package com.jizhi.jlongg.account;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.bigkoo.pickerview.TimePickerView;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.AccountSelectCompanyActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.activity.SalaryModeSettingActivity;
import com.jizhi.jlongg.main.activity.SelecteProjectActivity;
import com.jizhi.jlongg.main.adpter.AccountEditAdapter;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.WheelAccountTimeSelected;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.AccountData;
import com.jizhi.jlongg.main.util.AccountHttpUtils;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StringUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能:记账修改
 * 时间:2017/9/27 17:12
 * 作者:hcs
 */

public class AccountEditActivity extends BaseActivity implements View.OnClickListener, AccountPhotoGridAdapter.PhotoDeleteListener, AccountEditAdapter.AccountOnItemValueClickLitener, OnSquaredImageRemoveClick {
    private AccountEditActivity mActivity;
    private ListView listView;
    private AccountEditAdapter accountEditAdapter;
    /*记账类型，角色*/
    private String account_type, role_type;
    /*记账id*/
    private int account_id;
    /*列表数据*/
    protected List<AccountBean> itemData;
    /*记账数据*/
    private WorkDetail bean;
    /*角色，项目是否可以点击*/
    private boolean roleIsClick, projectIsClick;
    /* 薪资模板*/
    public List<ImageItem> photos;
    /* 薪资模板*/
    private Salary tpl;
    /*  项目列表数据 */
    public List<Project> projectList;
    /*  与我相关项目的WheelView */
    public WheelViewAboutMyProject projectWheelView;
    /*  备注 */
    public EditText ed_remark;
    /* 上班/加班时长WheelView */
    public WheelAccountTimeSelected workTimePopWindow, overTimePopWindow;
    /* 上班/加班时长数据 */
    private List<WorkTime> workTimeList, overTimeList;
    //是否修改过数据
    private boolean isChangedata;
    //借支金额
    private String amounts, str_remark;
    AgencyGroupUser agencyGroupUser;
    private DialogLeftRightBtnConfirm dialog;
    private int hour_type;
    private String overtime_salary_tpl;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account_edit);
        getIntentData();
        initView();
        initKeyBoardView();
        if (null != bean) {
            initData();
        } else {
            getDetailInfo();
        }
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        //记账类型
        account_type = getIntent().getStringExtra(Constance.BEAN_STRING);
        //记账id
        account_id = getIntent().getIntExtra(Constance.BEAN_INT, 0);
        role_type = getIntent().getStringExtra(Constance.ROLE);
        bean = (WorkDetail) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        agencyGroupUser = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE1);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, WorkDetail workDetail, String account_type, int account_id, String role_type, boolean isRecoedWork) {
        Intent intent = new Intent(context, AccountEditActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, workDetail);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_INT, account_id);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_BOOLEAN, isRecoedWork);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Acitivity
     *
     * @param context
     */
    public static void actionStart(Activity context, WorkDetail workDetail, String account_type, int account_id, String role_type, boolean isRecoedWork, AgencyGroupUser agencyGroupUser) {
        LUtils.e("------11---------" + role_type);
        Intent intent = new Intent(context, AccountEditActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, workDetail);
        intent.putExtra(Constance.ROLE, role_type);
        intent.putExtra(Constance.BEAN_INT, account_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, isRecoedWork);
        intent.putExtra(Constance.BEAN_STRING, account_type);
        intent.putExtra(Constance.BEAN_CONSTANCE1, agencyGroupUser);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 初始化键盘监听
     */
    public void initKeyBoardView() {
        rea_noticedetail = findViewById(R.id.main);
        //contentlayout是最外层布局
        mChildOfContent = rea_noticedetail.getChildAt(0);
        mChildOfContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                possiblyResizeChildOfContent();
            }
        });
    }

    private LinearLayout rea_noticedetail;
    private View mChildOfContent;
    private int usableHeightPrevious = 0;
    private boolean isShowKeyBoard;
    private String reply_uid;


    private void possiblyResizeChildOfContent() {
        int usableHeightNow = computeUsableHeight();
        if (usableHeightNow != usableHeightPrevious) {
            int usableHeightSansKeyboard = mChildOfContent.getRootView().getHeight();
            int heightDifference = usableHeightSansKeyboard - usableHeightNow;
            if (heightDifference > (usableHeightSansKeyboard / 4)) {
                // 键盘弹出
                isShowKeyBoard = true;
            } else {
                if (null != accountEditAdapter && account_type.equals(AccountUtil.CONSTRACTOR)) {
                    LUtils.e("------111A----" + bean.getSub_proname());
                    // 键盘收起
                    itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value(caluAllMonny());
                    accountEditAdapter.notifyDataSetChanged();
                }

            }
            mChildOfContent.requestLayout();
            usableHeightPrevious = usableHeightNow;
        }
    }

    private int computeUsableHeight() {
        Rect r = new Rect();
        mChildOfContent.getWindowVisibleDisplayFrame(r);
        return (r.bottom - r.top);
    }

    /**
     * 查询记账信息详情
     */

    private void getDetailInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("record_id", account_id + "");
        params.addBodyParameter("accounts_type", account_type + "");
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            params.addBodyParameter("role", role_type);
            params.addBodyParameter("is_confirm", "1");
        }
        if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id());
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.WORKDETAIL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<WorkDetail> status = CommonJson.fromJson(responseInfo.result, WorkDetail.class);
                    if (status.getMsg().equals(Constance.SUCCES_S)) {
                        if (status.getResult() != null) {
                            bean = status.getResult();
                            initData();

                        }
                    } else {
                        DataUtil.showErrOrMsg(mActivity, status.getErrno(), status.getErrmsg());
                        finish();
                    }
                    closeDialog();
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }

    /**
     * initView
     */
    public void initView() {
        mActivity = AccountEditActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        findViewById(R.id.btn_del).setOnClickListener(this);
        findViewById(R.id.btn_save).setOnClickListener(this);
        photos = new ArrayList<>();
        roleIsClick = false;
        projectIsClick = true;
        if (account_type.equals(AccountUtil.HOUR_WORKER)) {  //点工
            SetTitleName.setTitle(findViewById(R.id.title), "修改点工");
            itemData = AccountData.getAccountEditHour(mActivity, role_type, roleIsClick, projectIsClick);
        } else if (account_type.equals(AccountUtil.CONSTRACTOR)) {  //包工
            SetTitleName.setTitle(findViewById(R.id.title), "修改包工");
            itemData = AccountData.getAccountEditAll(mActivity, role_type);
        } else if (account_type.equals(AccountUtil.BORROWING)) {  //借支
            SetTitleName.setTitle(findViewById(R.id.title), "修改借支");
            itemData = AccountData.getAccountDetailBorrow(mActivity, role_type);
        } else if (account_type.equals(AccountUtil.SALARY_BALANCE)) {  //结算
            SetTitleName.setTitle(findViewById(R.id.title), "修改结算");
            itemData = AccountData.getAccountDetailBorrow(mActivity, role_type);
        } else if (account_type.equals(AccountUtil.CONSTRACTOR_CHECK)) {  //包工记工天
            SetTitleName.setTitle(findViewById(R.id.title), "修改包工记工天");
            itemData = AccountData.getAccountEdiAllCheck(mActivity, role_type, roleIsClick, projectIsClick);
        }
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setText_color(R.color.color_999999);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setClick(false);
            itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setShowArrow(false);
        }
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (itemData.get(position).getItem_type().equals(AccountBean.SELECTED_DATE)) {//时间-相同部分
                } else if (itemData.get(position).getItem_type().equals(AccountBean.ROLE_FM)) {//工头名称-相同部分
                } else if (itemData.get(position).getItem_type().equals(AccountBean.ROLE_WORKER)) {//工人名称-相同部分

                } else if (itemData.get(position).getItem_type().equals(AccountBean.SALARY_TOTAL)) {//金额-相同部分
                } else if (itemData.get(position).getItem_type().equals(AccountBean.SELECTED_PROJECT)) {//所在项目-相同部分
                    isChangedata = true;
//                    recordProject();
                    SelecteProjectActivity.actionStart(mActivity, bean.getPid() == 0 ? null : bean.getPid() + "");
                } else if (itemData.get(position).getItem_type().equals(AccountBean.WORK_TIME)) {//上班时间-点工
                    isChangedata = true;
                    workTimeSelect();
                } else if (itemData.get(position).getItem_type().equals(AccountBean.OVER_TIME)) {//加班时间-点工
                    isChangedata = true;
                    overTimeSelect();
                } else if (itemData.get(position).getItem_type().equals(AccountBean.ALL_MONEY)) {//点工工钱
                    dialog = new DialogLeftRightBtnConfirm(AccountEditActivity.this,
                            "点工工钱：是根据工资标准和上班加班时长计算的", "需要修改工资标准吗？",
                            new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                                @Override
                                public void clickLeftBtnCallBack() {
                                    dialog.dismiss();
                                }

                                @Override
                                public void clickRightBtnCallBack() {
                                    isChangedata = true;
                                    if (account_type.equals(AccountUtil.HOUR_WORKER)) {  //点工
                                        SalaryModeSettingActivity.actionStart(mActivity, tpl, Constance.ROLETYPE_FM.equals(role_type) ? bean.getWuid() : bean.getFuid()
                                                , role_type.equals("1") ? bean.getForeman_name() : bean.getWorker_name(), role_type, getString(R.string.set_salary_mode_title), AccountUtil.HOUR_WORKER_INT, true);
                                    }
                                }
                            });
                    dialog.setLeftBtnText("不修改");
                    dialog.setRightBtnText("修改");
                    dialog.setGravityLeft();
                    dialog.show();
                } else if (itemData.get(position).getItem_type().equals(AccountBean.SALARY)) {//模版-点工
                    isChangedata = true;
                    if (account_type.equals(AccountUtil.HOUR_WORKER)) {  //点工
                        SalaryModeSettingActivity.actionStart(mActivity, tpl, Constance.ROLETYPE_FM.equals(role_type) ? bean.getWuid() : bean.getFuid(), role_type.equals("1") ? bean.getForeman_name() : bean.getWorker_name(), role_type, getString(R.string.set_salary_mode_title), AccountUtil.HOUR_WORKER_INT, true);
                    } else if (account_type.equals(AccountUtil.CONSTRACTOR_CHECK)) {  //包工记工天
                        SalaryModeSettingActivity.actionStart(mActivity, tpl, bean.getUid(), role_type.equals("1") ? bean.getForeman_name() : bean.getWorker_name(), role_type, getString(R.string.set_salary_mode_title_check), AccountUtil.CONSTRACTOR_CHECK_INT, true);
                    }
                } else if (itemData.get(position).getItem_type().equals(AccountBean.UNIT_PRICE)) {//单价-包工
                } else if (itemData.get(position).getItem_type().equals(AccountBean.COUNT)) {//数量-包工
                    AccountSelectCompanyActivity.actionStart(mActivity, bean.getQuantities(), bean.getUnits());
                } else if (itemData.get(position).getItem_type().equals(AccountBean.SUBENTRY_NAME)) {//分项名称-包工
                } else if (itemData.get(position).getItem_type().equals(AccountBean.P_S_TIME)) {//开工时间-包工
                    isChangedata = true;
                    showTimePickView(AccountBean.P_S_TIME, getSelecteDate(itemData.get(position).getRight_value()));
                } else if (itemData.get(position).getItem_type().equals(AccountBean.P_E_TIME)) {//完工时间-包工
                    if (TextUtils.isEmpty(bean.getP_s_time())) {
                        CommonMethod.makeNoticeShort(mActivity, "请先选择开始时间", CommonMethod.ERROR);
                        return;
                    }
                    isChangedata = true;
                    showTimePickView(AccountBean.P_E_TIME, getSelecteDate(itemData.get(position).getRight_value()));
                }
            }
        });
    }

    /**
     * 获取时间calender
     *
     * @param time 选择的时间
     * @return
     */
    public Calendar getSelecteDate(String time) {
        Calendar selectedDate = Calendar.getInstance();
        if (!TextUtils.isEmpty(time) && time.length() == 8) {
            //初始化选择时间
            selectedDate.set(Calendar.YEAR, Integer.parseInt(time.substring(0, 4)));
            selectedDate.set(Calendar.MONTH, Integer.parseInt(time.substring(4, 6)));
            selectedDate.set(Calendar.DAY_OF_MONTH, Integer.parseInt(time.substring(6, 8)));
        } else {
            //初始化默认显示时间
            selectedDate.set(Calendar.YEAR, selectedDate.get(Calendar.YEAR));
            selectedDate.set(Calendar.MONTH, selectedDate.get(Calendar.MONTH));
            selectedDate.set(Calendar.DAY_OF_MONTH, selectedDate.get(Calendar.DAY_OF_MONTH));
        }
        return selectedDate;
    }

    /**
     * 显示时间view
     *
     * @param type 时间多选开始或者结束下标 1：开始 2：结束
     */
    public void showTimePickView(final String type, final Calendar selectedDate) {
        Calendar startDate = Calendar.getInstance();
        startDate.set(2014, 0, 23);
        Calendar endDate = Calendar.getInstance();
        endDate.set(2020, 11, 28);
        TimePickerView pvTime = new TimePickerView.Builder(this, new TimePickerView.OnTimeSelectListener() {
            @Override
            public void onTimeSelect(Date date, View v) {
                //选中事件回调
                int year = Integer.parseInt(new SimpleDateFormat("yyyy").format(date));
                int month = Integer.parseInt(new SimpleDateFormat("MM").format(date));
                int dayOfMonth = Integer.parseInt(new SimpleDateFormat("dd").format(date));
                String time = year + "" + (month < 10 ? "0" + month : month) + "" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth);
                if (type.equals(AccountBean.P_E_TIME)) {
                    long starttime = TimesUtils.strToLongYYYYMMDDs(bean.getP_s_time());
                    long endtime = TimesUtils.strToLongYYYYMMDDs(time);

                    if (starttime > endtime && starttime != 0) {
                        CommonMethod.makeNoticeShort(mActivity, "项目开始时间不能大于结束时间", CommonMethod.ERROR);
                        return;
                    }
                } else if (type.equals(AccountBean.P_S_TIME)) {
                    long starttime = TimesUtils.strToLongYYYYMMDDs(time);
                    long endtime = TimesUtils.strToLongYYYYMMDDs(bean.getP_e_time());
                    if (starttime > endtime && endtime != 0) {
                        CommonMethod.makeNoticeShort(mActivity, "项目开始时间不能大于结束时间", CommonMethod.ERROR);
                        return;
                    }
                }

                //显示时间
                String timeFont = year + "-" + (month < 10 ? "0" + month : month) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "");
                if (type.equals(AccountBean.P_S_TIME)) {
                    bean.setP_s_time(time);
//                    tv_start_time.setText(timeFont);
//                    setData(AccountBean.P_S_TIME, timeFont, null);
                } else if (type.equals(AccountBean.P_E_TIME)) {
                    bean.setP_e_time(time);
//                    tv_end_time.setText(timeFont);

//                    setData(AccountBean.P_E_TIME, timeFont, null);
                }
            }
        })
                //年月日时分秒 的显示与否，不设置则默认全部显示
                .setType(new boolean[]{true, true, true, false, false, false})
                .setCancelText("取消")
                .setSubmitText("确定")
                .setTitleText("请选择时间")
                .setCancelColor(getResources().getColor(R.color.white))
                .setSubmitColor(getResources().getColor(R.color.white))
                .setTitleColor(getResources().getColor(R.color.white))
                .setTitleBgColor(getResources().getColor(R.color.app_color))//标题背景颜色 Night mode
                .setSubCalSize(14)//确定取消字体大小
                .setTitleSize(16)
                .setOutSideCancelable(true)
                .isCyclic(false)
                .setContentSize(18)
                .setTextColorCenter(getResources().getColor(R.color.app_color))
                .isCenterLabel(false) //是否只显示中间选中项的label文字，false则每项item全部都带有label。
                .setDividerColor(getResources().getColor(R.color.app_color))
                .setDate(selectedDate)
                .setRangDate(startDate, endDate)
                .setBackgroundId(0x66000000) //设置外部遮罩颜色
                .setDecorView(null)
                .build();

        pvTime.show();
    }

    /**
     * ----------------处理数据逻辑----------------
     */
    public void initData() {
        for (int i = 0; i < itemData.size(); i++) {
            if (itemData.get(i).getItem_type().equals(AccountBean.SELECTED_DATE)) {//时间-相同部分
                itemData.get(i).setRight_value(bean.getDate());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SELECTED_ROLE)) {//工头名称-相同部分
                if (role_type.equals("1")) {
                    itemData.get(i).setRight_value(bean.getForeman_name());
                } else {
                    itemData.get(i).setRight_value(bean.getWorker_name());
                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.ALL_MONEY)) {//金额-点工包工
                itemData.get(i).setRight_value(bean.getAmounts() + "");
                if (bean.getAmounts().equals("") || bean.getAmounts().equals("0.00") || bean.getAmounts().equals("0")) {
                    itemData.get(i).setRight_value("-");
                } else {
                    itemData.get(i).setRight_value(bean.getAmounts() + "");
                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SUM_MONEY)) {//金额-借支
                LUtils.e("------111B----" + bean.getAmounts());
                amounts = bean.getAmounts();
                itemData.get(i).setRight_value(bean.getAmounts() + "");
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SELECTED_PROJECT)) {//所在项目-相同部分
                itemData.get(i).setRight_value(bean.getProname());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.WORK_TIME)) {//上班时间-点工
                if (bean.getManhour() == 0) {
                    selectWorkTime = 0;
                    itemData.get(i).setRight_value("休息");
                } else {
                    String worktime = (bean.getManhour() + "").contains(".0") ? (bean.getManhour() + "").replace(".0", "") + "小时" : (bean.getManhour() + "小时");
                    selectWorkTime = bean.getManhour();
                    if (bean.getManhour() == bean.getSet_tpl().getW_h_tpl()) {
                        itemData.get(i).setRight_value(worktime + "(1个工)");
                    } else if (bean.getManhour() == (bean.getSet_tpl().getW_h_tpl() / 2)) {
                        itemData.get(i).setRight_value(worktime + "(半个工)");
                    } else {
                        itemData.get(i).setRight_value(worktime);
                    }
                    LUtils.e("----------getManhour--------" + itemData.get(i).getItem_type());
                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.OVER_TIME)) {//加班时间-点工
                if (bean.getOvertime() == 0) {
                    selectOverTime = 0;
                    itemData.get(i).setRight_value("无加班");
                } else {
                    String overtime = (bean.getOvertime() + "").contains(".0") ? (bean.getOvertime() + "").replace(".0", "") + "小时" : (bean.getOvertime() + "小时");
                    selectOverTime = bean.getOvertime();
                    itemData.get(i).setRight_value(overtime);
                    if (bean.getOvertime() == bean.getSet_tpl().getO_h_tpl()) {
                        itemData.get(i).setRight_value(overtime + "(1个工)");
                    } else if (bean.getOvertime() == (bean.getSet_tpl().getO_h_tpl() / 2)) {
                        itemData.get(i).setRight_value(overtime + "(半个工)");
                    } else {
                        itemData.get(i).setRight_value(overtime);
                    }
                    LUtils.e("----------getOvertime--------" + itemData.get(i).getItem_type());
                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SALARY)) {//模版-点工
                tpl = bean.getSet_tpl();
                //4.0.2显示工资模板方式
                hour_type = tpl.getHour_type();
                String salary = "";
                if (hour_type == 1) {//按小时
                    if (tpl.getW_h_tpl() != 0) {
                        salary = "上班" + (tpl.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tpl.getS_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tpl.getS_tpl()) + "元/个工(上班)";
                    }

                    if (tpl.getO_s_tpl() != 0) {
                        salary = salary + "\n" + (Utils.m2(tpl.getO_s_tpl()) + "元/小时(加班)");
                    }
                } else {//按工天
                    if (tpl.getW_h_tpl() != 0) {
                        salary = "上班" + (tpl.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tpl.getO_h_tpl() != 0) {
                        salary = salary + "\n加班" + (tpl.getO_h_tpl() + "").replace(".0", "") + "小时算一个工";
                    }
                    if (tpl.getS_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tpl.getS_tpl()) + "元/个工(上班)";
                    }
                    if (tpl.getS_tpl() != 0 && tpl.getO_h_tpl() != 0) {
                        salary = salary + "\n" + Utils.m2(tpl.getS_tpl() / tpl.getO_h_tpl()) + "元/小时(加班)";
                    }
                }
                itemData.get(i).setRight_value(salary);
//                String w_h_tpl = "上班 " + Utils.deleteZero(bean.getSet_tpl().getW_h_tpl() + "小时算1个工");
//                String o_h_tpl = "加班 " + Utils.deleteZero(bean.getSet_tpl().getO_h_tpl() + "小时算1个工");
//                if (bean.getSet_tpl().getS_tpl() == 0) {
//                    itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl);
//                } else {
//                    String s_tpl = "1个工 " + "工资 " + Utils.m2(bean.getSet_tpl().getS_tpl()) + "";
//                    itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl + "\n" + s_tpl);
//                }
            } else if (itemData.get(i).getItem_type().equals(AccountBean.UNIT_PRICE)) {//单价-包工
                itemData.get(i).setRight_value(bean.getUnitprice());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.COUNT)) {//数量-包工
                itemData.get(i).setRight_value(bean.getQuantities() + "" + bean.getUnits());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SUBENTRY_NAME)) {//分项名称-包工
                itemData.get(i).setRight_value(bean.getSub_proname() + "");
            } else if (itemData.get(i).getItem_type().equals(AccountBean.SALARY_MONEY)) {//分项名称-包工
                itemData.get(i).setRight_value(bean.getAmounts() + "");
            } else if (itemData.get(i).getItem_type().equals(AccountBean.P_S_TIME)) {//开工时间-包工
                itemData.get(i).setRight_value(TimesUtils.ChageStrToDate(bean.getP_s_time()));
            } else if (itemData.get(i).getItem_type().equals(AccountBean.P_E_TIME)) {//完工时间-包工
                itemData.get(i).setRight_value(TimesUtils.ChageStrToDate(bean.getP_e_time()));
            }

        }
        //设置模版内上班与加班时间
        for (int i = 0; i < itemData.size(); i++) {
            if (itemData.get(i).getItem_type().equals(AccountBean.WORK_TIME)) {//上班时间-点工
                tpl.setChoose_w_h_tpl(bean.getManhour());
            } else if (itemData.get(i).getItem_type().equals(AccountBean.OVER_TIME)) {//加班时间-点工
                tpl.setChoose_o_h_tpl(bean.getOvertime());
            }

        }
        View bottomView = getLayoutInflater().inflate(R.layout.layout_account_edit_bottom, null); // 添加底部信息
        listView.addFooterView(bottomView, null, false);
        str_remark = bean.getNotes_txt();
        ed_remark = (EditText) bottomView.findViewById(R.id.ed_remark);
        if (!TextUtils.isEmpty(bean.getNotes_txt()) && !bean.getNotes_txt().equals("无")) {
            ed_remark.setText(bean.getNotes_txt());
        } else {
            ed_remark.setText("");
        }
        ed_remark.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    ed_remark.clearFocus();
                    ed_remark.requestFocus();
                    ed_remark.setFocusable(true);
                    ed_remark.setFocusableInTouchMode(true);
                }
                return false;
            }
        });
        accountEditAdapter = new AccountEditAdapter(mActivity, itemData, account_type, this);
        listView.setAdapter(accountEditAdapter);
        accountEditAdapter.setWorkerName(role_type.equals("1") ? bean.getForeman_name() : bean.getWorker_name());
        initOrUpDateAdapter();
    }

    /* 九宫格图片 adapter */
    private SquaredImageAdapter adapter;

    public void initOrUpDateAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.wrap_grid);
            adapter = new SquaredImageAdapter(this, this, photos, 4);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                    if (position == photos.size()) {
                        Acp.getInstance(mActivity).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                                , Manifest.permission.CAMERA)
                                        .build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        ArrayList<String> mSelected = selectedPhotoPath();
                                        CameraPop.multiSelector(mActivity, mSelected, 4);
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(mActivity, getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });
                    } else {
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) photos);
                        bundle.putInt(Constance.BEAN_INT, position);
                        Intent intent = new Intent(mActivity, PhotoZoomActivity.class);
                        intent.putExtras(bundle);
                        startActivity(intent);
                    }
                }
            });
        } else {
            adapter.updateGridView(photos);
        }

        List<String> imagePaths = bean.getNotes_img();
        if (imagePaths != null && imagePaths.size() > 0) {
            for (int i = 0; i < imagePaths.size(); i++) {
                ImageItem item = new ImageItem();
                item.imagePath = imagePaths.get(i);
                item.isNetPicture = true;
                photos.add(item);
            }
        }
        LUtils.e("-----00-----" + new Gson().toJson(photos));
        adapter.updateGridView(photos);
    }


    @Override
    public void imageSizeIsZero() {
    }

    /**
     * 4.0.2工资标准，按工天显示样式
     *
     * @param tplMode
     */
    private String salaryOfDay(Salary tplMode) {
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
        return salary;
    }

    /**
     * 4.0.2工资标准，按小时显示样式
     *
     * @param tplMode
     */
    private String salaryOfHour(Salary tplMode) {
        String salary = "";
        if (tplMode.getW_h_tpl() != 0) {
            salary = "上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工";
        }
        if (tplMode.getS_tpl() != 0) {
            salary = salary + "\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
        }

        if (overtime_salary_tpl != null && !TextUtils.isEmpty(overtime_salary_tpl)) {
            salary = salary + "\n" + (Utils.m2(Double.parseDouble(overtime_salary_tpl)) + "") + "元/小时(加班)";
            tpl.setO_s_tpl(Double.parseDouble(overtime_salary_tpl));
        }

        LUtils.e("=======hour" + salary);
        return salary;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            isChangedata = true;
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            List<ImageItem> tempList = new ArrayList<ImageItem>();
            if (mSelected != null && mSelected.size() > 0) { //遍历添加本地选中图片
                for (String localpath : mSelected) {
                    ImageItem item = new ImageItem();
                    item.imagePath = localpath;
                    item.isNetPicture = false;
                    tempList.add(item);
                }
            }


            for (int i = 0; i < tempList.size(); i++) {
                tempList.get(i).isNetPicture = false;
                for (int j = 0; j < photos.size(); j++) {
                    if (tempList.get(i).imagePath.equals(photos.get(j).imagePath) && !tempList.get(i).imagePath.contains("/storage/")) {
                        tempList.get(i).isNetPicture = true;
                    }
                }
                LUtils.e("---------------:" + tempList.get(i).imagePath + ",,," + tempList.get(i).isNetPicture);
                photos = tempList;
                adapter.updateGridView(photos);
            }
            LUtils.e("-----22-----" + new Gson().toJson(photos));
        } else if (requestCode == Constance.SALARYMODESETTING_REQUESTCODE && resultCode == Constance.SALARYMODESETTING_RESULTCODE) {
            isChangedata = true;
            Salary tplMode = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            workTimePopWindow = null;
            overTimePopWindow = null;
            tpl = tplMode;
            if (tplMode != null) {
                hour_type = tplMode.getHour_type();
                overtime_salary_tpl = tpl.getOvertime_salary_tpl();
                //设置模版信息
                for (int i = 0; i < itemData.size(); i++) {
                    if (itemData.get(i).getItem_type().equals(AccountBean.SALARY)) {//分项名称-包工
//                        String w_h_tpl = "上班 " + Utils.deleteZero(tpl.getW_h_tpl() + "小时算1个工");
//                        String o_h_tpl = "加班 " + Utils.deleteZero(tpl.getO_h_tpl() + "小时算1个工");
//                        String s_tpl = "1个工 " + "工资 " + Utils.m2(tpl.getS_tpl()) + "";
//                        if (tpl.getS_tpl() == 0) {
//                            LUtils.e("----22------" + w_h_tpl + "\n" + o_h_tpl);
//                            itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl);
//                        } else {
//                            LUtils.e("-----33-----" + w_h_tpl + "\n" + o_h_tpl + "\n" + s_tpl);
//                            itemData.get(i).setRight_value(w_h_tpl + "\n" + o_h_tpl + "\n" + s_tpl);
//                        }
                        if (hour_type == 1) {//按小时
                            itemData.get(i).setRight_value(salaryOfHour(tplMode));
                        } else {//按工天
                            itemData.get(i).setRight_value(salaryOfDay(tplMode));
                        }

                    } else if (itemData.get(i).getItem_type().equals(AccountBean.WORK_TIME)) {//上班时间-点工
                        if (bean.getManhour() == 0) {
                            selectWorkTime = 0;
                            itemData.get(i).setRight_value("休息");
                        } else {
                            String worktime = (bean.getManhour() + "").contains(".0") ? (bean.getManhour() + "").replace(".0", "") + "小时" : (bean.getManhour() + "小时");
                            selectWorkTime = bean.getManhour();
                            if (bean.getManhour() == tpl.getW_h_tpl()) {
                                itemData.get(i).setRight_value(worktime + "(1个工)");
                            } else if (bean.getManhour() == (tpl.getW_h_tpl() / 2)) {
                                itemData.get(i).setRight_value(worktime + "(半个工)");
                            } else {
                                itemData.get(i).setRight_value(worktime);
                            }
                        }
                    } else if (itemData.get(i).getItem_type().equals(AccountBean.OVER_TIME)) {//加班时间-点工
                        if (bean.getOvertime() == 0) {
                            selectOverTime = 0;
                            itemData.get(i).setRight_value("无加班");
                        } else {
                            String overtime = (bean.getOvertime() + "").contains(".0") ? (bean.getOvertime() + "").replace(".0", "") + "小时" : (bean.getOvertime() + "小时");
                            selectOverTime = bean.getOvertime();
                            itemData.get(i).setRight_value(overtime);
                            if (bean.getOvertime() == tpl.getO_h_tpl()) {
                                itemData.get(i).setRight_value(overtime + "(1个工)");
                            } else if (bean.getOvertime() == (tpl.getO_h_tpl() / 2)) {
                                itemData.get(i).setRight_value(overtime + "(半个工)");
                            } else {
                                itemData.get(i).setRight_value(overtime);
                            }
                        }
                    }
                    calculateMoney(tpl);
                    accountEditAdapter.notifyDataSetChanged();
                }
            }
        } else if (requestCode == Constance.REQUESTCODE_ALLWORKCOMPANT && resultCode == Constance.RESULTCODE_ALLWORKCOMPANT) {//包工填写数量回调
            isChangedata = true;
            String values = data.getStringExtra(Constance.CONTEXT);
            String company = data.getStringExtra(Constance.COMPANY);
            if (!TextUtils.isEmpty(values) && !TextUtils.isEmpty(company)) {
                bean.setQuantities(values);
                bean.setUnits(company);
                itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value(caluAllMonny());
                setData(AccountBean.COUNT, bean.getQuantities() + "" + bean.getUnits(), null);

            }
        } else if (resultCode == Constance.RESULTWORKERS) {//添加项目回调

            isChangedata = true;
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);

            LUtils.e(project.getPro_name() + "---------AA----添加项目回调------------" + project.getPid() + ",,," + bean.getPid());
            clearProjectDialog();
        } else if (resultCode == Constance.EDITOR_PROJECT_SUCCESS) {//编辑项目回调
            isChangedata = true;
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            LUtils.e(project.getPro_name() + "--------BB-----添加项目回调------------" + project.getPid() + ",,," + bean.getPid());
            //设置备注信息
            if (!TextUtils.isEmpty(project.getPro_name()) && bean.getPid() == project.getPid()) {
                bean.setPid(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()));

                bean.setProname(project.getPro_name());
                itemData.get(getPosion(itemData, AccountBean.SELECTED_PROJECT)).setRight_value(bean.getProname());
                setData(AccountBean.SELECTED_PROJECT, bean.getProname(), null);
            }
            clearProjectDialog();
        } else if (resultCode == Constance.SELECTE_PROJECT) {//修改了项目
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);

            String proname = project.getPro_name();
            if (!TextUtils.isEmpty(project.getPro_id()) && !project.getPro_id().equals("0")) {
                bean.setProname(proname);
            } else {
                bean.setProname("");
            }
            LUtils.e(bean.getProname() + ",,,,,,,,," + project.getPro_name() + "--------CC-----添加项目回调------------" + new Gson().toJson(project));
            bean.setPid(TextUtils.isEmpty(project.getPro_id()) ? 0 : Integer.parseInt(project.getPro_id()));
            setData(AccountBean.SELECTED_PROJECT, bean.getProname(), null);

        }
    }

    public void clearProjectDialog() {
        if (null != projectWheelView) {
            projectWheelView.dismiss();
        }
        projectList = null;
        projectWheelView = null;
//        recordProject();
    }

    /**
     * ----------------处理数据逻辑结束----------------
     */

    @Override
    public void onAccountItemvalue(int position, String str) {

        if (itemData.get(position).getItem_type().equals(AccountBean.SUBENTRY_NAME)) {//分项名字
            itemData.get(position).setRight_value(str);
            bean.setSub_proname(str);
        } else if (itemData.get(position).getItem_type().equals(AccountBean.UNIT_PRICE)) {//单价
            itemData.get(position).setRight_value(str);
            bean.setUnitprice(str);
        } else if (itemData.get(position).getItem_type().equals(AccountBean.SALARY_MONEY)) {//，结算金额
            itemData.get(position).setRight_value(str);

            bean.setAmounts(str);
        } else if (itemData.get(position).getItem_type().equals(AccountBean.SUM_MONEY)) {//借支金额
            itemData.get(position).setRight_value(str);
            bean.setAmounts(str);
            LUtils.e("-------处理数据逻辑结束--借支-------" + str);
        }
    }

    /**
     * 计算包工总价
     *
     * @return
     */
    private String caluAllMonny() {
        if (bean == null) {
            return "";
        }
        String perPricesStr = bean.getUnitprice();
        String countSumStr = bean.getQuantities();
        if (TextUtils.isEmpty(perPricesStr) || TextUtils.isEmpty(countSumStr)) {
            return "";
        }
        if (perPricesStr.endsWith(".") || countSumStr.endsWith(".")) {
            return "";
        }
        String price = Utils.m2(StringUtil.strToFloat(perPricesStr) * StringUtil.strToFloat(countSumStr));
        return price;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_del:
                delsetmount();
                break;
            case R.id.btn_save:
                try {
                    if (account_type.equals(AccountUtil.BORROWING)) {
                        if (Double.parseDouble(bean.getAmounts()) != Double.parseDouble(amounts)) {
                            isChangedata = true;
                        }
                        LUtils.e(bean.getAmounts() + ",,," + amounts + ",,," + isChangedata);
                    }
                    if (!str_remark.equals(ed_remark.getText().toString())) {
                        isChangedata = true;
                    }
                    if (!isChangedata && !getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                        mActivity.finish();
                        return;
                    }
                } catch (Exception e) {

                }
                FileUpData();
                break;
        }
    }

    /**
     * 删除
     */
    public void delsetmount() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", account_id + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELSETSMOUNT, params,
                new RequestCallBackExpand<String>() {
                    @SuppressWarnings("deprecation")
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<CityInfoMode> bean = CommonListJson.fromJson(responseInfo.result, CityInfoMode.class);
                            if (bean.getState() == 0) {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            } else {
                                CommonMethod.makeNoticeShort(mActivity, "删除成功", CommonMethod.ERROR);
                                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                                setResult(Constance.ACCOUNT_DELETE, getIntent());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                        closeDialog();
                    }
                });
    }

    /**
     * 设置今天工作时长
     */
    public void workTimeSelect() {
        hideSoftKeyboard();
        final Salary salar = tpl;
        int currentIndex = 0;
        workTimeList = DataUtil.getWorkTime(0, tpl.getW_h_tpl());
        for (int i = 0; i < workTimeList.size(); i++) {
            if (workTimeList.get(i).getWorkTimes() == selectWorkTime) {
                currentIndex = i;
            }
        }
        LUtils.e(currentIndex + "-------selectWorkTime-------------" + selectWorkTime);
        if (workTimePopWindow == null) {
            workTimePopWindow = new WheelAccountTimeSelected(this, getString(R.string.choosetime), workTimeList, currentIndex, true, hour_type);
            workTimePopWindow.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    WorkTime time = workTimeList.get(postion);
                    salar.setChoose_w_h_tpl(time.getWorkTimes());
                    selectWorkTime = time.getWorkTimes();
                    bean.setManhour(Float.parseFloat(time.getWorkTimes() + ""));
                    if (time.getWorkTimes() == 0) { //无上班时间
                        setData(AccountBean.WORK_TIME, "休息", null);
                    } else {
                        setData(AccountBean.WORK_TIME, (time.getWorkTimes() + "").replace(".0", "") + "小时" + time.getUnit(), null);
                    }
                    calculateMoney(salar);
                }
            });
            workTimePopWindow.setSelecteWheelView(currentIndex);
        } else {
            workTimePopWindow.setSelecteWheelView(currentIndex);
            workTimePopWindow.update();
        }
        //显示窗口
        workTimePopWindow.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 设置今天加班时长
     */
    public void overTimeSelect() {
        if (tpl == null || tpl.getW_h_tpl() == 0) {
            CommonMethod.makeNoticeShort(mActivity, "请先设置薪资模板", CommonMethod.ERROR);
            return;
        } else {
            final Salary salar = tpl;
            int currentIndex = 0;
            overTimeList = DataUtil.getOverTime(0, tpl.getO_h_tpl());
            for (int i = 0; i < overTimeList.size(); i++) {
                if (overTimeList.get(i).getWorkTimes() == selectOverTime) {
                    currentIndex = i;
                }
            }
            if (overTimePopWindow == null) {
                overTimePopWindow = new WheelAccountTimeSelected(this, getString(R.string.choosetime), overTimeList, currentIndex, false, hour_type);
                overTimePopWindow.setListener(new CallBackSingleWheelListener() {
                    @Override
                    public void onSelected(String scrollContent, int postion) {
                        WorkTime time = overTimeList.get(postion);
                        LUtils.e("---加班时间--------" + new Gson().toJson(time));
                        salar.setChoose_o_h_tpl(time.getWorkTimes());
                        selectOverTime = time.getWorkTimes();
                        bean.setOvertime(Float.parseFloat(time.getWorkTimes() + ""));
                        if (time.getWorkTimes() == 0) { //无加班
                            setData(AccountBean.OVER_TIME, "无加班", null);
                        } else {
                            setData(AccountBean.OVER_TIME, (time.getWorkTimes() + "").replace(".0", "") + "小时" + time.getUnit(), null);
                        }
                        calculateMoney(salar);

                    }
                });
                overTimePopWindow.setSelecteWheelView(currentIndex);

            } else {
                overTimePopWindow.setSelecteWheelView(currentIndex);
                overTimePopWindow.update();
            }
            //显示窗口
            overTimePopWindow.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        }
    }

    protected int getPosion(List<AccountBean> itemData, String item_type) {
        for (int i = 0; i < itemData.size(); i++) {
            if (TextUtils.equals(item_type, itemData.get(i).getItem_type())) {
                return i;
            }
        }
        return 0;

    }

    private double selectWorkTime, selectOverTime;


    public void setData(String type, String str, Salary salary) {
        LUtils.e(str + "--------SELECTED_ROLE----------" + type);
        for (int i = 0; i < itemData.size(); i++) {
            if (itemData.get(i).getItem_type().equals(type)) {//工头名称-相同部分
                if (!TextUtils.isEmpty(str)) {
                    if (role_type.equals("1")) {
                        itemData.get(i).setRight_value(str);
                    } else {
                        itemData.get(i).setRight_value(str);
                    }
                } else {
                    itemData.get(i).setRight_value("");

                }
            } else if (itemData.get(i).getItem_type().equals(type)) {//金额-相同部分
                itemData.get(i).setRight_value(str + "");
            } else if (itemData.get(i).getItem_type().equals(type)) {//所在项目-相同部分
                itemData.get(i).setRight_value(str);
            } else if (itemData.get(i).getItem_type().equals(type)) {//上班时间-点工
                itemData.get(i).setRight_value(str);
            } else if (itemData.get(i).getItem_type().equals(type)) {//加班时间-点工
                itemData.get(i).setRight_value(str);
            } else if (itemData.get(i).getItem_type().equals(type)) {//单价-包工
            } else if (itemData.get(i).getItem_type().equals(type)) {//数量-包工
                itemData.get(i).setRight_value(str + "" + bean.getUnits());
            } else if (itemData.get(i).getItem_type().equals(type)) {//分项名称-包工
                itemData.get(i).setRight_value(str + "");
            } else if (itemData.get(i).getItem_type().equals(type)) {//开始时间-包工
                itemData.get(i).setRight_value(str + "");
            } else if (itemData.get(i).getItem_type().equals(type)) {//结束时间-包工
                itemData.get(i).setRight_value(str + "");
            }
        }


        accountEditAdapter.notifyDataSetChanged();
        for (int i = 0; i < itemData.size(); i++) {
            if (itemData.get(i).getItem_type().equals(AccountBean.SELECTED_ROLE) || itemData.get(i).getItem_type().equals(AccountBean.SELECTED_PROJECT)) {
//                LUtils.e(itemData.get(i).getItem_type() + "--------SELECTED_ROLE----------" + itemData.get(i).getRight_value());
            }
        }
    }

    /**
     * 计算价钱
     *
     * @param salar
     */
    public void calculateMoney(Salary salar) {

        LUtils.e("--------calculateMoney----------" + new Gson().toJson(salar));
        if (salar.getS_tpl() == 0) {
            if (salar.getW_h_tpl() == 0 && salar.getO_h_tpl() == 0) {
                itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("");
            } else {
                itemData.get(getPosion(itemData, AccountBean.ALL_MONEY)).setRight_value("-");
            }
            return;
        }
        double w_money = salar.getS_tpl() / salar.getW_h_tpl() * salar.getChoose_w_h_tpl(); //正常上班计算薪资
        double o_money = salar.getS_tpl() / salar.getO_h_tpl() * salar.getChoose_o_h_tpl(); //加班时常计算薪资

        setData(AccountBean.ALL_MONEY, Utils.m2((w_money + o_money)), null);

    }

    RequestParams params;

    public void FileUpData() {
        createCustomDialog();
        //相同部分参数
        params = RequestParamsToken.getExpandRequestParams(mActivity);
        AccountInfoBean infoBean = new AccountInfoBean();
        infoBean.setAccounts_type(account_type);
        /** 记账id */
        infoBean.setRecord_id(account_id + "");
        /** 项目id */
        infoBean.setPid(bean.getPid() == 0 ? "0" : bean.getPid() + "");
        /** 备注描述 */
        if (!TextUtils.isEmpty(ed_remark.getText().toString())) {
            infoBean.setText(ed_remark.getText().toString());
        }

        //其他参数

        if (account_type.equals(AccountUtil.BORROWING)) {  //借支
            infoBean.setSalary(bean.getAmounts());
        } else if (account_type.equals(AccountUtil.CONSTRACTOR_CHECK)) {  //包工记工天
            infoBean.setWork_hour_tpl(String.valueOf(tpl.getW_h_tpl()));//模版上班时间
            infoBean.setOvertime_hour_tpl(String.valueOf(tpl.getO_h_tpl()));//模版加班时间
            infoBean.setWork_time(String.valueOf(bean.getManhour()));//正常上班时间
            infoBean.setOver_time(String.valueOf(bean.getOvertime()));//正常加班时间
            infoBean.setSalary_tpl(String.valueOf(tpl.getS_tpl()));
        } else if (account_type.equals(AccountUtil.HOUR_WORKER)) {//点工
            infoBean.setWork_hour_tpl(String.valueOf(tpl.getW_h_tpl()));//模版上班时间
            infoBean.setOvertime_hour_tpl(String.valueOf(tpl.getO_h_tpl()));//模版加班时间
            infoBean.setWork_time(String.valueOf(bean.getManhour()));//正常上班时间
            infoBean.setOver_time(String.valueOf(bean.getOvertime()));//正常加班时间
            infoBean.setSalary_tpl(String.valueOf(tpl.getS_tpl()));
            if (hour_type == 1&&overtime_salary_tpl!=null) {
                if (!TextUtils.isEmpty(overtime_salary_tpl)) {
                    infoBean.setOvertime_salary_tpl(overtime_salary_tpl);
                }
                infoBean.setHour_type(1);
            }else {
                infoBean.setHour_type(0);
            }
        }
        if (!TextUtils.isEmpty(getImage())) {
            infoBean.setImgs(getImage());//图片
        }
        List<AccountInfoBean> accountInfoBeanList = new ArrayList<>();
        accountInfoBeanList.add(infoBean);
        params.addBodyParameter("info", new Gson().toJson(accountInfoBeanList).toString());
        if (null != agencyGroupUser) {
            if (!TextUtils.isEmpty(agencyGroupUser.getUid())) {
                params.addBodyParameter("agency_uid", agencyGroupUser.getUid());
            }
            if (!TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
                params.addBodyParameter("group_id", agencyGroupUser.getGroup_id());
            }
        }
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                List<String> tempPhoto = null;
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
                    if (tempPhoto == null) {
                        tempPhoto = new ArrayList<>();
                    }
                    int size = photos.size();
                    LUtils.e("-----33-----" + new Gson().toJson(photos));
                    for (int i = 0; i < size; i++) {
                        ImageItem item = photos.get(i);
                        LUtils.e(item.isNetPicture + ",,,,," + item.imagePath);
                        if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                            tempPhoto.add(photos.get(i).imagePath);
                        }
                    }
                    LUtils.e("---------------" + new Gson().toJson(tempPhoto));
                    if (tempPhoto.size() > 0) {
                        RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, mActivity);
                    }
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
                    updateAccount();
                    break;
            }

        }
    };


    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = photos.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = photos.get(i);
            if (!TextUtils.isEmpty(item.imagePath)) {
                mSelected.add(item.imagePath);
            }

        }
        return mSelected;
    }

    /**
     * 保存记账信息
     */
    public void updateAccount() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFYRELASE_NEW, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getMsg().equals(Constance.SUCCES_S)) {
                        CommonMethod.makeNoticeShort(mActivity, getString(R.string.hint_changebill), CommonMethod.SUCCESS);
                        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                        setResult(Constance.ACCOUNT_UPDATE, getIntent());
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(mActivity, base.getErrno(), base.getMsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                closeDialog();
            }
        });
    }

//    StringBuffer stringBuffer;

    @Override
    public void remove(int position) {
//        if (!photos.get(position).imagePath.contains("/storage/")) {
//            if (null == stringBuffer) {
//                stringBuffer = new StringBuffer();
//            }
//            LUtils.e("删除了---------------------");
//            stringBuffer.append(photos.get(position).imagePath + ";");
//        } else {
//            LUtils.e("没有删除-----------------");
//        }
        isChangedata = true;
        photos.remove(position);
        adapter.notifyDataSetChanged();
        LUtils.e("-----11A----" + new Gson().toJson(photos));
    }

    public String getImage() {
        if (null == photos || photos.size() == 0) {
            return "";
        }
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < photos.size(); i++) {
            if (!photos.get(i).imagePath.contains("/storage/")) {
                stringBuffer.append(photos.get(i).imagePath + ";");
            }
        }
        return stringBuffer.toString();
    }
}