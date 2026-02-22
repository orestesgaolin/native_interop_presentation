package com.example.foreground_service_interop_plugin

import android.Manifest
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Binder
import android.os.IBinder
import androidx.annotation.Keep
import androidx.core.app.NotificationCompat
import androidx.core.app.RemoteInput
import androidx.core.content.ContextCompat

class ExampleForegroundService : Service() {
    private val binder = LocalBinder()
    private var lastMessage: String = "Waiting for messages..."
    private lateinit var replyListener: ReplyListenerProxy.OnReplyListener

    inner class LocalBinder : Binder() {
        fun getService(): ExampleForegroundService = this@ExampleForegroundService
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForegroundIfNeeded()
    }

    override fun onBind(intent: Intent): IBinder {
        startForegroundIfNeeded()
        return binder
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundIfNeeded()
        when (intent?.action) {
            ACTION_POST_MESSAGE -> {
                val message = intent.getStringExtra(EXTRA_MESSAGE).orEmpty()
                if (message.isNotBlank()) {
                    receiveMessage(message)
                }
            }
            ACTION_HANDLE_REPLY -> {
                val reply = intent.getStringExtra(EXTRA_REPLY_TEXT).orEmpty()
                if (reply.isNotBlank()) {
                    handleReply(reply)
                }
            }
        }
        return START_STICKY
    }

    @Keep
    fun receiveMessage(message: String) {
        lastMessage = message
        updateNotification(title = "Message received", text = message)
    }

    fun setOnReplyListener(listener:  ReplyListenerProxy.OnReplyListener) {
        replyListener = listener
    }

    private fun handleReply(reply: String) {
        updateNotification(title = "Reply sent", text = reply)
        if (::replyListener.isInitialized) {
            replyListener.onReply(reply)
        }
    }

    private fun startForegroundIfNeeded() {
        if (!canPostNotifications()) {
            stopSelf()
            return
        }
        val notification = buildNotification(title = "Service running", text = lastMessage)
        startForeground(NOTIFICATION_ID, notification)
    }

    private fun canPostNotifications(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
        return checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
    }

    private fun updateNotification(title: String, text: String) {
        val notification = buildNotification(title, text)
        notificationManager().notify(NOTIFICATION_ID, notification)
    }

    private fun buildNotification(title: String, text: String): Notification {
        val replyIntent = Intent(this, NotificationReplyReceiver::class.java).apply {
            action = ACTION_REPLY
        }
        val replyPendingIntent = PendingIntent.getBroadcast(
            this,
            0,
            replyIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        val remoteInput = RemoteInput.Builder(KEY_TEXT_REPLY)
            .setLabel("Reply")
            .build()
        val replyAction = NotificationCompat.Action.Builder(
            android.R.drawable.ic_menu_send,
            "Reply",
            replyPendingIntent
        )
            .addRemoteInput(remoteInput)
            .setAllowGeneratedReplies(true)
            .build()

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_email)
            .setContentTitle(title)
            .setContentText(text)
            .setStyle(NotificationCompat.BigTextStyle().bigText(text))
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .addAction(replyAction)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Foreground Messages",
            NotificationManager.IMPORTANCE_DEFAULT
        )
        notificationManager().createNotificationChannel(channel)
    }

    private fun notificationManager(): NotificationManager {
        return getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    companion object {
        const val CHANNEL_ID = "foreground_service_messages"
        const val NOTIFICATION_ID = 1001
        const val ACTION_POST_MESSAGE = "com.example.foreground_service_interop_plugin.action.POST_MESSAGE"
        const val ACTION_HANDLE_REPLY = "com.example.foreground_service_interop_plugin.action.HANDLE_REPLY"
        const val ACTION_REPLY = "com.example.foreground_service_interop_plugin.action.REPLY"
        const val EXTRA_MESSAGE = "com.example.foreground_service_interop_plugin.extra.MESSAGE"
        const val EXTRA_REPLY_TEXT = "com.example.foreground_service_interop_plugin.extra.REPLY_TEXT"
        const val KEY_TEXT_REPLY = "key_text_reply"

        fun start(context: Context, message: String) {
            if (!canPostNotifications(context)) return
            val intent = Intent(context, ExampleForegroundService::class.java).apply {
                action = ACTION_POST_MESSAGE
                putExtra(EXTRA_MESSAGE, message)
            }
            ContextCompat.startForegroundService(context, intent)
        }

        fun enqueueReply(context: Context, replyText: String) {
            if (!canPostNotifications(context)) return
            val intent = Intent(context, ExampleForegroundService::class.java).apply {
                action = ACTION_HANDLE_REPLY
                putExtra(EXTRA_REPLY_TEXT, replyText)
            }
            ContextCompat.startForegroundService(context, intent)
        }

        private fun canPostNotifications(context: Context): Boolean {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
            return ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        }
    }
}

@Keep
class ReplyListenerProxy {
    public interface OnReplyListener {
        fun onReply(replyText: String)
    }
}
