package com.jizhi.jlongg.main.util.shadow;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.StateListDrawable;
import android.os.Build;
import android.view.View;
import android.view.ViewTreeObserver;

import com.hcs.uclient.utils.Utils;

/**
 * Created by Administrator on 2017/5/4 0004.
 */

public class CustomShadowViewHelper {
    /**
     * 设置view的一些属性
     */
    private CustomShadowProperty shadowProperty;
    /**
     * 需要变色的view
     */
    private View view;
    /**
     * drawable
     */
    private CustomShadowViewDrawable shadowViewNormalDrawable, shadowViewPressDrawable;
    /**
     * normalColor:背景常态颜色
     * pressColor:按下颜色
     */
    private int normalColor, pressColor;
    /**
     * 设置阴影背景时 当按下背景时 需要变色
     */
    private boolean changePressColor;


    public static CustomShadowViewHelper bindShadowHelper(Context context, CustomShadowProperty shadowProperty, View view, boolean changePressColor) {
        if (changePressColor) {
            return new CustomShadowViewHelper(shadowProperty, view, shadowProperty.getBackground(), Color.parseColor("#f1f1f1"), 0.0F, 0.0F, context);
        } else {
            return new CustomShadowViewHelper(shadowProperty, view, shadowProperty.getBackground(), 0.0F, 0.0F, context);
        }
    }

    private CustomShadowViewHelper(CustomShadowProperty shadowProperty, View view, int normalColor, float rx, float ry, Context context) {
        this.shadowProperty = shadowProperty;
        this.view = view;
        this.normalColor = normalColor;
        this.changePressColor = false;
        this.init();
    }


    private CustomShadowViewHelper(CustomShadowProperty shadowProperty, View view, int normalColor, int pressColor, float rx, float ry, Context context) {
        this.shadowProperty = shadowProperty;
        this.view = view;
        this.normalColor = normalColor;
        this.pressColor = pressColor;
        this.changePressColor = true;
        this.init();
    }

    private void init() {
        if (Build.VERSION.SDK_INT > 11) {
            this.view.setLayerType(1, null);
        }
        this.view.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                if (changePressColor) {
                    CustomShadowViewHelper.this.shadowViewNormalDrawable.setBounds(0, 0, CustomShadowViewHelper.this.view.getMeasuredWidth(), CustomShadowViewHelper.this.view.getMeasuredHeight());
                    CustomShadowViewHelper.this.shadowViewPressDrawable.setBounds(0, 0, CustomShadowViewHelper.this.view.getMeasuredWidth(), CustomShadowViewHelper.this.view.getMeasuredHeight());
                } else {
                    CustomShadowViewHelper.this.shadowViewNormalDrawable.setBounds(0, 0, CustomShadowViewHelper.this.view.getMeasuredWidth(), CustomShadowViewHelper.this.view.getMeasuredHeight());
                }
                if (Build.VERSION.SDK_INT >= 16) {
                    CustomShadowViewHelper.this.view.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                } else {
                    CustomShadowViewHelper.this.view.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                }
            }
        });
        if (changePressColor) {
            this.shadowViewNormalDrawable = new CustomShadowViewDrawable(this.shadowProperty, this.normalColor);
            this.shadowViewPressDrawable = new CustomShadowViewDrawable(this.shadowProperty, this.pressColor);

            StateListDrawable drawable = new StateListDrawable();
            drawable.addState(new int[]{android.R.attr.state_pressed}, this.shadowViewPressDrawable); //按下的效果
            drawable.addState(new int[]{-android.R.attr.state_pressed}, this.shadowViewNormalDrawable); //未按下的效果

            Utils.setBackGround(this.view, drawable);
        } else {
            this.shadowViewNormalDrawable = new CustomShadowViewDrawable(this.shadowProperty, this.normalColor);
            Utils.setBackGround(this.view, shadowViewNormalDrawable);
        }
    }


    public View getView() {
        return this.view;
    }

    public CustomShadowProperty getShadowProperty() {
        return this.shadowProperty;
    }
}
