package com.jizhi.jlongg.main.custom;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PathEffect;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.View;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;

@SuppressLint("NewApi")
public class DashedLineView extends View {

	private int lineColor;

	private Paint paint;

	private Path path;

	public DashedLineView(Context context) {
		this(context, null);
	}

	public DashedLineView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	public DashedLineView(Context context, AttributeSet attrs) {
		super(context, attrs);
		TypedArray a = context.obtainStyledAttributes(attrs,R.styleable.dashedline);
		// 我们在attrs.xml中<declare-styleable name="dashedline">节点下
		// 添加了<attr name="lineColor" format="color" />
		// 表示这个属性名为lineColor类型为color。当用户在布局文件中对它有设定值时
		// 可通过TypedArray获得它的值当用户无设置值是采用默认值0XFF00000
		lineColor = a.getColor(R.styleable.dashedline_lineColor, getContext().getResources().getColor(R.color.gray_9e9e9e));
		a.recycle();
		paint = new Paint();
		paint.setTypeface(Typeface.DEFAULT_BOLD);
		paint.setStyle(Paint.Style.STROKE);// 空心
		paint.setColor(lineColor);
		path = new Path();
	}

	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		int pd = DensityUtils.dp2px(getContext(),2);
		path.moveTo(0, 0);
		path.lineTo(0, getHeight());
		PathEffect effects = new DashPathEffect(new float[]{pd,pd,pd,pd}, 0);
		paint.setPathEffect(effects);
		canvas.drawPath(path, paint);
	}
}
