package com.jizhi.jlongg.main;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.animation.DecelerateInterpolator;
import android.widget.ScrollView;
import android.widget.TextView;
import com.jizhi.jlongg.R;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.Animator.AnimatorListener;
import com.nineoldandroids.animation.ObjectAnimator;
import com.nineoldandroids.view.ViewHelper;

public class PullLayout extends ScrollView {

    private View rl_top;
    private View ll_content;
    private View main_view;
    private ObjectAnimator oa;
    private float lastY = -1;
    private float detalY = -1;
    private int range;
    private int tvHeight;
    private int tvWidth;
    private boolean isTouchOrRunning;
    private boolean isActionCancel;

    public PullLayout(Context context) {
        super(context);
    }

    public PullLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PullLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        setVerticalScrollBarEnabled(false); //取消滚动条
//        rl_top = findViewById(R.id.rl_top);
//        ll_content = findViewById(R.id.ll_content);
//        main_view = findViewById(R.id.main_view);
//        rl_top.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
//            @SuppressWarnings("deprecation")
//            @Override
//            public void onGlobalLayout() {
//                rl_top.getViewTreeObserver().removeGlobalOnLayoutListener(this);
//                range = rl_top.getHeight();
//                scrollTo(0, range);
//                rl_top.getLayoutParams().height = range;
//            }
//        });
    }


    private String TAG = getClass().getName();

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        switch (ev.getAction()) {
            case MotionEvent.ACTION_DOWN:
                isActionCancel = false;
                isTouchOrRunning = true;
                lastY = ev.getY();
                break;
        }
        return super.onInterceptTouchEvent(ev);
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
//        if(oa != null && oa.isRunning()){//动画是否在移动
//            ev.setAction(MotionEvent.ACTION_UP);
//            isActionCancel = true;
//        }
//        if(isActionCancel && ev.getAction() != MotionEvent.ACTION_DOWN) {
//            return false;
//        }
//        if(ev.getActionIndex() != 0 && getScrollY() < range) {
//            ev.setAction(MotionEvent.ACTION_UP);
//            isActionCancel = true;
//        }
//        switch (ev.getAction()){
//            case MotionEvent.ACTION_MOVE:
//                isTouchOrRunning = true;
//                if (getScrollY() != 0){
//                    detalY = 0;
//                    lastY = ev.getY();
//                } else {
//                    detalY = ev.getY() - lastY;
//                    if (detalY > 0) {
//                        setT((int) -detalY / 5);
//                        return true;
//                    }
//                }
//                break;
//            case MotionEvent.ACTION_UP:
//                isTouchOrRunning = false;
//                if (getScrollY() < range) {
//                    if (detalY != 0) {
//                        reset();
//                    } else {
//                        toggle();
//                    }
//                    return true;
//                }
//                break;
//        }
        return super.onTouchEvent(ev);
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
        if (t > range) {
            return;
        } else if (!isTouchOrRunning && t != range) {
            scrollTo(0, range);
        } else {
            animateScroll(t);
        }
    }

    public void setT(int t) {
        scrollTo(0,t);
        if (t < 0) {
            animatePull(t);
        }
    }

    private void animateScroll(int t) {
        float percent = (float) t / range;
//        Log.e(TAG, "percent:"+percent+"     t:"+t+"            tvHeight * percent:"+tvHeight * percent);
        ViewHelper.setTranslationY(rl_top, (int)(t * 0.05));
        ViewHelper.setTranslationY(ll_content, tvHeight * percent);
//        ViewHelper.setScaleX(tv, 2 - percent);
//        ViewHelper.setScaleY(tv, 2 - percent);
//        ViewHelper.setTranslationX(tv, tvWidth * (1 - percent) / 2f);
//        ViewHelper.setTranslationY(tv, t + tvHeight * (1 - percent) / 2f);
//        ViewHelper.setTranslationY(ev, -t / 2);
//        ViewHelper.setTranslationY(ll_weather, -t / 2);
//        ev.setRadius((int) (range * 0.25f * (1 - percent)));
//        tv.setTextColor(evaluate(percent, Color.WHITE, Color.BLACK));
    }

    private void animatePull(int t) {
        rl_top.getLayoutParams().height = range - t;
        rl_top.requestLayout();
        float percent = (float) t / range;
    }

    private Integer evaluate(float fraction, Object startValue, Integer endValue){
        int startInt = (Integer) startValue;
        int startA = (startInt >> 24) & 0xff;
        int startR = (startInt >> 16) & 0xff;
        int startG = (startInt >> 8) & 0xff;
        int startB = startInt & 0xff;
        int endInt = (Integer) endValue;
        int endA = (endInt >> 24) & 0xff;
        int endR = (endInt >> 16) & 0xff;
        int endG = (endInt >> 8) & 0xff;
        int endB = endInt & 0xff;
        return (int) ((startA + (int) (fraction * (endA - startA))) << 24)
                | (int) ((startR + (int) (fraction * (endR - startR))) << 16)
                | (int) ((startG + (int) (fraction * (endG - startG))) << 8)
                | (int) ((startB + (int) (fraction * (endB - startB))));
    }

    public void toggle() {
        if (isOpen()) {
            close();
        } else {
            open();
        }
    }

    private Status status;

    public enum Status {
        Open, Close;
    }

    public boolean isOpen() {
        return status == Status.Open;
    }

    private void reset() {
        if (oa != null && oa.isRunning()) {
            return;
        }
        oa = ObjectAnimator.ofInt(this, "t", (int) -detalY / 5, 0);
        oa.setDuration(150);
        oa.start();
    }

    public void close() {
        if (oa != null && oa.isRunning()) {
            return;
        }
        oa = ObjectAnimator.ofInt(this, "t", getScrollY(), range);
        oa.setInterpolator(new DecelerateInterpolator());
        oa.addListener(new AnimatorListener() {
            @Override
            public void onAnimationStart(Animator arg0) {
                isTouchOrRunning = true;
            }

            @Override
            public void onAnimationRepeat(Animator arg0) {
            }

            @Override
            public void onAnimationEnd(Animator arg0) {
                isTouchOrRunning = false;
                status = Status.Close;
            }

            @Override
            public void onAnimationCancel(Animator arg0) {

            }
        });
        oa.setDuration(250);
        oa.start();
    }

    public void open() {
        if (oa != null && oa.isRunning()) {
            return;
        }
        oa = ObjectAnimator.ofInt(this, "t", getScrollY(), (int) (-getScrollY() / 2.2f), 0);
        oa.setInterpolator(new DecelerateInterpolator());
        oa.addListener(new AnimatorListener() {
            @Override
            public void onAnimationStart(Animator arg0) {
                isTouchOrRunning = true;
            }

            @Override
            public void onAnimationRepeat(Animator arg0) {
            }

            @Override
            public void onAnimationEnd(Animator arg0) {
                isTouchOrRunning = false;
                status = Status.Open;
            }

            @Override
            public void onAnimationCancel(Animator arg0) {

            }
        });
        oa.setDuration(400);
        oa.start();
    }

}
