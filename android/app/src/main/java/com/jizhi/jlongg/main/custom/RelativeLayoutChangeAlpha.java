package com.jizhi.jlongg.main.custom;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.RelativeLayout;

@SuppressLint("NewApi")
public class RelativeLayoutChangeAlpha extends RelativeLayout {

    public RelativeLayoutChangeAlpha(Context context) {
        super(context);
    }


    public RelativeLayoutChangeAlpha(Context context, AttributeSet attrs,
                                     int defStyle) {
        super(context, attrs, defStyle);
    }


    public RelativeLayoutChangeAlpha(Context context, AttributeSet attrs) {
        super(context, attrs);
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


}
