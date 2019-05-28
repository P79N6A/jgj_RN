package com.jizhi.jlongg.main.fragment.repository;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.RepositoryAdapter;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.squareup.otto.Subscribe;

import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;

/**
 * 功能:知识库Fragment
 * 时间:2017-3-24 17:56:13
 * 作者:Xuj
 */
public class RepositoryFragment extends Fragment {
    /**
     * listView
     */
    private ListView listView;
    /**
     * 默认页
     */
    private View defaultLayout;
    /**
     * 知识库列表适配器
     */
    private RepositoryAdapter adapter;
    /**
     * 当前知识库的id
     */
    private String fileId;
    /**
     * listView 监听 最后一条 主要是分页
     */
    private int lastItem;
    /**
     * 分页number
     */
    private int pageNum = 1;
    /**
     * 分页加载更多View
     */
    private View loadMoreView;
    /**
     * 是否在加载更多数据
     */
    private boolean isLoadingMore;
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.repository_listview, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        init();
        BusProvider.getInstance().register(this);
    }


    private void init() {
        Bundle bundle = getArguments();
        fileId = bundle.getString("params1");
        loadMoreView = ((BaseActivity) getActivity()).loadMoreDataView();// listView 底部加载对话框
        listView = (ListView) getView().findViewById(R.id.listView);
        defaultLayout = getView().findViewById(R.id.defaultLayout);
        listView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                //SCROLL_STATE_IDLE#滑动停止
                if (scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isMoreData && lastItem == adapter.getList().size() &&
                        !isLoadingMore) { //是否滚动到底部、并且是否有更多的数据
                    isLoadingMore = true;
                    loadMoreView.setVisibility(View.VISIBLE);
                    pageNum += 1;
                    loadRepositoryData();
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
        loadRepositoryData();
    }

    /**
     * 加载知识库数据
     */
    public void loadRepositoryData() {
        RepositoryUtil.loadRepositoryData(fileId, adapter == null || adapter.getList() == null ? null : adapter.getList().get(adapter.getList().size() - 1).getId(), getActivity(), new RepositoryUtil.LoadRepositoryListener() { //首次加载知识库数据
            @Override
            public void loadRepositorySuccess(List<Repository> list) {
                if (list != null && list.size() > 0) { //展示列表数据
                    defaultLayout.setVisibility(View.GONE);
                    if (adapter == null) {
                        adapter = new RepositoryAdapter((BaseActivity) getActivity(), list);
                        listView.setAdapter(adapter);
                    } else {
                        if (pageNum == 1) {//如果等于1 直接替换列表数据
                            adapter.updateList(list);
                        } else {//如果分页编码大于1 表示正在分页加载更多数据
                            adapter.addList(list);
                        }
                    }
                    isMoreData = list.size() < RepositoryUtil.DEFAULT_PAGE_SIZE ? false : true;//如果小于默认数据条数 则表示没有缓存数据了
                } else { //显示默认页数据
                    if (pageNum == 1) {
                        defaultLayout.setVisibility(View.VISIBLE);
                    }
                    isMoreData = false;
                }
                if (!isMoreData) { //没有更多的数据了
                    if (listView.getFooterViewsCount() > 0) {//移除加载更多布局
                        loadMoreView.setVisibility(View.GONE);
                        listView.removeFooterView(loadMoreView);
                    }
                } else {
                    if (listView.getFooterViewsCount() < 1) {
                        listView.addFooterView(loadMoreView);
                        loadMoreView.setVisibility(View.VISIBLE);
                    }
                }
                isLoadingMore = false;
            }

            @Override
            public void loadRepositoryError() {
                if (pageNum > 1) {
                    pageNum -= 1;
                }
                if (listView.getFooterViewsCount() > 0) { //移除加载更多布局
                    loadMoreView.setVisibility(View.GONE);
                }
                isLoadingMore = false;
            }
        }, pageNum);
    }


    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        if (!getUserVisibleHint()) { //由于ViewPager 会给每个Fragment 分发调用onContextItemSelected事件所以需要判断一下当前可见的Fragment 才是我们需要调用的
            return super.onContextItemSelected(item);
        }
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //收藏、取消收藏
                RepositoryUtil.collectionOrCancel(adapter.getList().get(adapter.getLongClickPostion()), (BaseActivity) getActivity(),
                        new RepositoryUtil.CollectionListener() {
                            @Override
                            public void collection() { //收藏成功的回调
                                adapter.notifyDataSetChanged();
                            }
                        });
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RepositoryUtil.READ_DOC_RETURN) { //读取文件回调   主要是设置收藏、取消收藏状态的变化
            adapter.getList().get(adapter.getClickPosition()).setIs_collection(data.getIntExtra("param1", 0));
            adapter.notifyDataSetChanged();
        } else if (resultCode == RepositoryUtil.SEARCH_OVER) { //模糊搜索文档结束时的回调 ，因为不确定 搜索下载了哪些文件夹 所以要先清空所有的Fragment 数据
            pageNum = 1;
            if (adapter != null) {
                adapter.setList(null);
                adapter.notifyDataSetChanged();
            }
            defaultLayout.setVisibility(View.VISIBLE);
            loadRepositoryData();
        }
    }


    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    @Override
    public void onStart() {
        super.onPause();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        BusProvider.getInstance().unregister(this);
    }


    //文件下载状态
    @Subscribe
    public void downLoadingStateCallBack(Repository downLoadingRepository) {
        if (downLoadingRepository != null && adapter != null && adapter.getList() != null && adapter.getList().size() > 0) {
            List<Repository> list = adapter.getList();
            int size = list.size();
            for (int i = 0; i < size; i++) {
                if (list.get(i).getId().equals(downLoadingRepository.getId())) {
                    list.set(i, downLoadingRepository);
                    adapter.notifyDataSetChanged();
                    return;
                }
            }
        }
    }
}
