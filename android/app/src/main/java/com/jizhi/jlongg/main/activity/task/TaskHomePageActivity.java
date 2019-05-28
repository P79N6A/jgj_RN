package com.jizhi.jlongg.main.activity.task;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.TaskBaseInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * CName:任务首页
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:42:26
 */
public class TaskHomePageActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 待处理
     */
    private TextView taskPendingText;
    /**
     * 我负责的
     */
    private TextView iResponseText;
    /**
     * 我参与的
     */
    private TextView iJoinText;
    /**
     * 我提交的
     */
    private TextView iCommitText;
    /**
     * 我负责的小红点
     */
    private View iResponseRedCircle;
    /**
     * 我参与的小红点
     */
    private View iJoinRedCircle;

    public static final int PENDING_FLAG = 1; //待处理标识
    public static final int COMPLTED_FLAG = 2; //已完成标识
    public static final int I_RESPONSE_FLAG = 3; //我负责的标识
    public static final int I_JOIN_FLAG = 4; //我参与的标识
    public static final int I_COMMITED_FLAT = 5; //我提交的标识

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupName 项目组名称
     * @param groupId   项目组id
     * @param isClosed  是否已关闭
     */
    public static void actionStart(Activity context, String groupName, String groupId, boolean isClosed) {
        Intent intent = new Intent(context, TaskHomePageActivity.class);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.task_home_page);
        registerFinishActivity();
        initView();
        getTaskHomePageData();
    }

    private void initView() {
        TextView navigationTitle = getTextView(R.id.title);
        navigationTitle.setText(R.string.all_task);
        taskPendingText = getTextView(R.id.taskPendingText);
        iResponseText = getTextView(R.id.iResponseText);
        iJoinText = getTextView(R.id.iJoinText);
        iCommitText = getTextView(R.id.iCommitText);
        iResponseRedCircle = findViewById(R.id.iResponseRedCircle);
        iJoinRedCircle = findViewById(R.id.iJoinRedCircle);
        boolean isClosed = getIntent().getBooleanExtra(Constance.IS_CLOSED, false);
        findViewById(R.id.publishLayout).setVisibility( isClosed? View.GONE : View.VISIBLE);
        findViewById(R.id.img_close).setVisibility(isClosed ? View.VISIBLE : View.GONE);
        navigationTitle.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String groupName = intent.getStringExtra(Constance.GROUP_NAME);
        boolean isClosed = intent.getBooleanExtra(Constance.IS_CLOSED, false);
        switch (view.getId()) {
            case R.id.taskPending://待处理
                TaskListActivity.actionStart(this, groupName, groupId, isClosed, PENDING_FLAG);
                break;
            case R.id.taskComplete: //已完成
                TaskListActivity.actionStart(this, groupName, groupId, isClosed, COMPLTED_FLAG);
                break;
            case R.id.iResponseLayout: //我负责的
                TaskListActivity.actionStart(this, groupName, groupId, isClosed, I_RESPONSE_FLAG);
                break;
            case R.id.iCommitLayout: //我提交的
                TaskListActivity.actionStart(this, groupName, groupId, isClosed, I_COMMITED_FLAT);
                break;
            case R.id.iJoinLayout: //我参与的
                TaskListActivity.actionStart(this, groupName, groupId, isClosed, I_JOIN_FLAG);
                break;
            case R.id.newTaskBtn: //发布任务
                PubliskTaskActivity.actionStart(this);
                break;
            case R.id.title: //任务帮助
                HelpCenterUtil.actionStartHelpActivity(this, 183);
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击了单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else {
            getTaskHomePageData();
        }
    }

    /**
     * 获取任务首页数据
     */
    public void getTaskHomePageData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASK_HOME_PAGE, params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<TaskBaseInfo> base = CommonJson.fromJson(responseInfo.result, TaskBaseInfo.class);
                            if (base.getState() != 0) {
                                TaskBaseInfo taskInfo = base.getValues();
                                int unDealCount = taskInfo.getUn_deal_count(); //待处理任务数
                                int myAdminCount = taskInfo.getMy_admin_count();//我负责的任务数
                                int isJoinMsgCount = taskInfo.getMy_join_count(); //我参与的任务数
                                int mySubmitCount = taskInfo.getMy_submit_count(); //我提交的任务数

                                boolean isShowIReposonseRedCircle = taskInfo.getIs_admin_msg() == 1 ? true : false; //1表示有有我负责的 小红点
                                boolean isShowIJoinRedCircle = taskInfo.getIs_join_msg() == 1 ? true : false; //1表示有我参与的 小红点

                                taskPendingText.setText(unDealCount > 0 ? String.format(getString(R.string.pending_formate), "(" + Utils.setMessageCount(unDealCount) + ")") : getString(R.string.pending));
                                iResponseText.setText(myAdminCount > 0 ? String.format(getString(R.string.i_response_formate), "(" + Utils.setMessageCount(myAdminCount) + ")") : getString(R.string.i_response));
                                iJoinText.setText(isJoinMsgCount > 0 ? String.format(getString(R.string.i_join_formate), "(" + Utils.setMessageCount(isJoinMsgCount) + ")") : getString(R.string.i_join));
                                iCommitText.setText(mySubmitCount > 0 ? String.format(getString(R.string.i_commit_formate), "(" + Utils.setMessageCount(mySubmitCount) + ")") : getString(R.string.i_commit));

                                iResponseRedCircle.setVisibility(isShowIReposonseRedCircle ? View.VISIBLE : View.GONE);
                                iJoinRedCircle.setVisibility(isShowIJoinRedCircle ? View.VISIBLE : View.GONE);
                            } else {
                                DataUtil.showErrOrMsg(TaskHomePageActivity.this, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                }
        );
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }

}
