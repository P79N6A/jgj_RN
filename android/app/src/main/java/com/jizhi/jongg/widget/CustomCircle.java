package com.jizhi.jongg.widget;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WeatherAttribute;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2016/2/24.
 */
public class CustomCircle extends View {
    /**
     * 天气信息
     */
    private List<WeatherAttribute> list = new ArrayList<>();
    /**
     * 画笔
     */
    private Paint mPaint;
    /**
     * 画图片的画笔
     */
    private Paint mBitmapPaint;
    /**
     * 圆的半径
     */
    private int radius;


    public CustomCircle(Context context) {
        super(context);
        init();
    }

    public CustomCircle(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CustomCircle(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        mPaint = new Paint();
        mPaint.setAntiAlias(true); //设置画笔为无锯齿
        mPaint.setStyle(Paint.Style.FILL);               //实心效果
        mPaint.setColor(Color.parseColor("#f1f1f1"));     //设置画笔颜色


        mBitmapPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBitmapPaint.setFilterBitmap(true);
        mBitmapPaint.setDither(true);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        setMeasuredDimension(widthMeasureSpec, heightMeasureSpec);
        radius = getMeasuredWidth() / 2;
    }


    public List<WeatherAttribute> getList() {
        return list;
    }

    public void setList(List<WeatherAttribute> list) {
        this.list = list;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawCircle(radius, radius, radius, mPaint); //绘制边框
        Bitmap shadow = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.weather_shadow), getWidth(), getHeight(), true); //画阴影图片
        if (list == null || list.size() == 0) {
            canvas.drawBitmap(shadow, 0, 0, null);
            return;
        }
        switch (list.size()) {
            case 1: //当天气选中1种时的呈现效果
                handlerOneWeather(canvas);
                break;
            case 2: //当天气选中2种时的呈现效果
                handlerTwoWeather(canvas);
                break;
            case 3: //当天气选中3种时的呈现效果
                handlerThreeWeather(canvas);
                break;
            case 4: ///当天气选中4种时的呈现效果
                handlerFourWeather(canvas);
                break;
        }
        canvas.drawBitmap(shadow, 0, 0, null);
    }

    private Paint getLinePaint() {
        Paint linePaint = new Paint();
        linePaint.setColor(Color.parseColor("#ffffff"));
        linePaint.setAntiAlias(true);                       //设置画笔为无锯齿
        linePaint.setStrokeWidth(DensityUtils.dp2px(getContext(), 4));              //线宽
        return linePaint;
    }

    /**
     * 处理天气只有一种的情况
     *
     * @param canvas
     */
    private void handlerOneWeather(Canvas canvas) {
        if (list.size() < 1) {
            return;
        }
        Bitmap bitmap = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),
                list.get(0).getWeatherIcon()), getWidth() / 2, getHeight() / 2, true); //图片大小取圆大小的一半
        canvas.drawBitmap(bitmap, getWidth() / 2 - bitmap.getWidth() / 2, getHeight() / 2 - bitmap.getHeight() / 2, mBitmapPaint); //摆放在正中的位置
    }

    /**
     * 处理天气只有两种的情况
     *
     * @param canvas
     */
    private void handlerTwoWeather(Canvas canvas) {
        if (list.size() < 2) {
            return;
        }
        canvas.drawLine(0, radius, getWidth(), radius + DensityUtils.dp2px(getContext(), 1), getLinePaint()); //绘制中线
        Bitmap bitmapTop = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(0).getWeatherIcon()), getWidth() / 3, getHeight() / 3, true);
        Bitmap bitmapBottom = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(1).getWeatherIcon()), getWidth() / 3, getHeight() / 3, true);
        int width = getWidth() / 2 - bitmapTop.getWidth() / 2;
        int cellHeight = getHeight() / 2; //上下均分的单元格大小
        canvas.drawBitmap(bitmapTop, width, cellHeight / 2 - bitmapTop.getHeight() / 2, mBitmapPaint); //圆形顶部天气图标 居中显示
        canvas.drawBitmap(bitmapBottom, width, cellHeight / 2 + cellHeight - bitmapTop.getHeight() / 2, mBitmapPaint); //圆形底部天气图标 居中显示
    }

    /**
     * 处理天气只有三种的情况
     *
     * @param canvas
     */
    private void handlerThreeWeather(Canvas canvas) {
        if (list.size() < 3) {
            return;
        }
        Bitmap bitmapFirst = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(0).getWeatherIcon()), getWidth() / 4, getHeight() / 4, true);
        Bitmap bitmapTwo = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(1).getWeatherIcon()), getWidth() / 4, getHeight() / 4, true);
        Bitmap bitmapThree = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(2).getWeatherIcon()), getWidth() / 4, getHeight() / 4, true);
        int width = getWidth() / 2 - bitmapFirst.getWidth() / 2;
        int cellHeight = getHeight() / 3;
        int bitmapHeight = bitmapFirst.getHeight() / 2;
        canvas.drawBitmap(bitmapFirst, width, cellHeight / 2 - bitmapHeight, mBitmapPaint); //圆形顶部天气图标 居中显示
        canvas.drawBitmap(bitmapTwo, width, cellHeight + cellHeight / 2 - bitmapHeight, mBitmapPaint); //圆形顶部天气图标 居中显示
        canvas.drawBitmap(bitmapThree, width, cellHeight * 2 + cellHeight / 2 - bitmapHeight, mBitmapPaint); //圆形顶部天气图标 居中显示

        Paint linePaint = getLinePaint();
        int firstLine = getHeight() / 3; //第一条线
        int secondLine = firstLine << 1; //第二条线
        canvas.drawLine(0, firstLine, getWidth(), firstLine + DensityUtils.dp2px(getContext(), 1), linePaint);           //绘制圆形
        canvas.drawLine(0, secondLine, getWidth(), secondLine + DensityUtils.dp2px(getContext(), 1), linePaint);           //绘制圆形
    }

    /**
     * 处理天气只有四种的情况
     *
     * @param canvas
     */
    private void handlerFourWeather(Canvas canvas) {
        if (list.size() < 4) {
            return;
        }

        int cellWidth = (int) (getWidth() / 3.8);
        int cellHeight = (int) (getHeight() / 3.8);

        Bitmap bitmapFirst = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(0).getWeatherIcon()), cellWidth, cellWidth, true);
        Bitmap bitmapTwo = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(1).getWeatherIcon()), cellWidth, cellWidth, true);
        Bitmap bitmapThree = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(2).getWeatherIcon()), cellWidth, cellWidth, true);
        Bitmap bitmapFour = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(), list.get(3).getWeatherIcon()), cellWidth, cellWidth, true);

        int centerWidth = getWidth() / 2;
        int centerHeight = getHeight() / 2;


        float off = cellWidth * 1.3f; //偏移量

        canvas.drawBitmap(bitmapFirst, centerWidth - off, centerHeight - off, mBitmapPaint); //左上
        canvas.drawBitmap(bitmapTwo, centerWidth + off - cellWidth, centerHeight - off, mBitmapPaint); //右上


        canvas.drawBitmap(bitmapThree, centerWidth - off, centerHeight + off - cellHeight, mBitmapPaint); //左下
        canvas.drawBitmap(bitmapFour, centerWidth + off - cellWidth, centerHeight + off - cellHeight, mBitmapPaint); //右下

        Paint linePaint = getLinePaint();
        int vertiLine = getWidth() >> 1; //垂直线条
        int horizontalLine = getHeight() >> 1; //水平线条
        canvas.drawLine(vertiLine, 0, vertiLine + DensityUtils.dp2px(getContext(), 1), getHeight(), linePaint);           //绘制垂直线条
        canvas.drawLine(0, horizontalLine, getWidth(), horizontalLine + DensityUtils.dp2px(getContext(), 1), linePaint);           //绘制水平线条
    }
}
