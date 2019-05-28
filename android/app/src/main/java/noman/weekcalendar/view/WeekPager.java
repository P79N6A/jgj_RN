package noman.weekcalendar.view;

import android.content.Context;
import android.os.Build;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewTreeObserver;

import com.jizhi.jlongg.main.activity.BaseActivity;
import com.squareup.otto.Subscribe;

import org.joda.time.DateTime;
import org.joda.time.DateTimeConstants;
import org.joda.time.LocalDate;
import org.joda.time.Weeks;

import java.util.Calendar;
import java.util.GregorianCalendar;

import noman.weekcalendar.adapter.PagerAdapter;
import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;

/**
 * Created by nor on 12/5/2015.
 */
public class WeekPager extends ViewPager {
    /* ViewPager 适配器 */
    private PagerAdapter adapter;
    /* ViewPager 下标 */
    private int currentPosition;
    /* ViewPager 总页数 */
    private int weekPageTotal;
    /* 当前选择的时间 */
    public DateTime selectedDateTime;

    public WeekPager(Context context) {
        super(context);
        initialize();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int height = 0;
        //下面遍历所有child的高度
        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);
            child.measure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED));
            int h = child.getMeasuredHeight();
            if (h > height) //采用最大的view的高度。
                height = h;
        }
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    public WeekPager(Context context, AttributeSet attrs) {
        super(context, attrs);
        initialize();
    }

    private void initialize() {
        setId(idCheck());
        if (!isInEditMode()) {
            initPager();
            BusProvider.getInstance().register(this);
        }
    }

    private void initPager() {
        int startYear = 2014;
        Calendar calendar = Calendar.getInstance();
        int difference = calendar.get(Calendar.YEAR) - startYear; //2014年到现在 相差多少年
        for (int i = 0; i <= difference; i++) { //计算当前日期距离2014年共有多少个周末
            int year = calendar.get(Calendar.YEAR);
            int month = calendar.get(Calendar.MONTH);
            int day = calendar.get(Calendar.DAY_OF_MONTH);
            currentPosition += getWeekOfYear(year, month, day);//当前时间有多少周
            calendar.set(Calendar.YEAR, year - 1);
            calendar.set(Calendar.MONTH, 11);
            calendar.set(Calendar.DAY_OF_MONTH, 31);
        }
        currentPosition += 1; //有可能显示不出来2014-1-1号
        weekPageTotal = currentPosition;
        adapter = new PagerAdapter(((BaseActivity) getContext()).getSupportFragmentManager(), new DateTime(), weekPageTotal, this);
        setAdapter(adapter);
        setOnPageChangeListener(new OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                if (position < currentPosition) { //如果是往左滑 则显示上一周
                    adapter.swipeBack();
                } else if (position > currentPosition) {//如果是往右滑 则显示下一周
                    adapter.swipeForward();
                }
                currentPosition = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        currentPosition -= 1;
        setOverScrollMode(OVER_SCROLL_NEVER);
        if (selectedDateTime == null) {
            selectedDateTime = new DateTime();
        }
        getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                setCurrentItem(currentPosition);
                if (Build.VERSION.SDK_INT < 16) {
                    getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }

    // 获取当前时间所在年的周数
    public int getWeekOfYear(int year, int month, int day) {
        Calendar c = new GregorianCalendar();
        c.setFirstDayOfWeek(Calendar.MONDAY);
        c.setMinimalDaysInFirstWeek(7);
        c.set(Calendar.YEAR, year);
        c.set(Calendar.MONTH, month);
        c.set(Calendar.DAY_OF_MONTH, day);
        return c.get(Calendar.WEEK_OF_YEAR);
    }


    public void update(int betweenWeeks) {
        betweenWeeks += 1;
        currentPosition = weekPageTotal - betweenWeeks;
        if (currentPosition <= 0) {
            currentPosition += 1;
        }
        adapter.setCurrentPage(currentPosition);
        adapter.setDate(selectedDateTime);
        setCurrentItem(currentPosition);
        BusProvider.getInstance().post(new Event.InvalidateEvent());
    }

    @Subscribe
    public void setCurrentPage(Event.SetCurrentPageEvent event) {
        if (event.getDirection() == 1) {
            adapter.swipeForward();
            currentPosition += 1;
        } else {
            adapter.swipeBack();
            currentPosition -= 1;
        }
        setCurrentItem(getCurrentItem() + event.getDirection());
    }

    @Subscribe
    public void setSelectedDate(Event.JumpDateEvent event) {
        DateTime lastDay = new DateTime();
        lastDay = lastDay.withDayOfWeek(DateTimeConstants.THURSDAY).plusDays(3);
        selectedDateTime = event.getSelectedDate();
        LocalDate startDate = new LocalDate(selectedDateTime.getYear(), selectedDateTime.getMonthOfYear(), selectedDateTime.getDayOfMonth());
        LocalDate weekEndDate = new LocalDate(lastDay.getYear(), lastDay.getMonthOfYear(), lastDay.getDayOfMonth());
        int betweenWeeks = Weeks.weeksBetween(startDate, weekEndDate).getWeeks(); //相差多少个周末
        update(betweenWeeks);
    }


    private int idCheck() {
        int id = 0;
        while (findViewById(++id) != null) ;
        return id;
    }

    public DateTime getSelectedDateTime() {
        return selectedDateTime;
    }

    public void setSelectedDateTime(DateTime selectedDateTime) {
        this.selectedDateTime = selectedDateTime;
    }
}
