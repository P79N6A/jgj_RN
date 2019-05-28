package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BalanceWithdrawAccount;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.ChatInfo;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.ChatUserInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.SourceMemberProManager;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.DialogCloseTeam;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.listener.CallBackConfirm;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import org.litepal.LitePal;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2017/4/27 0027.
 */

public class MessageUtil {


    public static final int TYPE_GROUP_AND_TEAM = 1; //项目、班组
    public static final int TYPE_GROUP_CHAT = 2; //群聊

    public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; //班组、项目组、群聊添加成员
    public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; //记单笔-->从班组、项目组、群聊添加记账成员
    public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; //班组、项目组、群聊查看成员
    public static final int WAY_CREATE_GROUP_CHAT = 0X14; //创建群聊、班组、项目组
    public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; //新建班组时从项目选择成员
    public static final int WAY_ADD_SOURCE_MEMBER = 0X101; //添加数据来源人
    public static final int WAY_ADD_BORROW_MULTIPART_PERSON = 0X100; //借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）

    /**
     * 拉取漫游消息
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型
     * @param minMsgId  小于这个这个消息id的 漫游消息
     */
    public static void getRoamMessageList(Activity context, String groupId, String classType, String minMsgId, CommonHttpRequest.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter(MessageType.GROUP_ID, groupId);
        params.addBodyParameter(MessageType.CLASS_TYPE, classType);
        params.addBodyParameter(MessageType.MSG_ID, minMsgId);
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + "");
        CommonHttpRequest.commonRequest(context, NetWorkRequest.GET_ROAM_MESSAGE_LIST, MessageBean.class, CommonHttpRequest.LIST, params, false, callBack);
    }


    /**
     * 我们将新创建的班组或项目组或群聊存储在数据库中
     *
     * @param context
     * @param tips                班组、项目组、群聊创建成功后打印的文字
     * @param groupDiscussionInfo 班组、项目组、群聊信息
     * @param isRefreshMainIndex  true表示需要调用Http刷新首页数据,false只读取数据库刷新数据
     */
    public static void addTeamOrGroupToLocalDataBase(Context context, String tips, GroupDiscussionInfo groupDiscussionInfo, boolean isRefreshMainIndex) {
        LUtils.e("正在执行操作:" + context.getClass().getName());
        synchronized (MessageUtil.class) {
            if (checkGroupIsExist(context, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type())) {
                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST));
                return;
            }
            if (groupDiscussionInfo != null) {
                //设置当前数据为登录人的标识 查询数据的时候需要使用
                groupDiscussionInfo.setMessage_uid(UclientApplication.getUid());
                Gson gson = new Gson();
                //将头像信息以JSON格式存储
                if (groupDiscussionInfo.getMembers_head_pic() != null && groupDiscussionInfo.getMembers_head_pic().size() > 0) {
                    groupDiscussionInfo.setMembers_head_pic_json(gson.toJson(groupDiscussionInfo.getMembers_head_pic()));
                }
                //设置代班长信息为json方便下次读取
                if (groupDiscussionInfo.getAgency_group_user() != null) {
                    groupDiscussionInfo.setAgency_group_user_json(gson.toJson(groupDiscussionInfo.getAgency_group_user()));
                }
                //如果数据中找不到对应的组信息 就新增一条,如果存在则直接修改项目信息
                groupDiscussionInfo.saveOrUpdate("message_uid = ? and group_id = ? and class_type = ?",
                        UclientApplication.getUid(), groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type());
                if (!TextUtils.isEmpty(tips)) {
                    CommonMethod.makeNoticeShort(context, tips, CommonMethod.SUCCESS);
                }
                if (isRefreshMainIndex) {
                    //请求服务器刷新首页数据
                    LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST));
                } else {
                    //刷新本地数据库消息列表数据
                    LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
                }
            }
            LUtils.e("结束执行操作:" + context.getClass().getName());
        }
    }


    /**
     * 我们将新创建的班组或项目组或群聊存储在数据库中
     *
     * @param context
     * @param groupId
     * @param classType
     */
    public static boolean checkGroupIsExist(Context context, String groupId, String classType) {
        if (TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
            return true;
        }
        return LitePal.isExist(GroupDiscussionInfo.class, "message_uid = ? and group_id = ? and class_type = ?",
                UclientApplication.getUid(), groupId, classType);
    }


    /**
     * 首页小红点状态
     *
     * @param eliminateGroupId   需要排除的组id
     * @param eliminateClassType 需要排除的组类型
     * @return
     */
    public static boolean isShowMainLittleRedCircle(String eliminateGroupId, String eliminateClassType) {
        synchronized (MessageUtil.class) {
            ArrayList<GroupDiscussionInfo> chatMainList = null;
            if (TextUtils.isEmpty(eliminateGroupId) && TextUtils.isEmpty(eliminateClassType)) {
                chatMainList = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and (class_type = ? or class_type = ?)",
                        UclientApplication.getUid(), WebSocketConstance.TEAM, WebSocketConstance.GROUP).find(GroupDiscussionInfo.class);
            } else {
                chatMainList = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and (class_type = ? or class_type = ?) and group_id !=? ",
                        UclientApplication.getUid(), WebSocketConstance.TEAM, WebSocketConstance.GROUP, eliminateGroupId).find(GroupDiscussionInfo.class);
            }
            if (chatMainList == null || chatMainList.isEmpty()) {
                return false;
            }
            for (GroupDiscussionInfo groupDiscussionInfo : chatMainList) {
                if (groupDiscussionInfo.getUnread_quality_count() > 0 || //未读质量数
                        groupDiscussionInfo.getUnread_safe_count() > 0 || //未读安全数
                        groupDiscussionInfo.getUnread_inspect_count() > 0 || //未读检查数
                        groupDiscussionInfo.getUnread_task_count() > 0 || //未读任务数
                        groupDiscussionInfo.getUnread_notice_count() > 0 || //未读通知数
                        groupDiscussionInfo.getUnread_sign_count() > 0 || //未读签到数
                        groupDiscussionInfo.getUnread_meeting_count() > 0 || //未读会议数
                        groupDiscussionInfo.getUnread_approval_count() > 0 || //未读审批数数
                        groupDiscussionInfo.getUnread_log_count() > 0 ||  //未读日志数
                        groupDiscussionInfo.getUnread_weath_count() > 0 ||  //未读晴雨表数
                        groupDiscussionInfo.getUnread_billRecord_count() > 0 || //出勤公示小红点
                        groupDiscussionInfo.getWork_message_num() > 0 ||//未读工作回复消息数
                        groupDiscussionInfo.getUnread_msg_count() > 0) {//未读组消息数
                    return true;
                }
            }
            return false;
        }
    }

    /**
     * 获取单聊信息
     *
     * @param classType
     * @param groupId
     */
    public static GroupDiscussionInfo getLocalSingleGroupChatInfo(String groupId, String classType) {
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("group_id = ? and class_type = ? and message_uid = ?",
                groupId, classType, UclientApplication.getUid()).find(GroupDiscussionInfo.class);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    /**
     * 加载本地聊聊列表数据
     *
     * @param onlyLoadGroupOrSingleChat true表示只加载群聊或者单聊消息
     * @return
     */
    public static ArrayList<GroupDiscussionInfo> getLocalChatListData(boolean onlyLoadGroupOrSingleChat) {
        StringBuilder builder = new StringBuilder();
        builder.append("message_uid = ? and is_delete = 0");
        if (onlyLoadGroupOrSingleChat) {
            builder.append(" and (class_type = '" + WebSocketConstance.TEAM + "' or class_type = '" + WebSocketConstance.GROUP + "' or class_type = '" + WebSocketConstance.GROUP_CHAT +
                    "' or class_type= '" + WebSocketConstance.SINGLECHAT + "')");
        }
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where(builder.toString(),
                UclientApplication.getUid()).order("is_sticked desc, sort_time desc").find(GroupDiscussionInfo.class);
        loadGroupMemberHeadPic(list);
        return list;
    }

    /**
     * 加载本地群聊信息
     *
     * @param removeGroupId   需要排除的GroupId (可以不传)
     * @param removeClassType 需要排除的ClassType(可以不传)
     *                        如果groupId和classType不传 则不排除所有的数据
     * @return
     */
    public static ArrayList<GroupDiscussionInfo> getLocalGroupChat(String removeGroupId, String removeClassType) {
        ArrayList<GroupDiscussionInfo> groupDiscussionInfos = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and class_type = ? ",
                UclientApplication.getUid(), WebSocketConstance.GROUP_CHAT).order("create_time desc").find(GroupDiscussionInfo.class);
        //litepal 加载 数据库已存好的班组、项目组数据
        if (!TextUtils.isEmpty(removeGroupId) && !TextUtils.isEmpty(removeClassType) && groupDiscussionInfos != null && groupDiscussionInfos.size() > 0) {
            int count = 0;
            for (GroupDiscussionInfo groupDiscussionInfo : groupDiscussionInfos) {
                if (removeGroupId.equals(groupDiscussionInfo.getGroup_id()) && removeClassType.equals(groupDiscussionInfo.getClass_type())) {
                    groupDiscussionInfos.remove(count);
                    break;
                }
                count++;
            }
        }
        loadGroupMemberHeadPic(groupDiscussionInfos);
        return groupDiscussionInfos;
    }


    /**
     * 加载本地班组、项目组信息
     *
     * @param isNeedAgencyGroupUser 是否需要加载代班长信息
     * @param removeGroupId         需要排除的GroupId (可以不传)
     * @param removeClassType       需要排除的ClassType(可以不传)
     *                              如果groupId和classType不传 则不排除所有的数据
     * @return
     */
    public static ArrayList<GroupDiscussionInfo> getLocalGroupTeam(boolean isNeedAgencyGroupUser, String removeGroupId, String removeClassType) {
        //litepal 加载 数据库已存好的班组、项目组数据
        ArrayList<GroupDiscussionInfo> groupDiscussionInfos = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and (class_type = ? or class_type = ?) ",
                UclientApplication.getUid(), WebSocketConstance.TEAM, WebSocketConstance.GROUP).order("create_time desc").find(GroupDiscussionInfo.class);
        //litepal 加载 数据库已存好的班组、项目组数据
        if (!TextUtils.isEmpty(removeGroupId) && !TextUtils.isEmpty(removeClassType) && groupDiscussionInfos != null && groupDiscussionInfos.size() > 0) {
            int count = 0;
            for (GroupDiscussionInfo groupDiscussionInfo : groupDiscussionInfos) {
                if (removeGroupId.equals(groupDiscussionInfo.getGroup_id()) && removeClassType.equals(groupDiscussionInfo.getClass_type())) {
                    groupDiscussionInfos.remove(count);
                    break;
                }
                count++;
            }
        }
        loadGroupMemberHeadPic(groupDiscussionInfos);
        if (isNeedAgencyGroupUser && groupDiscussionInfos != null && groupDiscussionInfos.size() > 0) {
            Gson gson = new Gson();
            for (GroupDiscussionInfo groupDiscussionInfo : groupDiscussionInfos) {
                if (!TextUtils.isEmpty(groupDiscussionInfo.getAgency_group_user_json())) { //设置代班长信息
                    groupDiscussionInfo.setAgency_group_user(gson.fromJson(groupDiscussionInfo.getAgency_group_user_json(), AgencyGroupUser.class));
                }
            }
        }
        return groupDiscussionInfos;
    }


    /**
     * 获取通过地区加入的群聊 ,如果没有就返回空
     * 比如 从快速加群-->根据地区里面添加的群聊
     */
    public static GroupDiscussionInfo getAreaJoinGroupChat() {
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and add_from = 2",
                UclientApplication.getUid()).find(GroupDiscussionInfo.class);
        if (list != null && list.size() == 1) {
            GroupDiscussionInfo groupDiscussionInfo = list.get(0);
            groupDiscussionInfo.setIs_exist(1);
            return groupDiscussionInfo;
        }
        return null;
    }


    /**
     * 获取通过工种加入的群聊 ,如果没有就返回空
     * 比如 从快速加群-->根据工种类型里面添加的群聊
     */
    public static GroupDiscussionInfo getWorkTypeGroupChat() {
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and add_from = 1",
                UclientApplication.getUid()).find(GroupDiscussionInfo.class);
        if (list != null && list.size() == 1) {
            GroupDiscussionInfo groupDiscussionInfo = list.get(0);
            groupDiscussionInfo.setIs_exist(1);
            return groupDiscussionInfo;
        }
        return null;
    }

    public static List<String> loadHeadPicFromGroupId(String groupId) {
        if (!TextUtils.isEmpty(groupId)) {
            ArrayList<GroupDiscussionInfo> groupDiscussionInfos = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and class_type = ? and group_id = ? ",
                    UclientApplication.getUid(), WebSocketConstance.GROUP, groupId).find(GroupDiscussionInfo.class);
            if (groupDiscussionInfos != null && groupDiscussionInfos.size() > 0) {
                if (!TextUtils.isEmpty(groupDiscussionInfos.get(0).getMembers_head_pic_json())) {
                    return new Gson().fromJson(groupDiscussionInfos.get(0).getMembers_head_pic_json(), ArrayList.class);
                }
            }
        }
        return null;
    }


    public static void loadGroupMemberHeadPic(ArrayList<GroupDiscussionInfo> groupDiscussionInfos) {
        if (groupDiscussionInfos != null && groupDiscussionInfos.size() > 0) {
            for (GroupDiscussionInfo groupDiscussionInfo : groupDiscussionInfos) {
                //将数据库中的头像Json转换成为数组对象
                if (!TextUtils.isEmpty(groupDiscussionInfo.getMembers_head_pic_json())) {
                    groupDiscussionInfo.setMembers_head_pic(new Gson().fromJson(groupDiscussionInfo.getMembers_head_pic_json(), ArrayList.class));
                }
            }
        }
    }

    /**
     * 加载本地首页数据
     */
    public static ChatMainInfo getLocalWorkCircleData() {
        synchronized (MessageUtil.class) {
            //litepal 加载 数据库已存好的数据
            ArrayList<ChatMainInfo> chatMainList = (ArrayList<ChatMainInfo>) LitePal.where("message_uid = ? ", UclientApplication.getUid()).find(ChatMainInfo.class);
            if (chatMainList == null || chatMainList.isEmpty()) {
                return null;
            }
            //由于首页只显示一条数据 这里我们默认加载第一条
            ChatMainInfo chatMainInfo = chatMainList.get(0);
            if (chatMainInfo == null || TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
                return null;
            }
            Gson gson = new Gson();
            chatMainInfo.setGroup_info(gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class));
            if (chatMainInfo.getGroup_info() != null) {
                if (!TextUtils.isEmpty(chatMainInfo.getGroup_info().getMembers_head_pic_json())) { //设置头像
                    chatMainInfo.getGroup_info().setMembers_head_pic(gson.fromJson(chatMainInfo.getGroup_info().getMembers_head_pic_json(), ArrayList.class));
                }
                if (!TextUtils.isEmpty(chatMainInfo.getGroup_info().getAgency_group_user_json())) { //设置代班长信息
                    chatMainInfo.getGroup_info().setAgency_group_user(gson.fromJson(chatMainInfo.getGroup_info().getAgency_group_user_json(), AgencyGroupUser.class));
                }
            }
            chatMainInfo.setOther_group_unread_msg_count(isShowMainLittleRedCircle(chatMainInfo.getGroup_info().getGroup_id(), chatMainInfo.getGroup_info().getClass_type()) ? 1 : 0);
            return chatMainInfo;
        }
    }


    private static void initChatInfo(ChatMainInfo serverData) {
        if (LitePal.findFirst(ChatMainInfo.class) != null)
            LitePal.deleteAll(ChatMainInfo.class);
        if (serverData != null && serverData.getGroup_info() != null) {
            GroupDiscussionInfo serverGroupInfo = serverData.getGroup_info();
            Gson gson = new Gson();
            //设置当前数据为登录人的标识 查询数据的时候需要使用
            serverData.setMessage_uid(UclientApplication.getUid());
            GroupDiscussionInfo lastMessageBean = getLocalSingleGroupChatInfo(serverGroupInfo.getGroup_id(), serverGroupInfo.getClass_type());
            //设置最后一条的消息未读数,如果没有就设置为0
            serverGroupInfo.setUnread_msg_count(lastMessageBean != null ? lastMessageBean.getUnread_msg_count() : 0);
            //设置头像信息为json方便下次读取
            if (serverGroupInfo.getMembers_head_pic() != null && serverGroupInfo.getMembers_head_pic().size() > 0) {
                serverGroupInfo.setMembers_head_pic_json(gson.toJson(serverGroupInfo.getMembers_head_pic()));
            }
            //设置代班长信息为json方便下次读取
            if (serverGroupInfo.getAgency_group_user() != null) {
                String agencyJson = gson.toJson(serverGroupInfo.getAgency_group_user());
                serverGroupInfo.setAgency_group_user_json(agencyJson);
            }
            //重新覆盖代班长设置的信息
            if (lastMessageBean != null) {
                lastMessageBean.setAgency_group_user_json(!TextUtils.isEmpty(serverGroupInfo.getAgency_group_user_json()) ? serverGroupInfo.getAgency_group_user_json() : "");
                lastMessageBean.save();
            }
            //将项目组信息以Json数组的方式存储
            serverData.setGroup_info_json(gson.toJson(serverGroupInfo));
            serverData.save();
        }
    }

    /**
     * 调用http获取首页数据
     *
     * @param context
     */
    public static void getWorkCircleData(final Context context) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        CommonHttpRequest.commonRequest(context, NetWorkRequest.GET_CHAT_MAIN_INFO, ChatMainInfo.class, false, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ChatMainInfo serverData = (ChatMainInfo) object;
                initChatInfo(serverData);
//                我们在这里发送一条广播通知App首页, 重新获取数据
                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS));
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR));
            }
        });
    }

    /**
     * 调用http获取首页数据
     *
     * @param context
     */
    public static void getWorkCircleData(final Context context, final boolean sendSetIndexBroaderCast, final boolean isEnterMyGroupActivity) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        CommonHttpRequest.commonRequest(context, NetWorkRequest.GET_CHAT_MAIN_INFO, ChatMainInfo.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ChatMainInfo serverData = (ChatMainInfo) object;
                initChatInfo(serverData);
                if (sendSetIndexBroaderCast) {
                    Intent intent = new Intent(Constance.SET_INDEX);
                    intent.putExtra(Constance.IS_ENTER_GROUP, isEnterMyGroupActivity);
                    LocalBroadcastManager.getInstance(context).sendBroadcast(intent); //我们这里发送一条广播通知一下，因为有很多地方可以设置首页项目组
                }
//              我们在这里发送一条广播通知App首页, 重新获取数据
                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS));
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR));
            }
        });
    }


    /**
     * 获取聊聊  列表信息
     *
     * @param context
     */
    public static void getSingleChatListData(final Context context, final String groupId, final String classType) {
        String httpUrl = NetWorkRequest.GET_CHAT_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, ChatInfo.class, false, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(final Object object) {
                ChatInfo chatInfo = (ChatInfo) object;
                if (chatInfo != null) {
                    ArrayList<GroupDiscussionInfo> serverList = chatInfo.getList();
                    if (serverList != null && serverList.size() > 0) {
                        GroupDiscussionInfo groupDiscussionInfo = serverList.get(0);
                        MessageBean lastMessageBean = DBMsgUtil.getInstance().selectLastMessage(groupId, classType);
                        groupDiscussionInfo.setMessage_uid(UclientApplication.getUid());
                        groupDiscussionInfo.setMsg_text(lastMessageBean == null ? null : lastMessageBean.getMsg_text()); //设置发送的消息 如果是工作消息 没有标题就取内容展示
                        groupDiscussionInfo.setMsg_sender(lastMessageBean == null ? null : lastMessageBean.getMsg_sender()); //设置发送人id
                        groupDiscussionInfo.setSend_time(lastMessageBean == null ? 0 : lastMessageBean.getSend_time()); //设置发送时间
                        groupDiscussionInfo.setSort_time(lastMessageBean == null ? 0 : lastMessageBean.getSend_time()); //设置发送时间
                        addTeamOrGroupToLocalDataBase(context, null, groupDiscussionInfo, false);
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 获取聊聊  列表信息
     *
     * @param context
     */
    public static void getChatListData(final Activity context, final boolean isStartWebSocket) {
        String httpUrl = NetWorkRequest.GET_CHAT_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        CommonHttpRequest.commonRequest(context, httpUrl, ChatInfo.class, false, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(final Object object) {
                try {
                    ChatInfo chatInfo = (ChatInfo) object;
                    if (chatInfo != null) {
                        //获取服务器列表数据
                        ArrayList<GroupDiscussionInfo> serverList = chatInfo.getList();
                        Gson gson = new Gson();
                        if (serverList != null && serverList.size() > 0) {
                            for (GroupDiscussionInfo serverBean : serverList) {
                                GroupDiscussionInfo lastMessageBean = getLocalSingleGroupChatInfo(serverBean.getGroup_id(), serverBean.getClass_type());
                                serverBean.setMessage_uid(UclientApplication.getUid());
                                serverBean.setTitle(lastMessageBean == null ? null : lastMessageBean.getTitle());
                                serverBean.setMsg_text(lastMessageBean == null ? null : lastMessageBean.getMsg_text()); //设置发送的消息 如果是工作消息 没有标题就取内容展示
                                serverBean.setMsg_sender(lastMessageBean == null ? null : lastMessageBean.getMsg_sender()); //设置发送人id
                                serverBean.setSend_time(lastMessageBean == null ? 0 : lastMessageBean.getSend_time()); //设置发送时间
                                serverBean.setSort_time(lastMessageBean == null ? 0 : lastMessageBean.getSend_time());
                                serverBean.setAt_message(lastMessageBean == null ? null : lastMessageBean.getAt_message()); //设置At的消息
//                                serverBean.setReal_name(lastMessageBean == null ? null : lastMessageBean.getReal_name()); //设置发送人名称
                                serverBean.setUnread_msg_count(lastMessageBean == null ? 0 : lastMessageBean.getUnread_msg_count()); //设置本地已读未读的消息
                                serverBean.setIs_delete(lastMessageBean == null ? 0 : lastMessageBean.getIs_delete()); //是否已删除的标识
                                serverBean.setAdd_from(lastMessageBean == null ? 0 : lastMessageBean.getAdd_from());
                                if (serverBean.getAgency_group_user() != null) { //设置代班长信息
                                    serverBean.setAgency_group_user_json(gson.toJson(serverBean.getAgency_group_user()));
                                }
                                if (serverBean.getMembers_head_pic() != null && serverBean.getMembers_head_pic().size() > 0) {
                                    serverBean.setMembers_head_pic_json(gson.toJson(serverBean.getMembers_head_pic()));
                                }
                            }
                            //删除本地列表数据
                            LitePal.deleteAll(GroupDiscussionInfo.class);
                            //保存重新设置好的服务器数据
                            LitePal.saveAll(serverList);
                        }
                        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_LIST));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (isStartWebSocket) {
                        SocketManager.getInstance(context.getApplicationContext()).init();
//                        MessageUtils.getOffMessageList(context, false);//拉取离线消息
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                if (isStartWebSocket) {
                    SocketManager.getInstance(context.getApplicationContext()).init();
//                    MessageUtils.getOffMessageList(context, false);//拉取离线消息
                }
            }
        });
    }

    /**
     * 获取成员列表数据
     *
     * @param context
     * @param groupId   项目组id
     * @param classType 类型 team表示项目组,group表示班组
     * @param callBack  数据加载成功或失败的回调
     */

    public static void getGroupMembers(Activity context, String groupId, String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.GET_MEMBER_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupMemberInfo.class, true, params, true, callBack);
    }

    /**
     * 获取班组、项目组信息
     *
     * @param context
     * @param groupId   项目组id
     * @param classType 组类型 取值为team、group
     * @param callBack  数据加载成功或失败的回调
     */
    public static void getGroupInfo(Activity context, String groupId, String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.GET_GROUP_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupManager.class, false, params, true, callBack);
    }


    /**
     * 设置首页组，因为有很多地方可以设置首页项目组 我们这里抽象出来
     *
     * @param groupDiscussionInfo    项目组信息
     * @param isPrintTips            这个参数暂时没有用了
     * @param isEnterMyGroupActivity true表示需要进入我的项目班组页面
     */
    public static void setIndexList(final Activity context, final GroupDiscussionInfo groupDiscussionInfo, final boolean isPrintTips, final boolean isEnterMyGroupActivity) {
        if (groupDiscussionInfo == null) {
            return;
        }
        final CustomProgress loadingDialog = new CustomProgress(context);
        loadingDialog.show(context, null, false);
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("group_id", groupDiscussionInfo.getGroup_id());
        params.addBodyParameter("class_type", groupDiscussionInfo.getClass_type());
        CommonHttpRequest.commonRequest(context, NetWorkRequest.SET_INDEX_LIST, BaseNetNewBean.class, false, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonHttpRequest.commonRequest(context, NetWorkRequest.GET_CHAT_MAIN_INFO, ChatMainInfo.class, false,
                        RequestParamsToken.getExpandRequestParams(context.getApplicationContext()), false, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                ChatMainInfo serverData = (ChatMainInfo) object;
                                initChatInfo(serverData);
                                Intent intent = new Intent(Constance.SET_INDEX);
                                intent.putExtra(Constance.IS_ENTER_GROUP, isEnterMyGroupActivity);
                                LocalBroadcastManager.getInstance(context).sendBroadcast(intent); //我们这里发送一条广播通知一下，因为有很多地方可以设置首页项目组
//                              我们在这里发送一条广播通知App首页, 重新获取数据
                                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS));
                                loadingDialog.dismiss();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {
                                LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR));
                                loadingDialog.dismiss();
                            }
                        });
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                loadingDialog.dismiss();
            }
        });
    }


    /**
     * 彻底删除班组、项目组
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型 取值为group,team
     * @param callBack  数据加载成功或失败的回调
     */
    public static void thoroughDeleteGroup(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        switch (classType) {
            case WebSocketConstance.GROUP: //班组
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.remove_group_tips), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        thoroughDelete(context, groupId, classType, callBack);
                    }
                }).show();
                break;
            case WebSocketConstance.TEAM: //项目组
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.remove_team_tips), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        thoroughDelete(context, groupId, classType, callBack);
                    }
                }).show();
                break;
            case WebSocketConstance.GROUP_CHAT: //群聊
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.delete_and_exit_group_hint), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        thoroughDelete(context, groupId, classType, callBack);
                    }
                }).show();
                break;
        }
    }


    private static void thoroughDelete(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.DEL_GROUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }

    /**
     * 退出班组、项目组
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型 取值为group,team
     * @param callBack  数据加载成功或失败的回调
     */
    public static void quitGroup(final BaseActivity context, final String groupId, final String classType,
                                 final CommonHttpRequest.CommonRequestCallBack callBack) {
        switch (classType) {
            case WebSocketConstance.TEAM: //项目组
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.quit_project), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        quitTeamGroup(context, groupId, classType, callBack);
                    }
                }).show();
                break;
            case WebSocketConstance.GROUP: //班组
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.exit_group_desc), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        quitTeamGroup(context, groupId, classType, callBack);
                    }
                }).show();
                break;
            case WebSocketConstance.GROUP_CHAT: //群聊
                new DialogLeftRightBtnConfirm(context, null, context.getString(R.string.delete_and_exit_group_hint), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        quitTeamGroup(context, groupId, classType, callBack);
                    }
                }).show();
                break;
        }
    }

    /**
     * 退出项目组、关闭同步
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型 取值为group,team
     */
    public static void closeSync(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.TEAM_MEMBER_CLOSE_SYNC;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }


    private static void quitTeamGroup(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.QUIT_GROUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }

    /**
     * 移除黑名单
     *
     * @param context
     * @param uid             被移除人的id
     * @param removeBlackList 用户状态 true表示移除黑名单,false表示加入黑名单
     */
    public static void removeBlackList(Activity context, String uid, boolean removeBlackList, final CommonHttpRequest.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter(Constance.UID, uid);
        CommonHttpRequest.commonRequest(context, removeBlackList ? NetWorkRequest.RM_BLACK_LIST : NetWorkRequest.ADD_BLACK_LIST, ChatUserInfo.class, CommonHttpRequest.LIST,
                params, true, callBack);
    }

    /**
     * 重新开启班组、项目组
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型 取值为group,team
     * @param callBack  数据加载成功或失败的回调
     */
    public static void reOpen(final Activity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.REOPEN_GROUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupDiscussionInfo.class, false, params, true, callBack);
    }

    /**
     * 暂时关闭班组、项目组、群聊
     *
     * @param context
     * @param groupId   组id
     * @param classType 组类型 取值为group,team
     * @param callBack  数据加载成功或失败的回调
     */
    public static void closeTeamGroup(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        switch (classType) {
            case WebSocketConstance.TEAM:
                new DialogLeftRightBtnConfirm(context, "关闭项目提醒", context.getString(R.string.close_project), new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        executeCloseTeamGroup(context, groupId, classType, callBack);
                    }
                }).show();
                break;
            case WebSocketConstance.GROUP:
                new DialogCloseTeam(context, new CallBackConfirm() {
                    @Override
                    public void callBack() {
                        executeCloseTeamGroup(context, groupId, classType, callBack);
                    }
                }, context.getString(classType.equals(WebSocketConstance.GROUP) ? R.string.close_group_tips : R.string.close_project)).show();
                break;
        }
    }


    private static void executeCloseTeamGroup(final BaseActivity context, final String groupId, final String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.CLOSE_TEAM_GROUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }

    /**
     * 修改项目组、班组信息
     *
     * @param context
     * @param groupId        项目组id
     * @param classType      组类型 取值为group,team
     * @param groupName      项目组名称
     * @param nickName       昵称
     * @param cityCode       城市编码(班组设置地点使用)
     * @param isNotDisturbed 是否免打扰(1表示免打扰,0反之)
     * @param isStick        是否消息置顶(1表示置顶,0反之)
     * @param cityName       城市名称(项目地点的时候使用)
     * @param callBack       加载数据成功后的回调
     */
    public static void modifyTeamGroupInfo(final Activity context, final String groupId, final String classType, String groupName, String nickName, String cityCode,
                                           String isNotDisturbed, String isStick, String cityName, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.GROUP_MODIFY;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        if (!TextUtils.isEmpty(groupName)) {
            params.addBodyParameter("group_name", groupName);
        }
        if (nickName != null) {
            params.addBodyParameter("nickname", nickName);
        }
        if (!TextUtils.isEmpty(cityCode)) {
            params.addBodyParameter("city_code", cityCode);
        }
        if (!TextUtils.isEmpty(isNotDisturbed)) {
            params.addBodyParameter("is_not_disturbed", isNotDisturbed);
        }
        if (!TextUtils.isEmpty(isStick)) {
            params.addBodyParameter("is_stick", isStick);
        }
        if (!TextUtils.isEmpty(cityName)) {
            params.addBodyParameter("city_name", cityName);
        }
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }


    /**
     * 设置备注名称
     *
     * @param context
     * @param groupId     项目组id
     * @param classType   组类型 取值为group,team
     * @param uid         备注人id
     * @param commentName 备注名称
     * @param callBack    加载数据成功后的回调
     */
    public static void setCommentName(final Activity context, final String groupId, final String classType, String uid, String commentName, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.SET_USER_COMMENT_NAME;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId);
        }
        if (!TextUtils.isEmpty(classType)) {
            params.addBodyParameter("class_type", classType);
        }
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        if (!TextUtils.isEmpty(commentName)) {
            params.addBodyParameter("comment_name", commentName);
        }
        CommonHttpRequest.commonRequest(context, httpUrl, UserInfo.class, false, params, true, callBack);
    }


    /**
     * 获取管理员列表
     *
     * @param context
     * @param groupId   项目组id
     * @param classType 组类型 取值为group,team
     * @param type      判断是@成员 type=’at_member’，添加管理员列表 type=’set_admin_list’ 获取管理员列表 type=’get_admin_list’
     * @param callBack  加载数据成功后的回调
     */
    public static void getAdminList(final Activity context, final String groupId, final String classType, String type, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.ADMIN_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        //判断是@成员 type=’at_member’，添加管理员列表 type=’set_admin_list’ 获取管理员列表 type=’get_admin_list’
        params.addBodyParameter("type", type);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupMemberInfo.class, true, params, true, callBack);
    }


    /**
     * 获取好友列表
     *
     * @param context
     * @param groupId   如果传了groupId 就需要排除通讯录中已存在的人员
     * @param classType 组类型
     * @param callBack
     */
    public static void getFriendList(final Activity context, String groupId, String classType, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.FRIEND_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupMemberInfo.class, true, params, true, callBack);
    }

    /**
     * 获取最后一个好友申请人的头像
     *
     * @param context
     * @param callBack
     */
    public static void getTempFriend(final Activity context, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.GET_TEMPORARY_FRIEND;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        CommonHttpRequest.commonRequest(context, httpUrl, UserInfo.class, false, params, false, callBack);
    }


    /**
     * @param context
     * @param groupId          项目组、班组id
     * @param classType        组类型
     * @param isQrCode         是否二维码加群
     * @param qrCodeCreateTime 二维码创建时间
     * @param inviterUid       二维码邀请者
     * @param groupMembers     通讯录添加成员[{telephone:13888888888,real_name:小明}]
     * @param callBack
     */
    public static void addMembers(final Activity context, String groupId, String classType, boolean isQrCode, long qrCodeCreateTime, String inviterUid, String groupMembers,
                                  final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.ADD_MEMBERS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        if (isQrCode) { //通过二维码添加成员
            params.addBodyParameter("is_qr_code", "1");
            params.addBodyParameter("qr_code_create_time", qrCodeCreateTime + "");
            params.addBodyParameter("inviter_uid", inviterUid);
        }
        params.addBodyParameter("group_members", groupMembers);
        CommonHttpRequest.commonRequest(context, httpUrl, BalanceWithdrawAccount.class, false, params, true, callBack);
    }

    /**
     * @param context
     * @param groupId      项目组、班组id
     * @param classType    组类型
     * @param groupMembers 通讯录添加成员[{telephone:13888888888,real_name:小明}]
     * @param callBack
     */
    public static void addMembers(final Activity context, String groupId, String classType, ArrayList<GroupMemberInfo> groupMembers, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.ADD_MEMBERS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("group_members", new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create().toJson(groupMembers));
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }

    /**
     * @param context
     * @param groupId      项目组、班组id
     * @param classType    组类型
     * @param groupMembers 通讯录添加成员[{telephone:13888888888,real_name:小明}]
     * @param callBack
     */
    public static void addFastGroupChat(final Activity context, String groupId, String classType, ArrayList<GroupMemberInfo> groupMembers, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.ADD_MEMBERS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("fast_add_group", "1");
        params.addBodyParameter("group_members", new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create().toJson(groupMembers));
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }


    /**
     * 创建群聊
     *
     * @param context
     * @param uid      添加的成员，逗号隔开
     * @param code     面对面建群时的code(如果普通创建的设为null)
     * @param callBack
     */
    public static void createGroupChat(final Activity context, String uid, String code, final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.CREATE_GROUPCHAT;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("code", code);
        CommonHttpRequest.commonRequest(context, httpUrl, GroupDiscussionInfo.class, false, params, true, callBack);
    }


    /**
     * 修改本地班组、项目组信息
     *
     * @param context
     * @param groupId        班组id 主要是做查询修改的作用
     * @param classType      组类型
     * @param unreadMsgCount 消息未读数
     * @param msgText        文本消息
     * @param title          工作消息，招聘消息，活动消息可能会需要用到的title
     * @param maxReadMsgId   已读的最大消息数
     * @param realName       消息发送者名称
     * @param msgSender      消息发送者id
     */
    public static void setLastMessageInfo(final Activity context, String groupId,
                                          String classType, String unreadMsgCount, String msgText, long send_time, String title, String maxReadMsgId, String realName, String msgSender) {
        if (TextUtils.isEmpty(classType)) {
            return;
        }
        Intent intent = new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST);
        ContentValues values = new ContentValues();
        if (!TextUtils.isEmpty(unreadMsgCount)) {
            values.put("unread_msg_count", unreadMsgCount);
        }
        if (!TextUtils.isEmpty(msgText)) {
            values.put("msg_text", msgText);
        }
        if (send_time != 0) {
            values.put("send_time", send_time);
            values.put("sort_time", send_time);
        }
        if (title != null) {
            values.put("title", title);
        }
        if (realName != null) {
            values.put("real_name", realName);
        }
        if (!TextUtils.isEmpty(msgSender)) {
            values.put("msg_sender", msgSender);
        }
        values.put("max_readed_msg_id", maxReadMsgId);
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ? and message_uid = ?", groupId, classType, UclientApplication.getUid());
        if (!TextUtils.isEmpty(unreadMsgCount)) {
            updataMainInfo(groupId, classType, null, unreadMsgCount, null, null);
        }
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }


    /**
     * 修改本地班组、项目组信息
     *
     * @param context
     * @param isStick        消息是否置顶(1表示置顶,0反之,可以为空)
     * @param groupName      项目组名称(可以为空)
     * @param isNotDisturbed 是否免打扰(1表示免打扰,0反之,可以为空)
     * @param groupId        班组id 主要是做查询修改的作用
     * @param classType      组类型
     * @param unreadMsgCount 消息未读数
     * @param msgText        文本消息
     * @param memberHeadPic  头像信息
     * @param memberNum      成员数量
     * @param atMessage      @我的消息
     * @param realName       消息发送者名称
     * @param msgSender      消息发送者id
     * @param title          工作消息，招聘消息，活动消息可能会需要用到的title
     */
    public static void modityLocalTeamGroupInfo(final Activity context, String isStick, String groupName, String isNotDisturbed, String groupId,
                                                String classType, String unreadMsgCount, String msgText, List<String> memberHeadPic, String memberNum, long send_time,
                                                String atMessage, String realName, String msgSender, String title) {
        if (TextUtils.isEmpty(classType)) {
            return;
        }
        Intent intent = new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST);
        ContentValues values = new ContentValues();
        if (!TextUtils.isEmpty(isStick)) {
            values.put("is_sticked", isStick);
            if (isStick.equals("1")) { //如果是置顶的操作 我们将Sort_time设置为当前时间
                values.put("sort_time", System.currentTimeMillis() / 1000 + "");
            }
        }
        if (!TextUtils.isEmpty(isNotDisturbed)) {
            values.put("is_no_disturbed", isNotDisturbed);
        }
        if (!TextUtils.isEmpty(groupName)) {
            intent.putExtra(Constance.GROUP_NAME, groupName);
            values.put("group_name", groupName);
        }
        if (!TextUtils.isEmpty(unreadMsgCount)) {
            values.put("unread_msg_count", unreadMsgCount);
        }
        if (!TextUtils.isEmpty(msgText)) {
            values.put("msg_text", msgText);
        }
        if (memberHeadPic != null && memberHeadPic.size() > 0) {
            values.put("members_head_pic_json", new Gson().toJson(memberHeadPic));
        }
        if (!TextUtils.isEmpty(memberNum)) {
            intent.putExtra(Constance.MEMBER_NUMBER, memberNum);
            values.put("members_num", memberNum);
        }
        if (send_time != 0) {
            values.put("send_time", send_time);
            values.put("sort_time", send_time);
        }
        if (!TextUtils.isEmpty(atMessage)) {
            values.put("at_message", atMessage);
        }
        if (realName != null) {
            values.put("real_name", realName);
        }
        if (!TextUtils.isEmpty(msgSender)) {
            values.put("msg_sender", msgSender);
        }
        if (title != null) {
            values.put("title", title);
        }
        values.put("is_delete", "0"); //设置未删除的标记
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ? and message_uid = ?", groupId, classType, UclientApplication.getUid());
        if (!TextUtils.isEmpty(groupName) || !TextUtils.isEmpty(unreadMsgCount) || (memberHeadPic != null && memberHeadPic.size() > 0) || !TextUtils.isEmpty(memberNum)) {
            updataMainInfo(groupId, classType, groupName, unreadMsgCount, memberHeadPic, memberNum);
        }
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }

    /**
     * 设置快速加群的群聊标识
     *
     * @param context
     * @param addFrom 1表示从快速加群-->工种群
     *                2表示从快速加群-->地区群
     */
    public static void modityLocalTeamGroupInfo(final Activity context, String groupId, String classType, int addFrom) {
        Intent intent = new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST);
        ContentValues values = new ContentValues();
        values.put("add_from", addFrom);
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ? and message_uid = ?", groupId, classType, UclientApplication.getUid());
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }

    /**
     * 修改本地班组、项目组信息 不发送修改数据的广播
     *
     * @param context
     * @param isStick        消息是否置顶(1表示置顶,0反之,可以为空)
     * @param groupName      项目组名称(可以为空)
     * @param isNotDisturbed 是否免打扰(1表示免打扰,0反之,可以为空)
     * @param groupId        班组id 主要是做查询修改的作用
     * @param classType      组类型
     * @param unreadMsgCount 消息未读数
     * @param msgText        文本消息
     * @param memberHeadPic  头像信息
     * @param memberNum      成员数量
     * @param atMessage      @我的消息
     * @param realName       消息发送者名称
     * @param msgSender      消息发送者id
     */
    public static void modityLocalTeamGroupInfoNoSendBroaderCast(final Context context, String isStick, String groupName, String isNotDisturbed, String groupId,
                                                                 String classType, String unreadMsgCount, String msgText, List<String> memberHeadPic, String memberNum, long send_time,
                                                                 String atMessage, String realName, String msgSender, String title, long maxReadMsgId) {
        if (TextUtils.isEmpty(classType)) {
            return;
        }
        ContentValues values = new ContentValues();
        if (!TextUtils.isEmpty(isStick)) {
            values.put("is_sticked", isStick);
            if (isStick.equals("1")) { //如果是置顶的操作 我们将Sort_time设置为当前时间
                values.put("sort_time", System.currentTimeMillis() / 1000 + "");
            }
        }
        if (!TextUtils.isEmpty(isNotDisturbed)) {
            values.put("is_no_disturbed", isNotDisturbed);
        }
        if (!TextUtils.isEmpty(groupName)) {
            values.put("group_name", groupName);
        }
        if (!TextUtils.isEmpty(unreadMsgCount)) {
            values.put("unread_msg_count", unreadMsgCount);
        }
        if (!TextUtils.isEmpty(msgText)) {
            values.put("msg_text", msgText);
        }
        if (memberHeadPic != null && memberHeadPic.size() > 0) {
            values.put("members_head_pic_json", new Gson().toJson(memberHeadPic));
        }
        if (!TextUtils.isEmpty(memberNum)) {
            values.put("members_num", memberNum);
        }
        if (send_time != 0) {
            values.put("send_time", send_time);
            values.put("sort_time", send_time);
        }
        if (!TextUtils.isEmpty(atMessage)) {
            values.put("at_message", atMessage);
        }
        if (realName != null) {
            values.put("real_name", realName);
        }
        if (!TextUtils.isEmpty(msgSender)) {
            values.put("msg_sender", msgSender);
        }
        if (!TextUtils.isEmpty(msgSender)) {
            values.put("msg_sender", msgSender);
        }
        values.put("title", title);
        if (maxReadMsgId != 0) {
            values.put("max_readed_msg_id", maxReadMsgId);
        }
        values.put("is_delete", "0"); //设置未删除的标记
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ? and message_uid = ?", groupId, classType, UclientApplication.getUid());
        if (!TextUtils.isEmpty(groupName) || !TextUtils.isEmpty(unreadMsgCount) || (memberHeadPic != null && memberHeadPic.size() > 0) || !TextUtils.isEmpty(memberNum)) {
            updataMainInfo(groupId, classType, groupName, unreadMsgCount, memberHeadPic, memberNum);
        }
    }


    /**
     * 修改工作消息类型
     *
     * @param messageBean
     */
    public static void updateWorkMessageInfo(MessageBean messageBean) {
        ContentValues values = new ContentValues();
        if (!TextUtils.isEmpty(messageBean.getMsg_text())) { //设置工作消息发送内容
            values.put("msg_text", messageBean.getMsg_text());
        }
        if (!TextUtils.isEmpty(messageBean.getTitle())) { //设置工作消息发送人信息
            values.put("title", messageBean.getTitle());
        }
        if (!TextUtils.isEmpty(messageBean.getMsg_type())) { //设置发送人的id
            values.put("msg_type", messageBean.getMsg_type());
        }
        LitePal.updateAll(MessageBean.class, values, "group_id = ? and msg_id = ? and message_uid = ? ", MessageType.WORK_MESSAGE_ID,
                messageBean.getMsg_id() + "", UclientApplication.getUid());
    }

    /**
     * 修改首页数据库信息
     */
    private static void updataMainInfo(String groupId, String classType, String groupName, String unreadMsgCount, List<String> memberHeadPic, String memberNum) {
        //litepal 加载 数据库已存好的数据
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        if (chatMainInfo != null && !TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            Gson gson = new Gson();
            chatMainInfo.setGroup_info(gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class));
            GroupDiscussionInfo groupDiscussionInfo = chatMainInfo.getGroup_info();
            //只要组类型和组id 以及登录人身份匹配 我们这里就修改首页本地数据库信息
            if (groupDiscussionInfo != null
                    && groupId.equals(groupDiscussionInfo.getGroup_id())
                    && classType.equals(groupDiscussionInfo.getClass_type())
                    && UclientApplication.getUid().equals(chatMainInfo.getMessage_uid())) {
                if (!TextUtils.isEmpty(groupName)) {
                    groupDiscussionInfo.setGroup_name(groupName);
                }
                if (!TextUtils.isEmpty(unreadMsgCount)) {
                    groupDiscussionInfo.setUnread_msg_count(Integer.parseInt(unreadMsgCount));
                }
                if (memberHeadPic != null && memberHeadPic.size() > 0) {
                    chatMainInfo.getGroup_info().setMembers_head_pic_json(gson.toJson(memberHeadPic));
                }
                if (!TextUtils.isEmpty(memberNum)) {
                    groupDiscussionInfo.setMembers_num(memberNum);
                }
                chatMainInfo.setGroup_info_json(gson.toJson(groupDiscussionInfo));
                chatMainInfo.save();
            }
        }
    }


    /**
     * 修改组的类型
     *
     * @param context
     * @param groupDiscussionInfo
     * @param oldClassType
     */
    public static void updateGroupClassTypeAndGroupId(Activity context, GroupDiscussionInfo groupDiscussionInfo, String oldGroupId, String oldClassType) {
        if (groupDiscussionInfo == null || TextUtils.isEmpty(groupDiscussionInfo.getClass_type()) || TextUtils.isEmpty(groupDiscussionInfo.getGroup_id())) {
            return;
        }
        ContentValues values = new ContentValues();
        values.put("class_type", groupDiscussionInfo.getClass_type());
        values.put("group_id", groupDiscussionInfo.getGroup_id());
        groupDiscussionInfo.saveOrUpdate("group_id = ? and class_type = ? and message_uid = ?", oldGroupId,
                oldClassType, UclientApplication.getUid());
        //我们在这里发送一条广播通知消息列表，通知首页和聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST));
    }


    /**
     * 根据电话号码获取用户信息
     *
     * @param context
     * @param telephone 电话号码
     */
    public static void useTelGetUserInfo(Activity context, String telephone, final CommonHttpRequest.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("telephone", telephone);
        CommonHttpRequest.commonRequest(context, NetWorkRequest.USERTEL_GET_USERINFO, GroupMemberInfo.class, CommonHttpRequest.OBJECT,
                params, true, callBack);
    }


    /**
     * 获取数据来源人数据源
     *
     * @param context
     * @param groupId   项目组、班组id
     * @param classType 组类型
     * @param uid       成员id
     * @param callBack
     */
    public static void getSourceMemberSource(final Activity context, String groupId, String classType, String uid,
                                             final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.SYNCPRO_FROM_SOURCE_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(context, httpUrl, SourceMemberProManager.class, false, params, true, callBack);
    }


    /**
     * 添加数据来源人
     *
     * @param context
     * @param groupId       项目组、班组id
     * @param classType     组类型
     * @param sourceMembers 数据来源人
     * @param sourceProId   加入的数据源,多个用逗号隔开，如 2,3,4
     * @param callBack
     */
    public static void addSourceMember(final Activity context, String groupId, String classType, ArrayList<GroupMemberInfo> sourceMembers, String sourceProId,
                                       final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.ADD_SOURCE_MEMBER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        ////[{'uid':'1212','real_name':'常生','telphone':'18762315486','is_demand':'0' //不要求同步项目}]
        if (sourceMembers != null && sourceMembers.size() > 0) {
            params.addBodyParameter("source_members", new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create().toJson(sourceMembers));
        }
        if (!TextUtils.isEmpty(sourceProId)) {
            params.addBodyParameter("source_pro_id", sourceProId); //加入的数据源,多个用逗号隔开，如 2,3,4
        }
        CommonHttpRequest.commonRequest(context, httpUrl, SourceMemberProManager.class, false, params, true, callBack);
    }


    /**
     * 移除数据源
     *
     * @param context
     * @param groupId   项目组、班组id
     * @param classType 组类型
     * @param uid       成员id
     * @param pid       项目id
     * @param callBack
     */
    public static void removeSingleSource(final Activity context, String groupId, String classType, String uid, String pid,
                                          final CommonHttpRequest.CommonRequestCallBack callBack) {
        String httpUrl = NetWorkRequest.REMOVE_SOURCE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("pid", pid);
        CommonHttpRequest.commonRequest(context, httpUrl, BaseNetNewBean.class, false, params, true, callBack);
    }

    /**
     * 检查发消息的单聊信息是否在聊聊的列表中，如果不存在则创建一条新的消息，如果存在则直接return出去
     * 发起单聊 储存消息到聊聊列表
     *
     * @param context
     * @param receiverGroupList 单聊信息
     */
    public static void saveSendingSingeChat(final Activity context, ArrayList<GroupDiscussionInfo> receiverGroupList) {
        if (receiverGroupList == null || receiverGroupList.size() == 0) {
            return;
        }
        for (GroupDiscussionInfo groupDiscussionInfo : receiverGroupList) {
            ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and group_id = ? and class_type = ?",
                    UclientApplication.getUid(), groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type()).find(GroupDiscussionInfo.class);
            if (list == null || list.size() == 0) {
                if (groupDiscussionInfo.getMembers_head_pic() != null && groupDiscussionInfo.getMembers_head_pic().size() > 0) {
                    groupDiscussionInfo.setMembers_head_pic_json(new Gson().toJson(groupDiscussionInfo.getMembers_head_pic()));
                }
                groupDiscussionInfo.save();
            }
        }
    }

    /**
     * 清空活动，招聘，工作消息未读数
     *
     * @param groupDiscussionInfo
     */
    public static void clearWorkRecruitActivityMessageUnreadCount(GroupDiscussionInfo groupDiscussionInfo) {
        if (groupDiscussionInfo.getUnread_msg_count() > 0) {
            ContentValues values = new ContentValues();
            values.put("at_message", ""); //设置@我的消息
            values.put("unread_msg_count", 0); //设置消息未读数为空
            LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ?  and message_uid = ?", groupDiscussionInfo.getGroup_id(), UclientApplication.getUid());
        }
    }


    /**
     * 清空组的消息未读数
     *
     * @param activity
     * @param groupDiscussionInfo
     */
    public static void clearUnreadMessageCount(Activity activity, GroupDiscussionInfo groupDiscussionInfo) {
        if (groupDiscussionInfo.getUnread_msg_count() > 0) {
            //更新聊聊和首页的未读数为零
            setGroupChatLastMessageInfo(activity, "", 0, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type(), null);
        }
        NewMsgActivity.actionStart(activity, groupDiscussionInfo);
    }

    /**
     * 清空本地数据库工作消息未读数
     *
     * @param chatMainInfo
     */
    public static void cleaWorkMessageCount(ChatMainInfo chatMainInfo) {
        //更新聊聊未读数为零
        if (chatMainInfo != null && chatMainInfo.getWork_message_num() > 0) {
            //清空首页未读工作消息数
            chatMainInfo.setWork_message_num(0);
            chatMainInfo.saveOrUpdate("message_uid = ?", UclientApplication.getUid());
            ContentValues values = new ContentValues();
            values.put("work_message_num", 0);
            LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ?  and message_uid = ?", chatMainInfo.getGroup_info().getGroup_id(),
                    chatMainInfo.getGroup_info().getClass_type(), UclientApplication.getUid());
        }
    }


    public static void deleteLocalGroupInfo(String group_id, String class_type) {
        LitePal.deleteAll(GroupDiscussionInfo.class, "group_id = ? and class_type = ? and message_uid = ?", group_id, class_type, UclientApplication.getUid());
    }

    /**
     * 设置组的@信息
     *
     * @param context
     * @param atMessage
     * @param groupId
     * @param classType
     */
    public static void setGroupChatLastMessageInfo(Activity context, String atMessage, int unreadMsgCount, String groupId, String classType, MessageBean messageBean) {
//        LUtils.e("开始写入数据");
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        //修改首页未读信息
        if (chatMainInfo != null && !TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            Gson gson = new Gson();
            GroupDiscussionInfo groupInfo = gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
            if (groupInfo != null && groupInfo.getGroup_id().equals(groupId) && groupInfo.getClass_type().equals(classType)) {
                if (unreadMsgCount != -1) {
                    //自己发送的签到，日志，安全等，不需要处理未读数
                    groupInfo.setUnread_msg_count(unreadMsgCount); //设置消息未读数
                }
                chatMainInfo.setGroup_info(groupInfo);
                chatMainInfo.setGroup_info_json(gson.toJson(groupInfo));
                chatMainInfo.updateAll("message_uid = ?", UclientApplication.getUid());
            }
        }
        ContentValues values = new ContentValues();
        values.put("at_message", TextUtils.isEmpty(atMessage) ? "" : atMessage); //设置@我的消息
        //自己发送的签到，日志，安全等，不需要处理未读数
        if (unreadMsgCount != -1) {
            values.put("unread_msg_count", unreadMsgCount); //设置消息未读数为空
        }
        if (messageBean != null) {
            values.put("send_time", messageBean.getSend_time());
            values.put("sort_time", messageBean.getSend_time());
            values.put("msg_sender", messageBean.getMsg_sender());
            values.put("msg_text", MessageUtils.getMsg_Text(messageBean)); //设置消息未读数为空
            values.put("real_name", messageBean.getUser_info() == null ? "" : MessageUtils.getRealName(messageBean.getMsg_type(), messageBean.getUser_info().getReal_name()));
        }
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ?  and message_uid = ?", groupId, classType, UclientApplication.getUid());
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
        LUtils.e("写入数据完毕");
    }


    /**
     * 点击清空聊天消息需要调用的方法
     *
     * @param context
     * @param groupId
     * @param classType
     */
    public static void clearChatListMessage(Activity context, String groupId, String classType) {
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        //修改首页未读信息
        if (chatMainInfo != null && !TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            Gson gson = new Gson();
            GroupDiscussionInfo groupInfo = gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
            chatMainInfo.setGroup_info(groupInfo);
            if (groupInfo != null && groupInfo.getGroup_id().equals(groupId) && groupInfo.getClass_type().equals(classType)) {
                groupInfo.setUnread_msg_count(0); //设置消息未读数
                chatMainInfo.setGroup_info_json(gson.toJson(groupInfo));
                chatMainInfo.updateAll("message_uid = ?", UclientApplication.getUid());
            }
        }
        ContentValues values = new ContentValues();
        values.put("msg_text", "");//清空聊天消息
        values.put("msg_sender", ""); //清空消息发送人id
        values.put("real_name", "");//清空消息人发送名称
        values.put("send_time", "0");//清空消息发送时间
        LitePal.updateAll(GroupDiscussionInfo.class, values, "group_id = ? and class_type = ?  and message_uid = ?", groupId, classType, UclientApplication.getUid());
        //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
    }

    /**
     * 获取工作消息未读数
     */
    public static int getWorkMessageUnreadCount() {
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and group_id = ?", UclientApplication.getUid(),
                MessageType.WORK_MESSAGE_ID).find(GroupDiscussionInfo.class);
        if (list != null && list.size() > 0) {
            LUtils.e("count:" + list.size());
            GroupDiscussionInfo groupDiscussionInfo = list.get(0);
            //用原来的未读数量 加上收到的数量
            return groupDiscussionInfo.getUnread_msg_count();
        }
        return 0;
    }


    /**
     * 获取聊聊列表消息原未读数
     *
     * @param context
     * @param groupId
     * @param classType
     */
    public static int getGroupChatUnreadCount(Activity context, String groupId, String classType, int newMessageCount) {
        ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) LitePal.where("message_uid = ? and group_id = ? and class_type = ?",
                UclientApplication.getUid(), groupId, classType).find(GroupDiscussionInfo.class);
        if (list != null && !list.isEmpty() && list.size() == 1) {
            GroupDiscussionInfo groupDiscussionInfo = list.get(0);
            //用原来的未读数量 加上收到的数量
            int totalUnReadCount = groupDiscussionInfo.getUnread_msg_count() + newMessageCount;
            updateMainGroupUnreadCount(context, groupId, classType, totalUnReadCount);
            return totalUnReadCount;
        }
        return 0;
    }

    /**
     * 修改主页工作消息 未读消息数
     *
     * @param context
     * @param groupId
     * @param classType
     * @param unreadCount
     */
    public static void updateMainGroupUnreadCount(Activity context, String groupId, String classType, int unreadCount) {
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        //修改首页未读信息
        if (chatMainInfo != null && !TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            Gson gson = new Gson();
            GroupDiscussionInfo groupInfo = gson.fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
            chatMainInfo.setGroup_info(groupInfo);
            if (groupInfo != null && groupInfo.getGroup_id().equals(groupId) && groupInfo.getClass_type().equals(classType)) {
                groupInfo.setUnread_msg_count(groupInfo.getUnread_msg_count() + unreadCount); //设置消息未读数
                chatMainInfo.setGroup_info_json(gson.toJson(groupInfo));
                chatMainInfo.updateAll("message_uid = ?", UclientApplication.getUid());
            }
        }
    }

    /**
     * 修改主页工作回复 未读消息数
     *
     * @param context
     * @param groupId
     * @param classType
     */
    public static void updateMainGroupWorkReplyCount(Context context, String groupId, String classType) {
        if (TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
            return;
        }
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        if (TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            return;
        }
        GroupDiscussionInfo groupDiscussionInfo = new Gson().fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
        if (groupDiscussionInfo == null) {
            return;
        }
        if (groupId.equals(groupDiscussionInfo.getGroup_id()) && classType.equals(groupDiscussionInfo.getClass_type()) &&
                chatMainInfo.getMessage_uid().equals(UclientApplication.getUid())) { //只有判断这三个值相同才确定是当前首页的类
            chatMainInfo.setWork_message_num(chatMainInfo.getWork_message_num() + 1);
            chatMainInfo.saveOrUpdate("message_uid = ?", UclientApplication.getUid());
            //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
            LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
        }
    }

    /**
     * 清空主页工作回复 未读消息数
     *
     * @param context
     * @param groupId
     * @param classType
     */
    public static void clearMainGroupWorkReplyCount(Context context, String groupId, String classType) {
        if (TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
            return;
        }
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        if (TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            return;
        }
        GroupDiscussionInfo groupDiscussionInfo = new Gson().fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
        if (groupDiscussionInfo == null) {
            return;
        }
        if (groupId.equals(groupDiscussionInfo.getGroup_id()) && classType.equals(groupDiscussionInfo.getClass_type()) &&
                chatMainInfo.getMessage_uid().equals(UclientApplication.getUid())) { //只有判断这三个值相同才确定是当前首页的类
            chatMainInfo.setWork_message_num(0);
            chatMainInfo.saveOrUpdate("message_uid = ?", UclientApplication.getUid());
            //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
            LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
        }
    }

    /**
     * 修改主要模块未读小红点数
     *
     * @param context
     * @param groupId
     * @param classType
     * @param msgType
     */
    public static void updateMainModuleCount(Context context, String groupId, String classType, String msgType) {
        if (TextUtils.isEmpty(msgType) || TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
            return;
        }
        ChatMainInfo chatMainInfo = LitePal.findFirst(ChatMainInfo.class);
        if (TextUtils.isEmpty(chatMainInfo.getGroup_info_json())) {
            return;
        }
        GroupDiscussionInfo groupDiscussionInfo = new Gson().fromJson(chatMainInfo.getGroup_info_json(), GroupDiscussionInfo.class);
        if (groupDiscussionInfo == null) {
            return;
        }
        GroupDiscussionInfo localChatListGroup = MessageUtil.getLocalSingleGroupChatInfo(groupId, classType);
        if (groupId.equals(groupDiscussionInfo.getGroup_id()) && classType.equals(groupDiscussionInfo.getClass_type()) &&
                chatMainInfo.getMessage_uid().equals(UclientApplication.getUid())) { //只有判断这三个值相同才确定是当前首页的类
            switch (msgType) {
                case MessageType.MSG_QUALITY_STRING: //质量
                    chatMainInfo.setUnread_quality_count(1);
                    localChatListGroup.setUnread_quality_count(1);
                    break;
                case MessageType.MSG_SAFE_STRING: //安全
                    chatMainInfo.setUnread_safe_count(1);
                    localChatListGroup.setUnread_safe_count(1);
                    break;
                case MessageType.MSG_INSPECT_STRING: //检查
                    chatMainInfo.setUnread_inspect_count(1);
                    localChatListGroup.setUnread_inspect_count(1);
                    break;
                case MessageType.MSG_TASK_STRING: //任务
                    chatMainInfo.setUnread_task_count(1);
                    localChatListGroup.setUnread_task_count(1);
                    break;
                case MessageType.MSG_NOTICE_STRING: //通知
                    chatMainInfo.setUnread_notice_count(1);
                    localChatListGroup.setUnread_notice_count(1);
                    break;
                case MessageType.MSG_METTING_STRING: //会议
                    chatMainInfo.setUnread_meeting_count(1);
                    localChatListGroup.setUnread_meeting_count(1);
                    break;
                case MessageType.MSG_APPROVAL_STRING: //审批
                    chatMainInfo.setUnread_approval_count(1);
                    localChatListGroup.setUnread_approval_count(1);
                    break;
                case MessageType.MSG_LOG_STRING: //日志
                    chatMainInfo.setUnread_log_count(1);
                    localChatListGroup.setUnread_log_count(1);
                    break;
                case MessageType.MSG_GROUP_BILL: //出勤公式
                    chatMainInfo.setUnread_billRecord_count(1);
                    localChatListGroup.setUnread_billRecord_count(1);
                    break;
            }
            LUtils.e("修改首页小红点");
            chatMainInfo.save();
            localChatListGroup.save();
            //我们在这里发送一条广播通知消息列表，通知聊聊信息已经发生了改变，需要他重新去获取一下列表数据
            LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST));
        }
    }
}
