//package com.jizhi.jongg.widget;
//
//import android.content.Context;
//import android.graphics.Bitmap;
//import android.net.Uri;
//import android.util.AttributeSet;
//import android.view.LayoutInflater;
//import android.webkit.CookieManager;
//import android.webkit.CookieSyncManager;
//import android.webkit.ValueCallback;
//import android.webkit.WebView;
//import android.widget.ProgressBar;
//import android.widget.RelativeLayout;
//
//import com.github.lzyzsd.jsbridge.BridgeWebView;
//import com.github.lzyzsd.jsbridge.BridgeWebViewClient;
//import com.github.lzyzsd.jsbridge.DefaultHandler;
//import com.hcs.uclient.utils.SPUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.util.Constance;
//
///**
// * @author huChangSheng
// * @version 1.0
// * @time 2015-7-9 下午2:12:51
// */
//@SuppressWarnings("deprecation")
//public class ProgressWebView extends BridgeWebView {
//    /**
//     * 进度条
//     */
//    private ProgressBar mProgressBar;
//    private SetBridgeWebViewTitleLisntener SetBridgeWebViewTitleLisntener;
//    private ValueCallback<Uri> mFilePathCallback;
//    private ValueCallback<Uri[]> mFilePathCallbackArray;
//    public ProgressWebView(Context context, AttributeSet attrs) {
//        super(context, attrs);
//        mProgressBar = (ProgressBar) LayoutInflater.from(
//                    context).inflate(
//                    R.layout.progress_horizontal, null);
//        addView(mProgressBar, RelativeLayout.LayoutParams.MATCH_PARENT, 4);
//        setDefaultHandler(new DefaultHandler());
//        setWebChromeClient(new WebChromeClient());
//        setWebViewClient(new BridgeWebViewClient(this));
//
//    }
//
//
//    public class MyWebViewClient extends BridgeWebViewClient {
//        public MyWebViewClient(BridgeWebView webView) {
//            super(webView);
//        }
//
//
//        @Override
//        public boolean shouldOverrideUrlLoading(WebView view, String url) {
//            return super.shouldOverrideUrlLoading(view, url);
//        }
//
//        //
//        @Override
//        public void onPageStarted(WebView view, String url, Bitmap favicon) {
//            super.onPageStarted(view, url, favicon);
//
//        }
//
////        @Override
////        public void onPageFinished(WebView view, String url) {
////            super.onPageFinished(view, url);
////        }
////
////
////        @Override
////        public void onReceivedError(WebView view, int errorCode,
////                                    String description, String failingUrl) {
////            super.onReceivedError(view, errorCode, description, failingUrl);
////        }
////
////
////        // 通知应用程序内核即将加载url制定的资源，应用程序可以返回本地的资源提供给内核，若本地处理返回数据，内核不从网络上获取数据。
////        @SuppressLint("NewApi")
////        @Override
////        public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
////            return super.shouldInterceptRequest(view, url);
////        }
////
////        // 通知应用程序可以将当前的url存储在数据库中，意味着当前的访问url已经生效并被记录在内核当中。
////        // 这个函数在网页加载过程中只会被调用一次。注意网页前进后退并不会回调这个函数。
////        // @ param isReload 如果是true 这个是正在被reload的url
////        @Override
////        public void doUpdateVisitedHistory(WebView view, String url,
////                                           boolean isReload) {
////            super.doUpdateVisitedHistory(view, url, isReload);
////        }
////
////        // 提供应用程序同步一个处理按键事件的机会，菜单快捷键需要被过滤掉。如果返回true，webview不处理该事件，如果返回false，
////        // webview会一直处理这个事件，因此在view 链上没有一个父类可以响应到这个事件。默认行为是return false
////        // @param event 键盘事件名
////        // @return 如果返回true,应用程序处理该时间，返回false 交有webview处理。
////        @Override
////        public boolean shouldOverrideKeyEvent(WebView view, KeyEvent event) {
////            return super.shouldOverrideKeyEvent(view, event);
////        }
////
////        // 通知应用程序webview 要被scale。应用程序可以处理改事件，比如调整适配屏幕。
////        @Override
////        public void onScaleChanged(WebView view, float oldScale, float newScale) {
////            super.onScaleChanged(view, oldScale, newScale);
////        }
//    }
//
//    public void setListener(SetBridgeWebViewTitleLisntener SetBridgeWebViewTitleLisntener) {
//        this.SetBridgeWebViewTitleLisntener = SetBridgeWebViewTitleLisntener;
//    }
//
//    public class WebChromeClient extends android.webkit.WebChromeClient {
//        @Override
//        public void onProgressChanged(WebView view, int newProgress) {
//            if (newProgress == 100) {
//                mProgressBar.setVisibility(GONE);
//            } else {
//                if (mProgressBar.getVisibility() == GONE)
//                    mProgressBar.setVisibility(VISIBLE);
//                mProgressBar.setProgress(newProgress);
//            }
//            super.onProgressChanged(view, newProgress);
//        }
//
//
//        // 当document 的title变化时，会通知应用程序
//        @Override
//        public void onReceivedTitle(WebView view, String title) {
//            super.onReceivedTitle(view, title);
//
//            if (null != SetBridgeWebViewTitleLisntener) {
//                SetBridgeWebViewTitleLisntener.setTitle(title);
//
//            }
//        }
//
//        // 当前页面有个新的favicon时候，会回调这个函数。
//        @Override
//        public void onReceivedIcon(WebView view, Bitmap icon) {
//            super.onReceivedIcon(view, icon);
//        }
//        // file upload callback (Android 2.2 (API level 8) -- Android 2.3 (API level 10)) (hidden method)
//        public void openFileChooser(ValueCallback<Uri> filePathCallback) {
//            handle(filePathCallback);
//        }
//
//        // file upload callback (Android 3.0 (API level 11) -- Android 4.0 (API level 15)) (hidden method)
//        public void openFileChooser(ValueCallback filePathCallback, String acceptType) {
//            handle(filePathCallback);
//        }
//
//        // file upload callback (Android 4.1 (API level 16) -- Android 4.3 (API level 18)) (hidden method)
//        public void openFileChooser(ValueCallback<Uri> filePathCallback, String acceptType, String capture) {
//            handle(filePathCallback);
//        }
//
//        // for Lollipop
//        @Override
//        public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
//            // Double check that we don't have any existing callbacks
//            if (mFilePathCallbackArray != null) {
//                mFilePathCallbackArray.onReceiveValue(null);
//            }
//            mFilePathCallbackArray = filePathCallback;
////            showDialog();
//            return true;
//        }
//
//        /**
//         * 处理5.0以下系统回调
//         * @param filePathCallback
//         */
//        private void handle(ValueCallback<Uri> filePathCallback) {
//            if (filePathCallback != null) {
//                mFilePathCallback.onReceiveValue(null);
//            }
//            mFilePathCallback = filePathCallback;
////            showDialog();
//        }
//    }
//
//    @Override
//    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
//        LayoutParams lp = (LayoutParams) mProgressBar.getLayoutParams();
//        lp.x = l;
//        lp.y = t;
//        mProgressBar.setLayoutParams(lp);
//        super.onScrollChanged(l, t, oldl, oldt);
//    }
//
//
//    public interface SetBridgeWebViewTitleLisntener {
//        void setTitle(String title);
//    }
//
//    public void synCookies(Context context, String url) {
//        CookieSyncManager.createInstance(context);
//        CookieManager cookieManager = CookieManager.getInstance();
//        cookieManager.setAcceptCookie(true);
//        CookieSyncManager.getInstance().startSync();
//        cookieManager.removeAllCookie();
//        cookieManager.removeSessionCookie();
//        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
//        cookieManager.setCookie(url, "Authorization=" + stoken.replace(" ", "-"));
////        webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(getActivity()) + ";");
//        CookieSyncManager.getInstance().sync();
//    }
//}