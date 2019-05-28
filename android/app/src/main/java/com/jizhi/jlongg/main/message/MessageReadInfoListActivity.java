package com.jizhi.jlongg.main.message;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.flyco.tablayout.SlidingTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;

import java.util.ArrayList;

/**
 * CName:消息已读未读列表
 * User: hcs
 * Date: 2016-08-25
 * Time: 11:42
 */
public class MessageReadInfoListActivity extends BaseActivity implements OnTabSelectListener {
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    private MyPagerAdapter mAdapter;
    private ViewPager vp;
    protected GroupDiscussionInfo gnInfo;
    protected String msg_id;
    //true 聊天 false通知日志等
    protected boolean isMsg;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_msg_readinfo_tab);
        getIntentData();
        initView();
        if (isMsg) {
            setTextTitle(R.string.message_read_list);
        } else {
            setTextTitle(R.string.message_read_detail);
        }

    }

    public static void actionStart(Activity context, GroupDiscussionInfo info, String msg_id, boolean is_msg) {
        Intent intent = new Intent(context, MessageReadInfoListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, is_msg);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    protected void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        msg_id = getIntent().getStringExtra(Constance.MSG_ID);
        isMsg = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
    }


    private void initView() {
        mTitles = getResources().getStringArray(R.array.messageTypeReadInfo);
        MessageUnReadListFragment unreadListFragment = new MessageUnReadListFragment();
        MessageReadListFragment readListFragmengt = new MessageReadListFragment();
        mFragments.add(unreadListFragment);
        mFragments.add(readListFragmengt);
        View decorView = getWindow().getDecorView();
        vp = ViewFindUtils.find(decorView, R.id.vp);
        mAdapter = new MyPagerAdapter(getSupportFragmentManager());
        vp.setAdapter(mAdapter);
        /**自定义部分属性*/
        SlidingTabLayout tabLayout_2 = ViewFindUtils.find(decorView, R.id.tl_2);
        tabLayout_2.setViewPager(vp);
        tabLayout_2.setOnTabSelectListener(this);
    }

    @Override
    public void onTabSelect(int position) {
    }

    @Override
    public void onTabReselect(int position) {
    }


    private class MyPagerAdapter extends FragmentPagerAdapter {
        public MyPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public int getCount() {
            return mFragments.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return mTitles[position];
        }

        @Override
        public Fragment getItem(int position) {
            return mFragments.get(position);
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }
}
