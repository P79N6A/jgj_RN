package com.jizhi.jlongg.main.util;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageInfo;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageBroadCastListener;
import com.jizhi.jlongg.main.msg.MessageType;

import org.litepal.LitePal;
import org.litepal.crud.callback.SaveCallback;
import org.litepal.crud.callback.UpdateOrDeleteCallback;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class ThreadPoolManager {
    //线程池
    private ThreadPoolExecutor threadPoolExecutor;
    //CPU核心数量
    private final int CPU_COUNT = Runtime.getRuntime().availableProcessors();
    //线程队列
    private final BlockingQueue<Runnable> sPoolWorkQueue = new LinkedBlockingQueue<>(128);
    private static ThreadPoolManager instance = new ThreadPoolManager();
    public static Boolean isRunning = false;
    //消息最大一条消息数据
    private List<MessageInfo> offlineListBean;
    //撤回的消息数据
    private List<MessageInfo> recallListBean;
    /**
     * 组id
     */
    public static final String GROUP_ID = "group_id";
    /**
     * 组类型
     */
    public static final String CLASS_TYPE = "class_type";
    /**
     * 当前账号uid
     */
    public static final String MESSAGE_UID = "message_uid";
    /**
     * 消息id
     */
    public static final String MSG_ID = "msg_id";
    /**
     * 消息类型
     */
    public static final String MSG_TYPE = "msg_type";
    /**
     * 消息内容
     */
    public static final String MSG_TEXT = "msg_text";
    /**
     * 用户uid
     */
    public static final String UID = "uid";

    public static ThreadPoolManager getInstance() {
        return instance;
    }


    //初始化
    private ThreadPoolManager() {
        LUtils.e("--------ThreadPoolManager--------------");
        //核心线程数corePoolSize，线程池所能容纳的最大线程数maximumPoolSize，非核心线程的闲置超时时间keepAliveTime
        threadPoolExecutor = new ThreadPoolExecutor(CPU_COUNT + 1, CPU_COUNT * 2 + 1,
                1, TimeUnit.SECONDS, sPoolWorkQueue);
        if (null == offlineListBean) {
            offlineListBean = new ArrayList<>();
        }

        if (null == recallListBean) {
            recallListBean = new ArrayList<>();
        }
    }

    /**
     * 保存接收到的消息到数据库
     *
     * @param beanList
     * @param activity
     * @param isCheckGroupIsExist 是否检测项目信息是否已存在本地
     */
    public void executeReceiveMessage(final List<MessageBean> beanList, final Context activity, final boolean isCheckGroupIsExist) {
        if (null == beanList || beanList.size() == 0) {
            return;
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                LUtils.e("---start--处理消息中-----EEEE----" + beanList.size());
                isRunning = true;
                saveHandleMessage(beanList, UclientApplication.getUid(), activity, isCheckGroupIsExist);
                isRunning = false;
                LUtils.e("---end--处理消息中-----EEEE----");
            }
        };
        threadPoolExecutor.execute(runnable);
    }

    /**
     * 保存发送成功的消息到数据库并且更新状态消息到数据库
     */
    public void executeSaveSendMessage(final MessageBean bean, final MessageBroadCastListener broadCastSuccessListener) {
        LUtils.e("-------BBB----SENDMESSAGE-------");

        if (null == bean) {
            return;
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //保存消息到本息
                if (null != bean && null != bean.getUser_info()) {
                    bean.setMessage_uid(UclientApplication.getUid());
                    bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));//存储到子类为了方便修改昵称
                    bean.saveOrUpdateAsync(MESSAGE_UID + " = ? and " + GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and local_id = ? ", bean.getMessage_uid(), bean.getGroup_id(), bean.getClass_type(), bean.getLocal_id()).listen(new SaveCallback() {
                        @Override
                        public void onFinish(boolean success) {
                            if (null != broadCastSuccessListener) {
                                LUtils.e("-------ccc----SENDMESSAGE-------");

                                //添加未发送成功的消息
                                broadCastSuccessListener.showSingleMessageBottom(bean);
                                addSendingMeaageToList(bean);
                            } else {
                                LUtils.e("-------ddd----SENDMESSAGE-------");
                                //处理发送成功的消息
                                addSendSuccessMeaageToList(bean);
                            }
                        }
                    });
                }
            }
        };
        threadPoolExecutor.execute(runnable);
    }

    /**
     * 保存发送成功的消息到数据库并且更新状态消息到数据库
     */
    public void executeSaveSendMessage(final MessageBean bean) {
        if (null == bean) {
            return;
        }
        //保存消息到本息
        if (null != bean && null != bean.getUser_info()) {
            bean.setMessage_uid(UclientApplication.getUid());
            bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));//存储到子类为了方便修改昵称
            bean.saveOrUpdateAsync(MESSAGE_UID + " = ? and " + GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and local_id = ? ",
                    bean.getMessage_uid(), bean.getGroup_id(), bean.getClass_type(), bean.getLocal_id()).listen(new SaveCallback() {
                @Override
                public void onFinish(boolean success) {
                    if (success) {
                        Intent intent = new Intent(WebSocketConstance.FORWARD_SUCCESS);
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_CONSTANCE, bean);
                        intent.putExtras(bundle);
                        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
                        LUtils.e("转换后 groupId:" + bean.getGroup_id() + "         classType:" + bean.getClass_type() + " ---getLocal_id--- " + bean.getLocal_id());
                        //添加未发送成功的消息
                        addSendingMeaageToList(bean);

                    }
                }
            });
        }
    }

    /**
     * 添加未发送成功的消息
     *
     * @param bean
     */
    public void addSendingMeaageToList(MessageBean bean) {
        Intent intent = new Intent(Constance.ADD_SENDING_MSG_ACTION);
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_CONSTANCE, bean);
        intent.putExtras(bundle);
        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
    }

    /**
     * 处理发送成功的消息
     *
     * @param bean
     */
    public void addSendSuccessMeaageToList(MessageBean bean) {
        Intent intent = new Intent(Constance.ADD_SENDSUCCESS_MSG_ACTION);
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_CONSTANCE, bean);
        intent.putExtras(bundle);
        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
    }

    /**
     * 修改已读回执
     */
    public void executeUpdateMsgCallbanckReaded(final MessageBean bean) {
        if (null == bean) {
            return;
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //回执类型（readed 已读 / received 接收 ）
                ContentValues values = new ContentValues();
                if (bean.getType().equals(WebSocketConstance.READED)) {
                    values.put("is_readed", "1");
                    LUtils.e("------已读回执-------");
                    LitePal.updateAllAsync(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and msg_id <= ?  and message_uid = ?", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + "", UclientApplication.getUid()).listen(new UpdateOrDeleteCallback() {
                        @Override
                        public void onFinish(int rowsAffected) {

                        }
                    });
                }
            }
        };
        threadPoolExecutor.execute(runnable);

    }

    /**
     * 修改消息接收回执
     */
    public void executeupdateMsgCallbanckReceived(final MessageBean bean) {
        if (null == bean) {
            return;
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //回执类型（readed 已读 / received 接收 ）
                ContentValues values = new ContentValues();
                if (bean.getType().equals(WebSocketConstance.RECEIVED)) {
                    values.put("is_received", "1");

                } else if (bean.getType().equals(WebSocketConstance.READED)) {
                    values.put("is_readed", "1");

                }
                LUtils.e("------接收回执-------");
                LitePal.updateAllAsync(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " <= ? and " + MESSAGE_UID + " = ?", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + ""
                        , UclientApplication.getUid()).listen(new UpdateOrDeleteCallback() {
                    @Override
                    public void onFinish(int rowsAffected) {

                    }
                });
            }
        };
        threadPoolExecutor.execute(runnable);

    }

    /**
     * 保存单挑消息到数据库
     */
    public void executeSaveMessage(final MessageBean bean) {
        if (null == bean) {
            return;
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //保存消息到本息
                if (null != bean && null != bean.getUser_info()) {
                    bean.setMessage_uid(UclientApplication.getUid());
                    bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));//存储到子类为了方便修改昵称
                    bean.saveOrUpdateAsync(MESSAGE_UID + " = ? and " + MSG_ID + " = ? and " + GROUP_ID + " = ? and " + CLASS_TYPE + " = ? ", bean.getMessage_uid(), String.valueOf(bean.getMsg_id()), bean.getGroup_id(), bean.getClass_type()).listen(new SaveCallback() {
                        @Override
                        public void onFinish(boolean success) {
                        }
                    });
                }
            }
        };
        threadPoolExecutor.execute(runnable);
    }


    private void clearErrorMessage(List<MessageBean> beanList) {
        int count = 0;
        for (final MessageBean bean : beanList) {
            String msgType = bean.getMsg_type();
            if (msgType.equals(MessageType.JGB_SYNC_PROJECT_TO_YOU) ||
                    msgType.equals(MessageType.JGB_JOIN_TEAM) ||
                    msgType.equals(MessageType.JGB_CREATE_NEW_TEAM)) {
                beanList.remove(count);
                clearErrorMessage(beanList);
                return;
            }
            count++;
        }
    }

    /**
     * @param beanList
     */
    public void saveHandleMessage(final List<MessageBean> beanList, String uid, final Context activity, boolean isCheckGroupIsExist) {
        if (null == beanList || beanList.isEmpty()) {
            return;
        }
        clearErrorMessage(beanList);

        if (beanList.size() > 100) {
            LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(new Intent(WebSocketConstance.SHOW_DIALOG));
        }
        LUtils.e("---------------消息处理的数量-----------------" + beanList.size());
        if (offlineListBean.size() > 0) {
            offlineListBean.clear();
        }
        if (recallListBean.size() > 0) {
            recallListBean.clear();
        }
        HashMap<String, MessageBean> hashMap = new HashMap<>(); //新消息
        HashMap<String, String> hasmMapMsgIds = new HashMap<>(); //未读的消息数据

        for (MessageBean messageBean : beanList) {
            messageBean.setMessage_uid(UclientApplication.getUid());
            messageBean.setUser_info_json(new Gson().toJson(messageBean.getUser_info()));
            //筛选撤回的消息，需要回执给服务器
            if (!TextUtils.isEmpty(messageBean.getMsg_type()) && messageBean.getMsg_type().equals(MessageType.MSG_RECALL_STRING)) {
                MessageInfo recallBean = new MessageInfo();
                recallBean.setMsg_id(String.valueOf(messageBean.getMsg_id()));
                recallBean.setClass_type(messageBean.getClass_type());
                recallBean.setGroup_id(messageBean.getGroup_id());
                recallBean.setMsg_sender(messageBean.getMsg_sender());
                recallListBean.add(recallBean);
            }
            if (messageBean.getExtend() != null) {
                if (!TextUtils.isEmpty(messageBean.getExtend().getPro_name())) {
                    messageBean.setGroup_name(messageBean.getExtend().getPro_name());
                }
                //需要变色的信息
                if (messageBean.getExtend().getContent() != null && messageBean.getExtend().getContent().size() > 0) {
                    messageBean.setExtend_json(new Gson().toJson(messageBean.getExtend()));
                }
            }
            String key = messageBean.getClass_type() + "and" + messageBean.getGroup_id();
            if ((!hashMap.containsKey(key) || messageBean.getMsg_id() > hashMap.get(key).getMsg_id() && !MessageType.MSG_AUTH_STRING.equals(messageBean.getMsg_type()))) {
                hashMap.put(key, messageBean);
                if (MessageUtils.isAddUnreadCount(activity, messageBean)) {
                    String value = hasmMapMsgIds.get(key);
                    hasmMapMsgIds.put(key, TextUtils.isEmpty(value) ? messageBean.getMsg_id() + "" : value + "," + messageBean.getMsg_id());
                }
            }
        }
        if (hashMap.size() > 0) {
            int size = beanList.size();
            if (size <= 100) {
                for (final MessageBean bean : beanList) {
                    boolean isExist = LitePal.isExist(MessageBean.class, MESSAGE_UID + " = ? and " + MSG_ID + " = ?", uid, String.valueOf(bean.getMsg_id()));
                    if (!isExist) {
                        if (bean.getMsg_type().equals(MessageType.MSG_FINDWORK_STRING)) {
                            if (null != bean.getMsg_prodetail()) {
                                //网页传递过来的消息手动赋值
//                                bean.setProdetailactive(bean.getMsg_prodetail().getProdetailactive());
                                String worker_json = new Gson().toJson(bean.getMsg_prodetail());
                                bean.setMsg_prodetails(worker_json);
                                DBMsgUtil.getInstance().saveWorkMessage(bean, worker_json);
                            }
                            //保存找工作的消息
                        } else {
                            bean.save();
                        }
                    } else if (bean.getMsg_type().equals(MessageType.MSG_RECALL_STRING)) {
                        //如果是撤回的消息
                        DBMsgUtil.getInstance().updateRecallMsg(bean);
                    }
                }
            } else {
                LitePal.saveAll(beanList);
            }
            boolean isSearchMainIndex = false; //如果这个参数为true就需要去查询首页信息
            for (String key : hashMap.keySet()) {
                MessageBean bean = hashMap.get(key);
                MessageInfo offBean = new MessageInfo();
                offBean.setMsg_id(String.valueOf(bean.getMsg_id()));
                offBean.setClass_type(bean.getClass_type());
                offBean.setGroup_id(bean.getGroup_id());
                offlineListBean.add(offBean);
                isSearchMainIndex = setGroupChatInfo(bean, activity, isCheckGroupIsExist, hasmMapMsgIds.get(key));
            }
            if (isSearchMainIndex) {
                MessageUtil.getWorkCircleData(activity);//重新获取首页信息
            }
            sendBroadCastToShow(activity, beanList);
        }
    }


    /**
     * 消息存储完毕发送到聊天界面显示
     *
     * @param beanList
     */
    public void sendBroadCastToShow(Context activity, List<MessageBean> beanList) {
        Intent intent = new Intent(WebSocketConstance.SHOW_GROUP_MESSAGE);
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) offlineListBean);
        bundle.putSerializable(Constance.BEAN_CONSTANCE1, (Serializable) beanList);
        intent.putExtras(bundle);
        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
//        if(preMsg_id<)
        //发送消息收到回执
        MessageUtils.getCallBackOperationMessage(activity, new Gson().toJson(offlineListBean), WebSocketConstance.RECEIVED);
        //收到撤回回执
        if (null != recallListBean && recallListBean.size() > 0) {
            LUtils.e("---sendBroadCastToShow-----11--aaaaaa");
            MessageUtils.getCallBackOperationMessage(activity, new Gson().toJson(recallListBean), WebSocketConstance.RECALL);
        } else {
            LUtils.e("---sendBroadCastToShow-----22--aaaaaa");

        }
        //关闭对话框
        if (beanList.size() > 100) {
            LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(new Intent(WebSocketConstance.CLOSE_DIALOG));
        }
        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
    }


    private boolean setGroupChatInfo(MessageBean messageBean, Context activity, boolean isCheckGroupIsExist, String msgIds) {
        String msgType = messageBean.getMsg_type();
        String sysMsgType = messageBean.getSys_msg_type();
        String groupId = messageBean.getGroup_id();
        String classType = messageBean.getClass_type();
        String realName = messageBean.getUser_info() == null ? "" : MessageUtils.getRealName(messageBean.getMsg_type(), messageBean.getUser_info().getReal_name());
        //未读消息数
        int unreadCount = 0;
        long maxReadMsgId = 0;
        //获取本地存储的组信息
        GroupDiscussionInfo groupDiscussionInfo = MessageUtil.getLocalSingleGroupChatInfo(messageBean.getGroup_id(), messageBean.getClass_type());
        if (!TextUtils.isEmpty(msgIds)) { //判断消息是否需要新增小红点统计数
            if (groupDiscussionInfo != null) {
                //如果当前组正在聊天 则不会添加消息未读数
                if (!groupId.equals(DBMsgUtil.getInstance().currentEnterGroupId) && !classType.equals(DBMsgUtil.getInstance().currentEnterClassType)) {
                    unreadCount = groupDiscussionInfo.getUnread_msg_count();
                }
                //拆分聊天组id 检查收到的消息和本地最大已收到的消息数做对比 如果大于本地的消息最大已收则+1
                for (String msgId : msgIds.split(",")) {
                    if (Long.parseLong(msgId) > groupDiscussionInfo.getMax_readed_msg_id()) {
                        maxReadMsgId = messageBean.getMsg_id();
                        if (!groupId.equals(DBMsgUtil.getInstance().currentEnterGroupId) && !classType.equals(DBMsgUtil.getInstance().currentEnterClassType)) {
                            unreadCount++;
                        }
                    }
                }
            }
        } else { //这种情况一般都是单独撤回消息回造成的问题
            if (groupDiscussionInfo != null) {
                unreadCount = groupDiscussionInfo.getUnread_msg_count();
            }
        }

        //更新聊聊列表最新的一条消息,包含消息发送的内容,是否有人@我,发送人名称，发送者id
        MessageUtil.modityLocalTeamGroupInfoNoSendBroaderCast(activity, null, null, null,
                groupId, classType, unreadCount + "",
                MessageUtils.getMsg_Text(messageBean), null, null,
                messageBean.getSend_time(), messageBean.getAt_message(), realName,
                messageBean.getMsg_sender(), TextUtils.isEmpty(messageBean.getTitle()) ? null : messageBean.getTitle(), maxReadMsgId);
        if (!TextUtils.isEmpty(msgType)) {
            switch (msgType) {
                case MessageType.CLOSE: //关闭班组、项目组类型
                case MessageType.REMOVE: //移除班组、项目组类型
                case MessageType.DISMISS_GROUP://解散群聊
                case MessageType.DEL_MEMBER://被移除群
                    //如果是工作消息的关闭或者移除则需要将本地对应组信息给删除
                    DBMsgUtil.getInstance().deleteChatListGroupInfo(activity, messageBean.getOrigin_group_id(), messageBean.getOrigin_class_type());
                    return true;
                case MessageType.UPGRADE_GROUP: //群聊升级成班组
                    DBMsgUtil.getInstance().deleteChatListGroupInfo(activity, messageBean.getOrigin_group_id(), messageBean.getOrigin_class_type());
            }
        }
        if (!MessageType.RECRUIT_MESSAGE_TYPE.equals(sysMsgType) && !MessageType.ACTIVITY_MESSAGE_TYPE.equals(sysMsgType)) {
            //只要不是同步相关的消息，我们都需要去验证群聊在本地是否存在，如果不存在则调用接口重新获取数据信息
            String searchGroupId = TextUtils.isEmpty(messageBean.getOrigin_group_id()) || messageBean.getOrigin_group_id().equals("0") ? groupId : messageBean.getOrigin_group_id();
            String searchClassId = TextUtils.isEmpty(messageBean.getOrigin_class_type()) ? classType : messageBean.getOrigin_class_type();
            //如果是发的普通消息可能会将 origin_group_id,origin_class_type传为空，而工作消息 的重新开启 或者被加入群聊,origin_group_id,origin_class_type都不为空 所以在这里判断一下
            //只要,origin_group_id,origin_class_type 为空则取group_id和class_type
            if (isCheckGroupIsExist && !MessageUtil.checkGroupIsExist(activity, searchGroupId, searchClassId)) {
                MessageUtil.getSingleChatListData(activity, searchGroupId, searchClassId); //获取单条不存在的聊聊信息
                return true;
            }
        }
        return false;
    }
}