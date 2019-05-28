//package com.jizhi.jongg.widget;
//
//import android.content.Context;
//import android.graphics.Bitmap;
//import android.util.AttributeSet;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.webkit.CookieManager;
//import android.webkit.CookieSyncManager;
//import android.webkit.WebChromeClient;
//import android.webkit.WebSettings;
//import android.webkit.WebView;
//import android.webkit.WebViewClient;
//import android.widget.ProgressBar;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.github.lzyzsd.jsbridge.BridgeWebView;
//import com.hcs.uclient.utils.LUtils;
//import com.hcs.uclient.utils.SPUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.util.Constance;
//
///**
// * 备注: 此LJWebView继承自Relativielayout,所以会导致丢失一个WebView的属性，如果大家
// * 在项目中需要用到，可是此类中加入，然后调用即可，可参考 public void setClickable(boolean value){
// * mWebView.setClickable(value); } 这个方法的定义和调用
// *
// * @author Administrator
// */
//public class NewsWebView extends RelativeLayout {
//
//    public static int Circle = 0x01;
//    public static int Horizontal = 0x02;
//
//    private Context context;
//
//    private BridgeWebView mWebView = null; //
//    private ProgressBar progressBar = null; // 水平进度条
//    private RelativeLayout progressBar_circle = null; // 包含圆形进度条的布局
//    private int barHeight = 4; // 水平进度条的高
//    private boolean isAdd = false; // 判断是否已经加入进度条
//    private int progressStyle = Horizontal; // 进度条样式,Circle表示为圆形，Horizontal表示为水平
//    private WebSettings settings;
//    private TextView tv_title;
//    private RelativeLayout layout_title;
//    private OnReceivedIconListener onReceivedIconListener;
//
//    public NewsWebView(Context context) {
//        super(context);
//        this.context = context;
//        init();
//
//    }
//
//    public NewsWebView(Context context, AttributeSet attrs) {
//        super(context, attrs);
//        this.context = context;
//        init();
//    }
//
//    public NewsWebView(Context context, AttributeSet attrs, int defStyle) {
//        super(context, attrs, defStyle);
//        this.context = context;
//        init();
//    }
//
//
//    public void setOnReceivedIconListener(OnReceivedIconListener onReceivedIconListener) {
//        this.onReceivedIconListener = onReceivedIconListener;
//    }
//
//    public void setTv_title(TextView tv_title) {
//        this.tv_title = tv_title;
//    }
//
//    public RelativeLayout getLayout_title() {
//        return layout_title;
//    }
//
//    public void setLayout_title(RelativeLayout layout_title) {
//        this.layout_title = layout_title;
//    }
//
//    private void init() {
//        mWebView = new BridgeWebView(context);
//        settings = mWebView.getSettings();
//        this.addView(mWebView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
//        mWebView.setWebChromeClient(new WebChromeClient() {
//
//
//            // 通知应用程序当前网页加载的进度
//            @Override
//            public void onProgressChanged(WebView view, int newProgress) {
//                super.onProgressChanged(view, newProgress);
//                if (newProgress == 100) {
//                    if (progressStyle == Horizontal) {
//                        progressBar.setVisibility(View.GONE);
//                    } else {
//                        progressBar_circle.setVisibility(View.GONE);
//                    }
//                } else {
//                    if (!isAdd) {
//                        if (progressStyle == Horizontal) {
//                            progressBar = (ProgressBar) LayoutInflater.from(
//                                    context).inflate(
//                                    R.layout.progress_horizontal, null);
//                            progressBar.setMax(100);
//                            progressBar.setProgress(0);
//                            NewsWebView.this.addView(progressBar,
//                                    LayoutParams.MATCH_PARENT, barHeight);
//                        } else {
//                            progressBar_circle = (RelativeLayout) LayoutInflater.from(context).inflate(R.layout.progress_circle, null);
//                            NewsWebView.this.addView(progressBar_circle, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
//                        }
//                        isAdd = true;
//                    }
//
//                    if (progressStyle == Horizontal) {
//                        progressBar.setVisibility(View.VISIBLE);
//                        progressBar.setProgress(newProgress);
//                    } else {
//                        progressBar_circle.setVisibility(View.VISIBLE);
//                    }
//                }
//            }
//
//            // 当document 的title变化时，会通知应用程序
//            @Override
//            public void onReceivedTitle(WebView view, String title) {
//                super.onReceivedTitle(view, title);
//                if (null != tv_title) {
//                    tv_title.setText(title);
//
//                }
//            }
//
//            // 当前页面有个新的favicon时候，会回调这个函数。
//            @Override
//            public void onReceivedIcon(WebView view, Bitmap icon) {
//                super.onReceivedIcon(view, icon);
//                onReceivedIconListener.onReceivedIconListener(view.getUrl());
//            }
//
//        });
//    }
//
//    public interface OnReceivedIconListener {
//        public void onReceivedIconListener(String url);
//    }
//
//    public WebView getmWebView() {
//        return mWebView;
//    }
//
//
//    public WebSettings getSettings() {
//        return settings;
//    }
//
//    public void setClickable(boolean value) {
//        mWebView.setClickable(value);
//    }
//
//    public void setWebViewClient(WebViewClient value) {
//        mWebView.setWebViewClient(value);
//    }
//
//    public void loadUrl(String url) {
//        mWebView.loadUrl(url);
//    }
//
//    public void synCookies(Context context, String url) {
//        CookieSyncManager.createInstance(context);
//        CookieManager cookieManager = CookieManager.getInstance();
//        cookieManager.setAcceptCookie(true);
//        cookieManager.removeSessionCookie();// 移除
//        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
//        cookieManager.setCookie(url, "Authorization=" + stoken);
//        CookieSyncManager.getInstance().sync();
//    }
//}
