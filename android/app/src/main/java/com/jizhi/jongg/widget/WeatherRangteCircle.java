package com.jizhi.jongg.widget;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.support.v4.content.ContextCompat;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.MotionEvent;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WeatherAttribute;


/**
 * Created by Administrator on 2016/2/24.
 */
public class WeatherRangteCircle extends TextView {

    /**
     * 左上下标
     */
    public static final int TOP_LEFT = 1;
    /**
     * 右上下标
     */
    public static final int TOP_RIGHT = 2;
    /**
     * 左下下标
     */
    public static final int BOTTOM_LEFT = 3;
    /**
     * 右下下标
     */
    public static final int BOTTOM_RIGHT = 4;
    /**
     * 天气总数量
     */
    public static final int WEATHER_TOTAL_SIZE = 4;

    /**
     * 天气的方向
     */
    private int weatherDirection;
    /**
     * 天气数据
     */
    private WeatherAttribute weatherAttribute;

    public WeatherRangteCircle(Context context) {
        super(context);
    }

    public WeatherRangteCircle(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public WeatherRangteCircle(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray typedArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.WeatherRangteCircle, defStyleAttr, 0);
        int n = typedArray.getIndexCount();
        for (int i = 0; i < n; i++) {
            int attr = typedArray.getIndex(i);
            switch (attr) {
                case R.styleable.WeatherRangteCircle_direction: //获取天气的方向
                    weatherDirection = typedArray.getInt(R.styleable.WeatherRangteCircle_direction, 0);
                    break;
            }
        }
        typedArray.recycle();
        setGravity(Gravity.CENTER);
        setWeaherBackground();
    }


    /**
     * 设置天气背景色
     */
    public void setWeaherBackground() {

        int topLeftRadius = 0;
        int topRightRadius = 0;
        int bottomLeftRadius = 0;
        int bottomRightRadius = 0;

        /*1、2两个参数表示左上角，3、4表示右上角，5、6表示右下角，7、8表示左下角
        gradientDrawable.setCornerRadii(new float[] { topLeftRadius,
                topLeftRadius, topRightRadius, topRightRadius,
                bottomRightRadius, bottomRightRadius, bottomLeftRadius,
                bottomLeftRadius });*/

        int radius = DensityUtils.dp2px(getContext(), 50); //圆角的角度
        GradientDrawable shape = new GradientDrawable();
        switch (weatherDirection) {
            case TOP_LEFT: //左上
                topLeftRadius = radius;
                topRightRadius = radius;
                bottomLeftRadius = radius;
                break;
            case TOP_RIGHT: //右上
                topLeftRadius = radius;
                topRightRadius = radius;
                bottomRightRadius = radius;
                break;
            case BOTTOM_LEFT: //左下
                topLeftRadius = radius;
                bottomLeftRadius = radius;
                bottomRightRadius = radius;
                break;
            case BOTTOM_RIGHT: //右下
                topRightRadius = radius;
                bottomLeftRadius = radius;
                bottomRightRadius = radius;
                break;
        }
        float[] flo = new float[]{topLeftRadius, topLeftRadius, topRightRadius, topRightRadius, bottomRightRadius, bottomRightRadius, bottomLeftRadius, bottomLeftRadius};
        shape.setShape(GradientDrawable.RECTANGLE); //设置为正方形
        shape.setCornerRadii(flo); //设置圆角角度
        shape.setColor(ContextCompat.getColor(getContext(), R.color.color_fafafa)); //设置背景色为#fafafa
        shape.setStroke(DensityUtils.dp2px(getContext(), 1), ContextCompat.getColor(getContext(), weatherAttribute == null ? R.color.color_cccccc : weatherAttribute.getWeatherColor()));
        Utils.setBackGround(this, shape);
        setWetherText();

    }

    /**
     * 设置天气的文本
     */
    public void setWetherText() {
        if (weatherAttribute == null) {
            SpannableString spannableString = new SpannableString("天气\n" + weatherDirection);

            ForegroundColorSpan textColor = new ForegroundColorSpan(Color.parseColor("#999999"));
            ForegroundColorSpan numberColor = new ForegroundColorSpan(Color.parseColor("#eb4e4e"));

            AbsoluteSizeSpan numberSizeSpan = new AbsoluteSizeSpan(DensityUtils.sp2px(getContext(), 21));
            AbsoluteSizeSpan textSizeSpan = new AbsoluteSizeSpan(DensityUtils.sp2px(getContext(), 10));

            spannableString.setSpan(textColor, 0, 2, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            spannableString.setSpan(numberColor, 3, 4, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);

            spannableString.setSpan(textSizeSpan, 0, 2, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            spannableString.setSpan(numberSizeSpan, 3, 4, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            setText(spannableString);

        } else {
            setText(weatherAttribute.getWeatherName());
            setTextColor(ContextCompat.getColor(getContext(), weatherAttribute.getWeatherColor()));
            setTextSize(16);
            TextPaint tp = getPaint();
            tp.setFakeBoldText(true); //设置字体加粗
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
//        // 建立Paint 物件
//        Paint paint1 = new Paint();
//        // 设定颜色
//        paint1.setColor(Color.WHITE);
//
//        paint1.setAntiAlias(true);
//
//        setLayerType(LAYER_TYPE_SOFTWARE, paint1);
//        int range = DensityUtils.dp2px(getContext(), 4);
//        int radius = getWidth() / 2;
//
//        // 设定阴影(柔边, X 轴位移, Y 轴位移, 阴影颜色)
//        paint1.setShadowLayer(range, 0, 0, Color.parseColor("#d7252c"));
//
//        canvas.drawCircle(radius, radius, radius - range, paint1);
    }

    @SuppressLint("NewApi")
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                this.setAlpha(0.5F);
                break;
            case MotionEvent.ACTION_MOVE:
                break;
            case MotionEvent.ACTION_UP:
                this.setAlpha(1.0F);
                break;
            case MotionEvent.ACTION_CANCEL:
                this.setAlpha(1.0F);
                break;
            default:
                break;
        }
        return super.onTouchEvent(event);
    }

    public WeatherAttribute getWeatherAttribute() {
        return weatherAttribute;
    }

    public void setWeatherAttribute(WeatherAttribute weatherAttribute) {
        this.weatherAttribute = weatherAttribute;
        setWeaherBackground();
    }

}
