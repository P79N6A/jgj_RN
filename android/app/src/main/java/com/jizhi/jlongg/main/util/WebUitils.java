package com.jizhi.jlongg.main.util;

import android.annotation.SuppressLint;
import android.content.Context;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebSettings;

import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.main.bean.UpImg;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.WebViewBrage;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * webViewUtils
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-24 下午2:28:31
 */
public class WebUitils {
    public BridgeWebView webView;

    public WebUitils(BridgeWebView webView) {
        this.webView = webView;
    }

    /**
     * 初始化webview
     */
    @SuppressLint("SetJavaScriptEnabled")
    public void initWebView() {
        WebSettings webSettings = webView.getSettings();
        // 执行Javascript脚本
        webSettings.setJavaScriptEnabled(true);
        webSettings.setUseWideViewPort(true); //自适应屏幕
        webSettings.setSupportZoom(true); //自适应屏幕
        // 设置可以访问文件
        webSettings.setAllowFileAccess(true);
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        // 设置支持缩放
        webSettings.setBuiltInZoomControls(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);// 排版适应屏幕
        webSettings.setLoadWithOverviewMode(true);
        // 支持多种分辨率，需要js网页支持
        String ua = webSettings.getUserAgentString();
        webSettings.setUserAgentString(ua + ";manage;ver=" + AppUtils.getVersionName(webView.getContext()) + ";");
        webSettings.setDefaultTextEncodingName("utf-8");

    }

    public void synCookies(Context context, String url) {
        CookieSyncManager.createInstance(context);
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        CookieSyncManager.getInstance().startSync();
        cookieManager.removeAllCookie();
        cookieManager.removeSessionCookie();
        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
        LUtils.e(stoken);
        cookieManager.setCookie(url, "Authorization=" + stoken.replace(" ", "+"));
        LUtils.e(cookieManager.getCookie(url));
        CookieSyncManager.getInstance().sync();
    }

    // clear the cache before time numDays
    public static int clearCacheFolder(File dir, long numDays) {
        int deletedFiles = 0;
        if (dir != null && dir.isDirectory()) {
            try {
                for (File child : dir.listFiles()) {
                    if (child.isDirectory()) {
                        deletedFiles += clearCacheFolder(child, numDays);
                    }
                    if (child.lastModified() < numDays) {
                        if (child.delete()) {
                            deletedFiles++;
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return deletedFiles;
    }

    public static void uploadPic(List<String> mSelected, Context context, final WebViewBrage webViewBrage) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        ImageUtil.compressImageSetParams(params, mSelected, context);
        params.addBodyParameter("os", "A");
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBack() {
            @Override
            public void onLoading(long total, long current, boolean isUploading) {
                super.onLoading(total, current, isUploading);
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    JSONObject jsonObject = new JSONObject((String) responseInfo.result);
                    int state = jsonObject.getInt("state");
                    if (state != 0) {
                        JSONArray jSONArray = jsonObject.getJSONArray("values");
                        List<String> list = new ArrayList<String>();
                        for (int i = jSONArray.length() - 1; i >= 0; i--) {
                            list.add(jSONArray.get(i).toString());
                        }
                        UpImg img = new UpImg();
                        img.setState(1);
                        img.setImgdata(list);
                        String imgStr = new Gson().toJson(img);
                        LUtils.e("-----------------------:" + imgStr);
                        webViewBrage.getmFunction().onCallBack(imgStr);
                        ImageLoader.getInstance().clearDiskCache();
                        ImageLoader.getInstance().clearMemoryCache();
                    } else {
                        upImgFail(webViewBrage);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    upImgFail(webViewBrage);
                } finally {
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                upImgFail(webViewBrage);
            }
        });
    }


    public static void upImgFail(WebViewBrage webViewBrage) {
        UpImg img = new UpImg();
        img.setState(0);
        String imgStr = new Gson().toJson(img);
        LUtils.e("-----------------------:" + imgStr);
        webViewBrage.getmFunction().onCallBack(imgStr);
    }
}
