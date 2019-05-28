package com.jizhi.jlongg.account;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddAccountPersonActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RemarksActivity;
import com.jizhi.jlongg.main.activity.AddAccountPersonMultipartActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.adpter.AccountFrgmentsAdapter;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AccountProjectId;
import com.jizhi.jlongg.main.bean.AccountSendSuccess;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.bean.status.CommonJson;
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
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CustomListView;
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
 * 功能:借支
 * 时间:2017/2/14 20.08
 * 作者:hcs
 */

public class BorrowWorkFragment extends AccountFragment implements AccountFrgmentsAdapter.AccountOnItemClickLitener, DiaLogRecordSuccess.AccountSuccessListenerClick {
    /* 选择与我相关项目的WheelView */
    public WheelViewAboutMyProject addProject;
    /* 语音路径*/
    protected String voicePath;
    /* 语音长度*/
    protected int voiceLength;
    /* 图片数据*/
    protected List<ImageItem> imageItems;
    //选择对象列表数据
    protected PersonBean personBean;
    //记账对象ID
    protected int uid;
    //借支数据
    protected List<AccountBean> itemData;
    //借支金额
    private String sunmonery;
    /* 记账成功对话框 */
    private DiaLogRecordSuccess diaLogRecordSuccess;
    /* 记账成功id */
    public String record;
    /*备注 */
    private String remark;
    /*选择多个的记账对象*/
    protected ArrayList<PersonBean> selecteLis;

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
        listView = (CustomListView) getView().findViewById(R.id.listView);
        itemData = getBorrowData(((NewAccountActivity) getActivity()).roleType, getActivity().getIntent().getStringExtra(Constance.DATE));
        adapter = new AccountFrgmentsAdapter(getActivity(), itemData);
        listView.setAdapter(adapter);
        adapter.setAccountOnItemClickLitener(this);
        getView().findViewById(R.id.save).setOnClickListener(savaClickListener);
        setMsgText();
    }


    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param decimal_place
     */
    public void setEditTextDecimalNumberLength(EditText editText, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(6, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }

    }

    /**
     * 是否是聊天跳转过来的记账
     */
    public void setMsgText() {
//        if (((NewAccountActivity) getActivity()).isMsgAccount && null != ((NewAccountActivity) getActivity()).getAgency_group_user() && !TextUtils.isEmpty(((NewAccountActivity) getActivity()).getAgency_group_user().getUid())) {
        if (!((NewAccountActivity) getActivity()).isMsgAccount) {
            return;
        }
        if (((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            //创建者默认为工头 记账对象可选，所在项目不可选
            pid = ((NewAccountActivity) getActivity()).msgPid;
            itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setRight_value(((NewAccountActivity) getActivity()).proName);
            itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setText_color(R.color.color_999999);
            itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setClick(false);
            itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setShowArrow(false);
        } else {
            //创建者默认为工人 记账对象不可选，所在项目可选
            personBean = (PersonBean) getActivity().getIntent().getSerializableExtra("person"); //聊天记账对象
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setRight_value(personBean.getName());
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setText_color(R.color.color_999999);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setShowArrow(false);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_ROLE)).setClick(false);
            uid = null == personBean ? -1 : personBean.getUid();
            LastRecordInfo();
        }
        adapter.notifyDataSetChanged();
    }
    /**
     * 跳转到其他页面，取消动画
     */
    public void FlashingCancel(){
        if (adapter!=null){
            adapter.FlashingCancel(false);
        }
    }
    /**
     * 设置工人名称
     *
     * @param personName
     */
    public void setPersonName(String personName) {
        FlashingCancel();
        itemData.get(getPosion(itemData, RecordItem.SELECTED_ROLE)).setRight_value(personName);
        adapter.notifyDataSetChanged();
//        getUnPaySalaryList(uid + "");
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
        if (position != 0 && TextUtils.isEmpty(itemData.get(getPosion(itemData, RecordItem.SELECTED_ROLE)).getRight_value())) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            adapter.startFlashTips(true,getPosion(itemData, AccountBean.SELECTED_ROLE));
            return;
        }
        String type = itemData.get(position).getItem_type();
        if (type.equals(RecordItem.SELECTED_ROLE)) {
            if (((NewAccountActivity) getActivity()).isMsgAccount && ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
                AddAccountPersonMultipartActivity.actionStart(getActivity(), getActivity().getIntent().getStringExtra(Constance.GROUP_NAME), getActivity().getIntent().getStringExtra(Constance.GROUP_ID), selecteLis);
            } else {
                AddAccountPersonActivity.actionStart(getActivity(), uid + "", getActivity().getIntent().getStringExtra(Constance.GROUP_ID), AccountUtil.BORROWING_INT, 0);
            }


        } else if (type.equals(RecordItem.SELECTED_PROJECT)) {
            //与我相关的项目
//            recordProject();
            SelecteProjectActivity.actionStart(getActivity(), pid == 0 ? null : pid + "");
        } else if (type.equals(RecordItem.RECORD_REMARK)) {
            //备注
            RemarksActivity.actionStart(getActivity(), remark, imageItems);
        } else if (type.equals(RecordItem.SELECTED_DATE)) {
            setTime();
        }
    }

    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (TextUtils.isEmpty(getItemValue(RecordItem.SELECTED_ROLE))) {
            //CommonMethod.makeNoticeShort(getContext(), getString(R.string.please_select_record_object), CommonMethod.ERROR);
            adapter.startFlashTips(true,getPosion(itemData, AccountBean.SELECTED_ROLE));
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
                    BorrowWorkFragment.super.year =
                            BorrowWorkFragment.super.year = intYear;
                    BorrowWorkFragment.super.month = intMonth;
                    BorrowWorkFragment.super.day = intDay;

                    String selectDate = intYear + "-" + (BorrowWorkFragment.super.month < 10 ? "0" + month : month + "") + "-" + (BorrowWorkFragment.super.day < 10 ? "0" + day : day + "");
                    if (getTodayDate().trim().equals(selectDate.trim())) {
                        selectDate = selectDate + " (今天)";
                    }
                    itemData.get(getPosion(itemData, AccountBean.SELECTED_DATE)).setRight_value(selectDate);
                    adapter.notifyDataSetChanged();
//                    getUnPaySalaryList(uid + "");
                }
            }, year, month, day);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(getActivity().findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
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

    /**
     * listViewItem-EditView context
     */
    @Override
    public void EditTextWatchListener(String itemType, String str) {
        if (itemType.equals(RecordItem.SUM_MONEY)) {//借支金额
            itemData.get(getPosion(itemData, RecordItem.SUM_MONEY)).setRight_value(str);
            if (TextUtils.isEmpty(str)) {
                itemData.get(getPosion(itemData, RecordItem.SUM_MONEY)).setRight_value("");
                sunmonery = str;
//                itemData.get(getPosion(itemData, AccountBean.SUM_MONEY)).setRight_value("0.00");
                return;
            } else {
                sunmonery = str;
                itemData.get(getPosion(itemData, AccountBean.SUM_MONEY)).setRight_value(sunmonery);
            }
        }
    }

    @Override
    public void goToRecordWorkConfirm(int positon) {
        RecordWorkConfirmActivity.actionStart(getActivity(), year + "-" + month + "-" + day, uid + "", AccountUtil.BORROWING);
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
        LUtils.e("----------------" + currentProIndex);
        if (addProject == null) {
            addProject = new WheelViewAboutMyProject(getActivity(), projectList, true, pid);
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

    @Override
    public void LastRecordInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("uid", String.valueOf(uid));
        params.addBodyParameter("accounts_type", AccountUtil.BORROWING);

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
                            itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setRight_value(base.getValues().getPro_name());
                        } else {
                            pid = 0;
                            if (getActivity().getIntent().getBooleanExtra(Constance.ISMSGBILL, false)) {
                                itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setRight_value(((NewAccountActivity) getActivity()).proName);
                            } else {
                                itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).setRight_value("");
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
                adapter.startFlashTips(true,getPosion(itemData, AccountBean.SELECTED_ROLE));
                return;
            }
            String m = itemData.get(getPosion(itemData, AccountBean.SUM_MONEY)).getRight_value();
            if (TextUtils.isEmpty(m) || m.equals("0.00") ||m.equals(".") || Double.parseDouble(m) == 0) {
                //CommonMethod.makeNoticeShort(getActivity(), "请输入借支金额", CommonMethod.ERROR);
                adapter.startFlashTips(true,getPosion(itemData, AccountBean.SUM_MONEY));
                return;
            }
            FileUpData();
        }
    };
    RequestParams params;

    public AccountInfoBean setBeanParamter() {
        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");

        AccountInfoBean infoBean = new AccountInfoBean();
        /** 记账类型 1、点工  2、包工  3、总包 */
        infoBean.setAccounts_type(AccountUtil.BORROWING);
        /** 借支金额 */
        infoBean.setSalary(sunmonery);
        /** 提交时间 */
        infoBean.setDate(submitDate);
        /** 项目名称 */
        infoBean.setPro_name(TextUtils.isEmpty(itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).getRight_value()) ? "" : itemData.get(getPosion(itemData, RecordItem.SELECTED_PROJECT)).getRight_value());
        /** 项目id */
        infoBean.setPid(pid == 0 ? "0" : pid + "");
        if (!TextUtils.isEmpty(remark)) {
            /** 备注描述 */
            infoBean.setText(TextUtils.isEmpty(remark) ? "" : remark);
        }
        return infoBean;

    }

    public void FileUpData() {
        ((BaseActivity) getActivity()).createCustomDialog();
        params = RequestParamsToken.getExpandRequestParams(getActivity());
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();

        if (((NewAccountActivity) getActivity()).isMsgAccount && ((NewAccountActivity) getActivity()).roleType.equals(Constance.ROLETYPE_FM)) {
            for (int i = 0; i < selecteLis.size(); i++) {
                AccountInfoBean infoBean = setBeanParamter();
                /** 用户id */
                infoBean.setUid(selecteLis.get(i).getUid() + "");
                /** 记账对象名称 */
                infoBean.setName(selecteLis.get(i).getName());
                accountInfoBeanList.add(infoBean);
            }
        } else {
            AccountInfoBean infoBean = setBeanParamter();
            /** 用户id */
            infoBean.setUid(uid + "");
            /** 记账对象名称 */
            infoBean.setName(itemData.get(getPosion(itemData, RecordItem.SELECTED_ROLE)).getRight_value());
            accountInfoBeanList.add(infoBean);
        }


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
                LUtils.e(new Gson().toJson(imageItems + ",,,,,,,,,,,,,,,,,,,,"));
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
                        record = base.getResult().getRecord_id();
                        //发布成功对话框
                        if (diaLogRecordSuccess == null) {
                            diaLogRecordSuccess = new DiaLogRecordSuccess(getContext(), BorrowWorkFragment.this, ((NewAccountActivity) getActivity()).roleType);
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
//        //再计一笔需要清空内容
        personBean = null;

        if (imageItems != null && imageItems.size() > 0) {
            imageItems = null;
        }
        voicePath = null;
        voiceLength = 0;
        uid = -1;
        pid = 0;
        itemData = getBorrowData(((NewAccountActivity) getActivity()).roleType, getActivity().getIntent().getStringExtra(Constance.DATE));

        setMsgText();
        adapter = new AccountFrgmentsAdapter(getActivity(), itemData);
        listView.setAdapter(adapter);
        adapter.setAccountOnItemClickLitener(this);
        itemData.get(getPosion(itemData, AccountBean.SUM_MONEY)).setRight_value("");
        setMsgText();
//        ((NewAccountActivity) getActivity()). (tv_price, "0.00");
    }
}
