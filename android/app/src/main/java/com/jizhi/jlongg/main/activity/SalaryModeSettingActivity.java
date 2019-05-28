package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.SpannedString;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.AbsoluteSizeSpan;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.AppCursorEditText;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountWorkRember;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.SalaryTpl;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.dialog.DiaLogHourCheckDialog;
import com.jizhi.jlongg.main.dialog.DialogSalaryModeSuccess;
import com.jizhi.jlongg.main.dialog.WheelAccountTimeSelected;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.popwindow.ActionSheetPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.StringUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.util.ArrayList;
import java.util.List;

/**
 * 设置薪资模版2016/2/18.
 */
public class SalaryModeSettingActivity extends BaseActivity {

    /**
     * 正常上班时长
     */
    @ViewInject(R.id.normal_text)
    private TextView normal_text;
    /**
     * 加班时常
     */
    @ViewInject(R.id.overtime_text)
    private TextView overtime_text;
    /**
     * 金额
     */
    @ViewInject(R.id.s_tpl)
    private EditText moneyOfOneday;

    @ViewInject(R.id.tv_hint)
    private TextView tv_hint;

    @ViewInject(R.id.work_over_text)
    private TextView work_over_text;

    @ViewInject(R.id.oneHourSalary)
    private LinearLayout oneHourSalary;

    @ViewInject(R.id.overtime_layout)
    private LinearLayout overtime_layout;

    @ViewInject(R.id.lin_money)
    private LinearLayout lin_money;

    @ViewInject(R.id.work_overtime_salary)
    private AppCursorEditText work_overtime_salary;

    /**
     * 正常上班时长列表
     */
    private List<WorkTime> normalWorkingDurationList;
    /**
     * 正常加班时长列表
     */
    private List<WorkTime> overTimeWorkingDurationList;
    /**
     * 正常上班时长列表当前下标
     */
    private int normalWorkingDurationPos = 14;
    /**
     * 加班标准时长列表当前下标
     */
    private int overTimeWorkingDurationPos = 10;
    /**
     * 记账对象ID
     */
//    private String uid;
    /**
     * 接受薪资模板
     */
    private Salary tpl;
    /**
     * 选中的上班时间，选中的加班时间
     */
    private double selectWorkTime, selectOverTime;
    /**
     * 默认选中：按工天算加班
     */
    private static final int WORK_OVER_DAY=0x21;
    private static final int WORK_OVER_HOUR=0x32;
    private int work_over_flag=WORK_OVER_DAY;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.salarymode_setting4_0_2);
        ViewUtils.inject(this);
               //moneyOfOneday = findViewById(R.id.s_tpl);
               moneyOfOneday.setFocusable(true);
        moneyOfOneday.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        moneyOfOneday.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
        setEditTextDecimalNumberLength(moneyOfOneday, 7, 2);
        work_overtime_salary.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        work_overtime_salary.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
        setEditTextDecimalNumberLength(work_overtime_salary, 7, 2);
        initialize();
        moneyOfOneday.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                setOverTimeMoney();
            }
        });

    }

    /**
     * @param activity
     * @param tpl          工资模版
     * @param uid          用户uid
     * @param userName     用户名字
     * @param role         当前角色
     * @param title        标题
     * @param isChangeTime 用户是否在记账界面修改了 上班 ，加班时间， true,修改了，false,没有修改，记多人传true
     */
    public static void actionStart(Activity activity, Salary tpl, String uid, String userName, String role, String title, int account_type, boolean isChangeTime) {
        Intent intent = new Intent(activity, SalaryModeSettingActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, tpl);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.ROLE, role);
        intent.putExtra(Constance.TITLE, title);
        intent.putExtra(Constance.BEAN_BOOLEAN, isChangeTime);
        intent.putExtra(Constance.BEAN_INT, account_type);
        activity.startActivityForResult(intent, Constance.SALARYMODESETTING_REQUESTCODE);
    }

    /**
     * 批量记账启动方法
     *
     * @param uid           用户uid
     * @param userName      用户名字
     * @param role          当前角色
     * @param title         标题
     * @param isMoreAccount 是否是记多人跳转，
     * @param account_type  记账类型，
     */
    public static void actionStart(Activity activity, Salary tpl, String uid, String userName, String role, String title, boolean isMoreAccount, int account_type,boolean isChangeTime) {
        LUtils.e("---------------------" + account_type);
        Intent intent = new Intent(activity, SalaryModeSettingActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, tpl);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.ROLE, role);
        intent.putExtra(Constance.TITLE, title);
//        intent.putExtra(Constance.BEAN_FIRST_SET_SALARY, isFirstSetSalary);
        intent.putExtra(Constance.BEAN_MORE_ACCOUNT, isMoreAccount);
        intent.putExtra(Constance.BEAN_INT, account_type);
        intent.putExtra(Constance.BEAN_BOOLEAN, isChangeTime);
        activity.startActivityForResult(intent, Constance.SALARYMODESETTING_REQUESTCODE);
    }

    /**
     * 初始化数据
     */
    private void initialize() {
        Intent intent = getIntent();
        Salary tpl = (Salary) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        setMode(intent, tpl);
    }

    private void setMode(Intent intent, Salary tpl) {
        //设置标题
        if (tpl!=null&&tpl.getHour_type()==1){
            tpl.setO_h_tpl(6);
        }
        LUtils.e("------设置末班界面-tpl----------" + new Gson().toJson(tpl));
        String roler = getIntent().getStringExtra(Constance.ROLE);
        TextView tv_role = findViewById(R.id.tv_role);
        TextView title = findViewById(R.id.title);
        TextView tv_name = findViewById(R.id.tv_name);
        //名字
        if (!TextUtils.isEmpty(intent.getStringExtra(Constance.USERNAME))) {
            tv_name.setText(intent.getStringExtra(Constance.USERNAME));
            findViewById(R.id.lin_name).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.lin_name).setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.TITLE))) {
            if (getIntent().getStringExtra(Constance.TITLE).equals(getString(R.string.set_salary_mode_title_check))) {
                findViewById(R.id.lin_salary).setVisibility(View.GONE);
                findViewById(R.id.work_overtime).setVisibility(View.GONE);
                findViewById(R.id.view_1).setVisibility(View.GONE);
                findViewById(R.id.view2).setVisibility(View.GONE);
                findViewById(R.id.view3).setVisibility(View.GONE);
                findViewById(R.id.view4).setVisibility(View.GONE);
                LinearLayout.LayoutParams params=new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT);
                params.topMargin=0;
                findViewById(R.id.normal_layout).setLayoutParams(params);
                tv_hint.setText("包工记工天无需设置工资金额\n如需设置工资金额请为他记点工");
                title.setText(getIntent().getStringExtra(Constance.TITLE));
            } else {
                //findViewById(R.id.lin_money).setVisibility(View.GONE);
                findViewById(R.id.lin_salary).setVisibility(View.VISIBLE);
                title.setText((roler.equals(Constance.ROLETYPE_WORKER) ? "我的工资标准" : "工资标准"));
                //((TextView) findViewById(R.id.tv_hint)).setText(roler.equals(Constance.ROLETYPE_WORKER) ? "只需首次记工时设置工资标准，之后记工会自动显示，如工资变化，请重新设置" : "工资标准设置成功后\n记工将采用最新设置的工资标准\n\n如之前已经记过账\n不会更改之前已记工的工资标准");
                //4.0.2
                if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN,false)){
                    tv_hint.setText("修改工资标准后，记工将使用最新的工资标准，同时不会更改之前已记工的标准");
                }else {
                    tv_hint.setText("工资标准设置完成后，记工将一直使用该标准，如工资变化请重新设置");
                }

            }
        } else {
            findViewById(R.id.lin_salary).setVisibility(View.VISIBLE);
            title.setText((roler.equals(Constance.ROLETYPE_WORKER) ? "我的工资标准" : "工资标准"));
            //((TextView) findViewById(R.id.tv_hint)).setText(roler.equals(Constance.ROLETYPE_WORKER) ? "只需首次记工时设置工资标准，之后记工会自动显示，如工资变化，请重新设置" : "工资标准设置成功后\n记工将采用最新设置的工资标准\n\n如之前已经记过账\n不会更改之前已记工的工资标准");
            if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN,false)){
                tv_hint.setText("修改工资标准后，记工将使用最新的工资标准，同时不会更改之前已记工的标准");
            }else {
                tv_hint.setText("工资标准设置完成后，记工将一直使用该标准，如工资变化请重新设置");
            }
        }
        oneHourSalary.setVisibility(View.GONE);
        overtime_layout.setVisibility(View.VISIBLE);
        //角色
        tv_role.setText((roler.equals(Constance.ROLETYPE_WORKER) ? "班组长" : "工人"));
        //金额提示文字手动改变hint字体大小
        //SpannableString ss = new SpannableString(roler.equals(Constance.ROLETYPE_WORKER) ? "与班组长/工头协商的金额(可不填)" : "与工人协商的金额(可不填)");//定义hint的值
        //4.0.2新hint
        SpannableString ss = new SpannableString("请输入工资金额");
        AbsoluteSizeSpan ass = new AbsoluteSizeSpan(14, true);//设置字体大小 true表示单位是sp
        ss.setSpan(ass, 0, ss.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        ((TextView) findViewById(R.id.s_tpl)).setHint(new SpannedString(ss));
        if (!StringUtil.isNullOrEmpty(moneyOfOneday.getText().toString())) {
            moneyOfOneday.setSelection(moneyOfOneday.getText().length());
        }
        normalWorkingDurationList = DataUtil.getSalaryWorkingDuration(1);
        overTimeWorkingDurationList = DataUtil.getSalaryOverTimegDuration(1);
        if (tpl != null && tpl.getW_h_tpl() != 0) {
            if (tpl.getS_tpl() != 0) {  //将金额设置到EditText 上
                moneyOfOneday.setText(Utils.m2(tpl.getS_tpl()));
                moneyOfOneday.setSelection(moneyOfOneday.getText().toString().length());
            }
            selectWorkTime = tpl.getW_h_tpl(); //设置为上班时长的选项
            selectOverTime = tpl.getO_h_tpl(); //设置为加班时长的选项
            setOverTimeMoney();
            normal_text.setText(RecordUtils.cancelIntergerZeroFloat(tpl.getW_h_tpl()) + "小时算1个工");
            overtime_text.setText(RecordUtils.cancelIntergerZeroFloat(tpl.getO_h_tpl()) + "小时算1个工");
        } else {
            selectWorkTime = normalWorkingDurationList.get(normalWorkingDurationPos).getWorkTimes();
            selectOverTime = overTimeWorkingDurationList.get(overTimeWorkingDurationPos).getWorkTimes();
        }
        if (tpl!=null&&!TextUtils.isEmpty(getIntent().getStringExtra(Constance.TITLE))
                &&!getIntent().getStringExtra(Constance.TITLE)
                .equals(getString(R.string.set_salary_mode_title_check))) {
            if (tpl.getHour_type() == 1) {
                SalaryModeSettingActivity.this.work_over_flag = WORK_OVER_HOUR;
                oneHourSalary.setVisibility(View.VISIBLE);
                overtime_layout.setVisibility(View.GONE);
                lin_money.setVisibility(View.GONE);
                work_over_text.setText("按小时算加班工资");
                if (tpl.getO_s_tpl() != 0) {
                    work_overtime_salary.setText(Utils.m2(tpl.getO_s_tpl()));
                }else if (tpl.getO_s_tpl()==0&&tpl.getOvertime_salary_tpl()!=null&&
                        !TextUtils.isEmpty(tpl.getOvertime_salary_tpl())){
                    try {
                        work_overtime_salary.setText(Utils.m2(Double.valueOf(tpl.getOvertime_salary_tpl())));
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                }
            } else {
                SalaryModeSettingActivity.this.work_over_flag = WORK_OVER_DAY;
                oneHourSalary.setVisibility(View.GONE);
                overtime_layout.setVisibility(View.VISIBLE);
                work_over_text.setText("按工天算加班");
                if (!TextUtils.isEmpty(moneyOfOneday.getText().toString()) &&
                        !moneyOfOneday.getText().toString().equals("")) {
                    lin_money.setVisibility(View.VISIBLE);
                }
            }
        }
        this.tpl = tpl;
    }

    /**
     * 计算加班一个小的的工资
     */
    private void setOverTimeMoney() {
        //加班时间 selectOverTime
        //金额 moneyOfOneday
        String money = moneyOfOneday.getText().toString().trim(); //总金额

        double moneyTotal = 0;
        if (TextUtils.isEmpty(money)) {
            moneyTotal = 0;
        } else {
            if (!money.endsWith(".")&&!money.equals(".0")) {
                try {
                    moneyTotal = Double.valueOf(money);
                }catch (Exception e){
                    moneyTotal=0;
                }
            } else {
                try {
                    moneyTotal = Double.valueOf(money.replace(".", ""));
                }catch (Exception e){
                    moneyTotal=0;
                }
            }
        }
        if (moneyTotal==0){
            lin_money.setVisibility(View.GONE);
            return;
        }
        Double oneMoney = moneyTotal / selectOverTime;
        ((TextView) findViewById(R.id.tv_salaty)).setText(Utils.m2(oneMoney));
        //4.0.2只在按工天算加班，才显示加班一小时的工钱是根据输入的工资金额和加班标准计算出来的
        if (work_over_flag == WORK_OVER_DAY) {
            lin_money.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 保存设置
     */
    @OnClick(R.id.save)
    private void save(View v) {
        String moneyTotalEdit = moneyOfOneday.getText().toString().trim(); //总金额

        double moneyTotal = 0;
        if (TextUtils.isEmpty(moneyTotalEdit)) {
            moneyTotal = 0;
        } else {
            if (!moneyTotalEdit.endsWith(".")&&!moneyTotalEdit.endsWith(".0")) {
                try {
                    moneyTotal = Double.valueOf(moneyTotalEdit);
                }catch (Exception e){
                    moneyTotal=0;
                }
            } else {
                try {
                    moneyTotal = Double.valueOf(moneyTotalEdit.replace(".", ""));
                }catch (Exception e){
                    moneyTotal=0;
                }
            }
        }
        if (null == tpl) {
            tpl = new Salary();
        }
        //true,用户修改了上班或者加班时间，不用重新设置用户选择的上班加班时间，否者需要设置
        boolean isChangeTime = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (!isChangeTime) {
            //重新设置用户的上班加班时间
            tpl.setChoose_w_h_tpl(selectWorkTime);
            tpl.setChoose_o_h_tpl(0);
        }
        tpl.setW_h_tpl(selectWorkTime);
        tpl.setO_h_tpl(selectOverTime);
        tpl.setS_tpl(moneyTotal);
        closeKeyboard(); //关闭软键盘
        //3.4.1  只有记多人跳转过来的并且是首次设置模版才执行
        if (tpl.getW_h_tpl() <= 0 || tpl.getO_h_tpl() <= 0) {
            CommonMethod.makeNoticeShort(SalaryModeSettingActivity.this, "模版设置有误", true);
            return;
        }
        setWorkdayTpl(tpl);


    }

    /**
     * 批量设置记工的工资标准
     */
    public void setWorkdayTpl(final Salary tpl) {
        //模版对象
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        LUtils.e("----------AAAA-------" + TextUtils.isEmpty(getIntent().getStringExtra(Constance.UID)));
        if (TextUtils.isEmpty(getIntent().getStringExtra(Constance.UID))) {
            Intent intent = new Intent();
            intent.putExtra(Constance.BEAN_CONSTANCE, tpl);
            setResult(Constance.SALARYMODESETTING_RESULTCODE, intent);
            finish();
            return;
        }
        //4.0.2
        if (work_over_flag==WORK_OVER_HOUR){
            String stringExtra = getIntent().getStringExtra(Constance.TITLE);
            String moneyTotalEdit = moneyOfOneday.getText().toString().trim(); //总金额

            double moneyTotal = 0;
            if (TextUtils.isEmpty(moneyTotalEdit)) {
                moneyTotal = 0;
            } else {
                if (!moneyTotalEdit.endsWith(".")&&!moneyTotalEdit.endsWith(".0")) {
                    try {
                        moneyTotal = Double.valueOf(moneyTotalEdit);
                    }catch (Exception e){
                        moneyTotal=0;
                    }
                } else {
                    try {
                        moneyTotal = Double.valueOf(moneyTotalEdit.replace(".", ""));
                    }catch (Exception e){
                        moneyTotal=0;
                    }
                }
            }
            if (moneyTotal==0&&stringExtra!=null&&!stringExtra.equals(getString(R.string.set_salary_mode_title_check))){
                    CommonMethod.makeNoticeShort(SalaryModeSettingActivity.this,"请输入工资金额",false);
                    return;
                }
            String s = work_overtime_salary.getText().toString();
            double money = 0;
            if (TextUtils.isEmpty(s)) {
                money = 0;
            } else {
                if (!s.endsWith(".")&&!s.endsWith(".0")) {
                    try {
                        money = Double.valueOf(s);
                    }catch (Exception e){
                        money=0;
                    }
                } else {
                    try {
                        money = Double.valueOf(s.replace(".", ""));
                    }catch (Exception e){
                        money=0;
                    }
                }
            }
                if (money==0){
                    CommonMethod.makeNoticeShort(SalaryModeSettingActivity.this,"请输入加班一小时的工资金额",false);
                    return;
                }
        }
        String[] uids = getIntent().getStringExtra(Constance.UID).split(",");
        List<SalaryTpl> salaryTpls = new ArrayList<>();
        for (String uid : uids) {
            SalaryTpl salaryTpl = new SalaryTpl();
            //金额
            salaryTpl.setSalary_tpl(String.valueOf(tpl.getS_tpl()));
            //上班时间
            salaryTpl.setWork_hour_tpl(String.valueOf(tpl.getW_h_tpl()));
            //加班时间
            salaryTpl.setOvertime_hour_tpl(String.valueOf(tpl.getO_h_tpl()));
            //记账类型
            salaryTpl.setAccounts_type(getIntent().getIntExtra(Constance.BEAN_INT, 1) + "");
            //用户uid
            salaryTpl.setUid(uid);
            //4.0.2
            if (work_over_flag==WORK_OVER_HOUR){
                String m = work_overtime_salary.getText().toString();
                if (TextUtils.isEmpty(m)
                        || m.equals(".")||m.equals("0.")||m.equals(".0")) {
                   m="0";
                }
                if (m.endsWith(".")) {
                    m = m.replace(".", "");
                }
                salaryTpl.setHour_type(1);
                salaryTpl.setOvertime_salary_tpl(m);
                tpl.setHour_type(1);
                tpl.setOvertime_salary_tpl(m);
            }else {
                salaryTpl.setHour_type(0);
                tpl.setHour_type(0);
            }


            salaryTpls.add(salaryTpl);
        }
        params.addBodyParameter("params", new Gson().toJson(salaryTpls));
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SET_WORKDAY_TPL, Repository.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    Repository repository = (Repository) object;
                    if (repository.getStatus() == 1) {
                        //isFirstSetSalary 是否是首次设置薪资模版， true,修改了，false,
//                        boolean isFirstSetSalary = getIntent().getBooleanExtra(Constance.BEAN_FIRST_SET_SALARY, false);
                        boolean isMoreAccount = getIntent().getBooleanExtra(Constance.BEAN_MORE_ACCOUNT, false);

                        if (isMoreAccount) {
                            new DialogSalaryModeSuccess(SalaryModeSettingActivity.this, new DialogSalaryModeSuccess.SalarySuccessClickListenerClick() {
                                @Override
                                public void Succes() {
                                    Intent intent = new Intent();
                                    intent.putExtra(Constance.BEAN_CONSTANCE, tpl);
                                    setResult(Constance.SALARYMODESETTING_RESULTCODE, intent);
                                    finish();
                                }
                            }, getIntent().getStringExtra(Constance.ROLE).equals(Constance.ROLETYPE_WORKER) ? "设置成功，快去为班组长记工吧！" : "设置成功，快去为工人记工吧！").show();
                        } else {
                            Intent intent = new Intent();
                            intent.putExtra(Constance.BEAN_CONSTANCE, tpl);
                            setResult(Constance.SALARYMODESETTING_RESULTCODE, intent);
                            finish();
                        }


                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(SalaryModeSettingActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                printNetLog(msg, SalaryModeSettingActivity.this);
            }
        });
    }

    /**
     * 正常上班时常Dialog
     */
    private WheelAccountTimeSelected normalDilaog;
    /**
     * 加班时常Dialog
     */
    private WheelAccountTimeSelected overtimeDialog;

    /**
     * 加班计算方式选择
     */
    private ActionSheetPopWindow chooseOverTimeDialog;

    @OnClick(R.id.work_overtime)
    public void chooseWorkOverTime(View v) {
        hideSoftKeyboard();
        if (chooseOverTimeDialog == null) {
            chooseOverTimeDialog = new ActionSheetPopWindow(this, findViewById(R.id.main));
            chooseOverTimeDialog.show();
        } else {
            chooseOverTimeDialog.show();
        }
        chooseOverTimeDialog.setOnActionSheetPopClickListener(
                new ActionSheetPopWindow.ActionSheetPopClickListener() {
                    @Override
                    public void onClickWorkOverDay(View view) {
                        SalaryModeSettingActivity.this.work_over_flag=WORK_OVER_DAY;
                        oneHourSalary.setVisibility(View.GONE);
                        overtime_layout.setVisibility(View.VISIBLE);
                        String moneyTotalEdit = moneyOfOneday.getText().toString().trim(); //总金额

                        double moneyTotal = 0;
                        if (TextUtils.isEmpty(moneyTotalEdit)) {
                            moneyTotal = 0;
                        } else {
                            if (!moneyTotalEdit.endsWith(".")&&!moneyTotalEdit.endsWith(".0")) {
                                try {
                                    moneyTotal = Double.valueOf(moneyTotalEdit);
                                }catch (Exception e){
                                    moneyTotal=0;
                                }
                            } else {
                                try {
                                    moneyTotal = Double.valueOf(moneyTotalEdit.replace(".", ""));
                                }catch (Exception e){
                                    moneyTotal=0;
                                }
                            }
                        }
                        if (moneyTotal!=0
                                &&!TextUtils.isEmpty(getIntent().getStringExtra(Constance.TITLE))
                                        &&!getIntent().getStringExtra(Constance.TITLE)
                                        .equals(getString(R.string.set_salary_mode_title_check))){
                            lin_money.setVisibility(View.VISIBLE);
                        }
                        work_over_text.setText("按工天算加班");

                    }

                    @Override
                    public void onClickWorkOverHour(View view) {
                        SalaryModeSettingActivity.this.work_over_flag = WORK_OVER_HOUR;
                        oneHourSalary.setVisibility(View.VISIBLE);
                        overtime_layout.setVisibility(View.GONE);
                        lin_money.setVisibility(View.GONE);
                        work_over_text.setText("按小时算加班工资");
//                        if (tpl.getO_s_tpl() != 0) {
//                            work_overtime_salary.setText(Utils.m2(tpl.getO_s_tpl()));
//                        }
                    }
                }
        );
    }

    /**
     * 正常上班时长
     */
    @OnClick(R.id.normal_layout)
    public void normal_layout(View v) {
        hideSoftKeyboard();
        if (normalDilaog == null) {
            int currentIndex = 0;
            for (int i = 0; i < normalWorkingDurationList.size(); i++) {
                if (normalWorkingDurationList.get(i).getWorkTimes() == selectWorkTime) {
                    currentIndex = i;
                }
            }
            normalDilaog = new WheelAccountTimeSelected(this, getString(R.string.choosetime), normalWorkingDurationList, currentIndex);
            normalDilaog.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    normal_text.setText(normalWorkingDurationList.get(postion).getWorkName() + "算1个工");
                    selectWorkTime = normalWorkingDurationList.get(postion).getWorkTimes();
                }
            });
            normalDilaog.setSelecteWheelView(currentIndex);
        } else {
            normalDilaog.update();
        }
        //显示窗口
        normalDilaog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 加班
     */
    @OnClick(R.id.overtime_layout)
    public void overtime_layout(View v) {
        hideSoftKeyboard();
        if (overtimeDialog == null) {
            int currentIndex = 0;
            for (int i = 0; i < overTimeWorkingDurationList.size(); i++) {
                if (overTimeWorkingDurationList.get(i).getWorkTimes() == selectOverTime) {
                    currentIndex = i;
                }
            }
            overtimeDialog = new WheelAccountTimeSelected(this, getString(R.string.choosetime), overTimeWorkingDurationList, currentIndex);
            overtimeDialog.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    overtime_text.setText(overTimeWorkingDurationList.get(postion).getWorkName() + "算1个工");
                    selectOverTime = overTimeWorkingDurationList.get(postion).getWorkTimes();
                    setOverTimeMoney();
                }
            });
            overtimeDialog.setSelecteWheelView(currentIndex);
        } else {
            overtimeDialog.update();
        }
        //显示窗口
        overtimeDialog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    public void onFinish(View view) {
        finish();
    }


    private void closeKeyboard() {
        View view = getWindow().peekDecorView();
        if (view != null) {
            InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }
}
