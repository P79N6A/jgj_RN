package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;

import com.google.gson.Gson;
import com.google.zxing.client.android.scanner.CaptureActivity;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.MD5;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BillsEntity;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.listener.MyWebViewDownLoadListener;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebUitils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.WebViewBrage;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeHandler;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能: 我的资料页面
 * 作者：huchangsheng
 * 时间: 2017-2-8 11:07
 */

public class X5WebViewActivity extends BaseActivity implements CustomShareDialog.ShareSuccess {
    private BridgeX5WebView webView;
    private X5WebViewActivity mActivity;
    private WebViewBrage webViewBrage;
    private CallBackFunction mFunction;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String url) {
        Intent intent = new Intent(context, X5WebViewActivity.class);
        intent.putExtra("url", url);
        context.startActivityForResult(intent, REQUEST);
    }

    public static void actionStart1(Activity context, String url) {
        Intent intent = new Intent(context, X5WebViewActivity.class);
        intent.putExtra("url", url);
        context.startActivity(intent);
    }

    public static void actionStart(Activity context, String url, boolean isShowTitle) {
        Intent intent = new Intent();
        intent.setClass(context, X5WebViewActivity.class);
        intent.putExtra("url", url);
        intent.putExtra("isShowTitle", isShowTitle);
        context.startActivityForResult(intent, Constance.INFOMATION);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        String url = getData();
        LUtils.e("url onNewIntent x5web   " + url);
        if (!intent.getBooleanExtra("isShowTitle", false)) {
            findViewById(R.id.head).setVisibility(View.GONE);
        } else {
            if (!url.contains(NetWorkRequest.WEB_DOMAIN) || url.contains(Constance.HEAD)) {
                findViewById(R.id.head).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.head).setVisibility(View.GONE);
            }
        }

        webView = findViewById(R.id.webView);
        mActivity = X5WebViewActivity.this;

        if (TextUtils.isEmpty(url)) {
            finish();
            return;
        }
        LUtils.e(url);
        if (url.contains(NetWorkRequest.NETURL) && url.contains("opdisplay=1")) {
            findViewById(R.id.head).setVisibility(View.VISIBLE);
        }
//        StatService.trackWebView(mActivity, webView, webView.chromeClient);

        String ua = webView.getSettings().getUserAgentString();
        webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(mActivity) + ";infover=" + DataUtil.getinfover(mActivity) + ";");
        webView.synCookies(mActivity, url);
        webView.setDownloadListener(new MyWebViewDownLoadListener(mActivity));
        String imageUrl = intent.getStringExtra("imageUrl");
       String defaultUrl= (String) SPUtils.get(this,Constance.COMPLETE_SCHEME,"",Constance.JLONGG);
        if (!TextUtils.isEmpty(imageUrl)) {
            fileUpData(imageUrl);
        } else {
            if (!defaultUrl.equals(url)) {
                webView.loadUrl(Utils.getUrl(url));

                LUtils.e(Utils.getUrl(url));
                SPUtils.remove(this, Constance.COMPLETE_SCHEME, Constance.JLONGG);
            }else {
                LUtils.e("url相同 x5web不做处理");
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        setContentView(R.layout.activity_x5webview);
        String url = getData();
        LUtils.e("--------------url-------------" + url);
        if (!getIntent().getBooleanExtra("isShowTitle", false)) {
            findViewById(R.id.head).setVisibility(View.GONE);
        } else {
            if (!url.contains(NetWorkRequest.WEB_DOMAIN) || url.contains(Constance.HEAD)) {
                findViewById(R.id.head).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.head).setVisibility(View.GONE);
            }
        }

        webView = findViewById(R.id.webView);
        mActivity = X5WebViewActivity.this;

        if (TextUtils.isEmpty(url)) {
            finish();
            return;
        }
        LUtils.e(url);
        if (url.contains(NetWorkRequest.NETURL) && url.contains("opdisplay=1")) {
            findViewById(R.id.head).setVisibility(View.VISIBLE);
        }
//        StatService.trackWebView(mActivity, webView, webView.chromeClient);

        String ua = webView.getSettings().getUserAgentString();
        webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(mActivity) + ";infover=" + DataUtil.getinfover(mActivity) + ";");
        webView.synCookies(mActivity, url);
        webView.setDownloadListener(new MyWebViewDownLoadListener(mActivity));
        String imageUrl = getIntent().getStringExtra("imageUrl");

        if (!TextUtils.isEmpty(imageUrl)) {
            fileUpData(imageUrl);
        } else {
            webView.loadUrl(Utils.getUrl(url));
            SPUtils.put(this,Constance.COMPLETE_SCHEME,url,Constance.JLONGG);

        }
        webViewBrage = new WebViewBrage(webView, mActivity, this);
        //会议调用原生扫描二维码
        webView.registerHandler("sweepCode", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                mFunction = function;
                CaptureActivity.actionStart(mActivity);
            }
        });
        findViewById(R.id.tv_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mActivity.finish();
            }
        });
        registerReceiver();


    }


    private String isBill, param, md5, sign;

    public String getData() {
        String url = "";
        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("url")) {
                    url = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("msg_type")) {
                    isBill = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("param")) {
                    param = bun.getString(key);
                    Gson gson = new Gson();
                    BillsEntity bean = gson.fromJson(param, BillsEntity.class);
                    bean.setUid(UclientApplication.getUid(X5WebViewActivity.this));
                    bean.setClient_type("person");
                    md5 = MD5.getMD5(DataUtil.getBillSignData(DataUtil.sigBillnMap(bean)));
                }

            }
        }
        if (!TextUtils.isEmpty(isBill) && isBill.equals("weekly_bills")) {
            url = url + "&uid=" + UclientApplication.getUid(X5WebViewActivity.this) + "&client_type=person&param=" + md5;
        }
        if (TextUtils.isEmpty(url)) {
            url = getIntent().getStringExtra("url");
        }
        return url;
    }

    @Override
    public void onResume() {
        super.onResume();
//        if (null != webView) {
//            webView.resumeTimers();
//        }
        webView.callHandler("loginInfo", DataUtil.getLoginInfo(mActivity,""), new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
            }

        });
    }

    @Override
    protected void onPause() {
//        if (null != webView) {
//            webView.pauseTimers();
//        }
        super.onPause();
    }

    @Override
    public void shareClickSuccess() {
        String str = new Gson().toJson(new LoginInf("1"));
        webView.callHandler("webLink", str, new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
                setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
            }

        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        setResult(Constance.INFOMATION, getIntent());
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onFinish(View view) {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            setResult(Constance.INFOMATION, getIntent());
            mActivity.finish();
        }
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_SUCCESS); //微信支付成功后的回调
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_FAIL); //微信支付失败后的回调
        receiver=new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                String action = intent.getAction();
                if (action.equals(Constance.ACTION_MESSAGE_WXPAY_SUCCESS)) { //微信支付成功
                    LUtils.e("微信支付回调成功");
                    WxPaySucces(1);
                } else if (action.equals(Constance.ACTION_MESSAGE_WXPAY_FAIL)) { //微信支付失败
                    LUtils.e("微信支付回调失败");
                    WxPaySucces(0);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 1成功 0失败
     *
     * @param state
     */
    public void WxPaySucces(int state) {
        if (null != webView && null != webViewBrage.getPayFunction()) {
            PayBean loginInf = new PayBean();
            loginInf.setState(state);
            loginInf.setPay_type(1);
            webViewBrage.getPayFunction().onCallBack(new Gson().toJson(loginInf));
            webViewBrage.setPayFunction(null);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        LUtils.e("----------选择相册回调--------");
        if (resultCode == Constance.CLICK_GROUP_CHAT) { //添加人员成功
            setResult(Constance.CLICK_GROUP_CHAT, data);
            finish();
            return;
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {//点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
            return;
        } else if (resultCode == Constance.OPEN_WECHAT_WERVICE) {//绑定微信成功
            if (null != webViewBrage.getBundWechatFuncion()) {
                webViewBrage.getBundWechatFuncion().onCallBack("");
                LUtils.e("------绑定微信成功-------44444--");
            }
            return;
        }

        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            upPic(mSelected);
            if (Build.VERSION.SDK_INT >= 21) {
                if (null == webView.getmUploadCallbackAboveL()) {
                    return;
                }
                //5.0以上版本处理
                if (null == mSelected || mSelected.size() == 0) {
                    webView.getmUploadCallbackAboveL().onReceiveValue(null);
                    return;
                }
                Uri uri = Uri.fromFile(new File(mSelected.get(0)));
                Uri[] uris = new Uri[]{uri};
                webView.getmUploadCallbackAboveL().onReceiveValue(uris);
            } else {//4.4以下处理
                if (null == webView.getmUploadMessage()) {
                    return;
                }
                if (null == mSelected || mSelected.size() == 0) {
                    webView.getmUploadMessage().onReceiveValue(null);
                    return;
                }
                Uri uri = Uri.fromFile(new File(mSelected.get(0)));
                webView.getmUploadMessage().onReceiveValue(uri);
            }
        } else if (requestCode == CameraPop.REQUEST_IMAGE_WEB && resultCode == RESULT_OK) {//选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            WebUitils.uploadPic(mSelected, mActivity, webViewBrage);
        } else if (requestCode == Constance.requestCode_msg && resultCode == Constance.FIND_WORKER_CALLBACK) {
            setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
            finish();
        } else if (resultCode == Constance.SCAN_MEETING_SUCCESS) { //扫描成功刷新当前界面
            Share share = new Share();
            String url = data.getStringExtra("url");
            share.setUrl(url);
            String str = new Gson().toJson(share);
            mFunction.onCallBack(str + "");
        } else if (resultCode == Constance.SEND_ADD_FRIEND_SUCCESS) {
            //发送添加好友后需要改变状态为已发送
            LUtils.e("------发送添加好友请求成功------1-5555--");

            if (null != webViewBrage.getSendAddFriendFuncion()) {
                webViewBrage.getSendAddFriendFuncion().onCallBack("");
                LUtils.e("------发送添加好友请求成功---2----5555--");
            }
        } else {
            if (Build.VERSION.SDK_INT >= 21) {
                //5.0以上版本处理
                if (null != webView.getmUploadCallbackAboveL()) {
                    webView.getmUploadCallbackAboveL().onReceiveValue(null);
                }
            } else {//4.4以下处理
                if (null != webView.getmUploadMessage()) {
                    webView.getmUploadMessage().onReceiveValue(null);
                }
            }
        }
    }

    public class LoginInf {

        String share;
        String path;

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public LoginInf(String share) {
            this.share = share;
        }

        public LoginInf() {
        }

        public String getShare() {
            return share;
        }

        public void setShare(String share) {
            this.share = share;
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        if (requestCode == Constance.REQUEST || requestCode == Constance.REQUEST_CAPTURE) {
            LUtils.e("--------11------");
            webViewBrage.showShareDialog(webView, requestCode == Constance.REQUEST ? true : false);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (webView != null) {
            webView.destroy();
        }
    }

    public void fileUpData(final String imageUrl) {
        createCustomDialog();
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
                List<String> localUploadList = new ArrayList<>();
                localUploadList.add(imageUrl);
                if (localUploadList.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, localUploadList, mActivity);
                    upLoadImage(params);
                }

            }
        });
    }

    /**
     * 上传图片
     */
    public void upLoadImage(RequestParams params) {
        String httpUrl = NetWorkRequest.UPLOAD_NEW;
        CommonHttpRequest.commonRequest(mActivity, httpUrl, String.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
//                commit((ArrayList<String>) object, commentName);
                List<String> localUploadList = (ArrayList<String>) object;
                if (null != localUploadList && localUploadList.size() > 0) {
                    webView.loadUrl(getData() + "?pic=" + localUploadList.get(0));
                    closeDialog();
                } else {
                    webView.loadUrl(getData());

                }


            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                webView.loadUrl(getData());
                closeDialog();
            }
        });
    }

    public void closeDialog() {
        if (null != customProgress && customProgress.isShowing()) {
            customProgress.closeDialog();
            customProgress = null;
        }
    }

    public CustomProgress customProgress;

    public void createCustomDialog() {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(mActivity);
            customProgress.show(mActivity, null, false);
        }
    }

}
