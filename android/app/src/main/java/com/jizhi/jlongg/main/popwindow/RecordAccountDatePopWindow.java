package com.jizhi.jlongg.main.popwindow;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CalendarModel;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * 记工记账日期选择
 */
public class RecordAccountDatePopWindow extends PopupWindow implements OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {
    /**
     * 当前PopWindow View布局
     */
    private View popView;
    /**
     * 年、月、日、周
     */
    public WheelView mViewYear, mViewMonth, mViewDate, mViewWeek;
    /**
     * 年、月、日、周数据
     */
    private List<CalendarModel> yearList, monthList, dateList, weekList;
    /**
     * 选中时间回调
     */
    public SelectedDateListener listener;

    /**
     * 年、月、日、周适配器
     */
    private DatePickerWheelAdapter adapterYear, adapterMonth, adapterDate, adapterWeek;
    private final int YEAR = 1;//年
    private final int MONTH = 2;//阳历月
    private final int DATE = 3;//农历日
    private final int WEEK = 4;//星期



    private Activity context;


    public void update() {
        adapterYear.setCurrentIndex(mViewYear.getCurrentItem());
        adapterMonth.setCurrentIndex(mViewMonth.getCurrentItem());
        adapterDate.setCurrentIndex(mViewDate.getCurrentItem());
        adapterWeek.setCurrentIndex(mViewWeek.getCurrentItem());
    }

    public RecordAccountDatePopWindow(Activity context, String title, int accountType, SelectedDateListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
        setPopView();
        setUpViews(title, accountType);
        initData(0, 0, 0);
    }

    public RecordAccountDatePopWindow(Activity context, String title, int accountType, SelectedDateListener listener, int year, int month, int day) {
        super(context);
        this.context = context;
        this.listener = listener;
        setPopView();
        setUpViews(title, accountType);
        initData(year, month, day);
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.account_date, null);
        setContentView(popView);
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0xb0000000);
        setOnDismissListener(this);
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);
        setOutsideTouchable(true);
    }


    private void initData(int year, int month, int day) {
        int curYear = 0;
        int curMonth = 0;
        int curDate = 0;
        if (year != 0 && month != 0 && day != 0) {   // 格式化当前时间，并转换为年月日整型数据
            curYear = year;
            curMonth = month;
            curDate = day;
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
            String[] split = sdf.format(new Date()).split("-");
            curYear = Integer.parseInt(split[0]);
            curMonth = Integer.parseInt(split[1]);
            curDate = Integer.parseInt(split[2]);
        }
        if (curYear < 2014) {
            curYear = 2014;
        }
        yearList = DatePickerUtil.getYearData(2014, curYear); //初始化当前年月日数据
        monthList = DatePickerUtil.getMonthData(1, 12);
        dateList = DatePickerUtil.getDayData(DatePickerUtil.getLastDay(curYear, curMonth));
        weekList = DatePickerUtil.getWeek();
        initCalenderData(curYear, curMonth, curDate);
    }

    public void initCalenderData(int year, int month, int date) {
        int initPosition = getInitPosition(year + "", "year");
        //初始化年适配器
        adapterYear = new DatePickerWheelAdapter(context, yearList, initPosition, YEAR);
        mViewYear.setViewAdapter(adapterYear);
        mViewYear.setCurrentItem(initPosition);
        mViewYear.setVisibleItems(7);
        UpdateMonth(year, month, date);
    }

    public void UpdateMonth(int year, int month, int date) {
        int initPosition = getInitPosition(month + "", "month");
        //初始化月适配器
        adapterMonth = new DatePickerWheelAdapter(context, monthList, initPosition, MONTH);
        mViewMonth.setViewAdapter(adapterMonth);
        mViewMonth.setCurrentItem(initPosition);
        mViewMonth.setVisibleItems(7);
        UpdateDate(date);
    }

    public void UpdateDate(int date) {
        int initPosition = getInitPosition(date + "", "day");
        //初始化日适配器
        adapterDate = new DatePickerWheelAdapter(context, dateList, initPosition, DATE);
        mViewDate.setViewAdapter(adapterDate);
        mViewDate.setCurrentItem(initPosition);
        mViewDate.setVisibleItems(7);
        UpdateWeek();
    }


    public int getInitPosition(String date, String type) {
        if (TextUtils.isEmpty(date) || yearList == null || monthList == null || dateList == null) {
            return 0;
        }
        switch (type) {
            case "year":
                int yearCount = yearList.size();
                for (int i = 0; i < yearCount; i++) {
                    if (yearList.get(i).getCalendarYear().equals(date)) {
                        return i;
                    }
                }
                break;
            case "month":
                int monthCount = monthList.size();
                for (int i = 0; i < monthCount; i++) {
                    if (monthList.get(i).getSolarCalendarMonth().equals(date)) {
                        return i;
                    }
                }
                break;
            case "day":
                int dayCount = dateList.size();
                for (int i = 0; i < dayCount; i++) {
                    if (dateList.get(i).getSolarCalendarDate().equals(date)) {
                        return i;
                    }
                }
                break;
        }
        return 0;
    }

    public void UpdateWeek() {
        int whichDayWeek = 0;
        int YearL = Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear());
        int monthL = Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth());
        int dateL = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());
        whichDayWeek = TimesUtils.getwhichDayWeek(YearL, monthL, dateL);
        //初始化星期适配器
        adapterWeek = new DatePickerWheelAdapter(context, weekList, whichDayWeek, WEEK);
        mViewWeek.setViewAdapter(adapterWeek);
        mViewWeek.setCurrentItem(whichDayWeek);
        mViewWeek.setCyclic(true);
        mViewWeek.setEnabled(false);
        mViewWeek.setVisibleItems(7);
    }

    private void setUpListener() {
        // 添加年change事件
        mViewYear.addChangingListener(this);
        // 添加月change事件
        mViewMonth.addChangingListener(this);
        // 添加日change事件
        mViewDate.addChangingListener(this);
        mViewYear.addScrollingListener(this);
        mViewMonth.addScrollingListener(this);
        mViewDate.addScrollingListener(this);
        // 添加onclick事件
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        popView.findViewById(R.id.recordDays).setOnClickListener(this);
    }


    private void setUpViews(String title, int accountType) {
        View view = popView.findViewById(R.id.recordDays);  //我要记多天
        view.setVisibility(accountType == 1 ? View.VISIBLE : View.GONE); //只有点工才可以记多天
        mViewYear = (WheelView) popView.findViewById(R.id.id_year);
        mViewMonth = (WheelView) popView.findViewById(R.id.id_month);
        mViewDate = (WheelView) popView.findViewById(R.id.id_date);
        mViewWeek = (WheelView) popView.findViewById(R.id.id_week);
        ((TextView) popView.findViewById(R.id.tv_context)).setText(title);
        setUpListener();
    }

    /**
     * 计算当月阳历总天数
     *
     * @param currentYear
     * @param currentMonth
     */
    private void UpdateSolarDate(int currentYear, int currentMonth) {
        // 记录当前选择的天数
        String selectDay = dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate();
        // 根据当前选择的年月获取对应的天数nongl
        int lastDay = DatePickerUtil.getLastDay(currentYear, currentMonth + 1);
        int dateCurrentItem = 0;
        // 如果选中的天数大于实际天数，那么将默认天数设为实际天数;否则还是设置默认天数为选中的天数
        if (Integer.parseInt(selectDay) > lastDay) {
            dateCurrentItem = lastDay - 1;

        } else {
            dateCurrentItem = Integer.parseInt(selectDay) - 1;
        }

        dateList = DatePickerUtil.getDayData(lastDay);
        UpdateDate(dateCurrentItem);
    }


    public void init() {
        adapterYear.setTextViewSize(adapterYear.getItemText(mViewYear.getCurrentItem()).toString(), adapterYear);
        adapterMonth.setTextViewSize(adapterMonth.getItemText(mViewMonth.getCurrentItem()).toString(), adapterMonth);
        adapterWeek.setTextViewSize(adapterWeek.getItemText(mViewWeek.getCurrentItem()).toString(), adapterWeek);
        adapterDate.setTextViewSize(adapterDate.getItemText(mViewDate.getCurrentItem()).toString(), adapterDate);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (listener != null) {
                    String week = (String) adapterWeek.getItemText(mViewWeek.getCurrentItem());
                    String year = yearList.get(mViewYear.getCurrentItem()).getCalendarYear();
                    String month = monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth();
                    String date = dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate();
                    listener.selectedDate(year, month, date, week);
                }
                break;
            case R.id.recordDays://我要记多天
                if (listener != null) {
                    listener.selectedDays();
                }
                break;
        }
        dismiss();
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == mViewYear) {
            String yearS = (String) adapterYear.getItemText(mViewYear.getCurrentItem());
            adapterYear.setTextViewSize(yearS, adapterYear);
        } else if (wheel == mViewMonth) {
            String monthS = (String) adapterMonth.getItemText(mViewMonth.getCurrentItem());
            adapterMonth.setTextViewSize(monthS, adapterMonth);
        } else if (wheel == mViewDate) {
            String dateS = (String) adapterDate.getItemText(mViewDate.getCurrentItem());
            adapterMonth.setTextViewSize(dateS, adapterDate);
        }
    }

    @Override
    public void onScrollingStarted(WheelView wheel) {

    }

    @Override
    public void onScrollingFinished(WheelView wheel) {
        changeWheelValue(wheel);
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0f);
    }

    public class DatePickerWheelAdapter extends AbstractWheelTextAdapter {
        private List<CalendarModel> list;
        private int company;

        public DatePickerWheelAdapter(Context context, List<CalendarModel> list, int currentItem, int company) {
            super(context, R.layout.item_wheelview, NO_RESOURCE, currentItem);
            this.list = list;
            this.company = company;
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public CharSequence getItemText(int index) {
            if (index >= 0 && index < list.size()) {
                String item = "";
                if (company == YEAR) {
                    item = list.get(index).getCalendarYear() + list.get(index).getYearCompany();
                } else if (company == MONTH) {
                    item = list.get(index).getSolarCalendarMonth() + list.get(index).getMonthCompany();
                } else if (company == DATE) {
                    item = list.get(index).getSolarCalendarDate() + list.get(index).getDateCompany();
                } else if (company == WEEK) {
                    item = list.get(index).getWeekStr();
                }
                if (item instanceof CharSequence) {
                    return item;
                }
                return item.toString();
            }

            return null;
        }

        @Override
        public int getItemsCount() {
            return list.size();
        }

    }

    private void changeWheelValue(WheelView wheel) {
        if (wheel == mViewYear) {
            UpdateSolarDate(mViewYear.getCurrentItem(), mViewMonth.getCurrentItem());//跟新当月总天数
            String yearS = (String) adapterYear.getItemText(mViewYear.getCurrentItem());
            adapterYear.setTextViewSize(yearS, adapterYear);
        } else if (wheel == mViewMonth) {
            UpdateSolarDate(mViewYear.getCurrentItem(), mViewMonth.getCurrentItem());
            String monthS = (String) adapterMonth.getItemText(mViewMonth.getCurrentItem());
            adapterMonth.setTextViewSize(monthS, adapterMonth);
        } else if (wheel == mViewDate) {
            String dateS = (String) adapterDate.getItemText(mViewDate.getCurrentItem());
            adapterMonth.setTextViewSize(dateS, adapterDate);
            UpdateWeek();
        }
    }


    public interface SelectedDateListener {
        public void selectedDays(); //我要记多天

        public void selectedDate(String year, String month, String date, String week);
    }

}
