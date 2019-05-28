package com.jizhi.jongg.widget;

/**
 * @author ${lpei}
 * @time 2016/3/17 10:43
 */
/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014-2015 bboyfeiyu@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.RelativeLayout;

import com.jizhi.jlongg.R;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.AnimatorSet;
import com.nineoldandroids.animation.ObjectAnimator;

import java.util.ArrayList;

/**
 * 这是一个类似支付宝声波支付的波纹效果布局,该布局中默认添加了不可见的圆形的视图,启动动画时会启动缩放、颜色渐变动画使得产生波纹效果.
 * 这些动画都是无限循环的,并且每个View的动画之间都有时间间隔，这些时间间隔就会导致视图有大有小，从而产生波纹的效果.
 *
 * @author mrsimple
 */
public class RippleLayout extends RelativeLayout {
    private String Tag = "RippleLayout";
    //默认的波纹数量
    private static final int DEFAULT_RIPPLE_COUNT = 3;
    //默认的波纹持续时间
    private static final int DEFAULT_DURATION_TIME = 3000;
    //默认的波纹扩大范围
    private static final float DEFAULT_SCALE = 2.2f;
    //默认的波纹颜色
    private static final int DEFAULT_RIPPLE_COLOR = Color.rgb(0x47, 0xa6, 0xff);
    //默认的波纹边缘宽度
    private static final int DEFAULT_STROKE_WIDTH = 0;
    //默认的半径
    private static final int DEFAULT_RADIUS = 60;

    /**
     * 默认的波纹颜色
     */
    private int mRippleColor = DEFAULT_RIPPLE_COLOR;
    /**
     * 默认的波纹边缘宽度
     */
    private float mStrokeWidth = DEFAULT_STROKE_WIDTH;
    /*
     * 默认的半径
     */
    private float mRippleRadius = DEFAULT_RADIUS;
    private int mAnimDuration;
    private int mRippleViewNums;
    private int mAnimDelay;
    private float mRippleScale;
    private boolean animationRunning = false;
    private Paint mPaint = new Paint();

    /**
     * 动画集,执行缩放、alpha动画,使得背景色渐变
     */
    private AnimatorSet mAnimatorSet = new AnimatorSet();
    /**
     * 动画列表,保存几个动画
     */
    private ArrayList<Animator> mAnimatorList = new ArrayList<Animator>();
    /**
     * RippleView Params
     */
    private LayoutParams mRippleViewParams;

    /**
     * @param context
     */
    public RippleLayout(Context context) {
        super(context);
        init(context, null);
    }

    public RippleLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public RippleLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context, attrs);
    }

    private void init(final Context context, final AttributeSet attrs) {
        if (isInEditMode()) {
            return;
        }

        if (null != attrs) {
            initTypedArray(context, attrs);
        }
        initPaint();
        initRippleViewLayoutParams();
        generateRippleViews();

    }

    private void initTypedArray(Context context, AttributeSet attrs) {
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.RippleLayout);
        mRippleColor = typedArray.getColor(R.styleable.RippleLayout_colors, DEFAULT_RIPPLE_COLOR);
        mStrokeWidth = typedArray.getDimension(R.styleable.RippleLayout_strokeWidths, DEFAULT_STROKE_WIDTH);
        mRippleRadius = typedArray.getDimension(R.styleable.RippleLayout_radius, DEFAULT_RADIUS);
        mAnimDuration = typedArray.getInt(R.styleable.RippleLayout_duration, DEFAULT_DURATION_TIME);
        mRippleViewNums = typedArray.getInt(R.styleable.RippleLayout_rippleNums, DEFAULT_RIPPLE_COUNT);
        mRippleScale = typedArray.getFloat(R.styleable.RippleLayout_scale, DEFAULT_SCALE);
        // oh, baby, don't forget recycle the typedArray !!
        typedArray.recycle();
    }

    private void initPaint() {
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mStrokeWidth = 0;
        mPaint.setStyle(Paint.Style.FILL);
        mPaint.setColor(mRippleColor);
    }

    private void initRippleViewLayoutParams() {
        // ripple view的大小为 半径 + 笔宽的两倍
        int rippleSide = (int) (2 * (mRippleRadius + mStrokeWidth));
        mRippleViewParams = new LayoutParams(rippleSide, rippleSide);
        // 居中显示
        mRippleViewParams.addRule(CENTER_IN_PARENT, TRUE);
    }

    /**
     * 计算每个RippleView之间的动画时间间隔,从而产生波纹效果
     */
    private void calculateAnimDelay() {
        mAnimDelay = mAnimDuration / mRippleViewNums;
    }

    /**
     * 初始化RippleViews，并且将动画设置到RippleView上,使之在x, y不断扩大,并且背景色逐渐淡化
     */
    private void generateRippleViews() {
        calculateAnimDelay();
        initAnimSet();
        // 添加RippleView
        for (int i = 0; i < mRippleViewNums; i++) {
            RippleView rippleView = new RippleView(getContext());
            addView(rippleView, mRippleViewParams);
            // 添加动画
            addAnimToRippleView(rippleView, i);
        }

        // x, y, alpha动画一块执行
        mAnimatorSet.playTogether(mAnimatorList);
    }

    private void initAnimSet() {
        mAnimatorSet.setDuration(mAnimDuration);
        mAnimatorSet.setInterpolator(new AccelerateDecelerateInterpolator());
    }

    /**
     * 为每个RippleView添加动画效果,并且设置动画延时,每个视图启动动画的时间不同,就会产生波纹
     *
     * @param rippleView
     * @param i          视图所在的索引
     */
    private void addAnimToRippleView(RippleView rippleView, int i) {
        // x轴的缩放动画
        final ObjectAnimator scaleXAnimator = ObjectAnimator.ofFloat(rippleView, "scaleX", 1.0f, mRippleScale);
        scaleXAnimator.setRepeatCount(ObjectAnimator.INFINITE);
        scaleXAnimator.setRepeatMode(ObjectAnimator.RESTART);
        scaleXAnimator.setStartDelay(i * mAnimDelay);
        scaleXAnimator.setDuration(mAnimDuration);
        mAnimatorList.add(scaleXAnimator);
        // y轴的缩放动画
        final ObjectAnimator scaleYAnimator = ObjectAnimator.ofFloat(rippleView, "scaleY",
                    1.0f, mRippleScale);
        scaleYAnimator.setRepeatMode(ObjectAnimator.RESTART);
        scaleYAnimator.setRepeatCount(ObjectAnimator.INFINITE);
        scaleYAnimator.setStartDelay(i * mAnimDelay);
        scaleYAnimator.setDuration(mAnimDuration);
        mAnimatorList.add(scaleYAnimator);
        // 颜色的alpha渐变动画
        final ObjectAnimator alphaAnimator = ObjectAnimator.ofFloat(rippleView, "alpha", 1.0f, 0f);
        alphaAnimator.setRepeatMode(ObjectAnimator.RESTART);
        alphaAnimator.setRepeatCount(ObjectAnimator.INFINITE);
        alphaAnimator.setDuration(mAnimDuration);
        alphaAnimator.setStartDelay(i * mAnimDelay);
        mAnimatorList.add(alphaAnimator);
    }

    public void startRippleAnimation() {
        if (!isRippleAnimationRunning()) {
            makeRippleViewsVisible();
            mAnimatorSet.start();
            animationRunning = true;
        }
    }

    private void makeRippleViewsVisible() {
        int childCount = this.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childView = this.getChildAt(i);
            if (childView instanceof RippleView) {
                childView.setVisibility(VISIBLE);
            }
        }
    }

    public void stopRippleAnimation() {
        if (isRippleAnimationRunning()) {
            mAnimatorSet.end();
            animationRunning = false;
        }
    }

    public boolean isRippleAnimationRunning() {
        return animationRunning;
    }

    /**
     * RippleView产生波纹效果, 默认不可见,当启动动画时才设置为可见
     *
     * @author mrsimple
     */
    private class RippleView extends View {
        public RippleView(Context context) {
            super(context);
            this.setVisibility(View.INVISIBLE);
        }

        @Override
        protected void onDraw(Canvas canvas) {
            int radius = (Math.min(getWidth(), getHeight())) / 2;
            canvas.drawCircle(radius, radius, radius - mStrokeWidth, mPaint);
        }
    }
}
