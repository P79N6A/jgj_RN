package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.check.MsgCheckListActivity;
import com.jizhi.jlongg.main.bean.BaseCheckInfo;
import com.jizhi.jlongg.main.bean.CheckHomePageInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

/**
 * CName:检查计划首页
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:42:26
 */
public class CheckPlanHomePageActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 项目组信息
     */
    private GroupDiscussionInfo gnInfo;
    /**
     * 检查项数
     */
    private TextView checkListText;
    /**
     * 所有计划
     */
    private TextView allThePlanText;
    /**
     * 已完成
     */
    private TextView completeText;
    /**
     * 待我执行
     */
    private TextView waittingForMeToExecuteText;
    /**
     * 我创建的
     */
    private TextView iCreateText;
    /**
     * 待我执行小红点
     */
    private View waittingForMeToExecuteRedCircle;
    /**
     * 组是否已关闭
     */
    private boolean isClosed;


    /**
     * 启动当前Activity
     *
     * @param info    项目组信息
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, CheckPlanHomePageActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.check_home_page);
        registerFinishActivity();
        getIntentData();
        initView();
    }

    private void initView() {
        TextView navigationTitle = getTextView(R.id.title);
        navigationTitle.setText(R.string.check);
        checkListText = getTextView(R.id.checkListText);
        allThePlanText = getTextView(R.id.allThePlanText);
        completeText = getTextView(R.id.completeText);
        waittingForMeToExecuteText = getTextView(R.id.waittingForMeToExecuteText);
        iCreateText = getTextView(R.id.iCreateText);
        waittingForMeToExecuteRedCircle = findViewById(R.id.waittingForMeToExecuteRedCircle);
        navigationTitle.setOnClickListener(this);
        findViewById(R.id.publishLayout).setVisibility(isClosed ? View.GONE : View.VISIBLE);
        findViewById(R.id.img_close).setVisibility(isClosed ? View.VISIBLE : View.GONE);
        loadData();
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (gnInfo != null) {
            isClosed = gnInfo.getIs_closed() == 1;
        }
    }

    /**
     * 加载数据
     */
    private void loadData() {
        CheckListHttpUtils.getCheckListHomePageData(this, gnInfo.getGroup_id(), WebSocketConstance.TEAM, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                CheckHomePageInfo checkInfo = (CheckHomePageInfo) checkPlan;
                if (checkInfo != null) {
                    int inspectPro = checkInfo.getInspect_pro(); //首页检查数
                    int inspectAll = checkInfo.getInspect_all();//所有计划数
                    int inspectFinish = checkInfo.getInspect_finish(); //已完成的检查数
                    int inspectMyOper = checkInfo.getInspect_my_oper(); //待我执行的检查数
                    int inspectMyCreater = checkInfo.getInspect_my_creater(); //我创建的检查数
                    int inspectMyOperRed = checkInfo.getInspect_my_oper_red(); //1显示小红点
                    checkListText.setText(inspectPro > 0 ? String.format(getString(R.string.check_list_formate), "(" + Utils.setMessageCount(inspectPro) + ")") : getString(R.string.check_list));
                    allThePlanText.setText(inspectAll > 0 ? String.format(getString(R.string.all_the_plan_formate), "(" + Utils.setMessageCount(inspectAll) + ")") : getString(R.string.all_the_plan));
                    completeText.setText(inspectFinish > 0 ? String.format(getString(R.string.complete_check_list_count_formate), "(" + Utils.setMessageCount(inspectFinish) + ")") : getString(R.string.complete_check_list_count));
                    waittingForMeToExecuteText.setText(inspectMyOper > 0 ? String.format(getString(R.string.waitting_for_me_to_execute_text_formate), "(" + Utils.setMessageCount(inspectMyOper) + ")") : getString(R.string.waitting_for_me_to_execute_text));
                    iCreateText.setText(inspectMyCreater > 0 ? String.format(getString(R.string.i_create_formate), "(" + Utils.setMessageCount(inspectMyCreater) + ")") : getString(R.string.i_create));
                    waittingForMeToExecuteRedCircle.setVisibility(inspectMyOperRed == 1 ? View.VISIBLE : View.GONE);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.checkList://检查项
                CheckListActivity.actionStart(this, gnInfo.getGroup_id(), isClosed);
                break;
            case R.id.allThePlan: //所有计划
                //check_type:0所有计划-->null  check_type:1已完成-->status=3 check_type:待我执行2-->my_oper=1 check_type:我创建的3-->my_creater=1;
                MsgCheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo, 0);
                break;
            case R.id.complete: //已完成
                MsgCheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo, 1);
                break;
            case R.id.newPlanBtn: //新建计划
                CheckListHttpUtils.getInspecProList(this, gnInfo.getGroup_id(), WebSocketConstance.TEAM, 1, CheckListActivity.CHECK_LIST_STRING, new CheckListHttpUtils.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        BaseCheckInfo checkPlen = (BaseCheckInfo) object;
                        //无检查项时，点击“新建计划”弹出提示框
                        if (checkPlen != null && checkPlen.getList().size() > 0) {
                            NewPlanActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo.getGroup_id(), gnInfo.getGroup_name(), -1, NewOrUpdateCheckContentActivity.CREATE_CHECK);
                        } else {
                            DialogOnlyTitle emptyDialog = new DialogOnlyTitle(CheckPlanHomePageActivity.this, new DiaLogTitleListener() {
                                @Override
                                public void clickAccess(int position) {
                                    CheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo.getGroup_id(), isClosed);
                                }
                            }, -1, getString(R.string.empty_check_list_tips));
                            emptyDialog.setConfirmBtnName(getString(R.string.go_setting));
                            emptyDialog.setDissmissBtnName(getString(R.string.put_aside));
                            emptyDialog.show();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {

                    }
                });
                break;
            case R.id.waittingForMeToExecuteItem: //待我执行
                MsgCheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo, 2);
                break;
            case R.id.iCreateItem: //我创建的
                MsgCheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo, 3);
                break;
            case R.id.title: //检查帮助
                HelpCenterUtil.actionStartHelpActivity(this, 182);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
            return;
        }
        if (resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN) { //新建计划
            MsgCheckListActivity.actionStart(CheckPlanHomePageActivity.this, gnInfo, 3);
        }
        loadData(); //回来就刷新数据
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
