package com.jizhi.jlongg.main.fragment.task;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.task.AllTaskNewActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.TaskAdapter;
import com.jizhi.jlongg.main.bean.Task;
import com.jizhi.jlongg.main.bean.TaskDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 功能:任务---->已完成
 * 时间:2017年6月7日10:11:06
 * 作者:Xuj
 */
public class CompleteFragment extends Fragment {

    /**
     * 项目是否关闭
     */
    private boolean isClosed;

    /**
     * 当ViewPager选中当前模块时是否需要刷新当前页面
     */
    private boolean isRefurshData = true;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 默认页
     */
    private View defaultLayout;
    /**
     * 未处理适配器
     */
    private TaskAdapter adapter;
    /**
     * 分页number
     */
    private int pageNum = 1;
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;
    /**
     * listView 监听 最后一条 主要是分页
     */
    private int lastItem;
    /**
     * 分页加载更多View
     */
    private View loadMoreView;
    /**
     * 是否在加载更多数据
     */
    private boolean isLoadingMore;
    /**
     * 项目id
     */
    private String groupId;
    /**
     * 下拉刷新控件
     */
    protected SwipeRefreshLayout mSwipeLayout;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.task_listview, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        groupId = getArguments().getString(Constance.GROUP_ID);
        isClosed = getArguments().getBoolean("isClosed");
        defaultLayout = getView().findViewById(R.id.defaultLayout);
        mSwipeLayout = (SwipeRefreshLayout) getView().findViewById(R.id.swipeLayout);
        listView = (ListView) getView().findViewById(R.id.listView);
        loadMoreView = ((BaseActivity) getActivity()).loadMoreDataView();// listView 底部加载对话框
        getView().findViewById(R.id.closedIcon).setVisibility(isClosed ? View.VISIBLE : View.GONE); //项目是否已关闭
        listView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                //SCROLL_STATE_IDLE#滑动停止
                if (scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isMoreData
                        && lastItem == adapter.getCount() && !isLoadingMore) { //是否滚动到底部、并且是否有更多的数据
                    isLoadingMore = true;
                    loadMoreView.setVisibility(View.VISIBLE);
                    pageNum += 1;
                    getData();
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() { //下拉刷新回调
            @Override
            public void onRefresh() {
                pageNum = 1;
                getData();
            }
        });
        new SetColor(mSwipeLayout);
    }

    /**
     * 首次进来自动刷新列表数据
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                if (adapter != null && adapter.getCount() != 0) {
                    adapter.setList(null);
                    adapter.notifyDataSetChanged();
                }
                isRefurshData = false;
                mSwipeLayout.setRefreshing(true);
                pageNum = 1;
                getData();
            }
        });
    }

    /**
     * 查询列表数据
     */
    public void getData() {
        final AllTaskNewActivity AllTaskNewActivity = (AllTaskNewActivity) getActivity();
        String URL = NetWorkRequest.TASK_TASKPOST;
        final RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        params.addBodyParameter("task_status", "1"); //	任务状态(0:待处理，1：已完成 , 2:全部)
        params.addBodyParameter("pg", pageNum + "");  //页码
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //每页显示多少条数据
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Task> base = CommonJson.fromJson(responseInfo.result, Task.class);
                    if (base.getState() != 0) {
                        AllTaskNewActivity.fillCompleteCount(base.getValues().getComplete_count()); //填充已完成数
                        if (base.getValues().getTask_list().size() > 0) {
                            List<TaskDetail> list = base.getValues().getTask_list();
                            if (adapter == null) {
                                adapter = new TaskAdapter(getActivity(), list, isClosed, groupId);
                                listView.setAdapter(adapter);
                            } else {
                                if (pageNum == 1) {//如果等于1 直接替换列表数据
                                    adapter.updateList(list);
                                } else {//如果分页编码大于1 表示正在分页加载更多数据
                                    adapter.addList(list);
                                }
                            }
                            if (pageNum == 1) {
                                defaultLayout.setVisibility(View.GONE);
                            }
                            isMoreData = list.size() < RepositoryUtil.DEFAULT_PAGE_SIZE ? false : true;//如果小于默认数据条数 则表示没有缓存数据了
                        } else {
                            if (pageNum == 1) {
                                if (adapter != null) {
                                    adapter.updateList(null);
                                }
                                defaultLayout.setVisibility(View.VISIBLE);
                            }
                            isMoreData = false;
                        }
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                }
                if (pageNum == 1) { //下拉刷新
                    mSwipeLayout.setRefreshing(false);
                }
                if (!isMoreData) { //没有更多的数据了
                    if (listView.getFooterViewsCount() > 0) {//移除加载更多布局
                        listView.removeFooterView(loadMoreView);
                    }
                } else {
                    if (listView.getFooterViewsCount() < 1) {
                        listView.addFooterView(loadMoreView);
                    }
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                StringBuffer sb = new StringBuffer();
                sb.append(getString(R.string.conn_fail));
                CommonMethod.makeNoticeShort(getActivity(), sb.toString(), CommonMethod.ERROR);
                if (pageNum == 1) { //下拉刷新
                    mSwipeLayout.setRefreshing(false);
                } else {
                    pageNum -= 1;
                    loadMoreView.setVisibility(View.GONE);
                }
            }
        });
    }

    public boolean isRefurshData() {
        return isRefurshData;
    }

    public void setRefurshData(boolean refurshData) {
        isRefurshData = refurshData;
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.PUBLICSH_SUCCESS) { //发布成功
            autoRefresh();
        }
    }


}
