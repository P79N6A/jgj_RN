
package com.jizhi.jongg.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathEffect;
import android.util.AttributeSet;
import android.view.View;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;

public class DashView extends View {
    private static final String TAG = "DashView";
    public static final int DEFAULT_DASH_WIDTH = 100;
    public static final int DEFAULT_LINE_WIDTH = 100;
    public static final int DEFAULT_LINE_HEIGHT = 10;
    public static final int DEFAULT_LINE_COLOR = 0x9E9E9E;

    /**
     * 虚线的方向
     */
    public static final int ORIENTATION_HORIZONTAL = 0;
    public static final int ORIENTATION_VERTICAL = 1;
    /**
     * 默认为水平方向
     */
    public static final int DEFAULT_DASH_ORIENTATION = ORIENTATION_HORIZONTAL;
    /**
     * 间距宽度
     */
    private float dashWidth;
    /**
     * 线段高度
     */
    private float lineHeight;
    /**
     * 线段颜色
     */
    private int lineColor;

    private int lineWidth = DensityUtils.dp2px(getContext(), 2);


    public DashView(Context context) {
        this(context, null);
    }

    public DashView(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.DashView);
        dashWidth = typedArray.getDimension(R.styleable.DashView_dashWidth, DEFAULT_DASH_WIDTH);
        lineHeight = typedArray.getDimension(R.styleable.DashView_lineHeight, DEFAULT_LINE_HEIGHT);
        lineColor = typedArray.getColor(R.styleable.DashView_lineColors, DEFAULT_LINE_COLOR);
        typedArray.recycle();

    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawHorizontalLine(canvas);
    }

    /**
     * 画水平方向虚线
     *
     * @param canvas
     */
    public void drawHorizontalLine(Canvas canvas) {
        Paint paint = new Paint();
        paint.setStyle(Paint.Style.STROKE);
        paint.setColor(lineColor);
        Path path = new Path();

        path.moveTo(0, lineHeight);
        path.lineTo(this.getWidth(), lineHeight);

        /**
         * new DashPathEffect(new float[] { 8, 10, 8, 10}, 0);
         指定了绘制8px的实线,再绘制10px的透明,再绘制8px的实线,再绘制10px的透明,
         依次重复来绘制达到path对象的长度。
         phase参数指定了绘制的虚线相对了起始地址（Path起点）的取余偏移（对路径总长度）。
         new DashPathEffect(new float[] { 8, 10, 8, 10}, 0);
         这时偏移为0，先绘制实线，再绘制透明。
         new DashPathEffect(new float[] { 8, 10, 8, 10}, 8);
         这时偏移为8，先绘制了透明，再绘制了实线.(实线被偏移过去了)*/

        PathEffect effects = new DashPathEffect(new float[]{lineWidth, lineWidth, lineWidth, lineWidth}, 0);
        paint.setPathEffect(effects);
        canvas.drawPath(path, paint);
    }

}