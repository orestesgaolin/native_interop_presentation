package com.example.pdf;

import android.content.Context;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

public class PDFViewFactory extends PlatformViewFactory {

    public PDFViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new com.example.pdf.FlutterPDFView(context, id, params);
    }
}