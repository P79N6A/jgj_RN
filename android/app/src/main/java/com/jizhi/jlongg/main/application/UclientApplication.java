package com.jizhi.jlongg.main.application;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.support.annotation.NonNull;
import android.support.multidex.MultiDex;
import android.text.TextUtils;

import com.BV.LinearGradient.LinearGradientPackage;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mobstat.StatService;
import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.shell.MainReactPackage;
import com.google.gson.Gson;
import com.growingio.android.plugin.rn.GrowingIOPackage;
import com.growingio.android.sdk.collection.Configuration;
import com.growingio.android.sdk.collection.GrowingIO;
import com.hcs.cityslist.widget.CopyDB;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.LoginInfo;
import com.jizhi.jlongg.main.listener.ForegroundCallbacks;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.reactnative.MyReactPackage;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiscCache;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.utils.StorageUtils;
import com.oblador.vectoricons.VectorIconsPackage;
import com.swmansion.gesturehandler.react.RNGestureHandlerPackage;
import com.tencent.smtt.sdk.QbSdk;
import com.tencent.smtt.sdk.TbsListener;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.PushAgent;
import com.umeng.socialize.PlatformConfig;
import com.yanzhenjie.permission.Action;
import com.yanzhenjie.permission.AndPermission;
import com.yanzhenjie.permission.Permission;

import org.android.agoo.huawei.HuaWeiRegister;
import org.android.agoo.mezu.MeizuRegister;
import org.android.agoo.xiaomi.MiPushRegistar;
import org.litepal.LitePal;

import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.Stack;

import static com.hcs.uclient.utils.SPUtils.get;

//import com.tencent.smtt.sdk.QbSdk;

/**
 * application
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-7-28 下午3:22:43
 */
public class UclientApplication extends Application implements ReactApplication {


    public static UclientApplication instance;

    public static Stack<Activity> store;


    /**
     * 异常捕获
     **/
    protected boolean isNeedCaughtExeption = false;// 是否捕获未知异常
    private static final MyReactPackage myReactPackage = new MyReactPackage();
    private ReactContext mReactContext;

    public ReactContext getReactContext() {
        return mReactContext;
    }

    public static MyReactPackage getReactPackage() {
        return myReactPackage;
    }


    public static String getToken(Context context) {
        String token = SPUtils.get(context, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
        return token;
    }

    /**
     * 判断当前用户是否登录
     */
    public static boolean isLogin(Context context) {
        String token = SPUtils.get(context, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
        return !TextUtils.isEmpty(token);
    }

    public static String getTelephone(Context activity) {
        String telphone = get(activity, Constance.TELEPHONE, "", Constance.JLONGG).toString(); //电话号码
        return telphone;
    }


    /**
     * 获取用户状态 记录他正在使用工头还是工友
     */
    public static String getHeadPic(Context context) {
        return get(context, Constance.HEAD_IMAGE, "", Constance.JLONGG).toString(); //头像路径
    }

    /**
     * 获取用户状态 记录他正在使用工头还是工友
     */
    public static String getRealName(Context context) {
        return get(context, Constance.USERNAME, "", Constance.JLONGG).toString(); //头像路径
    }

    /**
     * 获取用户状态 记录他正在使用工头还是工友
     */
    public static String getNickName(Context context) {
        return get(context, Constance.NICKNAME, "", Constance.JLONGG).toString(); //头像路径
    }

    /**
     * 获取用户状态 记录他正在使用工头还是工友
     */
    public static String getRoler(Context context) {
        return SPUtils.get(context, Constance.enum_parameter.ROLETYPE.toString(), Constance.ROLETYPE_WORKER, Constance.JLONGG).toString();
    }

    /**
     * 是否有当前角色
     */
    public static int getIsInfo(Context context) {
        return Integer.parseInt(SPUtils.get(context, Constance.enum_parameter.IS_INFO.toString(), Constance.IS_INFO_NO, Constance.JLONGG).toString());
    }

    /**
     * 当前角色是否是工头
     */
    public static boolean isForemanRoler(Context context) {
        return UclientApplication.getRoler(context).equals(Constance.ROLETYPE_FM);
    }


    /**
     * 获取城市编码
     */
    public static String getCityCode(Context context) {
        String cityno = (String) SPUtils.get(context, "city_code", "510100", Constance.JLONGG);
        if (TextUtils.isEmpty(cityno) || cityno.equals("0")) {
            cityno = "510100";
        }
        return cityno;
    }

    public static String loginInfo() {
        String str;
        if (UclientApplication.isLogin(instance)) {
            String stoken = (String) SPUtils.get(instance, "TOKEN", "", Constance.JLONGG);
            LoginInfo loginInfo = new LoginInfo();
            loginInfo.setOs("A");
            loginInfo.setToken(stoken.replace("A ", ""));
            if (!TextUtils.isEmpty(stoken)) {
                int loginVer = (int) SPUtils.get(instance, Constance.LOGINVER, 0, Constance.JLONGG);
                loginInfo.setInfover(loginVer + "");
            }
            str = new Gson().toJson(loginInfo);
        } else {
            str = "";
        }
        return str;
    }


    /**
     * 是否有登录人 姓名
     */
    public static boolean isHasRealName(Context context) {
        String hasRelaName = SPUtils.get(context, Constance.USERNAME, "", Constance.JLONGG).toString(); // 是否有当前角色
        return TextUtils.isEmpty(hasRelaName) ? false : true;
    }


    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    private ActivityLifecycleCallbacks lifecycleCallback = new ActivityLifecycleCallbacks() {

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            store.add(activity);
            LUtils.e("application:onCreated___" + activity.getClass().getSimpleName());
        }

        @Override
        public void onActivityStarted(Activity activity) {

        }

        @Override
        public void onActivityResumed(Activity activity) {

        }

        @Override
        public void onActivityPaused(Activity activity) {

        }

        @Override
        public void onActivityStopped(Activity activity) {

        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

        }

        @Override
        public void onActivityDestroyed(Activity activity) {
            store.remove(activity);
            LUtils.e("application:onDestroyed__" + activity.getClass().getSimpleName());
        }
    };

    /**
     * 获取栈顶Activity
     *
     * @return
     */
    public Activity getTopActivity() {
        LUtils.e("application top :" + store.lastElement().getClass().getSimpleName());
        return store.lastElement(); //返回栈顶Activity
    }

    /**
     * 结束除了{@link com.jizhi.jlongg.main.AppMainActivity}的所有Activity
     *
     * @param activity
     */
    public void killOthersActivity(Activity activity) {
        if (activity == null) {
            return;
        }
        for (int i = 0, size = store.size(); i < size; i++) {
            if (null != store.get(i) && activity != store.get(i)) {
                store.get(i).finish();
            }
        }
        store.clear();
        store.add(activity);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        UMConfigure.setLogEnabled(LUtils.isDebug);
        store = new Stack<>();
        AddFriendsSources.create();
        registerActivityLifecycleCallbacks(lifecycleCallback);
        LitePal.initialize(this);
        initX5();
        initAnOtherConfiguration();
        initBaiDuLocationConfiguration();
        //注册友盟推送
        initUMeng();
        initImageLoaderConfiguration();
        //初始化ReactContext
        registerReactInstanceEventListener();
        //解决android7.0拍照崩溃问题
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
        }
        GrowingIO.startWithConfiguration(this, new Configuration()
                .trackAllFragments()
                .setChannel(getMete_data("UMENG_CHANNEL"))
                .setTestMode(true)
                .setDebugMode(true)

        );
        //读取百度统计渠道id
        StatService.setAppChannel(instance, getMete_data("UMENG_CHANNEL"), true);
        //百度统计手机java日志
        StatService.setOn(instance, StatService.JAVA_EXCEPTION_LOG);

        ForegroundCallbacks.init(this).addListener(new ForegroundCallbacks.Listener() {
            @Override
            public void onBecameForeground() {
//                LUtils.e("应用回到前台调用重连方法:");
                SocketManager.getInstance(UclientApplication.this).reconnectNow();
            }

            @Override
            public void onBecameBackground() {
//                LUtils.e("应用回到前台调用重连方法:");
            }
        });
        //百度统计上传用户识别ID
        if (!TextUtils.isEmpty(getUid())) {
            StatService.setUserId(instance, getUid());
        }

        OneKeyLoginManager.getInstance().set(getApplicationContext(), "n3EV0KJP", "DEY1Qh9V");
        //设置授权页logo
        initAuthenticationLogo();
        //权限申请
        requestPermission(Permission.READ_PHONE_STATE);
    }

    private void initAuthenticationLogo() {
        /*****************************************电信设置授权页logo方法************************************************/
        OneKeyLoginManager.getInstance().setCTCCImgLogo(R.drawable.key_one_login_icon);
        /*****************************************移动设置授权页logo方法************************************************/
        OneKeyLoginManager.getInstance().setCMCCImgLogo("@drawable/key_one_login_icon");
        /*****************************************联通设置授权页logo方法************************************************/
        OneKeyLoginManager.getInstance().setCUCCImgLogo(R.drawable.key_one_login_icon);
        /*****************************************一键登录页面左上角帮助按钮 是否显示***********************************/
        OneKeyLoginManager.getInstance().setShowHelpBtn(false);
        /*****************************************一键登录页面其他方式登录按钮 是否显示*********************************/
        OneKeyLoginManager.getInstance().setShowOtherBtn(true);
    }

    private void requestPermission(String... permissions) {
        AndPermission.with(this)
                .permission(permissions)
                .onGranted(new Action() {
                    @TargetApi(Build.VERSION_CODES.M)
                    @Override
                    public void onAction(List<String> permissions) {
                        //闪验SDK网络初始化
                        OneKeyLoginManager.getInstance().init();
                        //闪验SDK预取号（可选，能加速拉起授权页）
                        OneKeyLoginManager.getInstance().PreInitiaStart();
                    }
                })
                .onDenied(new Action() {
                    @Override
                    public void onAction(@NonNull List<String> permissions) {
                    }
                }).start();
    }

    public String getMete_data(String key) {
        String value = "";
        try {
            ApplicationInfo appInfo = getPackageManager().getApplicationInfo(getPackageName(),
                    PackageManager.GET_META_DATA);
            value = appInfo.metaData.getString(key);
            LUtils.e(key + ",," + value);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return value;
    }

    /**
     * 初始化common库
     * 参数1:上下文，不能为空
     * 参数2:设备类型，UMConfigure.DEVICE_TYPE_PHONE为手机、UMConfigure.DEVICE_TYPE_BOX为盒子，默认为手机
     * 参数3:Push推送业务的secret,需要集成Push功能时必须传入Push的secret
     */
    public void initUMeng() {
        if (LUtils.isDebug) {
            // 测试环境下设置成预览版
//            LUtils.e("-------测试环境下设置成预览版-------" );
            com.umeng.socialize.Config.setMiniPreView();
        }
        UMConfigure.init(this, UMConfigure.DEVICE_TYPE_PHONE, "9e795ed17c5cd0ed0181ea0a72068e5b");
        PushAgent mPushAgent = PushAgent.getInstance(this);
        //注册推送服务，每次调用register方法都会回调该接口
        mPushAgent.setNotificaitonOnForeground(false);
        mPushAgent.setDisplayNotificationNumber(8);
        mPushAgent.register(iUmengRegisterCallback);
        //小米推送 XIAOMI_ID  XIAOMI_KEY
        MiPushRegistar.register(this, "2882303761517438356", "5391743851356");
        //华为推送
        HuaWeiRegister.register(this);
        //魅族推送
        MeizuRegister.register(this, "112621", "cb563e5d746849319c39df2803b68fef");
        //分享
        PlatformConfig.setWeixin("wx0d7055be43182b5e", "d4624c36b6795d1d99dcf0547af5443d");
        PlatformConfig.setQQZone("1105013029", "tVZttNSBO9NTAIIU");
    }

    public void initX5() {
        QbSdk.PreInitCallback cb = new QbSdk.PreInitCallback() {
            @Override
            public void onViewInitFinished(boolean arg0) {
            }

            @Override
            public void onCoreInitFinished() {
            }
        };
        QbSdk.setTbsListener(new TbsListener() {
            @Override
            public void onDownloadFinish(int i) {
                LUtils.e("app" + ",,," + "onDownloadFinish");
            }

            @Override
            public void onInstallFinish(int i) {
                LUtils.e("app" + ",,," + "onInstallFinish");
            }

            @Override
            public void onDownloadProgress(int i) {
//                LUtils.e("app" + ",,," + "onDownloadProgress:" + i);
            }
        });
        QbSdk.initX5Environment(instance, cb);
    }

    /**
     * 初始化其他基础配置
     */
    private final void initAnOtherConfiguration() {
        new CopyDB().initDB(getApplicationContext(), CopyDB.jlongg); //拷贝基础数据库
        new CopyDB().initDB(getApplicationContext(), CopyDB.huangli);//拷贝黄历数据库
        if (isNeedCaughtExeption) { //是否需要捕获异常
            new UnCeHandler(this).cauchException();
        }
    }

    /**
     * 初始化百度定位配置
     */
    private final void initBaiDuLocationConfiguration() {
        try {
            //初始化定位sdk
            SDKInitializer.initialize(getApplicationContext());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 初始化图片加载器
     */
    private final void initImageLoaderConfiguration() {
        File cacheDir = StorageUtils.getOwnCacheDirectory(getApplicationContext(), "imageloader/personal/Cache");
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(
                getApplicationContext())
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .diskCacheFileNameGenerator(new Md5FileNameGenerator())
                .diskCacheSize(50 * 1024 * 1024)// 50 Mb
                .discCache(new UnlimitedDiscCache(cacheDir)) // 自定义缓存路径
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .writeDebugLogs() // Remove for release app
                .build();
        ImageLoader.getInstance().init(config);
    }


    @Override
    public void onTerminate() {
        super.onTerminate();
    }

    /**
     * 获取当前登录人电话号码
     */
    public static String getLoginTelephone(Context context) {
        String telphone = (String) SPUtils.get(context, Constance.TELEPHONE, "", Constance.JLONGG);
        return telphone;
    }

    /**
     * 获得实例
     *
     * @return
     */
    public static UclientApplication getInstance() {
        return instance;

    }

    public static String getUid(Context context) {
        String uid = SPUtils.get(context, Constance.UID, "", Constance.JLONGG).toString(); //用户id
        return uid;
    }

    public static String getUid() {
        String uid = SPUtils.get(instance, Constance.UID, "", Constance.JLONGG).toString(); //用户id
        return uid;
    }

    IUmengRegisterCallback iUmengRegisterCallback = new IUmengRegisterCallback() {
        @Override
        public void onSuccess(String deviceToken) {
            //注册成功会返回device token
            LUtils.e("umeng_deviceToken-----------------------:" + deviceToken);
            String token = SPUtils.get(getApplicationContext(), Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
            if (!isLogin(getApplicationContext())) {
                SPUtils.put(getApplicationContext(), "channelid", deviceToken, Constance.JLONGG);
            }
            if (!TextUtils.isEmpty(token)) {
                DataUtil.bindChannelId(getApplicationContext(), deviceToken);
                SPUtils.put(getApplicationContext(), "channelid", deviceToken, Constance.JLONGG);
            }
        }

        @Override
        public void onFailure(String s, String s1) {
            LUtils.e(s + "--------umeng_deviceToken--------------" + s1);

        }
    };
    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        public boolean getUseDeveloperSupport() {
            return LUtils.isDebug;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new VectorIconsPackage(),
                    new LinearGradientPackage(),
                    new RNGestureHandlerPackage(),
                    // 此处加入GrowingIOPackage
                    new GrowingIOPackage(),
                    //将我们创建的包管理器给添加进来
                    myReactPackage
            );
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    private void registerReactInstanceEventListener() {
        mReactNativeHost.getReactInstanceManager().addReactInstanceEventListener(mReactInstanceEventListener);
    }

    //ReactInstanceManager抽象类，它提供了 ReactInstanceEventListener 接口及相应的添加和删除方法。
    private final ReactInstanceManager.ReactInstanceEventListener mReactInstanceEventListener = new ReactInstanceManager.ReactInstanceEventListener() {
        @Override
        public void onReactContextInitialized(ReactContext context) {
            //初始化ReactContext
            mReactContext = context;
        }
    };
}
