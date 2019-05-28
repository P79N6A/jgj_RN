package com.jizhi.jlongg.account;

import android.annotation.TargetApi;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddAccountPersonActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.NoMoneyLittleWorkActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AccountProjectId;
import com.jizhi.jlongg.main.bean.AccountSendSuccess;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.AccountWageDialog;
import com.jizhi.jlongg.main.dialog.DiaLogHintCreateTeam;
import com.jizhi.jlongg.main.dialog.DiaLogRecordSuccess;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
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

import static com.jizhi.jlongg.R.id.unAccountCountLayout;
import static com.jizhi.jlongg.main.util.Constance.ROLETYPE_FM;


/**
 * 功能:结算
 * 时间:2017/4/13 15.34
 * 作者:hcs
 */

public class WagesSettlementFragment extends AccountFragment implements View.OnClickListener, DiaLogRecordSuccess.AccountSuccessListenerClick {
    /* 选择与我相关项目的WheelView */
    public WheelViewAboutMyProject addProject;
    /* 记账成功对话框 */
    private DiaLogRecordSuccess diaLogRecordSuccess;
    /* 记账成功id */
    public String record;
    private String date_srr;//日期信息
    //选择对象列表数据
    protected PersonBean personBean;
    //记账对象ID
    protected int uid;
    /* 语音路径*/
    protected String voicePath;
    /* 语音长度*/
    protected int voiceLength;
    /* 图片数据*/
    protected List<ImageItem> imageItems;
    //工人名字,时间，所在项目，备注信息,补奖扣合计
    private TextView tv_role, tv_date, tv_proname, tv_remarks, tv_s_r_f;
    //补奖惩
    private EditText ed_wage_subsidy, ed_wage_reward, ed_wage_fine;
    //本次实付收金额,抹零金额
    private EditText ed_income_money, ed_wage_del;
    //是否展开补贴奖励罚款
    private boolean isExpand;

    private Double balance_amount, wage_all, wage_wage, income_all;//未结工资,补奖罚金额，本次结算金额,剩余未结金额
    private TextView tv_wage_supplus_unset, tv_wage_wage;//剩余未结工资,本次结算金额
    private ImageView img_hint_wage1, img_hint_wage2, img_hint_wage3;//提示内容
    /*备注 */
    private String remark;
    //返回是否刷新界面
    public boolean isFulsh;
    private AlphaAnimation animator;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.account_wages_list, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        ((NewAccountActivity) getActivity()).initSettlement();
    }
    /**
     * @version 4.0.2
     * @desc: 记工记账，未选择工人/班组长时，点击日期等信息时，
     *        未选择的项标红闪动提醒（之前的气泡提示去掉，其他必填项未填写，点击保存时，也标红闪动提醒）
     * @param left 左边单项名称
     * @param hint 中间填写的信息
     */
    private void FlashingHints(final TextView left, final View hint, final ImageView right_arrow, final ViewGroup item){
        left.setTextColor(getResources().getColor(R.color.color_eb4e4e));
        if (hint instanceof TextView) {
            ((TextView)hint).setHintTextColor(getResources().getColor(R.color.color_eb4e4e));
        }else if (hint instanceof EditText){
            ((EditText)hint).setHintTextColor(getResources().getColor(R.color.color_eb4e4e));
        }
        if (right_arrow!=null) {
            right_arrow.setBackgroundResource(R.drawable.jiantou_red);
        }
        item.setBackgroundColor(Color.parseColor("#FFE7E7"));
        if (animator==null) {
            animator = new AlphaAnimation(1.0F, 0.1F);
        }
        animator.setRepeatCount(Animation.INFINITE);
        animator.setDuration(1000);
        animator.setRepeatMode(Animation.REVERSE);
        left.startAnimation(animator);
        hint.startAnimation(animator);
        if (right_arrow!=null) {
            right_arrow.startAnimation(animator);
        }
        animator.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                LUtils.e("===start");
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                LUtils.e("===end");
                if (hint instanceof TextView) {
                    ((TextView)hint).setHintTextColor(getResources().getColor(R.color.color_999999));
                }else if (hint instanceof EditText){
                    ((EditText)hint).setHintTextColor(getResources().getColor(R.color.color_999999));
                }
                if (right_arrow!=null) {
                    right_arrow.setBackgroundResource(R.drawable.houtui);
                }
                left.setTextColor(getResources().getColor(R.color.color_333333));
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
    /**
     * 初始化控件
     */
    public void initView() {
        isExpand = true;
        //初始信息
        ((TextView) getView().findViewById(R.id.tv_role_title)).setText(((NewAccountActivity) getActivity()).roleType.equals(ROLETYPE_FM) ? "工人" : "班组长");
        ((TextView) getView().findViewById(R.id.tv_income_money)).setText(((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM) ? "本次实付金额" : "本次实收金额");
        tv_role = getView().findViewById(R.id.tv_role);
        tv_proname = getView().findViewById(R.id.tv_proname);
        tv_remarks = getView().findViewById(R.id.tv_remarks);
        tv_s_r_f = getView().findViewById(R.id.tv_s_r_f);
        tv_wage_supplus_unset = getView().findViewById(R.id.tv_wage_supplus_unset);
        tv_wage_wage = getView().findViewById(R.id.tv_wage_wage);
        ed_income_money = getView().findViewById(R.id.ed_income_money);
        ed_wage_del = getView().findViewById(R.id.ed_wage_del);
        tv_role.setHint(((NewAccountActivity) getActivity()).roleType.equals(ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头");
        tv_date = getView().findViewById(R.id.tv_date);
        balance_amount = 0.0;
        date_srr = getActivity().getIntent().getStringExtra(Constance.DATE);
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
        tv_date.setText(date_srr);
        //设置未结工资模版
        getView().findViewById(R.id.tv_salary).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NoMoneyLittleWorkActivity.actionStart(getActivity(), uid + "");
            }
        });


        img_hint_wage1 = getActivity().findViewById(R.id.img_hint_wage1);
        img_hint_wage2 = getActivity().findViewById(R.id.img_hint_wage2);
        img_hint_wage3 = getActivity().findViewById(R.id.img_hint_wage3);
        getView().findViewById(R.id.rea_role).setOnClickListener(this);
        getView().findViewById(R.id.rea_date).setOnClickListener(this);
        getView().findViewById(R.id.rea_s_r_f).setOnClickListener(this);
        getView().findViewById(R.id.rea_project).setOnClickListener(this);
        getView().findViewById(R.id.rea_remarks).setOnClickListener(this);
        getView().findViewById(R.id.lin_send).setOnClickListener(this);
        getView().findViewById(unAccountCountLayout).setOnClickListener(this);
        img_hint_wage1.setOnClickListener(this);
        img_hint_wage2.setOnClickListener(this);
        img_hint_wage3.setOnClickListener(this);
        ed_wage_subsidy = getView().findViewById(R.id.ed_wage_subsidy);
        ed_wage_reward = getView().findViewById(R.id.ed_wage_reward);
        ed_wage_fine = getView().findViewById(R.id.ed_wage_fine);
        setEditTextDecimalNumberLength(ed_wage_subsidy, 7, 2);
        setEditTextDecimalNumberLength(ed_wage_reward, 7, 2);
        setEditTextDecimalNumberLength(ed_wage_fine, 7, 2);
//        setEditTextDecimalNumberLength(ed_income_money, 7, 2);
//        setEditTextDecimalNumberLength(ed_wage_del, 7, 2);
        addTextChangedListener(ed_wage_subsidy);
        addTextChangedListener(ed_wage_reward);
        addTextChangedListener(ed_wage_fine);
        addTextChangedListener(ed_income_money);
        addTextChangedListener(ed_wage_del);
        ed_wage_subsidy.setOnTouchListener(onTouchListener);
        ed_wage_reward.setOnTouchListener(onTouchListener);
        ed_wage_fine.setOnTouchListener(onTouchListener);
        ed_income_money.setOnTouchListener(onTouchListener);
        ed_wage_del.setOnTouchListener(onTouchListener);
//        ed_income_money.setInputType(InputType.TYPE_NUMBER_FLAG_SIGNED|InputType.TYPE_NUMBER_FLAG_DECIMAL);
        ed_income_money.setFilters(new InputFilter[]{new DecimalInputFilter(7, 2, true)});
        ed_wage_del.setFilters(new InputFilter[]{new DecimalInputFilter(7, 2, true)});
        //聊天跳转过来的记账
        setMsgText();
    }

    /**
     * 是否是聊天跳转过来的记账
     */
    public void setMsgText() {
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            return;
        }
        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            pid = ((NewAccountActivity) getActivity()).msgPid;
            tv_proname.setText(NameUtil.setRemark(((NewAccountActivity) getActivity()).proName, 10));
            tv_proname.setTextColor(getResources().getColor(R.color.color_999999));
            getView().findViewById(R.id.img_pro_arrow).setVisibility(View.GONE);
            getView().findViewById(R.id.rea_project).setClickable(false);
        } else {
            //创建者默认为工人 记账对象不可选，所在项目可选
            personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
            tv_role.setText(personBean.getName());
            tv_role.setTextColor(getResources().getColor(R.color.color_999999));
            getView().findViewById(R.id.rea_role).setClickable(false);
            getView().findViewById(R.id.img_role_arrow).setVisibility(View.GONE);
            uid = personBean.getUid();
            getUnPaySalaryList(personBean.getUid() + "", true);
            LastRecordInfo();
        }
    }

    View.OnTouchListener onTouchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (TextUtils.isEmpty(tv_role.getText().toString())) {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView) getView().findViewById(R.id.tv_role),
                        (ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                return true;
            }
            return false;
        }
    };

    @Override
    public void onClick(View v) {
        if (v.getId() != R.id.rea_s_r_f && v.getId() != R.id.img_hint_wage1 && v.getId() != R.id.img_hint_wage2 && v.getId() != R.id.img_hint_wage3
                && v.getId() != R.id.rea_role && TextUtils.isEmpty(tv_role.getText().toString())) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView) getView().findViewById(R.id.tv_role),
                    (ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
            return;
        }

        switch (v.getId()) {
            case R.id.rea_role:
//                //选择角色
                AddAccountPersonActivity.actionStart(getActivity(), uid + "", getActivity().getIntent().getStringExtra(Constance.GROUP_ID), AccountUtil.SALARY_BALANCE_INT, 0);
                break;
            case R.id.rea_date:
                //时间
                setTime();
                break;
            case R.id.rea_s_r_f:
                //补贴奖励罚款
                if (isExpand) {
                    isExpand = false;
                    Utils.setBackGround(getActivity().findViewById(R.id.img_s_r_f), ContextCompat.getDrawable(getActivity(), R.drawable.account_arrow_up));
                    getActivity().findViewById(R.id.lin_wages_other).setVisibility(View.VISIBLE);
                } else {
                    isExpand = true;
                    Utils.setBackGround(getActivity().findViewById(R.id.img_s_r_f), ContextCompat.getDrawable(getActivity(), R.drawable.account_arrow_down));
                    getActivity().findViewById(R.id.lin_wages_other).setVisibility(View.GONE);
                }
                break;
            case R.id.rea_project:
                //与我相关的项目
//                recordProject();
                if (TextUtils.isEmpty(tv_role.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView) getView().findViewById(R.id.tv_role),
                            (ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                if (((NewAccountActivity) getActivity()).isMsgAccount && null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
                    return;
                }
                SelecteProjectActivity.actionStart(getActivity(), pid == 0 ? null : pid + "");
                break;
            case R.id.rea_remarks:
                //备注
                RemarksActivity.actionStart(getActivity(), remark, imageItems);
                break;
            case R.id.lin_send:
                if (TextUtils.isEmpty(tv_role.getText().toString())) {
                    //CommonMethod.makeNoticeShort(getActivity(), getString(R.string.ple_select_ob), CommonMethod.ERROR);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView) getView().findViewById(R.id.tv_role),
                            (ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
                    return;
                }
                //补贴金额
                Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
                //奖励金额
                Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
                //罚款金额
                Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
                // 本次实付金额
                Double income_money = getEditM(ed_income_money.getText().toString().trim());
                if (wage_subsidy == 0 && wage_reward == 0 && wage_fine == 0 && income_money == 0) {
                    String str = ((TextView) getView().findViewById(R.id.tv_income_money)).getText().toString().toString();
                    //CommonMethod.makeNoticeLong(getActivity(), "补贴、奖励、罚款金额和" + str + "不能同时为0", false);
                    FlashingHints((TextView) getView().findViewById(R.id.tv_income_money),(EditText) getView().findViewById(R.id.ed_income_money),
                            null,(RelativeLayout)getView().findViewById(R.id.rea_layout));
                    return;
                }
                Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
                WorkDetail workDetail = new WorkDetail();
                //本次实收金额
                workDetail.setPay_amount(income_money);
                //补贴金额
                workDetail.setSubsidy_amount(wage_subsidy);
                //奖励金额
                workDetail.setReward_amount(wage_reward);
                //罚款金额
                workDetail.setPenalty_amount(wage_fine);
                //抹零金额
                workDetail.setDeduct_amount(wage_del);
                //本次结算金额
                workDetail.setAmounts(Utils.m2(wage_wage));
                //剩余未结金额
                workDetail.setUnbalance_amount(income_all);
                //未结工资
                workDetail.setBalance_amount(balance_amount);

                new AccountWageDialog(getActivity(), ((NewAccountActivity) getActivity()).roleType, Utils.m2(wage_wage), Utils.m2(income_all), new AccountWageDialog.AccountSuccessListenerClick() {
                    @Override
                    public void successAccountClick() {
                        FileUpData();
                    }
                }).show();
                break;
            case R.id.img_hint_wage1:
                // popwin弹窗 1.未结工资
                showAccountPopWin(getActivity(), img_hint_wage1, 1, ((NewAccountActivity) getActivity()).roleType);
                break;
            case R.id.img_hint_wage2:
                //popwin弹窗  2.本次结算金额
                showAccountPopWin(getActivity(), img_hint_wage2, 2, ((NewAccountActivity) getActivity()).roleType);
                break;
            case R.id.img_hint_wage3:
                // popwin弹窗  3.剩余未结金额
                showAccountPopWin(getActivity(), img_hint_wage3, 3, ((NewAccountActivity) getActivity()).roleType);
                break;
            case unAccountCountLayout:
                RecordWorkConfirmActivity.actionStart(getActivity(), year + "-" + month + "-" + day, uid + "", AccountUtil.SALARY_BALANCE);
                break;
        }
    }

    /**
     * 设置工人名称
     *
     * @param personName
     */
    public void setPersonName(String personName) {
        FlashingCancel();
        tv_role.setText(personName);
    }


    /**
     * 设置备注信息
     *
     * @param remark
     */
    public void setRemarkDesc(String remark, List<ImageItem> imageItems) {
        this.remark = remark;
        this.imageItems = imageItems;
        tv_remarks.setText(AccountUtil.getAccountRemark(remark, imageItems, getActivity()));

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
            tv_proname.setText(NameUtil.setRemark(proname, 10));
        } else {
            tv_proname.setText(" ");
        }
    }

    public void cleraProInfo() {
        this.pid = 0;
        tv_proname.setText("");

    }

    /**
     * edittext输入监听
     *
     * @param editText
     */
    public void addTextChangedListener(final EditText editText) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                //这部分是处理如果用户输入以.开头，在前面加上0
                if (s.toString().trim().substring(0).equals(".")) {

                    editText.setText("0" + s);
                    editText.setSelection(2);
                }
                //这里处理用户 多次输入.的处理 比如输入 1..6的形式，是不可以的
                if (s.toString().startsWith("0")
                        && s.toString().trim().length() > 1) {
                    if (!s.toString().substring(1, 2).equals(".")) {
                        editText.setText(s.subSequence(0, 1));
                        editText.setSelection(1);
                        return;
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                //光标移动到最后
                if (s.length() > 0 && s.toString().trim().equals("0.00")) {
                    editText.setSelection(s.toString().trim().length());
                    FlashingCancel();
                }
                //补贴金额
                Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
                //奖励金额
                Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
                //罚款金额
                Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
                // 本次实付金额
                Double income_money = getEditM(ed_income_money.getText().toString().trim());
//                Double income_money = ed_income_money.getText().toString().trim());
                //抹零金额
                Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
//                补奖罚合计金额：
//                合计金额 = 补贴金额 + 奖励金额 - 罚款金额
                wage_all = wage_subsidy + wage_reward - wage_fine;
                //本次结算金额 = 本次实付金额（本次实收金额） + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额
                wage_wage = income_money + wage_del + wage_fine - wage_subsidy - wage_reward;
                //剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额,tv_wage_supplus_unset
                income_all = balance_amount + wage_subsidy + wage_reward - wage_fine - income_money - wage_del;
                LUtils.e("-----补贴金额------    " + wage_subsidy);
                LUtils.e("-----奖励金额------    " + wage_reward);
                LUtils.e("-----罚款金额------    " + wage_fine);
                LUtils.e("-----本次实付金额------    " + wage_subsidy);
                LUtils.e("-----抹零金额------    " + wage_del);
                LUtils.e("-----补奖罚合计金额------" + wage_all);
                LUtils.e("-----未结金额------    " + balance_amount);
                LUtils.e("-----本次结算金额------    " + wage_wage);
                LUtils.e("-----剩余未结金额------    " + income_all);

                LUtils.e("=========================================");


                switch (editText.getId()) {
                    case R.id.ed_wage_subsidy:
                        //补贴金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_wage_reward:
                        //奖励金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_wage_fine:
                        //罚款金额-合计金额
                        tv_s_r_f.setText(Utils.m2(wage_all));
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;
                    case R.id.ed_income_money: //本次实付金额
                        //本次结算金额
                        if (!TextUtils.isEmpty(s)){
                            FlashingCancel();
                        }
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        //改变值后重新计算剩余未结金额和本次结算金额
                        break;
                    case R.id.ed_wage_del: //抹零金额
                        //本次结算金额
                        tv_wage_wage.setText(Utils.m2(wage_wage));
                        //剩余未结金额
                        tv_wage_supplus_unset.setText(Utils.m2(income_all));
                        break;

                }
            }


        });
    }

    /**
     * 获取输入的内容转换为double类型
     *
     * @param m
     * @return
     */
    public Double getEditM(String m) {
        if (TextUtils.isEmpty(m) || m.equals(".")) {
            m = "0";
        } else if (m.endsWith(".")) {
            m = m + "0";
        }
        if (m.contains("-")) {
            if (TextUtils.isEmpty(m.replace("-", ""))) {
                return 0.0;
            } else {
                double da = -Double.parseDouble(m.replace("-", ""));
                return -Double.parseDouble(m.replace("-", ""));
            }


        }
        return Double.parseDouble(m);
    }

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (TextUtils.isEmpty(tv_role.getText().toString())) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            FlashingHints((TextView) getView().findViewById(R.id.tv_role_title),(TextView) getView().findViewById(R.id.tv_role),
                    (ImageView) getView().findViewById(R.id.img_role_arrow),(RelativeLayout)getView().findViewById(R.id.rea_role));
            return;
        }
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(getActivity(), getString(R.string.choosetime), 3, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
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
                    WagesSettlementFragment.super.year =
                            WagesSettlementFragment.super.year = intYear;
                    WagesSettlementFragment.super.month = intMonth;
                    WagesSettlementFragment.super.day = intDay;
                    String selectDate = intYear + "-" + (WagesSettlementFragment.super.month < 10 ? "0" + month : month + "") + "-" + (WagesSettlementFragment.super.day < 10 ? "0" + day : day + "");
                    if (getTodayDate().trim().equals(selectDate.trim())) {
                        selectDate = selectDate + " (今天)";
                    }
                    tv_date.setText(selectDate);
                    getUnPaySalaryList(uid + "", false);
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
            addProject = new WheelViewAboutMyProject(getActivity(), projectList, true);
            addProject.setSelecteWheelView(currentProIndex);
            addProject.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    String proname = projectList.get(postion).getPro_name();
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


    @Override
    public void LastRecordInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", String.valueOf(uid));
        params.addBodyParameter("accounts_type", AccountUtil.SALARY_BALANCE);
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
                            tv_proname.setText(NameUtil.setRemark(base.getValues().getPro_name(), 12));
                        } else {
                            pid = 0;
                            if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                                String pname = ((NewAccountActivity) getActivity()).proName;
                                tv_proname.setText(NameUtil.setRemark(pname, 12));
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


    private RequestParams getParams() {


        return params;
    }

    RequestParams params;

    public void FileUpData() {
        ((BaseActivity) getActivity()).createCustomDialog();
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");
        AccountInfoBean infoBean = new AccountInfoBean();
        params = RequestParamsToken.getExpandRequestParams(getActivity());
        /** 记账类型 1、点工  2、包工  3、总包 4.工钱结算*/
        infoBean.setAccounts_type(AccountUtil.SALARY_BALANCE);
        /** 记账对象名称 */
        infoBean.setName(tv_role.getText().toString());
        /** 用户id */
        infoBean.setUid(uid + "");
        /** 本次支付金额 */
        infoBean.setSalary(ed_income_money.getText().toString());
        /** 未结工资 */
        infoBean.setBalance_amount(balance_amount + "");
        /** 补贴工资 */
        infoBean.setSubsidy_amount(ed_wage_subsidy.getText().toString());
        /** 奖金工资 */
        infoBean.setReward_amount(ed_wage_reward.getText().toString());
        /** 惩罚工资 */
        infoBean.setPenalty_amount(ed_wage_fine.getText().toString());
        /** 抹零工资 */
        infoBean.setDeduct_amount(ed_wage_del.getText().toString());
        /** 提交时间 */
        infoBean.setDate(submitDate);
        /** 项目名称 */
        infoBean.setPro_name(tv_proname.getText().toString());
        /** 项目id */
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        /** 备注描述 */
        if (!TextUtils.isEmpty(remark)) {
            /** 备注描述 */
            infoBean.setText(TextUtils.isEmpty(remark) ? "" : remark);
        }
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        accountInfoBeanList.add(infoBean);
        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList).toString());

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
                    sendAccount();
                    break;
            }

        }
    };

    /**
     * 发布记账
     */
    public void sendAccount() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.RELASE_NEW, getParams(), new RequestCallBack<String>() {
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
                        if (diaLogRecordSuccess == null) {
                            diaLogRecordSuccess = new DiaLogRecordSuccess(getContext(), WagesSettlementFragment.this, ((NewAccountActivity) getActivity()).roleType);
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

    public void initVisible(int state) {
        getView().findViewById(R.id.lin_driver_1).setVisibility(state);
        getView().findViewById(R.id.lin_driver_2).setVisibility(state);
        getView().findViewById(R.id.rea_wage).setVisibility(state);
    }

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

    /**
     * 获取当天是否记过工
     *
     * @param uid
     */
    public void getUnPaySalaryList(String uid, final boolean isChangePerson) {
        initVisible(View.VISIBLE);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        } else {
            if (this.uid == 0) {
                ((TextView) getView().findViewById(R.id.tv_textview_wage)).setText("");//未结工资数

                initVisible(View.GONE);
                return;
            }
            params.addBodyParameter("uid", this.uid + "");
        }
        //聊天跳转过来的记账
//        if (((NewAccountActivity) getActivity()).isMsgAccount) {
//            params.addBodyParameter("group_id", getActivity().getIntent().getStringExtra(Constance.GROUP_ID));
//        }
        params.addBodyParameter("accounts_type", AccountUtil.SALARY_BALANCE);
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");
        params.addBodyParameter("date", submitDate);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_UNBALANCEANDSALARYTPL, params, new RequestCallBack() {

            @Override
            public void onFailure(HttpException e, String s) {

            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonJson<PersonBean> bean = CommonJson.fromJson(responseInfo.result.toString(), PersonBean.class);
                    if (bean.getMsg().equals(Constance.SUCCES_S)) {
                        //显示未结工资
                        if (bean.getResult().getUn_salary_tpl() > 0) {
                            getView().findViewById(R.id.lin_unset).setVisibility(View.VISIBLE);
                            balance_amount = bean.getResult().getBalance_amount();
                            ((TextView) getView().findViewById(R.id.tv_count)).setText(Html.fromHtml("你还有<font color='#eb4e4e'>" + bean.getResult().getUn_salary_tpl() + "笔</font>点工的工资标准未设置金额"));
                        } else {
                            getView().findViewById(R.id.lin_unset).setVisibility(View.GONE);
                        }
                        balance_amount = bean.getResult().getBalance_amount();
                        ((TextView) getView().findViewById(R.id.tv_textview_wage)).setText(Utils.m2(bean.getResult().getBalance_amount()) + "");//未结工资数
                        getView().findViewById(R.id.rea_unAccountCountLayout).setVisibility(View.GONE);
                        if (isChangePerson) {
                            setRoleWage();
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                }
            }
        });
    }

    /**
     * 选择人之后设置显示内容
     */
    public void setRoleWage() {
        //设置补奖罚以及抹零金额为空
        ed_wage_subsidy.setText("");
        ed_wage_reward.setText("");
        ed_wage_fine.setText("");
        ed_wage_del.setText("");
        //重新计算金额
        getPrice();
        //剩余未结金额默认值
        tv_wage_supplus_unset.setText(Utils.m2(balance_amount));
        //本次结算金额
        tv_wage_wage.setText(Utils.m2(wage_wage));
        //剩余未结工资
        tv_wage_supplus_unset.setText(Utils.m2(income_all));
    }

    /**
     * 重新计算下列金额
     * 补奖罚合计金额
     * 本次结算金额
     * 剩余未结金额
     */
    public void getPrice() {
        //补贴金额
        Double wage_subsidy = getEditM(ed_wage_subsidy.getText().toString().trim());
        //奖励金额
        Double wage_reward = getEditM(ed_wage_reward.getText().toString().trim());
        //罚款金额
        Double wage_fine = getEditM(ed_wage_fine.getText().toString().trim());
        // 本次实付金额
        Double income_money = getEditM(ed_income_money.getText().toString().trim());
        //抹零金额
        Double wage_del = getEditM(ed_wage_del.getText().toString().trim());
//       补奖罚合计金额 = 补贴金额 + 奖励金额 - 罚款金额
        wage_all = wage_subsidy + wage_reward - wage_fine;
        //本次结算金额 = 本次实付金额（本次实收金额） + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额
        wage_wage = income_money + wage_del + wage_fine - wage_subsidy - wage_reward;
        //剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额,
        income_all = balance_amount + wage_subsidy + wage_reward - wage_fine - income_money - wage_del;
    }

    /**
     * 返回上级页面
     */

    public void finishAct() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString("typeMsg", "bill");
//        bundle.putString("record_id", record_id);
        intent.putExtras(bundle);
        getActivity().setResult(Constance.DISPOSEATTEND_RESULTCODE, intent);
        getActivity().finish();
    }

    @Override
    public void cancelAccountClick() {
        finishAct();
    }

    @Override
    public void successAccountClick() {
        isFulsh = true;
        initVisible(View.GONE);
//        //再计一笔需要清空内容
        personBean = null;
        tv_role.setText("");
        if (imageItems != null && imageItems.size() > 0) {
            imageItems = null;
        }
        remark = "";


        voicePath = null;
        voiceLength = 0;

        date_srr = getActivity().getIntent().getStringExtra(Constance.DATE);
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
        tv_date.setText(date_srr);

        uid = -1;
        pid = 0;
        balance_amount = 0.0;
        //剩余未结工资,本次结算金额
        tv_wage_supplus_unset.setText("");
        tv_wage_wage.setText("");
        ed_wage_subsidy.setText("");
        ed_wage_reward.setText("");
        ed_wage_fine.setText("");
        ed_income_money.setText("");
        ed_wage_del.setText("");
        tv_remarks.setText("");
        tv_proname.setText("");
        stopWaitConfirmAnim();
        getView().findViewById(R.id.rea_unAccountCountLayout).setVisibility(View.GONE);
        getView().findViewById(R.id.lin_unset).setVisibility(View.GONE);
        setMsgText();
    }


}
