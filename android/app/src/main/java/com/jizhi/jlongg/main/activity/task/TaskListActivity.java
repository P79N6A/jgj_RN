package com.jizhi.jlongg.main.activity.task;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.TaskAdapter;
import com.jizhi.jlongg.main.bean.Task;
import com.jizhi.jlongg.main.bean.TaskDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 功能:任务-->列表详情
 * 时间:2017年11月16日15:43:05
 * 作者:Xuj
 */
public class TaskListActivity extends BaseActivity implements PullRefreshCallBack, View.OnClickListener {

    /**
     * 项目是否关闭
     */
    private boolean isClosed;
    /**
     * 分页listView
     */
    private PageListView pageListView;
    /**
     * 未处理适配器
     */
    private TaskAdapter adapter;
    /**
     * 项目id
     */
    private String groupId;
    /**
     * 下拉刷新控件
     */
    protected SwipeRefreshLayout mSwipeLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupName  项目组名称
     * @param groupId    项目组id
     * @param isClosed   项目是否已关闭
     * @param taskStatus 任务状态  1、待处理标识 2、已完成标识 3、我负责的标识 4、我参与的标识 5、我提交的标识
     */
    public static void actionStart(Activity context, String groupName, String groupId, boolean isClosed, int taskStatus) {
        Intent intent = new Intent(context, TaskListActivity.class);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        intent.putExtra(Constance.TASK_STATUS, taskStatus);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.task_detail_listview);
        registerFinishActivity();
        initView();
        autoRefresh();
    }

    private void initView() {
        Intent intent = getIntent();
        // 1、待处理标识 2、已完成标识 3、我负责的标识 4、我参与的标识 5、我提交的标识
        int taskStatus = intent.getIntExtra(Constance.TASK_STATUS, TaskHomePageActivity.PENDING_FLAG);
        switch (taskStatus) {
            case TaskHomePageActivity.PENDING_FLAG:
                setTextTitle(R.string.pending);
                findViewById(R.id.helpLayout).setVisibility(View.GONE);
                break;
            case TaskHomePageActivity.COMPLTED_FLAG:
                setTextTitle(R.string.task_complete);
                findViewById(R.id.helpLayout).setVisibility(View.GONE);
                break;
            case TaskHomePageActivity.I_RESPONSE_FLAG:
                setTextTitle(R.string.i_response);
                findViewById(R.id.helpLayout).setVisibility(View.GONE);
                break;
            case TaskHomePageActivity.I_COMMITED_FLAT:
                setTextTitle(R.string.i_commit);
                getTextView(R.id.defaultDesc).setText("暂无提交的任务");
                break;
            case TaskHomePageActivity.I_JOIN_FLAG:
                setTextTitle(R.string.i_join);
                findViewById(R.id.helpLayout).setVisibility(View.GONE);
                break;
        }
        getTextView(R.id.defaultDesc).setText(R.string.def_nodata);
        TextView createBtn = getTextView(R.id.createBtn);
        findViewById(R.id.viewHelp).setOnClickListener(this); //查看帮助按钮

        groupId = intent.getStringExtra(Constance.GROUP_ID);
        isClosed = intent.getBooleanExtra(Constance.IS_CLOSED, false);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调
        if (isClosed) {
            createBtn.setVisibility(View.GONE);
            findViewById(R.id.closedIcon).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.closedIcon).setVisibility(View.GONE);
            createBtn.setText("立即发布");
            createBtn.setOnClickListener(this);
        }
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                pageListView.setPageNum(1);
                mSwipeLayout.setRefreshing(true);
                getData();
            }
        });
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) { //上拉加载回调
        getData();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) { //下拉加载回调
        getData();
    }

    /**
     * 查询列表数据
     */
    public void getData() {
        String URL = NetWorkRequest.TASK_TASKPOST;
        final RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        Intent intent = getIntent();
        // 1、待处理标识 2、已完成标识 3、我负责的标识 4、我参与的标识 5、我提交的标识
        int taskStatus = intent.getIntExtra(Constance.TASK_STATUS, TaskHomePageActivity.PENDING_FLAG);
        switch (taskStatus) {
            case TaskHomePageActivity.PENDING_FLAG:
                params.addBodyParameter("task_status", "0"); //	任务状态 (0:待处理，1：已完成)
                break;
            case TaskHomePageActivity.COMPLTED_FLAG:
                params.addBodyParameter("task_status", "1"); //	任务状态 (0:待处理，1：已完成)
                break;
            case TaskHomePageActivity.I_RESPONSE_FLAG:
                params.addBodyParameter("task_type", "1");  // 任务类型（1:我负责的，2：我发布的，3：我参与的）
                break;
            case TaskHomePageActivity.I_COMMITED_FLAT:
                params.addBodyParameter("task_type", "2");  // 任务类型（1:我负责的，2：我发布的，3：我参与的）
                break;
            case TaskHomePageActivity.I_JOIN_FLAG:
                params.addBodyParameter("task_type", "3");  // 任务类型（1:我负责的，2：我发布的，3：我参与的）
                break;
        }
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        params.addBodyParameter("pg", pageListView.getPageNum() + "");  //页码
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //每页显示多少条数据
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Task> base = CommonJson.fromJson(responseInfo.result, Task.class);
                    if (base.getState() != 0) {
                        List<TaskDetail> list = base.getValues().getTask_list();
                        setAdapter(list);
                    } else {
                        DataUtil.showErrOrMsg(TaskListActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(TaskListActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                    pageListView.loadOnFailure();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                CommonMethod.makeNoticeShort(TaskListActivity.this, getString(R.string.conn_fail), CommonMethod.ERROR);
                pageListView.loadOnFailure();
            }
        });
    }


    private void setAdapter(List<TaskDetail> list) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new TaskAdapter(this, list, isClosed, groupId);
            pageListView.setEmptyView(findViewById(R.id.defaultLayout)); //设置无数据时展示的页面
            pageListView.setListViewAdapter(adapter); //设置适配器
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_FINISH || resultCode == Constance.PUBLICSH_SUCCESS) { //任务详情里面 修改了任务状态 、新建了任务
            autoRefresh(); //重新加载数据
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.viewHelp: //查看帮助
                HelpCenterUtil.actionStartHelpActivity(this, 183);
                break;
            case R.id.createBtn://立即发布项目
                PubliskTaskActivity.actionStart(this);
                break;
        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
