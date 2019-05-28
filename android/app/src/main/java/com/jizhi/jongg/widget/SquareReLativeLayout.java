package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

/**
 * 功能:
 * 作者：Administrator
 * 时间: 2016-5-31 16:57
 */
public class SquareReLativeLayout extends RelativeLayout {

    public SquareReLativeLayout(Context context) {
        super(context);
    }

    public SquareReLativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        setMeasuredDimension(getMeasuredWidth(), getMeasuredWidth());
    }

}
