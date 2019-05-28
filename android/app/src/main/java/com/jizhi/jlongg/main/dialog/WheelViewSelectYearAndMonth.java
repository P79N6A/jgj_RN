package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * huchangsheng：Administrator on 2016/2/24 20:27
 */
public class WheelViewSelectYearAndMonth extends PopupWindow implements View.OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {

    /* 年 */
    private WheelView mWheelViewYear;
    /* 月 */
    private WheelView mWheelViewMonth;
    /* 年适配器 */
    private YearAdapter yearAdapter;
    /* 月适配器 */
    private MonthAdapter monthAdapter;
    /* 上下文 */
    private Activity context;
    /* window */
    private View popView;
    /* 年数据 */
    private List<WheelViewYear> yearList;
    /* 回调函数 */
    private YearAndMonthClickListener yearAndMonthClickListener;

    public WheelViewSelectYearAndMonth(Activity context, YearAndMonthClickListener yearAndMonthClickListener, int defaultSelecteYear, int defaultSelecteMonth) {
        super(context);
        this.context = context;
        this.yearAndMonthClickListener = yearAndMonthClickListener;
        setPopView();
        initYearAndMonth(false);
        initView(defaultSelecteYear, defaultSelecteMonth);
    }

    /**
     * @param context
     * @param yearAndMonthClickListener
     * @param defaultSelecteYear
     * @param defaultSelecteMonth
     * @param addTwoYearFromNow         从当前时间是否添加两年时间的日历选择
     */
    public WheelViewSelectYearAndMonth(Activity context, YearAndMonthClickListener yearAndMonthClickListener, int defaultSelecteYear, int defaultSelecteMonth, boolean addTwoYearFromNow) {
        super(context);
        this.context = context;
        this.yearAndMonthClickListener = yearAndMonthClickListener;
        setPopView();
        initYearAndMonth(addTwoYearFromNow);
        initView(defaultSelecteYear, defaultSelecteMonth);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.layout_wheelview_yearandmonth, null);
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
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);
        setOnDismissListener(this);
        setOutsideTouchable(true);
    }


    private void setClick() {
        mWheelViewYear.addChangingListener(this);
        mWheelViewYear.addScrollingListener(this);
        mWheelViewMonth.addChangingListener(this);
        mWheelViewMonth.addScrollingListener(this);
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
    }

    /**
     * 设置中间现实文字
     *
     * @param text
     */
    public void setCenterText(String text) {
        TextView textView = (TextView) popView.findViewById(R.id.tv_context);
        textView.setText(text);
    }

    private void initView(int defaultSelectYear, int defaultSelectMonth) {
        mWheelViewYear = (WheelView) popView.findViewById(R.id.wheel_year);
        mWheelViewMonth = (WheelView) popView.findViewById(R.id.wheel_month);
        TextView textView = (TextView) popView.findViewById(R.id.tv_context);
        textView.setText("请选择年月");

        int yearIndex = 0;
        int monthIndex = 0;
        if (defaultSelectYear == 0 || yearList == null || yearList.size() == 0) {
            yearIndex = yearList.size() - 1; //默认选择最后一条数据
        } else {
            int count = 0;
            for (WheelViewYear wheelViewYear : yearList) {
                if (wheelViewYear.year == defaultSelectYear) {
                    yearIndex = count;
                    break;
                }
                count++;
            }
        }

        List<Integer> months = yearList.get(yearIndex).getWheelViewMonth();
        if (defaultSelectMonth == 0 || months == null || months.size() == 0) {
            monthIndex = months.size() - 1; //默认选择最后一条数据
        } else {
            int count = 0;
            for (Integer month : months) {
                if (month == defaultSelectMonth) {
                    monthIndex = count;
                    break;
                }
                count++;
            }
        }

        yearAdapter = new YearAdapter(context, yearList, yearIndex);
        mWheelViewYear.setVisibleItems(5);
        mWheelViewYear.setViewAdapter(yearAdapter);
        mWheelViewYear.setCurrentItem(yearIndex);

        monthAdapter = new MonthAdapter(context, months, monthIndex);
        mWheelViewMonth.setVisibleItems(5);
        mWheelViewMonth.setViewAdapter(monthAdapter);
        mWheelViewMonth.setCurrentItem(monthIndex);

        setClick();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (yearAndMonthClickListener != null) {
                    int month = monthAdapter.list.get(mWheelViewMonth.getCurrentItem());
                    int year = yearAdapter.list.get(mWheelViewYear.getCurrentItem()).getYear();
                    yearAndMonthClickListener.YearAndMonthClick(String.valueOf(year), month < 10 ? "0" + month : String.valueOf(month));
                }
                break;
        }
        dismiss();
    }

    public void initYearAndMonth(boolean addTwoYearFromNow) {
        Calendar calendar = Calendar.getInstance();
        int yearNow = addTwoYearFromNow ? calendar.get(calendar.YEAR) + 2 : calendar.get(calendar.YEAR);
        int monthNow = calendar.get(Calendar.MONTH) + 1;
        int diffTime = yearNow - 2014;
        yearList = new ArrayList<>();
        if (diffTime <= 0) {
            //系统日期不正确添加默认值
            WheelViewYear wheelViewYear = new WheelViewYear();
            wheelViewYear.setYear(2014);
            wheelViewYear.setWheelViewMonth(getDefaultMonth());
            yearList.add(wheelViewYear);
            wheelViewYear = new WheelViewYear();
            wheelViewYear.setYear(2015);
            wheelViewYear.setWheelViewMonth(getDefaultMonth());
            yearList.add(wheelViewYear);
            wheelViewYear = new WheelViewYear();
            wheelViewYear.setYear(2016);
            wheelViewYear.setWheelViewMonth(getDefaultMonth());
            yearList.add(wheelViewYear);
            wheelViewYear.setYear(2017);
            wheelViewYear.setWheelViewMonth(getDefaultMonth());
            yearList.add(wheelViewYear);
            wheelViewYear.setYear(2018);
            wheelViewYear.setWheelViewMonth(getDefaultMonth());
            yearList.add(wheelViewYear);
        } else {
            for (int i = 0; i <= diffTime; i++) {//添加年
                WheelViewYear wheelViewYear = new WheelViewYear();
                wheelViewYear.setYear(2014 + i);
                List<Integer> wheelViewMonths = new ArrayList<>();
                if (wheelViewYear.getYear() != yearNow) {
                    for (int j = 1; j <= 12; j++) {
                        wheelViewMonths.add(j);
                    }
                } else {
                    for (int j = 1; j <= monthNow; j++) {
                        wheelViewMonths.add(j);
                    }
                }
                wheelViewYear.setWheelViewMonth(wheelViewMonths);
                yearList.add(wheelViewYear);
            }
        }
    }


    public List<Integer> getDefaultMonth() {
        List<Integer> list = new ArrayList<>();
        for (int j = 1; j <= 12; j++) {
            list.add(j);
        }
        return list;
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == mWheelViewYear) {
            String currentText = (String) yearAdapter.getItemText(wheel.getCurrentItem());
            monthAdapter.setTextViewSize(currentText, yearAdapter);
        } else {
            String currentText = (String) monthAdapter.getItemText(wheel.getCurrentItem());
            monthAdapter.setTextViewSize(currentText, monthAdapter);
        }
    }

    @Override
    public void onScrollingStarted(WheelView wheel) {

    }

    @Override
    public void onScrollingFinished(WheelView wheel) {
        if (wheel == mWheelViewYear) {
            String currentText = (String) yearAdapter.getItemText(wheel.getCurrentItem());
            monthAdapter.setTextViewSize(currentText, yearAdapter);
            List<Integer> months = yearList.get(wheel.getCurrentItem()).getWheelViewMonth();
            monthAdapter = new MonthAdapter(context, months, months.size() - 1);
            mWheelViewMonth.setVisibleItems(5);
            mWheelViewMonth.setViewAdapter(monthAdapter);
            mWheelViewMonth.setCurrentItem(months.size() - 1);
        } else {
            String currentText = (String) monthAdapter.getItemText(wheel.getCurrentItem());
            monthAdapter.setTextViewSize(currentText, monthAdapter);
        }
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }

    private class YearAdapter extends AbstractWheelTextAdapter {
        List<WheelViewYear> list;


        protected YearAdapter(Context context, List<WheelViewYear> list, int index) {
            super(context, R.layout.item_birth_year, NO_RESOURCE, index);
            this.list = list;
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            return list.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            return String.valueOf(list.get(index).getYear());
        }
    }

    private class MonthAdapter extends AbstractWheelTextAdapter {
        List<Integer> list;


        protected MonthAdapter(Context context, List<Integer> list, int index) {
            super(context, R.layout.item_birth_year, NO_RESOURCE, index);
            this.list = list;
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            return list.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            return list.get(index) < 10 ? String.valueOf("0" + list.get(index)) : String.valueOf(list.get(index));
        }

    }

    public class WheelViewYear {
        private int year;
        private List<Integer> wheelViewMonth;

        public int getYear() {
            return year;
        }

        public void setYear(int year) {
            this.year = year;
        }

        public List<Integer> getWheelViewMonth() {
            return wheelViewMonth;
        }

        public void setWheelViewMonth(List<Integer> wheelViewMonth) {
            this.wheelViewMonth = wheelViewMonth;
        }
    }


    public void update() {
        yearAdapter.setCurrentIndex(mWheelViewYear.getCurrentItem());
        monthAdapter.setCurrentIndex(mWheelViewMonth.getCurrentItem());
    }
}
