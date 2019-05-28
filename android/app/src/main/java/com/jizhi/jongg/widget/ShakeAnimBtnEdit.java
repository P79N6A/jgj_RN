package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;

import com.jizhi.jlongg.R;


/**
 * Created by Administrator on 2017/11/24 0024.
 */

public class ShakeAnimBtnEdit extends ImageView {


    public ShakeAnimBtnEdit(Context context) {
        super(context);
    }

    public ShakeAnimBtnEdit(Context context, AttributeSet attrs) {
        super(context, attrs);
    }


    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                setImageResource(R.drawable.icon_notebook_edit);
                startActionDownAnim();
                break;
            case MotionEvent.ACTION_UP:
                setImageResource(R.drawable.icon_notebook_edit);
                stopShakeAnim();
                break;
        }
        return super.onTouchEvent(event);
    }


    /**
     * 执行按下的动画
     */
    private void startActionDownAnim() {
        /**
         * ScaleAnimation类是Android系统中的尺寸变化动画类，用于控制View对象的尺寸变化，该类继承于Animation类。ScaleAnimation类中的很多方法都与Animation类一致，该类中最常用的方法便是ScaleAnimation构造方法。
         【基本语法】public ScaleAnimation (float fromX, float toX, float fromY, float toY, int pivotXType, float pivotXValue, int pivotYType, float pivotYValue)
         参数说明
         fromX：起始X坐标上的伸缩尺寸。
         toX：结束X坐标上的伸缩尺寸。
         fromY：起始Y坐标上的伸缩尺寸。
         toY：结束Y坐标上的伸缩尺寸。
         pivotXType：X轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。
         pivotXValue：X坐标的伸缩值。
         pivotYType：Y轴的伸缩模式，可以取值为ABSOLUTE、RELATIVE_TO_SELF、RELATIVE_TO_PARENT。
         pivotYValue：Y坐标的伸缩值。
         有三种默认值：
         RELATIVE_TO_PARENT 相对于父控件
         RELATIVE_TO_SELF 相对于符自己
         RELATIVE_TO_ABSOLUTE 绝对坐标
         */
        final float fromX = 1.0f;
        final float toX = 0.8f;
        final float fromY = 1.0f;
        final float toY = 0.8f;
        int duration = 300; //动画执行时间
        ScaleAnimation animation = new ScaleAnimation(fromX, toX, fromY, toY, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        animation.setDuration(duration);//设置动画持续时间
        startAnimation(animation);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                startShakeAnim(toX, toY);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    /**
     * 设置摇滚动画
     */
    private void startShakeAnim(float fromX, float fromY) {
            /*
             *  创建一个AnimationSet，它能够同时执行多个动画效果
             *  构造方法的入参如果是“true”，则代表使用默认的interpolator，如果是“false”则代表使用自定义interpolator
             */
        ScaleAnimation shakeAnimation = new ScaleAnimation(fromX, fromX + 0.02f, fromY, fromY + 0.02f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        shakeAnimation.setDuration(500);
        shakeAnimation.setInterpolator(getContext(), R.anim.shake_loop);
        shakeAnimation.setFillAfter(true);
        startAnimation(shakeAnimation);
    }

    /**
     * 停止摇滚动画
     */
    private void stopShakeAnim() {
        ScaleAnimation animation = new ScaleAnimation(0.82f, 1.0f, 0.82f, 1.0f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        animation.setFillAfter(true);
        animation.setDuration(300);//设置动画持续时间
        startAnimation(animation);
    }
}
