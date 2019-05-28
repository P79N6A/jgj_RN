package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

import com.jizhi.jlongg.listener.ScrollViewListener;

/**
 * 作者    ScrollView.setOnScrollChangeListener() API23版本兼容的问题，
 * 弄了整整一下午的时间终于在网上找到了资料根据项目代码做出修改才解决了这个问题，故在次记录一下：
 * 时间    2019-3-15 下午 3:32
 * 文件    yzg_android_s
 * 描述
 */
public class ObservableScrollView extends ScrollView {

    private ScrollViewListener scrollViewListener = null;

    public ObservableScrollView(Context context) {
        super(context);
    }

    public ObservableScrollView(Context context, AttributeSet attrs,
                                int defStyle) {
        super(context, attrs, defStyle);
    }

    public ObservableScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void setScrollViewListener(ScrollViewListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    protected void onScrollChanged(int x, int y, int oldx, int oldy) {
        super.onScrollChanged(x, y, oldx, oldy);
        if (scrollViewListener != null) {
            scrollViewListener.onScrollChanged(this, x, y, oldx, oldy);
        }
    }
}
