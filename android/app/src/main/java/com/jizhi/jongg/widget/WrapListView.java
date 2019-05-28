package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * ScrollView里面嵌套的ListView，显示不完全
 *
 * @author lilong
 * @version 1.0
 * @time 2015-11-25 下午6:20:22
 */
public class WrapListView extends ListView {

    public WrapListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int heightSpec;
        if (getLayoutParams().height == LayoutParams.WRAP_CONTENT) {
            heightSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
        } else {
            heightSpec = heightMeasureSpec;
        }
        super.onMeasure(widthMeasureSpec, heightSpec);
    }

}