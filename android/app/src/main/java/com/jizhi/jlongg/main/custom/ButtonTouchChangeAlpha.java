package com.jizhi.jlongg.main.custom;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.Button;

public class ButtonTouchChangeAlpha extends Button implements OnTouchListener {

    public ButtonTouchChangeAlpha(Context context) {
        super(context);
        setOnTouchListener(this);
    }

    public ButtonTouchChangeAlpha(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setOnTouchListener(this);
    }

    public ButtonTouchChangeAlpha(Context context, AttributeSet attrs) {
        super(context, attrs);
        setOnTouchListener(this);
    }

    @SuppressLint("NewApi")
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                this.setAlpha(0.5F);
                break;
            case MotionEvent.ACTION_CANCEL:
                this.setAlpha(1.0F);
                break;
            case MotionEvent.ACTION_UP:
                this.setAlpha(1.0F);
                break;
            default:
                break;
        }
        return false;
    }


}
