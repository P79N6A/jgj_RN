package com.jizhi.jlongg.main.listview;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.animation.DecelerateInterpolator;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Scroller;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;

/**
 * Created by Ly on 2016/10/4.
 */
public class RefreshListView extends ListView implements AbsListView.OnScrollListener {


    private Context mContext;

    boolean mEnablePullRefresh = true;
    boolean mPullRefreshing = false;
    boolean mEnableLoadMore = true;
    boolean mPullLoading = false;

    private static final int SCROLL_BACK_HEADER = 0;
    private static final int SCROLL_BACK_FOOTER = 1;
    private int mScrollBack = SCROLL_BACK_HEADER;

    private static final int SCROLL_DURATION = 400;

    private RefreshFooter mFooter;

    private RefreshHeader mHeader;

    //ListView是否滚动
    boolean isScrollFilling = false;

    RefreshListViewListener refreshListViewListener;

    private int mHeaderHeight;

    private int mTotalItemCount;

    private boolean mEnableAutoLoad = true;

    private float mLastY = -1;

    private final static float OFFSET_RADIO = 1.8f;

    private static final int PULL_LOAD_MORE_DELTA = 50;

    private Scroller mScroller;

    private RelativeLayout mHeaderContent;

    public RefreshListView(Context context) {
        super(context);
        init(context);
    }

    public RefreshListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public RefreshListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        mContext = context;

        //初始化mScroller，设置插值器为减速插值器,隐藏header或者footer时，数值变化先快后慢
        mScroller = new Scroller(mContext, new DecelerateInterpolator());
        setOnScrollListener(this);

        //初始化header
        mHeader = new RefreshHeader(mContext);
        mHeaderContent = (RelativeLayout) mHeader.findViewById(R.id.header_content);
        this.addHeaderView(mHeader);

        //初始化footer
        mFooter = new RefreshFooter(mContext);
        this.addFooterView(mFooter);

        // 获取header头部的高度
        ViewTreeObserver observer = mHeader.getViewTreeObserver();
        if (null != observer) {
            observer.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @SuppressWarnings("deprecation")
                @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
                @Override
                public void onGlobalLayout() {
                    mHeaderHeight = mHeaderContent.getHeight();

                    ViewTreeObserver observer = getViewTreeObserver();
                    if (null != observer) {
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN) {
                            observer.removeGlobalOnLayoutListener(this);
                        } else {
                            observer.removeOnGlobalLayoutListener(this);
                        }
                    }
                }
            });
        }

    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        if (mLastY == -1) {
            mLastY = ev.getRawY();
        }

        switch (ev.getAction()) {
            case MotionEvent.ACTION_DOWN:
                mLastY = ev.getRawY();
                break;
            case MotionEvent.ACTION_MOVE:
                float dy = ev.getRawY() - mLastY;
                mLastY = ev.getRawY();
                if (getFirstVisiblePosition() == 0 && (mHeader.getHeaderHeight() > 0 ||
                            dy > 0)) {
                    //OFFSET_RADIO的设置，让下拉header时感觉到阻力，增强体验
                    updateHeaderHeight(dy / OFFSET_RADIO);
                }

                if (getLastVisiblePosition() == mTotalItemCount - 1 &&
                            (mFooter.getFooterMargin() > 0 || dy < 0)) {
                    //原理同上
                    updateFooterHeight(-dy / OFFSET_RADIO);
                }

                break;
            case MotionEvent.ACTION_UP:
                mLastY = ev.getRawY();
                if (getFirstVisiblePosition() == 0) {
                    if (!mPullRefreshing && mEnablePullRefresh && (mHeader.getHeaderHeight() > mHeaderHeight)) {
                        refresh();
                    }
                    //RefreshHeader位置自动滚动到相应位置
                    resetHeaderHeight();
                }

                if (getLastVisiblePosition() == mTotalItemCount - 1) {
                    if (!mPullLoading && mEnableLoadMore && (mFooter.getFooterMargin() > PULL_LOAD_MORE_DELTA)) {
                        loadMore();
                    }
                    //RefreshFooter位置自动滚动到相应位置
                    resetFooterHeight();
                }

                break;

        }
        return super.onTouchEvent(ev);
    }

    /**
     * 首次加载数据
     */
    public void autoRefresh() {
//        mHeader.setHeaderState(REFRESHING);
//        refreshListViewListener.onRefresh();
        mHeader.setHeaderHeight(DensityUtils.dp2px(mContext, 60));
        refresh();
    }

    public void setLoadMoreEnable(boolean enable) {
        mEnableLoadMore = enable;
        if (!mEnableLoadMore) {
            mFooter.hide();
        } else {
            mPullLoading = false;
            mFooter.show();
            mFooter.setFooterState(RefreshFooter.PULL_TO_LOAD_MORE);
        }
    }

    public void setRefreshEnable(boolean enable) {
        mEnablePullRefresh = enable;
        mHeaderContent.setVisibility(enable ? View.VISIBLE : View.INVISIBLE);
    }

    /**
     * 有数据返回，将footer重置为拉上加载状态
     */
    public void stopLoadMore() {
        if (mPullLoading) {
            mPullLoading = false;
            mFooter.setFooterState(RefreshFooter.PULL_TO_LOAD_MORE);
        }
    }

    /**
     * 无更多数据，修改mFooter的状态
     */
    public void stopLoadMoreForNoDatas() {
        if (mPullLoading) {
            mPullLoading = false;
            //没有更多数据不再允许上拉加载更多数据
            mEnableLoadMore = false;
            mFooter.setFooterState(RefreshFooter.HAS_NO_MORE);
        }
    }

    /**
     * 刷新完成停止刷新，并且重置header
     */
    public void stopRefresh() {
        if (mPullRefreshing) {
            mPullRefreshing = false;
            resetHeaderHeight();
        }

    }


    private void resetHeaderHeight() {
        int height = mHeader.getHeaderHeight();
        if (height == 0)
            return;

        if (mPullRefreshing && height < mHeaderHeight) {  //正在刷新并且将header向上拖动隐藏时
            return;
        }

        int finalHeight = 0;

        if (mPullRefreshing && mHeader.getHeaderHeight() >= mHeaderHeight) {
            finalHeight = mHeaderHeight;
        }
        mScrollBack = SCROLL_BACK_HEADER;
        mScroller.startScroll(0, height, 0, finalHeight - height, SCROLL_DURATION);

        //激活computeScroll方法
        invalidate();
    }

    private void resetFooterHeight() {
        int bottomMargin = mFooter.getFooterMargin();

        if (bottomMargin > 0) {
            mScrollBack = SCROLL_BACK_FOOTER;
            mScroller.startScroll(0, bottomMargin, 0, -bottomMargin, SCROLL_DURATION);
            invalidate();
        }

    }


    private void updateHeaderHeight(float delta) {
        //改变RefreshHeader高度
        mHeader.setHeaderHeight((int) delta + mHeader.getHeaderHeight());
        //改变RefreshHeader状态
        if (mEnablePullRefresh && !mPullRefreshing) {
            if (mHeader.getHeaderHeight() > mHeaderHeight) {
                mHeader.setHeaderState(RefreshHeader.RELEASE_TO_REFRESH);
            } else {
                mHeader.setHeaderState(RefreshHeader.PULL_TO_REFRESH);
            }
        }
        //保证改变RefreshListView高度的同时，不滑动RefreshListView
        setSelection(0);
    }

    private void updateFooterHeight(float delta) {
        int height = (int) delta + mFooter.getFooterMargin();

        if (mEnableLoadMore && !mPullLoading) {
            if (mFooter.getFooterMargin() > PULL_LOAD_MORE_DELTA) {
                mFooter.setFooterState(RefreshFooter.RELEASE_TO_LOAD_MORE);
            } else {
                mFooter.setFooterState(RefreshFooter.PULL_TO_LOAD_MORE);
            }
        }

        mFooter.setFooterMargin(height);
    }


    @Override
    public void computeScroll() {
        if (mScroller.computeScrollOffset()) {
            if (mScrollBack == SCROLL_BACK_HEADER) {
                mHeader.setHeaderHeight(mScroller.getCurrY());
            } else {
                mFooter.setFooterMargin(mScroller.getCurrY());
            }

        }
        super.computeScroll();
    }


    public void setOnRefreshListViewListener(RefreshListViewListener refreshListViewListener) {
        this.refreshListViewListener = refreshListViewListener;
    }


    public void setNoMoreData() {
        mFooter.setFooterState(RefreshFooter.HAS_NO_MORE);
    }

    public void resetFooter() {
        mFooter.setFooterState(RefreshFooter.PULL_TO_LOAD_MORE);
    }


    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (scrollState == OnScrollListener.SCROLL_STATE_FLING) {
            isScrollFilling = true;
        }
        if (scrollState == OnScrollListener.SCROLL_STATE_TOUCH_SCROLL) {
            isScrollFilling = false;
        }
        if (scrollState == OnScrollListener.SCROLL_STATE_IDLE) {
            if (isScrollFilling && !mPullLoading && mEnablePullRefresh && mEnableAutoLoad && getLastVisiblePosition() == getCount() - 1) {
                loadMore();
            }
        }

    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        mTotalItemCount = totalItemCount;
    }


    private void refresh() {
        mPullRefreshing = true;
        if (mEnablePullRefresh && refreshListViewListener != null) {
            mHeader.setHeaderState(RefreshHeader.REFRESHING);
            refreshListViewListener.onRefresh();
        }
    }

    private void loadMore() {
        mPullLoading = true;
        if (mEnableLoadMore && refreshListViewListener != null) {
            mFooter.setFooterState(RefreshFooter.LOADING_DATA);
            refreshListViewListener.onLoad();
        }

    }

    public interface DataChangedListener {
        void onSuccess();
    }


}
