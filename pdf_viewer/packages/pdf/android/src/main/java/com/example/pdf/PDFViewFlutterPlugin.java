package com.example.pdf;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class PDFViewFlutterPlugin implements FlutterPlugin {
    /**
     * Plugin registration.
     */
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        binding
                .getPlatformViewRegistry()
                .registerViewFactory("com.example.pdf/pdfview", new PDFViewFactory());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
