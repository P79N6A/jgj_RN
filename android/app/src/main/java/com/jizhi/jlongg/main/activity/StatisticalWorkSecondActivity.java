package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.higuide.GuideUtils;
import com.jizhi.jlongg.main.adpter.StatisticalWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.NestRadioGroup;
import com.jizhi.jongg.widget.StatisticalDrawerLayout;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能: 记工统计-按项目查看2级页面
 * 作者：Xuj
 * 时间: 2018年9月26日16:05:09
 */
public class StatisticalWorkSecondActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 班组长角色:按项目查看
     */
    public static final int TYPE_FROM_PROJECT = 1;
    /**
     * 班组长角色:按工人查看
     */
    public static final int TYPE_FROM_WORKER = 2;
    /**
     * 工人角色:按班组长查看
     */
    public static final int TYPE_FROM_FOREMAN = 3;
    /**
     * RadioBtn左边按钮,右边按钮
     */
    private RadioButton leftRadioBtn, rightRadioBtn;
    /**
     * RadioBtn左边向上箭头,右边向上箭头
     */
    private View radioBtnLeftIcon, radioBtnRightIcon;
    /**
     * 当前选中的是左边的按钮标志
     */
    private final int SELECTE_LEFT_BTN_FLAG = 0;
    /**
     * 当前选中的是右边的按钮
     */
    private final int SELECTE_RIGHT_BTN_FLAG = 1;
    /**
     * 当前选中的状态   month 按月统计  project:按项目  默认选择为按月统计
     */
    private int current_selecte_flag = SELECTE_LEFT_BTN_FLAG;
    /**
     * 开始日期,结束日期,农历开始日期,农历结束日期
     */
    private TextView startTime, endTime;
    /**
     * 标题名称
     */
    private TextView itemTitleName;
    /**
     * 记工统计适配器
     */
    private StatisticalWorkAdapter adapter;
    /**
     * 侧滑菜单布局
     */
    private DrawerLayout drawer;
    /**
     * 侧滑菜单弹出布局
     */
    private StatisticalDrawerLayout drawerChildLayout;
    /**
     * 未结金额、点工金额、包工分包金额、包工承包金额、借支金额、结算金额
     */
    private TextView littleWorkAmount, contractorWorkTwoAmount, contractorWorkOneAmount, borrowAmount, balanceAmount;
    /**
     * 上班时长、加班时长、借支合计、结算合计
     */
    private TextView manhour, overTime, borrowTotal, balanceTotal;
    /**
     * 记工统计数据
     */
    private StatisticalWork statisticalWork;
    /**
     * private static final int TYPE_FROM_PROJECT = 1;班组长角色:按项目查看
     * private static final int TYPE_FROM_WORKER = 2;  班组长角色:按工人查看
     * private static final int TYPE_FROM_FOREMAN = 3;工人角色:按班组长查看
     */
    private int searchType;
    /**
     * 所在项目
     */
    private TextView own_pro_text, own_pro_value_text;
    /**
     * 工人、班组长名字
     */
    private TextView work_name_text, work_name_value_text;
    /**
     * 记工分类
     */
    private TextView record_type_text, record_type_value_text;
    /**
     * 当没有数据时展示的页面, item标题
     */
    private View defalutView, titleLayout;
    /**
     * 筛选点击确认后需要调用的记账id
     */
    private String accountIds;


    private String pid, proName, uid, userName;


    /**
     * 启动当前Activity
     *
     * @param startTime            开始时间
     * @param endTime              结束时间
     * @param pid                  所选的项目id,如果是从查看搜索跳转过来的页面需要将这个值给传过来(如果当前值为空 则uid一定不为空)
     * @param proName              如果是从查看搜索跳转过来的页面并且选择了项目 则需要将项目名称给传过来
     * @param uid                  所选的成员id,如果是从查看搜索跳转过来的页面需要将这个值给传过来(如果当前值为空 则pid一定不为空)
     * @param userName             如果是从查看搜索跳转过来的页面并且选择了成员 则需要将成员名称给传过来
     * @param account_ids          已选的记账类型ids,用逗号隔开比如 1,2,3,4 如果是从查看搜索跳转过来的页面需要将这个值给传过来(可以为空)
     * @param search_type          private static final int TYPE_FROM_PROJECT = 1;班组长角色:按项目查看
     *                             private static final int TYPE_FROM_WORKER = 2;  班组长角色:按工人查看
     *                             private static final int TYPE_FROM_FOREMAN = 3;工人角色:按班组长查看
     * @param classTypeId
     * @param classType            工人、班组长传person,项目project
     * @param isShowFilterBtn      是否显示搜索按钮 这个参数暂时已经没有使用了，传不传都可以
     * @param isFromSyncToMe       true表示是从同步给我的进去的 如果是从同步给我的项目跳转进来的 这里需要特殊处理一下 传一个uid
     * @param fromSyncUid          true表示是从同步给我的进去的 如果是从同步给我的项目跳转进来的 传这个uid
     * @param canClickPersonFilter true表示可以 筛选里面的人员
     * @param canClickProFilter    true表示可以 筛选里面的项目
     * @param context
     */
    public static void actionStart(Activity context, String startTime, String endTime, String pid, String proName, String uid, String userName, String account_ids, int search_type,
                                   String classTypeId, String classType, boolean isShowFilterBtn, boolean isFromSyncToMe, String fromSyncUid, boolean canClickPersonFilter, boolean canClickProFilter) {
        Intent intent = new Intent(context, StatisticalWorkSecondActivity.class);
        intent.putExtra(Constance.STARTTIME_STRING, startTime);
        intent.putExtra(Constance.ENDTIME_STRING, endTime);
        intent.putExtra(Constance.PID, pid);
        intent.putExtra(Constance.PROJECTNAME, proName);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.ACCOUNT_TYPE, account_ids);
        intent.putExtra("search_type", search_type);
        intent.putExtra("class_type_id", classTypeId);
        intent.putExtra("class_type", classType);
        intent.putExtra("is_show_filter_btn", isShowFilterBtn);
        intent.putExtra("is_from_sync_to_me", isFromSyncToMe);
        intent.putExtra("from_sync_to_me_uid", fromSyncUid);
        intent.putExtra("can_click_person_filter", canClickPersonFilter);
        intent.putExtra("can_click_pro_filter", canClickProFilter);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistical_work_new);
        initView();
        setDate();
        getData();
    }

    private SpannableStringBuilder setMoneyViewAttritube(String completeString, String changeString, int textColor) {
        Pattern p = Pattern.compile(changeString);
        SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
        Matcher telMatch = p.matcher(completeString);
        while (telMatch.find()) {
            ForegroundColorSpan redSpan = new ForegroundColorSpan(textColor);
//            builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
            builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            builder.setSpan(new AbsoluteSizeSpan(DensityUtils.sp2px(getApplicationContext(), 12)), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        return builder;
    }

    /**
     * 检查开始时间是否大于结束时间
     *
     * @param yearOfFirstDay
     */
    private boolean checkStartTimeIsGtEndTime(Calendar yearOfFirstDay) {
        String[] date = endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")).split("-");
        Calendar endTimeCalendar = Calendar.getInstance();
        endTimeCalendar.set(Calendar.YEAR, Integer.parseInt(date[0]));
        endTimeCalendar.set(Calendar.MONTH, Integer.parseInt(date[1]) - 1);
        endTimeCalendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(date[2]));
        if (yearOfFirstDay.getTimeInMillis() > endTimeCalendar.getTimeInMillis()) {
            return true;
        }
        return false;
    }


    /**
     * 设置默认开始时间
     * 默认为今年的第一天 也就是大年初一
     */
    private void setDefaultStartTime() {
        Calendar yearOfFirstDayCalendar = DatePickerUtil.getCurrYearFirst(); //获取当前年的第一天 比如2018年 的1月1日
        int[] date = DatePickerUtil.lunarToSolar(yearOfFirstDayCalendar.get(Calendar.YEAR), yearOfFirstDayCalendar.get(Calendar.MONTH) + 1, yearOfFirstDayCalendar.get(Calendar.DAY_OF_MONTH)); //将农历日期转为公历日期
        Calendar yearOfFirstDay = DatePickerUtil.strongYearMonthDayToCalendar(date); //获取转换后的公历Calendar 获取的就是新年的第一天时间
        //如果开始时间默认为新的一年也就是 从1月到2月过年之间  需要将开始时间提前移一年
        if (checkStartTimeIsGtEndTime(yearOfFirstDay)) {
            yearOfFirstDay = DatePickerUtil.strongYearMonthDayToCalendar(DatePickerUtil.lunarToSolar(yearOfFirstDayCalendar.get(Calendar.YEAR) - 1,
                    yearOfFirstDayCalendar.get(Calendar.MONTH) + 1, yearOfFirstDayCalendar.get(Calendar.DAY_OF_MONTH)));
        }
        int year = yearOfFirstDay.get(Calendar.YEAR);
        int monthOfYear = yearOfFirstDay.get(Calendar.MONTH);
        int dayOfMonth = yearOfFirstDay.get(Calendar.DAY_OF_MONTH);
        String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
        String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
        String defaultStartTime = year + "-" + month + "-" + day; //获取默认开始时间
        String defaultStartLuncher = DateUtil.getLunarDate(year, monthOfYear + 1, dayOfMonth);//默认开始时间的农历
        startTime.setText(getTimeHtml(defaultStartTime, defaultStartLuncher));
        drawerChildLayout.setStartTime(defaultStartTime, defaultStartLuncher, yearOfFirstDay.getTimeInMillis());
    }

    private Spanned getTimeHtml(String timeString, String timeLuncher) {
        return Html.fromHtml("<font color='#333333'>" + timeString + "</font><font color='#666666'>" + timeLuncher + "</font>");
    }

    /**
     * 设置默认结束时间
     * 默认为今天的时间
     */
    private void setDefaultEndTime() {
        Calendar calendar = DatePickerUtil.getTodayDate();
        int year = calendar.get(Calendar.YEAR);
        int monthOfYear = calendar.get(Calendar.MONTH);
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
        String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
        String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
        String defaultEndTime = year + "-" + month + "-" + day; //获取默认结束时间
        String defaultEndLuncher = DateUtil.getLunarDate(year, monthOfYear + 1, dayOfMonth); //默认结束时间的农历
        endTime.setText(getTimeHtml(defaultEndTime, defaultEndLuncher));
        drawerChildLayout.setEndTime(defaultEndTime, defaultEndLuncher, calendar.getTimeInMillis());
    }


    private void initDrawerLayout() {
        Intent intent = getIntent();
        final RadioButton radioButton = findViewById(R.id.filterBtn);
        drawerChildLayout = findViewById(R.id.drawerChildLayout);
        boolean is_show_filter_btn = intent.getBooleanExtra("is_show_filter_btn", true);
        is_show_filter_btn = true;
        if (is_show_filter_btn) {

            drawerChildLayout.setCanClickPerson(intent.getBooleanExtra("can_click_person_filter", true));
            drawerChildLayout.setCanClickPro(intent.getBooleanExtra("can_click_pro_filter", true));

            drawerChildLayout.setFilterSelectInterFace(new StatisticalDrawerLayout.FilterSelectInterFace() {
                @Override
                public void FilterConfirm(String startTimeValue, String endTimeValue, String startTimeLuncherValue, String endTimeLuncherValue) { //确认按钮
                    drawer.closeDrawers();
                    startTime.setText(getTimeHtml(startTimeValue, startTimeLuncherValue));
                    endTime.setText(getTimeHtml(endTimeValue, endTimeLuncherValue));
                    accountIds = drawerChildLayout.getAccount_type();
                    handlerFilter();
                }

                @Override
                public void FilterClose() { //关闭按钮
                    drawer.closeDrawers();
                    radioButton.setChecked(true);
                }
            });
            drawerChildLayout.setActivity(this);
            drawer = (DrawerLayout) findViewById(R.id.drawerLayout);
            drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED, Gravity.RIGHT);
            drawer.addDrawerListener(new DrawerLayout.SimpleDrawerListener() {

                private boolean isFirstOpen = true;

                @Override
                public void onDrawerOpened(View drawerView) {
                    //档DrawerLayout打开时，让整体DrawerLayout布局可以响应点击事件
                    drawerView.setClickable(true);

                    if (!isFirstOpen) {
                        String mStartTimeValue = startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("("));
                        String mEndTimeValue = endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("("));

                        String[] mStartDates = mStartTimeValue.split("-"); //获取开始时间
                        if (mStartDates != null && mStartDates.length == 3) {
                            int year = Integer.parseInt(mStartDates[0]);
                            int month = Integer.parseInt(mStartDates[1]);
                            int day = Integer.parseInt(mStartDates[2]);
                            String luncher = DateUtil.getLunarDate(year, month, day);
                            drawerChildLayout.setStartTime(mStartTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
                        }
                        String[] mEndDates = mEndTimeValue.split("-"); //获取结束时间
                        if (mEndDates != null && mEndDates.length == 3) {
                            int year = Integer.parseInt(mEndDates[0]);
                            int month = Integer.parseInt(mEndDates[1]);
                            int day = Integer.parseInt(mEndDates[2]);
                            String luncher = DateUtil.getLunarDate(year, month, day);
                            drawerChildLayout.setEndTime(mEndTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
                        }
                        drawerChildLayout.setAccountIds(accountIds);
                        drawerChildLayout.setPidAndProjectName(pid, proName);
                        drawerChildLayout.setUidAndName(uid, userName);
                        LUtils.e("设置弹框值");
                    }
                    isFirstOpen = false;
                }

                @Override
                public void onDrawerClosed(View drawerView) {
                    super.onDrawerClosed(drawerView);
                }
            });
            String pid = intent.getStringExtra(Constance.PID);
            String proName = intent.getStringExtra(Constance.PROJECTNAME);
            String userName = intent.getStringExtra(Constance.USERNAME);
            String uid = intent.getStringExtra(Constance.UID);
            String accountIds = intent.getStringExtra(Constance.ACCOUNT_TYPE);
            this.accountIds = accountIds;
            this.pid = pid;
            this.proName = proName;
            this.uid = uid;
            this.userName = userName;
            drawerChildLayout.setAccountIds(accountIds); //初始化上个页面已选的筛选条件 有可能为null
            drawerChildLayout.setPidAndProjectName(pid, proName);//初始化上个页面已选的筛选条件 有可能为null
            drawerChildLayout.setUidAndName(uid, userName);//初始化上个页面已选的筛选条件 有可能为null

            radioButton.setChecked(true);
        } else {
            radioButton.setVisibility(View.GONE);
        }
    }

    private void initView() {
        setTextTitleAndRight(R.string.statistical_work, R.string.more);

//        ImageView rightImageView = getImageView(R.id.rightImage);
//        rightImageView.setImageResource(R.drawable.red_dots);
//        rightImageView.setVisibility(View.VISIBLE);
//        rightImageView.setOnClickListener(this);

        startTime = getTextView(R.id.start_time_value_text);
        endTime = getTextView(R.id.end_time_value_text);

        own_pro_text = getTextView(R.id.own_pro_text);
        own_pro_value_text = getTextView(R.id.own_pro_value_text);
        work_name_text = getTextView(R.id.work_name_text);
        work_name_value_text = getTextView(R.id.work_name_value_text);
        record_type_text = getTextView(R.id.record_type_text);
        record_type_value_text = getTextView(R.id.record_type_value_text);


        work_name_text.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.work_name : R.string.foreman_name);


        final View headView = getLayoutInflater().inflate(R.layout.statistical_work_second_head, null); // 加载对话框

        ((TextView) (headView.findViewById(R.id.defaultDesc))).setText("未搜索到相关内容");
        defalutView = headView.findViewById(R.id.defaultLayout);
        titleLayout = headView.findViewById(R.id.titleLayout);

        littleWorkAmount = (TextView) headView.findViewById(R.id.littleWorkAmount);
        contractorWorkTwoAmount = (TextView) headView.findViewById(R.id.contractorWorkTwoAmount);
        contractorWorkOneAmount = (TextView) headView.findViewById(R.id.contractorWorkOneAmount);

        TextView contractorWorkTwoAmountText = (TextView) headView.findViewById(R.id.contractorWorkTwoAmountText);
        TextView contractorWorkOneAmountText = (TextView) headView.findViewById(R.id.contractorWorkOneAmountText);

        View contractorWorkCount = headView.findViewById(R.id.contractorWorkCount);
        // 班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
        // 4、工人角色：工人只有包工（承包），算收入红色显示
        if (UclientApplication.isForemanRoler(getApplicationContext())) {
            contractorWorkTwoAmount.setVisibility(View.VISIBLE);
            contractorWorkTwoAmountText.setVisibility(View.VISIBLE);

            contractorWorkOneAmount.setVisibility(View.VISIBLE);
            contractorWorkOneAmountText.setVisibility(View.VISIBLE);
            contractorWorkCount.setVisibility(View.INVISIBLE);

            Drawable mClearDrawable = getResources().getDrawable(R.drawable.green_circle_icon);
            mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
            contractorWorkOneAmountText.setCompoundDrawables(mClearDrawable, null, null, null);

            contractorWorkOneAmount.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.borrow_color));
            contractorWorkTwoAmount.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
        } else {
            contractorWorkTwoAmount.setVisibility(View.GONE);
            contractorWorkTwoAmountText.setVisibility(View.GONE);

            contractorWorkOneAmount.setVisibility(View.VISIBLE);
            contractorWorkOneAmountText.setVisibility(View.VISIBLE);
            contractorWorkCount.setVisibility(View.GONE);

            contractorWorkOneAmount.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));

            Drawable mClearDrawable = getResources().getDrawable(R.drawable.red_circle_icon);
            mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
            contractorWorkOneAmountText.setCompoundDrawables(mClearDrawable, null, null, null);

        }


        borrowAmount = (TextView) headView.findViewById(R.id.borrowAmount);
        balanceAmount = (TextView) headView.findViewById(R.id.balanceAmount);
        manhour = (TextView) headView.findViewById(R.id.manhour);
        overTime = (TextView) headView.findViewById(R.id.overTime);
        borrowTotal = (TextView) headView.findViewById(R.id.borrowTotal);
        balanceTotal = (TextView) headView.findViewById(R.id.balanceTotal);

        itemTitleName = (TextView) headView.findViewById(R.id.itemTitleName);
        final ListView listView = (ListView) findViewById(R.id.listView);
        listView.addHeaderView(headView, null, false); //添加头部文件

        radioBtnLeftIcon = headView.findViewById(R.id.leftIcon);
        radioBtnRightIcon = headView.findViewById(R.id.rightIcon);
        leftRadioBtn = (RadioButton) headView.findViewById(R.id.leftBtn);
        rightRadioBtn = (RadioButton) headView.findViewById(R.id.rightBtn);

        startTime.setOnClickListener(this);
        endTime.setOnClickListener(this);

        NestRadioGroup radioBtnGroup = (NestRadioGroup) headView.findViewById(R.id.radioBtnGroup);
        radioBtnGroup.setOnCheckedChangeListener(new NestRadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(NestRadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.leftBtn:
                        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
                            return;
                        }
                        current_selecte_flag = SELECTE_LEFT_BTN_FLAG;
                        changeState(0);
                        getData();
                        break;
                    case R.id.rightBtn:
                        if (current_selecte_flag == SELECTE_RIGHT_BTN_FLAG) {
                            return;
                        }
                        current_selecte_flag = SELECTE_RIGHT_BTN_FLAG;
                        changeState(0);
                        getData();
                        break;
                }
            }
        });
        initRadioBtn();
        initDrawerLayout();
        listView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() {
                //动态计算默认页的高度
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                View layout = defalutView;
                ViewGroup.LayoutParams params = (ViewGroup.LayoutParams) layout.getLayoutParams();
                params.height = listView.getHeight() - GuideUtils.getMeasuredHeight(headView);
                layout.setLayoutParams(params);
                if (Build.VERSION.SDK_INT < 16) {
                    listView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
        View endTimeLayout = findViewById(R.id.time_layout);
        LinearLayout.LayoutParams layoutParamsValue = (LinearLayout.LayoutParams) endTimeLayout.getLayoutParams();
        layoutParamsValue.bottomMargin = DensityUtil.dp2px(10);
        endTimeLayout.setLayoutParams(layoutParamsValue);
    }


    private void initRadioBtn() {
        searchType = getIntent().getIntExtra("search_type", TYPE_FROM_PROJECT);
        leftRadioBtn.setText("按月份统计");
        switch (searchType) {
            case TYPE_FROM_PROJECT: //班组长角色点击列表按项目查看
                current_selecte_flag = SELECTE_RIGHT_BTN_FLAG;
                rightRadioBtn.setText("按姓名统计");
                break;
            case TYPE_FROM_WORKER: //班组长角色点击列表按工人查看
                rightRadioBtn.setText("按项目统计");
                break;
            case TYPE_FROM_FOREMAN://工人角色点击列表按班组长查看
                rightRadioBtn.setText("按项目统计");
                break;
        }
        changeState(0);
    }

    private void setDate() {
        Intent intent = getIntent();
        //如果在请求这个页面时 传了结束时间过来的话 则默认取这个时间
        String endTimeValue = intent.getStringExtra(Constance.ENDTIME_STRING);
        if (!TextUtils.isEmpty(endTimeValue)) {
            String[] dates = endTimeValue.split("-");
            if (dates != null && dates.length == 3) {
                int year = Integer.parseInt(dates[0]);
                int month = Integer.parseInt(dates[1]);
                int day = Integer.parseInt(dates[2]);

                String luncher = DateUtil.getLunarDate(year, month, day);
                endTime.setText(getTimeHtml(endTimeValue, luncher));
                drawerChildLayout.setEndTime(endTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
            }
        } else {
            setDefaultEndTime();
        }
        //如果在请求这个页面时 传了开始时间过来的话 则默认取这个时间
        String startTimeValue = intent.getStringExtra(Constance.STARTTIME_STRING);
        if (!TextUtils.isEmpty(startTimeValue)) {
            String[] dates = startTimeValue.split("-");
            if (dates != null && dates.length == 3) {
                int year = Integer.parseInt(dates[0]);
                int month = Integer.parseInt(dates[1]);
                int day = Integer.parseInt(dates[2]);

                String luncher = DateUtil.getLunarDate(year, month, day);
                startTime.setText(getTimeHtml(startTimeValue, luncher));
                drawerChildLayout.setStartTime(startTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
            }
        } else {
            setDefaultStartTime();
        }
    }


    /**
     * 切换状态 个人和项目状态
     *
     * @param count
     */
    private void changeState(int count) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            leftRadioBtn.setChecked(true);
            radioBtnLeftIcon.setVisibility(View.VISIBLE);
            radioBtnRightIcon.setVisibility(View.GONE);
        } else {
            rightRadioBtn.setChecked(true);
            radioBtnLeftIcon.setVisibility(View.GONE);
            radioBtnRightIcon.setVisibility(View.VISIBLE);
        }
        setItemName(count);
    }


    private void setItemName(int count) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            itemTitleName.setText("月份");
        } else {
            switch (searchType) {
                case TYPE_FROM_FOREMAN://班组长角色点击按项目
                    itemTitleName.setText(count == 0 ? "项目" : "项目(" + count + "个)");
                    break;
                case TYPE_FROM_WORKER://班组长角色点击按工人
                    itemTitleName.setText(count == 0 ? "项目" : "项目(" + count + "个)");
                    break;
                case TYPE_FROM_PROJECT://工人角色点击按班组长
                    itemTitleName.setText(count == 0 ? "姓名" : "姓名(" + count + "人)");
                    break;
            }
        }
    }


    /**
     * 查询记工统计
     */
    public void getData() {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) { //查询按月统计
            getDataByDate(false);
        } else {
            getDataByProjectOrPerson(false);
        }
    }

    /**
     * 查询记工统计按月份统计
     *
     * @param isDown true表示下载记工统计账单
     */
    public void getDataByDate(final boolean isDown) {
        String httpUrl = NetWorkRequest.WORK_MONTH_RECORD_STATISTICS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("("))); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("("))); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type", getIntent().getStringExtra("class_type")); //	个人person(默认),项目project
        params.addBodyParameter("class_type_id", getIntent().getStringExtra("class_type_id")); //数据id
        if (getIntent().getBooleanExtra("is_from_sync_to_me", false)) { //如果是从工作消息里面进来的还需要传递 uid
            params.addBodyParameter("uid", getIntent().getStringExtra("from_sync_to_me_uid")); //数据id
        }
        if (!TextUtils.isEmpty(accountIds)) { //记账类型
            params.addBodyParameter("accounts_type", accountIds);
        }
        if (isDown) {
            params.addBodyParameter("is_down", "1"); //下载标识
        }
        CommonHttpRequest.commonRequest(this, httpUrl, isDown ? Repository.class : StatisticalWork.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (isDown) {
                    Repository repository = (Repository) object;
                    //文件名称、文件下载路径、文件类型都不能为空
                    if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
                        DownLoadExcelActivity.actionStart(StatisticalWorkSecondActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
//                        AccountUtils.downLoadAccount(StatisticalWorkSecondActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                    }
                } else {
                    StatisticalWork statisticalWork = (StatisticalWork) object;
                    setAdapter(statisticalWork.getMonth_list());
                    fillData(statisticalWork, statisticalWork.getMonth_list().size());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 查询记工统计按项查看、或按班组、工人查看
     *
     * @param isDown true表示下载记工统计账单
     */
    public void getDataByProjectOrPerson(final boolean isDown) {
        String httpUrl = NetWorkRequest.WORK_PERSON_RECORD_STATISTICS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("("))); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("("))); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type_id", getIntent().getStringExtra("class_type_id")); //项目组id
        params.addBodyParameter("class_type", getIntent().getStringExtra("class_type")); //	个人person(默认),项目project
        if (getIntent().getBooleanExtra("is_from_sync_to_me", false)) { //如果是从工作消息里面进来的还需要传递 uid
            params.addBodyParameter("uid", getIntent().getStringExtra("from_sync_to_me_uid")); //数据id
        }
        if (!TextUtils.isEmpty(accountIds)) { //记账类型
            params.addBodyParameter("accounts_type", accountIds);
        }
        if (isDown) {
            params.addBodyParameter("is_down", "1"); //下载标识
        }
        CommonHttpRequest.commonRequest(this, httpUrl, isDown ? Repository.class : StatisticalWork.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (isDown) {
                    Repository repository = (Repository) object;
                    //文件名称、文件下载路径、文件类型都不能为空
                    if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
//                        AccountUtils.downLoadAccount(StatisticalWorkSecondActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                        DownLoadExcelActivity.actionStart(StatisticalWorkSecondActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                    }
                } else {
                    StatisticalWork statisticalWork = (StatisticalWork) object;
                    setAdapter(statisticalWork.getMonth_list());
                    fillData(statisticalWork, statisticalWork.getMonth_list().size());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 填充列表数据
     *
     * @param statisticalWork
     */
    private void fillData(StatisticalWork statisticalWork, int listCount) {
        setItemName(listCount);

        String mLittleWorkAmount = statisticalWork.getWork_type().getAmounts(); //点工金额
        String mContractorWorkOneAmount = statisticalWork.getContract_type_one().getAmounts(); //包工(承包)金额
        String mContractorWorkTwoAmount = statisticalWork.getContract_type_two().getAmounts(); //包工(分包)金额

        String mBorrowAmount = statisticalWork.getExpend_type().getAmounts(); //借支金额
        String mBalanceAmount = statisticalWork.getBalance_type().getAmounts(); //结算金额

        String mBorrowTotal = String.format(getString(R.string.borrow_params), (int) statisticalWork.getExpend_type().getTotal()); //借支笔数
        String mBalanceTotal = String.format(getString(R.string.balance_params), (int) statisticalWork.getBalance_type().getTotal()); //结算笔数


        littleWorkAmount.setText(mLittleWorkAmount);

        //班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
        //4、工人角色：工人只有包工（承包），算收入红色显示
        if (UclientApplication.isForemanRoler(getApplicationContext())) {
            contractorWorkTwoAmount.setText(mContractorWorkTwoAmount);
            contractorWorkOneAmount.setText(mContractorWorkOneAmount);
        } else {
            contractorWorkOneAmount.setText(mContractorWorkOneAmount);
        }

        borrowAmount.setText(mBorrowAmount);
        balanceAmount.setText(mBalanceAmount);

        borrowTotal.setText(setMoneyViewAttritube(mBorrowTotal, ((int) statisticalWork.getExpend_type().getTotal()) + "", Color.parseColor("#83c76e")));
        balanceTotal.setText(setMoneyViewAttritube(mBalanceTotal, ((int) statisticalWork.getBalance_type().getTotal()) + "", Color.parseColor("#83c76e")));

        //工为单位的字段(这里计算的是点工+包工记工天的和)
        String totalManhourAsWork = RecordUtils.cancelIntergerZeroFloat(Utils.m2(Float.parseFloat(statisticalWork.getWork_type().getWorking_hours()) +
                Float.parseFloat(statisticalWork.getAttendance_type().getWorking_hours())));
        String totalOverTimeAsWork = RecordUtils.cancelIntergerZeroFloat(Utils.m2(Float.parseFloat(statisticalWork.getWork_type().getOvertime_hours()) +
                Float.parseFloat(statisticalWork.getAttendance_type().getOvertime_hours())));

        //小时为单位的字段(这里计算的是点工+包工记工天的和)
        String totalManhourAsHour = RecordUtils.cancelIntergerZeroFloat(Utils.m2(statisticalWork.getWork_type().getManhour() + statisticalWork.getAttendance_type().getManhour()));
        String totalOverTimeAsHour = RecordUtils.cancelIntergerZeroFloat(Utils.m2(statisticalWork.getWork_type().getOvertime() + statisticalWork.getAttendance_type().getOvertime()));

        String manhourCompleteString = AccountUtil.getAccountShowTypeString(this, true, true, true,
                Float.parseFloat(totalManhourAsHour), totalManhourAsWork);
        String overTimeCompleteString = AccountUtil.getAccountShowTypeString(this, true, true, false,
                Float.parseFloat(totalOverTimeAsHour), totalOverTimeAsWork);
        String manhourValue = null;
        String overTimeValue = null;
        switch (AccountUtil.getDefaultAccountUnit(getApplicationContext())) {
            case AccountUtil.WORK_AS_UNIT: //以工为单位
                manhourValue = totalManhourAsWork;
                overTimeValue = totalOverTimeAsWork;
                break;
            case AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //上班显示工，加班显示小时
                manhourValue = totalManhourAsWork;
                overTimeValue = totalOverTimeAsHour;
                break;
            case AccountUtil.WORK_OF_HOUR:
                manhourValue =totalManhourAsHour;
                overTimeValue = totalOverTimeAsHour;
                break;
        }

        LUtils.e("manhourCompleteString:" + totalManhourAsHour + "             manhourValue:" + manhourValue);
        manhour.setText(setMoneyViewAttritube(manhourCompleteString, manhourValue, Color.parseColor("#eb4e4e"))); //设置上班时长
        overTime.setText(setMoneyViewAttritube(overTimeCompleteString, overTimeValue, Color.parseColor("#eb4e4e"))); //设置加班时长
        this.statisticalWork = statisticalWork;

        String proName = statisticalWork.getPro_name();
        String userName = statisticalWork.getName();
        String accountTypeName = statisticalWork.getAccounts_type_name();
        if (!TextUtils.isEmpty(proName)) {
            own_pro_text.setVisibility(View.VISIBLE);
            own_pro_value_text.setVisibility(View.VISIBLE);
            own_pro_value_text.setText(proName);
        } else {
            own_pro_text.setVisibility(View.GONE);
            own_pro_value_text.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(userName)) {
            work_name_text.setVisibility(View.VISIBLE);
            work_name_value_text.setVisibility(View.VISIBLE);
            work_name_value_text.setText(userName);
        } else {
            work_name_text.setVisibility(View.GONE);
            work_name_value_text.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(accountTypeName)) {
            record_type_text.setVisibility(View.VISIBLE);
            record_type_value_text.setVisibility(View.VISIBLE);
            record_type_value_text.setText(accountTypeName);
        } else {
            record_type_text.setVisibility(View.GONE);
            record_type_value_text.setVisibility(View.GONE);
        }
    }


    /**
     * 设置记工统计数据
     *
     * @param list
     */
    private void setAdapter(final List<StatisticalWork> list) {
        defalutView.setVisibility(list != null && !list.isEmpty() ? View.GONE : View.VISIBLE);
        titleLayout.setVisibility(list != null && !list.isEmpty() ? View.VISIBLE : View.GONE);
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new StatisticalWorkAdapter(this, list, false, true, true);
            adapter.setAccountIds(accountIds);
//            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position -= listView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    StatisticalWork statisticalWork = adapter.getList().get(position);
                    String classType = getIntent().getStringExtra("class_type"); //个人person(默认),项目project
                    //如果是从同步给我的项目跳转进来的 则不能点进技工流水页面
                    boolean isFromSyncToMe = getIntent().getBooleanExtra("is_from_sync_to_me", false);
                    switch (current_selecte_flag) {
                        case SELECTE_LEFT_BTN_FLAG://如果当前是月份统计 点击列表则直接跳转到流水详情
                            try {
                                String date = DateUtil.dateFormat(statisticalWork.getDate());
                                String year = date.substring(0, date.indexOf("-"));
                                String month = date.substring(date.indexOf("-") + 1);
                                String accountIds = getIntent().getStringExtra(Constance.ACCOUNT_TYPE);
                                if (!TextUtils.isEmpty(classType) && classType.equals("project")) { //按项目
                                    RememberWorkerInfosActivity.actionStart(StatisticalWorkSecondActivity.this, year, month,
                                            null, null, statisticalWork.getClass_type_id(), statisticalWork.getTarget_name(), UclientApplication.getRoler(getApplicationContext()),
                                            accountIds, true, isFromSyncToMe, isFromSyncToMe, isFromSyncToMe); //项目名称或人名);
                                } else { //按人
                                    RememberWorkerInfosActivity.actionStart(StatisticalWorkSecondActivity.this, year, month,
                                            statisticalWork.getClass_type_id(), statisticalWork.getTarget_name(), null, null, UclientApplication.getRoler(getApplicationContext()),
                                            accountIds, true, isFromSyncToMe, isFromSyncToMe, isFromSyncToMe); //项目名称或人名);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            break;
                        case SELECTE_RIGHT_BTN_FLAG: //如果是按班组长、按项目、工人统计还需要跳转到根据月份或日期查看的页面
                            if (classType.equals("person")) {
                                StatisticalWorkThirdActivity.actionStart(
                                        StatisticalWorkSecondActivity.this,
                                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                                        classType,
//                                        getIntent().getStringExtra(Constance.USERNAME),
//                                        getIntent().getStringExtra(Constance.UID),
                                        drawerChildLayout.getName(),
                                        drawerChildLayout.getUid(),
                                        null, true, statisticalWork.getClass_type_target_id(), accountIds,
                                        statisticalWork.getTarget_name(), isFromSyncToMe);
                            } else {
                                StatisticalWorkThirdActivity.actionStart(
                                        StatisticalWorkSecondActivity.this,
                                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                                        classType,
//                                        getIntent().getStringExtra(Constance.PROJECTNAME),
//                                        getIntent().getStringExtra(Constance.PID),
                                        drawerChildLayout.getProjectName(),
                                        drawerChildLayout.getPid(),
                                        //如果是从同步给我的项目跳转进来的 这里需要特殊处理一下 传一个uid
                                        isFromSyncToMe ? getIntent().getStringExtra("from_sync_to_me_uid") : null, isFromSyncToMe ? false : true, statisticalWork.getClass_type_target_id(), accountIds,
                                        statisticalWork.getTarget_name(), isFromSyncToMe);
                            }
                            break;
                    }
                }
            });
        } else {
            adapter.setAccountIds(accountIds);
            adapter.updateListView(list);
        }
    }


    public List<SingleSelected> getItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber("1"));
        list.add(new SingleSelected("下载", getString(R.string.hint_wps), false, true,
                "DOWNLOAD", Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "1": //切换记工显示方式
                                AccountShowTypeActivity.actionStart(StatisticalWorkSecondActivity.this);
                                break;
                            case "DOWNLOAD": //下载
                                if (adapter == null || adapter.getCount() == 0) {
                                    CommonMethod.makeNoticeShort(getApplicationContext(), "没有可下载的数据", CommonMethod.ERROR);
                                    return;
                                }
                                if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) { //查询按月统计
                                    getDataByDate(true);
                                } else {
                                    getDataByProjectOrPerson(true);
                                }
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.time_layout:
            case R.id.filterBtn:
                drawer.openDrawer(GravityCompat.END);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //如果工显示方式已经被切换 则需要将数据变化了
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            fillData(statisticalWork, statisticalWork != null && statisticalWork.getMonth_list() != null ?
                    statisticalWork.getMonth_list().size() : null);
            adapter.notifyDataSetChanged();
        }
        setResult(Constance.REFRESH);
        getData();
    }


    private void handlerFilter() {
        //如果是从同步给我的项目跳转进来的 则不能点进技工流水页面
        boolean isFromSyncToMe = getIntent().getBooleanExtra("is_from_sync_to_me", false);
        if (!TextUtils.isEmpty(drawerChildLayout.getPid()) && !TextUtils.isEmpty(drawerChildLayout.getUid())) {
            //搜索条件：[选择项目]和[选择工人]2个如果同时都选择有数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的界面显示页面为“按月统计(可切换为按天统计）”；
            StatisticalWorkThirdActivity.actionStart(StatisticalWorkSecondActivity.this,
                    startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                    endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                    "person",
                    drawerChildLayout.getName(),
                    drawerChildLayout.getUid(),
                    isFromSyncToMe ? getIntent().getStringExtra("from_sync_to_me_uid") : null, isFromSyncToMe ? false : true,
                    drawerChildLayout.getPid(), accountIds, drawerChildLayout.getProjectName(), isFromSyncToMe);
        } else if (!TextUtils.isEmpty(drawerChildLayout.getUid())) {
            uid = drawerChildLayout.getUid();
            userName = drawerChildLayout.getName();
            pid = null;
            proName = null;
            //搜索条件：[选择项目]没有数据且[选择工人]有选择的数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的结果显示页面为“记工统计-按工人查看2级页面-按月份统计”；
            Intent intent = getIntent();
            intent.putExtra("search_type", UclientApplication.isForemanRoler(getApplicationContext()) ? StatisticalWorkSecondActivity.TYPE_FROM_WORKER : StatisticalWorkSecondActivity.TYPE_FROM_FOREMAN);
            intent.putExtra("class_type", "person");
            intent.putExtra("class_type_id", drawerChildLayout.getUid());
            initRadioBtn();
            getData();
        } else if (!TextUtils.isEmpty(drawerChildLayout.getPid())) {
            String roler = UclientApplication.getRoler(getApplicationContext());
            if (roler.equals(Constance.ROLETYPE_FM)) {
                uid = null;
                userName = null;
                pid = drawerChildLayout.getPid();
                proName = drawerChildLayout.getProjectName();

                //搜索条件：[选择项目]有选择的数据且[选择工人]没有选择任何数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的结果显示页面为“记工统计-按项目查看2级页面-按工人统计”；
                Intent intent = getIntent();
                intent.putExtra("search_type", StatisticalWorkSecondActivity.TYPE_FROM_PROJECT);
                intent.putExtra("class_type", "project");
                intent.putExtra("class_type_id", drawerChildLayout.getPid());
                initRadioBtn();
                getData();
            } else {
                //如果是从同步给我的项目跳转进来的 则不能点进技工流水页面
                StatisticalWorkThirdActivity.actionStart(StatisticalWorkSecondActivity.this,
                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                        "project",
                        drawerChildLayout.getProjectName(),
                        drawerChildLayout.getPid(),
                        isFromSyncToMe ? getIntent().getStringExtra("from_sync_to_me_uid") : null, isFromSyncToMe ? false : true, null,
                        accountIds, null, isFromSyncToMe);
            }
        } else {
            //搜索条件只选择[开始结束时间]或者只选择了[记工分类]](选择项目和选择工人都没有选择任何数据），点击【确定】后，搜索出的结果显示页面为记工统计首页按项目查看界面；
            Intent intent = getIntent();
            intent.putExtra(Constance.STARTTIME_STRING, startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")));
            intent.putExtra(Constance.ENDTIME_STRING, endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")));
            intent.putExtra(Constance.ACCOUNT_TYPE, accountIds);
            setResult(0X100, intent);
            finish();
        }
    }


}
