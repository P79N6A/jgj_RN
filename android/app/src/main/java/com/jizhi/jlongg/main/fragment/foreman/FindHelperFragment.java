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
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.fragment.BaseFragment;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.DataUtil;
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
public class FindHelperFragment extends BaseFragment {

    private BridgeX5WebView webView;

    public BridgeX5WebView getWebView() {
        return webView;
    }

    private WebViewBrage webViewBrage;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.activity_x5webview, container, false);
    }

    public String getUrl() {
//        return UclientApplication.getRoler(getContext()).equals("1") ? NetWorkRequest.WORK : NetWorkRequest.JOB;
        return NetWorkRequest.JOB;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        ViewUtils.inject(this, getView());
        getView().findViewById(R.id.head).setVisibility(View.GONE);
        webView = getView().findViewById(R.id.webView);
        String url = getUrl();
        // 修改ua使得web端正确判断
        String ua = webView.getSettings().getUserAgentString();
        webView.getSettings().setUserAgentString(ua + ";person;ver=" + AppUtils.getVersionName(getActivity()) + ";infover=" + DataUtil.getinfover(getActivity()) + ";");
        webView.synCookies(getActivity(), url);
        webView.loadUrl(Utils.getUrl(url));
        webViewBrage = new WebViewBrage(webView, getActivity(), null);
        LUtils.e("------webFlush----11------");

    }
    /**
     * 绑定微信成功
     */
    public void bindWechatSuccess() {
        if (null != webViewBrage.getBundWechatFuncion()) {
            webViewBrage.getBundWechatFuncion().onCallBack("");
        }

    }
    /**
     * 发送添加好友请求成功
     */
    public void AddFriendSuccess() {
        if (null != webViewBrage.getSendAddFriendFuncion()) {
            webViewBrage.getSendAddFriendFuncion().onCallBack("");
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


    public void loginInfo() {
        if (null != webView) {
            webViewBrage.loginInfo(webView);
        }
    }


    public void reloadUrl(String url) {
        if (null != webView) {
            webView.loadUrl(url);
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
        webView.callHandler("networkState", str, new CallBackFunction() {

            @Override
            public void onCallBack(String data) {
                if (null != data) {
                }
            }

        });
    }

    public void webFlush() {
        LUtils.e("------webFlush----22------");

        if (null != webView) {
            LUtils.e("------webFlush----33------");

            webView.loadUrl(Utils.getUrl(getUrl()));
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

    public class City {
        String city_name;
        String city_code;
        String city_provice;

        public String getCity_name() {
            return city_name;
        }

        public void setCity_name(String city_name) {
            this.city_name = city_name;
        }

        public String getCity_code() {
            return city_code;
        }

        public void setCity_code(String city_code) {
            this.city_code = city_code;
        }

        public String getCity_provice() {
            return city_provice;
        }

        public void setCity_provice(String city_provice) {
            this.city_provice = city_provice;
        }
    }

    @Override
    public void initFragmentData() {
        loginInfo();
    }

    /**
     * 分享
     */
    public void showShareDialog(boolean isHintSaveAlbim) {
        LUtils.e("开始分享");
        webViewBrage.showShareDialog(webView,isHintSaveAlbim);
    }
}