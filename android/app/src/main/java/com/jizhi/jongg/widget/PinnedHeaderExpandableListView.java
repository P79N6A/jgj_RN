package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnGroupClickListener;

public class PinnedHeaderExpandableListView extends ExpandableListView
        implements OnGroupClickListener {

    private scrollCallBack listener;

    public PinnedHeaderExpandableListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        registerListener();
    }

    public PinnedHeaderExpandableListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        registerListener();
    }

    public PinnedHeaderExpandableListView(Context context) {
        super(context);
        registerListener();
    }

    public void setScrollCallBack(scrollCallBack listener) {
        this.listener = listener;
    }

    /**
     * Adapter 接口 . 列表必须实现此接口 .
     */
    public interface HeaderAdapter {
        public static final int PINNED_HEADER_GONE = 0;
        public static final int PINNED_HEADER_VISIBLE = 1;
        public static final int PINNED_HEADER_PUSHED_UP = 2;

        /**
         * 获取 Header 的状态
         *
         * @param groupPosition
         * @param childPosition
         * @return PINNED_HEADER_GONE, PINNED_HEADER_VISIBLE, PINNED_HEADER_PUSHED_UP
         * 其中之一
         */
        int getHeaderState(int groupPosition, int childPosition);


        /**
         * 设置组按下的状态
         *
         * @param groupPosition
         * @param status
         */
        void setGroupClickStatus(int groupPosition, int status);

        /**
         * 获取组按下的状态
         *
         * @param groupPosition
         * @return
         */
        int getGroupClickStatus(int groupPosition);
    }

    public interface scrollCallBack {
        public void gone(int groupPosition);

        public void visible(int groupPosition, int childPosition, boolean isPushed);

        public void push_up(int groupPosition, int childPosition, int bottom);

    }

    private static final int MAX_ALPHA = 255;

    private HeaderAdapter mAdapter;


    private void registerListener() {
//		setOnGroupClickListener(this);
    }

    /**
     * 点击 HeaderView 触发的事件
     */
    public void headerViewClick() {
        long packedPosition = getExpandableListPosition(this.getFirstVisiblePosition());
        int groupPosition = ExpandableListView.getPackedPositionGroup(packedPosition);
        this.collapseGroup(groupPosition);
        mAdapter.setGroupClickStatus(groupPosition, 0);
    }

    @Override
    public void setAdapter(ExpandableListAdapter adapter) {
        super.setAdapter(adapter);
        mAdapter = (HeaderAdapter) adapter;
    }

    /**
     */
    @Override
    public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
//		if (mAdapter.getGroupClickStatus(groupPosition) == 0) {
//			mAdapter.setGroupClickStatus(groupPosition, 1);
//			parent.expandGroup(groupPosition);
//		} else if (mAdapter.getGroupClickStatus(groupPosition) == 1) {
//			mAdapter.setGroupClickStatus(groupPosition, 0);
//			parent.collapseGroup(groupPosition);
//		}
        // 返回 true 才可以弹回第一行 , 不知道为什么
        return true;
    }

    public void configureHeaderView(int groupPosition, int childPosition) {
        if (listener == null || mAdapter == null) {
            return;
        }
        int state = mAdapter.getHeaderState(groupPosition, childPosition);
        switch (state) {
            case HeaderAdapter.PINNED_HEADER_GONE: {
                listener.gone(groupPosition);
                break;
            }
            case HeaderAdapter.PINNED_HEADER_VISIBLE: {
                listener.visible(groupPosition, childPosition, false);
                break;
            }
            case HeaderAdapter.PINNED_HEADER_PUSHED_UP: {
                ViewGroup viewGroup = (ViewGroup) getChildAt(0);
                int bottom = viewGroup.getBottom();
                listener.push_up(groupPosition, childPosition, bottom);
                break;
            }
        }
    }

}
