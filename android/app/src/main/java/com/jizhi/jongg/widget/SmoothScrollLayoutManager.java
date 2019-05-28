package com.jizhi.jongg.widget;

import android.content.Context;
import android.support.v7.widget.LinearLayoutManager;

/**
 * Recycle滚动动画
 */
public class SmoothScrollLayoutManager extends LinearLayoutManager {

    public SmoothScrollLayoutManager(Context context, int orientation, boolean reverseLayout) {
        super(context, orientation, reverseLayout);
    }

//    @Override
//    public void smoothScrollToPosition(RecyclerView recyclerView, RecyclerView.State state, final int position) {
//        LinearSmoothScroller smoothScroller = new LinearSmoothScroller(recyclerView.getContext()) {
//            // 返回：滑过1px时经历的时间(ms)。
//            @Override
//            protected float calculateSpeedPerPixel(DisplayMetrics displayMetrics) {
////                LUtils.e("value:" + 150f / displayMetrics.densityDpi);
////                return LinearSmoothScroller.SNAP_TO_START;
////                return 150f / displayMetrics.densityDpi;
////                return 25f / displayMetrics.densityDpi;
//                return 1f;
//            }
//        };
//        smoothScroller.setTargetPosition(position);
//        startSmoothScroll(smoothScroller);
//    }
}