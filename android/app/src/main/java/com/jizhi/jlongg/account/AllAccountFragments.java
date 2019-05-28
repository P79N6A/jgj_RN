package com.jizhi.jlongg.account;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SimpleItemAnimator;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AccountUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddAccountPersonActivity;
import com.jizhi.jlongg.main.activity.AddSubProjectActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.adpter.NewAllAccountAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AccountProjectId;
import com.jizhi.jlongg.main.bean.AccountSendSuccess;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogHintCreateTeam;
import com.jizhi.jlongg.main.dialog.DiaLogHourWork;
import com.jizhi.jlongg.main.dialog.DiaLogRecordSuccess;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.WheelGridViewWorkTime;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
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


/**
 * 功能:包工记账
 * 时间:2017/2/14 20.08
 * 作者:hcs
 */

public class AllAccountFragments extends AccountFragment implements DiaLogRecordSuccess.AccountSuccessListenerClick, NewAllAccountAdapter.AllAccountListener {
    //记账成功对话框
    private DiaLogRecordSuccess diaLogRecordSuccess;
    //记账时间弹窗
    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;
    //分项view
    private RecyclerView listView;
    //日期字符串
    private String date_str;
    //分项适配器
    public NewAllAccountAdapter allAccountAdapter;
    private LinearLayoutManager linearLayoutManager;
    private String roleType;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.account_allaccount_fragment_new, container, false);
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
        roleType = ((NewAccountActivity) getActivity()).roleType;
        listView = getView().findViewById(R.id.listView);
        listView.setItemViewCacheSize(200);
        List<AccountAllWorkBean> accountAllWorkBean = new ArrayList<>();
        accountAllWorkBean.add(0, new AccountAllWorkBean(roleType.equals(Constance.ROLETYPE_FM) ? NewAllAccountAdapter.TYPE_HEADER_FORMAN : NewAllAccountAdapter.TYPE_HEADER_WORKER));
        AccountAllWorkBean bean = new AccountAllWorkBean();
        accountAllWorkBean.add(bean);
        accountAllWorkBean.add(accountAllWorkBean.size(), new AccountAllWorkBean(NewAllAccountAdapter.TYPE_FOTTER));
        date_str = getActivity().getIntent().getStringExtra(Constance.DATE);
        //日期
        if (!TextUtils.isEmpty(date_str)) {
            try {
                setData(date_str);
            } catch (Exception e) {
            }

        } else {
            getTodayTime();
        }
        date_str = year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "");
        if (getTodayDate().trim().equals(date_str.trim())) {
            date_str = date_str + " (今天)";
        }
        accountAllWorkBean.get(0).setDate(date_str);
        linearLayoutManager = new LinearLayoutManager(getActivity(), LinearLayoutManager.VERTICAL, false);
        //初始化空列表数据
        listView.setLayoutManager(linearLayoutManager);
        ((SimpleItemAnimator) listView.getItemAnimator()).setSupportsChangeAnimations(false);
        listView.setItemAnimator(null);
        allAccountAdapter = new NewAllAccountAdapter(getActivity(), accountAllWorkBean, this, roleType);
        listView.setAdapter(allAccountAdapter);
        getView().findViewById(R.id.save).setOnClickListener(savaClickListener);
        setMsgText();
        //读取上次是分包还是承包
        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            int contractor_type = (int) SPUtils.get(getActivity(), "contractor_type", 1, Constance.ACCOUNT_FORMAN_HISTORT);
            allAccountAdapter.getList().get(0).setContractor_type(contractor_type);
            allAccountAdapter.notifyDataSetChanged();
        }
    }


    /**
     * 是否是聊天跳转过来的记账
     */
    public void setMsgText() {
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            //非聊天跳转过来的记账，如果是工人读取本地记账信息
            boolean isWorker = ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false;
            String accountType = (String) SPUtils.get(getActivity(), "account_type", AccountUtil.HOUR_WORKER, isWorker ? Constance.ACCOUNT_WORKER_HISTORT : Constance.ACCOUNT_FORMAN_HISTORT);
            if (accountType.equals(AccountUtil.CONSTRACTOR) && isWorker) {
                //包工记账
                PersonBean bean = AccountUtils.getWorerInfo(getActivity(), isWorker);
                if (null != bean && bean.getUid() != 0) {
                    setPersonInfo(bean);
                    LastRecordInfo();

                }
            }
            return;
        }

        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            pid = ((NewAccountActivity) getActivity()).msgPid;
            allAccountAdapter.getList().get(0).setPro_name(((NewAccountActivity) getActivity()).proName);
            allAccountAdapter.getList().get(0).setPid(((NewAccountActivity) getActivity()).msgPid);
            allAccountAdapter.getList().get(0).setHintProjectArrow(true);
            allAccountAdapter.getList().get(0).setClickProject(true);
            allAccountAdapter.getList().get(0).setTOMsgFM(true);
        } else {
            //创建者默认为工人 记账对象不可选，所在项目可选
            PersonBean personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
            allAccountAdapter.getList().get(0).setRoleName(personBean.getName());
            allAccountAdapter.getList().get(0).setUid(personBean.getUid());
            allAccountAdapter.getList().get(0).setHintRoleArrow(true);
            allAccountAdapter.getList().get(0).setClickRole(true);
            allAccountAdapter.getList().get(0).setTOMsgFM(false);

            LastRecordInfo();


        }
    }

    /**
     * 跳转到其他页面，取消动画
     */
    public void FlashingCancel(){
        if (allAccountAdapter!=null){
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                allAccountAdapter.startFlashTips(false,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                allAccountAdapter.startFlashTips(false,2);
            }
            else {
                allAccountAdapter.startFlashTips(false,0);
            }
        }
    }
    /**
     * 记账时间弹窗
     */
    public void setTime() {
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(getActivity(), getString(R.string.choosetime), 2, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
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
                    AllAccountFragments.super.year =
                            AllAccountFragments.super.year = intYear;
                    AllAccountFragments.super.month = intMonth;
                    AllAccountFragments.super.day = intDay;
                    String selectDate = intYear + "-" + (AllAccountFragments.super.month < 10 ? "0" + month : month + "") + "-" + (AllAccountFragments.super.day < 10 ? "0" + day : day + "");
                    if (getTodayDate().trim().equals(selectDate.trim())) {
                        selectDate = selectDate + " (今天)";
                    }
                    allAccountAdapter.getList().get(0).setDate(selectDate);
                    allAccountAdapter.notifyItemChanged(0);

                }
            }, year, month, day);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }

    /**
     * 设置备注信息
     *
     * @param imageItems    图片数据
     * @param startWorkTime 上班时间
     * @param endWorkTime   加班时间
     * @param remark        备注文字
     */
    public void setRemarkDesc(List<ImageItem> imageItems, int startWorkTime, int endWorkTime, String remark) {
        allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).setImageItems(imageItems);
        allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).setStartWorkTime(startWorkTime);
        allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).setEndWorkTime(endWorkTime);
        allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).setRemark(remark);
        allAccountAdapter.notifyItemChanged(allAccountAdapter.getList().size() - 1);

    }

    /**
     * 设置新的记账对象
     *
     * @param personBean
     */
    public void setPersonInfo(PersonBean personBean) {
//        LUtils.e(personBean.getUid() + ",,," + ((NewAccountActivity) getActivity()).getCreate_group_uid());
        String pro_name = allAccountAdapter.getList().get(0).getPro_name();
        int pid = allAccountAdapter.getList().get(0).getPid();
        //4.0.2选中记账对象，关闭动画
        if (personBean.getName()!=null&&
                !TextUtils.isEmpty(personBean.getName())){
            LUtils.e("======="+personBean.getName());
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                allAccountAdapter.startFlashTips(false,2);
            } else {
                allAccountAdapter.startFlashTips(false,0);
            }
        }
        //聊天跳转过来的记账,工头身份
        if (((NewAccountActivity) getActivity()).isMsgAccount && roleType.equals(Constance.ROLETYPE_FM) && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getCreate_group_uid()) && (((NewAccountActivity) getActivity()).getCreate_group_uid()).equals(String.valueOf(personBean.getUid()))) {
            // 如果是代班长，并且代班长的uid等于选择的uid
            allAccountAdapter.getList().get(0).setRoleName("");
            allAccountAdapter.getList().get(0).setUid(0);
            allAccountAdapter.notifyDataSetChanged();
            CommonMethod.makeNoticeShort(getActivity(), "不能选择班组长", false);
            return;
        }
        int contractor_type = allAccountAdapter.getList().get(0).getContractor_type();
        if (allAccountAdapter.getList().get(0).getUid() != personBean.getUid()) {
            successAccountClick();
            allAccountAdapter.getList().get(0).setPid(pid);
            allAccountAdapter.getList().get(0).setPro_name(pro_name);
            allAccountAdapter.notifyDataSetChanged();

        }
        if (!((NewAccountActivity) getActivity()).isMsgAccount && UclientApplication.getUid(getActivity()).equals(String.valueOf(personBean.getUid())) && roleType.equals(Constance.ROLETYPE_FM) && contractor_type == 2) {
            allAccountAdapter.getList().get(0).setContractor_type(1);
            CommonMethod.makeNoticeShort(getActivity(), "自己对自己记账只能选择承包", false);
        } else {
            allAccountAdapter.getList().get(0).setContractor_type(contractor_type);

        }

        // 刷新记账对象名字
        allAccountAdapter.getList().get(0).setRoleName(personBean.getName());
        allAccountAdapter.getList().get(0).setUid(personBean.getUid());
        allAccountAdapter.notifyItemChanged(0);
        LUtils.e(roleType.equals(Constance.ROLETYPE_FM) + "-----B-----contractor_type-----" + allAccountAdapter.getList().get(0).getContractor_type());

//        //查询最后一次记账项目名字，聊天跳转的不查询
//        if (personBean.getUid() != -1 && !getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
//            LastRecordInfo();
//        }

        if (!((NewAccountActivity) getActivity()).isMsgAccount && roleType.equals(Constance.ROLETYPE_WORKER)) {
            //非聊天跳转过来的记账，如果是工人读取本地记账信息
            LastRecordInfo();
        }
    }

    /**
     * 设置项目信息
     *
     * @param pid
     * @param proname
     */
    public void setProInfo(int pid, String proname) {
        this.pid = pid;
        allAccountAdapter.getList().get(0).setPid(pid);
        allAccountAdapter.getList().get(0).setPro_name(pid != 0 ? proname : " ");
        allAccountAdapter.notifyItemChanged(0);

    }

    //设置当前日期（由前一个界面传过来的）
    public void setData(String dataintent) {//dataintent:20150106
        year = Integer.valueOf(dataintent.substring(0, 4));
        month = Integer.valueOf(dataintent.substring(4, 6));
        day = Integer.valueOf(dataintent.substring(6, 8));

    }


    /**
     * 设置分项名称
     */
    public void setSubProName(AccountAllWorkBean bean, int position) {
        allAccountAdapter.getList().set(position, bean);
        allAccountAdapter.notifyItemChanged(position);
    }


    @Override
    public void addSubProject(int position) {
        hideSoftKeyboard();
        if (Utils.isFastDoubleClick()) {
            return;
        }
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
        if (allAccountAdapter.getList().size() >= 12) {
            CommonMethod.makeNoticeShort(getContext(), "你已经添加10个分项了，不能再添加啦", CommonMethod.ERROR);
            return;
        }
        allAccountAdapter.getList().add(allAccountAdapter.getList().size() - 1, new AccountAllWorkBean());
        allAccountAdapter.notifyDataSetChanged();
        LUtils.e("--------添加的内容-----" + new Gson().toJson(allAccountAdapter.getList()));
    }

    @Override
    public void modifyAccountType(int type) {
        LUtils.e("-----111-----");
        /**
         * fix bug :Cannot call this method while RecyclerView is computing a layout or scrolling
         * {@link com.jizhi.jlongg.main.activity.MultiPersonBatchAccountNewActivity#onClick(View)}
         * 我要记单笔，进入后就会触发这个方法，出现recycleView的错误。
         */
        if (listView.getScrollState() == RecyclerView.SCROLL_STATE_IDLE && (!listView.isComputingLayout())) {
                 allAccountAdapter.startFlashTips(false,2);
        }else {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    allAccountAdapter.startFlashTips(false,2);
                }
            },300);
        }
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            String pro_name = allAccountAdapter.getList().get(0).getPro_name();
            int pid = allAccountAdapter.getList().get(0).getPid();
            successAccountClick();
            allAccountAdapter.getList().get(0).setPid(pid);
            allAccountAdapter.getList().get(0).setPro_name(pro_name);
            allAccountAdapter.getList().get(0).setContractor_type(type);
            allAccountAdapter.notifyDataSetChanged();
        }

    }

    @Override
    public void inputPrice() {
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
    }

    @Override
    public void inputNum() {
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
    }

    /**
     * 删除分享
     *
     * @param positon
     */
    @Override
    public void deleteSubProject(final int positon) {
        if (allAccountAdapter.getList().size() <= 3) {
            return;
        }
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(getActivity(), null, "你确定要删除该分项吗？", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {

            }

            @Override
            public void clickRightBtnCallBack() {
                CommonMethod.makeNoticeLong(getActivity(), "分项删除成功", true);
                allAccountAdapter.getList().remove(positon);
                allAccountAdapter.notifyDataSetChanged();
//                allAccountAdapter.setList(allAccountAdapter.getList());
            }
        });
        dialogLeftRightBtnConfirm.show();
    }

    /**
     * 添加分项名称
     *
     * @param positon
     */
    @Override
    public void selectSubProject(final int positon) {
        //记账日期
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
        AddSubProjectActivity.actionStart(getActivity(), allAccountAdapter.getList().get(positon), positon);
    }

    /**
     * 选中单位
     *
     * @param position
     */
    @Override
    public void selectCompany(final int position) {
        hideSoftKeyboard();
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            LUtils.e(allAccountAdapter.getList().get(0).getContractor_type() + "------roleType--------" + roleType);
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);

            }
            return;
        }
        final List<WorkTime> companyList = DataUtil.getAccountCompanyList(getActivity(), null == allAccountAdapter.getList().get(position).getUnits() ? "" : allAccountAdapter.getList().get(position).getUnits());
        WheelGridViewWorkTime selectCompanyDialog = new WheelGridViewWorkTime(getActivity(), companyList, "选择单位", 0);
        selectCompanyDialog.setListener(new WheelGridViewWorkTime.WorkTimeListener() {
            @Override
            public void workTimeClick(String scrollContent, int postion, String workUtil) {
                allAccountAdapter.getList().get(position).setUnits(companyList.get(postion).getWorkName());
                allAccountAdapter.notifyItemChanged(position);
                LUtils.e("-------companyList.get(postion).getWorkName(----" + companyList.get(postion).getWorkName());
            }
        });
        //显示窗口
        selectCompanyDialog.showAtLocation(getActivity().getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }

    /**
     * 选中记账对象
     */
    @Override
    public void selectRole(int position) {
        LUtils.e("------getContractor_type----" + (roleType.equals(Constance.ROLETYPE_FM) ? allAccountAdapter.getList().get(0).getContractor_type() : 0))
        ;
        //选中记账对象
        AddAccountPersonActivity.actionStart(getActivity(), allAccountAdapter.getList().get(0).getUid() + "", getActivity().getIntent().getStringExtra(Constance.GROUP_ID),
                AccountUtil.CONSTRACTOR_INT, roleType.equals(Constance.ROLETYPE_FM) ? allAccountAdapter.getList().get(0).getContractor_type() : 0);
//        roleType.equals(Constance.ROLETYPE_FM)
    }

    /**
     * 选中项目
     */
    @Override
    public void selectProject(int position) {
        //记账日期
        //选中项目
        if (((NewAccountActivity) getActivity()).isMsgAccount && null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
            return;
        }
        SelecteProjectActivity.actionStart(getActivity(), allAccountAdapter.getList().get(0).getPid() == 0 ? null : allAccountAdapter.getList().get(0).getPid() + "");
    }

    /**
     * 选中日期
     */
    @Override
    public void selectDate(int position) {
        //记账日期
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
        setTime();
    }

    /**
     * 设置备注
     */
    @Override
    public void selectRemark(int position) {
        //记账日期
        if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
            if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2) {
                //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,2);
            }
            else {
                //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                allAccountAdapter.startFlashTips(true,0);
            }
            return;
        }
        RemarksActivity.actionStart(getActivity(), allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getRemark(), allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getImageItems(), allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getStartWorkTime(), allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getEndWorkTime(), 1);

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

    @Override
    public void LastRecordInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", String.valueOf(allAccountAdapter.getList().get(0).getUid()));
        params.addBodyParameter("accounts_type", AccountUtil.CONSTRACTOR);
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
                            allAccountAdapter.getList().get(0).setPid(base.getValues().getPid());
                            allAccountAdapter.getList().get(0).setPro_name(base.getValues().getPro_name());
                            allAccountAdapter.notifyItemChanged(0);
                        } else {
                            pid = 0;
                            if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                                allAccountAdapter.getList().get(0).setPro_name(((NewAccountActivity) getActivity()).proName);
                            } else {
                                allAccountAdapter.getList().get(0).setPro_name("");
                            }
                            allAccountAdapter.notifyItemChanged(0);

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
            if (TextUtils.isEmpty(allAccountAdapter.getList().get(0).getRoleName())) {
                if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 1) {
                    //CommonMethod.makeNoticeShort(getContext(), "请先选择承包对象", CommonMethod.ERROR);
                    allAccountAdapter.startFlashTips(true,2);
                } else if (roleType.equals(Constance.ROLETYPE_FM) && allAccountAdapter.getList().get(0).getContractor_type() == 2){
                    allAccountAdapter.startFlashTips(true,2);
                }
                else {
                    //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
                    allAccountAdapter.startFlashTips(true,0);
                }
                return;
            }
            for (int i = 1; i < allAccountAdapter.getList().size() - 1; i++) {
                String perPricesStr = allAccountAdapter.getList().get(i).getSet_unitprice();
                String countSumStr = allAccountAdapter.getList().get(i).getSub_count();

                if (TextUtils.isEmpty(perPricesStr)) {
                    CommonMethod.makeNoticeShort(getActivity(), "请填写单价", CommonMethod.ERROR);
                    //allAccountAdapter.startFlashTips(true,1);
                    LUtils.e(perPricesStr + ",,cccc," + countSumStr);
                    return;
                }
                if (TextUtils.isEmpty(perPricesStr) || TextUtils.isEmpty(countSumStr)) {
                    CommonMethod.makeNoticeShort(getActivity(), "请填写数量", CommonMethod.ERROR);
                    LUtils.e(perPricesStr + ",,cccc," + countSumStr);
                    return;
                }
                String m = allAccountAdapter.getList().get(i).getPrice();
                if (TextUtils.isEmpty(m) || m.equals("0.00")) {
                    LUtils.e(m + ",,cccccc,");
                    CommonMethod.makeNoticeShort(getActivity(), "请输入正确的单价和数量", CommonMethod.ERROR);
                    return;
                }
            }
            FileUpData();

        }
    };

    public AccountInfoBean setBeanParamter() {
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");

        AccountInfoBean infoBean = new AccountInfoBean();
        /** 包工记账 */
        infoBean.setAccounts_type(AccountUtil.CONSTRACTOR);
        /** 用户id */
        infoBean.setUid(String.valueOf(allAccountAdapter.getList().get(0).getUid()));
        /** 记账对象名称 */
        infoBean.setName(allAccountAdapter.getList().get(0).getRoleName());
        /** 提交时间 */
        infoBean.setDate(submitDate);
        /** 项目id */
        infoBean.setPid(allAccountAdapter.getList().get(0).getPid() == 0 ? "0" : String.valueOf(allAccountAdapter.getList().get(0).getPid()));
        /** 项目名称 */
        infoBean.setPro_name(TextUtils.isEmpty(allAccountAdapter.getList().get(0).getPro_name()) ? "" : allAccountAdapter.getList().get(0).getPro_name());
        /** 开工时间 */
        infoBean.setP_s_time(allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getStartWorkTime() == 0 ? "" : allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getStartWorkTime() + "");
        /** 完工时间 */
        infoBean.setP_e_time(allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getEndWorkTime() == 0 ? "" : allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getEndWorkTime() + "");
        /** 备注描述 */
        infoBean.setText(TextUtils.isEmpty(allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getRemark()) ? "" : allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getRemark());
        return infoBean;

    }

    RequestParams params;

    public void FileUpData() {
        LUtils.e(new Gson().toJson(allAccountAdapter.getList()));
        ((BaseActivity) getActivity()).createCustomDialog();
        params = RequestParamsToken.getExpandRequestParams(getActivity());
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        for (int i = 1; i < allAccountAdapter.getList().size() - 1; i++) {
            AccountInfoBean infoBean = setBeanParamter();
            /** 分项名称 */
            infoBean.setSub_pro_name(TextUtils.isEmpty(allAccountAdapter.getList().get(i).getSub_pro_name()) ? "" : allAccountAdapter.getList().get(i).getSub_pro_name().trim());
            /** 单价 */
            infoBean.setUnit_price(TextUtils.isEmpty(allAccountAdapter.getList().get(i).getSet_unitprice()) ? "" : allAccountAdapter.getList().get(i).getSet_unitprice());
            /** 数量 */
            infoBean.setQuantity(TextUtils.isEmpty(allAccountAdapter.getList().get(i).getSub_count()) ? "" : allAccountAdapter.getList().get(i).getSub_count());
            /** 数量单位 */
            infoBean.setUnits(allAccountAdapter.getList().get(i).getUnits());
            /** 总金额 */
            infoBean.setSalary(allAccountAdapter.getList().get(i).getPrice());
            /** 分项id */
            infoBean.setTpl_id(allAccountAdapter.getList().get(i).getId());
            accountInfoBeanList.add(infoBean);
        }


        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList));
        params.addBodyParameter("contractor_type", String.valueOf(allAccountAdapter.getList().get(0).getContractor_type()));
        LUtils.e("---11----getContractor_type-----" + allAccountAdapter.getList().get(0).getContractor_type());

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
                //包工记账
                if (null != allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getImageItems() && allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getImageItems().size() > 0) {
                    if (tempPhoto == null) {
                        tempPhoto = new ArrayList<>();
                    }
                    for (int i = 0; i < allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getImageItems().size(); i++) {
                        tempPhoto.add(allAccountAdapter.getList().get(allAccountAdapter.getList().size() - 1).getImageItems().get(i).imagePath.trim());
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
                        //读取上次是分包还是承包
                        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
                            SPUtils.put(getActivity(), "contractor_type", allAccountAdapter.getList().get(0).getContractor_type(), Constance.ACCOUNT_FORMAN_HISTORT);
                            LUtils.e("---22----getContractor_type-----" + allAccountAdapter.getList().get(0).getContractor_type());
                        }


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
                        String name = allAccountAdapter.getList().get(0).getRoleName();
                        AccountUtils.saveWorerInfo(getActivity(), AccountUtil.CONSTRACTOR, allAccountAdapter.getList().get(0).getUid(), name, ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_WORKER) ? true : false);
                        //发布成功对话框
                        if (diaLogRecordSuccess == null) {
                            diaLogRecordSuccess = new DiaLogRecordSuccess(getContext(), AllAccountFragments.this, ((NewAccountActivity) getActivity()).roleType);
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
        String group_name = allAccountAdapter.getList().get(0).getPro_name();
        String text = "如果你对[" + group_name + "]项目新建一个班组，添加成员后，就可以对所有工人批量记工了。\n新建班组吗？";
        new DiaLogHintCreateTeam(getActivity(), text, group_name, pid, new DiaLogHintCreateTeam.CloseDialogListener() {
            @Override
            public void closeDialogClick() {
                successAccountClick();
            }
        }).show();
    }

    //
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
     * 隐藏键盘
     */
    protected void hideSoftKeyboard() {
        if (getActivity().getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (getActivity().getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
    }

    /**
     * 返回上级页面
     */
    public void finishAct() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString("typeMsg", "bill");
//        bundle.putString("record_id", record);
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
        if (!TextUtils.isEmpty(deleteUid) && deleteUid.contains(String.valueOf(allAccountAdapter.getList().get(0).getUid()))) {
            successAccountClick();
        }

    }

    @Override
    public void successAccountClick() {
        //再计一笔需要清空内容

        List<AccountAllWorkBean> accountAllWorkBean = new ArrayList<>();
        accountAllWorkBean.add(0, new AccountAllWorkBean(roleType.equals(Constance.ROLETYPE_FM) ? NewAllAccountAdapter.TYPE_HEADER_FORMAN : NewAllAccountAdapter.TYPE_HEADER_WORKER));
        AccountAllWorkBean bean = new AccountAllWorkBean();
        accountAllWorkBean.add(bean);
        accountAllWorkBean.add(accountAllWorkBean.size(), new AccountAllWorkBean(NewAllAccountAdapter.TYPE_FOTTER));
        accountAllWorkBean.get(0).setDate(getDate());
        allAccountAdapter.setList(accountAllWorkBean);
        allAccountAdapter.notifyDataSetChanged();
        if (((NewAccountActivity) getActivity()).isMsgAccount) {
            setMsgText();
            if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
                allAccountAdapter.getList().get(0).setPid(pid);
            }
            allAccountAdapter.notifyDataSetChanged();

        }
    }

}
