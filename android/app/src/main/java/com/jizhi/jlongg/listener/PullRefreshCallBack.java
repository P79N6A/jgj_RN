package com.jizhi.jlongg.listener;

/**
 * 加载更多的回调
 */

public interface PullRefreshCallBack {
    public void callBackPullUpToRefresh(int pageNum); //上拉刷新

    public void callBackPullDownToRefresh(int pageNum); //下拉刷新
}
