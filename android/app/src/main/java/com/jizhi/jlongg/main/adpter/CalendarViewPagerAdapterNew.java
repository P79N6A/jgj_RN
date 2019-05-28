package com.jizhi.jlongg.main.adpter;

import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.view.ViewGroup;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.fragment.worker.CalendarDetailFragment;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;

/**
 * ViewPager  fragment 管理器
 *
 * @author Xuj
 * @time 2015年12月30日 11:25:27
 * @Version 1.0
 */
public class CalendarViewPagerAdapterNew extends FragmentStatePagerAdapter {

    /**
     * 日历总数
     */
    private int calendarCount;
    /**
     * 当前页
     */
    private int currentPage;
    /**
     * 开始年，月
     */
    private int startYear, startMonth;
    /**
     * 当前滑动选中的Fragment
     */
    private Fragment currentFragment;

    public CalendarViewPagerAdapterNew(FragmentManager fm) {
        super(fm);
        int differenceBetweenMonth = 0; //相差月份个数
        CustomDate currentTime = new CustomDate();
        try {
            differenceBetweenMonth = DateUtil.countMonths("2014-01", currentTime.getYear() + "-" + currentTime.getMonth(), "yyyy-MM"); // 获取2014年1月到现在相差多少个月
        } catch (Exception e) {
            e.printStackTrace();
        }
        int startYear = 2014; // 开始时间2014年
        int startMonth = 1; // 1月
        for (int i = 0; i <= differenceBetweenMonth; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            startMonth += 1;
            calendarCount++;
        }
        this.startYear = startYear;
        this.startMonth = startMonth;
        currentPage = calendarCount - 1;
    }


    @Override
    public int getCount() {
        return calendarCount;
    }

    @Override
    public Fragment getItem(int position) {
        if (position < currentPage) {
            setPerviousDate();
        } else if (position > currentPage) {
            setNextDate();
        }
        CalendarDetailFragment fragment = new CalendarDetailFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, 1));
        bundle.putInt("fragmentPosition", currentPage);
        fragment.setArguments(bundle);
        return fragment;
    }

    private void setPerviousDate() {
        startMonth--;
        if (startMonth == 0) {
            startMonth = 12;
            startYear--;
        }
        currentPage--;
    }

    private void setNextDate() {
        startMonth++;
        if (startMonth > 12) {
            startYear++;
            startMonth = 1;
        }
        currentPage++;
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        LUtils.e("销毁:" + "          position:" + position);
        super.destroyItem(container, position, object);
    }

    @Override
    public Parcelable saveState() {
        LUtils.e("调用保存状态的信息方法");
//        return super.saveState();
        return null;
    }

    @Override
    public void restoreState(Parcelable state, ClassLoader loader) {
        LUtils.e("恢复保存状态的信息方法");
//        super.restoreState(state, loader);
    }


    public Fragment getCurrentFragment() {
        return currentFragment;
    }

    public void setCurrentFragment(Fragment currentFragment) {
        this.currentFragment = currentFragment;
    }
}
