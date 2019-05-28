package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 功能: 设置代班组长
 * 作者：Xuj
 * 时间: 2018年7月16日16:11:36
 */
public class SetReplaceForemanActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 开始时间
     */
    private TextView startTimeText;
    /**
     * 结束时间
     */
    private TextView endTimeText;
    /**
     * 设置代班长
     */
    private TextView setReplaceForemanText;
    /**
     * 开始日期 的时间戳   当还要选择结束时间做时间判断   结束时间不能小于开始时间
     */
    private long startTimeStamp, endTimeStamp;
    /**
     * 代班组长的id
     */
    private String uid;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupId) {
        Intent intent = new Intent(context, SetReplaceForemanActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId   班组id
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param userName  用户姓名
     * @param uid       用户id
     */
    public static void actionStart(Activity context, String groupId, String startTime, String endTime, String userName, String uid) {
        Intent intent = new Intent(context, SetReplaceForemanActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.STARTTIME_STRING, startTime);
        intent.putExtra(Constance.ENDTIME_STRING, endTime);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.BEAN_BOOLEAN, true); //只要这个参数为true就表示为编辑
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.set_replace_foreman);
        initView();
        initData();
    }

    private void initView() {
        setTextTitle(R.string.set_replace_foreman);
        startTimeText = getTextView(R.id.start_time_text);
        endTimeText = getTextView(R.id.end_time_text);
        setReplaceForemanText = getTextView(R.id.set_replace_foreman_text);
        findViewById(R.id.title).setOnClickListener(this);
        changeCommitBtnState();
    }

    private void initData() {
        Intent intent = getIntent();
        boolean isEditor = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (isEditor) { //true表示是编辑状态
            uid = intent.getStringExtra(Constance.UID);
            String startTime = intent.getStringExtra(Constance.STARTTIME_STRING);
            if (!TextUtils.isEmpty(startTime)) { //开始时间不为空
                String[] startTimes = startTime.split("-");
                setStartTimeInfo(startTimes[0], startTimes[1], startTimes[2]);
            }
            String endTime = intent.getStringExtra(Constance.ENDTIME_STRING);
            if (!TextUtils.isEmpty(endTime)) { //结束时间不为空
                String[] endTimes = intent.getStringExtra(Constance.ENDTIME_STRING).split("-");
                setEndTimeInfo(endTimes[0], endTimes[1], endTimes[2]);
            }
            setReplaceForemanText.setText(intent.getStringExtra(Constance.USERNAME));
        }
    }


    private void changeCommitBtnState() {
        Button commitBtn = getButton(R.id.red_btn);
        boolean isEditor = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        commitBtn.setText(isEditor ? "取消代班长设置" : "保存设置");
        commitBtn.setTextColor(ContextCompat.getColor(getApplicationContext(), isEditor ? R.color.app_color : R.color.white));
        Utils.setBackGround(commitBtn, getResources().getDrawable(isEditor ? R.drawable.draw_radius_guide_btn_whitecolor_5dip : R.drawable.draw_eb4e4e_5radius));
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn: //保存设置
                if (TextUtils.isEmpty(uid)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请设置代班长", CommonMethod.ERROR);
                    return;
                }
                commitDate();
                break;
            case R.id.set_replace_foreman_layout://设置代班组长
                GroupDiscussionInfo groupDiscussionInfo = new GroupDiscussionInfo();
                groupDiscussionInfo.setClass_type(WebSocketConstance.GROUP);
                groupDiscussionInfo.setGroup_id(getIntent().getStringExtra(Constance.GROUP_ID));
                ReleaseProjecPeopleActivity.actionStart(this, groupDiscussionInfo, uid, Constance.SELECTE_PROXYER, "选择代班长");
                break;
            case R.id.start_time_layout: //开始时间
                showStartTime();
                break;
            case R.id.end_time_layout: //结束时间
                showEndTime();
                break;
            case R.id.title: //代班长帮助
                HelpCenterUtil.actionStartHelpActivity(this, 228);
                break;
        }
    }


    private void setCancelFlag() {
        Intent intent = getIntent();
        boolean isCancel = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (isCancel) {
            intent.putExtra(Constance.BEAN_BOOLEAN, false);
            changeCommitBtnState();
        }
    }


    private void setStartTimeInfo(String year, String month, String day) {
        long timeInMills = DateUtil.getTimeInMillis(year + "-" + (Integer.parseInt(month) - 1) + "-" + day);
        if (endTimeStamp != 0) { //已选择了结束时间 需要判断开始时间不能大于结束时间
            if (timeInMills >= endTimeStamp) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "代班结束时间不能小于代班开始时间", CommonMethod.ERROR);
                return;
            }
        }
        startTimeStamp = timeInMills;
        startTimeText.setText(year + "-"
                + (Integer.parseInt(month) < 10 ? "0" + Integer.parseInt(month) : Integer.parseInt(month)) + "-"
                + (Integer.parseInt(day) < 10 ? "0" + Integer.parseInt(day) : Integer.parseInt(day)));
    }

    private void setEndTimeInfo(String year, String month, String day) {
        long timeInMills = DateUtil.getTimeInMillis(year + "-" + (Integer.parseInt(month) - 1) + "-" + (Integer.parseInt(day) + 1));
        if (startTimeStamp != 0) { //已选择了开始时间 需要判断开始时间不能大于结束时间
            if (timeInMills <= startTimeStamp) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "代班结束时间不能小于代班开始时间", CommonMethod.ERROR);
                return;
            }
        }
        endTimeText.setText(year + "-"
                + (Integer.parseInt(month) < 10 ? "0" + Integer.parseInt(month) : Integer.parseInt(month)) + "-"
                + (Integer.parseInt(day) < 10 ? "0" + Integer.parseInt(day) : Integer.parseInt(day)));
        endTimeStamp = timeInMills;
    }


    /**
     * 显示开始时间
     */
    public void showStartTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(this, getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String month, String day, String week) {
                        setStartTimeInfo(year, month, day);
                        setCancelFlag();
                    }
                }, 2020, 12, 31);
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //清空开始时间
            @Override
            public void clear() {
                startTimeStamp = 0;
                startTimeText.setText("");
                setCancelFlag();
            }
        });
        datePickerPopWindow.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        datePickerPopWindow.hideCancelBtnShowClearBtn("清空");
        datePickerPopWindow.hideSelecteDaysView();
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 显示结束时间
     */
    public void showEndTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(this, getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String month, String day, String week) {
                        setEndTimeInfo(year, month, day);
                        setCancelFlag();
                    }
                }, 2020, 12, 31);
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //清空结束时间
            @Override
            public void clear() {
                endTimeText.setText("");
                endTimeStamp = 0;
                setCancelFlag();
            }
        });
        datePickerPopWindow.hideSelecteDaysView();
        datePickerPopWindow.hideCancelBtnShowClearBtn("清空");
        datePickerPopWindow.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 提交代班长数据
     */
    public void commitDate() {
        final boolean isEditor = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("class_type", WebSocketConstance.GROUP);
        params.addBodyParameter("start_time", startTimeText.getText().toString());
        params.addBodyParameter("end_time", endTimeText.getText().toString());
        if (isEditor) {
            params.addBodyParameter("is_cancel", "1");
        }
        String httpUrl = NetWorkRequest.SET_PROXY_GROUPER;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeLong(getApplicationContext(), isEditor ? "代班长取消成功" : "代班长设置成功", CommonMethod.SUCCESS);
                //我们在这里发送一条广播通知App首页,重新获取数据
                LocalBroadcastManager.getInstance(SetReplaceForemanActivity.this).sendBroadcast(new Intent(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST));
                setResult(Constance.REFRESH);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SELECTE_PROXYER) {
            String name = data.getStringExtra(ReleaseQualityAndSafeActivity.VALUE);
            String uid = data.getStringExtra(Constance.UID);
            this.uid = uid;
            setReplaceForemanText.setText(name);
            setCancelFlag();
        }
    }
}
