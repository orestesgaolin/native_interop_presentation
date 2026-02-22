package com.example.foreground_service_interop_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.RemoteInput

class NotificationReplyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != ExampleForegroundService.ACTION_REPLY) return
        val input = RemoteInput.getResultsFromIntent(intent)
        val replyText = input?.getCharSequence(ExampleForegroundService.KEY_TEXT_REPLY)?.toString()
        if (!replyText.isNullOrBlank()) {
            ExampleForegroundService.enqueueReply(context, replyText)
        }
    }
}
