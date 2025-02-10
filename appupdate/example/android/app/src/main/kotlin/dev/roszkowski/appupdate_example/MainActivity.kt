package dev.roszkowski.appupdate_example

import android.content.Context
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.UpdateAvailability
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()


fun text(context: Context){
    val mg = AppUpdateManagerFactory.create(context);
    mg.appUpdateInfo.addOnSuccessListener {
        if (it.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE) {

        }
    }
}
