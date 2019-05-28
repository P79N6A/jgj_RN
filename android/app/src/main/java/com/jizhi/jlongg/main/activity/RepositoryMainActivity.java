package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;

import com.flyco.tablayout.SlidingTabLayout;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.fragment.repository.RepositoryFragment;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.umeng.analytics.MobclickAgent;

import java.util.ArrayList;
import java.util.List;


/**
 * 知识库主页
 *
 * @author Xuj
 * @time 2017年3月24日17:34:51
 * @Version 1.3.0
 */
public class RepositoryMainActivity extends BaseActivity implements View.OnClickListener {

    /**
     * fragments
     */
    private ArrayList<Fragment> fragments = null;
    /**
     * 知识库顶部滑动标题
     */
    private List<String> mTitles;
    /**
     * 顶部ViewPager滑动组件
     */
    private SlidingTabLayout slidingTabLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.repository);
        setTextTitle(R.string.repository);
        final View leftView = findViewById(R.id.leftImage); //隐藏搜索图标
        final View rightView = findViewById(R.id.rightImage); //隐藏收藏图标
        leftView.setVisibility(View.GONE);
        rightView.setVisibility(View.GONE);
        //加载知识库标题数据
        RepositoryUtil.loadRepositoryData(RepositoryUtil.ROOT_DIR_INDEX, null, this, new RepositoryUtil.LoadRepositoryListener() {
            @Override
            public void loadRepositorySuccess(List<Repository> list) {
                leftView.setVisibility(View.VISIBLE); //显示搜索图标
                rightView.setVisibility(View.VISIBLE); //显示收藏图标
                fragments = new ArrayList<>();
                mTitles = new ArrayList<>();
                for (Repository repository : list) { //填充知识库标题数据
                    Bundle bundle = new Bundle();
                    bundle.putString("params1", repository.getId());
                    RepositoryFragment fragment = new RepositoryFragment(); //行业规范
                    fragment.setArguments(bundle);
                    fragments.add(fragment);
                    mTitles.add(repository.getFile_name());
                }
                initViewPager();
            }

            @Override
            public void loadRepositoryError() {

            }
        }, 1);
        MobclickAgent.onEvent(this, "click_repository_module"); //U盟点击知识库模块统计
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String id) {
        Intent intent = new Intent(context, RepositoryMainActivity.class);
        intent.putExtra("param1", id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 初始化ViewPager
     */
    private void initViewPager() {
        slidingTabLayout = (SlidingTabLayout) findViewById(R.id.navigationView);
        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
        viewPager.setAdapter(new MyPagerAdapter(getSupportFragmentManager()));
        slidingTabLayout.setViewPager(viewPager);
        int framentsSize = fragments.size();
        viewPager.setOffscreenPageLimit(framentsSize);
        String selectedId = getIntent().getStringExtra("param1");
        if (!TextUtils.isEmpty(selectedId)) { //选中点击的下标
            for (int i = 0; i < framentsSize; i++) {
                RepositoryFragment fragment = (RepositoryFragment) fragments.get(i);
                if (selectedId.equals(fragment.getFileId())) {
                    slidingTabLayout.setCurrentTab(i);
                }
            }
        }

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.leftImage: //搜索按钮
                RepositorySearchingActivity.actionStart(this);
                break;
            case R.id.rightImage: //收藏按钮
                if (!IsSupplementary.accessLogin(RepositoryMainActivity.this)) { //是否已经登录
                    return;
                }
                RepositoryCollectionActivity.actionStart(this);
                break;
        }
    }

    private class MyPagerAdapter extends FragmentPagerAdapter {
        public MyPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public int getCount() {
            return fragments.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return mTitles.get(position);
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Fragment fragment = fragments.get(slidingTabLayout.getCurrentTab());
        if (fragment != null && fragment.isAdded()) {
            fragment.onActivityResult(requestCode, resultCode, data);
        }
        if (resultCode == RepositoryUtil.SEARCH_OVER) { //模糊搜索文档结束时的回调 ，因为不确定 搜索下载了哪些文件夹 所以要先清空所有的Fragment 数据
            for (Fragment fragmen : fragments) {
                if (fragmen != null && fragmen.isAdded()) {
                    fragmen.onActivityResult(requestCode, resultCode, data);
                }
            }
        }
    }
}