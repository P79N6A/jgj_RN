package com.jizhi.jlongg.main.popwindow;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CalendarModel;
import com.jizhi.jlongg.main.util.AccountUtil;
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
public class RecordAccountDateNotWeekPopWindow extends PopupWindow implements OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {
    /**
     * 当前PopWindow View布局
     */
    private View popView;
    /**
     * 年、月、日、周
     */
    public WheelView mViewYear, mViewMonth, mViewDate;
    /**
     * 年、月、日、周数据
     */
    private List<CalendarModel> yearList, monthList, dateList;
    /**
     * 选中时间回调
     */
    public SelectedDateListener listener;
    /**
     * 选中时间回调
     */
    public ClearListener clearListener;

    /**
     * 年、月、日、周适配器
     */
    private DatePickerWheelAdapter adapterYear, adapterMonth, adapterDate, adapterWeek;
    private final int YEAR = 1;//年
    private final int MONTH = 2;//阳历月
    private final int DATE = 3;//农历日


    private Activity context;


    public void update() {
        adapterYear.setCurrentIndex(mViewYear.getCurrentItem());
        adapterMonth.setCurrentIndex(mViewMonth.getCurrentItem());
        adapterDate.setCurrentIndex(mViewDate.getCurrentItem());
//        adapterWeek.setCurrentIndex(mViewWeek.getCurrentItem());
    }

    public RecordAccountDateNotWeekPopWindow(Activity context, String title, int accountType, SelectedDateListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
        setPopView();
        setUpViews(title, accountType);
        initData(0, 0, 0);
    }

    public RecordAccountDateNotWeekPopWindow(Activity context, String title, int accountType, SelectedDateListener listener, int year, int month, int day) {
        super(context);
        this.context = context;
        this.listener = listener;
        setPopView();
        setUpViews(title, accountType);
        initData(year, month, day);
    }

    /**
     * 隐藏我要记多天View
     */
    public void hideSelecteDaysView() {
        popView.findViewById(R.id.recordDays).setVisibility(View.GONE);
    }

    public void hideCancelBtnShowClearBtn(String btnName) {
        popView.findViewById(R.id.btn_cancel).setVisibility(View.GONE);
        Button button = popView.findViewById(R.id.btn_clear);
        button.setText(TextUtils.isEmpty(btnName) ? "清空" : btnName);
        button.setVisibility(View.VISIBLE);
        button.setOnClickListener(this);
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.account_date_not_week, null);
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
        if (curYear < 2017) {
            curYear = 2017;
        }
        yearList = DatePickerUtil.getYearData(2014, curYear); //初始化当前年月日数据
        monthList = DatePickerUtil.getMonthData(1, 12);
        dateList = DatePickerUtil.getDayData(DatePickerUtil.getLastDay(curYear, curMonth));
        initCalenderData(curYear, curMonth, curDate);
        setToday();
    }

    public void initCalenderData(int year, int month, int date) {
        //初始化年适配器
        adapterYear = new DatePickerWheelAdapter(context, yearList, yearList.size() - 1, YEAR);
        mViewYear.setViewAdapter(adapterYear);
        mViewYear.setCurrentItem(yearList.size() - 1);
        mViewYear.setVisibleItems(7);
        UpdateMonth(year, month, date);
    }

    public void UpdateMonth(int year, int month, int date) {
        //初始化月适配器
        adapterMonth = new DatePickerWheelAdapter(context, monthList, month - 1, MONTH);
        mViewMonth.setViewAdapter(adapterMonth);
        mViewMonth.setCurrentItem(month - 1);
        mViewMonth.setVisibleItems(7);
        UpdateDate(date - 1);
    }

    public void UpdateDate(int date) {
        //初始化日适配器
        adapterDate = new DatePickerWheelAdapter(context, dateList, date, DATE);
        mViewDate.setViewAdapter(adapterDate);
        mViewDate.setCurrentItem(date);
        mViewDate.setVisibleItems(7);
        UpdateWeek();
    }

    public void UpdateWeek() {
        int currY = Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear());
        int currM = Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth());
        int currD = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());

        String selectDate = currY + "-" + (currM < 10 ? "0" + currM : currM + "") + "-" + (currD < 10 ? "0" + currD : currD + "");
        if (getTodayDate().trim().equals(selectDate.trim())) {
            dateList.get(mViewDate.getCurrentItem()).setDateCompany("日(今天)");
        } else {
            dateList.get(mViewDate.getCurrentItem()).setDateCompany("日");
        }
    }

    public void setToday() {
        int currY = Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear());
        int currM = Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth());
        int currD = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());
        String selectDate = currY + "-" + (currM < 10 ? "0" + currM : currM + "") + "-" + (currD < 10 ? "0" + currD : currD + "");
        if (getTodayDate().trim().equals(selectDate.trim())) {
            dateList.get(mViewDate.getCurrentItem()).setDateCompany("日(今天)");
        } else {
            dateList.get(mViewDate.getCurrentItem()).setDateCompany("日");
        }
        adapterDate = new DatePickerWheelAdapter(context, dateList, mViewDate.getCurrentItem(), DATE);
        mViewDate.setViewAdapter(adapterDate);
        mViewDate.setCurrentItem(mViewDate.getCurrentItem());
        mViewDate.setVisibleItems(7);
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

    public void goneRecordDays() {
        popView.findViewById(R.id.recordDays).setVisibility(View.GONE);
    }

    private void setUpViews(String title, int accountType) {
        View view = popView.findViewById(R.id.recordDays);  //我要记多天
        view.setVisibility(accountType == 1 || accountType == 5 ? View.VISIBLE : View.GONE); //只有点工才可以记多天
        mViewYear = popView.findViewById(R.id.id_year);
        mViewMonth = popView.findViewById(R.id.id_month);
        mViewDate =  popView.findViewById(R.id.id_date);
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
        LUtils.e(currentYear + "-------11-----------" + currentMonth);
        // 记录当前选择的天数
        String selectDay = dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate();
        // 根据当前选择的年月获取对应的天数nongl
        int currY = Integer.parseInt(yearList.get(currentYear).getCalendarYear());
        int currM = Integer.parseInt(monthList.get(currentMonth).getSolarCalendarMonth());
        int currD = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());
        int lastDay = DatePickerUtil.getLastDay(currY, currM);
        LUtils.e(yearList.get(currentYear).getCalendarYear() + "------------22------------" + lastDay);
        int dateCurrentItem = 0;
        // 如果选中的天数大于实际天数，那么将默认天数设为实际天数;否则还是设置默认天数为选中的天数
        if (Integer.parseInt(selectDay) > lastDay) {
            dateCurrentItem = lastDay - 1;

        } else {
            dateCurrentItem = Integer.parseInt(selectDay) - 1;
        }
        LUtils.e(monthList.get(currentMonth).getSolarCalendarMonth() + "------------33------------" + lastDay);
        dateList = DatePickerUtil.getDayData(lastDay);
        String selectDate = currY + "-" + (currM < 10 ? "0" + currM : currM + "") + "-" + (currD < 10 ? "0" + currD : currD + "");
        if (getTodayDate().trim().equals(selectDate.trim())) {
//                            item = list.get(index).getSolarCalendarDate() + list.get(index).getDateCompany() + " (今天)";
            LUtils.e(getTodayDate() + ",111111,," + selectDate.trim());
            dateList.get(dateCurrentItem).setDateCompany("日(今天)");
        } else {
            LUtils.e(getTodayDate() + ",22222222222,," + selectDate.trim());
            dateList.get(dateCurrentItem).setDateCompany("日");
        }
        UpdateDate(dateCurrentItem);


    }


    public void init() {
        adapterYear.setTextViewSize(adapterYear.getItemText(mViewYear.getCurrentItem()).toString(), adapterYear);
        adapterMonth.setTextViewSize(adapterMonth.getItemText(mViewMonth.getCurrentItem()).toString(), adapterMonth);
//        adapterWeek.setTextViewSize(adapterWeek.getItemText(mViewWeek.getCurrentItem()).toString(), adapterWeek);
        adapterDate.setTextViewSize(adapterDate.getItemText(mViewDate.getCurrentItem()).toString(), adapterDate);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_clear: //清空按钮
                if (clearListener != null) {
                    clearListener.clear();
                }
                break;
            case R.id.btn_confirm:
                if (listener != null) {
//                    String week = (String) adapterWeek.getItemText(mViewWeek.getCurrentItem());
                    String year = yearList.get(mViewYear.getCurrentItem()).getCalendarYear();
                    String month = monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth();
                    String date = dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate();
                    listener.selectedDate(year, month, date, "");
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

                } else
//                if (company == WEEK) {
//                    item = list.get(index).getWeekStr();
//                }
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
//            UpdateWeek();
            setToday();
        }
    }


    public interface SelectedDateListener {
        public void selectedDays(); //我要记多天

        public void selectedDate(String year, String month, String date, String week);
    }

    public interface ClearListener {
        public void clear(); //清空
    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public String getTodayDate() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String todayTime = df.format(new Date());
        return todayTime;
    }

    public ClearListener getClearListener() {
        return clearListener;
    }

    public void setClearListener(ClearListener clearListener) {
        this.clearListener = clearListener;
    }
}
