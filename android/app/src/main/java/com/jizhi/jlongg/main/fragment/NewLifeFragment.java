package com.jizhi.jlongg.main.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.WebUitils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.WebViewBrage;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;

import java.io.File;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static android.app.Activity.RESULT_OK;


/**
 * 发现(新生活)
 *
 * @author hcs
 * @version 2.0.0
 * @time 2016年8月17日 15:32
 */
@SuppressLint("ValidFragment")
public class NewLifeFragment extends BaseFragment implements CustomShareDialog.ShareSuccess {

    private BridgeX5WebView webView;

    public BridgeX5WebView getWebView() {
        return webView;
    }

    private WebViewBrage webViewBrage;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.activity_x5webview, container, false);
    }


    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        getView().findViewById(R.id.head).setVisibility(View.GONE);
        webView = getView().findViewById(R.id.webView);
        String url = getHuangliData();
        // 修改ua使得web端正确判断
        String ua = webView.getSettings().getUserAgentString();
        webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(getActivity()) + ";infover=" + DataUtil.getinfover(getActivity()) + ";");
        webView.synCookies(getActivity(), url);
        webView.loadUrl(Utils.getUrl(url));
//        webView.loadUrl("file:///android_asset/demo.html");

        webViewBrage = new WebViewBrage(webView, getActivity(), this);

//        loginInfo();
    }

    @Override
    public void initFragmentData() {
        loginInfo();

    }

    /**
     * 绑定微信成功
     */
    public void bindWechatSuccess() {
        if (null != webViewBrage.getBundWechatFuncion()) {
            webViewBrage.getBundWechatFuncion().onCallBack("");
            LUtils.e("------绑定微信成功-------44444--");
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

    /**
     * 发送添加好友请求成功
     */
    public void addFriendSuccess() {
        if (null != webViewBrage.getSendAddFriendFuncion()) {
            webViewBrage.getSendAddFriendFuncion().onCallBack("");
            LUtils.e("------发送添加好友请求成功-------44444--");
        }

    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            LUtils.e("----------------" + Build.VERSION.SDK_INT);
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
                LUtils.e("----------------" + new Gson().toJson(uri));
            } else {//4.4以下处理
                if (null == webView.getmUploadMessage()) {
                    return;
                }
                if (null == mSelected || mSelected.size() == 0) {
                    webView.getmUploadMessage().onReceiveValue(null);
                    return;
                }
                Uri uri = Uri.fromFile(new File(mSelected.get(0)));
                if (null != webView.getmUploadMessage()) {
                    webView.getmUploadMessage().onReceiveValue(uri);
                }

            }
            if (null == webView.getX5WebViewExtension()) {
                LUtils.e("------X5内核启动失败----------");
            }
        } else if (requestCode == CameraPop.REQUEST_IMAGE_WEB && resultCode == RESULT_OK) {//选择相册回调
            LUtils.e("----------选择相册回调upimg--------");
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            WebUitils.uploadPic(mSelected, getContext(), webViewBrage);
        } else {
            try {
                if (null != webView) {
                    if (Build.VERSION.SDK_INT >= 21) {
                        if (null != webView.getmUploadCallbackAboveL()) {
                            //5.0以上版本处理
                            webView.getmUploadCallbackAboveL().onReceiveValue(null);
                        }
                    } else {//4.4以下处理
                        if (null != webView.getmUploadMessage()) {
                            webView.getmUploadMessage().onReceiveValue(null);
                        }
                    }
                }
            } catch (Exception e) {
            }
        }
    }

    public void loginInfo() {
        LUtils.e("----444--newlife---11-----");

        if (null != webView) {
            webViewBrage.loginInfo(webView);

            LUtils.e("----444--newlife---222-----");
//            String info = DataUtil.getLoginInfo(UclientApplication.getInstance());
//            webView.loadUrl("javascript:GLOBAL.jsBridgeFn(" + info + ")");
//            LUtils.e("-------loginInfo-----newlife-------" + info);
//            webView.callHandler("loginInfo", info, new CallBackFunction() {
//
//                @Override
//                public void onCallBack(String data) {
//                    LUtils.e("-------loginInfo-----newlife-------" + data);
//
//                }
//
//            });
//            webViewBrage.loginInfo(webView);
        }
    }


    /**
     * 网络状态
     */
    public void NetWorkState(String state) {
        if (null == webView) {
            return;
        }
        LoginInfo loginInfo = new LoginInfo();
        loginInfo.setNetwork(state);
        String str = new Gson().toJson(loginInfo);
        LUtils.e("----------:" + str);
        webView.callHandler("networkState", str, new CallBackFunction() {

            @Override
            public void onCallBack(String data) {
                if (null != data) {
                    LUtils.e("--------networkState------------");
                }
            }

        });
    }

    public void webFlush() {
        if (null != webView) {
            LUtils.e("------webFlush----11------");
            webView.loadUrl(Utils.getUrl(getHuangliData()));
        }
    }

    @Override
    public void shareClickSuccess() {
        String str = new Gson().toJson(new LoginInf("1"));
        webView.callHandler("webLink", str, new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
            }

        });
    }

    public void commonVideo(int id, String uid) {

        LoginInfo loginInfo = new LoginInfo();
        if (id != 0) {
            loginInfo.setId(id + "");
        }
        if (!TextUtils.isEmpty(uid)) {
            loginInfo.setUid(uid);
        }
        String str = new Gson().toJson(loginInfo);
        if (webViewBrage.getCommonFunction() != null) {
            webViewBrage.getCommonFunction().onCallBack(str);
            LUtils.e("--------commonVideo11---------------" + str);
        } else {
            LUtils.e("--------commonVideo22---------------" + str);
        }
    }

    public class LoginInfos {
    }

    public String getHuangliData() {

        return NetWorkRequest.NEWLIFE + "";
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

    /**
     * 分享
     */
    public void showShareDialog(boolean isHintSaveAlbim) {
        LUtils.e("开始分享");
        webViewBrage.showShareDialog(webView, isHintSaveAlbim);
    }
}
