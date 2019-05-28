package com.jizhi.jlongg.main.activity.task;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ReplyMsgQualityAndSafeActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.fragment.task.CompleteFragment;
import com.jizhi.jlongg.main.fragment.task.MyCommitAndResponseFragment;
import com.jizhi.jlongg.main.fragment.task.PendingFragment;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.ArrayList;

/**
 * CName:全部任务
 * User: xuj
 * Date: 2017年6月7日
 * Time: 10:08:35
 */
public class AllTaskNewActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 未处理、已完成、我提交的、我负责的
     */
    private TextView unDealText, compeleteText, iCommitText, iResporse;
    /**
     * 已完成 未读小红点
     */
    private View compeleteUnreadRedCircle;
    /**
     * 滑动组件
     */
    private ViewPager viewPager;
    /**
     * fragments
     */
    private ArrayList<Fragment> fragments = null;
    /**
     * 当前View选中的下标
     */
    private int cureentIndex;

    private ImageView rightImage;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupName, String groupId, boolean isClosed) {
        Intent intent = new Intent(context, AllTaskNewActivity.class);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra("isClosed", isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.all_task_new);
        registerFinishActivity();
        initView();
        registerReceiver();
    }

    private void initView() {

        rightImage = getImageView(R.id.rightImage);
        rightImage.setImageResource(R.drawable.icon_quality_msg);


        boolean isClosed = getIntent().getBooleanExtra("isClosed", false);
        unDealText = getTextView(R.id.unDealText);
        compeleteText = getTextView(R.id.compeleteText);
        iCommitText = getTextView(R.id.iCommitText);
        iResporse = getTextView(R.id.iResporse);
        compeleteUnreadRedCircle = findViewById(R.id.compeleteUnreadRedCircle);
        findViewById(R.id.bottom_layout).setVisibility(isClosed ? View.GONE : View.VISIBLE); //如果项目已关闭则隐藏添加任务按钮
        getButton(R.id.red_btn).setText(R.string.publish_task);
        setTextTitle(R.string.all_task);
        fragments = new ArrayList<>();
        Fragment dayReportFragment = new PendingFragment(); //待处理
        Fragment weekReportFragment = new CompleteFragment(); //已完成
        Fragment iCommitFragment = new MyCommitAndResponseFragment(); //我提交的
        Fragment iResponseFragment = new MyCommitAndResponseFragment(); //我负责的
        Bundle bundle = new Bundle();
        bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        bundle.putBoolean("isClosed", isClosed);
        dayReportFragment.setArguments(bundle);
        weekReportFragment.setArguments(bundle);
        iCommitFragment.setArguments(getMyCommitBundle(isClosed));
        iResponseFragment.setArguments(getMyReposonseBundle(isClosed));


        fragments.add(dayReportFragment);
        fragments.add(weekReportFragment);
        fragments.add(iCommitFragment);
        fragments.add(iResponseFragment);


        initViewPager();
    }

    /**
     * 获取我提交的bundle
     *
     * @param isClosed 项目是否关闭
     * @return
     */
    private Bundle getMyCommitBundle(boolean isClosed) {
        Bundle bundle = new Bundle();
        bundle.putString("taskStatus", "2");
        bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        bundle.putBoolean("isClosed", isClosed);
        return bundle;
    }

    /**
     * 获取我负责的bundle
     *
     * @param isClosed 项目是否关闭
     * @return
     */
    private Bundle getMyReposonseBundle(boolean isClosed) {
        Bundle bundle = new Bundle();
        bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        bundle.putString("taskStatus", "1");
        bundle.putBoolean("isClosed", isClosed);
        return bundle;
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
        viewPager = (ViewPager) findViewById(R.id.viewPager);
        viewPager.setAdapter(new MyPagerAdapter(getSupportFragmentManager()));
        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                setViewPagerSelectePosition(position, true);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        viewPager.setOffscreenPageLimit(4);
    }

    private void setViewPagerSelectePosition(int position, boolean isScrollViewpager) {
        switch (cureentIndex) {
            case 0: //未处理
                unDealText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_999999));
                break;
            case 1: //已完成
                compeleteText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_999999));
                break;
            case 2: //我提交的
                iCommitText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_999999));
                break;
            case 3: //我负责的
                iResporse.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_999999));
                break;
        }
        switch (position) {
            case 0: //未处理
                unDealText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
                break;
            case 1: //已完成
                compeleteText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
                break;
            case 2: //我提交的
                iCommitText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
                break;
            case 3: //我负责的
                iResporse.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
                break;
        }
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
        } else if (fragment instanceof MyCommitAndResponseFragment) { //已完成
            MyCommitAndResponseFragment myCommitAndResponseFragment = (MyCommitAndResponseFragment) fragment;
            if (myCommitAndResponseFragment.isRefurshData()) { //是否需要刷新数据
                myCommitAndResponseFragment.autoRefresh();
            }
        }
        cureentIndex = position;
        if (!isScrollViewpager) {
            viewPager.setCurrentItem(cureentIndex);
        }
    }


    /**
     * 填充未处理的消息数
     *
     * @param undailCount 未处理消息数
     */
    public void fillUnDailCount(int undailCount, int completeCount) {
        if (undailCount < 0) {
            unDealText.setText("待处理");
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
        unDealText.setText(unDailUpdateTitle);
    }

    /**
     * 填充已完成消息数
     *
     * @param completeCount
     */
    public void fillCompleteCount(int completeCount) {
        compeleteUnreadRedCircle.setVisibility(completeCount > 0 ? View.VISIBLE : View.GONE);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn:
                PubliskTaskActivity.actionStart(this);
                break;
            case R.id.unDealText:
                setViewPagerSelectePosition(0, false);
                break;
            case R.id.compeleteLayout:
                setViewPagerSelectePosition(1, false);
                break;
            case R.id.iCommitText:
                setViewPagerSelectePosition(2, false);
                break;
            case R.id.iResporse:
                setViewPagerSelectePosition(3, false);
                break;
            case R.id.rightImage:
                rightImage.setImageResource(R.drawable.icon_quality_msg);
                GroupDiscussionInfo info = new GroupDiscussionInfo();
                info.setClass_type(WebSocketConstance.TEAM);
                info.setGroup_id(getIntent().getStringExtra(Constance.GROUP_ID));
                info.setClass_type(WebSocketConstance.TEAM);
                ReplyMsgQualityAndSafeActivity.actionStart(this, info, MessageType.MSG_TASK_STRING);
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

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(WebSocketConstance.RECIVEMESSAGE);//获取聊天信息推送
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
            if (action.equals(WebSocketConstance.RECIVEMESSAGE)) {
                String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
                //接收到群组消息回执
                MessageEntity bean = (MessageEntity) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (TextUtils.isEmpty(bean.getGroup_id()) || bean.getGroup_id().equals("0")) {
                    return;
                }
                //是否是本组收到的消息
                if (!bean.getGroup_id().equals(groupId)) {
                    return;
                }
                if (bean.getMsg_type().equals(MessageType.MESSAGE_TYPE_REPLY_TASK)) {
                    //小铃铛🔔图片
                    rightImage.setImageResource(R.drawable.icon_quality_msg_red);
                }
            }
        }
    }
}
