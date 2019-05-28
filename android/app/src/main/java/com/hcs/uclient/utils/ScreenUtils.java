package com.hcs.uclient.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.WindowManager;
import android.widget.RelativeLayout;

/**
 * 获得屏幕相关的辅助类
 *
 * @author zhy
 */
public class ScreenUtils {
    private ScreenUtils() {
        /* cannot be instantiated */
        throw new UnsupportedOperationException("cannot be instantiated");
    }

    /**
     * 获取顶部状态栏的高度
     * 由于getLocationOnScreen 返回的坐标 包含了 下拉栏 需要减去
     *
     * @param activity
     * @return
     */
    public static int getStatusHeight(Activity activity) {
        int statusHeight = 0;
        Rect localRect = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(localRect);
        statusHeight = localRect.top;
        if (0 == statusHeight) {
            Class<?> localClass;
            try {
                localClass = Class.forName("com.android.internal.R$dimen");
                Object localObject = localClass.newInstance();
                int i5 = Integer.parseInt(localClass.getField("status_bar_height").get(localObject).toString());
                statusHeight = activity.getResources().getDimensionPixelSize(i5);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            }
        }
        return statusHeight;
    }


    /**
     * 获得屏幕密度
     *
     * @param context
     * @return
     */
    public static float getScreenDip(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.density;
    }

    /**
     * 获得屏幕高度
     *
     * @param context
     * @return
     */
    public static int getScreenWidth(Context context) {
        WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.widthPixels;
    }

    /**
     * 获得屏幕宽度
     *
     * @param context
     * @return
     */
    public static int getScreenHeight(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.heightPixels;
    }


    /**
     * 获得屏幕宽度
     *
     * @param context
     * @return
     */
    public static int getScreenHeightUnContainsStatusHeight(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.heightPixels - getStatusHeight(context);
    }

    /**
     * 获得状态栏的高度
     *
     * @param context
     * @return
     */
    public static int getStatusHeight(Context context) {

        int statusHeight = -1;
        try {
            Class<?> clazz = Class.forName("com.android.internal.R$dimen");
            Object object = clazz.newInstance();
            int height = Integer.parseInt(clazz.getField("status_bar_height")
                    .get(object).toString());
            statusHeight = context.getResources().getDimensionPixelSize(height);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statusHeight;
    }

    /**
     * 获取当前屏幕截图，包含状态栏
     *
     * @param activity
     * @return
     */
    public static Bitmap snapShotWithStatusBar(Activity activity) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap bmp = view.getDrawingCache();
        int width = getScreenWidth(activity);
        int height = getScreenHeight(activity);
        Bitmap bp = null;
        bp = Bitmap.createBitmap(bmp, 0, 0, width, height);
        view.destroyDrawingCache();
        return bp;

    }

    /**
     * 获取当前屏幕截图，不包含状态栏
     *
     * @param activity
     * @return
     */
    public static Bitmap snapShotWithoutStatusBar(Activity activity) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap bmp = view.getDrawingCache();
        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top;

        int width = getScreenWidth(activity);
        int height = getScreenHeight(activity);
        Bitmap bp = null;
        bp = Bitmap.createBitmap(bmp, 0, statusBarHeight, width, height
                - statusBarHeight);
        view.destroyDrawingCache();
        return bp;
    }


    /**
     * 获取View的绝对坐标 不包含状态栏的高度
     *
     * @param
     * @return
     */
    public static int[] getLocationOnScreenUnContainsStatusHeight(Context context, View notesGuideIcon) {
        int[] localtion = new int[2];
        if (notesGuideIcon != null) {
            notesGuideIcon.getLocationOnScreen(localtion);
            localtion[1] = localtion[1] - ScreenUtils.getStatusHeight(context);
        }
        return localtion;
    }

    /**
     * 获取屏幕中控件顶部位置的高度--即控件顶部的Y点
     *
     * @return
     */
    public static int getScreenViewTopHeight(View view) {
        return view.getTop();
    }

    /**
     * 获取屏幕中控件底部位置的高度--即控件底部的Y点
     *
     * @return
     */
    public static int getScreenViewBottomHeight(View view) {
        return view.getBottom();
    }

    /**
     * 获取屏幕中控件左侧的位置--即控件左侧的X点
     *
     * @return
     */
    public static int getScreenViewLeftHeight(View view) {
        return view.getLeft();
    }

    /**
     * 获取屏幕中控件右侧的位置--即控件右侧的X点
     *
     * @return
     */
    public static int getScreenViewRightHeight(View view) {
        return view.getRight();
    }

    /**
     * 得到控件长度
     */
    public static int getViewWidthLength(View view) {
        int width = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        int height = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        view.measure(width, height);
        int voiceWidth = view.getMeasuredWidth();
        return voiceWidth;
    }

    /**
     * 给控件动态设置长度
     */
    public static void setViewWidthLength(View view, int sumWidth, int voiceWidth, float seconds) {
        RelativeLayout.LayoutParams lParams = (RelativeLayout.LayoutParams) view.getLayoutParams();
        view.getLayoutParams();
        if (seconds >= 60) {
            seconds = 60;
        }
        int length = (int) ((sumWidth - voiceWidth - 180) / 60 * seconds + voiceWidth);
        lParams.width = length;
        view.setLayoutParams(lParams);
    }

    /**
     * 给控件动态设置长度
     */
    public static void setViewWidthLengthLin(Context Context, View view, float seconds) {
        if (seconds == 0) {
            return;
        }
//        int sec = Integer.parseInt(seconds);

//        int width = DensityUtils.dp2px(context, 70) + DensityUtils.dp2px(context, Float.parseFloat(entity.getVoice_long()));
        RelativeLayout.LayoutParams lParams = (RelativeLayout.LayoutParams) view.getLayoutParams();
        view.getLayoutParams();
        if (seconds >= 60) {
            seconds = 60;
        }
        int length = (int) ((((DensityUtils.dp2px(Context, 200) - DensityUtils.dp2px(Context, 60)) / 60) * seconds) + DensityUtils.dp2px(Context, 70));
        if (DensityUtils.px2dp(Context, length) >= 200) {
            length = DensityUtils.dp2px(Context, 220);
        }

        lParams.width = length;
        view.setLayoutParams(lParams);
    }

}
