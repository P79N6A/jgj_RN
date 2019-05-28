package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.ViewGroup;

import com.flyco.tablayout.SlidingTabLayout;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.fragment.checkplan.CheckListContentFragment;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:检查项
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class CheckListActivity extends BaseActivity {

    /**
     * 检查项编号
     */
    public static final int CHECK_LIST = 0;
    /**
     * 检查项内容
     */
    public static final int CHECK_CONTENT = 1;
    /**
     * 检查项标识
     */
    public static final String CHECK_LIST_STRING = "pro";
    /**
     * 检查内容标识
     */
    public static final String CHECK_CONTENT_STRING = "content";
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
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupId, boolean isClosed) {
        Intent intent = new Intent(context, CheckListActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.check_list);
        initView();
        registerReceiver();
    }

    private void initView() {
        setTextTitle(R.string.check_list);

        fragments = new ArrayList<>();
        mTitles = new ArrayList<>();

        fragments.add(getCheckListFragment());
        fragments.add(getCheckListContentFragment());

        mTitles.add("检查项");
        mTitles.add("检查内容");

        initViewPager();
    }

    /**
     * 获取检查项Fragment
     *
     * @return
     */
    private Fragment getCheckListFragment() {
        Fragment checkListContentFragment = new CheckListContentFragment(); //检查项
        Bundle bundle = new Bundle();
        bundle.putInt(Constance.NAVIGATION_ID, CHECK_LIST);
        checkListContentFragment.setArguments(bundle);
        return checkListContentFragment;
    }

    /**
     * 获取检查内容Fragment
     *
     * @return
     */
    private Fragment getCheckListContentFragment() {
        Fragment checkListContentFragment = new CheckListContentFragment(); //检查项
        Bundle bundle = new Bundle();
        bundle.putInt(Constance.NAVIGATION_ID, CHECK_CONTENT);
        checkListContentFragment.setArguments(bundle);
        return checkListContentFragment;
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
        slidingTabLayout = (SlidingTabLayout) findViewById(R.id.navigationView);
        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
        viewPager.setAdapter(new MyPagerAdapter(getSupportFragmentManager()));
        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                cureentIndex = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        slidingTabLayout.setViewPager(viewPager);
        slidingTabLayout.setCurrentTab(0);
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

    /**
     * 注册广播
     */
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.ACTION_CHECK_INFO_UN_EXIST);//检查项、或者检查内容列表已经被删除需要刷新列表数据
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.ACTION_CHECK_INFO_UN_EXIST)) { //检查项、或者检查内容列表已经被删除需要刷新列表数据
                for (Fragment fragment : fragments) {
                    if (fragment != null && fragment.isAdded()) {
                        CheckListContentFragment checkListContentFragment = (CheckListContentFragment) fragment;
                        checkListContentFragment.autoRefresh();
                    }
                }
            }
        }
    }
}
