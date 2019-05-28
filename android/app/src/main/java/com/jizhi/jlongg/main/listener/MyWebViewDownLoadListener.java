package com.jizhi.jlongg.main.listener;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import com.tencent.smtt.sdk.DownloadListener;

/**
 * webview下载文件监听
 */

public class MyWebViewDownLoadListener implements DownloadListener {
    private Activity activity;

    public MyWebViewDownLoadListener(Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
        Uri uri = Uri.parse(url);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        activity.startActivity(intent);
    }
}
