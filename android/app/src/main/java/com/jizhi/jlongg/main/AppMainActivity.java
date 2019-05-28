package com.jizhi.jlongg.main;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.db.HuangliBaseInfoService;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.higuide.HiGuide;
import com.jizhi.jlongg.higuide.Overlay;
import com.jizhi.jlongg.listener.OnDoubleClickListener;
import com.jizhi.jlongg.listener.impl.DoubleClick;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.activity.MyGroupTeamActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.pay.MyOrderListActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Banner;
import com.jizhi.jlongg.main.bean.DiscoverBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.dialog.AdvertisementPopWindow;
import com.jizhi.jlongg.main.dialog.DiaLogOpenNoticePermission;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.RememberFlowGuideDialog;
import com.jizhi.jlongg.main.fragment.BaseFragment;
import com.jizhi.jlongg.main.fragment.CalendarMainFragment;
import com.jizhi.jlongg.main.fragment.ChatFragment;
import com.jizhi.jlongg.main.fragment.NewLifeFragment;
import com.jizhi.jlongg.main.fragment.foreman.FindHelperFragment;
import com.jizhi.jlongg.main.fragment.foreman.MyFragmentWebview;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.LoctionUtils;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.UtilFile;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.reactnative.JobReactActivity;
import com.jizhi.jlongg.reactnative.RNHelperFragment;
import com.jizhi.jlongg.reactnative.RNMyFragment;
import com.jizhi.jlongg.reactnative.RNNewLifeFragment;
import com.jizhi.jlongg.service.WebSocketHeartRateService;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.lidroid.xutils.exception.HttpException;
import com.readystatesoftware.systembartint.SystemBarTintManager;
import com.umeng.message.PushAgent;
import com.umeng.socialize.UMShareAPI;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import util.NotificationUtils;

/**
 * 功能: 2.0.3 主页面
 * 作者：xuj
 * 时间: 2016年8月17日 14:52:59
 */
public class AppMainActivity extends BaseActivity implements DefaultHardwareBackBtnHandler {

    /**
     * 底部导航栏布局
     */
    private RelativeLayout[] mTabs;
    /**
     * Framgent集合
     */
    private Fragment[] fragments;
    /**
     * Fragment 标签
     */
    private String[] tags = new String[]{"tag", "tag1", "tag2", "tag3", "tag4"};
    /**
     * 当前Table选中下标
     */
    public int currentTabIndex;
    /**
     * 聊聊消息未读数
     */
    private TextView unreadChatmessageCount;
    /**
     * 发现小红点
     */
    private View discoveredView;
    /**
     * 是否从网页更新了个人资料
     */
    private boolean isUpdateInfoFromWebView;
    /**
     * 当前状态栏的颜色
     */
    private int currentStatusColor;
    /**
     * 发送中的消息集合
     */
    private ArrayList<MessageBean> listTemp = new ArrayList<>();
    private List<MessageBean> sendingMessageBean = Collections.synchronizedList(listTemp);
    private boolean isShowPermissionDialog = false;
    private boolean isShowGpsServiceDialog = false;
    private BroadcastReceiver broadcastReceiver;
    //RN管理器
    protected ReactInstanceManager mReactInstanceManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        registerReceiver();
        initView();
        initWebview();
        initFragments(savedInstanceState);
        UtilFile.picDir();
        checkPermission();
        getDiscoerRedDot();
//        startCheckMessageState();
        PushAgent.getInstance(this).setDisplayNotificationNumber(8);
        broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, final Intent intent) {
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        String url = intent.getStringExtra(Constance.COMPLETE_SCHEME);
                        if (url.equals(Constance.SCHEME_TYPE.JOB)) {
                            if (!(UclientApplication.getInstance().getTopActivity() instanceof AppMainActivity)) {
                                UclientApplication.getInstance().killOthersActivity(AppMainActivity.this);
                                onTabClicked(getmTabs()[2]);
                                //((FindHelperFragment)fragments[2]).webFlush();
                                refreshWebView(2);

                                LUtils.e("app job 杀死上层");
                            } else {
                                onTabClicked(getmTabs()[2]);
                                //((FindHelperFragment)fragments[2]).webFlush();
                                refreshWebView(2);
                                LUtils.e("app job ");
                            }
                        } else if (url.equals(Constance.SCHEME_TYPE.FIND)) {
                            if (!(UclientApplication.getInstance().getTopActivity() instanceof AppMainActivity)) {
                                UclientApplication.getInstance().killOthersActivity(AppMainActivity.this);
                                onTabClicked(getmTabs()[3]);
                                //((NewLifeFragment)fragments[3]).webFlush();
                                refreshWebView(3);
                                LUtils.e("app find 杀死上层");
                            } else {
                                onTabClicked(getmTabs()[3]);
                                //((NewLifeFragment)fragments[3]).webFlush();
                                refreshWebView(3);
                                LUtils.e("app find ");
                            }
                        } else if (url.equals(Constance.SCHEME_TYPE.MY)) {
                            if (!(UclientApplication.getInstance().getTopActivity() instanceof AppMainActivity)) {
                                UclientApplication.getInstance().killOthersActivity(AppMainActivity.this);
                                onTabClicked(getmTabs()[4]);
                                //((MyFragmentWebview)fragments[4]).webFlush();
                                refreshWebView(4);
                                LUtils.e("app my 杀死上层");
                            } else {
                                onTabClicked(getmTabs()[4]);
                                //((MyFragmentWebview)fragments[4]).webFlush();
                                refreshWebView(4);
                                LUtils.e("app my");
                            }
                        } else {
                            LUtils.e("app x5web");
                            url = url.replace(Constance.SCHEME, NetWorkRequest.WEBURLS);
                            X5WebViewActivity.actionStart1(UclientApplication.getInstance().getTopActivity(), url);
                        }
                    }
                }, 500);
            }
        };
        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver, new IntentFilter(Constance.URL_JUMP_ACTION));
        findViewById(R.id.btn1).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(AppMainActivity.this, JobReactActivity.class);
                startActivityForResult(intent, 0);
            }
        });
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            if (!Settings.canDrawOverlays(this)) {
//                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                        Uri.parse("package:" + getPackageName()));
//                startActivityForResult(intent, 1);
//            }
//        }
        checkRecruitGuide();
    }

    /**
     * 招聘,找工作引导页展示
     */
    private void checkRecruitGuide() {
        String key = "show_recruit_guide";
        boolean isShowRecruitGuide = (boolean) SPUtils.get(getApplicationContext(), key, false, Constance.JLONGG);
        if (!isShowRecruitGuide) {
            //马上记一笔按钮
            final View bottomLayout = findViewById(R.id.layout);
            bottomLayout.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    if (bottomLayout.getHeight() == 0) {
                        return;
                    }
//                    int[] range = new int[]{DensityUtil.dp2px(2), DensityUtil.dp2px(2)};  //高亮范围
                    new HiGuide(AppMainActivity.this).addHightLight(findViewById(R.id.find_worker_layout),
                            null, HiGuide.SHAPE_RECT, new Overlay.Tips(R.layout.main_guide_find_work, Overlay.Tips.TO_CENTER_OF, Overlay.Tips.ALIGN_TOP))
                            .touchDismiss(true)
                            .show();
                    if (Build.VERSION.SDK_INT < 16) {
                        bottomLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        bottomLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            SPUtils.put(getApplicationContext(), key, true, Constance.JLONGG); // 存放Token信息
        }


    }

    /**
     * 循环定时器，发送心跳包
     */
    private ScheduledExecutorService scheduledExecutorService;

    /**
     * 检查聊天消息状态
     */
    private void startCheckMessageState() {
        scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
        scheduledExecutorService.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                try {
                    LUtils.e("----检查聊天消息内容数量-----" + sendingMessageBean.size());
                    Iterator<MessageBean> it = sendingMessageBean.iterator();
                    while (it.hasNext()) {
                        MessageBean bean = it.next();
                        long time = (System.currentTimeMillis() - Long.parseLong(bean.getLocal_id())) / 1000;
                        if (Utils.isDouble(bean.getLocal_id()) && time >= 10) {
                            LUtils.e(bean.getLocal_id() + "----检查聊天消息内容---" + sendingMessageBean.size() + "--移除前--已经发送时间---" + time + "秒");
                            it.remove();
                            LUtils.e(bean.getLocal_id() + "----检查聊天消息内容---" + sendingMessageBean.size() + "--移除后--已经发送时间---" + time + "秒");
                        }
                    }
                } catch (Exception e) {
                    LUtils.e("----检查聊天消息内容异常----" + e.toString());

                }


            }
        }, 0, 10, TimeUnit.SECONDS);
    }

    private void setStatusColor(boolean isCalendarMain) {
        int mStatusColor = isCalendarMain ? R.color.app_color : R.color.black;
        if (currentStatusColor == (mStatusColor)) {
            return;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        }
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(mStatusColor);
        currentStatusColor = mStatusColor;
    }

    /**
     * 底部发现是否有小红点
     */
    private void getDiscoerRedDot() {
        String httpUrl = NetWorkRequest.DISCOVER_NEW_MSG_COUNT;
        CommonHttpRequest.commonRequest(this, httpUrl, DiscoverBean.class, CommonHttpRequest.OBJECT, RequestParamsToken.getExpandRequestParams(getApplicationContext()),
                false, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        DiscoverBean discoverBean = (DiscoverBean) object;
                        if (discoverBean != null && (discoverBean.getNew_comment_num() > 0 || discoverBean.getNew_liked_num() > 0 || discoverBean.getNew_fans_num() > 0)) {
                            discoveredView.setVisibility(View.VISIBLE);
                        } else {
                            discoveredView.setVisibility(View.GONE);
                        }
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });

    }

    /**
     * 检查App所需要的一些重要权限
     */
    private void checkPermission() {
        if (Build.VERSION.SDK_INT >= 23) {
            String[] mPermissionList = new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA};
            for (String permission : mPermissionList) {
                if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(AppMainActivity.this, mPermissionList, Constance.REQUEST_LOCAL);
                    return;
                } else {
                    setLocationCityName(); //设置定位城市
                    //防止第一次注册登录后权限申请过程出现的问题
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            LUtils.e("url onCreate第一次注册登录无权限");
                            urlSchemeJump(getIntent());
                        }
                    }, 500);
                    return;
                }
            }
        } else {
            setLocationCityName(); //设置定位城市
            //防止第一次注册登录后权限申请过程出现的问题
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    LUtils.e("url onCreate有权限");
                    urlSchemeJump(getIntent());
                }
            }, 500);
        }
    }

    /**
     * 1、推荐给他人的弹框 "APP打开40、60、80（后面每20次弹一次）次后弹框去推荐（新版本计数）： 你的支持是我们前进的最大动力！
     * 每推荐成员1个工友 即送你100积分 【马上去推荐】【残忍滴拒绝】
     * 2、引导去市场评价的弹框新版本打开20次，弹框引导去市场评论（新版本计数）： 你的支持是我们前进的最大动力，你对吉工家还满意吗？ 【残忍滴拒绝】【马上好评】”
     * 4、广告弹框（后台配置）
     * 5、版本升级（版本升级弹框）
     * 优先级：5 > 2 > 1 > 4
     */
    public boolean showAppRulerDialog() {
        String key = "app_ruler_dialog_" + AppUtils.getVersionName(getApplicationContext());
        boolean isShowDialog = false;
        int count = (int) SPUtils.get(getApplicationContext(), key, 1, Constance.JLONGG);
        if (count <= 20) {
            switch (count) {
                case 20: //弹出引导市场评价弹框
                    DialogLeftRightBtnConfirm btnConfirm = new DialogLeftRightBtnConfirm(this, null, "你的支持是我们前进的最大动力，你对吉工家还满意吗？", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {
                        }

                        @Override
                        public void clickRightBtnCallBack() { //跳转到应用市场 引导用户去评价
                            try {
                                Uri uri = Uri.parse("market://details?id=" + getPackageName());
                                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(intent);
                            } catch (Exception e) {
                                CommonMethod.makeNoticeLong(getApplicationContext(), "您的手机没有安装Android应用市场", CommonMethod.ERROR);
                                e.printStackTrace();
                            }
                        }
                    });
                    btnConfirm.setLeftBtnText("残忍滴拒绝");
                    btnConfirm.setRightBtnText("马上好评");
                    btnConfirm.show();
                    btnConfirm.setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override
                        public void onDismiss(DialogInterface dialog) {
                            getMainCalendarFragment().checkGuide();
                        }
                    });
                    isShowDialog = true;
                    break;
            }
        } else { //推荐给他人弹框  只要能被20整除的话 那么就弹出
//            if (count % 20 == 0) {
//                DialogLikeApp dialogLikeApp = new DialogLikeApp(this, new DialogLikeApp.LikeAppListener() {
//                    @Override
//                    public void toRecommend() { //推荐弹框
//                        X5WebViewActivity.actionStart(AppMainActivity.this, NetWorkRequest.WEBURLS + "my/3");
//                    }
//
//                    @Override
//                    public void refuse() { //拒绝弹框
//
//                    }
//                });
//                dialogLikeApp.setOnDismissListener(new DialogInterface.OnDismissListener() {
//                    @Override
//                    public void onDismiss(DialogInterface dialog) {
//                        getMainCalendarFragment().checkGuide();
//                    }
//                });
//                dialogLikeApp.show();
//                isShowDialog = true;
//            }
        }
        SPUtils.put(getApplicationContext(), key, count + 1, Constance.JLONGG);
        return isShowDialog;
    }

    /**
     * 预加载webview
     */
    public void initWebview() {
        BridgeX5WebView webView = findViewById(R.id.webView);
        webView.getSettings().setUserAgentString(webView.getSettings().getUserAgentString() + ";person;ver=" + AppUtils.getVersionName(getApplicationContext()) + ";");
        webView.loadUrl(Utils.getUrl(NetWorkRequest.WEBURLS + "404"));
    }

    private void initFragments(Bundle savedInstanceState) {
        BaseFragment calenrMainFragment = null; //项目
        BaseFragment chatFragment = null; //聊聊
        BaseFragment findHelpFragment = null; //找工作、招聘
        BaseFragment newLifeFragment = null; //发现
        BaseFragment myFragment = null; //我的
        if (savedInstanceState != null) {
            // “内存不足时重启”时调用成都集致生活科技有限公司
            currentTabIndex = savedInstanceState.getInt("position", 0);
            calenrMainFragment = (BaseFragment) getSupportFragmentManager().getFragment(savedInstanceState, tags[0]);
            chatFragment = (BaseFragment) getSupportFragmentManager().getFragment(savedInstanceState, tags[1]);
            findHelpFragment = (BaseFragment) getSupportFragmentManager().getFragment(savedInstanceState, tags[2]);
            newLifeFragment = (BaseFragment) getSupportFragmentManager().getFragment(savedInstanceState, tags[3]);
            myFragment = (BaseFragment) getSupportFragmentManager().getFragment(savedInstanceState, tags[4]);
        } else {
            calenrMainFragment = new CalendarMainFragment();
            chatFragment = new ChatFragment();
            findHelpFragment = new RNHelperFragment();
            newLifeFragment = new RNNewLifeFragment();
            myFragment = new RNMyFragment();
            checkIsLatestVersion();
        }

        fragments = new Fragment[]{calenrMainFragment, chatFragment, findHelpFragment, newLifeFragment, myFragment};
        if (chatFragment != null && !chatFragment.isAdded() && null == getSupportFragmentManager().findFragmentByTag(tags[1])) {
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            hideAllFragments(transaction);
            transaction.add(R.id.fragments, chatFragment, tags[1]).hide(chatFragment).commit();
        }
        onTabClicked(mTabs[currentTabIndex]);
    }

    /**
     * 检查通知权限
     * 【v4.0.1】打开推送通知权限的弹框,如用户关闭了推送权限，则在每天第一次打开app时进行提示。提示内容：
     */
    private boolean checkisOpenNoticePermission() {
        if (!NotificationUtils.isNotificationEnabled(this)) {
            int currentDay = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);
            int saveDay = (int) SPUtils.get(getApplicationContext(), "check_notice_permission_day", 0, Constance.JLONGG);
            LUtils.e("isOpen:" + NotificationUtils.isNotificationEnabled(getApplicationContext()) + "    currentDay:" + currentDay + "    save:" + saveDay);
            if (currentDay != saveDay) { //只要这两个日期不相等我们就认为已过了一天
                DiaLogOpenNoticePermission diaLogOpenNoticePermission = new DiaLogOpenNoticePermission(this);
                diaLogOpenNoticePermission.show();
                SPUtils.put(getApplicationContext(), "check_notice_permission_day", currentDay, Constance.JLONGG);
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    /**
     * 检查是否是最新版本
     */
    private void checkIsLatestVersion() {
//        5>6>2>1>4；
//        1、推荐给他人的弹框     "APP打开40、60、80（后面每20次弹一次）次后弹框去推荐（新版本计数）
//        2、引导去市场评价的弹框，新版本打开20次，弹框引导去市场评论（新版本计数）
//        4、广告弹框（后台配置）：
//        5、版本升级（版本升级弹框）：
//        6、【v4.0.1】打开推送通知权限的弹框,如用户关闭了推送权限，则在每天第一次打开app时进行提示。提示内容：
        Utils.checkVersion(this, new Utils.UpdateAppListener() {
            @Override
            public void isUpdate(boolean update) {
                if (!update) { //只有不更新App的时候才会去请求广告位
                    if (checkisOpenNoticePermission()) {
                        if (!showAppRulerDialog()) {
                            CommonHttpRequest.getAppBanner(AppMainActivity.this, 9, new CheckListHttpUtils.CommonRequestCallBack() {
                                @Override
                                public void onSuccess(Object bannerInfo) {
                                    Banner banner = (Banner) bannerInfo;
                                    if (banner != null && banner.getList() != null && banner.getList().size() > 0) {
                                        float bannerWidth = banner.getAd_size().get(0); //广告位图片宽度
                                        float bannerHeight = banner.getAd_size().get(1); //广告位图片高度
                                        Banner advertisement = banner.getList().get(banner.getList().size() - 1); //广告位图片
                                        AdvertisementPopWindow advertisementPopWindow = new AdvertisementPopWindow(AppMainActivity.this, bannerWidth, bannerHeight, advertisement); //取最后一位的广告位id
                                        advertisementPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.CENTER, 0, 0);
                                        advertisementPopWindow.setAlpha(true);
                                        advertisementPopWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                                            @Override
                                            public void onDismiss() {
                                                BackGroundUtil.backgroundAlpha(AppMainActivity.this, 1.0F);
                                                getMainCalendarFragment().checkGuide();
                                            }
                                        });
                                    } else {
                                        getMainCalendarFragment().checkGuide();
                                    }
                                }

                                @Override
                                public void onFailure(HttpException e, String s) {
                                    getMainCalendarFragment().checkGuide();
                                }
                            });
                        }
                    }
                }
            }
        }, new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                getMainCalendarFragment().checkGuide();
            }
        });
    }

    private void initView() {
        mReactInstanceManager =
                ((UclientApplication) AppMainActivity.this.getApplication()).getReactNativeHost().getReactInstanceManager();
        unreadChatmessageCount = findViewById(R.id.unreadChatmessageCount);
        discoveredView = findViewById(R.id.discoveredView);
        RelativeLayout work_circle_layout = findViewById(R.id.work_circle_layout);
        RelativeLayout group_chat_layout = findViewById(R.id.find_work_layout);
        RelativeLayout find_worker_layout = findViewById(R.id.find_worker_layout);
        RelativeLayout discovered_layout = findViewById(R.id.discovered_layout);
        RelativeLayout my_layout = findViewById(R.id.my_layout);
        mTabs = new RelativeLayout[]{work_circle_layout, group_chat_layout, find_worker_layout, discovered_layout, my_layout};
        OnDoubleClickListener doubleClickListener = new OnDoubleClickListener() {
            @Override
            public void OnSingleClick(View v) {
                onTabClicked(v);
            }

            @Override
            public void OnDoubleClick(final View v) {
                final Fragment fragment = fragments[currentTabIndex];
                if (fragment != null && fragment.isAdded()) {
                    if (fragment instanceof ChatFragment) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                ((ChatFragment) fragment).scrollToTop();
                            }
                        });
                    } else if (fragment instanceof RNHelperFragment || fragment instanceof RNNewLifeFragment || fragment instanceof RNMyFragment) {
                        mReactInstanceManager =
                                ((UclientApplication) AppMainActivity.this.getApplication()).getReactNativeHost().getReactInstanceManager();
                        mReactInstanceManager.showDevOptionsDialog();
                        refreshRN();
                    }
                }
            }
        };
        DoubleClick.registerDoubleClickListener(work_circle_layout, doubleClickListener);
        DoubleClick.registerDoubleClickListener(group_chat_layout, doubleClickListener);
        DoubleClick.registerDoubleClickListener(find_worker_layout, doubleClickListener);
        DoubleClick.registerDoubleClickListener(discovered_layout, doubleClickListener);
        DoubleClick.registerDoubleClickListener(my_layout, doubleClickListener);
    }


    @Override
    protected void onPause() {
        super.onPause();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostPause(this);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostResume(this, this);
        }
    }

    DialogLeftRightBtnConfirm dialog;

    /**
     * 底部按钮选中
     *
     * @param view
     */
    public void onTabClicked(View view) {
        int index = 0;
        switch (view.getId()) {
            case R.id.work_circle_layout: //项目
                index = 0;
                break;
            case R.id.find_work_layout: //聊聊
                index = 1;
                break;
            case R.id.find_worker_layout: //找工作、招聘
                checkGpsLocationPermission();
                index = 2;
                break;
            case R.id.discovered_layout: //发现
                index = 3;
                break;
            case R.id.my_layout: //我的
                index = 4;
                break;
        }
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        hideAllFragments(transaction);
        getSupportFragmentManager().executePendingTransactions();
        if (!fragments[index].isAdded() && null == getSupportFragmentManager().findFragmentByTag(tags[index])) {
            transaction.add(R.id.fragments, fragments[index], tags[index]);
        }
        transaction.show(fragments[index]).commitAllowingStateLoss();
        setBottomSelectedStatus(index);
        setStatusColor(index == 0 ? true : false);
        currentTabIndex = index;
    }

    private void refreshWebView(int index) {
        Fragment fragment = fragments[index];
        if (fragment != null && fragment.isAdded()) {
            if (fragment instanceof FindHelperFragment) {
                FindHelperFragment findHelperFragment = (FindHelperFragment) fragment;
                findHelperFragment.loginInfo();
                if (index == currentTabIndex) {
                    findHelperFragment.webFlush();
                }
            } else if (fragment instanceof NewLifeFragment) {
                NewLifeFragment newLifeFragment = (NewLifeFragment) fragment;
                newLifeFragment.loginInfo();
                if (index == currentTabIndex) {
                    newLifeFragment.webFlush();
                }
            } else if (fragment instanceof MyFragmentWebview) {
                MyFragmentWebview myFragmentWebview = (MyFragmentWebview) fragment;
                myFragmentWebview.loginInfo();
                if (index == currentTabIndex) {//|| isUpdateInfoFromWebView == true
                    myFragmentWebview.webFlush();
                    isUpdateInfoFromWebView = false;
                }
            }
        }
    }


    private void hideAllFragments(FragmentTransaction transaction) {
        int fragmentsCount = fragments.length;
        for (int i = 0; i < fragmentsCount; i++) {
            Fragment fragment = fragments[i];
            if (fragment != null && fragment.isAdded()) {
                transaction.hide(fragments[currentTabIndex]);
            }
        }
        if (currentTabIndex != -1) {
            RelativeLayout restoreLayout = mTabs[currentTabIndex];
            int count = restoreLayout.getChildCount();
            for (int j = 0; j < count; j++) {
                View childView = restoreLayout.getChildAt(j);
                childView.setSelected(false);
            }
        }
    }


    private void setBottomSelectedStatus(int index) {
        RelativeLayout restoreLayout = mTabs[index];
        int count = restoreLayout.getChildCount();
        for (int i = 0; i < count; i++) {
            View childView = restoreLayout.getChildAt(i);
            childView.setSelected(true);
        }
    }


//    @SuppressLint("MissingSuperCall")
//    @Override
//    protected void onRestoreInstanceState(Bundle savedInstanceState) {
//        currentTabIndex = savedInstanceState.getInt("position");
//        super.onRestoreInstanceState(savedInstanceState);
//    }

    // 当activity非正常销毁时被调用
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        if (fragments != null && fragments.length > 0) {
            int count = 0;
            FragmentManager fragmentManager = getSupportFragmentManager();
            for (Fragment fragment : fragments) {
                if (fragment != null && fragment.isAdded() && null != fragmentManager.findFragmentByTag(tags[count])) {
                    fragmentManager.putFragment(outState, tags[count], fragment);
                }
                count++;
            }
        }
        outState.putInt("position", currentTabIndex);
    }

//    // 重置Fragment
//    private void updateFragment(Bundle outState) {
//
//        mFm = getFragmentManager();
//        if (outState == null) {
//            FragmentTransaction transaction = mFm.beginTransaction();
//            OneFragment oneFragment = new OneFragment();
//            mCurrentFragmen = oneFragment;
//            transaction.add(R.id.fl_show, oneFragment, mFragmentTagList[0]).commitAllowingStateLoss();
//        } else {
//            // 通过tag找到fragment并重置
//            OneFragment oneFragment = (OneFragment) mFm.findFragmentByTag(mFragmentTagList[0]);
//            TwoFragment twoFragment = (TwoFragment) mFm.findFragmentByTag(mFragmentTagList[1]);
//            ThreeFragment threeFragment = (ThreeFragment) mFm.findFragmentByTag(mFragmentTagList[2]);
//            mFm.beginTransaction().show(oneFragment).hide(twoFragment).hide(threeFragment);
//        }
//    }


    /**
     * 初始化角色信息
     */
    public void initLoginRole() {
        unreadChatmessageCount.setVisibility(View.GONE);
        int fragmentSize = fragments.length;
        for (int i = 0; i < fragmentSize; i++) {
            BaseFragment fragment = (BaseFragment) fragments[i];
            if (fragment != null && fragment.isAdded()) {
                fragment.initFragmentData();
            }
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mReactInstanceManager.onActivityResult(AppMainActivity.this, requestCode, resultCode, data);
        UMShareAPI.get(this).onActivityResult(requestCode, resultCode, data);

        switch (resultCode) {
            case Constance.EXIT_LOGIN:
                Intent intent = new Intent(AppMainActivity.this, LoginActivity.class);
                startActivity(intent);
                finish();
                return;
            case Constance.LOGIN_SUCCESS: //登录成功 重新加载所有的数据
                initLoginRole();
                break;
            case Constance.FIND_WORKER_CALLBACK: //找帮手消息回调
                onTabClicked(getmTabs()[1]);
                if (!isUpdateInfoFromWebView) {
                    findViewById(R.id.layout).setVisibility(View.VISIBLE);
                }
                break;
            case Constance.UPGRADE: //群聊升级为班组
                NewMsgActivity.actionStart(this, (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE));
                break;
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //创建班组、班组、项目组
                //如果是true则直接进入项目组聊天,否则进入我的项目班组页面
                if (data.getBooleanExtra(Constance.IS_ENTER_GROUP, true)) {
                    NewMsgActivity.actionStart(this, (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE));
                } else {
                    MyGroupTeamActivity.actionStart(this);
                }
                break;
            case Constance.CLICK_GROUP_CHAT://去班组、项目组、群聊
                NewMsgActivity.actionStart(this, (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE));
                break;
            case Constance.CLICK_SINGLECHAT://去单聊
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                MessageUtil.addTeamOrGroupToLocalDataBase(AppMainActivity.this, null, groupDiscussionInfo, false);
                NewMsgActivity.actionStart(this, groupDiscussionInfo);
                break;
            case ProductUtil.PAID_GO_TO_ORDERLIST: //查看订单
                MyOrderListActivity.actionStart(this);
                break;
            case Constance.SCAN_CODE_JUMP_DEVICE://扫描二维码进入设备管理界面
                X5WebViewActivity.actionStart(this, data.getStringExtra("url"));
                break;
            case Constance.MAIN_GAGE_ONE://回到首页底部导航栏
                onTabClicked(getmTabs()[0]);
                if (!isUpdateInfoFromWebView) {
                    findViewById(R.id.layout).setVisibility(View.VISIBLE);
                }
                break;
            case Constance.SAVE_BATCH_ACCOUNT://从班组中批量记账，一人记多天保存成功后，直接跳转到记工流水界面 再从记工流水界面返回时，直接返回首页
                if (data != null) {
                    String id = data.getStringExtra(Constance.ID); //记账人id
                    String accountName = data.getStringExtra(Constance.USERNAME);//记账人名称
                    String pid = data.getStringExtra(Constance.PID); //项目id
                    String proName = data.getStringExtra(Constance.PRONAME); //项目名称
                    String year = data.getStringExtra(Constance.YEAR); //年
                    String month = data.getStringExtra(Constance.MONTH); //月
                    RememberWorkerInfosActivity.actionStart(this, year, month, id, accountName, pid, proName, true);
                }
                break;
            case Constance.INFOMATION: //新开webview进来回调
//                MyFragmentWebview baseFragment4 = (MyFragmentWebview) fragments[4];
//                baseFragment4.loginInfo();
                break;
            case Constance.SCAN_MEETING_SUCCESS://扫描成功打开网页
                X5WebViewActivity.actionStart(this, data.getStringExtra("url"));
                break;
            case Constance.UPDATE_TEL_SUCCESS:
                //修改手机号码成功
                for (Fragment fragment : fragments) {
                    if (fragment instanceof MyFragmentWebview && fragment.isAdded()) {
                        final MyFragmentWebview myFragmentWebview = (MyFragmentWebview) fragment;
                        myFragmentWebview.editMobileSuccess();
                        myFragmentWebview.getWebView().loadUrl(Utils.getUrl(myFragmentWebview.getUrl()));
                        break;
                    }
                }
                break;
            case Constance.OPEN_WECHAT_WERVICE:
                //开通微信服务成功
                Fragment fragment = fragments[currentTabIndex];
                if (fragment != null && fragment.isAdded()) {
                    if (fragment instanceof FindHelperFragment) {
                        FindHelperFragment findHelperFragment = (FindHelperFragment) fragment;
                        findHelperFragment.bindWechatSuccess();
                    } else if (fragment instanceof NewLifeFragment) {
                        NewLifeFragment newLifeFragment = (NewLifeFragment) fragment;
                        newLifeFragment.bindWechatSuccess();
                    } else if (fragment instanceof MyFragmentWebview) {
                        LUtils.e("------绑定微信成功-------333333--");
                        MyFragmentWebview myFragmentWebview = (MyFragmentWebview) fragment;
                        myFragmentWebview.bindWechatSuccess();
                    }
                }
                break;
            case Constance.SEND_ADD_FRIEND_SUCCESS:
                //发送添加好友后需要改变状态为已发送
                fragment = fragments[currentTabIndex];
                if (fragment instanceof NewLifeFragment) {
                    NewLifeFragment newLifeFragment = (NewLifeFragment) fragment;
                    newLifeFragment.addFriendSuccess();
                }
                break;
        }
        Fragment fragment = fragments[currentTabIndex];
        if (fragment != null && fragment.isAdded()) {
            fragment.onActivityResult(requestCode, resultCode, data);
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        LUtils.e("onDestory");
        SocketManager.getInstance(getApplicationContext()).clearWebSocket();
        stopSocketHeartService();
        if (null != networkChangeReceiver) {
            unregisterReceiver(networkChangeReceiver);
        }
        if (null != mReactInstanceManager) {
            mReactInstanceManager.getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("offDid", "");
        }
        if (broadcastReceiver != null) {
            LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);
        }
        closeDB();
    }

    /**
     * 关闭重连和心跳服务
     */
    public void stopSocketHeartService() {
        stopService(new Intent(this, WebSocketHeartRateService.class)); //停止发送WebSocket心跳
//        stopService(new Intent(this, WebSocketReconnectionService.class)); //停止连接
    }

    /**
     * 设置定位城市
     */
    private void setLocationCityName() {
        LoctionUtils loctionUtils = new LoctionUtils(this, new LoctionUtils.LoctionListener() {
            @Override
            public void loctionFail() {
            }

            @Override
            public void loctionSuccess(String city_name) {
            }
        });
        loctionUtils.initLoc();
    }

    private void closeDB() {
        BaseInfoService.getInstance(getApplicationContext()).closeDB();
        HuangliBaseInfoService.getInstance(getApplicationContext()).closeDB();
        ProCloudService.getInstance(getApplicationContext()).closeDB();//关闭云盘数据库
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(WebSocketConstance.SENDMESSAGE); //自己给别人发消息
        filter.addAction(WebSocketConstance.RECEIVEMESSAGE); //获取聊天信息推送
        filter.addAction(Constance.SEND_HTML5_COMMENT); //小视频 评论回调
        filter.addAction(WebSocketConstance.ACTION_UPDATEUSERINFO); //更新个人资料
        filter.addAction(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS); //加载首页数据成功后
        filter.addAction(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR); //加载首页数据失败后
        filter.addAction(WebSocketConstance.LOAD_CHAT_LIST); //加载聊聊列表数据
        filter.addAction(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST); //重新加载首页和聊聊列表本地数据
        filter.addAction(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST); //重新调用Http接口加载首页数据以及 加载读取聊聊本地数据库数据
        filter.addAction(WebSocketConstance.RED_DOTMESSAGE); //有人添加好友时的小红点
        filter.addAction(Constance.SET_INDEX); //设置首页项目组、班组成功后的回调
        filter.addAction(WebSocketConstance.MSGREADTOSENDER); //有人读了我的消息
        filter.addAction(Constance.HIDE_NEWLIFE_RED_DOT); //隐藏新生活红点
        filter.addAction(Constance.SWITCH_ROLER_BROADCAST); //切换角色广播
        filter.addAction(WebSocketConstance.CANCEL_CHAT_MAIN_INDEX_SUCCESS); //取消首页调用http接口数据
        filter.addAction(Constance.ADD_SENDING_MSG_ACTION); //检查消息发送状态
        filter.addAction(Constance.ADD_SENDSUCCESS_MSG_ACTION); //消息发送成功
        filter.addAction(Constance.ACCOUNT_INFO_CHANGE); //当记账数据发生变化时的调用
        filter.addAction(SocketManager.SOCKET_OPEN); //当记账数据发生变化时的调用
        filter.addAction(WebSocketConstance.OPEN_OR_HIDE_BOTTOM_MENU); //当记账数据发生变化时的调用
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
        registerNetworkReiver();
    }

    /**
     * 注册网络状态变化广播
     */
    private NetworkChangeReceiver networkChangeReceiver;

    public void registerNetworkReiver() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
        networkChangeReceiver = new NetworkChangeReceiver();
        registerReceiver(networkChangeReceiver, intentFilter);
    }


    public void handlerNewWorkCircleAndChatFragment(String action, Intent intent) {
        for (Fragment fragment : fragments) {
            if (fragment == null || !fragment.isAdded()) {
                continue;
            }
            if (fragment instanceof CalendarMainFragment) {
                CalendarMainFragment workCirlceFragment = (CalendarMainFragment) fragment;
                workCirlceFragment.handlerBroadcastData(action, intent);
            } else if (fragment instanceof ChatFragment) {
                ChatFragment chatFragment = (ChatFragment) fragment;
                chatFragment.handlerBroadcastData(action, intent);
            }
        }
    }

    public void handlerChatFragment(String action, Intent intent) {
        for (Fragment fragment : fragments) {
            if (fragment == null || !fragment.isAdded()) {
                continue;
            }
            if (fragment instanceof ChatFragment) {
                ChatFragment chatFragment = (ChatFragment) fragment;
                chatFragment.handlerBroadcastData(action, intent);
                return;
            }
        }
    }

    public void handlerNewWorkCircleFragment(String action, Intent intent) {
        for (Fragment fragment : fragments) {
            if (fragment == null || !fragment.isAdded()) {
                continue;
            }
            if (fragment instanceof CalendarMainFragment) {
                CalendarMainFragment newWorkCirlceFragment = (CalendarMainFragment) fragment;
                newWorkCirlceFragment.handlerBroadcastData(action, intent);
                return;
            }
        }
    }

    @Override
    public void invokeDefaultOnBackPressed() {
        super.onBackPressed();
        LUtils.e("========invokeDefaultOnBackPressed===========");
    }


    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                String action = intent.getAction();
                switch (action) {
                    case Constance.ACCOUNT_INFO_CHANGE:
                        getMainCalendarFragment().handlerBroadcastData(action, intent);
                        break;
                    case Constance.SWITCH_ROLER_BROADCAST: //切换角色
                        for (Fragment fragment : fragments) {
                            if (fragment != null && fragment.isAdded() && fragment instanceof FindHelperFragment) {
                                final FindHelperFragment findHelperFragment = (FindHelperFragment) fragment;
                                findHelperFragment.getWebView().loadUrl(Utils.getUrl(findHelperFragment.getUrl()));
                                findHelperFragment.getWebView().postDelayed(new Runnable() {
                                    @Override
                                    public void run() {
                                        findHelperFragment.getWebView().clearHistory();
                                    }
                                }, 1000);
                                break;
                            }
                        }
                        initLoginRole();
                        break;
                    case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN: //刷新首页数据
                        handlerNewWorkCircleFragment(action, intent);
                        break;
                    case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS: //加载首页Http接口单条数据成功后发送的广播
                        handlerNewWorkCircleAndChatFragment(action, intent);
                        break;
                    case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR: //加载首页Http接口单条数据失败后发送的广播
                        handlerNewWorkCircleFragment(action, intent);
                        break;
                    case WebSocketConstance.LOAD_CHAT_LIST: //加载聊聊列表http接口成功后发送的广播
                        handlerNewWorkCircleAndChatFragment(action, intent);
                        break;
                    case WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST: //调用Http重新加载首页数据  并且重新加载聊聊本地数据
                        handlerNewWorkCircleAndChatFragment(action, intent);
                        break;
                    case WebSocketConstance.CANCEL_CHAT_MAIN_INDEX_SUCCESS: //取消首页
                        handlerNewWorkCircleFragment(action, intent);
                        break;
                    case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST: //只要接收到这个表示就刷新首页和聊聊数据库数据
                        handlerNewWorkCircleAndChatFragment(action, intent);
                        break;
                    case Constance.SET_INDEX: //设置首页项目组、班组
                        boolean isEnterMyGroupActivity = intent.getBooleanExtra(Constance.IS_ENTER_GROUP, false);
                        if (isEnterMyGroupActivity) {
                            MyGroupTeamActivity.actionStart(AppMainActivity.this);
                        }
                        break;
                    case WebSocketConstance.SENDMESSAGE: //发送单条消息回执
                        MessageBean bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        if (TextUtils.isEmpty(bean.getUser_info().getHead_pic())) {
                            bean.getUser_info().setHead_pic(UclientApplication.getHeadPic(AppMainActivity.this));
                        }
                        //消息发送状态成功
                        bean.setMsg_state(0);
                        //保存更新数据库
                        LUtils.e("-------AAA----SENDMESSAGE-------");
                        ThreadPoolManager.getInstance().executeSaveSendMessage(bean, null);
                        //当发送通知没选择全部人的时候，就不需要在聊天组中显示
                        if (bean.getSys_msg_type().equals(MessageType.WORK_MESSAGE_TYPE)) {
                            return;
                        }
                        //更新聊聊列表最新的一条消息
                        MessageUtil.modityLocalTeamGroupInfo(AppMainActivity.this, null, null, null, bean.getGroup_id(), bean.getClass_type(),
                                null, MessageUtils.getMsg_Text(bean), null, null, bean.getSend_time(),
                                null, bean.getUser_info().getReal_name(), bean.getMsg_sender(), null);
                        break;
                    case WebSocketConstance.RECEIVEMESSAGE: //接收的消息回调
                        LUtils.e("接收到消息" + "--------111------");
                        ArrayList<MessageBean> beanList = (ArrayList<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);

                        if (beanList != null && beanList.size() > 0) {
                            LUtils.e("接收到消息" + "--------222------" + new Gson().toJson(beanList));
                            ThreadPoolManager.getInstance().executeReceiveMessage(beanList, AppMainActivity.this, true);
//                            handlerNewWorkCircleAndChatFragment(action, intent);
                        }
                        break;
                    case WebSocketConstance.GET_CALLBACK_OPERATIONMESSAGE: //接收 / 已读 回执接口
                        //回执类型（readed 已读 / received 接收 ）
                        //回执消息收到成功
                        NewMessageUtils.offline_message_str = "";
                        ArrayList<MessageBean> callBackList = (ArrayList<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        if (callBackList != null && callBackList.size() > 0) {
                            for (MessageBean messageBean : callBackList) {
                                //回执成功更新数据库状态
                                ThreadPoolManager.getInstance().executeupdateMsgCallbanckReceived(messageBean);
                                if (messageBean.getType().equals(WebSocketConstance.RECEIVED)) {
                                    DBMsgUtil.getInstance().updateMaxAskedId(messageBean);
                                } else if (messageBean.getType().equals(WebSocketConstance.READED)) {
                                    DBMsgUtil.getInstance().updateMaxReadedId(messageBean);
                                }
                            }
                        }
                        break;
                    case WebSocketConstance.RED_DOTMESSAGE://添加好友的小红点
                        MessageBean messageBean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        String msgType = messageBean.getMsg_type();
                        String groupId = messageBean.getGroup_id();
                        String classType = messageBean.getClass_type();
                        if (MessageType.WORK_REPLY.equals(msgType)) { //首页工作回复小红点
                            MessageUtil.updateMainGroupWorkReplyCount(AppMainActivity.this, groupId, classType);
                        } else if (MessageType.MSG_SAFE_STRING.equals(msgType) ||
                                MessageType.MSG_QUALITY_STRING.equals(msgType) ||
                                MessageType.MSG_LOG_STRING.equals(msgType) ||
                                MessageType.MSG_INSPECT_STRING.equals(msgType) ||
                                MessageType.MSG_TASK_STRING.equals(msgType) ||
                                MessageType.MSG_NOTICE_STRING.equals(msgType) ||
                                MessageType.MSG_APPROVAL_STRING.equals(msgType) ||
                                MessageType.MSG_METTING_STRING.equals(msgType) ||
                                MessageType.MSG_GROUP_BILL.equals(msgType)) { //如果收到这些小红点 需要更改首页的未读小红点
                            if (UclientApplication.getUid().equals(messageBean.getMsg_sender())) { //如果是自己给自己发送的则不用设置小红点
                                return;
                            }
                            MessageUtil.updateMainModuleCount(AppMainActivity.this, groupId, classType, msgType);
                        } else if (MessageType.SET_AGENCY.equals(msgType)) { //设置代班长信息
                            if (TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
                                return;
                            }
                            MessageUtil.getWorkCircleData(AppMainActivity.this); //重新请求首页数据
                        } else if (MessageType.MSG_FIND_RED.equals(msgType)) { //发现的推送 小红点
                            discoveredView.setVisibility(View.VISIBLE);
                            //刷新发现里面未都数
                            flushNewlife();
                        } else {
                            handlerChatFragment(action, intent);
                        }
                        break;
                    case WebSocketConstance.MSGREADTOSENDER:
                        //有人读了我发送的消息
                        beanList = (ArrayList<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        for (int i = 0; i < beanList.size(); i++) {
                            DBMsgUtil.getInstance().updateMessageReadedToSender(beanList.get(i));
                        }
                        break;
                    case Constance.HIDE_NEWLIFE_RED_DOT:
                        discoveredView.setVisibility(View.GONE);
                        DataUtil.UpdateLoginver(AppMainActivity.this);
                        flushNewlife();
                        break;
                    case Constance.ADD_SENDING_MSG_ACTION:
                        //增加发送中消息
                        bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        if (null != bean) {
                            LUtils.e(bean.getLocal_id() + "----检查聊天消息发送中---增加成功----" + bean.getMsg_text());
                            sendingMessageBean.add(bean);
                        }
                        break;
                    case Constance.ADD_SENDSUCCESS_MSG_ACTION:
                        //增加发送中消息
                        bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                        if (null != bean) {
                            if (sendingMessageBean.contains(bean)) {
                                LUtils.e(bean.getLocal_id() + "----检查聊天消息发送成功---一移除成功----" + sendingMessageBean.contains(bean));
//                                sendingMessageBean.remove(bean);
                            }
                        }
                        break;
                    case SocketManager.SOCKET_OPEN:
                        if (TextUtils.isEmpty(NewMessageUtils.offline_message_str)) {
                            return;
                        }
                        MessageUtils.getCallBackOperationMessage(AppMainActivity.this, NewMessageUtils.offline_message_str, WebSocketConstance.RECEIVED);
                        break;
                    case WebSocketConstance.OPEN_OR_HIDE_BOTTOM_MENU:
                        //显示隐藏底部
                        String status = intent.getStringExtra("statue");
                        if (!TextUtils.isEmpty(status)) {
                            findViewById(R.id.layout).setVisibility(status.equals("hide") ? View.GONE : View.VISIBLE);

                        }
                        break;
                    case WebSocketConstance.ACTION_UPDATEUSERINFO:
                        //完善了个人资料
                        refreshRN();
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void refreshRN() {
        String currentTabStr;
        if (currentTabIndex == 2) {
            currentTabStr = "job";
        } else if (currentTabIndex == 3) {
            currentTabStr = "find";
        } else if (currentTabIndex == 4) {
            currentTabStr = "my";
        } else {
            currentTabStr = "";
        }
        String info = DataUtil.getLoginInfo(UclientApplication.getInstance(), currentTabStr);
        mReactInstanceManager.getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("refreshRN", info);
        LUtils.e("-----------------ACTION_UPDATEUSERINFO---------" + info);

    }

    /**
     * 刷新新生活内部红点
     */
    public void flushNewlife() {
        String currentTabStr;
        if (currentTabIndex == 2) {
            currentTabStr = "job";
        } else if (currentTabIndex == 3) {
            currentTabStr = "find";
        } else if (currentTabIndex == 4) {
            currentTabStr = "my";
        } else {
            currentTabStr = "";
        }
        for (Fragment fragment : fragments) {
            if (fragment != null && fragment.isAdded() && fragment instanceof RNNewLifeFragment) {
                //完善了个人资料
                String info = DataUtil.getLoginInfo(UclientApplication.getInstance(), currentTabStr);
                mReactInstanceManager.getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("refreshRN", info);
                LUtils.e("--------flushNewlife---------ACTION_UPDATEUSERINFO---------" + info);
            }
        }


    }

    public TextView getUnreadChatmessageCount() {
        return unreadChatmessageCount;
    }


    public RelativeLayout[] getmTabs() {
        return mTabs;
    }


    public void setGroupChatCount(int unreadChatMessageCount) {
        TextView unreadChatmessageCount = AppMainActivity.this.unreadChatmessageCount;
        if (unreadChatMessageCount < 0) {
            unreadChatMessageCount = 0;
        }
        if (unreadChatMessageCount != 0) {//聊聊未读数大于0 显示未读数
            unreadChatmessageCount.setVisibility(View.VISIBLE);
            unreadChatmessageCount.setText(Utils.setMessageCount(unreadChatMessageCount));
        } else {
            unreadChatmessageCount.setVisibility(View.GONE);
        }
    }

    /**
     * 网络状态receiver
     */
    class NetworkChangeReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            ConnectivityManager mConnectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
            //网络连接状态管理
            NetworkInfo netInfo = mConnectivityManager.getActiveNetworkInfo();
            boolean isConnectionNet = false;
            if (netInfo != null && netInfo.isAvailable()) {
                SocketManager.getInstance(getApplicationContext()).reconnectNow();//wify 4g切换重连websocket
                //网络连接
                if (netInfo.getType() == ConnectivityManager.TYPE_WIFI || netInfo.getType() == ConnectivityManager.TYPE_ETHERNET || netInfo.getType() == ConnectivityManager.TYPE_MOBILE) {
                    isConnectionNet = true;
                }
            } else {   //网络断开
                isConnectionNet = false;
            }
//            ChangeFragementNetWorkState(isConnectionNet ? "mobile" : "none");
            intent.putExtra(Constance.BEAN_BOOLEAN, isConnectionNet);
            handlerNewWorkCircleAndChatFragment(ConnectivityManager.CONNECTIVITY_ACTION, intent);
        }

    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[],
                                           int[] grantResults) {
        if (requestCode == Constance.REQUEST || requestCode == Constance.REQUEST_CAPTURE) {
            LUtils.e("===========onRequestPermissionsResult=====11========");

            Fragment fragment = fragments[currentTabIndex];
            if (fragment == null || !fragment.isAdded()) {
                return;
            }
            if (fragment instanceof MyFragmentWebview) {
                ((MyFragmentWebview) fragment).showShareDialog(requestCode == Constance.REQUEST ? true : false);
            } else if (fragment instanceof FindHelperFragment) {
                ((FindHelperFragment) fragment).showShareDialog(requestCode == Constance.REQUEST ? true : false);
            } else if (fragment instanceof NewLifeFragment) {
                ((NewLifeFragment) fragment).showShareDialog(requestCode == Constance.REQUEST ? true : false);
            }
        } else if (requestCode == Constance.REQUEST_LOCAL) {
            setLocationCityName();
        }
    }

    public CalendarMainFragment getMainCalendarFragment() {
        for (Fragment fragment : fragments) {
            if (fragment != null && fragment.isAdded() && fragment instanceof CalendarMainFragment) {
                return (CalendarMainFragment) fragment;
            }
        }
        return null;
    }

    /**
     * url scheme跳转
     *
     * @param intent
     */
    private void urlSchemeJump(Intent intent) {
        if (intent != null) {
            String url = intent.getStringExtra(Constance.COMPLETE_SCHEME);
            if (!TextUtils.isEmpty(url) && !url.equals("")) {
                LUtils.e("url scheme 通过intent接收" + url);
                if (url.equals(Constance.SCHEME_TYPE.JOB)) {

                    onTabClicked(getmTabs()[2]);
                } else if (url.equals(Constance.SCHEME_TYPE.FIND)) {

                    onTabClicked(getmTabs()[3]);
                } else if (url.equals(Constance.SCHEME_TYPE.MY)) {

                    onTabClicked(getmTabs()[4]);
                } else {
                    url = url.replace(Constance.SCHEME, NetWorkRequest.WEBURLS);
                    X5WebViewActivity.actionStart1(UclientApplication.getInstance().getTopActivity(), url);
                }
            }
        }
    }

    private void checkGpsLocationPermission() {
        LocationManager lm = (LocationManager) getSystemService(LOCATION_SERVICE);
        boolean noLocationPermission = ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this,
                        Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean ok = false;
        if (lm != null) {
            ok = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
        }

        if (!ok && !isShowGpsServiceDialog) {
            noGpsService();
        } else if (ok && noLocationPermission && !isShowPermissionDialog) {
            noLocationPermission();
        }

    }

    private void noLocationPermission() {
        dialog = new DialogLeftRightBtnConfirm(this,
                "定位服务已关闭", "开启定位服务你将获取到附近的招工信息，请到设置 > 应用管理 > 吉工家 > 权限管理中开启。帮助你快速找到满意的工作。", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {
                dialog.dismiss();
            }

            @Override
            public void clickRightBtnCallBack() {
                Intent mIntent = new Intent();
                mIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                if (Build.VERSION.SDK_INT >= 9) {
                    mIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
                    mIntent.setData(Uri.fromParts("package", getPackageName(), null));
                } else if (Build.VERSION.SDK_INT <= 8) {
                    mIntent.setAction(Intent.ACTION_VIEW);
                    mIntent.setClassName("com.android.settings", "com.android.setting.InstalledAppDetails");
                    mIntent.putExtra("com.android.settings.ApplicationPkgName", getPackageName());
                }
                startActivity(mIntent);


            }
        });
        dialog.setRightBtnText("前往开启");
        dialog.setLeftBtnText("以后设置");
        dialog.show();
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                isShowPermissionDialog = true;
            }
        });
    }

    private void noGpsService() {
        dialog = new DialogLeftRightBtnConfirm(this,
                "位置信息已关闭", "开启手机定位信息（GPS）你将获取到附近的招工信息，帮助你快速找到满意的工作。", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {
                dialog.dismiss();
            }

            @Override
            public void clickRightBtnCallBack() {
                try {
                    Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    startActivityForResult(intent, 0);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        dialog.setRightBtnText("前往开启");
        dialog.setLeftBtnText("以后设置");
        dialog.show();
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                isShowGpsServiceDialog = true;
            }
        });
    }

    /**
     * 返回键监听
     *
     * @param keyCode
     * @param event
     * @return
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (fragments[currentTabIndex] instanceof RNHelperFragment) { //找工作回退
                return ((RNHelperFragment) fragments[currentTabIndex]).onKeyUp(keyCode, event) || super.onKeyUp(keyCode, event);
            } else if (fragments[currentTabIndex] instanceof RNNewLifeFragment) {//发现回退
                return ((RNNewLifeFragment) fragments[currentTabIndex]).onKeyUp(keyCode, event) || super.onKeyUp(keyCode, event);
            } else if (fragments[currentTabIndex] instanceof RNMyFragment) {//我的回退
                return ((RNMyFragment) fragments[currentTabIndex]).onKeyUp(keyCode, event) || super.onKeyUp(keyCode, event);

            }
            if (event.getAction() == KeyEvent.ACTION_DOWN) {
                //启动一个意图,回到桌面
                Intent backHome = new Intent(Intent.ACTION_MAIN);
                backHome.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                backHome.addCategory(Intent.CATEGORY_HOME);
                startActivity(backHome);
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }
}

