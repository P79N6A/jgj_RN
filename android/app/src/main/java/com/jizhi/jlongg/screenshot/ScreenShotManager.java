package com.jizhi.jlongg.screenshot;

import android.app.Activity;
import android.widget.FrameLayout;

import com.hcs.uclient.utils.LUtils;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 作者    你的名字
 * 时间    2019-2-19 下午 12:04
 * 文件    MyTest
 * 描述
 */
public class ScreenShotManager {
    /**
     * 大悬浮窗View的实例
     */
    private static ScreenShotView screenShotView;

    /**
     * 将截屏弹框从屏幕上移除
     *
     * @param activity
     */
    public static void removeScreenShotView(Activity activity) {
        synchronized (ScreenShotManager.class) {
            if (screenShotView != null) {
                LUtils.e("移除截屏View:" + screenShotView + "      hashCode:" + screenShotView.hashCode());
                FrameLayout decorFramentLayout = (FrameLayout) activity.getWindow().getDecorView();
                decorFramentLayout.removeView(screenShotView);
                screenShotView = null;
            }
        }
    }

    /**
     * 开启截屏弹框View
     *
     * @param activity
     */
    public static void createScreenShotViewAndStartTimer(final Activity activity, String imagePath) {
        synchronized (ScreenShotManager.class) {
            if (screenShotView == null) {
                screenShotView = new ScreenShotView(activity);
                screenShotView.loadScreenShotImage(imagePath);
                FrameLayout frameLayout = (FrameLayout) activity.getWindow().getDecorView();
                frameLayout.addView(screenShotView);
                LUtils.e("创建截屏View:" + screenShotView + "      hashCode:" + screenShotView.hashCode());
            }
            //延迟三秒后 需要消失弹框
            new Timer().schedule(new TimerTask() {
                public void run() {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            removeScreenShotView(activity);
                        }
                    });
                }
            }, 5000);
        }
    }
}
