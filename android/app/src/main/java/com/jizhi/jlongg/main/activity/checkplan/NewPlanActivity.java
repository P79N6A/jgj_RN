package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.SelecteActorActivity;
import com.jizhi.jlongg.main.adpter.MembersNoTagAdapter;
import com.jizhi.jlongg.main.adpter.check.CheckListAdapter;
import com.jizhi.jlongg.main.adpter.check.ShowCheckListAdapter;
import com.jizhi.jlongg.main.bean.CheckList;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * CName:新建计划
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class NewPlanActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 执行人GridView适配器
     */
    private MembersNoTagAdapter executeMemberAdapter;
    /**
     * 检查项适配器
     */
    private ShowCheckListAdapter checkListAdapter;
    /**
     * 计划名称输入框
     */
    private EditText planNameEdit;
    /**
     * 执行时间
     */
    private TextView executeTime;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId   项目组id
     * @param groupName 项目组名称
     * @param id        检查计划id
     * @param state     1、新建检查计划  2、修改检查计划
     */
    public static void actionStart(Activity context, String groupId, String groupName, int id, int state) {
        Intent intent = new Intent(context, NewPlanActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.SEARCH_CHECK_STATE, state);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_plan);
        initView();
    }


    /**
     * 计算默认页 高度
     *
     * @param listViewHeadView listView头部布局
     */
    private void calculateDefaultHeight(final View listViewHeadView) {
        //当布局加载完毕 计算默认页的高度
        listViewHeadView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                //设置ListView头部的高度
                if (checkListAdapter != null) {
                    checkListAdapter.setListViewHeadHeight(listViewHeadView.getHeight());
                    checkListAdapter.notifyDataSetChanged();
                }
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                if (Build.VERSION.SDK_INT < 16) {
                    listViewHeadView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listViewHeadView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }


    private void initView() {
        ListView listView = (ListView) findViewById(R.id.listView);
        TextView addText = getTextView(R.id.addText);
        addText.setText(R.string.selecte_check_list);
        findViewById(R.id.addBtnLayout).setOnClickListener(this);
        executeMemberAdapter = new MembersNoTagAdapter(this, null, new AddMemberListener() {
            @Override
            public void add(int state) { //添加执行人
                SelecteActorActivity.actionStart(NewPlanActivity.this, getExecutePersonUids(), getString(R.string.selecte_execute));
            }

            @Override
            public void remove(int state) { //删除执行人

            }
        });

        final View listHeadView = getLayoutInflater().inflate(R.layout.new_plan_head, null);

        planNameEdit = (EditText) listHeadView.findViewById(R.id.planNameEdit);
        executeTime = (TextView) listHeadView.findViewById(R.id.executeTime);
        listHeadView.findViewById(R.id.executeTimeLayout).setOnClickListener(this);

        GridView gridView = (GridView) listHeadView.findViewById(R.id.executeGridView);
        gridView.setAdapter(executeMemberAdapter);

        listView.addHeaderView(listHeadView, null, false);

        Intent intent = getIntent();
        //  1、新建检查计划  2、修改检查计划
        int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, NewOrUpdateCheckContentActivity.UPDATE_CHECK);
        if (state == NewOrUpdateCheckContentActivity.UPDATE_CHECK) { //修改检查计划
            setTextTitleAndRight(R.string.update_plan, R.string.save);
            CheckListHttpUtils.getCheckPlanDetail(this, intent.getIntExtra(Constance.ID, 0), new CheckListHttpUtils.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object checkPlan) {
                    CheckPlanListBean checkPlanListBean = (CheckPlanListBean) checkPlan;
                    planNameEdit.setText(checkPlanListBean.getPlan_name()); //设置计划名称
                    executeTime.setText(checkPlanListBean.getExecute_time()); //设置执行时间
                    setAdapter(checkPlanListBean.getPro_list()); //设置检查项列表
                    calculateDefaultHeight(listHeadView); //计算头部的高度
                    executeMemberAdapter.setList(checkPlanListBean.getMember_list());//设置执行成员
                    executeMemberAdapter.notifyDataSetChanged();
                }

                @Override
                public void onFailure(HttpException e, String s) {
                    finish();
                }
            });
        } else {  //新建检查计划
            setTextTitleAndRight(R.string.new_check_plan, R.string.publish);
            setAdapter(null);
            calculateDefaultHeight(listHeadView);
        }
    }


    private void setAdapter(ArrayList<CheckList> list) {
        if (checkListAdapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            checkListAdapter = new ShowCheckListAdapter(this, list, true, new CheckListAdapter.RemoveCheckContentListener() {
                @Override
                public void isRemoveAll() {
                }
            });
            listView.setAdapter(checkListAdapter);
        } else {
            checkListAdapter.updateList(list);
        }
    }

    /**
     * 获取执行人ids
     *
     * @return
     */
    private String getExecutePersonUids() {
        if (executeMemberAdapter != null && executeMemberAdapter.getList() != null && executeMemberAdapter.getList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            for (GroupMemberInfo groupMemberInfo : executeMemberAdapter.getList()) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
            }
            return builder.toString();
        }
        return null;
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.addBtnLayout: //选择检查项
                SelecteCheckListActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID), getCheckListIds(false), checkListAdapter.getList());
                break;
            case R.id.right_title: //发布
                String planNameValue = planNameEdit.getText().toString(); //新建计划
                if (TextUtils.isEmpty(planNameValue)) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请填写计划名称", CommonMethod.ERROR);
                    return;
                }
                String executeTimeValue = executeTime.getText().toString(); //执行时间
                if (TextUtils.isEmpty(executeTimeValue)) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请选择执行时间", CommonMethod.ERROR);
                    return;
                }
                String executeMembers = getSelecteExecuteIds();//执行人
                if (TextUtils.isEmpty(getSelecteExecuteIds())) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请选择执行人", CommonMethod.ERROR);
                    return;
                }
                //已选的检查项id  逗号隔开 x,x
                String selecteCheckListIds = getCheckListIds(true);
                if (!TextUtils.isEmpty(selecteCheckListIds)) {
                    Intent intent = getIntent();
                    //1、新建检查计划  2、修改检查计划
                    int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, NewOrUpdateCheckContentActivity.UPDATE_CHECK);
                    if (state == NewOrUpdateCheckContentActivity.UPDATE_CHECK) { //修改检查计划
                        int planId = intent.getIntExtra(Constance.ID, 0); //检查项id
                        CheckListHttpUtils.updateCheckPlan(this, planId, planNameValue, executeMembers, executeTimeValue, selecteCheckListIds, new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "修改成功", CommonMethod.SUCCESS);
                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {
                            }
                        });
                    } else { //新建检查计划
                        String groupId = intent.getStringExtra(Constance.GROUP_ID);
                        CheckListHttpUtils.addCheckPlan(this, groupId, WebSocketConstance.TEAM, executeMembers, selecteCheckListIds, planNameValue, executeTimeValue,
                                new CheckListHttpUtils.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object checkPlan) {
                                        CommonMethod.makeNoticeShort(getApplicationContext(), "发布成功", CommonMethod.SUCCESS);
                                        setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN);
                                        finish();
                                    }

                                    @Override
                                    public void onFailure(HttpException e, String s) {

                                    }
                                });
                    }
                }
                break;
            case R.id.executeTimeLayout: //执行时间
                showExecuteTime();
                break;
        }
    }


    /**
     * 获取已选的检查项id
     *
     * @return
     */
    private String getCheckListIds(boolean isShowEmptyDialog) {
        if (checkListAdapter != null && !checkListAdapter.isEmptyData()) {
            StringBuilder builder = new StringBuilder();
            List<CheckList> tempList = checkListAdapter.getList();
            for (CheckList checkList : tempList) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? checkList.getPro_id() : "," + checkList.getPro_id());
            }
            return builder.toString();
        } else {
            if (isShowEmptyDialog) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "请选择检查项", CommonMethod.ERROR);
            }
            return null;
        }
    }

    /**
     * 获取已选的执行人id
     *
     * @return
     */
    private String getSelecteExecuteIds() {
        if (executeMemberAdapter != null && executeMemberAdapter.getList() != null && executeMemberAdapter.getList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            List<GroupMemberInfo> memberList = executeMemberAdapter.getList();
            for (GroupMemberInfo groupMemberInfo : memberList) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
            }
            return builder.toString();
        } else {
            return null;
        }
    }

    /**
     * 选择执行时间
     */
    private void showExecuteTime() {
        final Calendar calendar = Calendar.getInstance();
        new NewPlanActivity.CustomDatePickerDialog(this, new DatePickerDialog.OnDateSetListener() { //弹出日历选择框
            @Override
            public void onDateSet(DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
                new NewPlanActivity.CustomTimePicker(NewPlanActivity.this, new TimePickerDialog.OnTimeSetListener() { //小时选择器
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        if (TimesUtils.isLessThanToday(TimesUtils.getThenTimeInMillons(year, monthOfYear, dayOfMonth, hourOfDay, minute))) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), "不可选择小于当前时间", CommonMethod.ERROR);
                            return;
                        }
                        String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                        String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                        final String yearMonthDay = year + "-" + month + "-" + day;
                        executeTime.setText(yearMonthDay + " " + (hourOfDay < 10 ? "0" + hourOfDay : hourOfDay) + ":" + (minute < 10 ? "0" + minute : minute));
                    }
                }, calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), true).show();
            }
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH)).show();
    }


    /**
     * Created by mindto on 2016/3/10.
     * 定义一个类，继承DialogFragment并实现DatePickerDialog.OnDateSetListener
     */
    public class CustomDatePickerDialog extends DatePickerDialog {

        public CustomDatePickerDialog(Context context, OnDateSetListener callBack, int year, int monthOfYear, int dayOfMonth) {
            super(context, callBack, year, monthOfYear, dayOfMonth);
        }

        /**
         * 大家只需写一个子类继承DatePickerDialog，然后在里面重写父类的onStop()方法
         */
        @Override
        protected void onStop() { //DatePickerDialog中onDateSet执行两次的问题
//            super.onStop();
        }

    }

    /**
     * Created by mindto on 2016/3/10.
     * 定义一个类，继承DialogFragment并实现TimePickerDialog.OnTimeSetListener实现监听
     */
    public class CustomTimePicker extends TimePickerDialog {
        public CustomTimePicker(Context context, OnTimeSetListener listener, int hourOfDay, int minute, boolean is24HourView) {
            super(context, listener, hourOfDay, minute, is24HourView);
        }

        /**
         * 大家只需写一个子类继承DatePickerDialog，然后在里面重写父类的onStop()方法
         */
        @Override
        protected void onStop() { //DatePickerDialog中onDateSet执行两次的问题
//            super.onStop();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SELECTED_ACTOR) { //选择执行者
            List<GroupMemberInfo> groupMemberInfos = (List<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            executeMemberAdapter.updateListView(groupMemberInfos);
        } else if (resultCode == Constance.SELECTED_CALLBACK) { //选择了检查项回调
            ArrayList<CheckList> list = (ArrayList<CheckList>) data.getSerializableExtra(Constance.BEAN_ARRAY);
            setAdapter(list);
        }
    }
}
