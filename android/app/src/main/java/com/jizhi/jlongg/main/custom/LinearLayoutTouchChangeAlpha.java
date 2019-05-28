package com.jizhi.jlongg.main.custom;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.LinearLayout;

public class LinearLayoutTouchChangeAlpha extends LinearLayout {

    public LinearLayoutTouchChangeAlpha(Context context) {
        super(context);
    }

    public LinearLayoutTouchChangeAlpha(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                this.setAlpha(0.4F);
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
