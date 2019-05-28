//package com.jizhi.jlongg.main.activity;
//
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.ActivityInfo;
//import android.hardware.Sensor;
//import android.hardware.SensorEvent;
//import android.hardware.SensorEventListener;
//import android.os.Bundle;
//import android.view.KeyEvent;
//import android.view.View;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.hcs.uclient.utils.SPUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.db.BaseInfoService;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.MyFragmentJSObject;
//import com.jizhi.jlongg.main.util.MyWebViewClient;
//import com.jizhi.jlongg.main.util.WebUitils;
//import com.jizhi.jongg.widget.LJWebView;
//import com.lidroid.xutils.ViewUtils;
//import com.tencent.smtt.sdk.CookieManager;
//import com.tencent.smtt.sdk.CookieSyncManager;
//
///**
// * 功能: 我的资料页面
// * 作者：huchangsheng
// * 时间: 2016-3-15 11:51
// */
//public class VideoActivity extends BaseActivity implements MyWebViewClient.LoadEndingListener, SensorEventListener {
//    public LJWebView webView;
//    /**
//     * Object对象，用来跟JS网页绑定
//     */
//    private MyFragmentJSObject jsobject;
//    private BaseInfoService baseInfoService;
//    private RelativeLayout rea_webfail;
//    private VideoActivity mActivity;
//    private TextView tv_title;
//    private String headPath = "";
//    private RelativeLayout right_title;
//    private MyWebViewClient myWebViewClient;
////    private SensorManager sensorManager;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.layout_video);
//        ViewUtils.inject(this);//Xutil必须调用的一句话
//        initView();
//        String url = getIntent().getStringExtra("url");
//        if (url != null && !url.equals("")) {
//            WebUitils uitils = new WebUitils(webView);
//            uitils.initWebView();
//            synCookies(mActivity, url);
//            webView.loadUrl(url);
//            myWebViewClient = new MyWebViewClient(url, mActivity, rea_webfail, this);
//            webView.setWebViewClient(myWebViewClient);
//            webView.getmWebView().addJavascriptInterface(jsobject, "jsPhone");
//        } else {
//            mActivity.finish();
//        }
//    }
//
//
//    public void synCookies(Context context, String url) {
//        CookieSyncManager.createInstance(context);
//        CookieManager cookieManager = CookieManager.getInstance();
//        cookieManager.setAcceptCookie(true);
//        cookieManager.removeSessionCookie();// 移除
//        String stoken = (String) SPUtils.get(context, "TOKEN", "",
//                Constance.JLONGG);
//        cookieManager.setCookie(url, "Authorization=" + stoken);
//        CookieSyncManager.getInstance().sync();
//    }
//
//    private void initView() {
//        mActivity = VideoActivity.this;
//        webView = (LJWebView) findViewById(R.id.webview);
//
//        baseInfoService = BaseInfoService.getInstance(getApplicationContext());
//        jsobject = new MyFragmentJSObject(mActivity, webView.getmWebView(), baseInfoService);
//        jsobject.clearState();
//        rea_webfail = (RelativeLayout) findViewById(R.id.rea_webfail);
//        tv_title = (TextView) findViewById(R.id.tv_title);
//        String title = getIntent().getStringExtra("title");
//        tv_title.setVisibility(View.VISIBLE);
//        tv_title.setText(title);
//        right_title = (RelativeLayout) findViewById(R.id.right_title);
//        right_title.setVisibility(View.VISIBLE);
//    }
//
//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        baseInfoService.closeDB();
//    }
//
//
//    @Override
//    public void loadEnding(String url) {
//        jsobject.clearState();
//    }
//
//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (keyCode == KeyEvent.KEYCODE_BACK && webView.getmWebView().canGoBack()) {
//            webView.getmWebView().goBack();
//            return true;
//        }
//
//        return super.onKeyDown(keyCode, event);
//    }
//
//    public void onFinish(View view) {
//        if (webView.getmWebView().canGoBack()) { //工友 资讯 是否能回退上一个页面
//            webView.getmWebView().goBack(); //回退WebView
//        } else {
//            if (!headPath.equals("")) {
//                Intent intent = new Intent();
//                intent.putExtra("headpath", headPath);
//                setResult(0X11, getIntent());
//            }
////            webView=null;
//            mActivity.finish();
//        }
//    }
//
//    public void rightClick(View view) {
//        mActivity.finish();
//    }
//
//    @Override
//    protected void onPause() {
//        webView.getmWebView().reload();
//        super.onPause();
//    }
//
//    String TAG = "sumile";
//
//    @Override
//    public void onSensorChanged(SensorEvent event) {
//        final int sensorType = event.sensor.getType();
//        //values[0]:X轴，values[1]：Y轴，values[2]：Z轴
//        final float[] values = event.values;
//        float x = values[0];
//        float y = values[1];
//        float z = values[2];
//        x = Math.abs(x);
//        y = Math.abs(y);
//        z = Math.abs(z);
//        if ((x >= 6 && z <= 6) || (x >= 6 && y >= 6)) {
//            if (getRequestedOrientation() != ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE) {
//                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
//            }
//        } else if ((x <= 3 && z <= 6) || (z <= 6 && y <= 3)) {
//            if (getRequestedOrientation() != ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
//                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
//            }
//        }
//    }
//
//    @Override
//    public void onAccuracyChanged(Sensor sensor, int accuracy) {
//
//    }
//}
