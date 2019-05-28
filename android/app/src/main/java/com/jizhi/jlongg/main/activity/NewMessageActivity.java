//package com.jizhi.jlongg.main.activity;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.os.Bundle;
//import android.text.TextUtils;
//import android.widget.ListView;
//
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.db.NewNoticeService;
//import com.jizhi.jlongg.main.activity.pay.ConfirmCloudOrderNewActivity;
//import com.jizhi.jlongg.main.activity.pay.ConfirmVersionOrderNewActivity;
//import com.jizhi.jlongg.main.adpter.NewMessageAdapter;
//import com.jizhi.jlongg.main.application.UclientApplication;
//import com.jizhi.jlongg.main.bean.BaseRequestParameter;
//import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
//import com.jizhi.jlongg.main.bean.NewMessage;
//import com.jizhi.jlongg.main.listener.NoticeOperateListener;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.MessageUtil;
//import com.jizhi.jlongg.main.util.ProductUtil;
//import com.jizhi.jlongg.main.util.WebSocket;
//import com.jizhi.jlongg.main.util.WebSocketConstance;
//import com.jizhi.jlongg.network.NetWorkRequest;
//
//import java.util.List;
//
///**
// * 功能: 新消息
// * 作者：Xuj
// * 时间: 2016年8月26日 10:51:07
// */
//public class NewMessageActivity extends BaseActivity implements NoticeOperateListener {
//
//    /**
//     * 新消息列表适配器
//     */
//    private NewMessageAdapter adapter;
//    /**
//     * 数据库操作对象
//     */
//    private NewNoticeService dao;
//    /**
//     * 当前点击的消息
//     */
//    private NewMessage clickMessage;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.listview_default);
//        init();
//        registerReceiver();
//        requestData();
//    }
//
//    private void init() {
//        setTextTitle(R.string.work_message);
//        getTextView(R.id.defaultDesc).setText("暂时还没有关于班组的消息");
//        dao = NewNoticeService.getInstance(getApplicationContext());
//        List<NewMessage> list = dao.getAllMessage(getApplicationContext());
//        initAdapter(list);
//    }
//
//    /**
//     * 发送通知已读
//     */
//    private void sendNoticeReaded(String noticeId) {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            WebSocketBaseParameter group = new WebSocketBaseParameter();
//            group.setAction(WebSocketConstance.ACTION_NOTICE_READED);
//            group.setCtrl(WebSocketConstance.CTRL_IS_NOTICE);
////            group.setNotice_id(noticeId);
//            webSocket.requestServerMessage(group);
//        }
//    }
//
//
//    private void requestData() {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            WebSocketBaseParameter group = new WebSocketBaseParameter();
//            group.setAction(WebSocketConstance.ACTION_NOTICE_MESSAGE);
//            group.setCtrl(WebSocketConstance.CTRL_IS_NOTICE);
//            webSocket.requestServerMessage(group);
//        }
//    }
//
//
//    @Override
//    public void remove(NewMessage bean) {
////        sendNoticeReaded(String.valueOf(bean.getNotice_id()));
//        dao.remove(bean);
//        List<NewMessage> list = dao.getAllMessage(getApplicationContext());
//        initAdapter(list);
//    }
//
//    @Override
//    public void refuse(NewMessage bean, int syncType) {
//        clickMessage = bean;
//        sendRefuseSynch(bean.getTeam_id(), bean.getTarget_uid(), syncType);
////        sendNoticeReaded(String.valueOf(bean.getNotice_id()));
//    }
//
//    @Override
//    public void into(NewMessage bean) {
//        if (!TextUtils.isEmpty(bean.getCan_click()) && bean.getCan_click().equals("1")) {
//            isMember(bean);
//        }
//    }
//
//    @Override
//    public void renew(NewMessage bean) {
//        String classType = bean.getClass_type();
//        if (classType.equals(WebSocketConstance.ACTION_SERVICE_EXPIRE_NOTICE)) { //项目云盘过期
//            ConfirmVersionOrderNewActivity.actionStart(this, bean.getGroup_id());
//        } else if (classType.equals(WebSocketConstance.ACTION_CLOUD_LACK) || classType.equals(WebSocketConstance.ACTION_CLOUD_EXPIRE_NOTICE)) { //云盘扩容 、续期
//            ConfirmCloudOrderNewActivity.actionStart(this, bean.getGroup_id());
//        }
//    }
//
//    @Override
//    public void audit(NewMessage bean) {
//        X5WebViewActivity.actionStart(this, NetWorkRequest.WEBURLS + "my/attest");
//    }
//
//    /**
//     * 广播回调
//     */
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_NOTICE_MESSAGE)) { //获取新消息
//                List<NewMessage> list = (List<NewMessage>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (list != null && list.size() > 0) {
//                    handlerReceiverResult(list);
//                }
//            } else if (action.equals(WebSocketConstance.ACTION_IS_MEMBER)) { //是否是成员
////                GroupDiscussionInfo infos = (GroupDiscussionInfo) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
////                if (infos.getIs_member().equals("1")) { //只有自己是成员才能点击
////                    clickMessage.setGroup_name(infos.getGroup_name());
////                    dao.updateGroupName(clickMessage, infos.getGroup_name()); //替换成最新的项目名称
//////                    setIndexList(infos.getClass_type(), infos.getGroup_id());
////                } else {
////                    CommonMethod.makeNoticeLong(getApplicationContext(), "无法进入已退出的班组/项目组", CommonMethod.ERROR);
////                }
//            } else if (action.equals(WebSocketConstance.ACTION_REFUSE_SYNCH)) { //拒绝同步
//                clickMessage.setSync_state(2);
////                dao.setSyncTag(clickMessage.getNotice_id(), clickMessage.getSync_state());
////                adapter.updateSingleView();
//            }
////            else if (action.equals(WebSocketConstance.ACTION_SET_INDEX_LIST)) { //切换项目组
////                String classType = clickMessage.getClass_type();
////                if (classType.equals(WebSocketConstance.JOIN_GROUP) || classType.equals(WebSocketConstance.CLOSE_GROUP)) {
////                    CommonMethod.makeNoticeLong(getApplicationContext(), "首页项目已切换为" + clickMessage.getGroup_name(), CommonMethod.SUCCESS);
////                    finish();
////                } else if (classType.equals(WebSocketConstance.JOIN_TEAM) || classType.equals(WebSocketConstance.CLOSE_TEAM)) {
////                    CommonMethod.makeNoticeLong(getApplicationContext(), "首页项目已切换为" + clickMessage.getTeam_name(), CommonMethod.SUCCESS);
////                    finish();
////                }
////            }
//        }
//    }
//
//    private void initAdapter(List<NewMessage> list) {
//        if (adapter == null) {
//            ListView listView = (ListView) findViewById(R.id.listView);
//            listView.setEmptyView(findViewById(R.id.defaultLayout));
//            adapter = new NewMessageAdapter(NewMessageActivity.this, list, listView, this);
//            listView.setAdapter(adapter);
//        } else {
//            adapter.updateList(list);
//        }
//    }
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {//创建群聊
//            NewMessage newMessage = adapter.getList().get(adapter.getClickPosition());
////            sendNoticeReaded(String.valueOf(newMessage.getNotice_id())); //设置当前通知消息为已读
//            newMessage.setClass_type(WebSocketConstance.JOIN_SUCCESS);
//            adapter.updateSingleView();
////            dao.updateGroupType(Integer.parseInt(newMessage.getNotice_id()), WebSocketConstance.JOIN_SUCCESS);
//        } else if (resultCode == Constance.SYNC_SUCCESS) { //同步项目成功
//            NewMessage newMessage = adapter.getList().get(adapter.getClickPosition());
////            sendNoticeReaded(String.valueOf(newMessage.getNotice_id())); //设置当前通知消息为已读
//            newMessage.setSync_state(1); //设置同步成功标识
//            adapter.updateSingleView();
////            dao.setSyncTag(newMessage.getNotice_id(), newMessage.getSync_state());
//        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
//            NewMessage newMessage = adapter.getList().get(adapter.getClickPosition());
//            newMessage.setIsPay(ProductUtil.PAID);
////            sendNoticeReaded(newMessage.getNotice_id());
////            dao.updatePayState(newMessage.getNotice_id());
//            adapter.notifyDataSetChanged();
//            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
//            finish();
//        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
//            NewMessage newMessage = adapter.getList().get(adapter.getClickPosition());
//            newMessage.setIsPay(ProductUtil.PAID);
////            sendNoticeReaded(newMessage.getNotice_id());
////            dao.updatePayState(newMessage.getNotice_id());
//            adapter.notifyDataSetChanged();
//            setResult(ProductUtil.PAID_GO_HOME);
//            finish();
//        }
//    }
//
//    /**
//     * 注册广播
//     */
//    private void registerReceiver() {
//        IntentFilter filter = new IntentFilter();
//        filter.addAction(WebSocketConstance.ACTION_NOTICE_MESSAGE);
//        filter.addAction(WebSocketConstance.ACTION_NOTICE_READED);
//        filter.addAction(WebSocketConstance.ACTION_REFUSE_SYNCH);
//        filter.addAction(WebSocketConstance.ACTION_IS_MEMBER);
//        receiver = new MessageBroadcast();
//        registerLocal(receiver, filter);
//    }
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        if (dao != null) {
//            dao.closeDB();
//        }
//    }
//
//    /**
//     * 处理广播结果
//     *
//     * @param object
//     */
//    private void handlerReceiverResult(Object object) {
//        StringBuilder builder = null;
//        if (object instanceof List) { //新消息列表
//            List<NewMessage> list = (List<NewMessage>) object;
//            if (list == null || list.size() == 0) {
//                return;
//            }
//            dao.saveNoticeMultiData(list, UclientApplication.getUid(getApplicationContext()));
//            list = dao.getAllMessage(getApplicationContext());
//            initAdapter(list);
//            int size = list.size();
//            for (int i = 0; i < size; i++) {
//                String classType = list.get(i).getClass_type();
//                if (!TextUtils.isEmpty(classType) && !classType.equals(WebSocketConstance.NEW_BILLING) &&
//                        !classType.equals(WebSocketConstance.SYNC_PROJECT) && !classType.equals(WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP)) {
//                    //如果是新记账人和同步项目则不发送已读标致
//                    if (builder == null) {
//                        builder = new StringBuilder();
//                    }
////                    builder.append(TextUtils.isEmpty(builder.toString()) ? list.get(i).getNotice_id() : "," + list.get(i).getNotice_id());
//                }
//            }
//        } else {//推送新消息
//            NewMessage bean = (NewMessage) object;
//            if (bean.getClass_type().equals("createSyncTeam")) {   //同步自动创建的讨论组推送，刷新用
//                return;
//            }
//            dao.saveNoticeSingleData(bean, UclientApplication.getUid(getApplicationContext()));
//            List<NewMessage> list = dao.getAllMessage(getApplicationContext());
//            initAdapter(list);
//            int size = list.size();
//            for (int i = 0; i < size; i++) {
//                String classType = list.get(i).getClass_type();
//                if (!TextUtils.isEmpty(classType) && !classType.equals(WebSocketConstance.NEW_BILLING) && !classType.equals(WebSocketConstance.SYNC_PROJECT)
//                        && !classType.equals(WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP)
//                        ) {
//                    //如果是新记账人和同步项目则不发送已读标致
//                    if (builder == null) {
//                        builder = new StringBuilder();
//                    }
////                    builder.append(TextUtils.isEmpty(builder.toString()) ? list.get(i).getNotice_id() : "," + list.get(i).getNotice_id());
//                }
//            }
//        }
//        if (builder != null) {
//            sendNoticeReaded(builder.toString());
//        }
//    }
//
//    /**
//     * 发送拒绝同步
//     *
//     * @param teamId
//     * @param targetUid
//     * @param sync_type 1：同步记工记账;2:同步记工
//     */
//    private void sendRefuseSynch(String teamId, String targetUid, int sync_type) {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            BaseRequestParameter group = new BaseRequestParameter();
//            group.setAction(WebSocketConstance.ACTION_REFUSE_SYNCH);
//            group.setCtrl(WebSocketConstance.CTRL_IS_TEAM);
//            group.setTeam_id(teamId);
//            group.setSync_type(sync_type);
//            group.setTarget_uid(targetUid);
//            webSocket.requestServerMessage(group);
//        }
//    }
//
//    /**
//     * 是否是成员
//     */
//    private void isMember(NewMessage newMessage) {
//        clickMessage = newMessage;
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            GroupDiscussionInfo request = new GroupDiscussionInfo();
////            request.setAction(WebSocketConstance.ACTION_IS_MEMBER);
////            request.setCtrl(WebSocketConstance.CTRL_IS_GROUP);
////            if (!TextUtils.isEmpty(newMessage.getTeam_id())) {
////                request.setTeam_id(newMessage.getTeam_id());
////            } else {
////                request.setGroup_id(newMessage.getGroup_id());
////            }
////            webSocket.requestServerMessage(request, this);
//        }
//    }
//
////    /**
////     * 设置首页组
////     *
////     * @param classType 类型
////     * @param groupId   组id
////     */
////    private void setIndexList(String classType, String groupId) {
////        SocketManager manager = UclientApplication.getInstance().getSocketManager();
////        if (manager != null && manager.getWebSocket() != null) {
////            BaseRequestParameter group = new BaseRequestParameter();
////            group.setAction(WebSocketConstance.ACTION_SET_INDEX_LIST);
////            group.setCtrl(WebSocketConstance.CTRL_IS_CHAT);
////            group.setClass_type(classType);
////            group.setGroup_id(groupId);
////            manager.getWebSocket().requestServerMessage(group, this);
////        }
////    }
//}
