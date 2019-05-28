package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.SigninDetailActivity;
import com.jizhi.jlongg.main.adpter.MessageSignTodayAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.Sign;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;

import java.util.ArrayList;
import java.util.List;

import static com.jizhi.jlongg.R.id.expanLv;


/**
 * CName: 签到
 * User: hcs
 * Date: 2016-08-25
 * Time: 14:23
 */
public class SingleTodayActivity extends BaseActivity implements MessageSignTodayAdapter.SignChildClickLisener, SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener {
    /**
     * 聊天的内容
     */
    private List<Sign> msgList;
    private MessageSignTodayAdapter messageSignAdapter;
    public ExpandableListView listview;
    private String s_date = "";
    // 下拉刷新
    private SwipeRefreshLayout mSwipeLayout;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 加载更多 */
    private View loadMoreView;
    private GroupDiscussionInfo gnInfo;

    private String signRecordList = "signRecordList";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.acitivty_message_sign);
        getIntentData();
        initView();
        registerReceivesr();
        autoRefresh();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String sign_id) {
        Intent intent = new Intent(context, SingleTodayActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_STRING, sign_id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    public void initView() {
        ((TextView) findViewById(R.id.title)).setText(getIntent().getStringExtra("real_name") + "的签到列表");
        listview = (ExpandableListView) findViewById(expanLv);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        listview.addFooterView(loadMoreView, null, false);
        msgList = new ArrayList<>();
        listview.setOnScrollListener(this);

        listview.setOnGroupClickListener(OnGroupClickListener);
        mSwipeLayout.setOnRefreshListener(this);
        new SetColor(mSwipeLayout);
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }

    //加载数据
    @Override
    public void onRefresh() {
        isFulsh = true;
        isHaveMoreData = true;
        getSignList();
    }

    public void getSignList() {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setClass_type(getIntent().getStringExtra(Constance.BEAN_STRING));
            msgParmeter.setCtrl("team");
            msgParmeter.setAction(signRecordList);
            msgParmeter.setGroup_id(gnInfo.getGroup_id());
            msgParmeter.setUid(getIntent().getStringExtra("mber_id"));
            msgParmeter.setPagesize(10 + "");
            msgParmeter.setS_date(s_date + "");
            webSocket.requestServerMessage(msgParmeter);
        }

    }

    /**
     * 广播回调
     */
    public BroadcastReceiver receiver;

    /**
     * 注册广播
     */
    private void registerReceivesr() {
        IntentFilter filter1 = new IntentFilter(signRecordList);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter1);
    }

    @Override
    public void SignChildClick(int groupPosition, int childPosition) {
        Intent intent = new Intent(SingleTodayActivity.this, SigninDetailActivity.class);
        intent.putExtra(Constance.sign_id, msgList.get(groupPosition).getSign_list().get(childPosition).getSign_id());
        startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                isFulsh = false;
                loadMoreView.setVisibility(View.VISIBLE);
//                pg += 1;
                getSignList();
            }
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            try {
                if (action.equals(signRecordList)) {//签到回执
                    mSwipeLayout.setRefreshing(false);
                    Sign bean = (Sign) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    LUtils.e("----------------------" + bean.getS_date());
                    s_date = bean.getS_date();
                    if (null == bean || null == bean.getList() || bean.getList().size() == 0) {
                        LUtils.e("-----------AAAAAAAAAAAa-----------");
                        listview.removeFooterView(loadMoreView);
                        loadMoreView.setVisibility(View.GONE);
//                        findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
//                        listview.setVisibility(View.GONE);
                        isHaveMoreData = false;
                        return;

                    }

                    addListMsg(bean.getList());


                }
            } catch (
                    Exception e)

            {
                e.printStackTrace();
            }

        }

    }

    /**
     * 显示数据
     *
     * @param msgDataList
     */
    public void addListMsg(List<Sign> msgDataList) {
        if (null == msgList) {
            msgList = new ArrayList<>();
        }
        //是否有更多数据
        isHaveMoreData = msgDataList.size() >= 1 ? true : false;
        int count = listview.getFooterViewsCount();
        if (isHaveMoreData) {
            if (count == 0) {
                listview.addFooterView(loadMoreView, null, false);
            }
        } else {
            if (count > 0) {
                listview.removeFooterView(loadMoreView);
            }
        }
        loadMoreView.setVisibility(View.GONE);
        msgList.addAll(msgDataList);
//        if (null == messageSignAdapter) {
        LUtils.e("-----------------11--------:" + msgList.size());
        messageSignAdapter = new MessageSignTodayAdapter(SingleTodayActivity.this, msgList, 0, SingleTodayActivity.this);
        listview.setAdapter(messageSignAdapter);
//            listview.setSelection(0);
//        } else {
//            messageSignAdapter.notifyDataSetChanged();
        LUtils.e("------------22-------------:" + msgList.size());
        if (isFulsh) {
            listview.setSelection(0);
        } else {
            listview.setSelection(msgList.size() > 0 ? msgList.size() - msgDataList.size() : msgDataList.size());
        }
//        }
        for (int i = 0; i < msgList.size(); i++) {
            try {
                listview.expandGroup(i);
            } catch (Exception e) {
            }

        }
        mSwipeLayout.setRefreshing(false);
    }

    ExpandableListView.OnGroupClickListener OnGroupClickListener = new ExpandableListView.OnGroupClickListener() {
        @Override
        public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
            return true;
        }
    };
}