package com.example.pdf;

import androidx.annotation.Keep;

@Keep
public interface PDFStatusListener {
    void onLoaded();
    void onPageChanged(int page, int total);
    void onError(String error);
    void onDisposed();
    void onLinkRequested(String uri);
}
