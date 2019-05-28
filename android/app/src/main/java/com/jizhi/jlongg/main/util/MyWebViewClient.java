package com.jizhi.jlongg.main.util;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;

/**
 * 网页加载各个阶段的通知
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-24 下午2:13:40
 */
public class MyWebViewClient extends WebViewClient {
    private String currentUrl;
    private Context context;
    private RelativeLayout rea_webfail;
    public LoadEndingListener loadEndingListener;
    private TextView tv_title;
    public TextView getTv_title() {
        return tv_title;
    }

    public void setTv_title(TextView tv_title) {
        this.tv_title = tv_title;
    }
    public interface LoadEndingListener {
        public void loadEnding(String url);
    }

    public MyWebViewClient(String currentUrl,
                           Context context, RelativeLayout rea_webfail,LoadEndingListener loadEndingListener) {
        this.currentUrl = currentUrl;
        this.context = context;
        this.rea_webfail = rea_webfail;
        this.loadEndingListener=loadEndingListener;
    }

    // 返回时候不会调用 当加载的网页需要重定向的时候就会回调这个函数告知我们应用程序是否需要接管控制网页加载，如果应用程序接管，并且return
    // true意味着主程序接管网页加载，如果返回false让webview自己处理。
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        view.loadUrl(url);
        return true;
    }

    // 通知应用程序WebView即将加载url 制定的资源
    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);

        if(null!=rea_webfail){
            rea_webfail.setVisibility(View.GONE);
        }

    }

    // 可以自定义网页的错误页面。
    // @param dontResent 当浏览器不需要重新发送数据时，可以使用这个参数。
    // @param resent 当浏览器需要重新发送数据时， 可以使用这个参数。
    @Override
    public void onReceivedError(WebView view, int errorCode,
                                String description, String failingUrl) {
        super.onReceivedError(view, errorCode, description, failingUrl);
        if(null!=rea_webfail){
            rea_webfail.setVisibility(View.VISIBLE);
        }
    }

    // 当内核加载完当前页面时会通知我们的应用程序，这个函数只有在main
    // frame情况下才会被调用，当调用这个函数之后，渲染的图片不会被更新，如果需要获得新图片的通知可以使用@link
    // WebView.PictureListener#onNewPicture。
    @Override
    public void onPageFinished(WebView view, String url) {
        if (null != tv_title) {
            tv_title.setText(view.getTitle());
        }
        super.onPageFinished(view, url);
    }

    // 通知应用程序内核即将加载url制定的资源，应用程序可以返回本地的资源提供给内核，若本地处理返回数据，内核不从网络上获取数据。
    @SuppressLint("NewApi")
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        return super.shouldInterceptRequest(view, url);
    }

    // 通知应用程序可以将当前的url存储在数据库中，意味着当前的访问url已经生效并被记录在内核当中。
    // 这个函数在网页加载过程中只会被调用一次。注意网页前进后退并不会回调这个函数。
    // @ param isReload 如果是true 这个是正在被reload的url
    @Override
    public void doUpdateVisitedHistory(WebView view, String url,
                                       boolean isReload) {
        super.doUpdateVisitedHistory(view, url, isReload);
    }

    // 提供应用程序同步一个处理按键事件的机会，菜单快捷键需要被过滤掉。如果返回true，webview不处理该事件，如果返回false，
    // webview会一直处理这个事件，因此在view 链上没有一个父类可以响应到这个事件。默认行为是return false
    // @param event 键盘事件名
    // @return 如果返回true,应用程序处理该时间，返回false 交有webview处理。
    @Override
    public boolean shouldOverrideKeyEvent(WebView view, KeyEvent event) {
        return super.shouldOverrideKeyEvent(view, event);
    }

    // 通知应用程序webview 要被scale。应用程序可以处理改事件，比如调整适配屏幕。
    @Override
    public void onScaleChanged(WebView view, float oldScale, float newScale) {
        super.onScaleChanged(view, oldScale, newScale);
    }

}
