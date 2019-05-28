package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LunarCalendar;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.StatisticalWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.NestRadioGroup;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * 功能: 记工统计
 * 作者：Xuj
 * 时间: 2018年1月4日10:47:06
 */
public class StatisticalWorkActivity extends BaseActivity implements View.OnClickListener {
    /**
     * RadioBtn左边按钮
     */
    private RadioButton leftBtn;
    /**
     * RadioBtn右边按钮
     */
    private RadioButton rightBtn;
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
     * 开始日期,结束日期,农历开始日期,农历结束日期
     */
    private TextView startTime, endTime, startLuncher, endLuncher;
    /**
     * 开始日期 的时间戳   当还要选择结束时间做时间判断   结束时间不能小于开始时间
     */
    private long startTimeStamp, endTimeStamp;
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
     * 默认开始时间,默认结束时间,默认开始农历,默认结束农历
     */
    private String defaultStartTime, defaultEndTime, defaultStartLuncher, defaultEndLuncher;
    /**
     * 默认开始时间戳,默认结束时间戳
     */
    private long defaultStartTimeStamp, defaultEndTimeStamp;


    private View leftIcon, rightIcon;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, StatisticalWorkActivity.class);
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
        Intent intent = new Intent(context, StatisticalWorkActivity.class);
        intent.putExtra(Constance.STARTTIME_STRING, startTime);
        intent.putExtra(Constance.ENDTIME_STRING, endTime);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistical_work);
        initView();
        setDate();
//        //未完善姓名不允许加载数据
//        IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//            @Override
//            public void onSuccess() {
//                getData();
//            }
//        });
    }

    /**
     * 设置默认结束时间
     * 默认为今天的时间
     */
    private void setDefaultEndTime() {
        if (TextUtils.isEmpty(defaultEndTime)) {
            Calendar calendar = DatePickerUtil.getTodayDate();
            int year = calendar.get(Calendar.YEAR);
            int monthOfYear = calendar.get(Calendar.MONTH);
            int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
            String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
            String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
            defaultEndTime = year + "-" + month + "-" + day; //获取默认结束时间
            defaultEndLuncher = getLunarDate(year, monthOfYear + 1, dayOfMonth); //默认结束时间的农历
            defaultEndTimeStamp = calendar.getTimeInMillis(); //默认结束时间的时间戳
            endTime.setText(defaultEndTime);
            endLuncher.setText(defaultEndLuncher);
            endTimeStamp = defaultEndTimeStamp;
        } else {
            endTime.setText(defaultEndTime);
            endLuncher.setText(defaultEndLuncher);
            endTimeStamp = defaultEndTimeStamp;
        }
    }

    /**
     * 设置默认开始时间
     * 默认为今年的第一天 也就是大年初一
     */
    private void setDefaultStartTime() {
        if (TextUtils.isEmpty(defaultStartTime)) {
            Calendar yearOfFirstDayCalendar = DatePickerUtil.getCurrYearFirst(); //获取当前年的第一天 比如2018年 的1月1日
            int[] date = DatePickerUtil.lunarToSolar(yearOfFirstDayCalendar.get(Calendar.YEAR), yearOfFirstDayCalendar.get(Calendar.MONTH) + 1, yearOfFirstDayCalendar.get(Calendar.DAY_OF_MONTH)); //将农历日期转为公历日期
            Calendar lastCalendar = DatePickerUtil.strongYearMonthDayToCalendar(date); //获取转换后的公历Calendar 获取的就是新年的第一天时间
            int year = lastCalendar.get(Calendar.YEAR);
            int monthOfYear = lastCalendar.get(Calendar.MONTH);
            int dayOfMonth = lastCalendar.get(Calendar.DAY_OF_MONTH);
            String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
            String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
            defaultStartTime = year + "-" + month + "-" + day; //获取默认开始时间
            defaultStartLuncher = getLunarDate(year, monthOfYear + 1, dayOfMonth);//默认开始时间的农历
            defaultStartTimeStamp = lastCalendar.getTimeInMillis();//默认开始时间的时间戳
            startTime.setText(defaultStartTime);
            startLuncher.setText(defaultStartLuncher);
            startTimeStamp = defaultStartTimeStamp;
        } else {
            startTime.setText(defaultStartTime);
            startLuncher.setText(defaultStartLuncher);
            startTimeStamp = defaultStartTimeStamp;
        }
    }

    private void initView() {
        setTextTitle(R.string.statistical_work);
        ImageView rightImageView = getImageView(R.id.rightImage);
        rightImageView.setImageResource(R.drawable.red_dots);
        rightImageView.setVisibility(View.VISIBLE);
        rightImageView.setOnClickListener(this);


        startLuncher = getTextView(R.id.startLuncher);
        endLuncher = getTextView(R.id.endLuncher);
        startTime = getTextView(R.id.startTime);
        endTime = getTextView(R.id.endTime);
//        confirmTime = getTextView(R.id.confirmTime);

        endTime.setText(defaultEndTime);

        getTextView(R.id.defaultDesc).setText("未搜索到相关内容");

        View headView = getLayoutInflater().inflate(R.layout.statistical_work_first_head, null); // 加载对话框
        itemTitleName = (TextView) headView.findViewById(R.id.itemTitleName);
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.addHeaderView(headView, null, false); //添加头部文件

        leftIcon = headView.findViewById(R.id.leftIcon);
        rightIcon = headView.findViewById(R.id.rightIcon);
        leftBtn = (RadioButton) headView.findViewById(R.id.leftBtn);
        rightBtn = (RadioButton) headView.findViewById(R.id.rightBtn);

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
        //当前角色
        String currentRole = UclientApplication.getRoler(getApplicationContext());
        if (currentRole.equals(Constance.ROLETYPE_WORKER)) { //当前角色是工人
            leftBtn.setText(R.string.selected_pro);
            rightBtn.setText(R.string.selected_foreman);
        } else { //工头角色
            leftBtn.setText(R.string.selected_pro);
            rightBtn.setText(R.string.selected_worker);
        }
        changeState(0);
    }


    private void setDate() {
        Intent intent = getIntent();
        //如果在请求这个页面时 传了开始时间过来的话 则默认取这个时间
        String startTimeValue = intent.getStringExtra(Constance.STARTTIME_STRING);
        if (!TextUtils.isEmpty(startTimeValue)) {
            String[] dates = startTimeValue.split("-");
            if (dates != null && dates.length == 3) {
                String year = dates[0];
                String month = dates[1];
                String day = dates[2];

                Calendar calendar = Calendar.getInstance();
                calendar.set(calendar.YEAR, Integer.parseInt(dates[0]));
                calendar.set(calendar.MONTH, Integer.parseInt(dates[1]) - 1);
                calendar.set(calendar.DAY_OF_MONTH, Integer.parseInt(dates[2]));

                startTime.setText(startTimeValue);
                startLuncher.setText(getLunarDate(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day)));
                startTimeStamp = calendar.getTimeInMillis();
            }
        } else {
            setDefaultStartTime();
        }
        //如果在请求这个页面时 传了结束时间过来的话 则默认取这个时间
        String endTimeValue = intent.getStringExtra(Constance.ENDTIME_STRING);
        if (!TextUtils.isEmpty(endTimeValue)) {
            String[] dates = endTimeValue.split("-");
            if (dates != null && dates.length == 3) {
                String year = dates[0];
                String month = dates[1];
                String day = dates[2];

                Calendar calendar = Calendar.getInstance();
                calendar.set(calendar.YEAR, Integer.parseInt(dates[0]));
                calendar.set(calendar.MONTH, Integer.parseInt(dates[1]) - 1);
                calendar.set(calendar.DAY_OF_MONTH, Integer.parseInt(dates[2]));

                endTime.setText(endTimeValue);
                endLuncher.setText(getLunarDate(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day)));
                endTimeStamp = calendar.getTimeInMillis();
            }
        } else {
            setDefaultEndTime();
        }
    }


    /**
     * 切换状态 个人和项目状态
     *
     * @param count
     */
    private void changeState(int count) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            leftBtn.setChecked(true);
            leftIcon.setVisibility(View.VISIBLE);
            rightIcon.setVisibility(View.GONE);
        } else {
            rightBtn.setChecked(true);
            leftIcon.setVisibility(View.GONE);
            rightIcon.setVisibility(View.VISIBLE);
        }
        setItemName(count);
    }


    private void setItemName(int count) {
        if (current_selecte_flag == SELECTE_LEFT_BTN_FLAG) {
            itemTitleName.setText("项目(" + count + "个)");
        } else {
            itemTitleName.setText(getString(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.workers : R.string.foremans) + "(" + count + "人)");
        }
    }


    /**
     * 查询记工统计
     */
    public void getData() {
        String URL = NetWorkRequest.STATISTICAL_WORK;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", startTime.getText().toString()); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", endTime.getText().toString()); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type", current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? "project" : "person"); //	个人person(默认),项目project
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<StatisticalWork> base = CommonJson.fromJson(responseInfo.result, StatisticalWork.class);
                    if (base.getState() != 0) {
                        StatisticalWork statisticalWork = base.getValues();
                        setAdapter(statisticalWork.getList());
                        fillData(statisticalWork);
                    } else {
                        DataUtil.showErrOrMsg(StatisticalWorkActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(StatisticalWorkActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

        });
    }

    /**
     * 填充列表数据
     *
     * @param statisticalWork
     */
    private void fillData(StatisticalWork statisticalWork) {
        int count = statisticalWork.getList().size();
        setItemName(count);
        this.statisticalWork = statisticalWork;
    }

    /**
     * 设置记工统计数据
     *
     * @param list
     */
    private void setAdapter(final List<StatisticalWork> list) {
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new StatisticalWorkAdapter(this, list, false, true, false);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position -= listView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    StatisticalWorkByMonthActivity.actionStart(
                            StatisticalWorkActivity.this,
                            startTime.getText().toString(),
                            endTime.getText().toString(),
                            current_selecte_flag == SELECTE_LEFT_BTN_FLAG ? "project" : "person",
                            adapter.getList().get(position).getName(),
                            adapter.getList().get(position).getClass_type_id(),
                            null, true);
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }

    private final String ITEM_1 = "1";

    public List<SingleSelected> getItem() {
        List<SingleSelected> list = new ArrayList<>();
//        list.add(new SingleSelected(getString(current_work_show_flag == AccountUtil.WORK_AS_UNIT ? R.string.hour_show : R.string.day_show), false, true, AccountUtil.WORK_SHOW_TYPE));
        list.add(new SingleSelected(true, true).setSelecteNumber(ITEM_1));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rightImage: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case ITEM_1: //切换记工显示方式
                                AccountShowTypeActivity.actionStart(StatisticalWorkActivity.this);
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.startTimeBtn: //开始日期
                showStartTime();
                break;
            case R.id.endTimeBtn: //结束日期
                showEndTime();
                break;
            case R.id.statisticalTotalLayout: //查看该时间段的统计
//                if (statisticalWork != null) {
//                    StatisticalDialog dialog = new StatisticalDialog(this,
//                            statisticalWork,
//                            startTime.getText().toString(),
//                            startLuncher.getText().toString(),
//                            endTime.getText().toString(),
//                            endLuncher.getText().toString());
//                    dialog.show();
//                }
                break;
        }
    }


    /**
     * 显示开始时间
     */
    private void showStartTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(this, getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String monthOfYear, String dayOfMonth, String week) {
                        Calendar calendar = Calendar.getInstance();
                        if (endTimeStamp != 0) { //已选择了结束时间 需要判断开始时间不能大于结束时间
                            calendar.set(Calendar.YEAR, Integer.parseInt(year)); //设置年
                            calendar.set(Calendar.MONTH, Integer.parseInt(monthOfYear) - 1); //设置月
                            calendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dayOfMonth)); //设置日
                            calendar.set(Calendar.HOUR_OF_DAY, 0); //设置小时
                            calendar.set(Calendar.MINUTE, 0);  //设置分钟
                            calendar.set(Calendar.SECOND, 0); //设置秒
                            calendar.set(Calendar.MILLISECOND, 0); //设置毫秒
                            if (calendar.getTimeInMillis() > endTimeStamp) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "开始日期不能大于结束日期", CommonMethod.ERROR);
                                return;
                            }
                        }
                        String month = Integer.parseInt(monthOfYear) < 10 ? "0" + Integer.parseInt(monthOfYear) : Integer.parseInt(monthOfYear) + "";
                        String day = Integer.parseInt(dayOfMonth) < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                        startTime.setText(year + "-" + month + "-" + day);
                        startLuncher.setText(getLunarDate(Integer.parseInt(year), Integer.parseInt(monthOfYear), Integer.parseInt(dayOfMonth)));
                        startTimeStamp = calendar.getTimeInMillis();
                        getData();
                    }
                });
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //重置开始时间
            @Override
            public void clear() {
                setDefaultStartTime();
                setDefaultEndTime();
                getData();
            }
        });
        datePickerPopWindow.hideCancelBtnShowClearBtn(" 重置");
        datePickerPopWindow.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        datePickerPopWindow.hideSelecteDaysView();
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 显示结束时间
     */
    private void showEndTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(this, getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String monthOfYear, String dayOfMonth, String week) {
                        Calendar calendar = Calendar.getInstance();
                        if (startTimeStamp != 0) { //已选择了开始时间,结束时间不能小于开始时间
                            calendar.set(Calendar.YEAR, Integer.parseInt(year));
                            calendar.set(Calendar.MONTH, Integer.parseInt(monthOfYear) - 1);
                            calendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dayOfMonth) + 1);
                            calendar.set(Calendar.HOUR_OF_DAY, 0); //设置小时
                            calendar.set(Calendar.MINUTE, 0);  //设置分钟
                            calendar.set(Calendar.SECOND, 0); //设置秒
                            calendar.set(Calendar.MILLISECOND, 0); //设置毫秒
                            if (calendar.getTimeInMillis() < startTimeStamp) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "开始日期不能大于结束日期", CommonMethod.ERROR);
                                return;
                            }
                        }
                        String month = Integer.parseInt(monthOfYear) < 10 ? "0" + Integer.parseInt(monthOfYear) : Integer.parseInt(monthOfYear) + "";
                        String day = Integer.parseInt(dayOfMonth) < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                        endTime.setText(year + "-" + month + "-" + day);
                        endLuncher.setText(getLunarDate(Integer.parseInt(year), Integer.parseInt(monthOfYear), Integer.parseInt(dayOfMonth)));
                        endTimeStamp = calendar.getTimeInMillis();
                        getData();
                    }
                });
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //重置结束时间
            @Override
            public void clear() {
                setDefaultStartTime();
                setDefaultEndTime();
                getData();
            }
        });
        datePickerPopWindow.hideCancelBtnShowClearBtn("重置");
        datePickerPopWindow.showAtLocation(findViewById(R.id.root_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        datePickerPopWindow.hideSelecteDaysView();
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 获取农历
     *
     * @param year
     * @param month
     * @param day
     * @return
     */
    private String getLunarDate(int year, int month, int day) {
        StringBuilder builder = new StringBuilder();
        builder.append("(");
        int[] date = LunarCalendar.solarToLunar(year, month, day);
        builder.append(DatePickerUtil.getLunarMonth(date[1]) + "月");
        builder.append(DatePickerUtil.getLunarDate(date[2]));
        builder.append(")");
//        LUtils.e("year111:" + date[0] + "     " + "     month111:" + date[1] + "     day1111:" + date[2]);
        return builder.toString();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //如果工显示方式已经被切换 则需要将数据变化了
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            adapter.notifyDataSetChanged();
        }
        if (resultCode == Constance.REFRESH) { //刷新数据标识
            getData();
        }
    }
}
