package com.jizhi.jlongg.higuide;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.IntDef;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.jizhi.jlongg.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Create Zii at 2018/5/3.
 */
public class HiGuide {

    private Context mContext;
    private ViewGroup mRootView;
    private GuideView mGuideView;
    private List<Overlay> mOverlays;
    private Overlay mDefaultOverlay;
    private boolean mIsOpenNext;

    public HiGuide(Context context) {
        mContext = context;
        init();
    }

    private void init() {
        mRootView = (ViewGroup) ((Activity) mContext).getWindow().getDecorView();
        mOverlays = new ArrayList<>();
        mDefaultOverlay = new Overlay();
        mOverlays.add(mDefaultOverlay);
    }

    public HiGuide touchDismiss(boolean isDismiss) {
        mDefaultOverlay.touchDismiss(isDismiss);
        return this;
    }

    public HiGuide bgColor(int color) {
        mDefaultOverlay.bgColor(color);
        return this;
    }

    public HiGuide addHightLightClickListener(View.OnClickListener listener) {
        mDefaultOverlay.addHightLightClickListener(listener);
        return this;
    }

    public HiGuide addGuideViewClickListener(View.OnClickListener listener) {
        mDefaultOverlay.addGuideViewClickListener(listener);
        return this;
    }

    public HiGuide addHightLight(View view, int[] expand, @Shape int shape, Overlay.Tips tips) {
        mDefaultOverlay.addHightLight(view, expand, shape, tips);
        return this;
    }

    public HiGuide nextOverLay(Overlay overlay) {
        mOverlays.add(overlay);
        return this;
    }

    public void show() {
        mIsOpenNext = mOverlays.size() > 1;

        final Overlay overlay = mOverlays.get(0);
        mGuideView = new GuideView(mContext, overlay);
        mGuideView.setId(R.id.guide_view);
        if (mRootView instanceof FrameLayout) {
            ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            mRootView.addView(mGuideView, mRootView.getChildCount(), lp);
        } else {
            FrameLayout frameLayout = new FrameLayout(mContext);
            ViewGroup parent = (ViewGroup) mRootView.getParent();
            parent.removeView(mRootView);
            parent.addView(frameLayout, mRootView.getLayoutParams());
            ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            frameLayout.addView(mRootView, lp);
        }
        mGuideView.addTipsViews();
        mGuideView.setRemoveCallback(new GuideView.RemoveCallback() {
            @Override
            public void callback() {
                mGuideView = null;
                if (mIsOpenNext) {
                    mOverlays.remove(0);
                    show();
                }
            }
        });
    }

    public GuideView getGuideView() {
        if (mGuideView != null) {
            return mGuideView;
        }
        return ((Activity) mContext).findViewById(R.id.guide_view);
    }

    public static final int SHAPE_CIRCLE = 0x21;
    public static final int SHAPE_OVAL = 0x22;
    public static final int SHAPE_RECT = 0x23;

    @IntDef({SHAPE_CIRCLE, SHAPE_OVAL, SHAPE_RECT})
    @interface Shape {

    }
}
