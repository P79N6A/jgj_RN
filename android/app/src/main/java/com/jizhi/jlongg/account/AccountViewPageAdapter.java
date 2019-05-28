package com.jizhi.jlongg.account;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.List;

/**
 * 记账viewpager适配器
 */

public class AccountViewPageAdapter extends FragmentPagerAdapter {
    private List<AccountFragment> fragmentsList;

    public AccountViewPageAdapter(FragmentManager fm) {
        super(fm);
    }

    public AccountViewPageAdapter(FragmentManager fm, List<AccountFragment> fragments) {
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
