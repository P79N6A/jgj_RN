package com.jizhi.jlongg.account;

import android.annotation.TargetApi;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AccountUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddAccountPersonActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.activity.SalaryModeSettingActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.activity.SingleBatchAccountActivity;
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
 * 功能：包工记工天
 * 时间:2017/2/14 20.08
 * 作者:hcs
 */

public class AllWorkFragment extends AccountFragment implements DiaLogRecordSuccess.AccountSuccessListenerClick, View.OnClickListener {
    /* 图片数据*/
    protected List<ImageItem> imageItems;
    //选择对象列表数据
    protected PersonBean personBean;
    //记账对象ID
    protected int uid;
    /* 记账成功对话框 */
    private DiaLogRecordSuccess diaLogRecordSuccess;
    /* 记账成功id */
    public String record;
    //工人名称，日期，所在项目,数量,包工工钱，上班时间，加班时间
    private TextView tv_role_name, tv_date, tv_proname, tv_worktime, tv_over_time;
    //项目pid
    private int pid = 0;
    //数量单位
    private String remarks;
    /* 薪资模板 */
    private Salary tpl;
    /* 上班/加班时长WheelView */
    public WheelAccountTimeSelected workTimePopWindow, overTimePopWindow;
    /* 上班/加班时长数据 */
    private List<WorkTime> workTimeList, overTimeList;
    /*是否修改了上班加班时间*/
    protected boolean isChangeTime;
    private AlphaAnimation animator;
    /*是否需要查询模版*/
//    protected boolean isSearchSalary;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.account_allwork_fragment, container, false);
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
        String roleType = ((NewAccountActivity) getActivity()).roleType;
        ((TextView) getView().findViewById(R.id.tv_role_title)).setText(roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长");
        tv_role_name = getView().findViewById(R.id.tv_role_name);
        tv_date = getView().findViewById(R.id.tv_date);
        tv_proname = getView().findViewById(R.id.tv_proname);
        tv_worktime = getView().findViewById(R.id.tv_worktime);
        tv_over_time = getView().findViewById(R.id.tv_over_time);
        tv_role_name.setHint(roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头");
        getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.VISIBLE);
        tv_date.setText(getDate());
        getView().findViewById(R.id.rea_role).setOnClickListener(this);
        getView().findViewById(R.id.rea_date).setOnClickListener(this);
        getView().findViewById(R.id.rea_project).setOnClickListener(this);
        getView().findViewById(R.id.rea_remarks).setOnClickListener(this);
        getView().findViewById(R.id.rea_worktime).setOnClickListener(this);
        getView().findViewById(R.id.rea_overtime).setOnClickListener(this);
        getView().findViewById(R.id.rea_salary).setOnClickListener(this);
        getView().findViewById(R.id.save).setOnClickListener(savaClickListener);
        setMsgText();
    }

    /**
     * 是否是聊天跳转过来的记账
     */
    public void setMsgText() {
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            boolean isWorker = ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false;
            String accountType = (String) SPUtils.get(getActivity(), "account_type", AccountUtil.HOUR_WORKER, isWorker ? Constance.ACCOUNT_WORKER_HISTORT : Constance.ACCOUNT_FORMAN_HISTORT);
            if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK) && isWorker) {
                //包工记工天
                PersonBean bean = AccountUtils.getWorerInfo(getActivity(), isWorker);
                if (null != bean && bean.getUid() != 0) {
                    getWorkTPlByUid(bean, true);
                }
            }
            return;
        }
        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            pid = ((NewAccountActivity) getActivity()).msgPid;
            tv_proname.setText(((NewAccountActivity) getActivity()).proName);
            tv_proname.setTextColor(getResources().getColor(R.color.color_999999));
            getView().findViewById(R.id.img_pro_arrow).setVisibility(View.GONE);
            getView().findViewById(R.id.rea_project).setClickable(false);
        } else {
            //创建者默认为工人 记账对象不可选，所在项目可选
            personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
            tv_role_name.setText(personBean.getName());
            tv_role_name.setTextColor(getResources().getColor(R.color.color_999999));
            getView().findViewById(R.id.rea_role).setClickable(false);
            getView().findViewById(R.id.img_role_arrow).setVisibility(View.GONE);
            uid = personBean.getUid();
            searchTpl(uid + "");
            LastRecordInfo();

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
                    setMode(list.get(0).getUnit_quan_tpl());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 初始化传递过来的日期
     *
     * @return
     */
    public String getDate() {
        String date_srr = getActivity().getIntent().getStringExtra(Constance.DATE);
        //日期
        if (!TextUtils.isEmpty(date_srr)) {
            try {
                setData(date_srr);
            } catch (Exception e) {
            }

        } else {
            getTodayTime();
        }
        date_srr = year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "");
        if (getTodayDate().trim().equals(date_srr.trim())) {
            date_srr = date_srr + " (今天)";
        }
        return date_srr;
    }


    /**
     * 设置工人名称
     *
     * @param personName
     */
    public void setPersonName(String personName) {
        FlashingCancel();
        tv_role_name.setText(personName);
    }


    /**
     * @param bean
     * @param isLocal 是否是根据本读数据查询
     *                本地数据查询还需要设置记账对象名称
     */
    public void getWorkTPlByUid(final PersonBean bean, final boolean isLocal) {
        setPersonName(bean.getName());
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("accounts_type", AccountUtil.CONSTRACTOR_CHECK);
        params.addBodyParameter("uid", String.valueOf(bean.getUid()));
        String httpUrl = NetWorkRequest.GET_WORK_TPL_BY_UID;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, AccountWorkRember.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
//                pid = 0;
//                tv_role_name.setText("");
                tv_worktime.setText("");
                tv_over_time.setText("");
                ((TextView) getView().findViewById(R.id.tv_salary)).setText("");
                final AccountWorkRember accountWorkRember = (AccountWorkRember) object;
                bean.setTelph(accountWorkRember.getTelph());
                if (accountWorkRember.getIs_diff() == 1 && !isLocal) {
                    //模版不一致显示弹窗
                    DiaLogHourCheckDialog diaLogHourCheckDialog = new DiaLogHourCheckDialog(getActivity(), bean.getName(), accountWorkRember.getMy_tpl(), accountWorkRember.getOth_tpl(),true, new DiaLogHourCheckDialog.AccountSuccessListenerClick() {
                        @Override
                        public void successAccountClick() {
                            //确认用对方设置的模版记账
                            Salary salary = accountWorkRember.getOth_tpl();
                            salary.setS_tpl(accountWorkRember.getMy_tpl().getS_tpl());
                            setPersonInfo(bean, accountWorkRember.getOth_tpl());
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
                            LUtils.e("-----setOnDismissListener--------");

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
                tv_worktime.setText("");
                tv_over_time.setText("");
                ((TextView) getView().findViewById(R.id.tv_salary)).setText("");
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
        if (null != salary) {
            getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.GONE);
            setMode(salary);
        } else {
            getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.VISIBLE);

        }
        //选择人之后上班加班时间置空
        workTimePopWindow = null;
        overTimePopWindow = null;
        isChangeTime = false;
        //查询最后一次记账项目名字，聊天跳转的不查询
        if (personBean.getUid() != -1 && !getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
            LastRecordInfo();
        }

    }

    /**
     * 设置备注信息
     *
     * @param remark
     */
    public void setRemarkDesc(List<ImageItem> imageItems, String remark) {
        //包工计考勤
        this.imageItems = imageItems;
        this.remarks = remark;
        ((TextView) getView().findViewById(R.id.tv_remarks)).setText(AccountUtil.getAccountRemark(remark, imageItems, getActivity()));


    }

    /**
     * 设置项目信息
     *
     * @param pid
     * @param proname
     */
    public void setProInfo(int pid, String proname) {

        this.pid = pid;
        if (!proname.equals("")) {
            tv_proname.setText(proname);
        } else {
            tv_proname.setText(" ");
        }
    }

    public void cleraProInfo() {
        this.pid = 0;
        tv_proname.setText("");

    }
    /**
     * @version 4.0.2
     * @desc: 记工记账，未选择工人/班组长时，点击日期等信息时，
     *        未选择的项标红闪动提醒（之前的气泡提示去掉，其他必填项未填写，点击保存时，也标红闪动提醒）
     * @param left 左边单项名称
     * @param hint 中间填写的信息
     */
    private void FlashingHints(final TextView left, final TextView hint, final ImageView right_arrow, final ViewGroup item){
            left.setTextColor(getResources().getColor(R.color.color_eb4e4e));
            hint.setHintTextColor(getResources().getColor(R.color.color_eb4e4e));
            right_arrow.setBackgroundResource(R.drawable.jiantou_red);
            item.setBackgroundColor(Color.parseColor("#FFE7E7"));
            if (animator==null) {
                animator = new AlphaAnimation(1.0F, 0.1F);
            }
            animator.setRepeatCount(Animation.INFINITE);
            animator.setDuration(1000);
            animator.setRepeatMode(Animation.REVERSE);
            left.startAnimation(animator);
            hint.startAnimation(animator);
            right_arrow.startAnimation(animator);
            animator.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {
                    LUtils.e("===start");
                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    LUtils.e("===end");
                    left.setTextColor(getResources().getColor(R.color.color_333333));
                    hint.setHintTextColor(getResources().getColor(R.color.color_999999));
                    right_arrow.setBackgroundResource(R.drawable.houtui);
                    item.setBackgroundColor(getResources().getColor(R.color.white));
                }

                @Override
                public void onAnimationRepeat(Animation animation) {
                    LUtils.e("===repeat"+animation.getRepeatCount());
                }
            });
    }

    public void FlashingCancel(){
        if (animator!=null){
            animator.cancel();
        }
    }
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rea_role:
                AddAccountPersonActivity.actionStart(getActivity(), uid + "", getActivity().getIntent().getStringExtra(Constance.GROUP_ID), AccountUtil.CONSTRACTOR_CHECK_INT, 0);
                break;
            case R.id.rea_date:
                //记账日期
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                setTime();
                break;
            case R.id.rea_project:
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                //所在项目
                if (((NewAccountActivity) getActivity()).isMsgAccount && null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
                    return;
                }
                SelecteProjectActivity.actionStart(getActivity(), pid == 0 ? null : pid + "");
                break;
            case R.id.rea_remarks:
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                if (tpl == null || tpl.getW_h_tpl() == 0) {
                    //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                            ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
                    return;
                }
                RemarksActivity.actionStart(getActivity(), remarks, imageItems);
                break;
            case R.id.rea_salary:
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                   // CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                if (null != tpl) {
                    tpl.setS_tpl(0);
                }
                //考勤模版
                SalaryModeSettingActivity.actionStart(getActivity(), tpl, String.valueOf(uid), tv_role_name.getText().toString(), ((NewAccountActivity) getActivity()).roleType, getString(R.string.set_salary_mode_title_check), AccountUtil.CONSTRACTOR_CHECK_INT, isChangeTime);
                break;
            case R.id.rea_worktime:
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                if (tpl == null || tpl.getW_h_tpl() == 0) {
                    //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                            ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
                    return;
                }
                //上班时间
                showWorkTimePop();
                break;
            case R.id.rea_overtime:
                if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                            ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                if (tpl == null || tpl.getW_h_tpl() == 0) {
                    //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                            ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
                    return;
                }
                showOverTimePop();
                //加班时间
                break;
        }
    }

    public void setMode(Salary tplMode) {
        tpl = tplMode;
        if (null == tplMode || tplMode.getW_h_tpl() == 0) {
            tv_worktime.setText("");
            tv_over_time.setText("");
            ((TextView) getView().findViewById(R.id.tv_salary)).setText("");
            getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.VISIBLE);
            return;
        }
        getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.GONE);
        FlashingCancel();
        workTimePopWindow = null;
        overTimePopWindow = null;
        LUtils.e(tv_worktime.getText().toString().trim() + "---11--------" + tv_worktime.getText().toString().trim());
        ((TextView) getView().findViewById(R.id.tv_salary)).setText((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(上班)/" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时(加班)");
        if (TextUtils.isEmpty(tv_worktime.getText().toString().trim())) {
            tpl.setChoose_w_h_tpl(tpl.getW_h_tpl());
            tv_worktime.setText((tplMode.getW_h_tpl() + "").replace(".0", "") + "小时(1个工)");
        } else {
            if (tplMode.getChoose_w_h_tpl() == tplMode.getW_h_tpl()) {
                tv_worktime.setText((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时(1个工)");
            } else {
                if (tplMode.getChoose_w_h_tpl() == 0) {
                    tv_worktime.setText("休息");
                } else {
                    tv_worktime.setText((tplMode.getChoose_w_h_tpl() + "").replace(".0", "") + "小时");
                }

            }
        }
        if (TextUtils.isEmpty(tv_over_time.getText().toString().trim())) {
            tpl.setChoose_o_h_tpl(0.0);
            tv_over_time.setText("无加班");
        } else {
            if (tplMode.getChoose_o_h_tpl() == tplMode.getO_h_tpl()) {
                tv_over_time.setText((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时(1个工)");
            } else {
                if (tplMode.getChoose_o_h_tpl() == 0) {
                    tv_over_time.setText("无加班");
                } else {
                    tv_over_time.setText((tplMode.getChoose_o_h_tpl() + "").replace(".0", "") + "小时");
                }

            }
        }
    }

    /**
     * 今天工作时长
     */
    public void showWorkTimePop() {
        if (tpl == null || tpl.getW_h_tpl() == 0) {
            //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
            FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                    ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
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
                workTimePopWindow = new WheelAccountTimeSelected(getActivity(), getString(R.string.choosetime), workTimeList, currentIndex, true,0);
                workTimePopWindow.setListener(new CallBackSingleWheelListener() {
                    @Override
                    public void onSelected(String scrollContent, int postion) {
                        isChangeTime = true;
                        WorkTime time = workTimeList.get(postion);
                        if (time.getWorkTimes() == 0) { //休息
                            tv_worktime.setText(time.getWorkName());
                        } else {
                            tv_worktime.setText(time.getWorkName().replace(".0", "") + time.getUnit());

                        }
                        salar.setChoose_w_h_tpl(time.getWorkTimes());

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
            //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
            FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                    ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
            return;
        } else {
            final Salary salar = tpl;
            if (overTimePopWindow == null) {
                overTimeList = DataUtil.getOverTime(0, tpl.getO_h_tpl());
                int currentIndex = 0;
                overTimePopWindow = new WheelAccountTimeSelected(getActivity(), getString(R.string.choosetime), overTimeList, currentIndex, false,0);
                overTimePopWindow.setListener(new CallBackSingleWheelListener() {
                    @Override
                    public void onSelected(String scrollContent, int postion) {
                        isChangeTime = true;
                        WorkTime time = overTimeList.get(postion);
                        if (time.getWorkTimes() == 0) { //休息
                            tv_over_time.setText(time.getWorkName());
                        } else {
                            tv_over_time.setText(time.getWorkName().replace(".0", "") + time.getUnit());

                        }
                        salar.setChoose_o_h_tpl(time.getWorkTimes());

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

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                    ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
            return;
        }
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(getActivity(), getString(R.string.choosetime), AccountUtil.CONSTRACTOR_CHECK_INT, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                    if (personBean == null) {
                        //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                        FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                                ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                        return;
                    }
                    SingleBatchAccountActivity.actionStart(getActivity(), personBean, pid + "", tv_proname.getText().toString().trim(),
                            getActivity().getIntent().getStringExtra(Constance.GROUP_ID), ((NewAccountActivity) getActivity()).getAgency_group_user(),
                            AccountUtil.CONSTRACTOR_CHECK_INT);
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
                    AllWorkFragment.super.year =
                            AllWorkFragment.super.year = intYear;
                    AllWorkFragment.super.month = intMonth;
                    AllWorkFragment.super.day = intDay;
                    String selectDate = intYear + "-" + (AllWorkFragment.super.month < 10 ? "0" + month : month + "") + "-" + (AllWorkFragment.super.day < 10 ? "0" + day : day + "");
                    if (getTodayDate().trim().equals(selectDate.trim())) {
                        selectDate = selectDate + " (今天)";
                    }
                    tv_date.setText(selectDate);
                }
            }, year, month, day);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }


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
                    setProInfo(projectList.get(postion).getPid(), projectList.get(postion).getPro_name());
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

    @Override
    public void LastRecordInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", String.valueOf(uid));
        params.addBodyParameter("accounts_type", AccountUtil.CONSTRACTOR_CHECK);
        if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
//            params.addBodyParameter("group_role", ((NewAccountActivity) getActivity()).roleType);
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
                            tv_proname.setText(base.getValues().getPro_name());
                        } else {
                            pid = 0;
                            if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                                tv_proname.setText(((NewAccountActivity) getActivity()).proName);
                            } else {
                                tv_proname.setText("");
                            }
                        }
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
            //记账日期
            if (TextUtils.isEmpty(tv_role_name.getText().toString())) {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView)getView().findViewById(R.id.tv_role_name)
                        ,(ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                return;
            }

            //包工计考勤
            if (tpl == null || tpl.getW_h_tpl() <= 0 | tpl.getO_h_tpl() <= 0) {
                //CommonMethod.makeNoticeShort(getActivity(), "请设置考勤模板", CommonMethod.ERROR);
                FlashingHints((TextView) getView().findViewById(R.id.account_left_text),(TextView)getView().findViewById(R.id.tv_salary)
                        ,(ImageView) getView().findViewById(R.id.account_rr),(RelativeLayout)getView().findViewById(R.id.rea_salary));
                return;
            }

            FileUpData();

        }
    };
    RequestParams params;

    public void FileUpData() {
        ((BaseActivity) getActivity()).createCustomDialog();
        params = RequestParamsToken.getExpandRequestParams(getActivity());
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");
        AccountInfoBean infoBean = new AccountInfoBean();
        /** 用户id */
        infoBean.setUid(uid + "");
        /** 记账对象名称 */
        infoBean.setName(tv_role_name.getText().toString().trim());
        /** 提交时间 */
        infoBean.setDate(submitDate);
        /** 项目id */
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        /** 记账对象名称 */
        infoBean.setPro_name(TextUtils.isEmpty(tv_proname.getText().toString().trim()) ? "" : tv_proname.getText().toString().trim());
        //包工计考勤
        infoBean.setAccounts_type(AccountUtil.CONSTRACTOR_CHECK);
        /** 上班时间 */
        infoBean.setWork_time(tpl.getChoose_w_h_tpl() + "");
        /** 加班时间 */
        infoBean.setOver_time(tpl.getChoose_o_h_tpl() + "");
        /** 模版上班时间 */
        infoBean.setWork_hour_tpl(tpl.getW_h_tpl() + "");
        /** 模版加班时间 */
        infoBean.setOvertime_hour_tpl(tpl.getO_h_tpl() + "");
        /** 模版金额 */
        infoBean.setSalary_tpl(tpl.getS_tpl() + "");
        if (!TextUtils.isEmpty(remarks)) {
            /** 备注描述 */
            infoBean.setText(TextUtils.isEmpty(remarks) ? "" : remarks);
        }


        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        accountInfoBeanList.add(infoBean);
        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList));


        //聊天跳转过来的记账
        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            params.addBodyParameter("group_id", getActivity().getIntent().getStringExtra(Constance.GROUP_ID));
            if (null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
                params.addBodyParameter("agency_uid", ((NewAccountActivity) getActivity()).getAgency_group_user().getUid());
            }
        }
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                ArrayList<String> tempPhoto = null;

                //包工计考勤
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
                        record = "1";
                        String name = tv_role_name.getText().toString();
                        AccountUtils.saveWorerInfo(getActivity(), AccountUtil.CONSTRACTOR_CHECK, uid, name, ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false);
                        record = "1";
                        //发布成功对话框
                        if (diaLogRecordSuccess == null) {
                            diaLogRecordSuccess = new DiaLogRecordSuccess(getContext(), AllWorkFragment.this, ((NewAccountActivity) getActivity()).roleType);
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

    DiaLogHourWork dialog;


    /**
     * 提示创建班组弹窗
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showCreateTeamDialog() {
        String group_name = tv_proname.getText().toString().trim();
        String text = "如果你对[" + group_name + "]项目新建一个班组，添加成员后，就可以对所有工人批量记工了。\n新建班组吗？";
        new DiaLogHintCreateTeam(getActivity(), text, group_name, pid, new DiaLogHintCreateTeam.CloseDialogListener() {
            @Override
            public void closeDialogClick() {
                successAccountClick();
            }
        }).show();
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
    }

    /**
     * 返回上级页面
     */
    public void finishAct() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString("typeMsg", "bill");
        bundle.putString("record_id", record);
        intent.putExtras(bundle);
        getActivity().setResult(Constance.DISPOSEATTEND_RESULTCODE, intent);
        getActivity().finish();
    }

    @Override
    public void cancelAccountClick() {
        finishAct();
    }


    /**
     * 检查档次选中的人是否与当前选中的一致
     *
     * @param deleteUid
     */
    public void checkPerson(String deleteUid) {
        if (!TextUtils.isEmpty(deleteUid) && deleteUid.contains(String.valueOf(uid))) {
            successAccountClick();
        }

    }

    @Override
    public void successAccountClick() {
        //再计一笔需要清空内容
        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            setMsgText();
        }
        personBean = null;
        if (imageItems != null && imageItems.size() > 0) {
            imageItems = null;
        }
        tv_date.setText(getDate());
        pid = 0;
        uid = -1;
        tv_role_name.setText("");
        tv_proname.setText("");
        tv_worktime.setText("");
        tv_over_time.setText("");
        ((TextView) getView().findViewById(R.id.tv_salary)).setText("");
        ((TextView) getView().findViewById(R.id.tv_remarks)).setText("");
        getView().findViewById(R.id.hout_work_time_hinet).setVisibility(View.VISIBLE);
        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            LUtils.e("---------222222----");

            if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
                pid = ((NewAccountActivity) getActivity()).msgPid;
                tv_proname.setText(((NewAccountActivity) getActivity()).proName);
                tv_proname.setTextColor(getResources().getColor(R.color.color_999999));
                getView().findViewById(R.id.img_pro_arrow).setVisibility(View.GONE);
                getView().findViewById(R.id.rea_project).setClickable(false);
            } else {
                //创建者默认为工人 记账对象不可选，所在项目可选
                personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
                tv_role_name.setText(personBean.getName());
                tv_role_name.setTextColor(getResources().getColor(R.color.color_999999));
                getView().findViewById(R.id.rea_role).setClickable(false);
                getView().findViewById(R.id.img_role_arrow).setVisibility(View.GONE);
                uid = personBean.getUid();
//                if (null != personBean.getUnit_quan_tpl() && personBean.getUnit_quan_tpl().getW_h_tpl() != 0) {
//                    setMode(personBean.getUnit_quan_tpl());
//                }
                LastRecordInfo();
//                this.tpl = tpl;

                LUtils.e("------tpl----" + new Gson().toJson(tpl));
//                setMode(tpl);

            }
        } else {
            tpl = null;
        }
    }

}
