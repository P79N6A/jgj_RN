package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ListView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RepositoryAdapter;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.squareup.otto.Subscribe;

import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;


/**
 * 知识库详情
 *
 * @author Xuj
 * @time 2017年3月24日17:34:51
 * @Version 1.0
 */
public class RepositoryDetailActivity extends BaseActivity {
    /**
     * 适配器
     */
    private RepositoryAdapter adapter;

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
    /**
     * listView
     */
    private ListView listView;
    /**
     * 无数据时展示的默认页
     */
    private View defaultLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repository_detail);
        initView();
        BusProvider.getInstance().register(this);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param docTitle 显示的标题
     * @param id       文件夹id
     */
    public static void actionStart(Activity context, String docTitle, String id) {
        Intent intent = new Intent(context, RepositoryDetailActivity.class);
        intent.putExtra("param1", docTitle);
        intent.putExtra("param2", id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    private void initView() {
        Intent intent = getIntent();
        defaultLayout = findViewById(R.id.defaultLayout);
        loadMoreView = loadMoreDataView();// listView 底部加载对话框
        getTextView(R.id.title).setText(StrUtil.ToDBC(StrUtil.StringFilter(intent.getStringExtra("param1"))));
        final String fileParentId = intent.getStringExtra("param2");
        final ClearEditText searchEdit = (ClearEditText) findViewById(R.id.filterEdit);
        searchEdit.setFocusable(false);
        searchEdit.setFocusableInTouchMode(false);
        searchEdit.setHint("请输入文档名称进行搜索");
        searchEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                RepositorySearchingActivity.actionStart(RepositoryDetailActivity.this);
            }
        });
        listView = (ListView) findViewById(R.id.listView);
        listView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                //SCROLL_STATE_IDLE#滑动停止
                if (scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isMoreData && lastItem == adapter.getList().size() &&
                        !isLoadingMore) { //是否滚动到底部、并且是否有更多的数据
                    isLoadingMore = true;
                    loadMoreView.setVisibility(View.VISIBLE);
                    pageNum += 1;
                    loadRepositoryData(fileParentId);
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
        loadRepositoryData(fileParentId);
    }



    /**
     * 加载知识库数据
     */
    public void loadRepositoryData(String fileParentId) {
        RepositoryUtil.loadRepositoryData(fileParentId, adapter == null || adapter.getList() == null ? null : adapter.getList().get(adapter.getList().size() - 1).getId(), this, new RepositoryUtil.LoadRepositoryListener() { //首次加载知识库数据
            @Override
            public void loadRepositorySuccess(List<Repository> list) {
                if (list != null && list.size() > 0) { //展示列表数据
                    defaultLayout.setVisibility(View.GONE);
                    if (adapter == null) {
                        adapter = new RepositoryAdapter(RepositoryDetailActivity.this, list);
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
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //收藏、取消收藏
                RepositoryUtil.collectionOrCancel(adapter.getList().get(adapter.getLongClickPostion()), this,
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
        }
    }

    //文件下载状态 、获取文件的下载状态
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BusProvider.getInstance().unregister(this);
    }


}