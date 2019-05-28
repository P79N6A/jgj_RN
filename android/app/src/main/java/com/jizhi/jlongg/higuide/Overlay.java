package com.jizhi.jlongg.higuide;

import android.graphics.Color;
import android.graphics.RectF;
import android.support.annotation.IntDef;
import android.support.annotation.LayoutRes;
import android.support.annotation.Nullable;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

/**
 * Create by Zii at 2018/5/4.
 */
public class Overlay {

    private List<HightLight> mHightLightList;
    private int mColorBg;
    private boolean mIsTouchDismiss;
    private View.OnClickListener mOnClickGuideViewListener;
    private View.OnClickListener mOnClickHightLightListener;
    private List<RectF> mHightLightAreas;

    public Overlay() {
        mHightLightList = new ArrayList<>();
//        mColorBg = Color.parseColor("#80000000");
        mColorBg = Color.parseColor("#cc000000");
        mIsTouchDismiss = true;
        mHightLightAreas = new ArrayList<>();
    }

    public Overlay touchDismiss(boolean isDismiss) {
        mIsTouchDismiss = isDismiss;
        return this;
    }

    public Overlay bgColor(int color) {
        mColorBg = color;
        return this;
    }

    public Overlay addHightLight(View view, int[] expand, @HiGuide.Shape int shape, Tips tips) {
        HightLight hightLight = new HightLight(view, expand, shape, tips);
        mHightLightList.add(hightLight);
        addHightLightArea(hightLight);
        return this;
    }

    private void addHightLightArea(HightLight info) {
        RectF rectF = info.getRectF();
        if (info.getShape() != HiGuide.SHAPE_CIRCLE) {
            mHightLightAreas.add(rectF);
        } else {
            mHightLightAreas.add(new RectF(rectF.left, rectF.centerY() - info.getRadius(), rectF.right, rectF.centerY() + info.getRadius()));
        }
    }

    public Overlay addHightLightClickListener(View.OnClickListener listener) {
        mOnClickHightLightListener = listener;
        return this;
    }

    public boolean isTouchDismiss() {
        return mIsTouchDismiss;
    }

    public Overlay addGuideViewClickListener(View.OnClickListener listener) {
        mOnClickGuideViewListener = listener;
        return this;
    }

    public List<RectF> getHightLightAreas() {
        return mHightLightAreas;
    }

    public List<HightLight> getHightLightList() {
        return mHightLightList;
    }

    public int getColorBg() {
        return mColorBg;
    }

    public View.OnClickListener getOnClickGuideViewListener() {
        return mOnClickGuideViewListener;
    }

    public View.OnClickListener getOnClickHightLightListener() {
        return mOnClickHightLightListener;
    }

    public static class HightLight {

        private View mView;
        private RectF mRectF;
        @HiGuide.Shape
        private int mShape;
        private float mRadius;
        private Tips mTips;

        HightLight(View view, int[] expand, @HiGuide.Shape int shape, Tips tips) {
            mView = view;
            mShape = shape;

            mRectF = new RectF();
            int[] location = new int[2];
//            final int[] size = GuideUtils.measureView(mView);
            final int[] size = new int[]{view.getWidth(), view.getHeight()};
            view.getLocationOnScreen(location);
            if (expand == null) {
                expand = new int[2];
            }
            mRectF.left = location[0] - expand[0];
            mRectF.top = location[1] - expand[1];
            mRectF.right = location[0] + size[0] + expand[0];
            mRectF.bottom = location[1] + size[1] + expand[1];

            mRadius = Math.max((mRectF.right - mRectF.left) / 2, (mRectF.bottom - mRectF.top) / 2);

            mTips = tips;
        }

        public Tips getTips() {
            return mTips;
        }

        public float getRadius() {
            return mRadius;
        }

        public View getView() {
            return mView;
        }

        public RectF getRectF() {
            return mRectF;
        }

        @HiGuide.Shape
        public int getShape() {
            return mShape;
        }

    }

    public static class Tips {

        public static final int TO_RIGHT_OF = 1;
        public static final int TO_LEFT_OF = 2;
        public static final int ALIGN_TOP = 3;
        public static final int ALIGN_BOTTOM = 4;
        public static final int TO_CENTER_OF = 5;

        @IntDef({TO_RIGHT_OF, TO_LEFT_OF, TO_CENTER_OF})
        @interface To {

        }

        @IntDef({ALIGN_TOP, ALIGN_BOTTOM})
        @interface Align {

        }

        public static class Margin {

            public int left;
            public int top;
            public int bottom;
            public int right;

            public Margin(int left, int top, int bottom, int right) {
                this.left = left;
                this.top = top;
                this.bottom = bottom;
                this.right = right;
            }
        }

        @LayoutRes
        public int layoutRes = -1;
        @To
        public int to;
        @Align
        public int align;
        public Margin margin;

        public Tips(int layoutRes) {
            this.layoutRes = layoutRes;
        }

        public Tips(@LayoutRes int layoutRes, @Nullable Margin margin) {
            this.layoutRes = layoutRes;
            this.margin = margin;
        }

        public Tips(@LayoutRes int layoutRes, @To int to, @Align int align) {
            this.layoutRes = layoutRes;
            this.to = to;
            this.align = align;
        }

        public Tips(@LayoutRes int layoutRes, @To int to, @Align int align, @Nullable Margin margin) {
            this.layoutRes = layoutRes;
            this.to = to;
            this.align = align;
            this.margin = margin;
        }

    }

}
