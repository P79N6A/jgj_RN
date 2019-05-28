package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.StatisticalWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.popwindow.TitleSingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能: 记工统计-按项目查看3级页面
 * 作者：Xuj
 * 时间: 2018年9月27日10:36:46
 */
public class StatisticalWorkThirdActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 日期是否按天显示
     */
    private boolean isDayShow;
    /**
     * 记工统计适配器
     */
    private StatisticalWorkAdapter adapter;
    /**
     * 标题
     */
    private TextView titleText;
    /**
     * 标题旁边的图标
     */
    private ImageView titleImage;
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
     * 启动当前Activity
     *
     * @param context
     * @param startTime              开始时间
     * @param endTime                结束时间
     * @param classType              个人person(默认),项目project
     * @param proNameOrPersonName    项目名称或人名
     * @param id                     如果传的是项目名称
     * @param otherPersonUid         如果这个参数不为空的话表示 是别人同步给我的项目信息的uid
     * @param canToNextPage          是否能到记工统计下个页面
     * @param class_type_target_id   如果classType为person 并且这个参数不为空 那么这个参数默认就为查看的项目id,如果classType为project 并且这个参数不为空 那么这个参数默认就为查看的用户id
     * @param accountIds             筛选的记工类型1,2,3,4,5(可不传)
     * @param class_type_target_name 如果classType为person 并且这个参数不为空 那么这个参数默认就为查看的项目名称,如果classType为project 并且这个参数不为空 那么这个参数默认就为查看的用户名称
     */
    public static void actionStart(Activity context, String startTime, String endTime, String classType, String proNameOrPersonName,
                                   String id, String otherPersonUid, boolean canToNextPage, String class_type_target_id, String accountIds,
                                   String class_type_target_name, boolean isFromSyncToMe) {
        Intent intent = new Intent(context, StatisticalWorkThirdActivity.class);
        intent.putExtra(Constance.STARTTIME_STRING, startTime);
        intent.putExtra(Constance.ENDTIME_STRING, endTime);
        intent.putExtra("class_type", classType);
        intent.putExtra("param4", proNameOrPersonName);
        intent.putExtra("param5", id);
        intent.putExtra("param6", otherPersonUid);
        intent.putExtra("param7", canToNextPage);
        intent.putExtra("param8", class_type_target_id);
        intent.putExtra("param10", class_type_target_name);
        intent.putExtra("is_from_sync_to_me", isFromSyncToMe);
        intent.putExtra(Constance.ACCOUNT_TYPE, accountIds);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistical_work_third);
        initView();
        setDate();
        getData(false);
    }

    private void setDate() {
        Intent intent = getIntent();
        //如果在请求这个页面时 传了开始时间过来的话 则默认取这个时间
        String startTimeValue = intent.getStringExtra(Constance.STARTTIME_STRING);
        String[] startDates = startTimeValue.split("-");
        if (startDates != null && startDates.length == 3) {
            String year = startDates[0];
            String month = startDates[1];
            String day = startDates[2];

            Calendar calendar = Calendar.getInstance();
            calendar.set(calendar.YEAR, Integer.parseInt(year));
            calendar.set(calendar.MONTH, Integer.parseInt(month) - 1);
            calendar.set(calendar.DAY_OF_MONTH, Integer.parseInt(day));

            String luncher = DateUtil.getLunarDate(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day));
            getTextView(R.id.start_time_value_text).setText(getTimeHtml(startTimeValue, luncher));
        }
        //如果在请求这个页面时 传了结束时间过来的话 则默认取这个时间
        String endTimeValue = intent.getStringExtra(Constance.ENDTIME_STRING);
        String[] endDates = endTimeValue.split("-");
        if (endDates != null && endDates.length == 3) {
            String year = endDates[0];
            String month = endDates[1];
            String day = endDates[2];

            Calendar calendar = Calendar.getInstance();
            calendar.set(calendar.YEAR, Integer.parseInt(endDates[0]));
            calendar.set(calendar.MONTH, Integer.parseInt(endDates[1]) - 1);
            calendar.set(calendar.DAY_OF_MONTH, Integer.parseInt(endDates[2]));

            String luncher = DateUtil.getLunarDate(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day));
            getTextView(R.id.end_time_value_text).setText(getTimeHtml(endTimeValue, luncher));
        }
    }

    private Spanned getTimeHtml(String timeString, String timeLuncher) {
        return Html.fromHtml("<font color='#333333'>" + timeString + "</font><font color='#666666'>" + timeLuncher + "</font>");
    }


    private void initView() {

        titleText = getTextView(R.id.title);
        titleImage = getImageView(R.id.titleImage);
        getTextView(R.id.defaultDesc).setText("暂无记工统计数据");

        if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM)) {
            titleText.setOnClickListener(this);
            titleText.setText(isDayShow ? "按天统计" : "按月统计");
            titleImage.setVisibility(View.VISIBLE);
            titleImage.setOnClickListener(this);
            setTitleImageState(false);
        } else {
            titleText.setText("记工统计");
        }
        TextView rightTitle = getTextView(R.id.right_title);
        rightTitle.setText(R.string.more);
        rightTitle.setOnClickListener(this);

        View headView = getLayoutInflater().inflate(R.layout.statistical_work_third_head, null); // 加载对话框
        littleWorkAmount = (TextView) headView.findViewById(R.id.littleWorkAmount);
        contractorWorkTwoAmount = (TextView) headView.findViewById(R.id.contractorWorkTwoAmount);
        contractorWorkOneAmount = (TextView) headView.findViewById(R.id.contractorWorkOneAmount);

        TextView contractorWorkTwoAmountText = (TextView) headView.findViewById(R.id.contractorWorkTwoAmountText);
        TextView contractorWorkOneAmountText = (TextView) headView.findViewById(R.id.contractorWorkOneAmountText);

        borrowAmount = (TextView) headView.findViewById(R.id.borrowAmount);
        balanceAmount = (TextView) headView.findViewById(R.id.balanceAmount);
        manhour = (TextView) headView.findViewById(R.id.manhour);
        overTime = (TextView) headView.findViewById(R.id.overTime);
        borrowTotal = (TextView) headView.findViewById(R.id.borrowTotal);
        balanceTotal = (TextView) headView.findViewById(R.id.balanceTotal);

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

        ListView listView = (ListView) findViewById(R.id.listView);
        listView.addHeaderView(headView, null, false); //添加头部文件

        View endTimeLayout = findViewById(R.id.end_time_layout);
        LinearLayout.LayoutParams layoutParamsValue = (LinearLayout.LayoutParams) endTimeLayout.getLayoutParams();
        layoutParamsValue.bottomMargin = DensityUtil.dp2px(10);
        endTimeLayout.setLayoutParams(layoutParamsValue);
    }

    /**
     * 设置标题图标状态
     */
    private void setTitleImageState(boolean isOpenPopWindow) {
        titleImage.setImageResource(isOpenPopWindow ? R.drawable.sanjiao_shang : R.drawable.sanjiao_xia);
    }


    /**
     * 获取记工统计数据
     *
     * @param isDown true表示下载
     */
    public void getData(final boolean isDown) {
        String httpUrl = NetWorkRequest.WORK_MONTH_RECORD_STATISTICS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", getIntent().getStringExtra(Constance.STARTTIME_STRING)); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", getIntent().getStringExtra(Constance.ENDTIME_STRING)); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type", getIntent().getStringExtra("class_type")); //个人person(默认),项目project
        params.addBodyParameter("class_type_id", getIntent().getStringExtra("param5")); //记工统计页面二级页面id
        String uid = getIntent().getStringExtra("param6");
        String classTypeTargetId = getIntent().getStringExtra("param8");
        String accountIds = getIntent().getStringExtra(Constance.ACCOUNT_TYPE);
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        if (!TextUtils.isEmpty(classTypeTargetId)) {
            params.addBodyParameter("class_type_target_id", classTypeTargetId); //数据id
        }
        if (!TextUtils.isEmpty(accountIds)) { //记账类型
            params.addBodyParameter("accounts_type", accountIds);
        }
        if (isDayShow) {
            params.addBodyParameter("is_day", "1");
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
                        DownLoadExcelActivity.actionStart(StatisticalWorkThirdActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                    }
                } else {
                    StatisticalWork statisticalWork = (StatisticalWork) object;
                    setAdapter(statisticalWork.getMonth_list());
                    fillData(statisticalWork);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 设置记工统计数据
     *
     * @param list
     */
    private void setAdapter(List<StatisticalWork> list) {
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new StatisticalWorkAdapter(this, list, true, false, false);
            listView.setAdapter(adapter);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            String accountIds = getIntent().getStringExtra(Constance.ACCOUNT_TYPE);
            if (!TextUtils.isEmpty(accountIds)) {
                adapter.setAccountIds(accountIds);
            }
            final boolean isFromSyncToMe = getIntent().getBooleanExtra("is_from_sync_to_me", false);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position -= listView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    StatisticalWork statisticalWork = adapter.getList().get(position);
                    String date = DateUtil.dateFormat(statisticalWork.getDate());
                    if (TextUtils.isEmpty(date)) {
                        return;
                    }
                    try {
                        String year = date.substring(0, date.indexOf("-"));
                        String month = null;
                        if (isDayShow) {
                            month = date.substring(date.indexOf("-") + 1, date.lastIndexOf("-"));
                        } else {
                            month = date.substring(date.indexOf("-") + 1);
                        }
                        String proNameOrPersonName = getIntent().getStringExtra("param4"); //项目名称或人名
                        String classType = getIntent().getStringExtra("class_type"); //个人person(默认),项目project
                        String accountIds = getIntent().getStringExtra(Constance.ACCOUNT_TYPE); // 筛选的记工类型1,2,3,4,5
                        if (!TextUtils.isEmpty(classType) && classType.equals("project")) { //按项目
                            String classTargetId = getIntent().getStringExtra("param8");
                            String classTargetName = getIntent().getStringExtra("param10");
                            RememberWorkerInfosActivity.actionStart(StatisticalWorkThirdActivity.this, year, month,
                                    classTargetId, classTargetName, statisticalWork.getClass_type_id(), proNameOrPersonName, UclientApplication.getRoler(getApplicationContext()),
                                    accountIds, true, isFromSyncToMe, isFromSyncToMe, isFromSyncToMe); //项目名称或人名);

                        } else { //按人
                            //如果这个参数不为空 那么这个参数默认就为查看的项目id和项目名称
                            String classTargetId = getIntent().getStringExtra("param8");
                            String classTargetName = getIntent().getStringExtra("param10");
                            RememberWorkerInfosActivity.actionStart(StatisticalWorkThirdActivity.this, year, month,
                                    statisticalWork.getClass_type_id(), proNameOrPersonName, classTargetId, classTargetName, UclientApplication.getRoler(getApplicationContext()), accountIds,
                                    true, isFromSyncToMe, isFromSyncToMe, isFromSyncToMe); //项目名称或人名);\
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }

    /**
     * 填充列表数据
     *
     * @param statisticalWork
     */
    private void fillData(StatisticalWork statisticalWork) {

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

        String manhourString = AccountUtil.getAccountShowTypeString(this, true, true, true,
                Float.parseFloat(totalManhourAsHour), totalManhourAsWork);
        String overTimeString = AccountUtil.getAccountShowTypeString(this, true, true, false,
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
                manhourValue = totalManhourAsHour;
                overTimeValue = totalOverTimeAsHour;
                break;
        }
        manhour.setText(setMoneyViewAttritube(manhourString, manhourValue, Color.parseColor("#eb4e4e"))); //设置上班时长
        overTime.setText(setMoneyViewAttritube(overTimeString, overTimeValue, Color.parseColor("#eb4e4e"))); //设置加班时长
        this.statisticalWork = statisticalWork;

        String proName = statisticalWork.getPro_name();
        String userName = statisticalWork.getName();
        String accountTypeName = statisticalWork.getAccounts_type_name();

        if (!TextUtils.isEmpty(proName)) {
            TextView own_pro_text = getTextView(R.id.own_pro_text);
            TextView own_pro_value_text = getTextView(R.id.own_pro_value_text);
            own_pro_text.setVisibility(View.VISIBLE);
            own_pro_value_text.setVisibility(View.VISIBLE);
            own_pro_value_text.setText(proName);
        }
        if (!TextUtils.isEmpty(userName)) {
            TextView work_name_text = getTextView(R.id.work_name_text);
            work_name_text.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.work_name : R.string.foreman_name);
            TextView work_name_value_text = getTextView(R.id.work_name_value_text);
            work_name_text.setVisibility(View.VISIBLE);
            work_name_value_text.setVisibility(View.VISIBLE);
            work_name_value_text.setText(userName);
        }
        if (!TextUtils.isEmpty(accountTypeName)) {
            TextView record_type_text = getTextView(R.id.record_type_text);
            TextView record_type_value_text = getTextView(R.id.record_type_value_text);
            record_type_text.setVisibility(View.VISIBLE);
            record_type_value_text.setVisibility(View.VISIBLE);
            record_type_value_text.setText(accountTypeName);
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

    public List<SingleSelected> getTitleItem() {
        List<SingleSelected> list = new ArrayList<>();
        SingleSelected singleSelected1 = new SingleSelected("按天统计", false, false, "to_day");
        SingleSelected singleSelected2 = new SingleSelected("按月统计", false, false, "to_month");
        if (isDayShow) {
            singleSelected1.setShowSelectedIcon(true);
        } else {
            singleSelected2.setShowSelectedIcon(true);
        }
        list.add(singleSelected1);
        list.add(singleSelected2);
        return list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.titleImage:
            case R.id.title: //点击标题弹出月统计和天统计
                TitleSingleSelectedPopWindow titlePopWindow = new TitleSingleSelectedPopWindow(this, getTitleItem(),
                        isDayShow ? "按天统计" : "按月统计", R.drawable.sanjiao_shang, new TitleSingleSelectedPopWindow.TitleSingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "to_day": //按天统计
                                isDayShow = true;
                                break;
                            case "to_month": //按月统计
                                isDayShow = false;
                                break;
                        }
                        titleText.setText(isDayShow ? "按天统计" : "按月统计");
                        getData(false);
                    }

                    @Override
                    public void clickRightImage() {
                        onClick(findViewById(R.id.right_title));
                    }
                });
                //当窗口关闭的时候需要将标题的图标状态恢复
                titlePopWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                        setTitleImageState(false);
                        BackGroundUtil.backgroundAlpha(StatisticalWorkThirdActivity.this, 1.0F);
                    }
                });
                setTitleImageState(true);
                //显示窗口
                titlePopWindow.showAtLocation(getWindow().getDecorView(), Gravity.TOP | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                break;
            case R.id.right_title: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "1": //切换记工显示方式
                                AccountShowTypeActivity.actionStart(StatisticalWorkThirdActivity.this);
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
                popWindow.setAlpha(true);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //如果工显示方式已经被切换 则需要将数据变化了
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            fillData(statisticalWork);
            adapter.notifyDataSetChanged();
        } else {
            setResult(Constance.REFRESH); //只要回到当前页面就刷新数据
            getData(false);
        }
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

}

