package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.ScrollView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.HourWorkFragment;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.AccountWorkRember;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.dialog.WheelViewSingleBatchAccount;
import com.jizhi.jlongg.main.fragment.worker.SingleBatchAccountFragment;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.NestRadioGroup;
import com.jizhi.jongg.widget.WrapViewPager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 单人批量记账
 *
 * @author Xuj
 * @time 2017年2月9日18:43:35
 * @Version 1.0
 */
public class SingleBatchAccountActivity extends BaseActivity implements View.OnClickListener {

    /**
     * ViewPager
     */
    private WrapViewPager mViewPager;
    /**
     * fragments
     */
    private ArrayList<Fragment> fragments;
    /**
     * VierPager 滑动位置
     */
    private int mCurrentIndex;
    /**
     * 日期
     */
    private TextView dateTxt;

    /**
     * 上班时长数据
     */
    private List<WorkTime> normalTimeList;
    /**
     * 加班时长数据
     */
    private List<WorkTime> overTimeList;
    /**
     * 记账对象id,当前选中的项目id,班组id
     */
    private String uid, pid, proName;
    /**
     * 记账对象点工薪资模板,包工记工天考勤模板
     */
    private Salary hourWorkSalary, constractorSalary;
    /**
     * true表示已请求过点工和包工记工天薪资模板
     * 如果选择的人被删除了则也会设置相应为false
     */
    private boolean isRequestHourWorkSalary, isRequestConstractorSalary;
    /**
     * 提交按钮
     */
    private Button submitBtn;
    /**
     * 薪资标准文本
     */
    private TextView salaryValueText;
    /**
     * 薪资标准名称
     */
    private TextView salaryText;
    /**
     * 记账对象名称TextView
     */
    private TextView accountNameText;
    /**
     * 备注文本
     */
    private String remark;
    /**
     * 备注图片
     */
    private ArrayList<ImageItem> remarkImages;
    /**
     * 左滑箭头
     */
    private View leftArrows;
    /**
     * 右滑箭头
     */
    private View rightArrows;
    /**
     * 当前工种
     * 1.点工
     * 5.包工记工天
     */
    public int currentWork;
    /**
     * 记账对象
     */
    private PersonBean accountPerson;
    /**
     * 批量记多天弹窗
     */
    private WheelViewSingleBatchAccount confirmPopWindow;

    /**
     * 按小时算加班，加班一小时工钱
     */
    private String overtime_salary_tpl="0";//按小时记工，两个页面之间的传值
    private int hour_type;
    /**
     * 设置标准来源，如果选择了记账的人，则是api拉取上一笔工模板from==1
     * 如果本地进行设置，但是未保存当前这笔记工，这表示本地进行设置from==0
     */
    private static int from=-1;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.single_batch_account);
        initIntentData();
        initView();
        setViewPager();
        setConfirmState(0);
        //未完善姓名
        IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                getLastRecordBillOfProject();
            }
        });
    }

    /**
     * @param context
     * @param accountPerson 记账对象
     * @param pid           项目id
     * @param proName       项目名称
     * @param groupId       项目组id 如果groupId则不能修改记账对象
     * @param user          代班长信息
     * @param accountType   默认选择的记账类型 传1 表示点工 传5表示包工考勤
     */
    public static void actionStart(Activity context, PersonBean accountPerson, String pid, String proName, String groupId, AgencyGroupUser user, int accountType) {
        Intent intent = new Intent(context, SingleBatchAccountActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, accountPerson);
        intent.putExtra(Constance.PID, pid);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra("agencyGroupUser", user);
        intent.putExtra(Constance.ACCOUNT_TYPE, accountType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * {@link HourWorkFragment#setTime()}批量记多天时，工资模板from==1
     */
    public static void setFrom(){
        from=1;
    }
    /**
     * 初始化记账人信息
     *
     * @param accountPerson  记账对象信息
     * @param initSalaryInfo 是否初始化薪资模板信息 true:选择了记账对象 false：未选择记账对象
     */
    private void initAccountPerson(PersonBean accountPerson, boolean initSalaryInfo) {
        if (accountPerson != null) {
            uid = accountPerson.getUid() + "";
            accountNameText.setText(accountPerson.getName());
            hourWorkSalary = accountPerson.getTpl();
            constractorSalary = accountPerson.getUnit_quan_tpl();
            if (initSalaryInfo) {
                from=1;
                initSalaryInfo();
            }
        } else { //表示已删除了对应的人
            uid = null;
            accountNameText.setText("");
            salaryValueText.setText("");
            hourWorkSalary = null;
            constractorSalary = null;
            //设置已删除的标识
            setResult(Constance.SUCCESS, getIntent());
        }
        this.accountPerson = accountPerson;
        isRequestHourWorkSalary = false;
        isRequestConstractorSalary = false;
    }

    private void initIntentData() {
        Intent intent = getIntent();
        pid = intent.getStringExtra(Constance.PID);
        proName = intent.getStringExtra(Constance.PRONAME);
        accountPerson = (PersonBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        //（V3.5.3）记工类型：用户首次使用批量记工，记工类型默认选中点工，之后记工类型默认到上一次记工选择的类型；
        if (accountPerson == null) { //如果记账对象为空 则是从日历首页点击进来的
            currentWork = (int) SPUtils.get(getApplicationContext(), "singlebatch_select_type", AccountUtil.HOUR_WORKER_INT, Constance.JLONGG);
        } else {
            currentWork = intent.getIntExtra(Constance.ACCOUNT_TYPE, AccountUtil.HOUR_WORKER_INT);
        }
    }

    private void initView() {
        setTextTitle(R.string.single_person_batch_account);

        Button confirmBtn = getButton(R.id.red_btn);
        dateTxt = getTextView(R.id.dateText);
        mViewPager = (WrapViewPager) findViewById(R.id.viewPager);
        submitBtn = getButton(R.id.red_btn);

        leftArrows = findViewById(R.id.leftIcon);
        rightArrows = findViewById(R.id.rightIcon);
        leftArrows.setOnClickListener(this);
        rightArrows.setOnClickListener(this);
        rightArrows.setVisibility(View.INVISIBLE);

        salaryValueText = (TextView) findViewById(R.id.salary_value_text);
        salaryText = (TextView) findViewById(R.id.salary_text);
        accountNameText = (TextView) findViewById(R.id.account_name_text);
        TextView accountNameRole = (TextView) findViewById(R.id.account_name_role);

        NestRadioGroup nestRadioGroup = findViewById(R.id.guide_rg);
        nestRadioGroup.setOnCheckedChangeListener(new NestRadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(NestRadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.hourWorkBtn: //点工
                        currentWork = AccountUtil.HOUR_WORKER_INT;
                        initSalaryInfo();
                        SPUtils.put(getApplicationContext(), "singlebatch_select_type", AccountUtil.HOUR_WORKER_INT, Constance.JLONGG);
                        break;
                    case R.id.constactorBtn: //包工记工天
                        currentWork = AccountUtil.CONSTRACTOR_CHECK_INT;
                        initSalaryInfo();
                        SPUtils.put(getApplicationContext(), "singlebatch_select_type", AccountUtil.CONSTRACTOR_CHECK_INT, Constance.JLONGG);
                        break;
                }
            }
        });
        initAccountPerson(accountPerson, false);
        switch (currentWork) {
            case AccountUtil.HOUR_WORKER_INT: //点工
                RadioButton hourWorkBtn = findViewById(R.id.hourWorkBtn);
                hourWorkBtn.setChecked(true);
                break;
            case AccountUtil.CONSTRACTOR_CHECK_INT: //包工记工天
                RadioButton constactorBtn = findViewById(R.id.constactorBtn);
                constactorBtn.setChecked(true);
                break;
        }
        boolean isForeman = UclientApplication.isForemanRoler(getApplicationContext());
        accountNameText.setHint(isForeman ? "请选择工人" : "请添加你的班组长/工头");
        accountNameRole.setText(isForeman ? R.string.workers : R.string.foremans);
        confirmBtn.setText(getString(R.string.single_batch_account_un_selecte));
        //班组内的记账 如果当前角色是工人则不允许修改记账对象
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.GROUP_ID)) && !UclientApplication.isForemanRoler(getApplicationContext())) {
            findViewById(R.id.select_account_person_layout).setOnClickListener(null);
            TextView accountNameText = findViewById(R.id.account_name_text);
            accountNameText.setCompoundDrawables(null, null, null, null);
        }
    }
    /**
     * 4.0.2工资标准，按工天显示样式
     * @param tplMode
     */
    private void salaryOfDay(Salary tplMode) {
        String salary="";
        if (tplMode.getW_h_tpl()!=0){
            salary="上班"+(tplMode.getW_h_tpl() + "").replace(".0", "")+ "小时算一个工";
        }
        if (tplMode.getO_h_tpl()!=0){
            salary=salary+"\n加班"+(tplMode.getO_h_tpl() + "").replace(".0", "")+"小时算一个工";
        }
        if (tplMode.getS_tpl()!=0){
            salary=salary+ "\n"+Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
        }
        if (tplMode.getS_tpl()!=0&&tplMode.getO_h_tpl()!=0) {
            salary = salary + "\n"+Utils.m2(tplMode.getS_tpl() / tplMode.getO_h_tpl())+"元/小时(加班)";
        }
        LUtils.e("=======day"+salary);
        salaryValueText.setText(salary);
    }

    /**
     * 4.0.2工资标准，按小时显示样式
     * @param tplMode
     * @param fromNet 设置标准来源，如果选择了记账的人，则是api拉取上一笔工模板from==1
     *                如果本地进行设置，但是未保存当前这笔记工，这表示本地进行设置from==0
     */
    private void salaryOfHour(Salary tplMode,int fromNet) {
        String salary="";
        if (tplMode.getW_h_tpl()!=0){
            salary="上班"+(tplMode.getW_h_tpl() + "").replace(".0", "")+ "小时算一个工";
        }
        if (tplMode.getS_tpl()!=0){
            salary=salary+"\n"+ Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)";
        }
        if (fromNet==0) {
            if (overtime_salary_tpl != null && !TextUtils.isEmpty(overtime_salary_tpl)) {
                salary = salary+"\n" + (Utils.m2(Double.parseDouble(overtime_salary_tpl)) + "") + "元/小时(加班)";
                hourWorkSalary.setO_s_tpl(Double.parseDouble(overtime_salary_tpl));
            }
        }else if (fromNet==1){
            if (tplMode.getO_s_tpl()!= 0) {
                salary = salary +"\n"+ (Utils.m2(tplMode.getO_s_tpl()) + "元/小时(加班)");
            }
        }
        LUtils.e("=======hour"+salary);
        salaryValueText.setText(salary);
    }
    /**
     * 初始化工资标准信息
     */
    private void initSalaryInfo() {
        if (isHourWork()) { //点工模板
            salaryText.setText(R.string.set_salary_mode_title);
           if (hourWorkSalary!=null) {
               overtime_salary_tpl = hourWorkSalary.getOvertime_salary_tpl();
               hour_type = hourWorkSalary.getHour_type();
               if (hour_type == 1) {//按小时算加班
                   salaryOfHour(hourWorkSalary, from);

               } else {//按工天算加班
                   salaryOfDay(hourWorkSalary);
               }
           }else {
               salaryValueText.setText("");
               salaryValueText.setHint("这里设置工资标准");
               if (!TextUtils.isEmpty(uid)) {//如果没有uid 禁止加载薪资模板
                   getSalaryTpl(currentWork);
               }
           }
//            if (hourWorkSalary != null && hourWorkSalary.getW_h_tpl() != 0 && hourWorkSalary.getO_h_tpl() != 0) {
//                if (hourWorkSalary.getS_tpl() != 0) {
//                    salaryValueText.setText(Utils.m2(hourWorkSalary.getS_tpl()) + "元/个工\n" + RecordUtils.cancelIntergerZeroFloat(hourWorkSalary.getW_h_tpl()) + "小时(上班)/" + RecordUtils.cancelIntergerZeroFloat(
//                            hourWorkSalary.getO_h_tpl()) + "小时(加班)");
//                } else {
//                    salaryValueText.setText(RecordUtils.cancelIntergerZeroFloat(hourWorkSalary.getW_h_tpl()) + "小时(上班)/" + RecordUtils.cancelIntergerZeroFloat(hourWorkSalary.getO_h_tpl()) + "小时(加班)");
//                }
//            } else {
//                salaryValueText.setText("");
//                salaryValueText.setHint("这里设置工资标准");
//                if (!TextUtils.isEmpty(uid)) {//如果没有uid 禁止加载薪资模板
//                    getSalaryTpl(currentWork);
//                }
//            }
        } else { //包工记工天模板
            salaryText.setText(R.string.set_salary_mode_title_check);
            if (constractorSalary != null && constractorSalary.getW_h_tpl() != 0 && constractorSalary.getO_h_tpl() != 0) {
                salaryValueText.setText(RecordUtils.cancelIntergerZeroFloat(constractorSalary.getW_h_tpl()) + "小时(上班)/" + RecordUtils.cancelIntergerZeroFloat(constractorSalary.getO_h_tpl()) + "小时(加班)");
            } else {
                salaryValueText.setText("");
                salaryValueText.setHint("这里设置考勤模板");
                if (!TextUtils.isEmpty(uid)) {//如果没有uid 禁止加载薪资模板
                    getSalaryTpl(currentWork);
                }
            }
        }
    }

    /**
     * 获取薪资模板
     *
     * @param accountTyps 记账类型
     */
    public void getSalaryTpl(final int accountTyps) {
        if (isHourWork()) {
            if (isRequestHourWorkSalary) { //如果已请求过点工薪资模板 则不在去请求薪资模板
                return;
            }
        } else {
            if (isRequestConstractorSalary) {//如果已请求过包工记工天薪资模板 则不在去请求薪资模板
                return;
            }
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("accounts_type", accountTyps + "");
        params.addBodyParameter("uid", uid);
        String httpUrl = NetWorkRequest.GET_WORK_TPL_BY_UID;
        CommonHttpRequest.commonRequest(this, httpUrl, AccountWorkRember.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final AccountWorkRember accountWorkRember = (AccountWorkRember) object;
                if (accountWorkRember != null) {
                    switch (accountTyps) {
                        case AccountUtil.HOUR_WORKER_INT://点工
                            isRequestHourWorkSalary = true;
                            hourWorkSalary = accountWorkRember.getMy_tpl();
                            initSalaryInfo();
                            from=0;
                            break;
                        case AccountUtil.CONSTRACTOR_CHECK_INT://包工考勤
                            isRequestConstractorSalary = true;
                            constractorSalary = accountWorkRember.getMy_tpl();
                            initSalaryInfo();
                            break;
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    private void setViewPager() {
        fragments = new ArrayList<>();
        CustomDate currentTime = new CustomDate();
        int difference_between_month = 0; //相差月份个数
        try {
            difference_between_month = DateUtil.countMonths("2014-01", currentTime.getYear() + "-" + currentTime.getMonth(), "yyyy-MM"); // 获取2014年1月到现在相差多少个月
        } catch (Exception e) {
            e.printStackTrace();
        }
        int startYear = 2014; // 开始时间2014年
        int startMonth = 1; // 1月
        int startday = 1; // 第一天
        for (int i = 0; i <= difference_between_month; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            SingleBatchAccountFragment fragment = new SingleBatchAccountFragment();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, startday));
            bundle.putInt("fragmentPosition", i);
            fragment.setArguments(bundle);
            fragments.add(fragment);
            startMonth += 1;
        }

        mViewPager.setAdapter(new CalendarViewPagerAdapter(getSupportFragmentManager(), fragments));
        mViewPager.setCurrentItem(fragments.size());
        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                leftArrows.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
                rightArrows.setVisibility(position == fragments.size() - 1 ? View.INVISIBLE : View.VISIBLE);
                mCurrentIndex = position;
                SingleBatchAccountFragment fragment = (SingleBatchAccountFragment) (fragments.get(position));
                setDate(fragment.getmShowDate().year + "", fragment.getmShowDate().month);
                refreshCalendarData(true, true);
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        SingleBatchAccountFragment fragment = (SingleBatchAccountFragment) fragments.get(fragments.size() - 1);
        Bundle bundle = fragment.getArguments();
        CustomDate date = (CustomDate) bundle.getSerializable(Constance.BEAN_CONSTANCE);
        setDate(date.year + "", date.month);
        mCurrentIndex = fragments.size() - 1;
        final ScrollView scrollView = findViewById(R.id.scroll_view);
        mViewPager.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                if (scrollView.getHeight() == 0 || scrollView.getWidth() == 0) {
                    return;
                }
                /**
                 * Android设置ScrollView回到顶部的三种方式
                 * 直接置顶,瞬间回到顶部,没有滚动过程,其中Y值可以设置为大于0的值,使Scrollview停在指定位置。
                 * ScrollView.scrollTo(0,0);
                 * 类似于手动拖回顶部,有滚动过程
                 * ScrollView.fullScroll(View.FOCUS_UP);
                 * 类似于手动拖回顶部,有滚动过程,其中Y值可以设置为大于0的值,使Scrollview停在指定位置。
                 * ScrollView.smoothScrollTo(0, 0);
                 */
                scrollView.smoothScrollTo(0, 0);
                if (Build.VERSION.SDK_INT >= 16) {
                    mViewPager.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                } else {
                    mViewPager.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                }
            }
        });
    }

    private void setDate(String year, int month) {
        dateTxt.setText(year + "年" + month + "月");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.dateText: //选择日历框
                SingleBatchAccountFragment fragme = (SingleBatchAccountFragment) fragments.get(mCurrentIndex);
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(this, new YearAndMonthClickListener() { //    时间选择器弹出框
                    @Override
                    public void YearAndMonthClick(String year, String month) {
                        try {
                            int count = DateUtil.countMonths("2014-01", year + "-" + month, "yyyy-MM");
                            mViewPager.setCurrentItem(count);
                            setDate(year, Integer.parseInt(month));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }, fragme.getmShowDate().year, fragme.getmShowDate().month);
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.red_btn: //提交批量记账
                openSubmitDialog();
                break;
            case R.id.leftIcon: //点击回到上个月
                if (mCurrentIndex == 0) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex - 1);
                break;
            case R.id.rightIcon://点击去到下个月
                if (mCurrentIndex == fragments.size() - 1) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex + 1);
                break;
            case R.id.salary_setting_layout: //设置工资标准
                if (TextUtils.isEmpty(uid)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), getString(R.string.ple_select_ob), CommonMethod.ERROR);
                    return;
                }
                boolean isHourWork = isHourWork();
                SalaryModeSettingActivity.actionStart(this, isHourWork ? hourWorkSalary : constractorSalary, uid,
                        accountNameText.getText().toString(), UclientApplication.getRoler(getApplicationContext()),
                        getString(isHourWork ? R.string.set_salary_mode_title : R.string.set_salary_mode_title_check), false, currentWork,true);
                break;
            case R.id.select_account_person_layout: //选择班组长成员
                AddAccountPersonActivity.actionStart(this, uid, getIntent().getStringExtra(Constance.GROUP_ID), currentWork, 0);
                break;
        }
    }


    /**
     * 设置确定按钮状态
     *
     * @param size
     */
    public void setConfirmState(int size) {
        if (size > 0) {
            submitBtn.setText(R.string.single_batch_account_un_selecte);
            submitBtn.setClickable(true);
            Utils.setBackGround(submitBtn, getResources().getDrawable(R.drawable.draw_eb4e4e_5radius));
        } else {
            submitBtn.setText(R.string.single_batch_account_selecte);
            submitBtn.setClickable(false);
            Utils.setBackGround(submitBtn, getResources().getDrawable(R.drawable.bg_yw_dark_5radius));
        }
    }

    /**
     * 提交批量记账参数
     *
     * @param normalTime    正常时长
     * @param overTime      加班时长
     * @param selectedDatas
     * @return
     */
    public RequestParams getParams(double normalTime, double overTime, List<SingleBatchAccountFragment.Cell> selectedDatas) {
        ArrayList<AccountInfoBean> paramsList = new ArrayList<>();
        String userName = getTextView(R.id.account_name_text).getText().toString(); //获取记账对象姓名
        for (SingleBatchAccountFragment.Cell cell : selectedDatas) { //遍历记账已选中的记账日期
            CustomDate selectedData = cell.date;
            String month = selectedData.month < 10 ? "0" + selectedData.month : selectedData.month + "";
            String day = selectedData.day < 10 ? "0" + selectedData.day : selectedData.day + "";
            paramsList.add(getData(selectedData.year + month + day, normalTime, overTime, userName, cell.selecteAccountType));
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        AgencyGroupUser user = (AgencyGroupUser) getIntent().getSerializableExtra("agencyGroupUser"); //如果代班长信息不为空需要验证一下时间是否开始时间和结束时间范围内
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId);// 班组id
        }
        if (user != null && !TextUtils.isEmpty(user.getUid())) {
            params.addBodyParameter("agency_uid", user.getUid());//代班长id
        }
        if (!TextUtils.isEmpty(remark)) { //备注信息
            params.addBodyParameter("text", remark);
        }
        params.addBodyParameter("is_days", "1");
        if (remarkImages != null && remarkImages.size() > 0) {
            RequestParamsToken.compressImageAndUpLoadWater(params, remarkImages, SingleBatchAccountActivity.this);
        }
        params.addBodyParameter("info", new Gson().toJson(paramsList));
        return params;
    }

    private AccountInfoBean getData(String date, double normalTime, double overTime, String accountName, int accountType) {
        AccountInfoBean accountInfoBean = new AccountInfoBean();
        accountInfoBean.setAccounts_type(accountType + "");
        accountInfoBean.setName(accountName);
        accountInfoBean.setUid(uid);
        accountInfoBean.setDate(date);
        accountInfoBean.setWork_time(String.valueOf(normalTime));
        accountInfoBean.setOver_time(String.valueOf(overTime));
        accountInfoBean.setPid(pid);
        accountInfoBean.setPro_name("0".equals(pid) ? "其他项目" : proName);
        if (accountType == AccountUtil.HOUR_WORKER_INT) {
            if (hourWorkSalary != null) {
                accountInfoBean.setSalary_tpl(String.valueOf(hourWorkSalary.getS_tpl()));
                accountInfoBean.setWork_hour_tpl(String.valueOf(hourWorkSalary.getW_h_tpl()));
                accountInfoBean.setOvertime_hour_tpl(String.valueOf(hourWorkSalary.getO_h_tpl()));
                double normalTimeMoney = hourWorkSalary.getS_tpl() / hourWorkSalary.getW_h_tpl() * normalTime; //正常上班计算薪资
                double overTimeMoney = hourWorkSalary.getS_tpl() / hourWorkSalary.getO_h_tpl() * overTime; //加班时常计算薪资
                accountInfoBean.setSalary(Utils.m2(normalTimeMoney + overTimeMoney));
                /**4.0.2 点工按小时加班增加参数*/
                if (hour_type==1&&overtime_salary_tpl!=null){
                    accountInfoBean.setOvertime_salary_tpl(String.valueOf(overtime_salary_tpl));
                    accountInfoBean.setHour_type(1);
                }else {
                    accountInfoBean.setHour_type(0);
                }
            }
        } else {
            if (constractorSalary != null) {
                accountInfoBean.setWork_hour_tpl(String.valueOf(constractorSalary.getW_h_tpl()));
                accountInfoBean.setOvertime_hour_tpl(String.valueOf(constractorSalary.getO_h_tpl()));
            }
        }
        return accountInfoBean;
    }


    /**
     * 提交批量记账
     *
     * @param normalTime   已选的上班时长
     * @param overTime     已选的加班时长
     * @param selectedData 日历上已选的天数
     */
    public void submitBatchAccount(final double normalTime, final double overTime, final List<SingleBatchAccountFragment.Cell> selectedData) {
        final CustomProgress customProgress = new CustomProgress(this);
        customProgress.show(this, null, false);
        //这里提交可能会涉及到图片的上传，所以我们手动开启线程上传不会阻塞UI
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                String httpUrl = NetWorkRequest.WORKERBATCHACCOUNT;
                RequestParams requestParams = getParams(normalTime, overTime, selectedData);
                CommonHttpRequest.commonRequest(SingleBatchAccountActivity.this, httpUrl, BaseNetBean.class,
                        CommonHttpRequest.OBJECT, requestParams, false, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                                if (customProgress != null) {
                                    customProgress.dismiss();
                                }
                                remark = null;
                                remarkImages = null;
                                confirmPopWindow = null;
                                setResult(Constance.SAVE_BATCH_ACCOUNT); //批量记账成功后的标记
                                CommonMethod.makeNoticeLong(getApplicationContext(), getString(R.string.hint_bill), CommonMethod.SUCCESS);
                                refreshCalendarData(false, true);//重新刷新一下数据
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {
                                if (customProgress != null) {
                                    customProgress.dismiss();
                                }
                            }
                        });
            }
        });
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_EDITPROJECT) { //选择项目后回调
            if (resultCode == Constance.SELECTE_PROJECT) {
                Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (project == null) {
                    return;
                }
                pid = project.getPro_id();
                proName = "0".equals(project.getPro_id()) ? null : project.getPro_name();
            }
            openSubmitDialog();
        } else if (resultCode == Constance.SALARYMODESETTING_RESULTCODE) { //设置记账对象薪资模板回调
            Salary settingSalary = (Salary) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (settingSalary != null) {
                if (isHourWork()) {
                    from=0;
                    hourWorkSalary = settingSalary;
                } else {
                    constractorSalary = settingSalary;
                }
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, settingSalary);
                setResult(Constance.SALARYMODESETTING_RESULTCODE, intent);
                initSalaryInfo();
            }
        } else if (resultCode == Constance.REMARK_SUCCESS) { //备注返回
            String remark = data.getStringExtra(RemarksActivity.REMARK_DESC);
            ArrayList<ImageItem> remarkImages = (ArrayList<ImageItem>) data.getSerializableExtra(RemarksActivity.PHOTO_DATA);
            this.remark = remark;
            this.remarkImages = remarkImages;
            openSubmitDialog();
        } else if (resultCode == Constance.SUCCESS) {//选择记账对象回调
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            initAccountPerson(personBean, true);
            getLastRecordBillOfProject();
            refreshCalendarData(true, true);
        }
    }

    /**
     * 获取记账对象最后一笔工 所对应的项目名称
     */
    public void getLastRecordBillOfProject() {
        if (TextUtils.isEmpty(uid)) {
            return;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.LASTPRO, Project.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Project project = (Project) object;
                if (project != null && project.getPid() != 0) {
                    pid = project.getPid() + "";
                    proName = project.getPro_name();
                } else {
                    pid = "0";
                    proName = null;
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    public boolean isHourWork() {
        return AccountUtil.HOUR_WORKER_INT == currentWork;
    }

    /**
     * 重新刷新数据 是否选中的日期
     *
     * @param clearCalendarCell true表示清空日历记账数据
     * @param clearSelectCell   true表示清空日历记账选择框
     */
    private void refreshCalendarData(boolean clearCalendarCell, boolean clearSelectCell) {
        SingleBatchAccountFragment fragment = (SingleBatchAccountFragment) fragments.get(mCurrentIndex);
        fragment.clearAccountState(clearCalendarCell, clearSelectCell);
        fragment.getMonthAccountData(); //重新获取月数据
    }

    /**
     * 已选中的天数
     */
    private void openSubmitDialog() {
        SingleBatchAccountFragment fragment = (SingleBatchAccountFragment) fragments.get(mCurrentIndex);
        if (normalTimeList == null) { //初始化上班时长数据
            normalTimeList = DataUtil.getNormalTimeListNewVersion(24);
        }
        if (overTimeList == null) { //初始化加班时常数据
            overTimeList = DataUtil.getOverTimeListNewVersion(24);
        }
        boolean editorPro;
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.GROUP_ID))) { //如果班组id为 空表示是普通记账， 不为空表示是代班长记工
            editorPro = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER) ? true : false;
        } else {
            editorPro = true;
        }
        if (confirmPopWindow == null) {
            confirmPopWindow = new WheelViewSingleBatchAccount(this, normalTimeList, overTimeList, fragment.getSelecteDay(),
                    new WheelViewSingleBatchAccount.SelecteTimeListener() {
                        @Override
                        public void selectedTime(WorkTime normalTime, WorkTime overTime, List<SingleBatchAccountFragment.Cell> selectedData) { //确定批量记账
                            submitBatchAccount(normalTime.getWorkTimes(), overTime.getWorkTimes(), selectedData);
                        }

                        @Override
                        public void selectedProject() { //选择所在项目
                            SelecteProjectActivity.actionStart(SingleBatchAccountActivity.this, pid);
                        }

                        @Override
                        public void setRemark() { //批量设置备注
                            Intent intent = new Intent(SingleBatchAccountActivity.this, RemarksActivity.class);
                            Bundle bundle = new Bundle();
                            bundle.putSerializable(RemarksActivity.PHOTO_DATA, remarkImages);
                            bundle.putString(RemarksActivity.REMARK_DESC, remark);
                            intent.putExtras(bundle);
                            startActivityForResult(intent, Constance.REQUEST_ACCOUNT);
                        }
                    }, proName, remark, remarkImages, editorPro);
        } else {
            confirmPopWindow.update(fragment.getSelecteDay(), proName, remark, remarkImages);
        }
        confirmPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 是否设置了薪资标准
     */
    public boolean isSetSalary() {
        if (isHourWork()) {
            return hourWorkSalary != null && hourWorkSalary.getW_h_tpl() != 0 && hourWorkSalary.getO_h_tpl() != 0;
        } else {
            return constractorSalary != null && constractorSalary.getW_h_tpl() != 0 && constractorSalary.getO_h_tpl() != 0;
        }
    }


    @Override
    public void finish() {
        //将记账对象返回
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_CONSTANCE, accountPerson);
        setResult(Constance.SUCCESS, intent);
        super.finish();
    }
}