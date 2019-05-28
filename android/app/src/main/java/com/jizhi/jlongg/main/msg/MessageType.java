package com.jizhi.jlongg.main.msg;

/**
 * CName:消息类型
 * User: hcs
 * Date: 2016-08-27
 * Time: 15:54
 */
public class MessageType {
    public static final String CLASS_TYPE = "class_type";
    public static final String MSG_TYPE = "msg_type";
    public static final String GROUP_ID = "group_id";
    public static final String MSG_ID = "msg_id";
    public static final String MSG_TEXT = "msg_text";
    public static final String TYPE = "type";


    /**
     * 质量消息
     */
    public static final int MSG_QUALITY_INT = 1;
    public static final String MSG_QUALITY_STRING = "quality";
    /**
     * 安全消息
     */
    public static final int MSG_SAFE_INT = 2;
    public static final String MSG_SAFE_STRING = "safe";
    /**
     * 任务消息
     */
    public static final int MSG_TASK_INT = 3;
    public static final String MSG_TASK_STRING = "task";
    /**
     * 日志消息
     */
    public static final int MSG_LOG_INT = 4;
    public static final String MSG_LOG_STRING = "log";
    /**
     * 会议消息
     */
    public static final int MSG_METTING_INT = 5;
    public static final String MSG_METTING_STRING = "meeting";

    /**
     * 审批消息
     */
    public static final int MSG_APPROVAL_INT = 6;
    public static final String MSG_APPROVAL_STRING = "approval";
    /**
     * 检查消息
     */
    public static final int MSG_INSPECT_INT = 7;
    public static final String MSG_INSPECT_STRING = "inspect";
    /**
     * 签到
     */
    public static final int MSG_SIGNIN_INT = 8;
    public static final String MSG_SIGNIN_STRING = "signIn";
    /**
     * 通知消息
     */
    public static final int MSG_NOTICE_INT = 9;
    public static final String MSG_NOTICE_STRING = "notice";
    /**
     * 文字消息
     */
    public static final int MSG_TEXT_INT = 10;
    public static final String MSG_TEXT_STRING = "text";
    /**
     * 语音消息
     */
    public static final int MSG_VOICE_INT = 11;
    public static final String MSG_VOICE_STRING = "voice";
    /**
     * 图片消息
     */
    public static final int MSG_PIC_INT = 12;
    public static final String MSG_PIC_STRING = "pic";

    /**
     * 成员加入消息
     */
    public static final int MSG_MENBERJOIN_INT = 13;
    public static final String MSG_MENBERJOIN_TEXT = "memberjoin";
    /**
     * 邀请朋友
     */
    public static final int ADD_GROUP_FRIEND_INT = 14;
    public static final String ADD_GROUP_FRIEND_TEXT = "addGroupFriend";

    /**
     * 找工作
     */
    public static final int MSG_OTHER_INT = 15;
    /**
     * 撤回
     */
    public static final String MSG_RECALL_STRING = "recall";
    public static final int MSG_RECALL_INT = 16;
    /**
     * 活动消息
     */
    public static final String MSG_ACTIVITY_STRING = "activity";
    public static final int MSG_ACTIVITY_INT = 17;
    /**
     * 找工作消息
     */
    public static final String MSG_FINDWORK_STRING = "proDetail";
    public static final int MSG_FINDWORK_INT = 18;
    /**
     * 贴子送积分消息
     */
    public static final String MSG_PRESENT_STRING = "present_integral";
    public static final int MSG_PRESENT_INT = 19;
    /**
     * 加入地方群通知
     */
    public static final String LOCAL_GROUP_CHAT_STRING = "local_group_chat";
    public static final int LOCAL_GROUP_CHAT_INT = 20;
    /**
     * 加入工种群通知
     */
    public static final String WORK_GROUP_CHAT_STRING = "work_group_chat";
    public static final int WORK_GROUP_CHAT_INT = 21;
    /**
     * 名片
     */
    public static final int MSG_POSTCARD_INT = 22;
    public static final String MSG_POSTCARD_STRING = "postcard";

    /**
     * 链接
     */
    public static final int MSG_LINK_INT = 23;
    public static final String MSG_LINK_STRING = "link";
    /**
     * 新招工信息
     */
    public static final int RECTUITMENT_INT = 24;
    public static final String RECTUITMENT_STRING = "recruitment";

    /**
     * 4.0.1找工作临时消息
     */
    public static final String MSG_FINDWORK_TEMP_STRING = "proDetail_temp";
    public static final int MSG_FINDWORK_TEMP_INT = 25;
    /**
     * 认证消息
     */
    public static final String MSG_AUTH_STRING = "auth";
    public static final int MSG_AUTH_INT = 26;

    /**
     * 新消息
     */
    public static final int MSG_NEW_INT = 27;
    /**
     * 新消息
     */
    public static final String MSG_NEW_STRING = "new_msg";

    /**
     * 出勤公式小红点
     */
    public static final String MSG_GROUP_BILL = "group_bill";

    /**
     * 帖子违规
     */
    public static final String MSG_POST_CENSOR_STRING = "post_censor";
    public static final int MSG_POST_CENSO_INT = 28;

    public static final String MSG_FIND_RED = "findred";


    public static final String TRANSFER_OF_MANAGEMENT = "transfer_of_management"; //转让群管理员
    public static final String MSG_CLOUD = "oss"; //云盘


    public static final String JOIN = "join"; //加入班组、项目组
    public static final String REMOVE = "remove"; //移除班组、项目组
    public static final String CLOSE = "close"; //关闭班组、项目组
    public static final String REOPEN = "reopen"; //重新班组、项目组
    public static final String SWITCH_GROUP = "switchgroup"; //转让管理权
    public static final String DEL_MEMBER = "delmember"; //被移除群
    public static final String UPGRADE_GROUP = "upgradegroupchat"; //群聊升级成班组

    public static final String DISMISS_GROUP = "dismissGroup"; //解散群聊

    public static final String EVALUATE = "evaluate"; //评价
    public static final String INTEGRAL = "integral"; //积分帖子


    /**
     * 吉工家可显示
     * 'demandSyncProject',//要求同步项目
     * 'agreeSyncProject',//同意同步项目
     * 'refuseSyncProject',//拒绝同步项目
     * 'syncBillToYou',//对你同步记工（对你同步项目）
     * 'agreeSyncBill',//同意同步记工
     * 'demandSyncBill',//要求同步记工
     * 'refuseSyncBill',//决绝同步记工
     * 'cancellSyncProject',//取消同步项目（记工）
     * 'cancellSyncBill',//取消同步记账（记工记账）
     * <p>
     * 吉工宝可显示
     * 'syncProjectToYou',//对你同步项目(同步记工)
     * 'joinTeam',//加入现有项目组
     * 'createNewTeam',//创建新项目组
     */

    public static final String REQUIRE_SYNC_PROJECT = "demandSyncProject"; //要求同步项目
    public static final String AGREE_SYNC_PROJECT = "agreeSyncProject"; //同意同步项目
    public static final String RESUSE_SYNC_PROJECT = "refuseSyncProject"; //拒绝同步项目


    public static final String DEMAND_SYNC_BILL = "demandSyncBill"; //记工同步请求
    public static final String AGREE_SYNC_BILL = "agreeSyncBill"; //同意记工同步
    public static final String SYNC_BILL_TO_YOU = "syncBillToYou"; //对你同步记工（对你同步项目）

    public static final String REFUSE_SYNC_BILL = "refuseSyncBill"; //记工同步被拒
    public static final String CANCEL_SYNC_PROJECT = "cancellSyncProject"; //取消同步项目（记工）
    public static final String CANCEL_SYNC_BILL = "cancellSyncBill"; //取消同步记账（记工记账）


    public static final String JGB_SYNC_PROJECT_TO_YOU = "syncProjectToYou"; //对你同步项目(同步记工)
    public static final String JGB_JOIN_TEAM = "joinTeam"; //对你同步项目 加入已存在的项目组
    public static final String JGB_CREATE_NEW_TEAM = "createNewTeam"; //对你同步项目 创建新的项目组
    public static final String AGREE_SYNC_PROJECT_TO_YOU = "agreeSyncProjectToYou"; //对你同步项目 用户B将XXX项目1、XXX项目2 等项目的记工记账情况同步给你


//    public static final String AUTHPASS = "authpass"; //劳务认证审核已通过
//    public static final String AUTHFAIL = "authfail"; //劳务认证审核未通过
//    public static final String AUTHEXPIRED = "authexpired"; //劳务认证过期通知
//    public static final String AUTHDUE = "authdue"; //劳务认证临近到期通知
//    public static final String WORKERMIND = "workremind"; //新工作提醒


    public static final String WORK_MESSAGE_TYPE = "work"; //工作消息类型
    public static final String RECRUIT_MESSAGE_TYPE = "recruit"; //招聘消息类型
    public static final String ACTIVITY_MESSAGE_TYPE = "activity"; //活动消息类型
    public static final String NEW_FRIEND_MESSAGE = "friend"; //新好友

    public static final String NEW_FRIEND_MESSAGE_TYPE = "newFriends";
    public static final String WORK_REPLY = "reply"; //工作回复消息类型
    public static final String SET_AGENCY = "set_agency"; //设置代班长回复类型


    public static final String ADD_FRIEND_REDDOT_MESSAGE = "addGroupFriend"; //添加好友时推送的小红点信息


    public static final String WORK_MESSAGE_ID = "-1";
    public static final String ACTIVITY_MESSAGE_ID = "-2";
    public static final String RECRUIT_MESSAGE_ID = "-3";
    public static final String NEW_FRIEND_MESSAGE_ID = "-4";

    public static final String MESSAGE_TYPE_ADD_FRIEND = "addFriend";


    public static final String MESSAGE_TYPE_REPLY_SAFE = "reply_safe";
    public static final String MESSAGE_TYPE_REPLY_QUALITY = "reply_quality";
    public static final String MESSAGE_TYPE_REPLY_TASK = "reply_task";


}
