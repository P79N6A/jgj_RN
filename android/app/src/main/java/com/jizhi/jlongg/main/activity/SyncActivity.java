package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.fragment.sync.SyncRecordFragment;
import com.jizhi.jlongg.main.fragment.sync.SyncToMeRecordFragment;
import com.jizhi.jlongg.main.util.Constance;

import java.util.ArrayList;
import java.util.List;

/**
 * 作者    xuj
 * 时间    2018-12-14 上午 10:10
 * 文件    同步记工
 * 描述
 */
public class SyncActivity extends BaseActivity implements View.OnClickListener {
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
    /**
     * 当前View选中的下标
     */
    private int cureentIndex;
    /**
     * 导航栏右边的标题
     */
    private TextView rightTitle;
    /**
     * 是否在编辑
     */
    public boolean isEditor;


    /**
     * 启动当前Activity
     *
     * @param selecteRecordToMe true表示选中同步给我的记工
     * @param context
     */
    public static void actionStart(Activity context, boolean selecteRecordToMe) {
        Intent intent = new Intent(context, SyncActivity.class);
        intent.putExtra(Constance.PAGE, selecteRecordToMe);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sync_account_main);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.sync_account);
        rightTitle = findViewById(R.id.right_title);
        rightTitle.setText(R.string.delete);
        fragments = new ArrayList<>();
        mTitles = new ArrayList<>();

        fragments.add(getSyncToMeRecordFragment());
        fragments.add(getSyncRecordFragment());

        mTitles.add(getString(R.string.sync_to_me));
        mTitles.add(getString(R.string.sync_account));

        initViewPager();
    }


    /**
     * 初始化ViewPager
     * 这时，如果页面3中有需要耗时的事件，比如网络访问。那么，在我们进行 1-->2 的操作的时候，就会不断的出现页面3加载的对话框（如果有的话）。而且如果快速的 1-->2-->3的切换，3中的内容很可能还没加载出来。
     * 这样重复的加载，既影响体验、又耗费时间和流量，所以笔者这两天一直在查如何在Fragment移出的时候不要销毁，或者保存状态。
     * 后来发现真是多此一举，如果你的软件对内存消耗不是很在意的话，只需加入以下代码：
     * mViewPager.setOffscreenPageLimit(2);
     * 就可以让ViewPager多缓存一个页面，这样上面的问题就得到了解决。
     * ViewPager里面定义了一个
     * private int mOffscreenPageLimit = DEFAULT_OFFSCREEN_PAGES;默认值 是1,这表示你的预告加载的页面数量是1,假设当前有四个Fragment的tab,显示一个,预先加载下一个.这样你在移动前就已经加载了下一个界面,移动时就可以看到已经加载的界面了.
     * 可以通过修改这个值,但有,修改后就会有一个麻烦的地方,因为移动时不会预先加载下一个界面的关系,所以会看到一片黑色的背景.
     * 如果不介意黑色背景,可以覆盖这个类,然后定义默认的加载数量为0
     * private int mOffscreenPageLimit = DEFAULT_OFFSCREEN_PAGES=0;就是不预先加载下一个界面.
     * 如果想预加载，可以使用原来的ViewPager，或这里直接改为mOffscreenPageLimit=你要加载的数量。
     * LazyViewPager没有预加载
     */
    private void initViewPager() {
        slidingTabLayout = (SlidingTabLayout) findViewById(R.id.sliding_table_layout);
        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
        viewPager.setAdapter(new MyPagerAdapter(getSupportFragmentManager()));
        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (position == 0) { //同步给我的记工
                    rightTitle.setText(R.string.delete);
                    rightTitle.setCompoundDrawables(null, null, null, null);
                } else { //同步记工
                    Drawable mClearDrawable = getResources().getDrawable(R.drawable.chat_add_small_icon);
                    mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
                    rightTitle.setText(R.string.add_sync);
                    rightTitle.setCompoundDrawables(mClearDrawable, null, null, null);
                }
                if (isEditor) { //如果正在编辑状态则取消编辑状态
                    isEditor = !isEditor;
                    ((SyncToMeRecordFragment) fragments.get(0)).setEditor(isEditor);
                }
                cureentIndex = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        slidingTabLayout.setViewPager(viewPager);
        slidingTabLayout.setCurrentTab(getIntent().getBooleanExtra(Constance.PAGE, true) ? 0 : 1);
    }

    /**
     * 获取同步给我的记工Fragment
     *
     * @return
     */
    private Fragment getSyncToMeRecordFragment() {
        Fragment fragment = new SyncToMeRecordFragment();
        return fragment;
    }

    /**
     * 获取同步记工Fragment
     *
     * @return
     */
    private Fragment getSyncRecordFragment() {
        Fragment fragment = new SyncRecordFragment();
        return fragment;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //删除和新增同步按钮
                if (cureentIndex == 0) { //同步给我的记工
                    isEditor = !isEditor;
                    rightTitle.setText(isEditor ? R.string.cancel : R.string.delete);
                    ((SyncToMeRecordFragment) fragments.get(cureentIndex)).setEditor(isEditor);
                } else { //同步记工
                    SelecteSyncTypeActivity.actionStart(this);//跳转到新增同步
                }
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

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            super.destroyItem(container, position, object);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        fragments.get(cureentIndex).onActivityResult(requestCode, resultCode, data);
    }

}
