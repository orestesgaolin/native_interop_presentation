package com.example.pdf;

import androidx.annotation.Keep;

@Keep
public class PDFViewController {
    public void setPage(int page){
        if (FlutterPDFView.pdfView == null){
            return;
        }

        FlutterPDFView.pdfView.jumpTo(page);
    }

    public int getPageCount(){
        if (FlutterPDFView.pdfView == null){
            return 0;
        }
        return FlutterPDFView.pdfView.getPageCount();
    }

    public int getCurrentPage(){
        if (FlutterPDFView.pdfView == null){
            return 0;
        }
        return FlutterPDFView.pdfView.getCurrentPage();
    }

    public void enableSwipe(boolean enable){
        if (FlutterPDFView.pdfView == null){
            return;
        }
        FlutterPDFView.pdfView.setSwipeEnabled(enable);
    }

    public void nightMode(boolean nightMode){
        if (FlutterPDFView.pdfView == null){
            return;
        }
        FlutterPDFView.pdfView.setNightMode(nightMode);
    }

    public void setPageFling(boolean pageFling){
        if (FlutterPDFView.pdfView == null){
            return;
        }
        FlutterPDFView.pdfView.setPageFling(pageFling);
    }

    public void setPageSnap(boolean pageSnap){
        if (FlutterPDFView.pdfView == null){
            return;
        }
        FlutterPDFView.pdfView.setPageSnap(pageSnap);
    }

    public void setPdfStatusListener(PDFStatusListener listener){
        FlutterPDFView.setPDFStatusListener(listener);
    }
}
