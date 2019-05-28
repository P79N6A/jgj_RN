package com.jizhi.jlongg.main.util.shadow;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;

/**
 * Created by Administrator on 2017/5/4 0004.
 */

public class CustomShadowViewDrawable extends Drawable {
    /**
     * 画笔
     */
    private Paint paint;
    /**
     * 属性
     */
    private CustomShadowProperty shadowProperty;
    private RectF drawRect;

    public CustomShadowViewDrawable(CustomShadowProperty shadowProperty, int color) {
        this.shadowProperty = shadowProperty;
        this.paint = new Paint();
        this.paint.setAntiAlias(true);
        this.paint.setFilterBitmap(true);
        this.paint.setDither(true);
        this.paint.setStyle(Paint.Style.FILL);
        this.paint.setColor(color);
        this.paint.setShadowLayer((float) shadowProperty.getShadowRadius(), (float) shadowProperty.getShadowDx(), (float) shadowProperty.getShadowDy(), shadowProperty.getShadowColor());
        this.drawRect = new RectF();
    }

    protected void onBoundsChange(Rect bounds) {
        super.onBoundsChange(bounds);
        if (bounds.right - bounds.left > 0 && bounds.bottom - bounds.top > 0) {
            int width = (bounds.right - bounds.left);
            int height = (bounds.bottom - bounds.top);
            int shadowRadius = shadowProperty.getShadowRadius();
            this.drawRect = new RectF(bounds.left + shadowRadius, bounds.top + shadowRadius, width - shadowRadius, height - shadowRadius - this.shadowProperty.getShadowDy());
            this.invalidateSelf();
        }
    }

    public void draw(Canvas canvas) {
        canvas.drawRoundRect(this.drawRect, shadowProperty.getShadowRadius(), shadowProperty.getShadowRadius(), this.paint);
    }


    public void setAlpha(int alpha) {
    }

    public void setColorFilter(ColorFilter cf) {
    }

    @Override
    public int getOpacity() {
        return 0;
    }

}
