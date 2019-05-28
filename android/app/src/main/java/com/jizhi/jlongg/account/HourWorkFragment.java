package com.jizhi.jlongg.account;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Telephony;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AccountUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddAccountPersonActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.activity.SalaryModeSettingActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.activity.SingleBatchAccountActivity;
import com.jizhi.jlongg.main.adpter.AccountFrgmentsAdapter;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AccountProjectId;
import com.jizhi.jlongg.main.bean.AccountSendSuccess;
import com.jizhi.jlongg.main.bean.AccountWorkRember;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogHintCreateTeam;
import com.jizhi.jlongg.main.dialog.DiaLogHourCheckDialog;
import com.jizhi.jlongg.main.dialog.DiaLogHourWork;
import com.jizhi.jlongg.main.dialog.DiaLogRecordSuccess;
import com.jizhi.jlongg.main.dialog.WheelAccountTimeSelected;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import org.litepal.LitePal;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:点工
 * 时间:2017/2/14 20.08
 * 作者:hcs
 */

public class HourWorkFragment extends AccountFragment implements AccountFrgmentsAdapter.AccountOnItemClickLitener, DiaLogRecordSuccess.AccountSuccessListenerClick {
    /* 薪资模板 */
    private Salary tpl;
    private String price;
    /* 上班/加班时长WheelView */
    public WheelAccountTimeSelected workTimePopWindow, overTimePopWindow;
    /* 上班/加班时长数据 */
    private List<WorkTime> workTimeList, overTimeList;

    //记账对象ID
    protected int uid;
    /* 语音路径*/
    protected String voicePath;
    /* 语音长度*/
    protected int voiceLength;
    /* 图片数据*/
    protected List<ImageItem> imageItems;
    //点工数据
    protected List<AccountBean> itemData;
    //选择对象列表数据
    protected PersonBean personBean;
    /* 记账成功对话框 */
    private DiaLogRecordSuccess diaLogRecordSuccess;
    /* 记账成功id */
    public String record;
    /* 没有更多dialog */
    private DiaLogHourWork dialog;
    /*备注 */
    private String remark;
    /*是否修改了上班加班时间*/
    protected boolean isChangeTime;
    /*按小时算加班，加班一小时工钱*/
    private String overtime_salary_tpl;
    private int hour_type;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.account_listviews, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
    }

    /**
     * 初始化控件
     */
    public void initView() {
        listView = getView().findViewById(R.id.listView);
        itemData = getHourData(((NewAccountActivity) getActivity()).roleType, getActivity().getIntent().getStringExtra(Constance.DATE));
        adapter = new AccountFrgmentsAdapter(getActivity(), itemData);
        listView.setAdapter(adapter);
        adapter.setAccountOnItemClickLitener(this);
        getView().findViewById(R.id.save).setOnClickListener(savaClickListener);
        setMsgText();


    }

    /**
     * 是否是聊天跳转过来的记账
     */
    public void setMsgText() {
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            // 非聊天跳转过来的记账，如果是工人读取本地记账信息
            boolean isWorker = ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false;
            String accountType = (String) SPUtils.get(getActivity(), "account_type", AccountUtil.HOUR_WORKER, isWorker ? Constance.ACCOUNT_WORKER_HISTORT : Constance.ACCOUNT_FORMAN_HISTORT);
            if (accountType.equals(AccountUtil.HOUR_WORKER) && isWorker) {
                //点工
                PersonBean bean = AccountUtils.getWorerInfo(getActivity(), isWorker);
                if (null != bean && bean.getUid() != 0) {
                    getWorkTPlByUid(bean, false);
                }
            }
            return;
        }
        LUtils.e("------11111------A-----");
        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            //创建者默认为工头 记账对象可选，所在项目不可选
            pid = ((NewAccountActivity) getActivity()).msgPid;
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(((NewAccountActivity) getActivity()).proName);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setText_color(R.color.color_999999);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setClick(false);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setShowArrow(false);
        } else {
            LUtils.e("------11111------B-----");

            //创建者默认为工人 记账对象不可选，所在项目可选
            personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setRight_value(personBean.getName());
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setText_color(R.color.color_999999);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setClick(false);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setShowArrow(false);
            uid = personBean.getUid();
            setSalaryMode(personBean.getTpl());
            LastRecordInfo();
        }
        adapter.notifyDataSetChanged();
    }

    @Override
    public void goToRecordWorkConfirm(int positon) {
        RecordWorkConfirmActivity.actionStart(getActivity(), year + "-" + month + "-" + day, uid + "", AccountUtil.HOUR_WORKER);
    }

    /**
     * 跳转到其他页面，取消动画
     */
    public void FlashingCancel() {
        if (adapter != null) {
            adapter.FlashingCancel(false);
        }
    }

    /**
     * 设置模版
     *
     * @param tplMode
     */
    public void setMode(Salary tplMode) {
        if (tplMode != null) {
            isChangeTime = true;
        }
        LUtils.e("-------tplMode-----------" + new Gson().toJson(tplMode));
        workTimePopWindow = null;
        overTimePopWindow = null;
        tpl = tplMode;
        //4.0.2
        adapter.FlashingCancel(false);
        overtime_salary_tpl = tpl.getOvertime_salary_tpl();
        hour_type = tpl.getHour_type();
        if (overtime_salary_tpl != null && hour_type == 1) {//说明是按小时算加班
            //重新选择记账对象之后，加班时长设置为0,上班时长根据模版定
            tplMode.setChoose_o_h_tpl(0);
            tplMode.setChoose_w_h_tpl(tplMode.getW_h_tpl());
            //按小时加班工资金额不可能为0
            salaryOfHour(tplMode, 0);
            //itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(Utils.m2(tplMode.getS_tpl()) + "元/个工\n" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (Utils.m2(Double.parseDouble(overtime_salary_tpl)) + "")+ "元/小时(加班)");
            // 根据上班时常和加班时常 计算薪资
            if (TextUtils.isEmpty(itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).getRight_value())) {
                tpl.setChoose_w_h_tpl(tpl.getW_h_tpl());
                itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(1个工)");
            } else {
                if (tplMode.getChoose_w_h_tpl() == tplMode.getW_h_tpl()) {
                    itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                } else {
                    if (tplMode.getChoose_w_h_tpl() == 0) {
                        itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value("休息");
                    } else {
                        itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时");
                    }

                }
            }
            if (TextUtils.isEmpty(itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).getRight_value())) {
                tpl.setChoose_o_h_tpl(0.0);
                itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");

            } else {
                if (tplMode.getChoose_o_h_tpl() == tplMode.getO_h_tpl()) {
                    itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                } else {

                    if (tplMode.getChoose_o_h_tpl() == 0) {
                        itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");
                    } else {
                        itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时");
                    }

                }

            }
        } else {
            //重新选择记账对象之后，加班时长设置为0,上班时长根据模版定
            tplMode.setChoose_o_h_tpl(0);
            tplMode.setChoose_w_h_tpl(tplMode.getW_h_tpl());
            //设置模版信息
            salaryOfDay(tplMode);
//            if (tplMode.getS_tpl() == 0) {
//                itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时(加班)");
//            } else {
//                itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(Utils.m2(tplMode.getS_tpl()) + "元/个工\n" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时(加班)");
//            }
            // 根据上班时常和加班时常 计算薪资
            if (TextUtils.isEmpty(itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).getRight_value())) {
                tpl.setChoose_w_h_tpl(tpl.getW_h_tpl());
                itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(1个工)");
            } else {
                if (tplMode.getChoose_w_h_tpl() == tplMode.getW_h_tpl()) {
                    itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                } else {
                    if (tplMode.getChoose_w_h_tpl() == 0) {
                        itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value("休息");
                    } else {
                        itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时");
                    }

                }
            }
            if (TextUtils.isEmpty(itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).getRight_value())) {
                tpl.setChoose_o_h_tpl(0.0);
                itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");

            } else {
                if (tplMode.getChoose_o_h_tpl() == tplMode.getO_h_tpl()) {
                    itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                } else {
                    if (tplMode.getChoose_o_h_tpl() == 0) {
                        itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");
                    } else {
                        itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时");
                    }

                }

            }
        }

        calculateMoney(tplMode);
        adapter.notifyDataSetChanged();
    }

    /**
     * 4.0.2工资标准，按工天显示样式
     *
     * @param tplMode
     */
    private void salaryOfDay(Salary tplMode) {
        String salary = "";
        if (tplMode.getW_h_tpl() != 0) {
            salary = "上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
        }
        if (tplMode.getO_h_tpl() != 0) {
            salary = salary + "\n加班" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时算一个工";
        }
        if (tplMode.getS_tpl() != 0) {
            salary = salary + "\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
        }
        if (tplMode.getS_tpl() != 0 && tplMode.getO_h_tpl() != 0) {
            salary = salary + "\n" + Utils.m2(tplMode.getS_tpl() / tplMode.getO_h_tpl()) + "元/小时(加班)";
        }
        LUtils.e("=======day" + salary);
        itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(salary);
    }

    /**
     * 4.0.2工资标准，按小时显示样式
     *
     * @param tplMode
     * @param fromNet 之前设置过，从网上拉取 1 ，0 本地设置的，也就是记工未保存
     */
    private void salaryOfHour(Salary tplMode, int fromNet) {
        String salary = "";
        if (tplMode.getW_h_tpl() != 0) {
            salary = "上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
        }
        if (tplMode.getS_tpl() != 0) {
            salary = salary + "\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
        }
        if (fromNet == 0) {
            if (overtime_salary_tpl != null && !TextUtils.isEmpty(overtime_salary_tpl)) {
                salary = salary + "\n" + (Utils.m2(Double.parseDouble(overtime_salary_tpl)) + "") + "元/小时(加班)";
                tpl.setO_s_tpl(Double.parseDouble(overtime_salary_tpl));
            }
        } else if (fromNet == 1) {
            if (tplMode.getO_s_tpl() != 0) {
                salary = salary + "\n" + (Utils.m2(tplMode.getO_s_tpl()) + "元/小时(加班)");
            }
        }
        LUtils.e("=======hour" + salary);
        itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(salary);
    }

    /**
     * 设置工人名称
     *
     * @param personName
     */
    public void setPersonName(String personName) {
        adapter.FlashingCancel(false);
        itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setRight_value(personName);
        adapter.notifyDataSetChanged();
    }

    /**
     * 设置备注信息
     *
     * @param remark
     */
    public void setRemarkDesc(String remark, List<ImageItem> imageItems) {
        this.remark = remark;
        this.imageItems = imageItems;
        itemData.get(getPosion(itemData, AccountBean.RECORD_REMARK)).setRight_value(AccountUtil.getAccountRemark(remark, imageItems, getActivity()));
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onItemClick(int position) {
        if (position != 0 && TextUtils.isEmpty(itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).getRight_value())) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            adapter.startFlashTips(true, getPosion(itemData, AccountBean.SELECTED_ROLE));
            return;
        }
        String type = itemData.get(position).getItem_type();
        if (type.equals(AccountBean.SELECTED_ROLE)) {
            AddAccountPersonActivity.actionStart(getActivity(), uid + "", getActivity().getIntent().getStringExtra(Constance.GROUP_ID), AccountUtil.HOUR_WORKER_INT, 0);
        } else if (type.equals(AccountBean.WORK_TIME)) {
            //上班时间
            if (tpl == null || tpl.getW_h_tpl() == 0) {
                //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
                adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
                return;
            }
            showWorkTimePop();
        } else if (type.equals(AccountBean.OVER_TIME)) {
            //加班时间
            if (tpl == null || tpl.getW_h_tpl() == 0) {
                //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
                adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
                return;
            }
            showOverTimePop();
        } else if (type.equals(AccountBean.ALL_MONEY)) {
            CommonMethod.makeNoticeShort(getActivity(), "点工工钱是根据工资标准和上班加班时长计算的", false);
        } else if (type.equals(AccountBean.SALARY)) {
            //薪资模版
            LUtils.e("-----薪资模版---------" + uid);
            SalaryModeSettingActivity.actionStart(getActivity(), tpl, String.valueOf(uid), itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).getRight_value(), ((NewAccountActivity) getActivity()).roleType, getString(R.string.set_salary_mode_title), AccountUtil.HOUR_WORKER_INT, isChangeTime);
        } else if (type.equals(AccountBean.SELECTED_PROJECT)) {
//            //如果是聊天跳转过来的并且是群主创建者，项目不可选
//            recordProject();
            SelecteProjectActivity.actionStart(getActivity(), pid == 0 ? null : pid + "");
        } else if (type.equals(AccountBean.RECORD_REMARK)) {
            //上班时间
            if (tpl == null || tpl.getW_h_tpl() == 0) {
                //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
                adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
                return;
            }
            RemarksActivity.actionStart(getActivity(), remark, imageItems);
        } else if (type.equals(AccountBean.SELECTED_DATE)) {
            setTime();
        }
    }

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(getActivity(), getString(R.string.choosetime), AccountUtil.HOUR_WORKER_INT, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                    if (personBean == null) {
                        CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                        return;
                    }
                    personBean.setTpl(tpl);
                    SingleBatchAccountActivity.actionStart(getActivity(), personBean, pid + "", getItemValue(AccountBean.SELECTED_PROJECT),
                            getActivity().getIntent().getStringExtra(Constance.GROUP_ID), ((NewAccountActivity) getActivity()).getAgency_group_user(),
                            AccountUtil.HOUR_WORKER_INT);
                    SingleBatchAccountActivity.setFrom();
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    int intYear = Integer.parseInt(year);
                    int intMonth = Integer.parseInt(month);
                    int intDay = Integer.parseInt(day);
                    AgencyGroupUser agencyGroupUser = ((NewAccountActivity) getActivity()).getAgency_group_user();
                    if (AccountUtil.TimeJudgment(getActivity(), agencyGroupUser, intYear, intMonth, intDay)) {
                        return;
                    }

                    HourWorkFragment.super.year =
                            HourWorkFragment.super.year = intYear;
                    HourWorkFragment.super.month = intMonth;
                    HourWorkFragment.super.day = intDay;
                    String selectDate = intYear + "-" + (HourWorkFragment.super.month < 10 ? "0" + month : month + "") + "-" + (HourWorkFragment.super.day < 10 ? "0" + day : day + "");
                    if (getTodayDate().trim().equals(selectDate.trim())) {
                        selectDate = selectDate + " (今天)";
                    }
                    itemData.get(getPosion(itemData, AccountBean.SELECTED_DATE)).setRight_value(selectDate);
                    adapter.notifyDataSetChanged();
                }
            }, year, month, day);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }

    /**
     * listViewItem-EditView context
     */
    @Override
    public void EditTextWatchListener(String itemType, String str) {
        //点工里面无可监听内容
    }

    /**
     * 今天工作时长
     */
    public void showWorkTimePop() {
        if (tpl == null || tpl.getW_h_tpl() == 0) {
            //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
            adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
            return;
        } else {
            final Salary salar = tpl;
            if (workTimePopWindow == null) {
                workTimeList = DataUtil.getWorkTime(0, tpl.getW_h_tpl());
                int currentIndex = 0;
                for (int i = 0; i < workTimeList.size(); i++) {
                    if (null != tpl && workTimeList.get(i).getWorkTimes() == tpl.getW_h_tpl()) {
                        currentIndex = i;
                    }
                }
                workTimePopWindow = new WheelAccountTimeSelected(getActivity(), getString(R.string.choosetime), workTimeList, currentIndex, true, hour_type);
                workTimePopWindow.setListener(new CallBackSingleWheelListener() {
                    @Override
                    public void onSelected(String scrollContent, int postion) {
                        isChangeTime = true;
                        WorkTime time = workTimeList.get(postion);
                        if (time.getWorkTimes() == 0) { //休息
                            itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value(time.getWorkName());
                        } else {
                            itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value(time.getWorkName().replace(".0", "") + time.getUnit());

                        }
                        salar.setChoose_w_h_tpl(time.getWorkTimes());
                        calculateMoney(salar);
                        adapter.notifyDataSetChanged();

                    }
                });
                workTimePopWindow.setSelecteWheelView(currentIndex);
            } else {
                workTimePopWindow.update();
            }
            //显示窗口
            workTimePopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
            BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);

        }

    }


    /**
     * 今天加班时长
     */
    public void showOverTimePop() {
        if (tpl == null || tpl.getW_h_tpl() == 0) {
            //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
            adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
            return;
        } else {
            final Salary salar = tpl;
            if (overTimePopWindow == null) {
                overTimeList = DataUtil.getOverTime(0, tpl.getO_h_tpl());
                int currentIndex = 0;
//                for (int i = 0; i < overTimeList.size(); i++) {
//                    if (null != tpl && overTimeList.get(i).getWorkTimes() == tpl.getW_h_tpl()) {
//                        currentIndex = i;
//                        return;
//                    }
//                }
//                currentIndex=0;
                overTimePopWindow = new WheelAccountTimeSelected(getActivity(), getString(R.string.choosetime), overTimeList, currentIndex, false, hour_type);
                overTimePopWindow.setListener(new CallBackSingleWheelListener() {
                    @Override
                    public void onSelected(String scrollContent, int postion) {
                        isChangeTime = true;
                        WorkTime time = overTimeList.get(postion);
                        if (time.getWorkTimes() == 0) { //休息
                            itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value(time.getWorkName());
                        } else {
                            itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value(time.getWorkName().replace(".0", "") + time.getUnit());

                        }
                        salar.setChoose_o_h_tpl(time.getWorkTimes());
                        calculateMoney(salar);
                        adapter.notifyDataSetChanged();

                    }
                });
                overTimePopWindow.setSelecteWheelView(currentIndex);
            } else {
                overTimePopWindow.update();
            }
            //显示窗口
            overTimePopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
            BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
        }
    }

    /**
     * @param bean
     * @param isLocal 是否是根据本读数据查询
     *                本地数据查询还需要设置记账对象名称
     */
    public void getWorkTPlByUid(final PersonBean bean, final boolean isLocal) {
        setPersonName(bean.getName());
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("accounts_type", AccountUtil.HOUR_WORKER);
        params.addBodyParameter("uid", String.valueOf(bean.getUid()));
        String httpUrl = NetWorkRequest.GET_WORK_TPL_BY_UID;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, AccountWorkRember.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final AccountWorkRember accountWorkRember = (AccountWorkRember) object;
                bean.setTelph(accountWorkRember.getTelph());
                if (accountWorkRember.getIs_diff() == 1 && !isLocal) {
                    //模版不一致显示弹窗

                    DiaLogHourCheckDialog diaLogHourCheckDialog = new DiaLogHourCheckDialog(getActivity(), bean.getName(), accountWorkRember.getMy_tpl(), accountWorkRember.getOth_tpl(), false, new DiaLogHourCheckDialog.AccountSuccessListenerClick() {
                        @Override
                        public void successAccountClick() {
                            //确认用对方设置的模版记账
                            if (accountWorkRember.getOth_tpl().getHour_type() == 0 &&
                                    accountWorkRember.getMy_tpl().getHour_type() == 0) {
                                Salary salary = accountWorkRember.getOth_tpl();
                                salary.setS_tpl(accountWorkRember.getMy_tpl().getS_tpl());
                                setPersonInfo(bean, accountWorkRember.getOth_tpl());
                            } else {
                                setPersonInfo(bean, accountWorkRember.getOth_tpl());
                            }
                        }

                        @Override
                        public void cancelAccountClick() {
                            //取消用我设置的模版记账
                            setPersonInfo(bean, accountWorkRember.getMy_tpl());
                        }
                    });
                    diaLogHourCheckDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                        @Override
                        public void onDismiss(DialogInterface dialog) {

                        }
                    });
                    diaLogHourCheckDialog.show();
                } else {
                    //设置模版信息
                    setPersonInfo(bean, accountWorkRember.getMy_tpl());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                //接口调用失败，直接显示上级带的
                setPersonInfo(bean, bean.getTpl());
            }
        });
    }

    /**
     * 设置新的记账对象
     *
     * @param personBean
     * @param salary
     */
    public void setPersonInfo(PersonBean personBean, Salary salary) {
        //设置记账对象信息
        this.personBean = personBean;
        //刷新记账对象名字
        setPersonName(personBean.getName());
        uid = personBean.getUid();
        //设置工人薪资模版
        //4.0.2如果线上没有数据，说明没有设置过记工薪资模板，如果有，进入模板设置，显示修改文案
        if (null == salary) {
            salary = new Salary();
            hour_type = salary.getHour_type();
            isChangeTime = false;
        } else {
            isChangeTime = true;
            hour_type = salary.getHour_type();
        }
        setSalaryMode(salary);
        //选择人之后上班加班时间置空
        workTimePopWindow = null;
        overTimePopWindow = null;
        //查询最后一次记账项目名字，聊天跳转的不查询
        if (personBean.getUid() != -1 && !getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
            LastRecordInfo();
        }

    }

    /**
     * 选择模版后回调
     *
     * @param tplMode
     */

    public void setSalaryMode(Salary tplMode) {
        LUtils.e("------11111------C-----");

        LUtils.e("--------setSalaryMode--------44----" + new Gson().toJson(tplMode));
        tpl = tplMode;
        if (tplMode != null) {
            hour_type = tplMode.getHour_type();
            double o_s_tpl = tplMode.getO_s_tpl();
            if (o_s_tpl != 0 && hour_type == 1) {//4.0.2模板，按小时算工资
                //重新选择记账对象之后，加班时长设置为0,上班时长根据模版定
                tplMode.setChoose_o_h_tpl(0);
                tplMode.setChoose_w_h_tpl(tplMode.getW_h_tpl());
                //根据模版设置 上班时长/加班时长/价钱
                itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");
                // 根据上班时常和加班时常 计算薪资
                salaryOfHour(tplMode, 1);
                //itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(Utils.m2(tplMode.getS_tpl()) + "元/个工\n" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (o_s_tpl + "").replace(".0", "") + "元/小时(加班)");
                calculateMoney(tplMode);

            } else {
                //重新选择记账对象之后，加班时长设置为0,上班时长根据模版定
                tplMode.setChoose_o_h_tpl(0);
                tplMode.setChoose_w_h_tpl(tplMode.getW_h_tpl());
                //没有模版
                if (tplMode.getW_h_tpl() == 0) {
                    //根据模版设置 上班时长/加班时长/价钱 设置为空
                    itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value("");
                    itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value("");
                    itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("");
                    if (tplMode.getW_h_tpl() == 0 && tplMode.getO_h_tpl() == 0) {
                        itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("");
                    } else {
                        itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("-");
                    }
                } else {
                    //根据模版设置 上班时长/加班时长/价钱
                    itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(1个工)");
                    itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("无加班");
                    // 根据上班时常和加班时常 计算薪资
//                    if (tplMode.getS_tpl() == 0) {
//                        itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时(加班)");
//                        price = "";
//                    } else {
//                        itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value(Utils.m2(tplMode.getS_tpl()) + "元/个工\n" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时(加班)");
//                    }
                    salaryOfDay(tplMode);
                    calculateMoney(tplMode);
                }
            }
        } else {
            //根据模版设置 上班时长/加班时长/价钱 设置为空
            itemData.get(getPosion(itemData, AccountBean.SALARY)).setRight_value("");
            itemData.get(getPosion(itemData, AccountBean.WORK_TIME)).setRight_value("");
            itemData.get(getPosion(itemData, AccountBean.OVER_TIME)).setRight_value("");
            itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("");
            price = "";
        }
        adapter.notifyDataSetChanged();
    }

    protected int getPosion(List<AccountBean> itemData, String item_type) {
        for (int i = 0; i < itemData.size(); i++) {
            if (TextUtils.equals(item_type, itemData.get(i).getItem_type())) {
                return i;
            }
        }
        return 0;

    }

    /**
     * 选择与我有关的项目
     */
    public void recordProject() {
        if (projectList != null) {
            createProjectWheelView();
            return;
        }
        projectList = null;
        AccountHttpUtils.IRelatedProjects((BaseActivity) getActivity(), new AccountHttpUtils.AccountIRelatedListener() {
            @Override
            public void IRelatedProjectsSuccess(List<Project> list) {
                if (null != projectList) {
                    projectList.clear();
                }
                projectList = list;
                createProjectWheelView();
            }
        }, true);
    }


    /**
     * 所在项目
     */
    public void createProjectWheelView() {
        int currentProIndex = 0;
        for (int i = 0; i < projectList.size(); i++) {
            if (projectList.get(i).getPid() == pid) {
                currentProIndex = i;
            }
        }
        if (addProject == null) {
            addProject = new WheelViewAboutMyProject(getActivity(), projectList, true, pid);
            addProject.setSelecteWheelView(currentProIndex);
            addProject.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    String proname = projectList.get(postion).getPro_name();
                    LUtils.e(new Gson().toJson(projectList.get(postion)) + ",,,,,");
                    setProInfo(projectList.get(postion).getPid(), proname);

                }
            });
            addProject.setSelecteWheelView(currentProIndex);
        } else {
            addProject.setSelecteWheelView(currentProIndex);
            addProject.update();
        }
        //显示窗口
        addProject.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }

    /**
     * 设置项目信息
     *
     * @param pid
     * @param proname
     */
    public void setProInfo(int pid, String proname) {
        this.pid = pid;
        if (pid != 0) {
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(proname);
        } else {
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(" ");
        }

        adapter.notifyDataSetChanged();
    }

    public void cleraProInfo() {
        this.pid = 0;
        itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value("");
        adapter.notifyDataSetChanged();
    }

    public void clearProjectDialog() {
        if (null != addProject) {
            addProject.dismiss();
        }
        projectList = null;
        addProject = null;
        recordProject();
    }

    /**
     * 计算价钱
     *
     * @param salar
     */
    public void calculateMoney(Salary salar) {
        int hour_type = salar.getHour_type();
        if (hour_type == 1) {//按小时
            double w_money = salar.getS_tpl() / salar.getW_h_tpl() * salar.getChoose_w_h_tpl(); //正常上班计算薪资
            double o_money = salar.getO_s_tpl() * salar.getChoose_o_h_tpl(); //加班时常计算薪资
            price = Utils.m2(w_money + o_money);
            itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value(price);
        } else {//按工天
            if (salar.getS_tpl() == 0) {
                if (salar.getW_h_tpl() == 0 && salar.getO_h_tpl() == 0) {
                    itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("");
                } else {
                    itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("-");
                }
                price = "";
            } else {
                double w_money = salar.getS_tpl() / salar.getW_h_tpl() * salar.getChoose_w_h_tpl(); //正常上班计算薪资
                double o_money = salar.getS_tpl() / salar.getO_h_tpl() * salar.getChoose_o_h_tpl(); //加班时常计算薪资
                price = Utils.m2(w_money + o_money);
                LUtils.e("========price" + price);
                itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value(price);
            }
        }
    }

    @Override
    public void LastRecordInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", String.valueOf(uid));
        params.addBodyParameter("accounts_type", AccountUtil.HOUR_WORKER);

        if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
            params.addBodyParameter("group_id", getActivity().getIntent().getStringExtra(Constance.GROUP_ID));
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LASTPRO, params, ((BaseActivity) getActivity()).new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Project> base = CommonJson.fromJson(responseInfo.result, Project.class);
                    if (base.getState() != 0) {
                        if (null != base.getValues() && base.getValues().getPid() != 0) {
                            pid = base.getValues().getPid();
                            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(base.getValues().getPro_name());
                        } else {
                            pid = 0;
                            if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(((NewAccountActivity) getActivity()).proName);
                            } else {
                                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value("");
                            }
                        }
                        adapter.notifyDataSetChanged();
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    ((BaseActivity) getActivity()).closeDialog();
                }
            }
        });
    }

    /**
     * 保存按钮
     */
    View.OnClickListener savaClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (TextUtils.isEmpty(itemData.get(0).getRight_value())) {
                //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.ple_select_ob), CommonMethod.ERROR);
                adapter.startFlashTips(true, getPosion(itemData, AccountBean.SELECTED_ROLE));
                return;
            }
            if (tpl == null || tpl.getW_h_tpl() <= 0 | tpl.getO_h_tpl() <= 0) {
                //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.set_salary_mode), CommonMethod.ERROR);
                adapter.startFlashTips(true, getPosion(itemData, AccountBean.SALARY));
                return;
            }

            LUtils.e("----点工记账保存：" + new Gson().toJson(tpl));
            FileUpData();
        }
    };
    RequestParams params;

    public void FileUpData() {
        ((BaseActivity) getActivity()).createCustomDialog();
        Salary salar = tpl;
        params = RequestParamsToken.getExpandRequestParams(getActivity());
        AccountInfoBean infoBean = new AccountInfoBean();
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");
        /** 记账类型 1、点工  2、包工  3、总包 */
        infoBean.setAccounts_type(AccountUtil.HOUR_WORKER);
        /** 用户id */
        infoBean.setUid(uid + "");
        /** 提交时间 */
        infoBean.setDate(submitDate);
        /** 正常时间 */
        infoBean.setWork_time(String.valueOf(salar.getChoose_w_h_tpl()) + "");
        /** 加班时间 */
        infoBean.setOver_time(String.valueOf(salar.getChoose_o_h_tpl()) + "");
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        /** 备注描述 */
        if (!TextUtils.isEmpty(remark)) {
            infoBean.setText(TextUtils.isEmpty(remark) ? "" : remark);
        }
        /** 记账对象名称 */
        infoBean.setName(itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).getRight_value());

        /** 模版上班时间 */
        infoBean.setWork_hour_tpl(TextUtils.isEmpty(String.valueOf(salar.getW_h_tpl())) ? "" : String.valueOf(salar.getW_h_tpl()));
        /** 模版加班时间 */
        infoBean.setOvertime_hour_tpl(TextUtils.isEmpty(String.valueOf(salar.getO_h_tpl())) ? "" : String.valueOf(salar.getO_h_tpl()));
        /** 模版金额 */
        infoBean.setSalary_tpl(TextUtils.isEmpty(String.valueOf(salar.getS_tpl())) ? "" : String.valueOf(salar.getS_tpl()));
        /** 总金额 */
        infoBean.setSalary(TextUtils.isEmpty(String.valueOf(price)) ? "" : String.valueOf(price));
        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            params.addBodyParameter("group_id", getActivity().getIntent().getStringExtra(Constance.GROUP_ID));
            if (null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
                params.addBodyParameter("agency_uid", ((NewAccountActivity) getActivity()).getAgency_group_user().getUid());
            }
        }
        /**4.0.2 按小时加班增加参数*/
        if (hour_type == 1 && overtime_salary_tpl != null) {
            infoBean.setOvertime_salary_tpl(overtime_salary_tpl);
            infoBean.setHour_type(1);
        } else {
            infoBean.setHour_type(0);
        }
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        accountInfoBeanList.add(infoBean);
        //聊天跳转过来的记账
        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList).toString());
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                ArrayList<String> tempPhoto = null;
                if (null != imageItems && imageItems.size() > 0) {
                    if (tempPhoto == null) {
                        tempPhoto = new ArrayList<>();
                    }
                    for (int i = 0; i < imageItems.size(); i++) {
                        tempPhoto.add(imageItems.get(i).imagePath.trim());
                    }
                }
                if (tempPhoto != null && tempPhoto.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, getActivity());
                }
                Message message = Message.obtain();
                message.obj = params;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        });
        thread.start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    sendAccount(0);
//                    List<String> list = new ArrayList<>();
//                    list.add("18086988874");
//                    list.add("18380439449");
//                    list.add("18602887226");
//                    list.add("18086988877");
//                    sendSms(getContext(), "这是群发短信的内容……", list);
//                    ((BaseActivity) getActivity()).closeDialog();

                    break;
            }

        }
    };


    /**
     * 发布记账
     */
    public void sendAccount(int is_next_act) {
        HttpUtils http = SingsHttpUtils.getHttp();
        if (is_next_act != 0) {
            params.addBodyParameter("is_next_act", "" + is_next_act);
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.RELASE_NEW, params, new RequestCallBack<String>() {
            @Override
            public void onFailure(HttpException e, String s) {
                ((BaseActivity) getActivity()).closeDialog();
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {

                    CommonJson<AccountSendSuccess> base = CommonJson.fromJson(responseInfo.result.toString(), AccountSendSuccess.class);
                    if (base.getMsg().equals(Constance.SUCCES_S)) {
                        LocalBroadcastManager.getInstance(getActivity()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                        //新项目未创建班组提示框
                        if (!TextUtils.isEmpty(base.getResult().getGroup_id()) && base.getResult().getGroup_id().equals("0")) {
                            List<AccountProjectId> accountProjectIdList = LitePal.findAll(AccountProjectId.class);
                            AccountProjectId accountProjectId = new AccountProjectId();
                            accountProjectId.setPid(pid);
                            LUtils.e(new Gson().toJson(accountProjectIdList) + ",,," + accountProjectIdList.contains(accountProjectId));
                            if (null != accountProjectIdList && accountProjectIdList.size() > 0 && accountProjectIdList.contains(accountProjectId)) {
                                LUtils.e("--------排除掉了");
                            } else {
                                LUtils.e("--------可以显示");
                                accountProjectId.save();
                                showCreateTeamDialog();
                                return;

                            }

                        }

                        if (base.getResult().getIs_exist() == 1) {
                            showNoMoreDialog(base.getResult().getMsg(), base.getResult().getRecord_id(), base.getResult().getAccounts_type(), base.getResult().getUid(), base.getResult().getDate(), base.getResult().getIs_next_act(), ((NewAccountActivity) getActivity()).getAgency_group_user());
                            return;
                        }
                        //保存记账信息
                        String name = itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).getRight_value();
                        AccountUtils.saveWorerInfo(getActivity(), AccountUtil.HOUR_WORKER, uid, name, ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false);
                        record = base.getResult().getRecord_id();
                        //发布成功对话框
                        if (diaLogRecordSuccess == null) {
                            diaLogRecordSuccess = new DiaLogRecordSuccess(getContext(), HourWorkFragment.this, ((NewAccountActivity) getActivity()).roleType);
                        }
                        diaLogRecordSuccess.show();
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), base.getCode(), base.getMsg());
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    ((BaseActivity) getActivity()).closeDialog();
                }
            }

        });
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showNoMoreDialog(String string_resource, String record_id, String
            account_type, String uid, String date, int is_next_act, AgencyGroupUser agencyGroupUser) {
        dialog = null;
        if (dialog == null) {
            dialog = new DiaLogHourWork(getActivity(), account_type, string_resource, record_id, uid, date, is_next_act, agencyGroupUser, new DiaLogHourWork.CloseDialogListener() {
                @Override
                public void closeDialogClick() {
//                    successAccountClick();
                }

                @Override
                public void accountRelease(int is_next_act) {
                    sendAccount(is_next_act);
                }
            });
        }
        dialog.show();
//        dialog.setReal_name(itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).getRight_value());
//        dialog.setAccount_uid(String.valueOf(this.uid));
    }

    /**
     * 提示创建班组弹窗
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showCreateTeamDialog() {

        String group_name = !TextUtils.isEmpty(getItemValue(AccountBean.SELECTED_PROJECT)) ? getItemValue(AccountBean.SELECTED_PROJECT) : "";
        String text = "如果你对[" + group_name + "]项目新建一个班组，添加成员后，就可以对所有工人批量记工了。\n新建班组吗？";
        new DiaLogHintCreateTeam(getActivity(), text, group_name, pid, new DiaLogHintCreateTeam.CloseDialogListener() {
            @Override
            public void closeDialogClick() {
                successAccountClick();
            }
        }).show();
    }

    /**
     * 返回上级页面
     *
     * @param record_id 记账成功的id
     */
    public void finishAct(String record_id) {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString("typeMsg", "bill");
        bundle.putString("record_id", record_id);
        intent.putExtras(bundle);
        getActivity().setResult(Constance.DISPOSEATTEND_RESULTCODE, intent);
        getActivity().finish();
    }

    @Override
    public void onDestroy() {
        if (!TextUtils.isEmpty(record)) {
            finishAct(record);
        }
        super.onDestroy();
    }

    @Override
    public void cancelAccountClick() {
        //取消直接返回上级页面
        finishAct(record);
    }

    /**
     * 检查档次选中的人是否与当前选中的一致
     *
     * @param deleteUid
     */
    public void checkPerson(String deleteUid) {
        if (!TextUtils.isEmpty(deleteUid) && deleteUid.contains(String.valueOf(uid))) {
            successAccountClick();
            isChangeTime = false;
        }

    }

    @Override
    public void successAccountClick() {
        LUtils.e("--11----tpl----" + new Gson().toJson(tpl));

        //再计一笔需要清空内容
        personBean = null;
        if (imageItems != null && imageItems.size() > 0) {
            imageItems = null;
        }
        voicePath = null;
        voiceLength = 0;
        uid = -1;
        pid = 0;
        itemData = getHourData(((NewAccountActivity) getActivity()).roleType, getActivity().getIntent().getStringExtra(Constance.DATE));

//        if (((NewAccountActivity) getActivity()).isMsgAccount) {
//            setMsgText();
//        }
        price = "";
        adapter = new AccountFrgmentsAdapter(getActivity(), itemData);
        listView.setAdapter(adapter);
        adapter.setAccountOnItemClickLitener(this);
        itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("");

        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
                //创建者默认为工头 记账对象可选，所在项目不可选
                pid = ((NewAccountActivity) getActivity()).msgPid;
                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(((NewAccountActivity) getActivity()).proName);
                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setText_color(R.color.color_999999);
                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setClick(false);
                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setShowArrow(false);
            } else {
                //创建者默认为工人 记账对象不可选，所在项目可选
                personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
                itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setRight_value(personBean.getName());
                itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setText_color(R.color.color_999999);
                itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setClick(false);
                itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setShowArrow(false);
                uid = personBean.getUid();
                LastRecordInfo();
//                setSalaryMode(personBean.getTpl());
                searchTpl(personBean.getUid() + "");
            }
        } else {
            tpl = null;

        }

    }

    /**
     * 查询工头班组长信息
     */
    public void searchTpl(String uid) {
        LUtils.e("------------info-----" + uid);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", uid);
        String httpUrl = NetWorkRequest.JLWORKDAY_NEW;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                if (list != null && list.size() > 0) {
                    setSalaryMode(list.get(0).getTpl());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    public String getItemValue(String itemType) {
        if (adapter == null) {
            return "";
        }
        for (AccountBean item : adapter.getList()) {
            if (item.getItem_type().equals(itemType)) {
                return item.getRight_value();
            }
        }
        return "";
    }

    public static void sendSms(Context context, String text, List<String> numbers) {
        String numbersStr = "";
        String symbol = "Samsung".equalsIgnoreCase(Build.MANUFACTURER) ? "," : ";";
        if (numbers != null && !numbers.isEmpty()) {
            numbersStr = TextUtils.join(symbol, numbers);
        }
        LUtils.e(numbersStr);
        Uri uri = Uri.parse("smsto:" + numbersStr);

        Intent intent = new Intent();
        intent.setData(uri);
        intent.putExtra("sms_body", text);
        intent.setAction(Intent.ACTION_SENDTO);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            String defaultSmsPackageName = Telephony.Sms.getDefaultSmsPackage(context);
            if (defaultSmsPackageName != null) {
                intent.setPackage(defaultSmsPackageName);
            }
        }
        if (!(context instanceof Activity)) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        try {
            context.startActivity(intent);
        } catch (Exception e) {
        }
    }
}

