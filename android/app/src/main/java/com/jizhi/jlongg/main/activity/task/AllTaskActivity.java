package com.jizhi.jlongg.main.activity.task;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.fragment.task.CompleteFragment;
import com.jizhi.jlongg.main.fragment.task.PendingFragment;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:全部任务
 * User: xuj
 * Date: 2017年6月7日
 * Time: 10:08:35
 */
public class AllTaskActivity extends BaseActivity implements View.OnClickListener {

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
     * 任务类型 （0:全部任务，1：我负责的任务）
     */
    private String TASK_TYPE = "0";
    /**
     * 任务类型弹出框
     */
    private SingleSelectedPopWindow taskTypePopWindow;
    /**
     * 根布局
     */
    private View rootView;
    /**
     * 标题
     */
    private TextView title;
    /**
     * 未处理、已完成的数据条数
     */
    private int unDailCount, completeCount;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupName, String groupId, boolean isClosed) {
        Intent intent = new Intent(context, AllTaskActivity.class);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra("isClosed", isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.all_task);
        initView();
    }

    private void initView() {
        boolean isClosed = getIntent().getBooleanExtra("isClosed", false);
        ImageView addImage = getImageView(R.id.rightImage);
        if (isClosed) { //已关闭
            addImage.setVisibility(View.GONE);
        } else {
            addImage.setImageResource(R.drawable.task_add_icon);
        }

        rootView = findViewById(R.id.rootView);
        title = getTextView(R.id.title);

        title.setText(R.string.all_task);
        fragments = new ArrayList<>();
        mTitles = new ArrayList<>();
        Fragment dayReportFragment = new PendingFragment(); //待处理
        Fragment weekReportFragment = new CompleteFragment(); //已完成
        Bundle bundle = new Bundle();
        bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        bundle.putBoolean("isClosed", isClosed);
        dayReportFragment.setArguments(bundle);
        weekReportFragment.setArguments(bundle);

        fragments.add(dayReportFragment);
        fragments.add(weekReportFragment);

        mTitles.add("待处理");
        mTitles.add("已完成");

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
        slidingTabLayout = (SlidingTabLayout) findViewById(R.id.navigationView);
        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
        viewPager.setAdapter(new MyPagerAdapter(getSupportFragmentManager()));
        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                Fragment fragment = fragments.get(position);
                if (fragment instanceof PendingFragment) { //未处理
                    PendingFragment pendingFragment = (PendingFragment) fragment;
                    if (pendingFragment.isRefurshData()) { //是否需要刷新数据
                        pendingFragment.autoRefresh();
                    }
                } else if (fragment instanceof CompleteFragment) { //已完成
                    CompleteFragment completeFragment = (CompleteFragment) fragment;
                    if (completeFragment.isRefurshData()) { //是否需要刷新数据
                        completeFragment.autoRefresh();
                    }
                }
                cureentIndex = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
//        slidingTabLayout.setViewPager(viewPager);
        slidingTabLayout.setCurrentTab(0);
    }

    /**
     * 设置已完成 刷新标识
     */
    public void setCompleteRefreshTag() {
        CompleteFragment completeFragment = (CompleteFragment) fragments.get(1);
        if (completeFragment != null && completeFragment.isAdded()) {
            completeFragment.setRefurshData(true);
        }
    }

    /**
     * 设置未读消息 刷新标识
     */
    public void setPendingRefreshTag() {
        PendingFragment pendingFragment = (PendingFragment) fragments.get(0);
        if (pendingFragment != null && pendingFragment.isAdded()) {
            pendingFragment.setRefurshData(true);
        }
    }


    /**
     * 填充未处理的消息数
     *
     * @param undailCount   未处理消息数
     * @param completeCount 已完成消息数
     */
    public void fillUnDailCount(int undailCount, int completeCount) {
        if (undailCount < 0) {
            return;
        }
        fillCompleteCount(completeCount);
        String unDailUpdateTitle = null;
        if (undailCount > 99) {
            unDailUpdateTitle = "待处理(99+)";
        } else if (undailCount == 0) {
            unDailUpdateTitle = "待处理";
        } else {
            unDailUpdateTitle = "待处理(" + undailCount + ")";
        }
        mTitles.set(0, unDailUpdateTitle);
//        slidingTabLayout.updateTitle(0, unDailUpdateTitle);
        this.unDailCount = undailCount;
    }

    /**
     * 填充已完成消息数
     *
     * @param completeCount
     */
    public void fillCompleteCount(int completeCount) {
        String updateTitle = null;
        if (completeCount > 99) {
            updateTitle = "(99+)";
        } else if (completeCount == 0) {
            updateTitle = null;
        } else {
            updateTitle = "(" + completeCount + ")";
        }
        mTitles.set(1, updateTitle);
//        slidingTabLayout.fillTextRed("已完成", updateTitle);
        this.completeCount = completeCount;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.title:
                if (taskTypePopWindow == null) {
                    List<SingleSelected> list = new ArrayList<>();
                    list.add(new SingleSelected(getString(R.string.all_task), "0"));
                    list.add(new SingleSelected(getString(R.string.i_responsibly), "1"));
                    taskTypePopWindow = new SingleSelectedPopWindow(this, list, new SingleSelectedPopWindow.SingleSelectedListener() {
                        @Override
                        public void getSingleSelcted(SingleSelected bean) {
                            TASK_TYPE = bean.getSelecteNumber(); //设置类型
                            title.setText(TASK_TYPE.equals("0") ? R.string.all_task : R.string.i_responsibly);
                            for (Fragment fragment : fragments) {
                                if (fragment instanceof PendingFragment) { //未处理
                                    PendingFragment pendingFragment = (PendingFragment) fragment;
                                    pendingFragment.autoRefresh();
                                } else if (fragment instanceof CompleteFragment) { //已完成
                                    CompleteFragment completeFragment = (CompleteFragment) fragment;
                                    completeFragment.autoRefresh();
                                }
                            }
                        }
                    });
                }
                taskTypePopWindow.showAtLocation(rootView, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.rightImage:
                PubliskTaskActivity.actionStart(this);
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
        if (resultCode == Constance.RESULTCODE_FINISH) { //任务详情里面 修改了任务状态
            for (Fragment fragment : fragments) {
                if (fragment instanceof PendingFragment) { //未处理
                    PendingFragment pendingFragment = (PendingFragment) fragment;
                    pendingFragment.autoRefresh();
                } else if (fragment instanceof CompleteFragment) { //已完成
                    CompleteFragment completeFragment = (CompleteFragment) fragment;
                    completeFragment.autoRefresh();
                }
            }
            return;
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
        fragments.get(cureentIndex).onActivityResult(requestCode, resultCode, data);
    }

    public String getTASK_TYPE() {
        return TASK_TYPE;
    }


    public int getUnDailCount() {
        return unDailCount;
    }


    public int getCompleteCount() {
        return completeCount;
    }


}
