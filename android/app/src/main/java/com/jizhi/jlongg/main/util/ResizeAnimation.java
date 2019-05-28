package com.jizhi.jlongg.main.util;

import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Transformation;

/**
 * 跟App相关的辅助类
 *
 * @author zhy
 */
public class ResizeAnimation extends Animation {


    /**
     * 开始缩放的高度
     */
    private int startHeight;
    /**
     * 结束后缩放的高度
     */
    private int deltaHeight; // distance between start and end height
    /**
     * 需要调整高度的View
     */
    private View view;
    /**
     * view 的参数
     */
    private ViewGroup.LayoutParams params;

    /**
     * constructor, do not forget to use the setParams(int, int) method before
     * starting the animation
     *
     * @param v
     */
    public ResizeAnimation(View v) {
        this.view = v;
        params = view.getLayoutParams();
    }

    @Override
    protected void applyTransformation(float interpolatedTime, Transformation t) {
        View view = this.view;
        ViewGroup.LayoutParams params = this.params;
        if (startHeight > deltaHeight) { //从大变小
            view.setAlpha(1f - interpolatedTime);
        } else {  //从小变大
            view.setAlpha(interpolatedTime);
        }
        params.height = (int) (startHeight + deltaHeight * interpolatedTime);
        view.setLayoutParams(params);
    }

    /**
     * set the starting and ending height for the resize animation
     * starting height is usually the views current height, the end height is the height
     * we want to reach after the animation is completed
     *
     * @param start height in pixels
     * @param end   height in pixels
     */
    public void setParams(int start, int end) {
        this.startHeight = start;
        deltaHeight = end - startHeight;
    }

    @Override
    public boolean willChangeBounds() {
        return true;
    }
}
