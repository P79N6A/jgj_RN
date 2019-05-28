package com.jizhi.jlongg.main.util;

/**
 * 功能: WebSocket 常量
 * 作者：Xuj
 * 时间: 2016年8月27日 15:20:40
 */
public class WebSocketConstance {


    public static final String GROUP_CHAT = "groupChat";//群聊类型
    public static final String TEAM = "team";//项目组类型
    public static final String GROUP = "group";//班组类型
    public static final String SINGLECHAT = "singleChat";//单聊类型


    public static final String LOGDEL = "logdel";
    public static final String ACTION_CHECK_INFO_UN_EXIST = "check_info_un_exist";//获取检查列表失败


    public static final String LOAD_CHAT_LIST = "load_chat_list";  //加载聊聊列表数据成功后的回调
    public static final String CANCEL_CHAT_MAIN_INDEX_SUCCESS = "cancel_chat_main_index_success";//取消首页调用http接口数据
    public static final String LOAD_CHAT_MAIN_HTTP_SUCCESS = "load_chat_main_index_success";//加载首页http接口数据成功后的回调
    public static final String LOAD_CHAT_MAIN_HTTP_ERROR = "load_chat_main_index_error";//加载首页http接口数据失败后的回调
    public static final String REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST = "refresh_local_database_main_index_and_chat_list"; //重新加载首页和聊聊列表本地数据
    public static final String REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST = "refresh_server_main_index_and_chat_list"; //调用Http重新加载首页数据  并且重新加载聊聊本地数据
    public static final String REFRESH_LOCAL_DATABASE_MAIN = "refresh_local_database_main_index"; //重新加载首页
    public static final String ACTION_UPDATEUSERINFO = "ACTION_UPDATEUSERINFO";//更新个人资料

    public static final String UPDATE_GROUP_PERSON_NAME_INCLUDE_MINE = "update_group_person_name"; //设置组的成员名称，包括自己的
    public static final String SHOW_GROUP_MESSAGE = "show_group_message"; //显示收到的消息
    public static final String FORWARD_SUCCESS = "forward_success"; //显示发送的转发消息
    public static final String CLOSE_DIALOG = "close_dialog";//关闭收到的推送消息
    public static final String SHOW_DIALOG = "show_dialog";//显示收到的推送消息
    public static final String CLEAR_MESSAGE = "clear_message"; //清空聊天消息
    public static final String requestMessage = "requestMessage"; //通知,安全,质量,日志 收到
    public static final String MSGREAD = "messageReaded"; //通知已读回执
    public static final String RECIVEMESSAGE = "reciveMessage";//reciveMessge接收别人发的
    public static final String OPEN_OR_HIDE_BOTTOM_MENU = "openirhidebottommenu";//打开关闭底部

    public static final String MESSAGE = "message";
    /**
     * 接收 / 已读 回执接口
     * 回执类型（readed 已读 / received 接收 ）
     */
    public static final String GET_CALLBACK_OPERATIONMESSAGE = "getCallBackOperationMessage";
    /**
     * 已读
     */
    public static final String READED = "readed";
    /**
     * 接收
     */
    public static final String RECEIVED = "received";
    /**
     * 消息撤回
     */
    public static final String RECALL = "recall";
    /**
     * 收到别人已读消息剩余数回执
     */
    public static final String MSGREADTOSENDER = "messageReadedToSender";
    /**
     * 自己发送的消息回执
     */
    public static final String SENDMESSAGE = "sendMessage";
    /**
     * 接收别人发送新消息
     */
    public static final String RECEIVEMESSAGE = "receiveMessage";
    /**
     * 消息撤回
     */
    public static final String RECALLMESSAGE = "recallMessage";
    /**
     * 离线消息列表
     */
    public static final String GET_OFFLINE_MESSAGE_LIST = "chat/get-offline-message-list";
    /**
     * 当有人添加我为好友时的小红点
     */
    public static final String RED_DOTMESSAGE = "reddotMessage";
    /**
     * socket重连成功
     */
    public static final String NETWORK_CONNECTION_SUCCESS = "network_connection_success";
    /**
     * 心跳包
     */
    public static final String ACTION_HEARTBEAT = "heartbeat";

    /**
     * 检测头像是否改变
     */
    public static final String CHECK_HEAD_ISCHANGE = "check_head_ischange";
    /**
     * 刷新记事本
     */
    public static final String FLUSH_NOTEBOOK = "flush_notebook";
    /**
     * 更新了个人资料
     */
    public static final String MODIFT_PERSON_INFO = "MODIFT_PERSON_INFO";
    /**
     * 分享成功
     */
    public static final String SHARE_SUCCESS = "share_success";
    /**
     * 消息发送失败
     */
    public static final String SEND_MSG_FAIL = "send_msg_fail";
    /**
     * 自己添加别人的特殊消息
     */
    public static final String FRIENDMESSAGETOSENDER = "friendMessageToSender";
}
