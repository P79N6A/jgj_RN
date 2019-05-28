package com.jizhi.jlongg.reactnative;

import android.app.Activity;
import android.app.Dialog;
import android.os.Build;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.dialog.CustomProgress;

import java.lang.ref.WeakReference;

/**
 * SplashScreen
 * 启动屏
 * from：http://www.devio.org
 * Author:CrazyCodeBoy
 * GitHub:https://github.com/crazycodeboy
 * Email:crazycodeboy@gmail.com
 */
public class SplashScreen {
    private static Dialog mSplashDialog;
    private static WeakReference<Activity> mActivity;
    private static CustomProgress customProgress;

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity, final int themeResId) {
        if (activity == null) return;
        mActivity = new WeakReference<Activity>(activity);
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (!activity.isFinishing()) {
//                    mSplashDialog = new Dialog(activity, themeResId);
//                    mSplashDialog.setContentView(R.layout.activity_loading);
//                    mSplashDialog.setCancelable(false);
//
//                    if (!mSplashDialog.isShowing()) {
//                        mSplashDialog.show();
//                    }
                    createCustomDialog(activity);
                }
            }
        });
    }

    public static void createCustomDialog(Activity activity) {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(activity);
            if (!customProgress.isShowing()) {
                customProgress.show(activity, null, false);

            }
        }
    }

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity, final boolean fullScreen) {
        int resourceId = fullScreen ? R.style.SplashScreen_Fullscreen : R.style.SplashScreen_SplashTheme;

        show(activity, resourceId);
    }

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity) {
        show(activity, true);
    }

    /**
     * 关闭启动屏
     */
    public static void hide(Activity activity) {
        if (activity == null) {
            if (mActivity == null) {
                return;
            }
            activity = mActivity.get();
        }

        if (activity == null) return;

        final Activity _activity = activity;

        _activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
//                if (mSplashDialog != null && mSplashDialog.isShowing()) {
//                    boolean isDestroyed = false;
//
//                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
//                        isDestroyed = _activity.isDestroyed();
//                    }
//
//                    if (!_activity.isFinishing() && !isDestroyed) {
//                        mSplashDialog.dismiss();
//                    }
//                    mSplashDialog = null;
//                    _activity.startActivity(new Intent(_activity, WelcomeActivity.class));
//                    _activity.finish();
                if (customProgress != null && customProgress.isShowing()) {
                    boolean isDestroyed = false;

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                        isDestroyed = _activity.isDestroyed();
                    }

                    if (!_activity.isFinishing() && !isDestroyed) {
                        customProgress.dismiss();
                    }
                    customProgress = null;
                }
            }
        });
    }
}

