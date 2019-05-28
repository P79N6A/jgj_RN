package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;

/**
 * 功能:自定义滑动监听事件
 * 时间:2017年2月24日12:42:22
 * 作者: xuj
 */
public class CustomExpandableListView extends ExpandableListView {

    /**
     * 滚动事件
     */
    private CustomScrollListener scrollListener;

    public CustomExpandableListView(Context context) {
        super(context);
        init();
    }

    public CustomExpandableListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public CustomExpandableListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

//    @Override
//    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
//        // TODO Auto-generated method stub
//        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,MeasureSpec.AT_MOST);
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
//    }

    private void init() {
        setOnScrollListener(new AbsListView.OnScrollListener() {
                                private SparseArray recordSp = new SparseArray(0);
                                private int mCurrentfirstVisibleItem = 0;

                                @Override
                                public void onScrollStateChanged(AbsListView arg0, int arg1) {
                                    // TODO Auto-generated method stub
                                }

                                @Override
                                public void onScroll(AbsListView arg0, int arg1, int arg2, int arg3) {
                                    // TODO Auto-generated method stub
                                    try {
                                        if (scrollListener != null) {
                                            mCurrentfirstVisibleItem = arg1;
                                            View firstView = arg0.getChildAt(0);
                                            if (null != firstView) {
                                                ItemRecod itemRecord = (ItemRecod) recordSp.get(arg1);
                                                if (null == itemRecord) {
                                                    itemRecord = new ItemRecod();
                                                }
                                                itemRecord.height = firstView.getHeight();
                                                itemRecord.top = firstView.getTop();
                                                recordSp.append(arg1, itemRecord);
                                                int scrollY = getScrollY();//滚动距离
                                                scrollListener.onScroll(scrollY); //分发事件
                                            }
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                }

                                private int getScrollY() {
                                    int height = 0;
                                    for (int i = 0; i < mCurrentfirstVisibleItem; i++) {
                                        ItemRecod itemRecod = (ItemRecod) recordSp.get(i);
                                        height += itemRecod.height;
                                    }
                                    ItemRecod itemRecod = (ItemRecod) recordSp.get(mCurrentfirstVisibleItem);
                                    if (null == itemRecod) {
                                        itemRecod = new ItemRecod();
                                    }
                                    return height - itemRecod.top;
                                }

                                class ItemRecod {
                                    int height = 0;
                                    int top = 0;
                                }
                            }
        );
    }

    public interface CustomScrollListener {
        public void onScroll(int scrollY);
    }

    public CustomScrollListener getScrollListener() {
        return scrollListener;
    }

    public void setScrollListener(CustomScrollListener scrollListener) {
        this.scrollListener = scrollListener;
    }
}
