package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.db.BaseInfoDB;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.DeleteMessageBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageExtend;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.msg.MessageBroadCastListener;
import com.jizhi.jlongg.main.msg.MessageType;

import org.json.JSONException;
import org.json.JSONObject;
import org.litepal.LitePal;
import org.litepal.crud.callback.FindMultiCallback;
import org.litepal.crud.callback.SaveCallback;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DBMsgUtil {

    /**
     * 当前正在聊天进入的groupId,和classType
     */
    public String currentEnterGroupId, currentEnterClassType;

    private static volatile DBMsgUtil dbMsgUtil;
    //SELECT msg_id FROM message_list where msg_id IN(2,3,4,5,6)
    /**
     * 最大已读msg_id
     */
    private static final String MAX_READED_MSG_ID = "max_readed_msg_id";
    /**
     * 最大已接收msg_id
     */
    private static final String MAX_ASKED_MSG_ID = "max_asked_msg_id";
    /**
     * 未读消息数量
     */
    public static final String UNREAD_MSG_COUNT = "unread_msg_count";
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
     * 用户uid
     */
    public static final String UID = "uid";

    private DBMsgUtil() {
    }

    public static DBMsgUtil getInstance() {
        if (dbMsgUtil == null) {
            synchronized (DBMsgUtil.class) {
                if (dbMsgUtil == null) {
                    dbMsgUtil = new DBMsgUtil();
                }
            }
        }
        return dbMsgUtil;
    }


    public void clearEnterMessageInfo() {
        currentEnterGroupId = null;
        currentEnterClassType = null;
    }


    /**
     * 获取最大消息id
     */
    public String selectMaxId(String group_id, String class_type) {
        int maxId = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type, UclientApplication.getUid()).max(MessageBean.class, BaseInfoDB.msg_id, int.class);
        LUtils.e(group_id + "," + class_type + "<===selectMaxId====>" + maxId);
        return maxId + "";
    }


    /**
     * 获取上次已读最大的消息id
     */
    public long selectLastMaxReadId(String group_id, String class_type) {
        long lastMaxReadId = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? and is_readed = 1 ",
                group_id, class_type, UclientApplication.getUid()).max(MessageBean.class, BaseInfoDB.msg_id, int.class);
        LUtils.e(group_id + "," + class_type + "<===selectLastReadMaxId====>" + lastMaxReadId);
        return lastMaxReadId;
    }


    /**
     * 查询删除的消息最大id
     */
    public long selectDeleteMsg_id(String group_id, String class_type) {
        List<DeleteMessageBean> list = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type,
                UclientApplication.getUid()).limit(10).find(DeleteMessageBean.class);
        return (null != list && list.size() > 0) ? list.get(0).getMsg_id() : 0;
    }


    /**
     * 查询本地消息
     */
    public MessageBean selectLastMessage(String group_id, String class_type) {
        int maxMsgId = LitePal.where("group_id = ? and class_type = ? and message_uid = ? ",
                group_id, class_type, UclientApplication.getUid()).max(MessageBean.class, MSG_ID, int.class);
        ArrayList<MessageBean> messageBeanArrayList = (ArrayList<MessageBean>) LitePal.where("group_id = ? and class_type = ? and message_uid = ?  and msg_id = ?",
                group_id, class_type, UclientApplication.getUid(), maxMsgId + "").order("send_time desc").find(MessageBean.class);
        if (messageBeanArrayList != null && messageBeanArrayList.size() > 0) {
            MessageBean messageBean = messageBeanArrayList.get(0);
            //设置发送人信息
            messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
            return messageBean;
        }
        return null;
    }


    /**
     * 查询本地范围消息
     *
     * @param group_id
     * @param class_type
     * @param minMessageId 最小的消息id
     * @param maxMessageId 最大的消息id
     * @return
     */
    public List<MessageBean> selectScopeMessage(String group_id, String class_type, long minMessageId, long maxMessageId) {
        List<MessageBean> messageBeans = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and (msg_id > ? and msg_id < ?) and "
                + MESSAGE_UID + " = ? and sys_msg_type = ? ", group_id, class_type, minMessageId + "", maxMessageId + "", UclientApplication.getUid(), "normal")
                .order("send_time asc,msg_id desc").find(MessageBean.class);
        if (messageBeans != null && !messageBeans.isEmpty()) {
            //查看是否有特殊消息类型,改变起数据结构以展示聊天内容
            for (MessageBean messageBean : messageBeans) {
                if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
                    messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
                }
                //处理找工作类型的消息
                if (messageBean.getMsg_type().equals(MessageType.MSG_FINDWORK_STRING) && !TextUtils.isEmpty(messageBean.getMsg_prodetails())) {
                    GroupDiscussionInfo info = new Gson().fromJson(messageBean.getMsg_prodetails(), GroupDiscussionInfo.class);
                    messageBean.setMsg_prodetail(info);
                }
            }
            LUtils.e(messageBeans.get(0).getMsg_text() +
                    "查询范围数据:" + messageBeans.size() + "      id:" + messageBeans.get(0).getMsg_id() + "        min:" + minMessageId + "           max:" + maxMessageId);
        }
        return messageBeans;
    }

    /**
     * 查询本地消息
     */
    private List<MessageBean> selectselectReceiveMsgList;


//    public List<MessageBean> selectReceiveMessageList(String group_id, String class_type, String msg_id) {
//        if (null == selectselectReceiveMsgList) {
//            selectselectReceiveMsgList = new ArrayList<>();
//        } else {
//            selectselectReceiveMsgList.clear();
//        }
//        try {
//            LUtils.e(UclientApplication.getUid() + ",," + group_id + "----------开始查询---------" + class_type + ",,,,,,,,,,," + msg_id);
//            LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " > ? and " + MESSAGE_UID + " = ? and sys_msg_type = ? ", group_id, class_type, msg_id, UclientApplication.getUid(), "normal")
//                    .limit(10).findAsync(MessageBean.class).listen(new FindMultiCallback() {
//                @Override
//                public <T> void onFinish(List<T> t) {
//                    selectselectReceiveMsgList = (List<MessageBean>) t;
//                    LUtils.e("查询出来AAAA的大小：" + selectselectReceiveMsgList.size());
//                    Collections.reverse(selectselectReceiveMsgList);
//                    //查看是否有特殊消息类型,改变起数据结构以展示聊天内容
//                    for (MessageBean messageBean : selectselectReceiveMsgList) {
//                        if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
//                            messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
//                        }
//                    }
//
//                }
//            });
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return selectselectReceiveMsgList;
//    }

    /**
     * 读取本地的消息
     *
     * @param group_id
     * @param class_type
     * @param msg_id
     * @param broadCastSuccessListener
     */
    public void selectMessageList(String group_id, String class_type, String msg_id, int limit, final MessageBroadCastListener broadCastSuccessListener) {
        try {
            LUtils.e("----------开始查询---------" + msg_id);
            LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " < ? and " + MESSAGE_UID + " = ? and sys_msg_type =?", group_id, class_type, msg_id, UclientApplication.getUid(), "normal")
                    .order("send_time desc,msg_id desc")
                    .limit(limit).findAsync(MessageBean.class).listen(new FindMultiCallback<MessageBean>() {
                @Override
                public void onFinish(List<MessageBean> list) {
                    List<MessageBean> selectMsgList = list;
                    LUtils.e("----------开始查询---------" + selectMsgList.size());
//                    Collections.reverse(selectMsgList);
                    //查看是否有特殊消息类型,改变起数据结构以展示聊天内容
                    for (MessageBean messageBean : selectMsgList) {
                        if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
                            messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
                        }
                        //处理找工作类型的消息
                        if (messageBean.getMsg_type().equals(MessageType.MSG_FINDWORK_STRING) && !TextUtils.isEmpty(messageBean.getMsg_prodetails())) {
                            GroupDiscussionInfo info = new Gson().fromJson(messageBean.getMsg_prodetails(), GroupDiscussionInfo.class);
                            messageBean.setMsg_prodetail(info);
                        }
                    }
                    broadCastSuccessListener.showRoamMessage(selectMsgList);
                }
            });


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存找工作消息到数据库
     */
    public static void saveWorkMessage(MessageBean bean, String worker_json) {
        if (bean == null) {
            return;
        }
        if (null != bean.getMsg_prodetail()) {
            //网页传递过来的消息手动赋值
            bean.setMessage_uid(UclientApplication.getUid());
            //把消息内容存jsonsetMsg_prodetails
            bean.setMsg_prodetails(worker_json);
            bean.save();
            LUtils.e("-------111-----------开始保存网页消息----------------" + worker_json);
        }
    }

    /**
     * 修改发送中的消息状态为失败
     */
    public void updateMessageFail() {
        ContentValues values = new ContentValues();
        values.put("msg_state", "1");
        LitePal.updateAll(MessageBean.class, values, "msg_state=?", "2");
    }

    /**
     * 删除单条消息
     */
    public void deleteSingleMessage(MessageBean bean) {
        LitePal.deleteAll(MessageBean.class, " local_id = ? ", bean.getLocal_id() + "");
    }

    /**
     * 删除某个组消息
     *
     * @param context
     * @param group_id
     * @param class_type
     */
    public void deleteMessage(Context context, final String group_id, final String class_type) {
        LitePal.deleteAll(MessageBean.class, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and message_uid = ?", group_id, class_type, UclientApplication.getUid());
        MessageUtil.deleteLocalGroupInfo(group_id, class_type);
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST));
    }


    /**
     * 删除聊聊列表信息
     *
     * @param context
     * @param group_id   项目id
     * @param class_type 项目类型
     */
    public void deleteChatListGroupInfo(Context context, final String group_id, final String class_type) {
        MessageUtil.deleteLocalGroupInfo(group_id, class_type);
    }

    /**
     * 清空某个组消息
     *
     * @param activity
     * @param group_id
     * @param class_type
     */
    public void clearMessage(final Activity activity, final String group_id, final String class_type) {
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(activity, null, "确定清空聊天记录吗？",
                new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        CommonMethod.makeNoticeLong(activity, "清空成功！", CommonMethod.SUCCESS);
                        clearGroupMessage(group_id, class_type);
                        MessageUtil.clearChatListMessage(activity, group_id, class_type);
                        LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
                        LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(WebSocketConstance.CLEAR_MESSAGE));
                    }
                });
        dialogLeftRightBtnConfirm.show();
    }


    public void clearGroupMessage(String group_id, String class_type) {
        //保存本组清空缓存的最大消息id
        long maxId = Long.parseLong(selectMaxId(group_id, class_type));
        LUtils.e(maxId + "-------------clearGroupMessage--------------" + group_id + ",," + class_type);
        if (maxId != 0) {
            saveDeleteMessage(new DeleteMessageBean(class_type, group_id, maxId, UclientApplication.getUid()));
        }
        LitePal.deleteAll(MessageBean.class, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and message_uid = ?", group_id, class_type, UclientApplication.getUid());
    }

    /**
     * 查询最大已读max_readed_id
     */
    public long getMaxReadedId(String group_id, String class_type) {
        long maxId = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ",
                group_id, class_type, UclientApplication.getUid()).max(GroupDiscussionInfo.class, MAX_READED_MSG_ID, int.class);
        LUtils.e("-----------getMaxReadedId-----------------" + maxId);
        return maxId;
    }

    /**
     * 查询最大接收 max_asked_id
     */
    public long getMaxAskedId(String group_id, String class_type) {
        long maxId = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ",
                group_id, class_type, UclientApplication.getUid()).max(GroupDiscussionInfo.class, MAX_ASKED_MSG_ID, int.class);
        LUtils.e("-----------getMaxAskedId-----------------" + maxId);
        return maxId;
    }

    /**
     * 修改最大已回执消息 max_readed_id
     */
    public void updateMaxReadedId(MessageBean bean) {
        //如果本地存在的比当前的大，就忽略
        if (getMaxReadedId(bean.getGroup_id(), bean.getClass_type()) >= bean.getMsg_id()) {
            return;
        }
        //修改最大已读id
        ContentValues values = new ContentValues();
        values.put(MAX_READED_MSG_ID, bean.getMsg_id());
        LitePal.updateAll(GroupDiscussionInfo.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ?  and " + MESSAGE_UID + " = ?",
                bean.getGroup_id(), bean.getClass_type(), UclientApplication.getUid());
    }


    /**
     * 修改最大已接收消息max_asked_id
     */
    public void updateMaxAskedId(MessageBean bean) {
        //修改最大已接收到消息id
        //如果本地存在的比当前的大，就忽略
        if (getMaxAskedId(bean.getGroup_id(), bean.getClass_type()) >= bean.getMsg_id()) {
            return;
        }
        ContentValues values = new ContentValues();
        values.put(MAX_ASKED_MSG_ID, bean.getMsg_id());
        LitePal.updateAll(GroupDiscussionInfo.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ?  and " + MESSAGE_UID + " = ?",
                bean.getGroup_id(), bean.getClass_type(), UclientApplication.getUid());
    }

//    /**
//     * 更新聊聊未读数为零
//     *
//     * @param bean
//     */
//    public void clearUnreadCountZero(Context context, MessageBean bean) {
//        updateMaxReadIdAndAskedId(context, bean);
//        //更新聊聊列表underMsgContent;
//    }

//    /**'
//     * 更新聊聊未读数为零
//     *
//     * @param bean
//     */
//    public int getUnReadMsgCount(Context context, MessageBean bean) {
//        updateMaxReadIdAndAskedId(context, bean);
//        //更新聊聊列表underMsgContent;
//        return getUnderMsgCount(bean);
//    }

//    /**
//     * 更新聊聊未读数为零
//     *
//     * @param bean
//     */
//    public void updateMaxReadIdAndAskedId(Context context, MessageBean bean) {
//        if (bean.getMsg_id() == 0) {
//            String max_id = selectMaxId(bean.getGroup_id(), bean.getClass_type());
//            bean.setMsg_id(TextUtils.isEmpty(max_id) ? 0 : Long.parseLong(max_id));
//        }
//        //更新max_readed_id,max_asked_id
//        updateMaxReadedId(bean);
//        updateMaxAskedId(bean);
//    }


//    /**
//     * 修改聊聊消息未读数
//     */
//    public void clearUnreadCountZero(Context context, MessageBean bean) {
//        if (bean.getMsg_id() == 0) {
//            String max_id = selectMaxId(bean.getGroup_id(), bean.getClass_type());
//            bean.setMsg_id(TextUtils.isEmpty(max_id) ? 0 : Long.parseLong(max_id));
//        }
//        //更新max_readed_id,max_asked_id
//        updateMaxReadedId(bean);
//        updateMaxAskedId(bean);
//        //更新聊聊列表underMsgContent;
//        setUnderMsgCount(context, bean);
//    }


//    /**
//     * 更新聊聊列表未读数
//     */
//    public int getUnderMsgCount(MessageBean bean) {
//        //最大已读id
//        long maxReadedId = selectedMaxReadedId(bean);
//        //最大已回执id
//        long maxAskedId = selectedMaxAskedId(bean);
//        LUtils.e(maxReadedId + "--maxReadedId---------maxAskedId-----" + maxAskedId);
//        //两个id相等不处理
//        if (maxReadedId == maxAskedId) {
//            LUtils.e("----------设置未读数为0------------");
//            return 0;
//        } else if (maxReadedId > maxAskedId) {   //最大已读大于最大已回执，更新最大已读等于最大已回执
//            LUtils.e("----------设置未读数为-1------------");
//            bean.setMsg_id(maxReadedId);
//            updateMaxAskedId(bean);
//            return 0;
//        } else if (maxAskedId > maxReadedId) { //最大回执大于最大已读的时候才处理未读数
//            //未读数大小
//            int size = selectMessageList(bean, String.valueOf(maxAskedId), String.valueOf(maxReadedId));
//            LUtils.e("----------设置未读数为A1------------" + size);
//            return size;
//        }
//        return 0;
//    }


//    /**
//     * 更新聊聊列表未读数
//     */
//    public void setUnderMsgCount(Context context, MessageBean bean) {
//        //最大已读id
//        long maxReadedId = selectedMaxReadedId(bean);
//        //最大已回执id
//        long maxAskedId = selectedMaxAskedId(bean);
//        LUtils.e(maxReadedId + "--maxReadedId---------maxAskedId-----" + maxAskedId);
//        //两个id相等不处理
//        if (maxReadedId == maxAskedId) {
//            LUtils.e("----------设置未读数为0------------");
////            updateUnderMsgCount(context, bean, 0);
//            return;
//        }
//        //最大已读大于最大已回执，更新最大已读等于最大已回执
//        if (maxReadedId > maxAskedId) {
//            LUtils.e("----------设置未读数为-1------------");
//            bean.setMsg_id(maxReadedId);
////            updateMaxAskedId(bean);
//            return;
//        }
//        //最大回执大于最大已读的时候才处理未读数
//        if (maxAskedId > maxReadedId) {
//            //未读数大小
//            int size = selectMessageList(bean, String.valueOf(maxAskedId), String.valueOf(maxReadedId));
//            LUtils.e("----------设置未读数为A1------------" + size);
////            updateUnderMsgCount(context, bean, size);
//        }
//    }


    public void updateUnderMsgCount(Context context, MessageBean bean, int size) {
        LUtils.e("-未读数----------size--" + size);
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        //修改首页未读信息
        if (chatMainInfo != null && !TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            Gson gson = new Gson();
            GroupDiscussionInfo groupInfo = gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
            chatMainInfo.setGroup_info(groupInfo);
            if (groupInfo != null && groupInfo.getGroup_id().equals(bean.getGroup_id()) && groupInfo.getClass_type().equals(bean.getClass_type())) {
                groupInfo.setUnread_msg_count(size); //设置消息未读数
                chatMainInfo.setGroup_info_json(gson.toJson(groupInfo));
                chatMainInfo.updateAll("message_uid = ?", UclientApplication.getUid());
            }
        }
        ContentValues values = new ContentValues();
        values.put(UNREAD_MSG_COUNT, size); //清空消息列表未读数
        values.put("at_message", "");
        LitePal.updateAll(GroupDiscussionInfo.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ?  and " + MESSAGE_UID + " = ?", bean.getGroup_id(), bean.getClass_type(), UclientApplication.getUid());
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
    }


    /**
     * 未读数大小
     */
//    public int selectMessageList(MessageBean bean, String max_asked_msg_id, String max_readed_msg_id) {
//        LUtils.e("----------GROUP_ID--------" + bean.getGroup_id());
//        LUtils.e("----------CLASS_TYPE--------" + bean.getClass_type());
//        LUtils.e("----------MAX_ASKED_MSG_ID--------" + max_asked_msg_id);
//        LUtils.e("-----------MAX_READED_MSG_ID-------" + max_readed_msg_id);
//        LUtils.e("-----------MESSAGE_UID-------" + UclientApplication.getUid());
//        int size = (LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MAX_ASKED_MSG_ID + " <= ? and " + MAX_READED_MSG_ID + " > ? and " + MESSAGE_UID + " = ? ", bean.getGroup_id(), bean.getClass_type(), max_asked_msg_id, max_readed_msg_id, UclientApplication.getUid())
//                    .find(GroupDiscussionInfo.class, true)).size();
//        LUtils.e("查询出来未读数大小：" + size);
//        return size;
//    }

    /**
     * 未读数大小
     */
    public int selectMessageList(MessageBean bean, String max_asked_msg_id, String max_readed_msg_id) {
//        LUtils.e("----------GROUP_ID--------" + bean.getGroup_id());
//        LUtils.e("----------CLASS_TYPE--------" + bean.getClass_type());
//        LUtils.e("----------MAX_ASKED_MSG_ID--------" + max_asked_msg_id);
//        LUtils.e("-----------MAX_READED_MSG_ID-------" + max_readed_msg_id);
//        LUtils.e("-----------MESSAGE_UID-------" + UclientApplication.getUid());
        int size = (LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " <= ? and " + MSG_ID + " > ? and "
                + MESSAGE_UID + " = ? ", bean.getGroup_id(), bean.getClass_type(), max_asked_msg_id, max_readed_msg_id, UclientApplication.getUid())
                .find(MessageBean.class)).size();
        LUtils.e("查询出来未读数大小：" + size);
        return size;
    }

//    /**
//     * 修改已读回执
//     */
//    public void updateMsgCallbanckReaded(MessageBean bean) {
//
//        //回执类型（readed 已读 / received 接收 ）
//        ContentValues values = new ContentValues();
//        if (bean.getType().equals(WebSocketConstance.READED)) {
//            values.put("is_readed", "1");
//            LUtils.e("------已读回执-------");
//            LitePal.updateAll(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and msg_id <= ?  and message_uid = ?", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + "", UclientApplication.getUid());
//        }
//    }

//    /**
//     * 修改消息接收回执
//     */
//    public void updateMsgCallbanckReceived(MessageBean bean) {
//
//        //回执类型（readed 已读 / received 接收 ）
//        ContentValues values = new ContentValues();
//        if (bean.getType().equals(WebSocketConstance.RECEIVED)) {
//            values.put("is_received", "1");
//            LUtils.e("------接收回执-------");
//            LitePal.updateAll(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " <= ? and " + MESSAGE_UID + " = ?", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + ""
//                        , UclientApplication.getUid());
//        }
//    }

    /**
     * 修改发送中的消息状态为失败
     */
    public void updateRecallMsg(MessageBean bean) {
        ContentValues values = new ContentValues();
        values.put("msg_type", bean.getMsg_type());
        values.put("msg_text", bean.getMsg_text());
        LitePal.updateAll(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ?  and " + MESSAGE_UID + " = ?  and " + MSG_ID + " = ?",
                bean.getGroup_id(), bean.getClass_type(), UclientApplication.getUid(), String.valueOf(bean.getMsg_id()));
    }

    /**
     * 更新剩余未读数
     */
    public void updateMessageReadedToSender(MessageBean bean) {
        ContentValues values = new ContentValues();
        values.put("unread_members_num", bean.getUnread_members_num());
        LitePal.updateAll(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " <= ? and unread_members_num>?", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + "", "0");
    }

    /**
     * 更新本地已读
     */
    public void updateVoiceIsReadLocal(MessageBean bean) {
        ContentValues values = new ContentValues();
        values.put("is_readed_local", bean.getIs_readed_local());
        LitePal.updateAll(MessageBean.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MSG_ID + " = ? ", bean.getGroup_id(), bean.getClass_type(), bean.getMsg_id() + "");
    }


    /**
     * 保存清空组消息的最大msg_id到数据库
     */
    public void saveDeleteMessage(final DeleteMessageBean bean) {
        //保存消息到本息
        bean.saveOrUpdate("message_uid = ? and group_id = ? and class_type = ?", UclientApplication.getUid(), bean.getGroup_id(), bean.getClass_type());
    }

    /**
     * 保存单挑消息到数据库
     */
    public void saveMessage(final MessageBean bean) {
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

    /**
     * 保存发送成功的消息到数据库并且更新状态消息到数据库
     */
    public void saveSendMessage(final MessageBean bean) {
        //保存消息到本息
        if (null != bean && null != bean.getUser_info()) {
            bean.setMessage_uid(UclientApplication.getUid());
            bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));//存储到子类为了方便修改昵称
            bean.saveOrUpdateAsync(MESSAGE_UID + " = ? and " + GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and local_id = ? ", bean.getMessage_uid(), bean.getGroup_id(), bean.getClass_type(), bean.getLocal_id()).listen(new SaveCallback() {
                @Override
                public void onFinish(boolean success) {
                }
            });
        }
    }


    /**
     * 修改用户在某个组的昵称，备注
     */
    public void updateNickName(String group_id, String class_type, String real_name, String msg_sender, Context context) {
        if (TextUtils.isEmpty(group_id) || TextUtils.isEmpty(class_type) || TextUtils.isEmpty(real_name) || TextUtils.isEmpty(msg_sender)) {
            return;
        }
        Intent updateMyRemarkNameIntent = new Intent(WebSocketConstance.UPDATE_GROUP_PERSON_NAME_INCLUDE_MINE);
        updateMyRemarkNameIntent.putExtra(Constance.USERNAME, real_name);
        updateMyRemarkNameIntent.putExtra(Constance.UID, msg_sender);
        LocalBroadcastManager.getInstance(context).sendBroadcast(updateMyRemarkNameIntent);

        LUtils.e("修改备注的条件--group_id->" + group_id);
        LUtils.e("修改备注的条件--class_type->" + class_type);
        LUtils.e("修改备注的条件--real_name->" + real_name);
        LUtils.e("修改备注的条件--msg_sender->" + msg_sender);
//        LUtils.e("修改备注的条件--UclientApplication.getUid()->" + UclientApplication.getUid());
        try {
            List<MessageBean> list = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and msg_sender = ? and " + MESSAGE_UID + " = ? and sys_msg_type =?", group_id, class_type, msg_sender, UclientApplication.getUid(), "normal").find(MessageBean.class);
            LUtils.e("需要修改昵称的消息数量：" + list.size());
            //查看是否有特殊消息类型,改变起数据结构以展示聊天内容
            for (MessageBean messageBean : list) {
                if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
                    messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
                    messageBean.getUser_info().setReal_name(real_name);
//                    saveMessage(messageBean);
                    ThreadPoolManager.getInstance().executeSaveMessage(messageBean);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 修改消息表的所有头像
     */
    public void updateHeadpic(String msg_sender, String head_pic) {
        LUtils.e("修改头像的条件--msg_sender->" + msg_sender);
        try {
            ContentValues values = new ContentValues();
            values.put("head_pic", head_pic);
            LitePal.updateAll(MessageBean.class, values, "msg_sender = ? ", msg_sender);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 查询本地招聘消息
     *
     * @return
     */
    public ArrayList<MessageBean> selecteRecruitMessage(String minMsgId) {
        ArrayList<MessageBean> messageBeanArrayList = null;
        if (TextUtils.isEmpty(minMsgId)) { //首次加载聊聊数据
            messageBeanArrayList = (ArrayList<MessageBean>) LitePal.where(MESSAGE_UID + " = ? and sys_msg_type =  ? ",
                    UclientApplication.getUid(), MessageType.RECRUIT_MESSAGE_TYPE).order("send_time desc").limit(20).find(MessageBean.class);
        } else {
            messageBeanArrayList = (ArrayList<MessageBean>) LitePal.where(MESSAGE_UID + " = ? and sys_msg_type =  ?  and " + MSG_ID + " < ? ",
                    UclientApplication.getUid(), MessageType.RECRUIT_MESSAGE_TYPE, minMsgId).order("send_time desc").limit(20).find(MessageBean.class);
        }
        Gson gson = new Gson();
        if (messageBeanArrayList != null && messageBeanArrayList.size() > 0) {
            for (MessageBean messageBean : messageBeanArrayList) {
                if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
                    messageBean.setUser_info(gson.fromJson(messageBean.getUser_info_json(), UserInfo.class));
                }
                if (!TextUtils.isEmpty(messageBean.getExtend_json())) {
                    messageBean.setExtend(gson.fromJson(messageBean.getExtend_json(), MessageExtend.class));
                    LUtils.e("messageBean:" + messageBean);
                    try {
                        messageBean.getExtend().setMsg_content(gson.fromJson(new JSONObject(messageBean.getExtend_json()).getString("msg_content"), MessageExtend.class));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        if (messageBeanArrayList != null) {
            Collections.reverse(messageBeanArrayList);
        }
        return messageBeanArrayList;
    }

    /**
     * 查询本地工作消息
     *
     * @param minMsgId 最小的id数
     * @return
     */
    public ArrayList<MessageBean> selecteWorkMessage(String minMsgId) {
        ArrayList<MessageBean> messageBeanArrayList = null;
        if (TextUtils.isEmpty(minMsgId)) { //首次加载聊聊数据
            messageBeanArrayList = (ArrayList<MessageBean>) LitePal.where(MESSAGE_UID + " = ? and sys_msg_type = ? ",
                    UclientApplication.getUid(), MessageType.WORK_MESSAGE_TYPE).order("send_time desc").limit(20).find(MessageBean.class);
        } else {
            messageBeanArrayList = (ArrayList<MessageBean>) LitePal.where(MESSAGE_UID + " = ? and sys_msg_type =  ? and " + MSG_ID + " < ? ",
                    UclientApplication.getUid(), MessageType.WORK_MESSAGE_TYPE, minMsgId).order("send_time desc").limit(20).find(MessageBean.class);
        }
        if (messageBeanArrayList != null && messageBeanArrayList.size() > 0) {
            for (MessageBean messageBean : messageBeanArrayList) {
                if (!TextUtils.isEmpty(messageBean.getUser_info_json())) {
                    messageBean.setUser_info(new Gson().fromJson(messageBean.getUser_info_json(), UserInfo.class));
                }
            }
            Collections.reverse(messageBeanArrayList);
        }
        return messageBeanArrayList;
    }

    /**
     * 查询群聊防骗信息提示日期
     */
    public String selectMsgHintDate(String group_id, String class_type) {
        List<GroupDiscussionInfo> groupDiscussionInfos = LitePal.where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type, UclientApplication.getUid())
                .find(GroupDiscussionInfo.class);
        if (null != groupDiscussionInfos && groupDiscussionInfos.size() > 0) {
            return groupDiscussionInfos.get(0).getHint_msg_date();

        } else {
            return "";
        }
    }

    /**
     * 修改群聊防骗信息提示日期
     */
    public void updateMsgHintDate(String group_id, String class_type, String hint_msg_date) {
        try {
            ContentValues values = new ContentValues();
            values.put("hint_msg_date", hint_msg_date);
            LitePal.updateAll(GroupDiscussionInfo.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type, UclientApplication.getUid());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 读取聊天草稿信息
     */
    public String getMsgDraftText(String group_id, String class_type) {
        List<GroupDiscussionInfo> groupDiscussionInfos = LitePal.select("draft_text").where(GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type, UclientApplication.getUid())
                .find(GroupDiscussionInfo.class);
        if (null != groupDiscussionInfos && groupDiscussionInfos.size() > 0) {
            return groupDiscussionInfos.get(0).getDraft_text();
        } else {
            return "";
        }
    }

    /**
     * 保存聊天草稿信息
     */
    public void saveMsgDraftText(String group_id, String class_type, String draft_text) {
        ContentValues values = new ContentValues();
        values.put("draft_text", draft_text);
        LitePal.updateAll(GroupDiscussionInfo.class, values, GROUP_ID + " = ? and " + CLASS_TYPE + " = ? and " + MESSAGE_UID + " = ? ", group_id, class_type, UclientApplication.getUid());

    }


    /**
     * 修改发送中的消息状态为失败
     */
    public void upMessageStatus(String local_id) {
        LUtils.e("----------接收的json---11---" + local_id);
        ContentValues values = new ContentValues();
        values.put("msg_state", "1");
        LitePal.updateAll(MessageBean.class, values, "local_id = ?", local_id);
    }
}
