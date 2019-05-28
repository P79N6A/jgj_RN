package com.jizhi.jlongg.reactnative;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.main.activity.AddFriendSendCodectivity;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.activity.RepositoryGridViewActivity;
import com.jizhi.jlongg.main.activity.SetActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.ShareBill;
import com.jizhi.jlongg.main.bean.WebImageBean;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.listener.ShareListener;
import com.jizhi.jlongg.main.listener.RNImpl;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static android.app.Activity.RESULT_OK;

/**
 * CName:3.4.2RN与原生交互
 * User: hcs
 * Date: 2019-4-22
 * Time: 下午 17:07
 */
public class MyNativeModule extends ReactContextBaseJavaModule implements ShareListener, ActivityEventListener {
    public static final String REACT_NATIVE_CLASSNAME = "MyNativeModule";
    public ReactApplicationContext context;
    public static final String EVENT_NAME = "nativeCallRn";
    public static final String TAG = "TAG";
    public static Callback payCallback = null;
    private Callback selectPicCallback = null;
    private RNImpl rnImpl;

    public MyNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
        context.addActivityEventListener(this);

    }

    @Override
    public String getName() {
        //返回的这个名字是必须的，在rn代码中需要这个名字来调用该类的方法。
        return REACT_NATIVE_CLASSNAME;
    }

    //函数不能有返回值，因为被调用的原生代码是异步的，原生代码执行结束之后只能通过回调函数或者发送信息给rn那边。
    @ReactMethod
    public void rnCallNative(String msg) {
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
//        nativeCallRn("回调rn---->" + msg);
    }

    /**
     * rn调用原生获取token
     *
     * @param msg
     * @param callback
     */
    @ReactMethod
    public void getAppToken(String msg, Callback callback) {
        String token = UclientApplication.getToken(context);

        LUtils.e("---------getAppToken--------" + token);
        callback.invoke(token);
    }

    /**
     * 拨打电话
     *
     * @param data 电话号码
     */
    @ReactMethod
    public void appCall(String data) {
        LUtils.e("----MyNativeModule-----appCall-----------" + data);
        CallPhoneUtil.callPhone(context, data);
    }


    /**
     * 底部控制器
     *
     * @param data
     */
    @ReactMethod
    public void footerController(String data) {
        LUtils.e("----footer-------" + data);
        Gson gson = new Gson();
        ShareBill state = gson.fromJson(data, ShareBill.class);
        Intent intent = new Intent(WebSocketConstance.OPEN_OR_HIDE_BOTTOM_MENU);
        intent.putExtra("statue", state.getState());
        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
    }


    /**
     * 跳转原生视图
     *
     * @param name   类名
     * @param params 参数
     */
    @ReactMethod
    public void startActivityFromJS(String name, String params) {
        try {
            LUtils.e(name + "-----MyNativeModule----startActivityFromJS-----------" + params);
            Activity currentActivity = getCurrentActivity();
            if (null != currentActivity) {
                Class toActivity = Class.forName(name);
                Intent intent = new Intent(currentActivity, toActivity);
                intent.putExtra("params", params);
                currentActivity.startActivity(intent);

            }
        } catch (Exception e) {
            throw new JSApplicationIllegalArgumentException(
                    "不能打开Activity : " + e.getMessage());
        }
    }

    /**
     * 复制微信号码并且打开
     *
     * @param data 参数
     */
    @ReactMethod
    public void copyWechatNumber(String data) {
        if (TextUtils.isEmpty(data)) {
            return;
        }
        //添加到剪切板
        ClipboardManager clipboardManager =
                (ClipboardManager) getCurrentActivity().getSystemService(Context.CLIPBOARD_SERVICE);
        assert clipboardManager != null;
        clipboardManager.setPrimaryClip(ClipData.newPlainText(null, data));
        if (clipboardManager.hasPrimaryClip()) {
            clipboardManager.getPrimaryClip().getItemAt(0).getText();
        }

        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(getCurrentActivity(), null, "该微信号: " + data + " 已复制，请在微信中添加朋友时粘贴搜索", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {

            }

            @Override
            public void clickRightBtnCallBack() {
                Utils.OPenWXAPP(getCurrentActivity());
            }
        });
        dialogLeftRightBtnConfirm.show();
        dialogLeftRightBtnConfirm.setLeftBtnText("我知道了");
        dialogLeftRightBtnConfirm.setRightBtnText("打开微信");
    }


    /**
     * 跳转聊天
     *
     * @param data 电话号码
     */
    @ReactMethod
    public void createChat(String data) {
        Gson gson = new Gson();
        LUtils.e("--MyNativeModule---createChat-11----" + data);


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
            LUtils.e("====添加朋友==native===" + AddFriendsSources.create().getSource());
        }
        if (personWorkInfoBean.getIs_chat() == 0) {
            //当为 0 时 跳转到添加朋友的页面
            AddFriendSendCodectivity.actionStart(getCurrentActivity(), personWorkInfoBean.getGroup_id());
            return;
        }

        GroupDiscussionInfo info = new GroupDiscussionInfo();
        info.setGroup_id(personWorkInfoBean.getGroup_id());
        info.setClass_type(personWorkInfoBean.getClass_type());
        info.setGroup_name(personWorkInfoBean.getGroup_name());
        info.setIs_find_job(1);
        info.setVerified(personWorkInfoBean.getVerified());
//        info.setIs_resume(1);
        info.setIs_resume(personWorkInfoBean.getIs_resume());
        if (personWorkInfoBean.getClick_type() != 0) {
            NewMsgActivity.actionStart(getCurrentActivity(), info, personWorkInfoBean);
        } else if (!TextUtils.isEmpty(personWorkInfoBean.getVerified()) && !personWorkInfoBean.getVerified().equals("3")) {
            personWorkInfoBean.setClick_type(3);
            NewMsgActivity.actionStart(getCurrentActivity(), info, personWorkInfoBean);

        } else {
            NewMsgActivity.actionStart(getCurrentActivity(), info);

        }
    }

    /**
     * 分享
     */
    @ReactMethod
    @Override
    public void showShareMenu(String data, Callback callback) {
        LUtils.e("---MyNativeModule--showShareMenu-11----" + data);

        if (null == rnImpl) {
            rnImpl = RNImpl.of(getCurrentActivity());
        } else {
            rnImpl.updateActivity(getCurrentActivity());
        }
        rnImpl.showShareMenu(data, callback);
    }


    /**
     * 上传坐标
     */
    @ReactMethod
    public void getLocation(String data, Callback callback) {
        LUtils.e("---MyNativeModule--getLocation-11----" + data);
        String lat = (String) SPUtils.get(getCurrentActivity(), "lat", "", Constance.JLONGG);
        String lng = (String) SPUtils.get(getCurrentActivity(), "lng", "", Constance.JLONGG);
        if (!TextUtils.isEmpty(lat) && !TextUtils.isEmpty(lng)) {
            callback.invoke(lat + "," + lng);
        }
    }


    /**
     * 打开计算器
     */
    @ReactMethod
    public void openCalculator() {
        Utils.openCalender(getCurrentActivity());

    }

    /**
     * 资料库
     */
    @ReactMethod
    public void openRepository() {
        RepositoryGridViewActivity.actionStart(getCurrentActivity(), null);


    }

    /**
     * 切换身份
     */
    @ReactMethod
    public void chooseRole() {
        ChooseRoleActivity.actionStart(getCurrentActivity(), false);


    }

    /**
     * 打开设置
     */
    @ReactMethod
    public void openSet() {
        LUtils.e("--openSet-------");
        SetActivity.actionStart(getCurrentActivity());


    }

    /**
     * 打开网页
     *
     * @param data
     */
    @ReactMethod
    public void openWebView(String data) {
        LUtils.e("----MyNativeModule-----openWebView-----------" + data);
        X5WebViewActivity.actionStart(getCurrentActivity(), NetWorkRequest.WEBURLS + data);
    }

    /**
     * 关闭对话框
     *
     * @param data
     */
    @ReactMethod
    public void closeDialog(String data) {
        LUtils.e("关闭对话框");
        SplashScreen.hide(getCurrentActivity());
    }

    /**
     * Native调用RN
     *
     * @param msg
     */
    public void nativeCallRn(String msg) {
        context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EVENT_NAME, msg);

    }

    @ReactMethod
    public void startActivityRN(String name, String params) {
        Toast.makeText(context, name + ",," + name, Toast.LENGTH_SHORT).show();

        try {
            Activity activity = getCurrentActivity();
            if (activity != null) {
                Class toClass = Class.forName(name);
                Intent intent = new Intent(activity, toClass);
                intent.putExtra("params", params);
                activity.startActivity(intent);
            }
        } catch (Exception ex) {
            throw new JSApplicationIllegalArgumentException("不能打开Activity " + ex.getMessage());
        }
    }

    /**
     * 登录失效
     */
    @ReactMethod
    public void login() {
        DataUtil.removeUserLoginInfo(getCurrentActivity());
        Intent intent = new Intent(getCurrentActivity(), LoginActivity.class);
        getCurrentActivity().startActivityForResult(intent, Constance.REQUEST_LOGIN);
        getCurrentActivity().finish();
    }

    /**
     * 支付
     */
    @ReactMethod
    public void appPay(String data, Callback callback) {
        LUtils.e("---appPay-------" + data);
        Gson gson = new Gson();
        PayBean payBean = gson.fromJson(data, PayBean.class);
        if (payBean.getPay_type() == 1) {
            payCallback = callback;
            ProductUtil.wxPayCallBack(payBean.getRecord_id(), getCurrentActivity());
        } else if (payBean.getPay_type() == 2) {
            ProductUtil.aliPayCallBack(payBean.getRecord_id(), getCurrentActivity(), callback);
        }
    }


    //后面该方法可以用Linking代替
    @ReactMethod
    public void getDataFromIntent(Callback success, Callback error) {
        try {
            Activity currentActivity = getCurrentActivity();
            String result = currentActivity.getIntent().getStringExtra("result");//会有对应数据放入
            if (!TextUtils.isEmpty(result)) {
                success.invoke(result);
            }
        } catch (Exception ex) {
            error.invoke(ex.getMessage());
        }
    }

    /**
     * Callback 方式
     * rn调用Native,并获取返回值
     *
     * @param msg
     * @param callback
     */
    @ReactMethod
    public void rnCallNativeFromCallback(String msg, Callback callback) {
        Log.e("-----------", msg);

        String result = "hello RN！Native正在处理你的callback请求";
        // .回调RN,即将处理结果返回给RN
        callback.invoke(result);
    }

    /**
     * Promise
     *
     * @param msg
     * @param promise
     */
    @ReactMethod
    public void rnCallNativeFromPromise(String msg, Promise promise) {
        Log.e(TAG, "rnCallNativeFromPromise");
        String result = "hello RN！Native正在处理你的promise请求";
        promise.resolve(result);
    }

    /**
     * 向RN传递常量
     */
    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> params = new HashMap<>();
        params.put("Constant", "我是Native常量，传递给RN");
        return params;
    }

    /**
     * 图片单选
     */
    @ReactMethod
    public void singleSelectPicture(String data, Callback callback) {
        LUtils.e("---MyNativeModule--showShareMenu-11----" + data);
        CameraPop.singleSelector(getCurrentActivity(), null);
        selectPicCallback = callback;
    }

    /**
     * 图片单选
     */
    @ReactMethod
    public void previewImage(String data) {
        LUtils.e("---------------:" + data);
        WebImageBean webImageBean = new Gson().fromJson(data, WebImageBean.class);
        ArrayList<String> list = webImageBean.getImgData();
        for (int i = 0; i < list.size(); i++) {
            list.set(i, webImageBean.getImgDiv() + list.get(i));
        }
        LoadCloudPicActivity.actionStart(getCurrentActivity(), list, webImageBean.getImgIndex() + 1);
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        LUtils.e(requestCode + ",,,,,,,,222,,,,," + resultCode);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            if (null != selectPicCallback) {
                List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
                LUtils.e(new Gson().toJson(mSelected));
                selectPicCallback.invoke(new Gson().toJson(mSelected));
                selectPicCallback = null;
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent) {

    }
}
