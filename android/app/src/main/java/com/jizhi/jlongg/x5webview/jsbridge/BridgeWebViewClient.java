package com.jizhi.jlongg.x5webview.jsbridge;

import android.graphics.Bitmap;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.tencent.smtt.export.external.interfaces.SslError;
import com.tencent.smtt.export.external.interfaces.SslErrorHandler;
import com.tencent.smtt.sdk.WebView;
import com.tencent.smtt.sdk.WebViewClient;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

/**
 * Created by bruce on 10/28/15.
 */
public class BridgeWebViewClient extends WebViewClient {
    private BridgeX5WebView webView;

    public BridgeWebViewClient(BridgeX5WebView webView) {
        this.webView = webView;
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        try {
            url = URLDecoder.decode(url, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        if (url.startsWith(BridgeUtil.YY_RETURN_DATA)) {
            webView.handlerReturnData(url);
            return true;
        } else if (url.startsWith(BridgeUtil.YY_OVERRIDE_SCHEMA)) { //
            webView.flushMessageQueue();
            return true;
        } else {
            return super.shouldOverrideUrlLoading(view, url);
        }
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);
    }
    @Override
    public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
        // *** NEVER DO THIS!!! ***
        // super.onReceivedSslError(view, handler, error);

        // let's ignore ssl error
        LUtils.e("---------------onReceivedSslError-----------------");
        handler.proceed();
    }
    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        if (BridgeX5WebView.toLoadJs != null) {
            BridgeUtil.webViewLoadLocalJs(view, BridgeX5WebView.toLoadJs);
        }
        if (webView.getStartupMessage() != null) {
            for (Message m : webView.getStartupMessage()) {
                webView.dispatchMessage(m);
            }
            webView.setStartupMessage(null);
        }
        webView.callHandler("loginInfo", UclientApplication.loginInfo(), new CallBackFunction() {

            @Override
            public void onCallBack(String data) {
                if (null != data) {
                    LUtils.e("--------loginInfocallHandler------------" + data);
                }
            }

        });


    }

    @Override
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
        super.onReceivedError(view, errorCode, description, failingUrl);
    }
}