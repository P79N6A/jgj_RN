package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LunarCalendar;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CalendarModel;
import com.jizhi.jlongg.main.listener.SelectedLuckyDayListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * 黄历日期选择
 */
public class WheelViewSelectDatePicker extends PopupWindow implements OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {
    public WheelView mViewYear, mViewMonth, mViewDate, mViewWeek;
    private List<CalendarModel> yearList, monthList, dateList, weekList;
    public SelectedLuckyDayListener listener;
    private Activity context;
    private DatePickerWheelAdapter adapterYear, adapterMonth, adapterDate, adapterWeek;
    private String title;
    private final int YEAR = 1;//年
    private final int MONTH = 2;//阳历月
    private final int DATE = 3;//农历日
    private final int WEEK = 4;//星期
    private ImageView cb_calender;//阳历农历切换
    private boolean isCheckCal;//阳历农历状态
    private View popView;


    public void update() {
        adapterYear.setCurrentIndex(mViewYear.getCurrentItem());
        adapterMonth.setCurrentIndex(mViewMonth.getCurrentItem());
        adapterDate.setCurrentIndex(mViewDate.getCurrentItem());
        adapterWeek.setCurrentIndex(mViewWeek.getCurrentItem());
    }

    public WheelViewSelectDatePicker(Activity context, List<CalendarModel> yearList, String title, SelectedLuckyDayListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
        this.title = title;
        this.yearList = yearList;
        setPopView();
        setUpViews();
        initData();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.date_wheel_view, null);
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


    private void initData() {
        // 格式化当前时间，并转换为年月日整型数据
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String[] split = sdf.format(new Date()).split("-");
        int curYear = Integer.parseInt(split[0]);
        int curMonth = Integer.parseInt(split[1]);
        int curDate = Integer.parseInt(split[2]);
        //初始化当前年月日数据
//        yearList = DatePickerUtil.getYearData(2013, 2020);
        curYear = DatePickerUtil.getYearCurrent(yearList, curYear);
        monthList = DatePickerUtil.getMonthData(1, 12);
        curMonth = curMonth - 1;
        dateList = DatePickerUtil.getDayData(DatePickerUtil.getLastDay(curYear, curMonth));
        curDate = curDate - 1;
        weekList = DatePickerUtil.getWeek();
        //如果存在结束时间选择项需要在当前时间加一个月
        if (this.title.equals(context.getString(R.string.end_time))) {
            try {
                Date dates = (new SimpleDateFormat("yyyy-MM-dd")).parse(split[0] + "-" + split[1] + "-" + split[2]);
                Calendar cal = Calendar.getInstance();
                cal.setTime(dates);
                cal.add(Calendar.MONTH, 1);
                String newDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cal.getTime());
                String[] splits = newDate.split("-");
                curYear = DatePickerUtil.getYearCurrent(yearList, Integer.parseInt(splits[0]));
                curMonth = (Integer.parseInt(splits[1])) - 1;
                curDate = (Integer.parseInt(splits[2])) - 1;
            } catch (Exception e) {

            }
        }
        initCalenderData(curYear, curMonth, curDate);
        setUpListener();
    }

    public void initCalenderData(int year, int month, int date) {
        //初始化年适配器
        adapterYear = new DatePickerWheelAdapter(context, yearList, year, YEAR);
        mViewYear.setViewAdapter(adapterYear);
        mViewYear.setCurrentItem(year);
        mViewYear.setVisibleItems(7);
        UpdateMonth(year, month, date);
    }

    public void UpdateMonth(int year, int month, int date) {
        if (isCheckCal) {
            int leapmonth = LunarCalendar.leapMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()));
            monthList = DatePickerUtil.getMonthData(1, 12);
            if (leapmonth != 0) {
                CalendarModel calendarModel = new CalendarModel();
                calendarModel.setSolarCalendarMonth(leapmonth + "");
                calendarModel.setLunarCalendarMonth("闰" + DatePickerUtil.getLunarMonth(leapmonth));
                monthList.add(leapmonth, calendarModel);
            }
        } else {
            monthList = DatePickerUtil.getMonthData(1, 12);
        }
        //初始化月适配器
        adapterMonth = new DatePickerWheelAdapter(context, monthList, month, MONTH);
        mViewMonth.setViewAdapter(adapterMonth);
        mViewMonth.setCurrentItem(month);
        mViewMonth.setVisibleItems(7);
        UpdateDate(date);
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
        int whichDayWeek = 0;
        int YearL = Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear());
        int monthL = Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth());
        int dateL = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());
        if (isCheckCal) {
            int lempMonth = LunarCalendar.leapMonth(YearL);
            boolean islempMonth = false;
            if (lempMonth != 0 && lempMonth == monthL) {
                islempMonth = true;
            }
            int[] a = LunarCalendar.lunarToSolar(YearL, monthL, dateL, islempMonth);
            whichDayWeek = TimesUtils.getwhichDayWeek(a[0], a[1], a[2]);
        } else {
            whichDayWeek = TimesUtils.getwhichDayWeek(YearL, monthL, dateL);
        }

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
        popView.findViewById(R.id.ttt).setOnClickListener(this);
    }


    private void setUpViews() {
        mViewYear = (WheelView) popView.findViewById(R.id.id_year);
        mViewMonth = (WheelView) popView.findViewById(R.id.id_month);
        mViewDate = (WheelView) popView.findViewById(R.id.id_date);
        mViewWeek = (WheelView) popView.findViewById(R.id.id_week);
        cb_calender = (ImageView) popView.findViewById(R.id.cb_calender);
        ((TextView) popView.findViewById(R.id.tv_context)).setText(title);
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

    public void UpdateSunlarDate() {
        int leapmonth = LunarCalendar.leapMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()));
        int alldays;
        if (leapmonth == 0) {
            alldays = LunarCalendar.daysInMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), (mViewMonth.getCurrentItem() + 1));
        } else if (leapmonth != 0 && leapmonth >= (mViewMonth.getCurrentItem() + 1)) {
            alldays = LunarCalendar.daysInMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), (mViewMonth.getCurrentItem() + 1));

        } else if (leapmonth != 0 && (mViewMonth.getCurrentItem()) == leapmonth) {
            alldays = LunarCalendar.daysInMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), leapmonth, true);
        } else {
            alldays = LunarCalendar.daysInMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), (mViewMonth.getCurrentItem()));
        }
        dateList = DatePickerUtil.getDayData(alldays);
        UpdateDate(mViewDate.getCurrentItem());
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                String week = (String) adapterWeek
                        .getItemText(mViewWeek.getCurrentItem());
                if (!isCheckCal) {
                    String year = yearList.get(mViewYear.getCurrentItem()).getCalendarYear();
                    String month = monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth();
                    String date = dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate();
                    listener.selectedCaldenerClick(year, month, date, week);
                } else {
                    int[] a = LunarCalendar.lunarToSolar(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth()), Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate()), false);
                    listener.selectedCaldenerClick((a[0] + ""), (a[1]) + "", (a[2]) + "", week);
                }
                dismiss();
                break;
            case R.id.btn_cancel:
                dismiss();
                break;
            case R.id.ttt:
                if (!isCheckCal) {
                    cb_calender.setImageResource(R.drawable.checkbox_pressed);
                    isCheckCal = true;
                    int[] lunar = LunarCalendar.solarToLunar(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()), Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth()), Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate()));
                    int curYear = lunar[0];
                    int curMonthLunar = lunar[1];
                    int curDateLunar = lunar[2];
                    curYear = DatePickerUtil.getYearCurrent(yearList, curYear);
                    int lempMonth = LunarCalendar.leapMonth(Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear()));
                    if (lempMonth != 0 && lunar[3] == 1) {
                        curMonthLunar = lempMonth - 1;
                    } else if (lempMonth != 0 && lempMonth == curMonthLunar) {
                        curMonthLunar = lempMonth;
                    } else if (lempMonth != 0 && curMonthLunar > lempMonth) {
                    } else {
                        curMonthLunar = curMonthLunar - 1;
                    }
                    curDateLunar = curDateLunar - 1;

                    initCalenderData(curYear, curMonthLunar, curDateLunar);
                } else {
                    cb_calender.setImageResource(R.drawable.checkbox_normal);
                    isCheckCal = false;

                    int YearL = Integer.parseInt(yearList.get(mViewYear.getCurrentItem()).getCalendarYear());
                    int monthL = Integer.parseInt(monthList.get(mViewMonth.getCurrentItem()).getSolarCalendarMonth());
                    int dateL = Integer.parseInt(dateList.get(mViewDate.getCurrentItem()).getSolarCalendarDate());

                    SolarToLunar(YearL, monthL, dateL);
                }
                break;
        }
    }

    public void SolarToLunar(int yearL, int monthL, int dateL) {
        int lempMonth = LunarCalendar.leapMonth(yearL);
        boolean islempMonth = false;
        if (lempMonth != 0 && lempMonth == monthL) {
            islempMonth = true;
        }
        int[] a = LunarCalendar.lunarToSolar(yearL, monthL, dateL, islempMonth);
        int curYear = a[0];
        int curMonth = a[1];
        int curDate = a[2];
        if (lempMonth != 0 && islempMonth && mViewMonth.getCurrentItem() != lempMonth) {
            curYear = DatePickerUtil.getYearCurrent(yearList, curYear);
            curMonth = lempMonth;

            if (Integer.parseInt(yearList.get(curYear).getCalendarYear()) == 2017) {
                curDate += 1;
            }

        } else {
            curYear = DatePickerUtil.getYearCurrent(yearList, curYear);
            curMonth = curMonth - 1;
            curDate -= 1;
        }


        initCalenderData(curYear, curMonth, curDate);
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
                    if (!isCheckCal) {
                        item = list.get(index).getSolarCalendarMonth() + list.get(index).getMonthCompany();
                    } else {
                        item = list.get(index).getLunarCalendarMonth() + list.get(index).getMonthCompany();
                    }


                } else if (company == DATE) {
                    if (!isCheckCal) {
                        item = list.get(index).getSolarCalendarDate() + list.get(index).getDateCompany();
                    } else {
                        item = DatePickerUtil.getLunarDate(index + 1);
                    }

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
            if (!isCheckCal) {
                UpdateSolarDate(mViewYear.getCurrentItem(), mViewMonth.getCurrentItem());//跟新当月总天数
            } else {
                //农历
                UpdateMonth(mViewYear.getCurrentItem(), mViewMonth.getCurrentItem(), mViewDate.getCurrentItem());
                UpdateSunlarDate();
            }
            String yearS = (String) adapterYear.getItemText(mViewYear.getCurrentItem());
            adapterYear.setTextViewSize(yearS, adapterYear);
        } else if (wheel == mViewMonth) {
            if (!isCheckCal) {
                //阳历
                UpdateSolarDate(mViewYear.getCurrentItem(), mViewMonth.getCurrentItem());
            } else {
                //农历
                UpdateSunlarDate();
            }
            String monthS = (String) adapterMonth.getItemText(mViewMonth.getCurrentItem());
            adapterMonth.setTextViewSize(monthS, adapterMonth);
        } else if (wheel == mViewDate) {
            if (!isCheckCal) {
                String dateS = (String) adapterDate.getItemText(mViewDate.getCurrentItem());
                adapterMonth.setTextViewSize(dateS, adapterDate);
            } else {
                String dateS = (String) adapterDate.getItemText(mViewDate.getCurrentItem());
                adapterMonth.setTextViewSize(dateS, adapterDate);
            }
            UpdateWeek();
        }
    }

}
