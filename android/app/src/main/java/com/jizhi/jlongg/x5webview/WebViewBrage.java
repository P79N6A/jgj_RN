package com.jizhi.jlongg.x5webview;

import android.Manifest;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;

import com.alipay.sdk.app.PayTask;
import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.AddFriendSendCodectivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.ContactsActivity;
import com.jizhi.jlongg.main.activity.GameActivity;
import com.jizhi.jlongg.main.activity.HuangliActivity;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.activity.MyScanQrCodeActivity;
import com.jizhi.jlongg.main.activity.OpenWechatServiceActivity;
import com.jizhi.jlongg.main.activity.ProjectGuideActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.RepositoryGridViewActivity;
import com.jizhi.jlongg.main.activity.SetActivity;
import com.jizhi.jlongg.main.activity.SynchMutipartProActivity;
import com.jizhi.jlongg.main.activity.UpdateTelFirstNewActivity;
import com.jizhi.jlongg.main.activity.UserInfoBrageActivity;
import com.jizhi.jlongg.main.activity.VeinRecommendationActivity;
import com.jizhi.jlongg.main.activity.WonderfulVideoListActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.partner.BailCashActivity;
import com.jizhi.jlongg.main.activity.partner.BalanceWithdrawActivity;
import com.jizhi.jlongg.main.activity.pay.MyOrderListActivity;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.GotoView;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LocalBean;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.ShareBill;
import com.jizhi.jlongg.main.bean.UpImg;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.bean.Video;
import com.jizhi.jlongg.main.bean.WebImageBean;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.SavaPicDialog;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.ScreenShot;
import com.jizhi.jlongg.main.util.ShareUtils;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeHandler;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;

import java.util.ArrayList;
import java.util.List;

import util.PayResult;

import static com.jizhi.jlongg.main.util.Constance.JLONGG;

/**
 * Created by Administrator on 2017/3/3 0003.
 */

public class WebViewBrage {
    //    private BridgeX5WebView webView;
//    private Activity activity;


    private CallBackFunction mFunction;
    private String type;
    private CallBackFunction payFunction;
    private CallBackFunction commonFunction;
    private Activity activity;
    private CustomShareDialog.ShareSuccess shareSuccess;
    private int shareType;
    private Share share;
    //分享链接
    private CallBackFunction shareFuncion;
    //分享图片
    private CallBackFunction captureFuncion;
    //修改手机号
    private CallBackFunction editTelpHoneFuncion;
    //绑定微信
    private CallBackFunction bundWechatFuncion;
    //发送添加朋友信息
    private CallBackFunction sendAddFriendFuncion;

    private BridgeX5WebView webView;

    public CallBackFunction getSendAddFriendFuncion() {
        return sendAddFriendFuncion;
    }

    public void setSendAddFriendFuncion(CallBackFunction sendAddFriendFuncion) {
        this.sendAddFriendFuncion = sendAddFriendFuncion;
    }

    public CallBackFunction getBundWechatFuncion() {
        return bundWechatFuncion;
    }

    public void setBundWechatFuncion(CallBackFunction bundWechatFuncion) {
        this.bundWechatFuncion = bundWechatFuncion;
    }

    public CallBackFunction getCaptureFuncion() {
        return captureFuncion;
    }

    public CallBackFunction getShareFuncion() {
        return shareFuncion;
    }

    public void setShareFuncion(CallBackFunction shareFuncion) {
        this.shareFuncion = shareFuncion;
    }

    public CallBackFunction getEditTelpHoneFuncion() {
        return editTelpHoneFuncion;
    }

    public void setEditTelpHoneFuncion(CallBackFunction editTelpHoneFuncion) {
        this.editTelpHoneFuncion = editTelpHoneFuncion;
    }

    public CallBackFunction getCommonFunction() {
        return commonFunction;
    }

    public void setCommonFunction(CallBackFunction commonFunction) {
        this.commonFunction = commonFunction;
    }

    public void setmFunction(CallBackFunction mFunction) {
        this.mFunction = mFunction;
    }

    public String getType() {
        return type;
    }

    public CallBackFunction getmFunction() {
        return mFunction;
    }

    public CallBackFunction getPayFunction() {
        return payFunction;
    }

    public void setPayFunction(CallBackFunction payFunction) {
        this.payFunction = payFunction;
    }

    public void loginInfo(BridgeX5WebView webView) {
        String info = DataUtil.getLoginInfo(UclientApplication.getInstance(),"");
        webView.loadUrl("javascript:GLOBAL.jsBridgeFn(" + info + ")");

//        LUtils.e("-------loginInfo------------" + info);
//        webView.callHandler("loginInfo", info, new CallBackFunction() {
//
//            @Override
//            public void onCallBack(String data) {
//            }
//
//        });
    }

    public WebViewBrage(final BridgeX5WebView webView, final Activity activity, final CustomShareDialog.ShareSuccess shareSuccess) {
        this.activity = activity;
        this.shareSuccess = shareSuccess;

        /**
         * 打电话
         */
        webView.registerHandler("appCall", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                CallPhoneUtil.callPhone(activity, data);
            }
        });
        /**
         * 关闭页面
         */
        webView.registerHandler("viewBack", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                activity.finish();
            }
        });
        /**
         * gotoFirstPageForApp 首页
         */
        webView.registerHandler("gotoFirstPageForApp", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e(data);
                Gson gson = new Gson();
                ShareBill shareBill = gson.fromJson(data, ShareBill.class);
//                if (null != shareBill && !TextUtils.isEmpty(shareBill.getMsg())) {
//                    CommonMethod.makeNoticeShort(activity, shareBill.getMsg(), true);
//                }
                activity.setResult(Constance.FINISH_WEBVIEW, new Intent());
                activity.finish();
            }
        });
        /**
         * 分享
         */
        webView.registerHandler("showShareMenu", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("---data---" + data);

                if (Utils.isFastDoubleClick()) {
                    return;
                }

                shareFuncion = function;
                Gson gson = new Gson();
                ShareBill shareBill = gson.fromJson(data, ShareBill.class);
                share = new Share();
                share.setUrl(shareBill.getUrl());
                share.setDescribe(shareBill.getDescribe());
                share.setImgUrl(shareBill.getImgUrl());
                share.setTitle(shareBill.getTitle());
                share.setTopdisplay(shareBill.getTopdisplay());
                if (null != shareBill.getWxMini()) {
                    share.setAppId(!TextUtils.isEmpty(shareBill.getWxMini().getAppId()) ? shareBill.getWxMini().getAppId() : "");
                    share.setPath(!TextUtils.isEmpty(shareBill.getWxMini().getPath()) ? shareBill.getWxMini().getPath() : "");
                    share.setTypeImg(!TextUtils.isEmpty(shareBill.getWxMini().getTypeImg()) ? shareBill.getWxMini().getTypeImg() : "");
                }
                shareType = shareBill.getType();
//                function.onCallBack("");

                if (Build.VERSION.SDK_INT >= 23) {
                    String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
                    ActivityCompat.requestPermissions(activity, mPermissionList, Constance.REQUEST);
                } else {
                    showShareDialog(webView, true);
                }
            }
        });

        /**
         * 调用原生截屏幕
         */
        webView.registerHandler("screenshot", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                captureFuncion = function;
                share = new Share();
                if (Build.VERSION.SDK_INT >= 23) {
                    String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
                    ActivityCompat.requestPermissions(activity, mPermissionList, Constance.REQUEST_CAPTURE);
                } else {
                    showShareDialog(webView, false);

                }
            }
        });


        /**
         * 登陆
         */
        webView.registerHandler("login", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("----------login------------:");
                Intent intent = new Intent(activity, LoginActivity.class);
                activity.startActivityForResult(intent, Constance.REQUEST_LOGIN);
                activity.finish();
            }
        });
        /**
         * 补充姓名
         */
        webView.registerHandler("upInfoState", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("-----------------ACTION_UPDATEUSERINFO---------" +data);
                Gson gson = new Gson();
                LoginStatu state = gson.fromJson(data, LoginStatu.class);
                SPUtils.put(activity, Constance.enum_parameter.IS_INFO.toString(), Constance.IS_INFO_YES, Constance.JLONGG);
                SPUtils.put(activity, Constance.NICKNAME, state.getNickname(), JLONGG); //昵称
                SPUtils.put(activity, Constance.USERNAME, state.getRealname(), Constance.JLONGG);
                SPUtils.put(activity, Constance.NICKNAME, state.getRealname(), Constance.JLONGG);
                SPUtils.put(activity, Constance.HEAD_IMAGE, state.getHeadpic(), Constance.JLONGG); //用户头像
                DataUtil.UpdateLoginver(activity);
                LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(WebSocketConstance.ACTION_UPDATEUSERINFO));

            }
        });
        /**
         * 跳转聊天
         */
        webView.registerHandler("createChat", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Gson gson = new Gson();
                LUtils.e("-----createChat-11----" + data);
                PersonWorkInfoBean personWorkInfoBean = gson.fromJson(data, PersonWorkInfoBean.class);
                //4.0.2好友来源字段名:page  ： connection 人脉  ，  dynamic 工友圈， job 找活招工
                if (personWorkInfoBean.getPage() != null && !TextUtils.isEmpty(personWorkInfoBean.getPage())) {
                    if (personWorkInfoBean.getPage().equals("job")) {
                        AddFriendsSources.create().setSource(AddFriendsSources.SOURCE_JOB).setReset(false);
                    } else if (personWorkInfoBean.getPage().equals("connection")) {
                        AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_PEOPLE_CONNECTION);
                    } else if (personWorkInfoBean.getPage().equals("dynamic")) {
                        AddFriendsSources.create().setSource(AddFriendsSources.SOURCE_WORKMATES_CICLE).setReset(false);
                    }
                    LUtils.e("====添加朋友==h5==="+AddFriendsSources.create().getSource());
                }
                if (personWorkInfoBean.getIs_chat() == 0) {
                    //当为 0 时 跳转到添加朋友的页面
                    AddFriendSendCodectivity.actionStart(activity, personWorkInfoBean.getGroup_id());
                    sendAddFriendFuncion = function;
                    return;
                }
                GroupDiscussionInfo info = new GroupDiscussionInfo();
                info.setGroup_id(personWorkInfoBean.getGroup_id());
                info.setClass_type(personWorkInfoBean.getClass_type());
                info.setGroup_name(personWorkInfoBean.getGroup_name());
                info.setIs_find_job(1);
                info.setVerified(personWorkInfoBean.getVerified());
                if (personWorkInfoBean.getClick_type() != 0) {
                    NewMsgActivity.actionStart(activity, info, personWorkInfoBean);
                } else if (!TextUtils.isEmpty(personWorkInfoBean.getVerified()) && !personWorkInfoBean.getVerified().equals("3")) {
                    personWorkInfoBean.setClick_type(3);
                    NewMsgActivity.actionStart(activity, info, personWorkInfoBean);

                } else {
                    NewMsgActivity.actionStart(activity, info);

                }

            }
        });

        /**
         * 黄历
         */
        webView.registerHandler("showCalendar", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Intent intent = new Intent(activity, HuangliActivity.class);
                activity.startActivity(intent);

            }
        });

        webView.registerHandler("getMobileInfo", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                SystemInfo systemInfo = new SystemInfo();
                systemInfo.setClient_type("person");
                systemInfo.setVersion(AppUtils.getVersionName(activity).toString());
                systemInfo.setSys_info(AppUtils.getMobileInfo(activity).toString());
                function.onCallBack(new Gson().toJson(systemInfo));
            }
        });

        /**
         * 原生设置模块，调用原生设置页面
         */
        webView.registerHandler("appSet", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                SetActivity.actionStart(activity);
            }
        });

        webView.registerHandler("appLink", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("data:" + data);
                Gson gson = new Gson();
                ShareBill shareBill = gson.fromJson(data, ShareBill.class);
                if (shareBill.getTitle().equals(activity.getResources().getString(R.string.look_book)) || shareBill.getTitle().equals(activity.getResources().getString(R.string.look_duanzi))) {
                    Intent intent = new Intent(activity, GameActivity.class);
                    intent.putExtra("url", shareBill.getUrl());
                    intent.putExtra("title", shareBill.getTitle());
                    activity.startActivity(intent);
                } else {
                    if (!shareBill.getUrl().contains(NetWorkRequest.WEB_DOMAIN) || shareBill.getUrl().contains(Constance.HEAD)) {
                        X5WebViewActivity.actionStart(activity, shareBill.getUrl(), true);
                    } else {
                        X5WebViewActivity.actionStart(activity, shareBill.getUrl());
                    }
                }
            }
        });
        webView.registerHandler("upImg", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                mFunction = function;
                Gson gson = new Gson();
                UpImg upImg = gson.fromJson(data, UpImg.class);
                type = upImg.getType();
                if (upImg.getNum() == 1) {
                    CameraPop.singleSelectorWeb(activity, null);
                } else {
                    CameraPop.multiSelectorWeb(activity, null, upImg.getNum());
                }
                LUtils.e("---------------------------upImg-" + data);
            }
        });

        //同步
        webView.registerHandler("syncBill", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("同步:" + data);
                ReleaseProjectInfo info = new Gson().fromJson(data, ReleaseProjectInfo.class);
                Intent intent = new Intent(activity, SynchMutipartProActivity.class);
//                intent.putExtra(Constance.PID, String.valueOf(info.getSync_id()));
                intent.putExtra(Constance.PID, String.valueOf(info.getTeam_id()));    //字段语义有可能不明确
                intent.putExtra(Constance.BEAN_STRING, info.getPro_name());
                activity.startActivity(intent);
            }

        });
//关闭页面
        webView.registerHandler("backPrev", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                activity.setResult(Constance.INFOMATION, activity.getIntent());
                activity.finish();
            }
        });
        //缺省页
        webView.registerHandler("recordFrom", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Intent intent = new Intent();
                intent.setClass(activity, ProjectGuideActivity.class);
                intent.putExtra("title", "记工统计数据从哪里来");
                intent.putExtra("from", 1);
//                intent.setClass(mActivity, CreateProjectActivity.class);
                activity.startActivityForResult(intent, Constance.REQUEST);
            }
        });
        //查看明细
        webView.registerHandler("checkBill", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("查看明细:" + data);
                Share info = new Gson().fromJson(data, Share.class);
                LUtils.e(data);
                Intent intent = new Intent();
                intent.setClass(activity, UserInfoBrageActivity.class);
                intent.putExtra("title", "记工统计");
                intent.putExtra("url", info.getUrl());
                activity.startActivity(intent);
            }
        });

        //web跳转原生视图
        webView.registerHandler("goToView", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("---goToView-----" + data);
                GotoView info = new Gson().fromJson(data, GotoView.class);
                if (info.getName().equalsIgnoreCase("RememberWorkerInfoActivity")) {
                    RememberWorkerInfosActivity.actionStart(activity, info.getData().getYear(), info.getData().getMonth());
                } else if (info.getName().equalsIgnoreCase("RepositoryGridViewActivity")) {
                    //资料库
                    RepositoryGridViewActivity.actionStart(activity, null);
                } else if (info.getName().equalsIgnoreCase("identity")) {
                    //切换身份
                    ChooseRoleActivity.actionStart(activity, false);
                } else if (info.getName().equalsIgnoreCase(Constance.CONNECTION)) {
                    //人脉
                    VeinRecommendationActivity.actionStart(activity);
                } else if (info.getName().equalsIgnoreCase("OpenWechatServiceActivity")) {
                    bundWechatFuncion = function;
                    //开通微信服务
                    OpenWechatServiceActivity.actionStart(activity, 0, true);
                } else if (info.getName().equalsIgnoreCase("MyScanQrCodeActivity")) {
                    String nickName = UclientApplication.getNickName(activity); //昵称
                    String realName = UclientApplication.getRealName(activity); //真实姓名
                    MyScanQrCodeActivity.actionStart(activity, !TextUtils.isEmpty(realName) ? realName : nickName, SPUtils.get(activity, Constance.HEAD_IMAGE, "", Constance.JLONGG).toString());
                }

            }
        });
        //点击头像
        webView.registerHandler("changeHeader", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Acp.getInstance(activity).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA)
                                .build(),
                        new AcpListener() {
                            @Override
                            public void onGranted() {
                                CameraPop.singleSelector(activity, null);
                            }

                            @Override
                            public void onDenied(List<String> permissions) {
                                //已经禁止提示了
                                CommonMethod.makeNoticeShort(activity, activity.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                            }
                        });
            }
        });
//        /**
//         * 上传坐标
//         */
//        webView.registerHandler("getLocation", new BridgeHandler() {
//            @Override
//            public void handler(String data, CallBackFunction function) {
                String city_name = (String) SPUtils.get(activity, "city_name", "", JLONGG);
//                String city_code = (String) SPUtils.get(activity, "city_code", "", JLONGG);
//                String city_provice = (String) SPUtils.get(activity, "city_provice", "", JLONGG);
//                String lat = (String) SPUtils.get(activity, "lat", "", JLONGG);
//                String lng = (String) SPUtils.get(activity, "lng", "", JLONGG);
//                City city = new City();
//                city.setCity_name(city_name);
//                city.setCity_code(city_code);
//                city.setCity_provice(city_provice);
//            }
//        });

        /**
         * 隐藏显示fooder
         */
        webView.registerHandler("footerController", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e(data + "------------------:footerController");
                LinearLayout appMainBottomLayout = (LinearLayout) activity.findViewById(R.id.layout);
                if (appMainBottomLayout == null) {
                    return;
                }
                try {
                    String[] url = webView.getUrl().split("\\?");
                    if (url.length > 0) {
                        if (url[0].equals(NetWorkRequest.MY) || url[0].equals(NetWorkRequest.NEWLIFE)) {
                            appMainBottomLayout.setVisibility(View.VISIBLE);
                            return;
                        }
                    }
                    if (((AppMainActivity) activity).currentTabIndex == 1) {
                        appMainBottomLayout.setVisibility(View.VISIBLE);
                        return;
                    }
                } catch (Exception e) {

                }
                Gson gson = new Gson();
                ShareBill state = gson.fromJson(data, ShareBill.class);
                appMainBottomLayout.setVisibility(state.getState().equals("hide") ? View.GONE : View.VISIBLE);

            }
        });

        //获取定位信息
        webView.registerHandler("getLocation", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("-------------getLocation--------00---------:");
                String city_name = SPUtils.get(activity, "loc_city_name", "", JLONGG).toString(); //定位的城市
                String lat = (String) SPUtils.get(activity, "lat", "", JLONGG); //纬度 Latitude
                String lng = (String) SPUtils.get(activity, "lng", "", Constance.JLONGG);//经度 Longitude
                String nation = SPUtils.get(activity, "nation", "", Constance.JLONGG).toString(); //国家
                String province = SPUtils.get(activity, "province", "", Constance.JLONGG).toString(); //省
                String adcode = SPUtils.get(activity, "adcode", "", Constance.JLONGG).toString(); //国家城市编码
                LocalBean localBean = new LocalBean();
                localBean.setCity(city_name);
                localBean.setLat(lat);
                localBean.setLng(lng);
                localBean.setNation(nation);
                localBean.setProvince(province);
                localBean.setAdcode(adcode);
                function.onCallBack(new Gson().toJson(localBean));

            }
        });
        webView.registerHandler("deposit", new BridgeHandler() {//交保证金
            @Override
            public void handler(String data, CallBackFunction function) {

                BailCashActivity.actionStart(activity);
            }
        });
        webView.registerHandler("withdrawal", new BridgeHandler() {  //余额提现
            @Override
            public void handler(String data, CallBackFunction function) {
                BalanceWithdrawActivity.actionStart(activity);
            }
        });
        //我的订单
        webView.registerHandler("myOrder", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                MyOrderListActivity.actionStart(activity);
            }
        });
        // orderNow立即订购
        webView.registerHandler("orderNow", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
//                ConfirmVersionOrderNewActivity.actionStart(activity, null);
            }
        });

        // 调用原生展示图片
        webView.registerHandler("previewImage", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("---------------:" + data);
                WebImageBean webImageBean = new Gson().fromJson(data, WebImageBean.class);
                ArrayList<String> list = webImageBean.getImgData();
                for (int i = 0; i < list.size(); i++) {
                    list.set(i, webImageBean.getImgDiv() + list.get(i));
                }
                LoadCloudPicActivity.actionStart(activity, list, webImageBean.getImgIndex() + 1);
            }
        });
        //跳转到个人资料
        webView.registerHandler("returnPerson", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Gson gson = new Gson();
                UserInfo userInfo = gson.fromJson(data, UserInfo.class);
                ChatUserInfoActivity.actionStart(activity, userInfo.getUid());
            }
        });

        //支付
        webView.registerHandler("appPay", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("---appPay-------" + data);
                Gson gson = new Gson();
                PayBean payBean = gson.fromJson(data, PayBean.class);
                payFunction = function;
                if (payBean.getPay_type() == 1) {
                    ProductUtil.wxPayCallBack(payBean.getRecord_id(), activity);
                } else if (payBean.getPay_type() == 2) {
                    ProductUtil.aliPayCallBack(payBean.getRecord_id(), activity, function);
                }
            }
        });
        /**
         * 小视频
         */
        webView.registerHandler("createDynamicVideo", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Gson gson = new Gson();
                Video video = gson.fromJson(data, Video.class);
                LUtils.e("----------createDynamicVideo------------:" + data + "     id:" + video.getId());
                commonFunction = function;
                if (video.getId() == 0) {
                    WonderfulVideoListActivity.actionStart(activity); //精彩小视频
                } else {
                    WonderfulVideoListActivity.actionStart(activity, video.getId()); //精彩小视频
                }
            }
        });
        /**
         * 复制
         */
        webView.registerHandler("copy", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Gson gson = new Gson();
                LoginInfo loginInfo = gson.fromJson(data, LoginInfo.class);
                LUtils.e("----------copy------------:" + loginInfo.getCopyInfo());
                //        //添加到剪切板
                ClipboardManager clipboardManager =
                        (ClipboardManager) activity.getSystemService(Context.CLIPBOARD_SERVICE);
                /**之前的应用过期的方法，clipboardManager.setText(copy);*/
                assert clipboardManager != null;
                clipboardManager.setPrimaryClip(ClipData.newPlainText(null, loginInfo.getCopyInfo()));
                if (clipboardManager.hasPrimaryClip()) {
                    clipboardManager.getPrimaryClip().getItemAt(0).getText();
                }

                DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(activity, null, "该微信号: " + loginInfo.getCopyInfo() + " 已复制，请在微信中添加朋友时粘贴搜索", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        Utils.OPenWXAPP(activity);
                    }
                });
                dialogLeftRightBtnConfirm.show();
                dialogLeftRightBtnConfirm.setLeftBtnText("我知道了");
                dialogLeftRightBtnConfirm.setRightBtnText("打开微信");

            }
        });
        LoginInfo loginInfo = new LoginInfo();
        String str = new Gson().toJson(loginInfo);
        LUtils.e("----netWorkState------:" + str);
        webView.callHandler("networkState", str, new CallBackFunction() {

            @Override
            public void onCallBack(String data) {
                if (null != data) {
                    LUtils.e("--------networkState------------");
                }
            }

        });
        //修改手机号
        webView.registerHandler("editTelph", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                UpdateTelFirstNewActivity.actionStart(activity);
                editTelpHoneFuncion = function;

            }
        });

        //跳转到通讯录
        webView.registerHandler("toAddressBook", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                ContactsActivity.actionStart(activity);
            }
        });
        //隐藏发现红点
        webView.registerHandler("registerDynamicMsgNum", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {

                LUtils.e("-------------registerDynamicMsgNum----------");
                Intent intent = new Intent(Constance.
                        HIDE_NEWLIFE_RED_DOT);
                LocalBroadcastManager.getInstance(activity).sendBroadcast(intent);
            }
        });
        //隐藏发现红点
        webView.registerHandler("opencalender", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                LUtils.e("-------opencalender--------");
                Utils.openCalender(activity);
            }
        });

//        //修改手机号
//        webView.registerHandler("editTelph", new BridgeHandler() {
//            @Override
//            public void handler(String data, CallBackFunction function) {
//                FindPwdInputTelphoneActivity.actionStart(activity);
//                editTelpHoneFuncion=function;
//
//            }
//        });

    }

    /**
     * 支付宝回调
     *
     * @param orderInfo
     * @param activity
     */
    public void aliPayCallBack(final String orderInfo, final Activity activity, final CallBackFunction function) {
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                final PayResult payResult = new PayResult(new PayTask(activity).payV2(Html.fromHtml(orderInfo).toString(), true));
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        /**
                         对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                         */
                        // 判断resultStatus 为9000则代表支付成功
                        if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                            // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                            function.onCallBack(payResult.getResultStatus());
                        } else {
                            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                            function.onCallBack(new Gson().toJson(payResult));
                        }
                    }
                });
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    public class LoginInfos {
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

    //判断是否登录或补充资料

    private boolean judgeLogin(Activity activity) {
        if (!IsSupplementary.accessLogin(activity)) {
            return false;
        }
        String title = UclientApplication.getRoler(activity).equals(Constance.ROLETYPE_FM) ? "完善班组长/工头资料,即可查看该内容" : "完善工人资料,即可查看该内容";
        if (IsSupplementary.SupplementaryRegistrationWorker(activity, title)) {
            return false;
        }
        return true;
    }

    public class SystemInfo {
        private String client_type;
        private String version;
        private String sys_info;

        public String getClient_type() {
            return client_type;
        }

        public void setClient_type(String client_type) {
            this.client_type = client_type;
        }

        public String getVersion() {
            return version;
        }

        public void setVersion(String version) {
            this.version = version;
        }

        public String getSys_info() {
            return sys_info;
        }

        public void setSys_info(String sys_info) {
            this.sys_info = sys_info;
        }
    }

    public static class LoginInf {

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

    public void showShareDialog(BridgeX5WebView webView, boolean isHintSaveAlbim) {//所有权限申请完成
        if (null == share) {
            return;
        }
        switch (shareType) {
            case 0:
                CustomShareDialog dialog = new CustomShareDialog(activity, isHintSaveAlbim, share);
                //显示窗口
                dialog.showAtLocation(activity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                BackGroundUtil.backgroundAlpha(activity, 0.5F);
                //保存成功或者分享链接成功回调fuction
                dialog.setFunction(shareFuncion);
                //保存成功或者分享图片成功回调fuction
                dialog.setCaptureFuncion(captureFuncion);
                dialog.setWebView(webView);
                break;
            case 1:
            case 2:
            case 3:
                ShareUtils shareUtils = new ShareUtils();
                shareUtils.shareFactory(activity, shareType + "", share);
                if (null != shareSuccess) {
                    shareUtils.setShareSuccess(shareSuccess);
                }
                break;
        }
    }

    public void saveImage() {
        LUtils.e("-----------AAAAAA---------");
        int headHeight = ScreenUtils.getStatusHeight(activity) + DensityUtils.dp2px(activity, 50);
        Bitmap bitmap = ScreenShot.takeScreenShotClip(activity, 0, headHeight);
        boolean isSaveSuccess = new SavaPicDialog(activity, bitmap).SavePic(bitmap);
        LUtils.e("-----------保存成功啦----------" + isSaveSuccess);
        if (isSaveSuccess) {
            captureFuncion.onCallBack(new Gson().toJson(new LoginInf()));
        }
    }
}