package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RecruitMessageAdapter;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.HandleDataListView;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;

/**
 * 功能: 招聘消息
 * 作者：xuj
 * 时间:2018年10月17日16:15:23
 */
public class RecruitMessageActivity extends BaseActivity implements AdapterView.OnItemClickListener {

    /**
     * 列表适配器
     */
    private RecruitMessageAdapter adapter;
    /**
     * listView
     */
    private HandleDataListView listView;
    /**
     * 是否第一次加载到了数据滚动到底部
     */
    private boolean isFirstScrollBottom;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 是否保持原味  adapter在调用notifydateChange的时候位置可能会发生变化
     */
    private int isScrollOldPosition = -1;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RecruitMessageActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.work_recruit_message);
        initView();
        registerReceiver();
        loadLocalDataBaseData();
    }


    /**
     * 获取漫游招聘消息
     *
     * @param minMsgId 最小的消息id
     */
    private void getOffLineRecruitMessage(final String minMsgId) {
        if (!mSwipeLayout.isRefreshing()) {
            mSwipeLayout.setRefreshing(true);
        }
        MessageUtil.getRoamMessageList(this, MessageType.RECRUIT_MESSAGE_ID, MessageType.RECRUIT_MESSAGE_TYPE,
                TextUtils.isEmpty(minMsgId) ? "0" : minMsgId, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        ArrayList<MessageBean> list = (ArrayList<MessageBean>) object;
                        MessageUtils.saveWorkRecruitMessage(RecruitMessageActivity.this, list, MessageType.RECRUIT_MESSAGE_TYPE);//将拉取的离线消息储存在本地
                        setAdapter(list, true);
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        if (mSwipeLayout.isRefreshing()) {
                            mSwipeLayout.setRefreshing(false);
                        }
                    }
                });
    }

    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        //本地已存在的最大消息id数
        String minMsgId = getMinMsgId();
        //获取本地已经存在的工作消息
        ArrayList<MessageBean> list = DBMsgUtil.getInstance().selecteRecruitMessage(minMsgId);
        if (list == null || list.size() == 0) { //如果本地不存在数据了就去服务器拉取数据
            getOffLineRecruitMessage(minMsgId);
            return;
        }
        setAdapter(list, true);
    }

    private String getMinMsgId() {
        return adapter != null && adapter.getCount() > 0 ? adapter.getList().get(0).getMsg_id() + "" : null;
    }


    private void initView() {
        setTextTitle(R.string.recruit_message);
        listView = (HandleDataListView) findViewById(R.id.listView);
        View diverView = new View(this);
        AbsListView.LayoutParams params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dp2px(100));
        diverView.setLayoutParams(params);
        listView.addFooterView(diverView, null, false);
        listView.setDivider(null);
        listView.setOnItemClickListener(this);
        listView.setDataChangedListener(new HandleDataListView.DataChangedListener() { //每次都滚动到底部重新加载数据
            @Override
            public void onSuccess() {
                if (!isFirstScrollBottom) {
                    isFirstScrollBottom = true;
                    if (adapter != null && adapter.getCount() > 0) {
                        listView.setSelection(adapter.getCount() - 1);
                    }
                    return;
                }
                if (isScrollOldPosition != -1) {
                    if (adapter != null && adapter.getCount() > 0) {
                        listView.setSelection(isScrollOldPosition);
                    }
                    isScrollOldPosition = -1;
                }
            }
        });
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        new SetColor(mSwipeLayout); // 设置下拉刷新滚动颜色
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                loadLocalDataBaseData();
            }
        });
        //设置当前点击的classType
        DBMsgUtil.getInstance().currentEnterClassType = MessageType.RECRUIT_MESSAGE_TYPE;
        //设置当前点击的groupId
        DBMsgUtil.getInstance().currentEnterGroupId = MessageType.RECRUIT_MESSAGE_ID;
    }

    private void setAdapter(ArrayList<MessageBean> list, boolean isHistoryMessage) {
        if (adapter == null) {
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new RecruitMessageAdapter(this, list);
            listView.setAdapter(adapter);
        } else {
            if (isHistoryMessage) { //如果是历史消息就放在最顶部就行了
                adapter.getList().addAll(0, list);
                isScrollOldPosition = list != null ? list.size() : 0;
            } else { //如果是新消息就放在最底部
                adapter.getList().addAll(list);
            }
        }
        adapter.notifyDataSetChanged();
        if (mSwipeLayout.isRefreshing()) {
            mSwipeLayout.setRefreshing(false);
        }
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.RECEIVEMESSAGE);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
        MessageBean bean = adapter.getList().get(position);
//        switch (bean.getMsg_type()) {
//            case MessageType.AUTHPASS: //劳务认证审核已通过
//                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
//                break;
//            case MessageType.AUTHFAIL: //劳务认证审核未通过
//                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
//                break;
//            case MessageType.AUTHEXPIRED: //劳务认证过期通知
//                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
//                break;
//            case MessageType.AUTHDUE: //劳务认证临近到期通知
//                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
//                break;
//            case MessageType.WORKERMIND: //新工作提醒
//                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
//                break;
//        }
        if ("projectinfo".equals(bean.getMsg_type())) { //招工情况
            if (bean.getExtend() != null && bean.getExtend().getMsg_content() != null && !TextUtils.isEmpty(bean.getExtend().getMsg_content().getJump_url())) {
                X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getExtend().getMsg_content().getJump_url());
            }
        } else {
            if (TextUtils.isEmpty(bean.getUrl())) {
                return;
            }
//            if ("workremind".equals(bean.getMsg_type())) {
//                Intent intent = new Intent(this, JobReactActivity.class);
//                startActivityForResult(intent, 0);
//                return;
//            }
            X5WebViewActivity.actionStart(RecruitMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
        }
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            switch (action) {
                case WebSocketConstance.RECEIVEMESSAGE: //接收消息
                    ArrayList<MessageBean> messageBeanArrayList = (ArrayList<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    LUtils.e("招聘消息接受到的消息大小:" + messageBeanArrayList.size());
                    synchronized (RecruitMessageActivity.MessageBroadcast.class) {
                        boolean isChangeData = false;
                        //用这个集合装排重的消息
                        ArrayList<MessageBean> filterList = null;
                        if (messageBeanArrayList != null && messageBeanArrayList.size() > 0) {
                            for (MessageBean messageBean : messageBeanArrayList) {
                                if (MessageType.RECRUIT_MESSAGE_TYPE.equals(messageBean.getSys_msg_type())) { //过滤非工作消息
                                    if (adapter == null || adapter.getCount() == 0) {
                                        setAdapter(messageBeanArrayList, false);
                                        return;
                                    } else if (!adapter.getList().contains(messageBean)) {
                                        if (filterList == null) {
                                            filterList = new ArrayList<>();
                                        }
                                        filterList.add(messageBean);
                                        isChangeData = true;
                                    }
                                }
                            }
                            if (isChangeData) {
                                setAdapter(filterList, false);
                            }
                        }
                    }
                    break;
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        DBMsgUtil dbMsgUtil = DBMsgUtil.getInstance();
        //根据group_id 和class_type 获取本地存储的最后一条消息
        MessageBean messageBean = dbMsgUtil.selectLastMessage(MessageType.RECRUIT_MESSAGE_ID, MessageType.RECRUIT_MESSAGE_TYPE);
        //设置最后一条消息的发送时间 发送人
        if (messageBean != null) {
            MessageUtil.setLastMessageInfo(RecruitMessageActivity.this, messageBean.getGroup_id(), messageBean.getClass_type(), "0",
                    MessageUtils.getMsg_Text(messageBean), messageBean.getSend_time(), TextUtils.isEmpty(messageBean.getTitle()) ? "" : messageBean.getTitle(),
                    messageBean.getMsg_id() + "", null, null);
        }
        DBMsgUtil.getInstance().clearEnterMessageInfo();
    }

}
