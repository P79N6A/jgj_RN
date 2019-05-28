package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.AbsListView;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;

/**
 * Created by Administrator on 2018-4-9.
 */

public class PinnedListView extends ExpandableListView {
    /**
     * 固定滑动的View
     */
    private View pinnedView;
    /**
     * 上次滚动的GroupPosition
     */
    private int lastGroupPosition = -1;
    /**
     * 当Group滑动时候下标变化的时候需要汇调度的函数
     */
    private OnGroupPositionChangeListener listener;
    /**
     * 列表适配器
     */
    private BaseExpandableListAdapter adapter;


    public PinnedListView(Context context) {
        super(context);
        init();
    }

    public PinnedListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    public PinnedListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        setOnScrollListener(new OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {

            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                if (pinnedView == null || adapter == null) {
                    return;
                }
                final long flatPos = getExpandableListPosition(firstVisibleItem);
                int groupPosition = ExpandableListView.getPackedPositionGroup(flatPos);
                int childPosition = ExpandableListView.getPackedPositionChild(flatPos);
                View childView = getChildAt(0);
                if (childView != null) {
                    MarginLayoutParams params = (MarginLayoutParams) pinnedView.getLayoutParams();
                    if (childPosition == adapter.getChildrenCount(groupPosition) - 1) { //已经滑动到最后一个了
                        pinnedView.setVisibility(View.VISIBLE);
                        int pinnedHeight = pinnedView.getHeight();
                        if (pinnedHeight >= childView.getBottom()) {
                            int distanc = childView.getBottom() - pinnedHeight;//获取移动的距离
                            params.topMargin = distanc;
                        }
                    } else {
                        pinnedView.setVisibility(View.VISIBLE);
                        params.topMargin = 0;
                    }

//                    LUtils.e("groupPosition:" + groupPosition + "    childPosition:" + childPosition + "     height:" + pinnedView.getHeight() + "       bottom:" + firstChild.getBottom());
                    if (groupPosition != lastGroupPosition) {
                        if (listener != null) {
                            listener.changeGroup(groupPosition, childPosition);
                        }
                        lastGroupPosition = groupPosition;
                    }
                    pinnedView.setLayoutParams(params);
                }
            }
        });
    }

    public void setPinnedView(View pinnedView) {
        this.pinnedView = pinnedView;
    }


    public void setAdapter(BaseExpandableListAdapter adapter) {
        super.setAdapter(adapter);
        this.adapter = adapter;
    }


    public interface OnGroupPositionChangeListener {
        public void changeGroup(int groupPosition, int childPosition);
    }

    public OnGroupPositionChangeListener getListener() {
        return listener;
    }

    public void setListener(OnGroupPositionChangeListener listener) {
        this.listener = listener;
    }
}
