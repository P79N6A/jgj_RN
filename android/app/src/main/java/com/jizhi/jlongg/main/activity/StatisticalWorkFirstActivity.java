package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.higuide.GuideUtils;
import com.jizhi.jlongg.main.adpter.StatisticalWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.dialog.StatisticalDialog;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
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

/**
 * 功能: 记工统计
 * 作者：Xuj
 * 时间: 2018年9月26日16:05:09
 */
public class StatisticalWorkFirstActivity extends BaseActivity implements View.OnClickListener {
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
     * 当前选中的状态   person 按个人  project:按项目  默认选择为个人
     */
    private int current_selecte_flag = SELECTE_LEFT_BTN_FLAG;
    /**
     * 开始日期,结束日期
     */
    private TextView startTime, endTime;
    /**
     * 筛选点击确认后需要调用的记账id
     */
    private String accountIds;
    /**
     * 标题名称
     */
    private TextView itemTitleName;
    /**
     * 记工统计适配器
     */
    private StatisticalWorkAdapter adapter;
    /**
     * 主要是当切换点工显示方式时候直接使用 不用在查询服务器
     */
    private StatisticalWork statisticalWork;
    /**
     * 侧滑菜单布局
     */
    private DrawerLayout drawer;
    /**
     * 侧滑菜单弹出布局
     */
    private StatisticalDrawerLayout drawerChildLayout;
    /**
     * 筛选条件
     */
    private RadioButton filterBtn;
    /**
     * 当没有数据时展示的页面, item标题
     */
    private View defalutView, titleLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, StatisticalWorkFirstActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 启动当前Activity
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param context
     */
    public static void actionStart(Activity context, String startTime, String endTime) {
        Intent intent = new Intent(context, StatisticalWorkFirstActivity.class);
        intent.putExtra(Constance.STARTTIME_STRING, startTime);
        intent.putExtra(Constance.ENDTIME_STRING, endTime);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistical_work_new);
        initView();
        setDate();
        //未完善姓名不允许加载数据
        IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                getData(false);
            }
        });
    }


    private void setDate() {
        Intent intent = getIntent();
        //如果在请求这个页面时 传了结束时间过来的话 则默认取这个时间
        //否则默认为今天的时间
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
        //否则默认为今年的第一天 也就是大年初一
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
     * 则默认为今天的时间
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
        filterBtn = findViewById(R.id.filterBtn);
        drawerChildLayout = findViewById(R.id.drawerChildLayout);
        drawerChildLayout.setFilterSelectInterFace(new StatisticalDrawerLayout.FilterSelectInterFace() {
            @Override
            public void FilterConfirm(String startTimeValue, String endTimeValue, String startTimeLuncherValue, String endTimeLuncherValue) { //确认按钮
                startTime.setText(getTimeHtml(startTimeValue, startTimeLuncherValue));
                endTime.setText(getTimeHtml(endTimeValue, endTimeLuncherValue));
                accountIds = drawerChildLayout.getAccount_type();
                handlerFilter();
                drawer.closeDrawers();
            }

            @Override
            public void FilterClose() { //关闭按钮
                drawer.closeDrawers();
            }
        });
        drawerChildLayout.setActivity(this);
        drawer = (DrawerLayout) findViewById(R.id.drawerLayout);
        drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED, Gravity.RIGHT);
        drawer.addDrawerListener(new DrawerLayout.SimpleDrawerListener() {


            @Override
            public void onDrawerOpened(View drawerView) {
                //档DrawerLayout打开时，让整体DrawerLayout布局可以响应点击事件
                drawerView.setClickable(true);
            }

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
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
                drawerChildLayout.setPidAndProjectName(null, "全部项目");
                drawerChildLayout.setUidAndName(null, UclientApplication.isForemanRoler(getApplicationContext()) ? "全部工人" : "全部班组长");
                filterBtn.setChecked(drawerChildLayout.isRestoryInit() ? false : true);
            }
        });
    }

    private void initView() {
        setTextTitleAndRight(R.string.statistical_work, R.string.more);
        initDrawerLayout();
        findViewById(R.id.firstLine).setVisibility(View.GONE);

        startTime = getTextView(R.id.start_time_value_text);
        endTime = getTextView(R.id.end_time_value_text);

        final View headView = getLayoutInflater().inflate(R.layout.statistical_work_first_head, null); // 加载对话框
        ((TextView) (headView.findViewById(R.id.defaultDesc))).setText("未搜索到相关内容");
        defalutView = headView.findViewById(R.id.defaultLayout);
        titleLayout = headView.findViewById(R.id.titleLayout);
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
                        getData(false);
                        break;
                    case R.id.rightBtn:
                        if (current_selecte_flag == SELECTE_RIGHT_BTN_FLAG) {
                            return;
                        }
                        current_selecte_flag = SELECTE_RIGHT_BTN_FLAG;
                        changeState(0);
                        getData(false);
                        break;
                }
            }
        });
        //当前角色
        String currentRole = UclientApplication.getRoler(getApplicationContext());
        if (currentRole.equals(Constance.ROLETYPE_WORKER)) { //当前角色是工人
            leftRadioBtn.setText(R.string.selected_pro);
            rightRadioBtn.setText(R.string.according_name);
        } else { //工头角色
            leftRadioBtn.setText(R.string.selected_pro);
            rightRadioBtn.setText(R.string.according_name);
        }
        changeState(0);
        listView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() {
                //动态计算默认页的高度
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                View layout = defalutView;
                ViewGroup.LayoutParams params = (ViewGroup.LayoutParams) layout.getLayoutParams();
                params.height = listView.getHeight() - GuideUtils.getMeasuredHeight(headView) + DensityUtil.dp2px(35);
                layout.setLayoutParams(params);
                if (Build.VERSION.SDK_INT < 16) {
                    listView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }


    /**
     * 切换状态 个人和项目状态
     *
     * @param listViewItemCount listView总行数
     */
    private void changeState(int listViewItemCount) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            leftRadioBtn.setChecked(true);
            radioBtnLeftIcon.setVisibility(View.VISIBLE);
            radioBtnRightIcon.setVisibility(View.GONE);
        } else {
            rightRadioBtn.setChecked(true);
            radioBtnLeftIcon.setVisibility(View.GONE);
            radioBtnRightIcon.setVisibility(View.VISIBLE);
        }
        setItemName(listViewItemCount);
    }


    private void setItemName(int count) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            itemTitleName.setText(count == 0 ? "项目" : "项目(" + count + "个)");
        } else {
//            itemTitleName.setText(getString(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ?
//                    R.string.workers : R.string.foremans) + (count == 0 ? "" : "(" + count + "人)"));
            itemTitleName.setText(getString(R.string.name) + (count == 0 ? "" : "(" + count + "人)"));
        }
    }


    /**
     * 查询记工统计
     *
     * @param isDown true表示下载记工统计账单
     */
    public void getData(final boolean isDown) {
        String httpUrl = NetWorkRequest.WORK_RECORD_STATISTICS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("("))); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("("))); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type", current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? "project" : "person"); //	个人person(默认),项目project
        if (isDown) {
            params.addBodyParameter("is_down", "1"); //下载标识
        }
        if (!TextUtils.isEmpty(accountIds)) { //如果右上角的筛选按钮里面选了记账类型 需要将相应的记账类型带入
            params.addBodyParameter("accounts_type", accountIds);
        }
        CommonHttpRequest.commonRequest(this, httpUrl, isDown ? Repository.class : StatisticalWork.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (isDown) {
                    Repository repository = (Repository) object;
                    //文件名称、文件下载路径、文件类型都不能为空
                    if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
                        DownLoadExcelActivity.actionStart(StatisticalWorkFirstActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
//                        AccountUtils.downLoadAccount(StatisticalWorkFirstActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                    }
                } else {
                    StatisticalWork statisticalWork = (StatisticalWork) object;
                    setAdapter(statisticalWork.getList());
                    fillData(statisticalWork);
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
    private void fillData(StatisticalWork statisticalWork) {
        setItemName(statisticalWork.getList().size());
        this.statisticalWork = statisticalWork;
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
                    String roler = UclientApplication.getRoler(getApplicationContext());
                    StatisticalWork statisticalWork = adapter.getList().get(position);
                    String classTypeId = statisticalWork.getClass_type_id();
                    if (roler.equals(Constance.ROLETYPE_FM)) { //工头角色
                        StatisticalWorkSecondActivity.actionStart(StatisticalWorkFirstActivity.this,
                                startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                                endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                                current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? statisticalWork.getClass_type_id() : null,
                                current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? statisticalWork.getTarget_name() : null,
                                current_selecte_flag == SELECTE_RIGHT_BTN_FLAG ? statisticalWork.getClass_type_id() : null,
                                current_selecte_flag == SELECTE_RIGHT_BTN_FLAG ? statisticalWork.getTarget_name() : null,
                                accountIds, current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? StatisticalWorkSecondActivity.TYPE_FROM_PROJECT : StatisticalWorkSecondActivity.TYPE_FROM_WORKER,
                                classTypeId, current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? "project" : "person", true, false, null, true, true);
                    } else { //工人角色
                        switch (current_selecte_flag) {
                            case SELECTE_LEFT_BTN_FLAG://工人按项目查看
                                StatisticalWorkThirdActivity.actionStart(
                                        StatisticalWorkFirstActivity.this,
                                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                                        "project",
                                        statisticalWork.getTarget_name(),
                                        classTypeId, null, true, null, accountIds, null, false);
                                break;
                            case SELECTE_RIGHT_BTN_FLAG://工人按班组长查看
                                StatisticalWorkSecondActivity.actionStart(StatisticalWorkFirstActivity.this,
                                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                                        current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? statisticalWork.getClass_type_id() : null,
                                        current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? statisticalWork.getTarget_name() : null,
                                        current_selecte_flag == SELECTE_RIGHT_BTN_FLAG ? statisticalWork.getClass_type_id() : null,
                                        current_selecte_flag == SELECTE_RIGHT_BTN_FLAG ? statisticalWork.getTarget_name() : null,
                                        accountIds, StatisticalWorkSecondActivity.TYPE_FROM_FOREMAN,
                                        classTypeId, "person", true, false, null, true, true);
                                break;
                        }
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
                                AccountShowTypeActivity.actionStart(StatisticalWorkFirstActivity.this);
                                break;
                            case "DOWNLOAD": //下载
                                if (adapter == null || adapter.getCount() == 0) {
                                    CommonMethod.makeNoticeShort(getApplicationContext(), "没有可下载的数据", CommonMethod.ERROR);
                                    return;
                                }
                                getData(true);
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.statisticalTotalLayout: //查看该时间段的统计
                if (statisticalWork != null) {
                    String mStarTime = startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("("));
                    String mStartTimeLuncher = startTime.getText().toString().substring(startTime.getText().toString().indexOf("(") + 1, startTime.getText().toString().indexOf(")"));
                    String mEndTime = endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("("));
                    String mEndTimeLuncher = endTime.getText().toString().substring(endTime.getText().toString().indexOf("(") + 1, endTime.getText().toString().indexOf(")"));
                    StatisticalDialog dialog = new StatisticalDialog(this, statisticalWork, mStarTime, mStartTimeLuncher, mEndTime, mEndTimeLuncher);
                    dialog.show();
                }
                break;
            case R.id.time_layout:
                filterBtn.setChecked(true);
                drawer.openDrawer(GravityCompat.END);
                break;
            case R.id.filterBtn: //右上角筛选按钮
                drawer.openDrawer(GravityCompat.END);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //如果工显示方式已经被切换 则需要将数据变化了
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            adapter.notifyDataSetChanged();
        } else if (resultCode == 0X100) { //搜索查看返回 需要带入相应的条件参数
            String mStartTimeValue = data.getStringExtra(Constance.STARTTIME_STRING);
            String mEndTimeValue = data.getStringExtra(Constance.ENDTIME_STRING);
            String mAccountIds = data.getStringExtra(Constance.ACCOUNT_TYPE);
            String[] mStartDates = mStartTimeValue.split("-"); //获取开始时间
            if (mStartDates != null && mStartDates.length == 3) {
                int year = Integer.parseInt(mStartDates[0]);
                int month = Integer.parseInt(mStartDates[1]);
                int day = Integer.parseInt(mStartDates[2]);
                String luncher = DateUtil.getLunarDate(year, month, day);
                startTime.setText(getTimeHtml(mStartTimeValue, luncher));
                drawerChildLayout.setStartTime(mStartTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
            }
            String[] mEndDates = mEndTimeValue.split("-"); //获取结束时间
            if (mEndDates != null && mEndDates.length == 3) {
                int year = Integer.parseInt(mEndDates[0]);
                int month = Integer.parseInt(mEndDates[1]);
                int day = Integer.parseInt(mEndDates[2]);
                String luncher = DateUtil.getLunarDate(year, month, day);
                endTime.setText(getTimeHtml(mEndTimeValue, luncher));
                drawerChildLayout.setEndTime(mEndTimeValue, luncher, DateUtil.getTimeInMillis(year, month, day));
            }
            drawerChildLayout.setAccountIds(mAccountIds);
            accountIds = mAccountIds;
            drawerChildLayout.setPidAndProjectName(null, "全部项目");
            drawerChildLayout.setUidAndName(null, UclientApplication.isForemanRoler(getApplicationContext()) ? "全部工人" : "全部班组长");
            filterBtn.setChecked(drawerChildLayout.isRestoryInit() ? false : true);
            if (!leftRadioBtn.isChecked()) {
                leftRadioBtn.setChecked(true);
            } else {
                getData(false);
            }
        } else {//刷新数据标识
            getData(false);
        }
    }

    /**
     * 搜索查看的处理
     */
    private void handlerFilter() {
        if (!TextUtils.isEmpty(drawerChildLayout.getPid()) && !TextUtils.isEmpty(drawerChildLayout.getUid())) {
            //搜索条件：[选择项目]和[选择工人]2个如果同时都选择有数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的界面显示页面为“按月统计(可切换为按天统计）”；
            StatisticalWorkThirdActivity.actionStart(StatisticalWorkFirstActivity.this,
                    startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                    endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                    "person",
                    drawerChildLayout.getName(),
                    drawerChildLayout.getUid(),
                    null, true, drawerChildLayout.getPid(), accountIds, drawerChildLayout.getProjectName(), false);
        } else if (!TextUtils.isEmpty(drawerChildLayout.getUid())) {
            String roler = UclientApplication.getRoler(getApplicationContext());
            //搜索条件：[选择项目]没有数据且[选择工人]有选择的数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的结果显示页面为“记工统计-按工人查看2级页面-按月份统计”；
            String classType = "person";
            String classTypeId = drawerChildLayout.getUid();
            StatisticalWorkSecondActivity.actionStart(StatisticalWorkFirstActivity.this,
                    startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                    endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")), null, null,
                    drawerChildLayout.getUid(), drawerChildLayout.getName(), accountIds,
                    roler.equals(Constance.ROLETYPE_FM) ? StatisticalWorkSecondActivity.TYPE_FROM_WORKER : StatisticalWorkSecondActivity.TYPE_FROM_FOREMAN,
                    classTypeId, classType, true, false, null, true, true);
        } else if (!TextUtils.isEmpty(drawerChildLayout.getPid())) {
            //搜索条件：[选择项目]有选择的数据且[选择工人]没有选择任何数据（开始时间、结束时间、记工分类不管选没有选），点击确定后，搜索出的结果显示页面为“记工统计-按项目查看2级页面-按工人统计”；
            String roler = UclientApplication.getRoler(getApplicationContext());
            if (roler.equals(Constance.ROLETYPE_FM)) {
                String classType = "project";
                String classTypeId = drawerChildLayout.getPid();
                StatisticalWorkSecondActivity.actionStart(StatisticalWorkFirstActivity.this,
                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")), drawerChildLayout.getPid(), drawerChildLayout.getProjectName(),
                        null, null, accountIds,
                        StatisticalWorkSecondActivity.TYPE_FROM_PROJECT,
                        classTypeId, classType, true, false, null, true, true);
            } else {
                StatisticalWorkThirdActivity.actionStart(
                        StatisticalWorkFirstActivity.this,
                        startTime.getText().toString().substring(0, startTime.getText().toString().indexOf("(")),
                        endTime.getText().toString().substring(0, endTime.getText().toString().indexOf("(")),
                        "project",
                        drawerChildLayout.getProjectName(),
                        drawerChildLayout.getPid(),
                        null, true, null, accountIds, null, false);
            }
        } else {
            //搜索条件只选择[开始结束时间]或者只选择了[记工分类]](选择项目和选择工人都没有选择任何数据），点击【确定】后，搜索出的结果显示页面为记工统计首页按项目查看界面；
            if (!leftRadioBtn.isChecked()) {
                leftRadioBtn.setChecked(true);
            } else {
                getData(false);
            }
        }
    }
}
