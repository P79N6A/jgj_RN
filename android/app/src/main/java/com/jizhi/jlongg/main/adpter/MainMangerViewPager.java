package com.jizhi.jlongg.main.adpter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.ArrayList;

/**
 * ViewPager  fragment 管理器
 *
 * @author Xuj
 * @time 2015年12月30日 11:25:27
 * @Version 1.0
 */
public class MainMangerViewPager extends FragmentPagerAdapter {
    private ArrayList<Fragment> fragmentsList;

    public MainMangerViewPager(FragmentManager fm) {
        super(fm);
    }

    public MainMangerViewPager(FragmentManager fm, ArrayList<Fragment> fragments) {
        super(fm);
        this.fragmentsList = fragments;
    }

    @Override
    public int getCount() {
        return fragmentsList.size();
    }

    @Override
    public Fragment getItem(int arg0) {
        return fragmentsList.get(arg0);
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }


}
