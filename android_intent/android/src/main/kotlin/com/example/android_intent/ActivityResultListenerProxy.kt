package com.example.android_intent

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.annotation.Keep
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.lang.ref.WeakReference

@Keep
class ActivityResultListenerProxy : FlutterPlugin, ActivityAware {
    private var activity: WeakReference<Activity>? = null;
    private var callback: OnResultListener? = null;

    companion object {
        @Volatile
        private var instance: ActivityResultListenerProxy? = null

        fun getInstance(): ActivityResultListenerProxy {
            return instance ?: synchronized(this) {
                instance ?: ActivityResultListenerProxy().also { instance = it }
            }
        }
    }

    @Keep
    public fun setOnResultListener(listener: OnResultListener) {
        callback = listener
    }

    public interface OnResultListener {
        fun onResult(requestCode: Int, resultCode: Int, result: String?)
    }

    @Keep
    public fun onResult(requestCode: Int, resultCode: Int, intent: Intent?) : Boolean {
        if (intent != null) {
            val data = intent.getByteArrayExtra("data")
            Log.i("ARLP", "onResult called with requestCode: $requestCode, resultCode: $resultCode, data: ${data}")
            callback?.onResult(requestCode, resultCode, intent.dataString)
            return true
        } else {
            return false
        }
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i("ARLP", "onAttachedToEngine called")
        instance = this
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i("ARLP", "onDetachedFromEngine called")
        instance = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = WeakReference(binding.activity)
        binding.addActivityResultListener { res, req, intent ->
            Log.i("ARLP", "onAttachedToActivity called with intent: $intent")
            onResult(res, req, intent)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity?.clear()
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = WeakReference(binding.activity)
        binding.addActivityResultListener { res, req, intent ->
            Log.i("ARLP", "onReattachedToActivityForConfigChanges called with intent: $intent")
            onResult(res, req, intent)
        }
    }

    override fun onDetachedFromActivity() {
        activity?.clear()
        activity = null
    }
}