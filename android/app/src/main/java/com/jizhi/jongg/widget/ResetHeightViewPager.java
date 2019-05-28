package com.jizhi.jongg.widget;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * 自动适应高度的ViewPageri
 *
 * @author
 */
public class ResetHeightViewPager extends ViewPager {

    private int currentItem;
    private HashMap<Integer, View> mChildrenViews = new LinkedHashMap<Integer, View>();
    /**
     * 当前滑动日历的高度
     */
    private int currentCalendarHeight;


    public ResetHeightViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ResetHeightViewPager(Context context) {
        super(context);
    }


    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (mChildrenViews != null && mChildrenViews.size() > 0 && mChildrenViews.containsKey(currentItem)) {
            if (currentCalendarHeight == 0) {
                View child = mChildrenViews.get(currentItem);
                if (child != null) {
                    child.measure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED));
                    currentCalendarHeight = child.getMeasuredHeight();
                }
            }
        }
        super.onMeasure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(currentCalendarHeight, MeasureSpec.EXACTLY));
    }

    public void resetHeight(int currentItem) {
        this.currentItem = currentItem;
        View child = mChildrenViews.get(currentItem);
        if (currentCalendarHeight == 0) { //首次加载
            currentCalendarHeight = child.getMeasuredHeight();
            requestLayout();
            return;
        }
        if (child != null && child.getMeasuredHeight() != currentCalendarHeight) {
            startAnimation(child.getMeasuredHeight());
        }
    }

    private void startAnimation(final int currentScrollChildHeight) {
        Animation heightMoveAnimation = null;
        final int mLastHeight = currentCalendarHeight;
        if (currentCalendarHeight > currentScrollChildHeight) {
            //移动的距离
            final int moveDistance = mLastHeight - currentScrollChildHeight;
            heightMoveAnimation = new Animation() {
                @Override
                protected void applyTransformation(float interpolatedTime, Transformation t) {
                    super.applyTransformation(interpolatedTime, t);
                    if (interpolatedTime < 1.0f) {
                        currentCalendarHeight = (int) (mLastHeight - moveDistance * interpolatedTime);
                        requestLayout();
                    }
                }
            };
        } else {
            //移动的距离
            final int moveDistance = currentScrollChildHeight - currentCalendarHeight;
            heightMoveAnimation = new Animation() {
                @Override
                protected void applyTransformation(float interpolatedTime, Transformation t) {
                    super.applyTransformation(interpolatedTime, t);
                    if (interpolatedTime < 1.0f) {
                        currentCalendarHeight = (int) (mLastHeight + moveDistance * interpolatedTime);
                        requestLayout();
                    }
                }
            };
        }
        heightMoveAnimation.setDuration(600); //设置动画时间为1秒
        heightMoveAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                currentCalendarHeight = currentScrollChildHeight;
                requestLayout();
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        startAnimation(heightMoveAnimation);
    }


    /**
     * 保存position与对于的View
     */
    public void setObjectForPosition(View view, int position) {
        mChildrenViews.put(position, view);
    }
}
