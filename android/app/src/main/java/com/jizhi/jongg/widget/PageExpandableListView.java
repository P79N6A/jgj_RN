package com.jizhi.jongg.widget;

import android.content.Context;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.AttributeSet;
import android.view.View;
import android.widget.AbsListView;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;

import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.SetColor;

import java.util.List;


/**
 * Created by Administrator on 2017/12/1 0001.
 */

public class PageExpandableListView extends ExpandableListView {
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;
    /**
     * listView 监听 最后一条 主要是分页时使用
     */
    private int lastItem;
    /**
     * 分页number
     */
    private int pageNum = 1;
    /**
     * 加载更多的回调
     */
    private PullRefreshCallBack pullRefreshCallBack;
    /**
     * adpter
     */
    private BaseExpandableListAdapter adapter;
    /**
     * 下拉加载刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 上拉加载时展示的布局
     */
    private View loadMoreView;


    public PageExpandableListView(Context context) {
        super(context);
    }

    public PageExpandableListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    /**
     * 设置下拉刷新
     *
     * @param swipeRefreshLayout
     */
    public void setPullDownToRefreshView(SwipeRefreshLayout swipeRefreshLayout) {
        this.mSwipeLayout = swipeRefreshLayout;
        new SetColor(mSwipeLayout); // 设置下拉刷新滚动颜色
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                setPageNum(1);
                if (pullRefreshCallBack != null) {
                    pullRefreshCallBack.callBackPullDownToRefresh(pageNum);
                }
            }
        });
    }

    /**
     * 设置上拉刷新
     *
     * @param loadMoreView
     */
    public void setPullUpToRefreshView(final View loadMoreView) {
        this.loadMoreView = loadMoreView;

        loadMoreView.setVisibility(View.GONE);
        setOnScrollListener(new OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                switch (scrollState) {
                    case OnScrollListener.SCROLL_STATE_IDLE: //滑动停止后的回调
                        if (loadMoreView != null && adapter != null && isMoreData //是否还有更多数据
                                && lastItem == view.getCount() - 1 //是否已滑动到底了
                                && loadMoreView.getVisibility() == View.GONE) {
                            loadMoreView.setVisibility(View.VISIBLE);
                            pageNum += 1;
                            if (pullRefreshCallBack != null) {
                                pullRefreshCallBack.callBackPullUpToRefresh(pageNum);
                            }
                        }
                        break;
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
    }

    public void setPullRefreshCallBack(PullRefreshCallBack pullRefreshCallBack) {
        this.pullRefreshCallBack = pullRefreshCallBack;
    }

    public void setListViewAdapter(BaseExpandableListAdapter adapter) {
        this.adapter = adapter;
    }

    public void setMoreData(boolean moreData) {
        isMoreData = moreData;
    }


    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }


    public void addFootView() {
        if (getFooterViewsCount() > 0) {
            loadMoreView.setVisibility(View.GONE);
            return;
        }
        if (loadMoreView != null) {
            loadMoreView.setVisibility(View.GONE);
            addFooterView(loadMoreView);
        }
    }

    public void removeFootView() {
        if (getFooterViewsCount() == 0) {
            loadMoreView.setVisibility(View.GONE);
            return;
        }
        if (loadMoreView != null) {
            loadMoreView.setVisibility(View.GONE);
            removeFooterView(loadMoreView);
        }
    }

    public void hideFootView() {
        if (loadMoreView != null) {
            loadMoreView.setVisibility(View.GONE);
        }
    }

    /**
     * 加载数据完毕后调用一下方法,取消 上拉或者下拉组件
     *
     * @param list
     */
    public void loadDataFinish(List list) {
        if (pageNum == 1 && mSwipeLayout != null) {
            mSwipeLayout.setRefreshing(false);//关闭下拉刷新
        }
        if (list != null && list.size() >= RepositoryUtil.DEFAULT_PAGE_SIZE) {
            addFootView();
            setMoreData(true);
        } else {
            removeFootView();
            setMoreData(false);
        }
    }

    /**
     * 加载失败后调用这个方法
     */
    public void loadOnFailure() {
        int pageNum = getPageNum();
        if (pageNum == 1) {
            if (mSwipeLayout != null) {
                mSwipeLayout.setRefreshing(false);
            }
        } else {
            setPageNum(pageNum - 1);
            hideFootView();
        }
    }
}
