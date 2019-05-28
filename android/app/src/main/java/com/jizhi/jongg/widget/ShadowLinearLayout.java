package com.jizhi.jongg.widget;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import com.jizhi.jlongg.main.util.shadow.ShadowUtil;


/**
 * Created by Administrator on 2017/12/11 0011.
 */

public class ShadowLinearLayout extends LinearLayout {
    public ShadowLinearLayout(Context context) {
        super(context);
        setShadow(context);
    }

    public ShadowLinearLayout(final Context context, AttributeSet attrs) {
        super(context, attrs);
        setShadow(context);
    }

    public ShadowLinearLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setShadow(context);
    }

    public ShadowLinearLayout(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        setShadow(context);
    }

    private void setShadow(final Context context) {
        //当布局加载完毕 设置阴影
        getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                ShadowUtil.setShadow(context, ShadowLinearLayout.this);
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                if (Build.VERSION.SDK_INT < 16) {
                    getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }
}
