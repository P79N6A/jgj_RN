package com.jizhi.jlongg.main.activity;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.github.lzyzsd.jsbridge.BridgeHandler;
import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DownPic;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.ShareBill;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.util.Constance;
import com.readystatesoftware.systembartint.SystemBarTintManager;

/**
 * 功能: 下载账单
 * 作者：huchangsheng
 * 时间: 2016-3-15 11:51
 */
public class DownLoadBillActivity extends AppCompatActivity implements CustomShareDialog.SavaPictureListener {
    private DownLoadBillActivity mActivity;
    private BridgeWebView webView;
    private CustomShareDialog shareDialog;
    private String year, month;

    private LinearLayout rootView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_jsbrage);
        ((TextView) findViewById(R.id.title)).setText(R.string.downloadbill);
        webView = (BridgeWebView) findViewById(R.id.webView);
        rootView = (LinearLayout) findViewById(R.id.rootView);
        initView();
        String url = getIntent().getStringExtra(Constance.BEAN_STRING); //URL
        year = getIntent().getStringExtra("year");
        month = getIntent().getStringExtra("month");
        if (TextUtils.isEmpty(url)) {
            finish();
        } else {
//            url = NetWorkRequest.BILL + "?" + url;
            String ua = webView.getSettings().getUserAgentString();
            webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(mActivity) + ";");
            synCookies(mActivity, url);
            webView.loadUrl(url);
            LUtils.e("url:" + url);
        }
        //web调用native
        webView.registerHandler("showShareMenu", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Gson gson = new Gson();
                ShareBill shareBill = gson.fromJson(data, ShareBill.class);
                Share share = new Share();
                share.setUrl(shareBill.getUrl());
                share.setDescribe(shareBill.getDescribe());
                share.setTitle("账单分享");
//                if (shareDialog == null) {
//                    shareDialog = new CustomShareDialog(DownLoadBillActivity.this, false, share, DownLoadBillActivity.this);
//                    shareDialog.setOnDismissListener(new PopupWindow.OnDismissListener() {
//                        @Override
//                        public void onDismiss() {
//                            BackGroundUtil.backgroundAlpha(DownLoadBillActivity.this, 1.0F);
//                        }
//                    });
//                }
                //显示窗口
//                shareDialog.showAtLocation(rootView, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//                BackGroundUtil.backgroundAlpha(DownLoadBillActivity.this, 0.5F);
            }
        });
    }


    public void synCookies(Context context, String url) {
        CookieSyncManager.createInstance(context);
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        cookieManager.removeSessionCookie();// 移除
        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
        cookieManager.setCookie(url, "Authorization=" + stoken.replace(" ", "-"));
        CookieSyncManager.getInstance().sync();
    }

    private void initView() {
        mActivity = DownLoadBillActivity.this;
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.black);

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            //表示按返回键
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                if (webView.canGoBack()) {
                    webView.goBack(); //回退WebView
                }
                mActivity.finish();
            }
        }
        return false;
    }

    public void onFinish(View view) {
        if (webView.canGoBack()) {
            webView.goBack();
        }
        mActivity.finish();

    }


    @Override
    public void savaPictureClick() {
        LUtils.e("-------111----savaPictureClick-------:" );
        webView.callHandler("saveToPicture", "data from Java", new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
                LUtils.e("-------data------------:" + data);
                final String url = data;
                String name;
                if (null != year && !year.equals("")) {
                    name = year + "年" + month + "月账单" + System.currentTimeMillis() + ".jpg";
                } else {
                    name = System.currentTimeMillis() + ".jpg";
                }
                DownPic DownPic = new DownPic(mActivity, name);
                DownPic.downLoadPic(url);
                if (shareDialog != null) {
                    shareDialog.dismiss();
                }
            }
        });
    }

}
