package com.jizhi.jongg.widget;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;

/**
 * 备注: 此LJWebView继承自Relativielayout,所以会导致丢失一个WebView的属性，如果大家
 * 在项目中需要用到，可是此类中加入，然后调用即可，可参考 public void setClickable(boolean value){
 * mWebView.setClickable(value); } 这个方法的定义和调用
 *
 * @author Administrator
 */
public class LJWebView extends RelativeLayout {

    public static int Circle = 0x01;
    public static int Horizontal = 0x02;

    private Context context;

    private BridgeWebView mWebView = null; //
    private ProgressBar progressBar = null; // 水平进度条
    private RelativeLayout progressBar_circle = null; // 包含圆形进度条的布局
    private int barHeight = 4; // 水平进度条的高
    private boolean isAdd = false; // 判断是否已经加入进度条
    private int progressStyle = Horizontal; // 进度条样式,Circle表示为圆形，Horizontal表示为水平
    private WebSettings settings;
    private TextView tv_title;
    private RelativeLayout layout_title;


    //定义变量
    /**
     * 视频
     */
    FrameLayout videowebview;
    private View xCustomView;
    private WebChromeClient.CustomViewCallback xCustomViewCallback;

    public LJWebView(Context context) {
        super(context);
        this.context = context;
        init();

    }

    public LJWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        init();
    }

    public LJWebView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.context = context;
        init();
    }


    //    public TextView getTv_title() {
//        return tv_title;
//    }
//
    public void setTv_title(TextView tv_title) {
        this.tv_title = tv_title;
    }

    public RelativeLayout getLayout_title() {
        return layout_title;
    }

    public void setLayout_title(RelativeLayout layout_title) {
        this.layout_title = layout_title;
    }

    private void init() {
        mWebView = new BridgeWebView(context);
        settings = mWebView.getSettings();
        this.addView(mWebView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        Bitmap xdefaltvideo;
        View xprogressvideo;
        mWebView.setWebChromeClient(new WebChromeClient() {

            //            //视频加载添加默认图标
//            public Bitmap getDefaultVideoPoster() {
//                Log.i(TAG, "here in on getDefaultVideoPoster");
//                if (xdefaltvideo == null) {
//                    xdefaltvideo = BitmapFactory.decodeResource(
//                            getResources(), R.drawable.videoicon);ntnt
//                }
//                return xdefaltvideo;
//            }
            //视频加载时进程loading
            @Override
            public View getVideoLoadingProgressView() {
//                Log.i(TAG, "here in on getVideoLoadingPregressView");
//                if (xprogressvideo == null) {
//                    xprogressvideo = inflater.inflate(R.layout.video_loading_progress, null);
//                }
                return null;
            }

            // 通知应用程序当前网页加载的进度
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
//                System.out.println( "2222:" + view.getUrl());
                if (newProgress == 100) {
                    if (progressStyle == Horizontal) {
                        progressBar.setVisibility(View.GONE);
                    } else {
                        progressBar_circle.setVisibility(View.GONE);
                    }
                } else {
                    if (!isAdd) {
                        if (progressStyle == Horizontal) {
                            progressBar = (ProgressBar) LayoutInflater.from(
                                    context).inflate(
                                    R.layout.progress_horizontal, null);
                            progressBar.setMax(100);
                            progressBar.setProgress(0);
                            LJWebView.this.addView(progressBar,
                                    LayoutParams.MATCH_PARENT, barHeight);
                        } else {
                            progressBar_circle = (RelativeLayout) LayoutInflater.from(context).inflate(R.layout.progress_circle, null);
                            LJWebView.this.addView(progressBar_circle, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
                        }
                        isAdd = true;
                    }

                    if (progressStyle == Horizontal) {
                        progressBar.setVisibility(View.VISIBLE);
                        progressBar.setProgress(newProgress);
                    } else {
                        progressBar_circle.setVisibility(View.VISIBLE);
                    }
                }
            }

            // 当document 的title变化时，会通知应用程序
            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                if (null != tv_title) {
                    tv_title.setText(title);

                }
            }

            // 当前页面有个新的favicon时候，会回调这个函数。
            @Override
            public void onReceivedIcon(WebView view, Bitmap icon) {
                super.onReceivedIcon(view, icon);
                if (layout_title != null) {
                    if (view.getUrl().split("=")[0].equals(NetWorkRequest.NETURL + "web/html/make-friends/ph-person-detail.html?uid") || view.getUrl().equals(NetWorkRequest.NETURL + "web/html/make-friends/ph-person-detail.html")) {
                        layout_title.setVisibility(View.GONE);
                    } else {
                        layout_title.setVisibility(View.VISIBLE);
                    }
                }

                LUtils.e("onReceivedIcon---->" + view.getUrl());
            }

            // 通知应用程序 apple-touch-icon的 url
            // 参数说明：
            // @param view 接收WebViewClient的那个实例，前面看到webView.setWebViewClient(new
            // MyAndroidWebViewClient())，即是这个webview。
            // @param url apple-touch-icon 的服务端地址
            // @param precomposed 如果precomposed 是true 则touch-icon是预先创建的
            @Override
            public void onReceivedTouchIconUrl(WebView view, String url,
                                               boolean precomposed) {
                super.onReceivedTouchIconUrl(view, url, precomposed);
            }

            // 通知应用程序webview需要显示一个custom view，主要是用在视频全屏HTML5Video support。
            // 参数说明：
            // @param view 即将要显示的view
            // @param callback 当view 需要dismiss 则使用这个对象进行回调通知
            @Override
            public void onShowCustomView(View view, CustomViewCallback callback) {
                super.onShowCustomView(view, callback);
//                System.out.println(view.get);
            }

            // 退出视频通知
            @Override
            public void onHideCustomView() {
                super.onHideCustomView();
            }

            // webview请求得到focus，发生这个主要是当前webview不是前台状态，是后台webview。
            @Override
            public void onRequestFocus(WebView view) {
                super.onRequestFocus(view);
            }

//            //视频加载时进程loading
//            @Override
//            public View getVideoLoadingProgressView() {
//
//                return null;
//            }
        });
    }

//    //播放网络视频时全屏会被调用的方法
//    public void onShowCustomView(View view, WebChromeClient.CustomViewCallback callback) {
//        ((Activity) context).setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
//        mWebView.setVisibility(View.GONE);
//        //如果一个视图已经存在，那么立刻终止并新建一个
//        if (xCustomView != null) {
//            callback.onCustomViewHidden();
//            return;
//        }
//        mWebView.addView(view);
//        xCustomView = view;
//        xCustomViewCallback = callback;
//        mWebView.setVisibility(View.VISIBLE);
//    }
//
//    //视频播放退出全屏会被调用的
//    public void onHideCustomView() {
//        if (xCustomView == null)//不是全屏播放状态
//            return;
//        ((Activity) context).setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
//        xCustomView.setVisibility(View.GONE);
//        mWebView.removeView(xCustomView);
//        xCustomView = null;
//        mWebView.setVisibility(View.GONE);
//        xCustomViewCallback.onCustomViewHidden();
//        mWebView.setVisibility(View.VISIBLE);
//    }

    public BridgeWebView getmWebView() {
        return mWebView;
    }

    public void setmWebView(BridgeWebView mWebView) {
        this.mWebView = mWebView;
    }

    public WebSettings getSettings() {
        return settings;
    }

    public void setSettings(WebSettings settings) {
        this.settings = settings;
    }

    public void setBarHeight(int height) {
        barHeight = height;
    }

    public void setProgressStyle(int style) {
        progressStyle = style;
    }

    public void setClickable(boolean value) {
        mWebView.setClickable(value);
    }

    public void setUseWideViewPort(boolean value) {
        mWebView.getSettings().setUseWideViewPort(value);
    }

    public void setSupportZoom(boolean value) {
        mWebView.getSettings().setSupportZoom(value);
    }

    public void setBuiltInZoomControls(boolean value) {
        mWebView.getSettings().setBuiltInZoomControls(value);

    }

    public void setJavaScriptEnabled(boolean value) {
        mWebView.getSettings().setJavaScriptEnabled(value);
    }

    public void setCacheMode(int value) {
        mWebView.getSettings().setCacheMode(value);
    }

    public void setWebViewClient(WebViewClient value) {
        mWebView.setWebViewClient(value);
    }

    public void loadUrl(String url) {
//		synCookies(context,url);
        mWebView.loadUrl(url);
    }

    public void synCookies(Context context, String url) {
        CookieSyncManager.createInstance(context);
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        cookieManager.removeSessionCookie();// 移除
        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
        cookieManager.setCookie(url, "Authorization=" + stoken);
        CookieSyncManager.getInstance().sync();
    }
}
