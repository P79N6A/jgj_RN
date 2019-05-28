package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;

import com.flyco.tablayout.SlidingTabLayout;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.fragment.pro_cloud.ProCloudDownLoadedFragment;
import com.jizhi.jlongg.main.fragment.pro_cloud.ProCloudUploadFragment;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;

import java.util.ArrayList;
import java.util.List;


/**
 * 项目云盘-->传输列表
 *
 * @author Xuj
 * @time 2017年7月18日11:07:11
 * @Version 1.0
 */
public class TranmissionActivity extends BaseActivity implements View.OnClickListener {
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
    public static void actionStart(Activity context, String groupId) {
        Intent intent = new Intent(context, TranmissionActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.transmission);
        initView();
    }

    private void initView() {
        setTextTitleAndRight(R.string.transmission, R.string.delete_file);
        fragments = new ArrayList<>();
        mTitles = new ArrayList<>();
        Fragment downLoadedFragment = new ProCloudDownLoadedFragment(); //我下载的
        Fragment upLoadedFragment = new ProCloudUploadFragment(); //我上传的

        Bundle bundle = new Bundle();
        bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        downLoadedFragment.setArguments(bundle);
        upLoadedFragment.setArguments(bundle);

        fragments.add(downLoadedFragment);
        fragments.add(upLoadedFragment);

        mTitles.add("我下载的");
        mTitles.add("我上传的");

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
                cureentIndex = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        slidingTabLayout.setViewPager(viewPager);
        slidingTabLayout.setCurrentTab(0);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //删除文件
                if (cureentIndex == 0) { //已下载的文件
                    DeleteFileActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID), CloudUtil.FILE_TYPE_DOWNLOAD_TAG);
                } else if (cureentIndex == 1) { //已上传的文件
                    DeleteFileActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID), CloudUtil.FILE_TYPE_UPLOAD_TAG);
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
        if (resultCode == Constance.DELETE_SUCCESS) {
            fragments.get(cureentIndex).onActivityResult(requestCode, resultCode, data);
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }
}