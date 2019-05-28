package noman.weekcalendar.adapter;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.view.ViewGroup;

import org.joda.time.DateTime;

import java.util.Calendar;

import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;
import noman.weekcalendar.fragment.WeekFragment;
import noman.weekcalendar.view.WeekPager;

import static noman.weekcalendar.fragment.WeekFragment.DATE_KEY;

/**
 * Created by nor on 12/4/2015.
 */
public class PagerAdapter extends FragmentStatePagerAdapter {
    /**
     * 当前选中的下标
     */
    private int currentPage;
    /**
     * 总页码
     */
    private int totalPager;
    /**
     * 时间
     */
    private DateTime date;
    /**
     * weekPager
     */
    private WeekPager weekPager;


    public PagerAdapter(FragmentManager fm, DateTime date, int totalPager, WeekPager weekPager) {
        super(fm);
        this.date = date;
        currentPage = totalPager - 1;
        this.totalPager = totalPager;
        this.weekPager = weekPager;
    }

    @Override
    public Fragment getItem(int position) {
        WeekFragment fragment = new WeekFragment();
        Bundle bundle = new Bundle();
        if (position < currentPage)
            bundle.putSerializable(DATE_KEY, getPerviousDate());
        else if (position > currentPage)
            bundle.putSerializable(DATE_KEY, getNextDate());
        else
            bundle.putSerializable(DATE_KEY, getTodaysDate());
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        super.destroyItem(container, position, object);
    }


    @Override
    public int getCount() {
        return totalPager;
    }

    private DateTime getTodaysDate() {
        return date;
    }

    private DateTime getPerviousDate() {
        return date.plusDays(-7);
    }

    private DateTime getNextDate() {
        return date.plusDays(7);
    }


    public void setDate(DateTime date) {
        this.date = date;
    }


    /**
     * 回退一周
     */
    public void swipeBack() {
        date = date.plusDays(-7);
        currentPage--;
        DateTime pagerSelecteDateTime = weekPager.getSelectedDateTime();
        if (pagerSelecteDateTime != null) {
            DateTime swipeBackDate = weekPager.getSelectedDateTime().plusDays(-7);
            if (swipeBackDate.getYear() <= 2013) { //如果滑动选中的日期小于2014-01-01则默认选择2014-01-01为默认日期
                swipeBackDate = new DateTime(2014, 1, 1, 0, 0);
                weekPager.setSelectedDateTime(swipeBackDate);
            } else {
                weekPager.setSelectedDateTime(swipeBackDate);
            }
            BusProvider.getInstance().post(new Event.InvalidateEvent()); //初始化选中状态
            BusProvider.getInstance().post(new Event.OnDateClickEvent(swipeBackDate));
        }
    }

    /**
     * 前进一周
     */
    public void swipeForward() {
        date = date.plusDays(7);
        currentPage++;
        DateTime pagerSelecteDateTime = weekPager.getSelectedDateTime();
        if (pagerSelecteDateTime != null) {
            DateTime forWardDate = pagerSelecteDateTime.plusDays(+7);
            if (forWardDate.getMillis() > Calendar.getInstance().getTimeInMillis()) { //不能大于当前时间
                forWardDate = new DateTime();
                weekPager.setSelectedDateTime(forWardDate); //设置为今天的日期
            } else {
                weekPager.setSelectedDateTime(forWardDate);
            }
            BusProvider.getInstance().post(new Event.InvalidateEvent()); //初始化选中状态
            BusProvider.getInstance().post(new Event.OnDateClickEvent(forWardDate));
        }
    }

    public DateTime getDate() {
        return date;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }


}
