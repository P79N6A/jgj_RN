package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.BackGroundUtil;


/**
 * WheelView 单个选择
 *
 * @author Xuj
 * @date 2016年9月26日 10:59:58
 */
public class PopupWindowExpand extends PopupWindow implements PopupWindow.OnDismissListener {
    /**
     * popwindow
     */
    public View popView;
    /**
     * 上下文
     */
    public Activity activity;
    /**
     *
     */
    private int style = -1;

    public PopupWindowExpand(Activity activity) {
        this.activity = activity;
    }

    /**
     * 是否设置透明度
     */
    public void setAlpha(boolean setAlpha) {
        if (setAlpha) {
            BackGroundUtil.backgroundAlpha(activity, 0.5F);
        }
    }


    public void setPopParameter() {
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果 从下到上的动画
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0);
        setOnDismissListener(this);
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);
        setOutsideTouchable(true);
    }

    public void setTopToBottomAnimation(){
        //从上到下的动画
        setAnimationStyle(R.style.ActionSheetDialogAnimationTopToBottom);
    }



    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(activity, 1.0F);
    }

    public int getStyle() {
        return style;
    }

    public void setStyle(int style) {
        this.style = style;
    }
}