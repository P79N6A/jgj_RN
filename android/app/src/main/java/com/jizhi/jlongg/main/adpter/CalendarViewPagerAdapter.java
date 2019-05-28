package com.jizhi.jlongg.main.adpter;

import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.view.ViewGroup;

import java.util.ArrayList;

/**
 * ViewPager  fragment 管理器
 *
 * @author Xuj
 * @time 2015年12月30日 11:25:27
 * @Version 1.0
 */
public class CalendarViewPagerAdapter extends FragmentStatePagerAdapter {

    private ArrayList<Fragment> fragmentsList;

    public CalendarViewPagerAdapter(FragmentManager fm, ArrayList<Fragment> fragments) {
        super(fm);
        this.fragmentsList = fragments;
    }


    @Override
    public int getCount() {
        return fragmentsList.size();
    }

    @Override
    public Fragment getItem(int position) {
//        LUtils.e("创建:" + fragmentsList.get(position) + "          position:" + position);
        return fragmentsList.get(position);
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
//        LUtils.e("销毁:" + fragmentsList.get(position) + "          position:" + position);
        super.destroyItem(container, position, object);
    }

    @Override
    public Parcelable saveState() {
//        LUtils.e("调用保存状态的信息方法");
//        return super.saveState();
        return null;
    }

    @Override
    public void restoreState(Parcelable state, ClassLoader loader) {
//        LUtils.e("恢复保存状态的信息方法");
//        super.restoreState(state, loader);
    }
}
