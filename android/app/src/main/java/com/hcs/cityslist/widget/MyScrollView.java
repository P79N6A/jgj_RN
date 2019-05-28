package com.hcs.cityslist.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

public class MyScrollView extends ScrollView {
    private static final String TAG = MyScrollView.class.getSimpleName();

    public MyScrollView(Context context) {
        super(context);
    }

    public MyScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyScrollView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);

//        Log.d(TAG, "onScrollChanged: 竖直高度t = " + t);
//        Log.d(TAG, "onScrollChanged: 竖直高度oldt = " + oldt);
        //将高度传出去
        if (mOnScrollHeightListener != null) {
            mOnScrollHeightListener.onScrollHeight(t);
        }
    }


    //滚动到底部时，clampedY变为true，其余情况为false，通过回调将状态传出去即可。
    @Override
    protected void onOverScrolled(int scrollX, int scrollY, boolean clampedX, boolean clampedY) {
        super.onOverScrolled(scrollX, scrollY, clampedX, clampedY);
        if (scrollY != 0 && null != mOnScrollToBottomListener) {
            mOnScrollToBottomListener.onScrollBottomListener(clampedY);
        }
    }

    private OnScrollToBottomListener mOnScrollToBottomListener;

    public void setOnScrollToBottomLintener(OnScrollToBottomListener listener) {
        mOnScrollToBottomListener = listener;
    }

    public interface OnScrollToBottomListener {
        public void onScrollBottomListener(boolean isBottom);
    }

    //复杂实现方式，将滚动距离传出去，获取滚动的位置，来判断也可。
    public interface OnScrollHeightListener {
        void onScrollHeight(int scrollY);
    }

    private OnScrollHeightListener mOnScrollHeightListener;

    public void setOnScrollHeightListener(OnScrollHeightListener onScrollHeightListener) {
        mOnScrollHeightListener = onScrollHeightListener;
    }
    //    public void
}
