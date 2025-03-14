package dev.roszkowski.appupdate

import androidx.annotation.Keep
import com.google.android.play.core.install.InstallState
import com.google.android.play.core.install.InstallStateUpdatedListener

@Keep
class InstallStateUpdatedListenerProxy(val callback: InstallStateCallbackInterface) : InstallStateUpdatedListener {
    public interface InstallStateCallbackInterface {
        fun onStateUpdate(state: InstallState)
    }

    override fun onStateUpdate(state: InstallState) {
        callback.onStateUpdate(state)
    }
}