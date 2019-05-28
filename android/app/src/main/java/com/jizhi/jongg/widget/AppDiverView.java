package com.jizhi.jongg.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ScreenUtils;

public class AppDiverView extends View {
    /**
     * 是否绘制第一根线条
     */
    private boolean isDrawFisrtLine = true;
    /**
     * 是否绘制背景色
     */
    private boolean isDrawBackground = true;
    /**
     * 是否绘制最后一根线条
     */
    private boolean isDrawLastLine = true;

    public AppDiverView(Context context) {
        super(context);
    }

    public AppDiverView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public AppDiverView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        // TODO Auto-generated method stub
        int allHeight = 0;
        if (isDrawFisrtLine) {
            allHeight += 1;
        }
        if (isDrawBackground) {
            allHeight += DensityUtils.dp2px(getContext(), 7);
        }
        if (isDrawLastLine) {
            allHeight += 1;
        }
        setMeasuredDimension(ScreenUtils.getScreenWidth(getContext()), allHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        Paint paint = new Paint();
        paint.setStyle(Style.FILL);// 设置非填充
        paint.setStrokeWidth(1);// 笔宽1像素
        paint.setColor(Color.parseColor("#dbdbdb"));//设置画笔颜色
        paint.setAntiAlias(true);// 锯齿不显示

        int backgroundHeight = isDrawBackground ? DensityUtils.dp2px(getContext(), 7) : 0; // 背景色的高度
        int firstLineHeight = isDrawFisrtLine ? 1 : 0; // 第一根线条的高度
        int lastLineHeight = isDrawLastLine ? 1 : 0; // 最后根线条的高度

        if (isDrawFisrtLine) {
            canvas.drawLine(0, 0, getWidth(), firstLineHeight, paint); // 绘制第一根线条
        }
        if (isDrawLastLine) {
            canvas.drawLine(0, backgroundHeight + firstLineHeight, getWidth(),
                    backgroundHeight + firstLineHeight + lastLineHeight, paint);
        }
        if (isDrawBackground) {
            Rect rect = new Rect(0, firstLineHeight, getWidth(),
                    backgroundHeight + firstLineHeight);
            paint.setColor(Color.parseColor("#ebebeb"));
            canvas.drawRect(rect, paint);
        }
    }

    public void setDrawFisrtLine(boolean isDrawFisrtLine) {
        this.isDrawFisrtLine = isDrawFisrtLine;
        requestLayout();
        invalidate();
    }

    public void setDrawBackground(boolean isDrawBackground) {
        this.isDrawBackground = isDrawBackground;
        requestLayout();
        invalidate();
    }

    public void setDrawLastLine(boolean isDrawLastLine) {
        this.isDrawLastLine = isDrawLastLine;
        requestLayout();
        invalidate();
    }

}
