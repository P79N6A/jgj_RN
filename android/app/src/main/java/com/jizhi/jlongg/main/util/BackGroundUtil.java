package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.view.Window;
import android.view.WindowManager;

/**
 * 功能: 设置透明度
 * 作者：Xuj
 * 时间: 2016-6-1 18:25
 */
public class BackGroundUtil {

    /**
     * 设置添加屏幕的背景透明度
     *
     * @param bgAlpha
     */
    public static void backgroundAlpha(Activity activity, float bgAlpha) {
        Window window = activity.getWindow();
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.alpha = bgAlpha; //0.0-1.0
        window.setAttributes(lp);
    }
}
