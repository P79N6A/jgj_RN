package com.jizhi.jlongg.main.util.shadow;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.DensityUtils;

/**
 * Created by Administrator on 2017/5/3 0003.
 */

public class ShadowUtil {

    /**
     * 设置阴影效果
     *
     * @param setShadowView
     */
    public static void setShadow(Context context, View setShadowView) {
        int shadowY = DensityUtils.dp2px(context, 2);
        int shadowMargin = DensityUtils.dp2px(context, 5);
        init(shadowMargin, shadowY, setShadowView, context);
        CustomShadowProperty shadowProperty = new CustomShadowProperty()
                .setShadowColor(Color.parseColor("#e6e6e6")) //设置阴影颜色
                .setShadowDy(shadowY) //设置阴影圆角大小
                .setBackground(Color.parseColor("#FFFFFF")) //设置背景色
                .setShadowRadius(shadowMargin);
        CustomShadowViewHelper.bindShadowHelper(context, shadowProperty, setShadowView, true);
    }


    /**
     * 设置阴影效果 保持原背景的颜色
     *
     * @param context
     * @param setShadowView
     */
    public static void setShadowAndUserOriginalBackground(Context context, View setShadowView, int background) {
        int shadowY = DensityUtils.dp2px(context, 2);
        int shadowMargin = DensityUtils.dp2px(context, 5);
        init(shadowMargin, shadowY, setShadowView, context);
        CustomShadowProperty shadowProperty = new CustomShadowProperty()
                .setShadowColor(Color.parseColor("#efb8b8"))
                .setShadowDy(shadowY)
                .setBackground(background)
                .setShadowRadius(shadowMargin);
        CustomShadowViewHelper.bindShadowHelper(context, shadowProperty, setShadowView, false);
    }


    public static void init(int shadowMargin, int shadowY, View setShadowView, Context context) {
        if (setShadowView != null) {
            setShadowView.setPadding(
                    setShadowView.getPaddingLeft() + shadowMargin,
                    setShadowView.getPaddingTop() + shadowMargin,
                    setShadowView.getPaddingRight() + shadowMargin,
                    setShadowView.getPaddingBottom() + shadowMargin + shadowY);
            ViewGroup.LayoutParams viewGroupParams = setShadowView.getLayoutParams();
            if (viewGroupParams instanceof RelativeLayout.LayoutParams) {
                RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) viewGroupParams;
                layoutParams.height = layoutParams.height + DensityUtils.dp2px(context, 10);
                layoutParams.leftMargin = layoutParams.leftMargin - shadowMargin;
                layoutParams.rightMargin = layoutParams.rightMargin - shadowMargin;
                layoutParams.topMargin = layoutParams.topMargin - shadowMargin;
                layoutParams.bottomMargin = layoutParams.bottomMargin - shadowMargin - shadowY;
                setShadowView.setLayoutParams(layoutParams);

            } else if (viewGroupParams instanceof FrameLayout.LayoutParams) {
                FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) viewGroupParams;

                layoutParams.height = layoutParams.height + DensityUtils.dp2px(context, 10);
                layoutParams.leftMargin = layoutParams.leftMargin - shadowMargin;
                layoutParams.rightMargin = layoutParams.rightMargin - shadowMargin;
                layoutParams.topMargin = layoutParams.topMargin - shadowMargin;
                layoutParams.bottomMargin = layoutParams.bottomMargin - shadowMargin - shadowY;
                setShadowView.setLayoutParams(layoutParams);
            } else if (viewGroupParams instanceof LinearLayout.LayoutParams) {
                LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) viewGroupParams;
                layoutParams.height = layoutParams.height + DensityUtils.dp2px(context, 10);
                layoutParams.leftMargin = layoutParams.leftMargin - shadowMargin;
                layoutParams.rightMargin = layoutParams.rightMargin - shadowMargin;
                layoutParams.topMargin = layoutParams.topMargin - shadowMargin;
                layoutParams.bottomMargin = layoutParams.bottomMargin - shadowMargin - shadowY;
                setShadowView.setLayoutParams(layoutParams);
            }
        }
    }
}
