package com.example.pdf;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.net.Uri;

import io.flutter.plugin.platform.PlatformView;

import java.io.File;
import java.util.Map;

import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.PDFView.Configurator;
import com.github.barteksc.pdfviewer.listener.*;
import com.github.barteksc.pdfviewer.util.FitPolicy;

import com.github.barteksc.pdfviewer.link.LinkHandler;

public class FlutterPDFView implements PlatformView {
    private final LinkHandler linkHandler;

    public static PDFView pdfView;
    public static PDFStatusListener PDFStatusListener;

    public static void setPDFStatusListener(PDFStatusListener listener) {
        PDFStatusListener = listener;
    }

    @SuppressWarnings("unchecked")
    FlutterPDFView(Context context, int id, Map<String, Object> params) {
        Log.i("FlutterPDFView", "creating PDFView");

        pdfView = new PDFView(context, null);

        final boolean preventLinkNavigation = getBoolean(params, "preventLinkNavigation");

        linkHandler = new com.example.pdf.PDFLinkHandler(context, pdfView, preventLinkNavigation);

        Configurator config = null;
        if (params.get("filePath") != null) {
          String filePath = (String) params.get("filePath");
          config = pdfView.fromUri(getURI(filePath));
        }
        else if (params.get("pdfData") != null) {
          byte[] data = (byte[]) params.get("pdfData");
          config = pdfView.fromBytes(data);
        }

        if (config != null) {
            config
                    .enableSwipe(getBoolean(params, "enableSwipe"))
                    .swipeHorizontal(getBoolean(params, "swipeHorizontal"))
                    .password(getString(params, "password"))
                    .nightMode(getBoolean(params, "nightMode"))
                    .autoSpacing(getBoolean(params, "autoSpacing"))
                    .pageFling(getBoolean(params, "pageFling"))
                    .pageSnap(getBoolean(params, "pageSnap"))
                    .pageFitPolicy(getFitPolicy(params))
                    .enableAnnotationRendering(true)
                    .linkHandler(linkHandler).
                    enableAntialiasing(false)
                    .onPageChange(new OnPageChangeListener() {
                        @Override
                        public void onPageChanged(int page, int total) {
                            if (PDFStatusListener != null){
                                PDFStatusListener.onPageChanged(page,total);
                            }
                        }
                    }).onError(new OnErrorListener() {
                @Override
                public void onError(Throwable t) {
                    Log.e("FlutterPDFView", "error loading PDF", t);
                    if (PDFStatusListener != null){
                        PDFStatusListener.onError(t.getMessage());
                    }
                }
            }).onPageError(new OnPageErrorListener() {
                @Override
                public void onPageError(int page, Throwable t) {
                    Log.e("FlutterPDFView", "error loading PDF page " + page, t);
                    if (PDFStatusListener != null){
                        PDFStatusListener.onError(t.getMessage());
                    }
                }
            }).onRender(new OnRenderListener() {
                @Override
                public void onInitiallyRendered(int pages) {
                    Log.i("FlutterPDFView", "PDF rendered with " + pages + " pages");
                    if (PDFStatusListener != null) {
                        PDFStatusListener.onLoaded();
                    }
                }
            }).enableDoubletap(true).defaultPage(getInt(params, "defaultPage")).load();
        }
    }

    @Override
    public View getView() {
        return pdfView;
    }

    boolean getBoolean(Map<String, Object> params, String key) {
        return params.containsKey(key) ? (boolean) params.get(key) : false;
    }

    String getString(Map<String, Object> params, String key) {
        return params.containsKey(key) ? (String) params.get(key) : "";
    }

    int getInt(Map<String, Object> params, String key) {
        return params.containsKey(key) ? (int) params.get(key) : 0;
    }

    FitPolicy getFitPolicy(Map<String, Object> params) {
        String fitPolicy = getString(params, "fitPolicy");
        switch (fitPolicy) {
            case "FitPolicy.WIDTH":
                return FitPolicy.WIDTH;
            case "FitPolicy.HEIGHT":
                return FitPolicy.HEIGHT;
            case "FitPolicy.BOTH":
            default:
                return FitPolicy.BOTH;
        }
    }

    private Uri getURI(final String uri) {
        Uri parsed = Uri.parse(uri);

        if (parsed.getScheme() == null || parsed.getScheme().isEmpty()) {
            return Uri.fromFile(new File(uri));
        }
        return parsed;
    }

    @Override
    public void dispose() {
        if (PDFStatusListener != null){
            PDFStatusListener.onDisposed();
        }
        PDFStatusListener = null;
    }
}
