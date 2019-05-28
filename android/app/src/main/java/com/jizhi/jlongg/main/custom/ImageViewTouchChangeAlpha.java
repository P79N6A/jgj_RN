package com.jizhi.jlongg.main.custom;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.ImageView;

public class ImageViewTouchChangeAlpha extends ImageView {

    public ImageViewTouchChangeAlpha(Context context) {
        super(context);
        setClickable(true);
    }

    public ImageViewTouchChangeAlpha(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setClickable(true);
    }

    public ImageViewTouchChangeAlpha(Context context, AttributeSet attrs) {
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
