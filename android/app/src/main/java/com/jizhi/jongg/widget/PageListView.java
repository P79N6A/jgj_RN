package com.jizhi.jongg.widget;

import android.content.Context;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.AttributeSet;
import android.view.View;
import android.widget.AbsListView;
import android.widget.Adapter;
import android.widget.BaseAdapter;
import android.widget.ListView;

import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.SetColor;

import java.util.List;


/**
 * Created by Administrator on 2017/12/1 0001.
 */

public class PageListView extends ListView {
    HandleDataListView.DataChangedListener dataChangedListener;

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
    private Adapter adapter;
    /**
     * 下拉加载刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 上拉加载时展示的布局
     */
    private View loadMoreView;


    public PageListView(Context context) {
        super(context);
    }

    public PageListView(Context context, AttributeSet attrs) {
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
                //SCROLL_STATE_IDLE#滑动停止
                if (scrollState == OnScrollListener.SCROLL_STATE_IDLE && isMoreData //是否还有更多数据
                        && adapter != null && lastItem == adapter.getCount() + getHeaderViewsCount()//是否已滑动到底了
                        && loadMoreView.getVisibility() == View.GONE) {
                    loadMoreView.setVisibility(View.VISIBLE);
                    pageNum += 1;
                    if (pullRefreshCallBack != null) {
                        pullRefreshCallBack.callBackPullUpToRefresh(pageNum);
                    }
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
    }


    /**
     * 设置上拉刷新
     *
     * @param loadMoreView
     */
    public void setPullUpToRefreshView(final View loadMoreView, final OnScrollListener onScrollListener) {
        this.loadMoreView = loadMoreView;
        loadMoreView.setVisibility(View.GONE);
        setOnScrollListener(new OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                //SCROLL_STATE_IDLE#滑动停止
                if (scrollState == OnScrollListener.SCROLL_STATE_IDLE && isMoreData //是否还有更多数据
                        && lastItem == adapter.getCount() + getHeaderViewsCount()//是否已滑动到底了
                        && loadMoreView.getVisibility() == View.GONE) {
                    loadMoreView.setVisibility(View.VISIBLE);
                    pageNum += 1;
                    if (pullRefreshCallBack != null) {
                        pullRefreshCallBack.callBackPullUpToRefresh(pageNum);
                    }
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                if (onScrollListener != null) {
                    onScrollListener.onScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
                }
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
    }


    public void setPullRefreshCallBack(PullRefreshCallBack pullRefreshCallBack) {
        this.pullRefreshCallBack = pullRefreshCallBack;
    }

    public void setListViewAdapter(BaseAdapter adapter) {
        this.adapter = adapter;
        setAdapter(adapter);
    }

    public void setAdapter(BaseAdapter adapter) {
        this.adapter = adapter;
        super.setAdapter(adapter);
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

    public boolean isMoreData() {
        return isMoreData;
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


    @Override
    protected void handleDataChanged() {
        super.handleDataChanged();
        if (dataChangedListener != null) {
            dataChangedListener.onSuccess();
        }
    }

    public void setDataChangedListener(HandleDataListView.DataChangedListener dataChangedListener) {
        this.dataChangedListener = dataChangedListener;
    }
}
