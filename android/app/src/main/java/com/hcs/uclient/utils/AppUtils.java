package com.hcs.uclient.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.WindowManager;

import com.google.gson.Gson;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.MobileInfo;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.StringUtil;
import com.jizhi.jlongg.network.NetWorkRequest;

/**
 * 跟App相关的辅助类
 *
 * @author zhy
 */
public class AppUtils {

    private AppUtils() {
        /* cannot be instantiated */
        throw new UnsupportedOperationException("cannot be instantiated");
    }

    /**
     * 获取应用程序名称
     */
    public static String getAppName(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                    context.getPackageName(), 0);
            int labelRes = packageInfo.applicationInfo.labelRes;
            return context.getResources().getString(labelRes);
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * [获取应用程序版本名称信息]
     *
     * @param context
     * @return 当前应用的版本名称
     */
    public static String getVersionName(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionName;

        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * [获取应用程序版本号]
     *
     * @param context
     * @return 当前应用的版本号
     */
    public static int getVersionCode(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;

        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取串号
     */
    public static String getImei(Context context) {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            @SuppressLint("MissingPermission") String imei = telephonyManager.getDeviceId();
            return TextUtils.isEmpty(imei) ? "null" : imei;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取IMEI号，IESI号，手机型号
     */
    public static String getMobileInfo(Context context) {
        WindowManager mWindowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        int mWidth = mWindowManager.getDefaultDisplay().getWidth();
        int mHeight = mWindowManager.getDefaultDisplay().getHeight();
        MobileInfo mInfo = new MobileInfo();
        mInfo.setModel(android.os.Build.MODEL);
        mInfo.setBrand(android.os.Build.BRAND);
        mInfo.setScreenWidth(mWidth);
        mInfo.setScreenHeight(mHeight);
        mInfo.setRelease(android.os.Build.VERSION.RELEASE);
        mInfo.setVerName(getVersionName(context));
        mInfo.setVer(getVersionName(context));
        return new Gson().toJson(mInfo).toString();
    }

    /**
     * 过滤App关键字
     * 群名称中不能包含吉工家、吉工宝、官方；
     *
     * @param proName
     * @return
     */
    public static boolean filterAppImportantWord(Context context, String proName, String hintName, boolean isFileterAppImportantWord) {
        if (StringUtil.isNullOrEmpty(proName)) {
            CommonMethod.makeNoticeShort(context, "请输入" + hintName + "名称", CommonMethod.ERROR);
            return false;
        }
        if (!Utils.JudgeInput(proName)) {
            CommonMethod.makeNoticeShort(context, hintName + "名称只能由数字,字母,汉字组成", CommonMethod.ERROR);
            return false;
        }
        if (isFileterAppImportantWord) {
            if (proName.contains("吉工家") || proName.contains("吉工宝") || proName.contains("官方")) {
                CommonMethod.makeNoticeLong(context, "群名称中不能包含吉工家、吉工宝、官方", CommonMethod.ERROR);
                return false;
            }
        }
        return true;
    }

    /**
     * 分享App
     *
     * @param activity
     */
    public static void shareApp(Activity activity) {
        if (Build.VERSION.SDK_INT >= 23) {
            String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
            ActivityCompat.requestPermissions(activity, mPermissionList, Constance.REQUEST);
        } else {
            showShareDialog(activity);
        }
    }


    /**
     * 分享弹窗
     */
    public static void showShareDialog(Activity activity) {
        Share share = new Share();
        share.setTitle("记工账本怕丢失？吉工家手机记工更安全！用吉工家记工，账本永不丢失！");
        share.setDescribe("1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！");
        share.setUrl(NetWorkRequest.WEBURLS + "page/open-invite.html?uid=" + UclientApplication.getUid(activity) + "&plat=person");
        share.setImgUrl(NetWorkRequest.IP_ADDRESS + "media/default_imgs/logo.jpg");
        //微信小程序相关内容
        share.setAppId("gh_89054fe67201");
        share.setPath("/pages/work/index?suid=" + UclientApplication.getUid(activity));
        share.setWxMiniDrawable(2);

        CustomShareDialog dialog = new CustomShareDialog(activity, true, share);
        dialog.showAtLocation(activity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
        BackGroundUtil.backgroundAlpha(activity, 0.5F);
    }



}
