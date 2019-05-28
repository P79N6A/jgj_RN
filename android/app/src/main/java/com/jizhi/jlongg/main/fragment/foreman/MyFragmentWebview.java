package com.jizhi.jlongg.main.fragment.foreman;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.fragment.BaseFragment;
import com.jizhi.jlongg.main.listener.MyWebViewDownLoadListener;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.WebUitils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.WebViewBrage;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.lidroid.xutils.ViewUtils;

import java.io.File;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static android.app.Activity.RESULT_OK;

/**
 * 找帮手
 */
public class MyFragmentWebview extends BaseFragment implements CustomShareDialog.ShareSuccess {

    private BridgeX5WebView webView;
    private WebViewBrage webViewBrage;

    public BridgeX5WebView getWebView() {
        return webView;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.activity_x5webview, container, false);
    }

    public String getUrl() {
        return NetWorkRequest.MY;
    }


    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        ViewUtils.inject(this, getView());
        getView().findViewById(R.id.head).setVisibility(View.GONE);
        initWebView();
    }

    public void initWebView() {
        webView = getView().findViewById(R.id.webView);
        String url = getUrl();
        // 修改ua使得web端正确判断
        String ua = webView.getSettings().getUserAgentString();
        String sagent = ua + ";person;ver=" + AppUtils.getVersionName(getActivity()) + ";infover=" + DataUtil.getinfover(getActivity());
        webView.getSettings().setUserAgentString(sagent);
        webView.synCookies(getActivity(), url);
        webView.loadUrl(Utils.getUrl(url));
        webView.setDownloadListener(new MyWebViewDownLoadListener(getActivity()));
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webViewBrage = new WebViewBrage(webView, getActivity(), this);

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
        } else {
        }
    }

    public void loginInfo() {
        if (null != webView) {
            webViewBrage.loginInfo(webView);
        }
    }


    /**
     * 网络状态
     */
    public void setNetWorkState(String state) {
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
            webView.loadUrl(Utils.getUrl(getUrl()));
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
    public void shareClickSuccess() {
        String str = new Gson().toJson(new LoginInf("1"));
        LUtils.e("-----分享成功--------------");
        webView.callHandler("webLink", str, new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
            }

        });
    }

    /**
     * 修改手机号成功
     */
    public void editMobileSuccess() {
        if (null != webViewBrage.getEditTelpHoneFuncion()) {
            webViewBrage.getEditTelpHoneFuncion().onCallBack("");
        }
        LUtils.e("------修改手机号码成功-------3333--");

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

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            LUtils.e("----------选择相册回调--------");
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
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
        } else if (resultCode == ProductUtil.PAID_BAILCACH) { //已经交了保证金
            DataUtil.UpdateLoginver(getActivity());
            int loginVe1r = (int) SPUtils.get(getActivity(), Constance.LOGINVER, 0, Constance.JLONGG);
            LUtils.e("------------22--------" + loginVe1r);
            loginInfo();
            CommonMethod.makeNoticeShort(getActivity(), "已缴纳保证金", CommonMethod.SUCCESS);
        } else if (resultCode == Constance.BALANCE_WITHDRAW_SUCCESS) {
            CommonMethod.makeNoticeShort(getActivity(), "提现成功", CommonMethod.SUCCESS);
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


    public class LoginInf {

        String share;
        String path;
        int state;

        public int getState() {
            return state;
        }

        public void setState(int state) {
            this.state = state;
        }

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
    public void initFragmentData() {
        initWebView();
        loginInfo();
    }

    /**
     * 分享
     */
    public void showShareDialog(boolean isHintSaveAlbim) {
        LUtils.e("开始分享");
        webViewBrage.showShareDialog(webView, isHintSaveAlbim);
    }

}