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
import com.jizhi.jlongg.main.activity.check.CheckInspectioPlanActivity;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.activity.pay.ConfirmCloudOrderNewActivity;
import com.jizhi.jlongg.main.activity.task.TaskDetailActivity;
import com.jizhi.jlongg.main.adpter.WorkMessageAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.HandleDataListView;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;

/**
 * 功能: 工作消息
 * 作者：xuj
 * 时间:2018年10月17日16:15:32
 */
public class WorkMessageActivity extends BaseActivity implements AdapterView.OnItemClickListener {

    /**
     * 列表适配器
     */
    private WorkMessageAdapter adapter;
    /**
     * 是否第一次加载到了数据滚动到底部
     */
    private boolean isFirstScrollBottom;
    /**
     * listView
     */
    private HandleDataListView listView;
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
        Intent intent = new Intent(context, WorkMessageActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.work_recruit_message);
        registerFinishActivity();
        initView();
        registerReceiver();
        loadLocalDataBaseData();
    }

    /**
     * 获取漫游工作消息
     *
     * @param minMsgId 最小的消息id
     */
    private void getOffLineWorkMessage(final String minMsgId) {
        if (!mSwipeLayout.isRefreshing()) {
            mSwipeLayout.setRefreshing(true);
        }
        MessageUtil.getRoamMessageList(this, MessageType.WORK_MESSAGE_ID, MessageType.WORK_MESSAGE_TYPE,
                TextUtils.isEmpty(minMsgId) ? "0" : minMsgId, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        ArrayList<MessageBean> list = (ArrayList<MessageBean>) object;
                        MessageUtils.saveWorkRecruitMessage(WorkMessageActivity.this, list, MessageType.WORK_MESSAGE_TYPE);//将拉取的离线消息储存在本地
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
        ArrayList<MessageBean> list = DBMsgUtil.getInstance().selecteWorkMessage(minMsgId);
        if (list == null || list.size() == 0) { //如果本地不存在数据了就去服务器拉取数据
            getOffLineWorkMessage(minMsgId);
            return;
        }
        setAdapter(list, true);
    }

    private String getMinMsgId() {
        return adapter != null && adapter.getCount() > 0 ? adapter.getList().get(0).getMsg_id() + "" : null;
    }


    private void initView() {
        setTextTitle(R.string.work_message);
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
//        listView.setOnScrollListener(new AbsListView.OnScrollListener() {
//            @Override
//            public void onScrollStateChanged(AbsListView absListView, int i) {
//
//            }
//
//            @Override
//            public void onScroll(AbsListView absListView, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
//                if (firstVisibleItem == 0) {
//                    View firstVisibleItemView = listView.getChildAt(0);
//                    if (firstVisibleItemView != null && firstVisibleItemView.getTop() == 0 && !mSwipeLayout.isRefreshing()) {
//                        LUtils.e("onScroll");
////                        loadLocalDataBaseData();
//                    }
//                }
//            }
//        });
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        new SetColor(mSwipeLayout); // 设置下拉刷新滚动颜色
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                loadLocalDataBaseData();
            }
        });
        //设置当前点击的classType
        DBMsgUtil.getInstance().currentEnterClassType = MessageType.WORK_MESSAGE_TYPE;
        //设置当前点击的groupId
        DBMsgUtil.getInstance().currentEnterGroupId = MessageType.WORK_MESSAGE_ID;
    }

    /**
     * 清除错误类型的工作消息
     *
     * @param list
     */
    private void clearErrorTypeMessage(ArrayList<MessageBean> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        for (int i = 0; i < list.size(); i++) {
            String msgType = list.get(i).getMsg_type();
            if (msgType.equals(MessageType.JGB_SYNC_PROJECT_TO_YOU) ||
                    msgType.equals(MessageType.JGB_JOIN_TEAM) ||
                    msgType.equals(MessageType.JGB_CREATE_NEW_TEAM) ||
                    msgType.equals(MessageType.AGREE_SYNC_PROJECT_TO_YOU)) {
                list.remove(i);
                clearErrorTypeMessage(list);
                return;
            }
        }
    }

    private void setAdapter(ArrayList<MessageBean> list, boolean isHistoryMessage) {
        clearErrorTypeMessage(list);
        if (adapter == null) {
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new WorkMessageAdapter(this, list);
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
        String msgType = bean.getMsg_type();
        int status = bean.getStatus();
        if ((msgType.equals(MessageType.MSG_QUALITY_STRING) ||
                msgType.equals(MessageType.MSG_SAFE_STRING) ||
                msgType.equals(MessageType.MSG_NOTICE_STRING) ||
                msgType.equals(MessageType.MSG_LOG_STRING) ||
                msgType.equals(MessageType.MSG_TASK_STRING) ||
                msgType.equals(MessageType.MSG_INSPECT_STRING) || msgType.equals(MessageType.EVALUATE)) && status == 4
                ) { //已删除的状态不能点击
            return;
        }
        switch (bean.getMsg_type()) {
            case MessageType.MSG_QUALITY_STRING: //质量
            case MessageType.MSG_SAFE_STRING: //安全
                ActivityQualityAndSafeDetailActivity.actionStart(WorkMessageActivity.this, bean, getGroupInfo(bean.getOrigin_class_type(), bean.getOrigin_group_id()), bean.getBill_id());
                break;
            case MessageType.MSG_NOTICE_STRING: //通知
                ActivityNoticeDetailActivity.actionStart(WorkMessageActivity.this, getGroupInfo(bean.getOrigin_class_type(), bean.getOrigin_group_id()), (int) bean.getMsg_id(), bean.getBill_id());
                break;
            case MessageType.MSG_LOG_STRING: //日志
                LogDetailActivity.actionStart(WorkMessageActivity.this, getGroupInfo(bean.getOrigin_class_type(), bean.getOrigin_group_id()), bean.getMsg_id() + "", bean.getBill_id(),
                        "日志", true);
                break;
            case MessageType.MSG_TASK_STRING: //任务
                TaskDetailActivity.actionStart(WorkMessageActivity.this, bean.getBill_id() + "", bean.getOrigin_group_id(),
                        bean.getGroup_name(), false);
                break;
            case MessageType.MSG_INSPECT_STRING: //检查
                CheckInspectioPlanActivity.actionStart(WorkMessageActivity.this, getGroupInfo(bean.getOrigin_class_type(), bean.getOrigin_group_id()), bean.getBill_id() + "");
                break;
            case MessageType.MSG_APPROVAL_STRING: //审批
                X5WebViewActivity.actionStart(WorkMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
                break;
            case MessageType.MSG_METTING_STRING: //会议
                X5WebViewActivity.actionStart(WorkMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
                break;
            case MessageType.MSG_CLOUD: //云盘
                ConfirmCloudOrderNewActivity.actionStart(WorkMessageActivity.this, bean.getOrigin_group_id());
                break;
            case MessageType.AGREE_SYNC_PROJECT: //同意同步项目 点击查看详情，跳转到“同步记工”界面；
                SyncActivity.actionStart(WorkMessageActivity.this, false);
                break;
            case MessageType.SYNC_BILL_TO_YOU: //记工同步通知 点击查看详情，跳转到“同步给我的记工”界面；
                SyncActivity.actionStart(WorkMessageActivity.this, true);
                break;
            case MessageType.AGREE_SYNC_BILL: //同意同步项目 点击查看详情，跳转到“同步记工”界面；
                SyncActivity.actionStart(WorkMessageActivity.this, false);
                break;
            case MessageType.INTEGRAL: //积分帖子
                X5WebViewActivity.actionStart(WorkMessageActivity.this, NetWorkRequest.WEBURLS + bean.getUrl());
                break;
            case MessageType.EVALUATE: //去评价按钮
                EvaluationDetailActivity.actionStart(WorkMessageActivity.this, UclientApplication.getUid(), bean.getStatus() + "");
                break;
            case MessageType.DEMAND_SYNC_BILL: //吉工家用户A邀请吉工家用户B向我同步
                WorkMessageSyncDetailActivity.actionStart(this, msgType, bean.getMsg_id() + "", bean.getUser_info() != null ? bean.getUser_info().getReal_name() : "",
                        bean.getMsg_sender());
                break;
            case MessageType.REQUIRE_SYNC_PROJECT: //吉工宝用户A添加数据来源人用户B（数据来源人用户B是吉工家用户)
                WorkMessageSyncDetailActivity.actionStart(this, msgType, bean.getMsg_id() + "", bean.getUser_info() != null ? bean.getUser_info().getReal_name() : "",
                        bean.getMsg_sender());
                break;
            case MessageType.NEW_FRIEND_MESSAGE: //好友注册申请
                ChatUserInfoActivity.actionStart(this, bean.getMsg_sender());
                break;
            case MessageType.JOIN: //加入班组、项目组
            case MessageType.REOPEN: //重新开启班组、项目组
            case MessageType.SWITCH_GROUP: //转让管理权
                if (WebSocketConstance.GROUP_CHAT.equals(bean.getOrigin_class_type())) { //群聊消息
                    GroupDiscussionInfo groupDiscussionInfo = MessageUtil.getLocalSingleGroupChatInfo(bean.getOrigin_group_id(), bean.getOrigin_class_type());
                    if (groupDiscussionInfo != null) {
                        NewMsgActivity.actionStart(this, groupDiscussionInfo);
                    }
                } else {
                    MessageUtil.setIndexList(this, getGroupInfo(bean.getOrigin_class_type(), bean.getOrigin_group_id()), true, true);
                }
                break;
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
                    LUtils.e("工作消息接受到的消息大小:" + messageBeanArrayList.size());
                    synchronized (MessageBroadcast.class) {
                        boolean isChangeData = false;
                        //用这个集合装排重的消息
                        ArrayList<MessageBean> filterList = null;
                        if (messageBeanArrayList != null && messageBeanArrayList.size() > 0) {
                            for (MessageBean messageBean : messageBeanArrayList) {
                                if (MessageType.WORK_MESSAGE_TYPE.equals(messageBean.getSys_msg_type())) { //过滤非工作消息
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

    private GroupDiscussionInfo getGroupInfo(String classType, String groupId) {
        //项目组、班组信息 主要是查看详情的时候需要使用 ,里面只有简单的class_type和group_id
        GroupDiscussionInfo groupDiscussionInfo = new GroupDiscussionInfo();
        groupDiscussionInfo.setGroup_id(groupId);
        groupDiscussionInfo.setClass_type(classType);
        return groupDiscussionInfo;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (resultCode) {
            case ProductUtil.PAID_GO_TO_ORDERLIST: //支付成功回订单列表
                setResult(resultCode);
                finish();
                break;
            case ProductUtil.PAID_GO_HOME: //支付成功回主页
                setResult(resultCode);
                finish();
                break;
            case Constance.SYNC_SUCCESS: //同步成功后的回调
                MessageBean callBackMessageBean = (MessageBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                updateWorkListInfo(callBackMessageBean);
                break;
            case Constance.SUCCESS:
                break;
            case Constance.CLICK_SINGLECHAT: //点击单聊
                setResult(resultCode, data);
                finish();
                break;
        }
    }

    public void updateWorkListInfo(MessageBean callBackMessageBean) {
        if (callBackMessageBean != null && adapter != null && adapter.getCount() > 0) {
            for (MessageBean messageBean : adapter.getList()) {
                if (messageBean.getMsg_id() == callBackMessageBean.getMsg_id()) {
                    //修改本地工作消息信息
                    MessageUtil.updateWorkMessageInfo(callBackMessageBean);
                    messageBean.setMsg_text(callBackMessageBean.getMsg_text());
                    messageBean.setTitle(callBackMessageBean.getTitle());
                    messageBean.setMsg_type(callBackMessageBean.getMsg_type());
                    adapter.notifyDataSetChanged();
                    break;
                }
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterFinishActivity();
        DBMsgUtil dbMsgUtil = DBMsgUtil.getInstance();
        //根据group_id 和class_type 获取本地存储的最后一条消息
        MessageBean messageBean = dbMsgUtil.selectLastMessage(MessageType.WORK_MESSAGE_ID, MessageType.WORK_MESSAGE_TYPE);
        //设置最后一条消息的发送时间 发送人
        if (messageBean != null) {
            LUtils.e("title:" + messageBean.getTitle());
            MessageUtil.setLastMessageInfo(WorkMessageActivity.this, messageBean.getGroup_id(), messageBean.getClass_type(), "0",
                    MessageUtils.getMsg_Text(messageBean), messageBean.getSend_time(), TextUtils.isEmpty(messageBean.getTitle()) ? "" : messageBean.getTitle(),
                    messageBean.getMsg_id() + "", null, null);
        }
        DBMsgUtil.getInstance().clearEnterMessageInfo();
    }

}
