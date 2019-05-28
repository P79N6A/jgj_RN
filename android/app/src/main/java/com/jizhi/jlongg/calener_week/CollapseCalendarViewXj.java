package com.jizhi.jlongg.calener_week;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;

import org.joda.time.DateTimeConstants;
import org.joda.time.LocalDate;

import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class CollapseCalendarViewXj extends LinearLayout {

    private static final String TAG = "CalendarView";

    @Nullable
    private CalendarManager mManager;
    @NonNull
    private LinearLayout mWeeksView;

    @NonNull
    private final LayoutInflater mInflater;
    @NonNull
    private final RecycleBin mRecycleBin = new RecycleBin();

    @Nullable
    private OnDateSelect mListener;
    @NonNull
    private TextView mSelectionText;

    @NonNull
    private ResizeManager mResizeManager;

    private boolean initialized;
    private LocalDate currentDate;
    private List<Day> days;

    public CollapseCalendarViewXj(Context context) {
        this(context, null);
    }

    public CollapseCalendarViewXj(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.calendarViewStyle);
    }

    @SuppressLint("NewApi")
    public CollapseCalendarViewXj(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        mInflater = LayoutInflater.from(context);
//        mResizeManager = new ResizeManager(this);
        inflate(context, R.layout.calendar_layout, this);
        setOrientation(VERTICAL);
    }

    public void init(@NonNull CalendarManager manager) {
        if (manager != null) {
            mManager = manager;
            // 初始化星期一到星期日总体
            populateLayout();
            if (mListener != null) {
                currentDate = mManager.getSelectedDay();
                mListener.onDateSelected(mManager.getSelectedDay());
            }
        }
    }

    @Nullable
    public CalendarManager getManager() {
        return mManager;
    }


    @SuppressLint("WrongCall")
    @Override
    protected void dispatchDraw(@NonNull Canvas canvas) {
        mResizeManager.onDraw();
        super.dispatchDraw(canvas);
    }

    @Nullable
    public CalendarManager.State getState() {
        if (mManager != null) {
            return mManager.getState();
        } else {
            return null;
        }
    }

    public void setListener(@Nullable OnDateSelect listener) {
        mListener = listener;
    }


    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        mWeeksView = (LinearLayout) findViewById(R.id.weeks);
        mSelectionText = (TextView) findViewById(R.id.selection_title);
        populateLayout();
    }

    /**
     * 初始化星期一到星期日头
     */
    private void populateDays() {
        if (!initialized) {
            CalendarManager manager = getManager();
            if (manager != null) {
                Formatter formatter = manager.getFormatter();
                LinearLayout layout = (LinearLayout) findViewById(R.id.days);
                LocalDate date = LocalDate.now().withDayOfWeek(DateTimeConstants.MONDAY);
                // 初始化星期一到星期日头
                for (int i = 0; i < 7; i++) {
                    TextView textView = (TextView) layout.getChildAt(i);
                    String d = formatter.getDayName(date);
                    if (d.contains("周")) {
                        textView.setText(d.replace("周", ""));
                    } else if (d.contains("星期")) {
                        textView.setText(d.replace("星期", ""));
                    } else {
                        textView.setText(d);
                    }
                    if (i == 0 || i == 6) {
                        textView.setTextColor(getResources().getColor(R.color.app_color));
                    } else {
                        textView.setTextColor(getResources().getColor(R.color.canlendar_text_color));
                    }
                    date = date.plusDays(1);
                }
                initialized = true;
            }
        }

    }

    /**
     * 初始化星期一到星期日总体
     */
    public void populateLayout() {
        if (mManager != null) {
            populateDays();
            if (mManager.getState() == CalendarManager.State.MONTH) {
                populateMonthLayout((Month) mManager.getUnits());
            } else {
                // 设置日期数据
                populateWeekLayout((Week) mManager.getUnits());
            }
        }

    }

    private void populateMonthLayout(Month month) {
        List<Week> weeks = month.getWeeks();
        int cnt = weeks.size();
        for (int i = 0; i < cnt; i++) {
            WeekView weekView = getWeekView(i);
            populateWeekLayout(weeks.get(i), weekView);
        }
        int childCnt = mWeeksView.getChildCount();
        if (cnt < childCnt) {
            for (int i = cnt; i < childCnt; i++) {
                cacheView(i);
            }
        }

    }

    /**
     * 设置日期数据
     *
     * @param week
     */
    private void populateWeekLayout(Week week) {
        WeekView weekView = getWeekView(0);
        populateWeekLayout(week, weekView);
        //
//        List<Day> days = week.getDays();
//        boolean compDate = false;
//        for (int i = 0; i < days.size(); i++) {
//            Day day = days.get(i);
//            boolean compDates = Utils.compare_date(day.getDate().getYear() + "-" + day.getDate().getMonthOfYear() + "-" + day.getDate().getDayOfMonth());
//            if (compDates) {
//                compDate = compDates;
//            }
//        }
//        if (compDate) {
//            for (int i = 0; i < days.size(); i++) {
//                if (i == 0) {
//                    mManager.selectDay(days.get(0).getDate());
//                    days.get(0).setSelected(true);
//                } else {
//                    days.get(i).setSelected(false);
//                }
//
//            }
//        }
        int cnt = mWeeksView.getChildCount();
        if (cnt > 1) {
            for (int i = cnt - 1; i > 0; i--) {
                cacheView(i);
            }
        }
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        touchEvent(event);

        return super.dispatchTouchEvent(event);

    }

    //    @Override
//    public boolean onTouchEvent(MotionEvent event) {
//        touchEvent(event);
//        return true;
//    }
    int downXInstance;
    int moveXInstance;
    int downYInstance;
    int moveYInstance;

    private void touchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                downXInstance = (int) event.getX();
                break;
            case MotionEvent.ACTION_MOVE:
                moveXInstance = (int) event.getX();
                break;
            case MotionEvent.ACTION_UP:
                int stanceX = downXInstance - moveXInstance;
                int stanceY = downYInstance - moveYInstance;
                if (null != days) {
                    for (int i = 0; i < days.size(); i++) {
                        Day day = days.get(i);
                        boolean compDate = Utils.compare_date(day.getDate().getYear() + "-" + day.getDate().getMonthOfYear() + "-" + day.getDate().getDayOfMonth());
                        if (compDate) {
                            clearInstance();
                            return;
                        }
                    }
                }
                if (stanceX > 200 && stanceY < Math.abs(50)) {
                    clearInstance();
                    if (mManager.next()) {
                        populateLayout();
                    }
                } else if (stanceX < -200 && stanceY < Math.abs(50)) {
                    clearInstance();
                    if (mManager.prev()) {
                        populateLayout();
                    }
                }
                break;
        }
    }

    public void clearInstance() {
        downXInstance = 0;
        moveXInstance = 0;
        downYInstance = 0;
        moveYInstance = 0;
    }

    public void monthturning(int stance) {
        if (stance > 200) {
//            days.get(6).get
//            String nowtime = LocalDate.now().getYear() + "-" + LocalDate.now().getMonthOfYear() + "-" + LocalDate.now().getDayOfMonth();
//            System.out.println(days.get(6).getDate()+",,,,"+nowtime);
            if (null != days) {
                for (int i = 0; i < days.size(); i++) {
                    Day day = days.get(i);
                    boolean compDate = Utils.compare_date(day.getDate().getYear() + "-" + day.getDate().getMonthOfYear() + "-" + day.getDate().getDayOfMonth());
                    if (compDate) {
                        clearInstance();
                        return;
                    }
                }
            }
            currentDate = currentDate.plusDays(1);
            mManager = null;
            mManager = new CalendarManager(currentDate,
                    CalendarManager.State.WEEK, currentDate.withYear(100),
                    currentDate.plusYears(10));
            init(mManager);
        } else if (stance < -200) {
            currentDate = currentDate.minusDays(1);
            mManager = null;
            mManager = new CalendarManager(currentDate,
                    CalendarManager.State.WEEK, currentDate.withYear(100),
                    currentDate.plusYears(10));
            init(mManager);
        }
    }

    private void populateWeekLayout(@NonNull Week week, @NonNull WeekView weekView) {
        days = week.getDays();
        for (int i = 0; i < 7; i++) {
            final Day day = days.get(i);

            // DayView dayView = (DayView) weekView.getChildAt(i);
            LinearLayout layout = (LinearLayout) weekView.getChildAt(i);
            final DayView dayView = (DayView) layout.findViewById(R.id.tvDayView);
            DayView tvChinaDay = (DayView) layout.findViewById(R.id.tvChinaDay);
            //比较日期大小
            String dTime = day.getDate().getYear() + "-" + day.getDate().getMonthOfYear() + "-" + day.getDate().getDayOfMonth();
            final boolean compDate = Utils.compare_date(dTime);
            dayView.setText(day.getText());
            tvChinaDay.setText(day.getChinaDate());
            Resources res = getResources();
            if (!compDate) {
                boolean isd = Utils.compare_equaldate(dTime);
                if (day.isSelected()) {
                    if (isd) {
                        Utils.setBackGround(layout, res.getDrawable(R.drawable.bg_btn_calendar_nowdate));
                    } else {
                        Utils.setBackGround(layout, res.getDrawable(R.drawable.bg_btn_calendar));
                    }
                    dayView.setTextColor(res.getColor(R.color.white));
                    tvChinaDay.setTextColor(res.getColor(R.color.white));
                } else {
                    if (isd) {
                        dayView.setTextColor(res.getColor(R.color.app_color));
                        tvChinaDay.setTextColor(res.getColor(R.color.app_color));
                    } else {
                        dayView.setTextColor(res.getColor(R.color.text_normal));
                        tvChinaDay.setTextColor(res.getColor(R.color.text_normal));
                    }
                }
            } else {
                //以后的时间设置时间为灰色
                dayView.setTextColor(res.getColor(R.color.gray_bbbbbb));
                tvChinaDay.setTextColor(res.getColor(R.color.gray_bbbbbb));
            }
            if (day.isSelected()) {
                if (compDate && i != 0) {
                    mManager.selectDay(days.get(i - 1).getDate());
                    populateLayout();
                    return;
                } else {
                    if (mListener != null) {
                        mListener.onDateSelected(day.getDate());
                    }
                }
            }
            layout.setSelected(day.isSelected());
//            dayView.setCurrent(day.isCurrent());
            tvChinaDay.setCurrent(day.isCurrent());
            boolean enables = day.isEnabled();
            dayView.setEnabled(enables);

            if (enables) { // 解除点击限制，所有的都可以点击
                layout.setOnClickListener(new OnClickListener() {
                    @Override
                    public void onClick(View v) {
//                        System.out.println("========OnClick=====1111=====");
                        if (!compDate) {
//                            System.out.println("=======OnClick=======2222====");
                            currentDate = day.getDate();
                            if (mManager.selectDay(currentDate)) {
                                populateLayout();
                                if (mListener != null) {
                                    mListener.onDateSelected(currentDate);
                                }
                            }
                        } else {
                            dayView.setOnClickListener(null);
                        }

                    }
                });
            } else {
                dayView.setOnClickListener(null);
            }


        }

    }

    @NonNull
    public LinearLayout getWeeksView() {
        return mWeeksView;
    }

    @NonNull
    private WeekView getWeekView(int weekIndex) {
        int cnt = mWeeksView.getChildCount();
        if (cnt < weekIndex + 1) {
            for (int i = cnt; i < weekIndex + 1; i++) {
                View view = getView();
                mWeeksView.addView(view);
            }
        }
        return (WeekView) mWeeksView.getChildAt(weekIndex);
    }

    private View getView() {
        View view = mRecycleBin.recycleView();
        if (view == null) {
            view = mInflater.inflate(R.layout.week_layout, this, false);
        } else {
            view.setVisibility(View.VISIBLE);
        }
        return view;
    }

    private void cacheView(int index) {
        View view = mWeeksView.getChildAt(index);
        if (view != null) {
            mWeeksView.removeViewAt(index);
            mRecycleBin.addView(view);
        }
    }

    public LocalDate getSelectedDate() {
        return mManager.getSelectedDay();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();

        mResizeManager.recycle();
    }

    private class RecycleBin {

        private final Queue<View> mViews = new LinkedList<View>();

        @Nullable
        public View recycleView() {
            return mViews.poll();
        }

        public void addView(@NonNull View view) {
            mViews.add(view);
        }

    }

    public interface OnDateSelect {
        public void onDateSelected(LocalDate date);
    }

}
