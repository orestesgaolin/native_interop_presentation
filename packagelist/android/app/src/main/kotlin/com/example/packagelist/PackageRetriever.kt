package com.example.packagelist

import android.content.Context
import androidx.annotation.Keep
import androidx.core.graphics.drawable.toBitmap

@Keep
class PackageRetriever {
    fun getInstalledPackages(context: Context): List<String> {
        val pm = context.packageManager
        val packages = pm.getInstalledPackages(0)

        return packages.map { "${it.packageName}" }
    }

    fun getPackageDrawable(context: Context, packageName: String): ByteArray {
        val pm = context.packageManager
        val drawable = pm.getApplicationIcon(packageName)
        val bitmap = drawable.toBitmap()
        // get byte array from bitmap
        val byteArray = android.graphics.Bitmap.CompressFormat.PNG.run {
            val stream = java.io.ByteArrayOutputStream()
            bitmap.compress(this, 100, stream)
            stream.toByteArray()
        }
        return byteArray
    }
}
