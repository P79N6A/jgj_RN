package com.jizhi.jlongg.main.activity.welcome;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.MyWebViewClient;
import com.jizhi.jlongg.main.util.WebUitils;
import com.jizhi.jlongg.network.NetWorkRequest;

/**
 * 功能:易找工协议
 * 时间:2016-3-30 16:10
 * 作者:hcs
 */
public class AgreementActivity extends BaseActivity implements
        MyWebViewClient.LoadEndingListener {
    public BridgeWebView webView;
    private RelativeLayout rea_webfail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_agreement);
        initView();
        WebUitils uitils = new WebUitils(webView);
        uitils.initWebView();
        webView.loadUrl(NetWorkRequest.AGREEMENT);
//        webView.setWebViewClient(new MyWebViewClient(NetWorkRequest.AGREEMENT, AgreementActivity.this, rea_webfail, this));

    }


    private void initView() {
        setTextTitle(R.string.agreenment);
        webView = (BridgeWebView) findViewById(R.id.webview);
        rea_webfail = (RelativeLayout) findViewById(R.id.rea_webfail);
        ImageView btn_refresh = (ImageView) findViewById(R.id.btn_refresh);
        btn_refresh.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.reload();
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)
                && webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        finish();
        return false;
    }


    @Override
    public void loadEnding(String url) {

    }
}
