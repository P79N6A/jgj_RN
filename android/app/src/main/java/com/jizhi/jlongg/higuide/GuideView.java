package com.jizhi.jlongg.higuide;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.higuide.Overlay.HightLight;
import com.jizhi.jlongg.higuide.Overlay.Tips;
import com.jizhi.jlongg.higuide.Overlay.Tips.Margin;
import com.liaoinstan.springview.utils.DensityUtil;


/**
 * Create By Zii at 2018/5/3.
 */
class GuideView extends FrameLayout {

    private Overlay mOverlay;
    private Paint mPaint;
    private Path mBgPath;
    private Path mShapePath;
    private RemoveCallback mRemoveCallback;

    public GuideView(Context context, Overlay overlay) {
        super(context);
        mOverlay = overlay;
        init();
    }

    private void init() {
        final int bgColor = mOverlay.getColorBg();

        mBgPath = new Path();
        mShapePath = new Path();


        mPaint = new Paint();
        mPaint.setColor(bgColor);
        mPaint.setDither(true);
        mPaint.setAntiAlias(true);

        setWillNotDraw(false);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        mBgPath.reset();
        mShapePath.reset();

        mBgPath.addRect(0, 0, getWidth(), getHeight(), Path.Direction.CW);

        for (Overlay.HightLight hightLight : mOverlay.getHightLightList()) {
            Path shapePath = calcHightLightShapePath(hightLight, mShapePath);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                mBgPath.op(shapePath, Path.Op.XOR);
            }
        }

        canvas.drawPath(mBgPath, mPaint);
    }

    private Path calcHightLightShapePath(HightLight hightLight, Path shapePath) {
        shapePath.reset();
        switch (hightLight.getShape()) {
            case HiGuide.SHAPE_CIRCLE:
                shapePath.addCircle(hightLight.getRectF().centerX(),
                        hightLight.getRectF().centerY(),
                        hightLight.getRadius(), Path.Direction.CW);
                break;
            case HiGuide.SHAPE_OVAL:
                shapePath.addOval(hightLight.getRectF(), Path.Direction.CW);
                break;
            case HiGuide.SHAPE_RECT:
//                shapePath.addRect(hightLight.getRectF(), Path.Direction.CW);
                int radius = DensityUtil.dp2px(4); //设置圆角的弧度
                float[] radiusArray = {radius, radius, radius, radius, radius, radius, radius, radius};
                shapePath.addRoundRect(hightLight.getRectF(), radiusArray, Path.Direction.CW);
                break;
            default:
                break;
        }
        return shapePath;
    }

    public void addTipsViews() {
        for (HightLight hightLight : mOverlay.getHightLightList()) {

            if (hightLight != null
                    && hightLight.getTips() != null
                    && hightLight.getTips().layoutRes != -1) {

                addTipsView(hightLight.getTips(), hightLight.getRectF());
            }
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {
            //点击高亮
            if (mOverlay.getOnClickHightLightListener() != null) {
                float x = event.getX();
                float y = event.getY();
                for (RectF rectF : mOverlay.getHightLightAreas()) {
                    if (rectF.contains(x, y)) {
                        mOverlay.getOnClickHightLightListener().onClick(this);
                        remove();
                        return super.onTouchEvent(event); //点击高亮后不做其他的处理了，直接返回
                    }
                }
            }
            //全局点击
            if (mOverlay.getOnClickGuideViewListener() != null) {
                mOverlay.getOnClickGuideViewListener().onClick(this);
            }
            if (mOverlay.isTouchDismiss()) {
                remove();
            }
        }

        return true;
    }

    private void remove() {
        ViewGroup parent = (ViewGroup) getParent();
        if (parent instanceof RelativeLayout || parent instanceof FrameLayout) {
            parent.removeView(this);
        } else {
            parent.removeView(this);
            View origin = parent.getChildAt(0);
            ViewGroup graParent = (ViewGroup) parent.getParent();
            graParent.removeView(parent);
            graParent.addView(origin, parent.getLayoutParams());
        }

        if (mRemoveCallback != null) {
            mRemoveCallback.callback();
        }
    }

    public void addTipsView(Tips tips, RectF hlRectF) {
        View tipsView = LayoutInflater.from(getContext()).inflate(tips.layoutRes, this, false);
        int tipsWidth = GuideUtils.getMeasuredWidth(tipsView);
        int tipsHeight = GuideUtils.getMeasuredHeight(tipsView);
        Margin margin = tips.margin == null ? new Margin(0, 0, 0, 0) : tips.margin;
        LayoutParams lp = (LayoutParams) tipsView.getLayoutParams();

        LUtils.e("hlRectF:" + hlRectF.top + "            " + hlRectF.bottom + "      tipsView.getHeight:" + tipsHeight);
        switch (tips.to) {
            case Tips.TO_LEFT_OF:
                lp.leftMargin = (int) (hlRectF.left - tipsWidth - margin.right);
                switch (tips.align) {
                    case Tips.ALIGN_BOTTOM:
                        lp.topMargin = (int) (hlRectF.bottom + margin.top);
                        break;
                    case Tips.ALIGN_TOP:
                        lp.topMargin = (int) (hlRectF.top - margin.bottom) - tipsHeight;
//                        lp.bottomMargin = (int) (hlRectF.top + margin.bottom);
                        break;
                    default:
                        lp.topMargin = margin.top;
                        break;
                }
                break;
            case Tips.TO_RIGHT_OF:
                lp.leftMargin = (int) (hlRectF.right + margin.left);
                switch (tips.align) {
                    case Tips.ALIGN_BOTTOM:
                        lp.topMargin = (int) (hlRectF.bottom + margin.top);
                        break;
                    case Tips.ALIGN_TOP:
                        lp.topMargin = (int) (hlRectF.top + margin.top);
                        break;
                    default:
                        lp.topMargin = margin.top;
                        break;
                }
                break;
            case Tips.TO_CENTER_OF:
                lp.leftMargin = (int) ((hlRectF.left + hlRectF.right - hlRectF.left) / 2);
                switch (tips.align) {
                    case Tips.ALIGN_BOTTOM:
                        lp.topMargin = (int) (hlRectF.bottom + margin.top);
                        break;
                    case Tips.ALIGN_TOP:
                        lp.topMargin = (int) (hlRectF.top - margin.bottom) - tipsHeight;
                        break;
                    default:
                        lp.topMargin = margin.top;
                        break;
                }
                break;
            default:
                lp.leftMargin = margin.left;
                lp.topMargin = margin.top;
                lp.rightMargin = margin.right;
                lp.bottomMargin = margin.bottom;
                break;
        }

        tipsView.setLayoutParams(lp);

        addView(tipsView, lp);
    }

    public void setRemoveCallback(RemoveCallback removeCallback) {
        mRemoveCallback = removeCallback;
    }

    public interface RemoveCallback {

        void callback();
    }
}
