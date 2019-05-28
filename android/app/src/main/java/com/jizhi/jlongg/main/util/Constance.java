package com.jizhi.jlongg.main.util;

import android.annotation.SuppressLint;
import android.os.Environment;

public class Constance {

    public static final String APP_ID = "wx0d7055be43182b5e";
    public static final String APP_SECRET = "d4624c36b6795d1d99dcf0547af5443d";

    @SuppressLint("SdCardPath")
    public final static String path = "/data/data/com.jizhi.jlongg/databases";
    public static final String JLONGG = "jlongg";
    public static final String WOKRBILL = "workbillhistory";
    public static final String ATALL = "atAll";
    public final static String PROVICECITY = "proviceCity"; //省、市
    public static final String ACTION_MESSAGE_WXPAY_SUCCESS = "action_message_wxpay_success";
    public static final String ACTION_MESSAGE_WXPAY_FAIL = "action_message_wxpay_fail";
    public static final String IS_BUYED = "is_buyed"; //组id
    public static final String GROUP_CAT_ID = "group_cat_id";
    public static final String GROUP_CAT_NAME = "group_cat_name";
    public static final String TEAM_CAT_ID = "team_cat_id";
    public static final String TEAM_CAT_NAME = "team_cat_name";
    public final static String FILTER_STATE = "filter_state";
    public final static int REQUEST_WEB = 0X40;
    public static final String CLOUD_USE_SPACE = "cloud_use_space"; //云盘已用空间
    public static final String CLOUD_TOTAL_SPACE = "cloud_total_space"; //云盘总空间
    public static final String SEARCH_CHECK_STATE = "SEARCH_CHECK_STATE"; //组id
    public static final String NAVIGATION_ID = "NAVIGATION_ID";
    public static final String FILE_PARENT_ID = "file_parent_id"; //文件父id
    public static final String FILE_PARENT_NAME = "file_parent_name"; //文件父名称
    public static final String MOVE_FILES_JSON_OBJECT = "move_files_json_object"; //移动文件的ids
    public static final String MOVE_FILES_IDS = "move_files_ids"; //移动文件的ids
    public static final String ACTION_GET_WX_USERINFO = "ACTION_GET_WX_USERINFO";
    public static final String SEND_HTML5_COMMENT = "send_html5_comment";
    public static final String SELECTED_IDS = "selected_ids"; //组id
    public static final String IS_FROM_BATCH = "IS_FROM_BATCH"; //云盘是否已过期
    public static final String IS_FROM_SERVER_ORDER = "IS_FROM_SERVER_ORDER"; //云盘是否已过期
    public static final String TASK_STATUS = "TASK_STATUS";
    //隐藏新生活红点
    public static final String HIDE_NEWLIFE_RED_DOT = "hide_newlife_red_dot";
    //工人记工
    public static final String ACCOUNT_WORKER_HISTORT = "account_worker_history";
    //工头记工
    public static final String ACCOUNT_FORMAN_HISTORT = "account_forman_history";
    //
    public static final String CHAT_SHAREPREFRENCES = "chat_shareprefrens";
    //增加发送中消息
    public static final String ADD_SENDING_MSG_ACTION = "check_msg_sendin_state_action";
    //增加发送失败消息
    public static final String ADD_SENDSUCCESS_MSG_ACTION = "check_msg_sendsuccess_state_action";

    //记账信息发生了变化调用这个广播
    public static final String ACCOUNT_INFO_CHANGE = "ACCOUNT_INFO_CHANGE";


    public static final String IS_ACTIVE = "IS_ACTIVE";
    /**
     * 头像
     */
    public static final String HEAD_IMAGE = "HEAD_IMAGE";
    /**
     * 聊天组头像
     */
    public static final String GROUP_HEAD_IMAGE = "GROUP_HEAD_IMAGE";
    /**
     * 电话号码
     */
    public static final String TELEPHONE = "TELEPHONE";
    /**
     * 用户名
     */
    public static final String USERNAME = "USERNAME";
    public static final String ADDRESS = "address";
    public static final String LOGINVER = "LOGINVER";
    /**
     * 用户昵称
     */
    public static final String NICKNAME = "NICKNAME";
    public static final String BILLID = "billid";
    public static final String COMPANY = "COMPANY";
    public static final String CONTEXT = "CONTEXT";


    public static final String CHOOSE_MEMBER_TYPE = "choose_member_type";

    public static final String POSITION = "position";
    public final static String STATE = "state";
    public static final String IS_HAS_REALNAME = "IS_HAS_REALNAME";
    /**
     * 用户名
     */
    /**
     * 自己发送消息类型
     */
    public final static String MSG_TYPE = "msg_type";
    public final static String MSG = "msg_entity";
    public final static String MSG_ID = "msg_id";
    /**
     * 发布项目选择工友请求码
     */
    public final static int RESULTWORKERS = 0X01;
    public final static int REQUESTWORKERS = 0X02;
    public final static int REQUEST_ACCOUNT = 0X03;
    public final static int REQUEST = 0X05;
    public final static int REQUEST_LOCAL = 0X88;
    public final static int REQUEST_CAPTURE = 0X124;
    public final static int INFOMATION = 0X10;
    public final static int RESULTENEVALUATION = 0X13;
    public final static int RESULTCODE_NEAYBYADDE = 0X16;
    public final static int SUCCESS = 0X18;
    public final static int ADD_SUCCESS = 0X20;
    public final static int DELETE_SUCCESS = 0X21;
    public final static int REMARK_SUCCESS = 0X23;
    public final static int EDITOR_PROJECT_SUCCESS = 0X24;
    public final static int LOADING = 0X25;
    public final static int LOGIN_SUCCESS = 0X26;
    public final static int EXIT_LOGIN = 0X28;
    public final static int REQUEST_ADD = 0X29;
    public final static int REQUEST_LOGIN = 0X30;
    public final static int REQUEST_PROJECT = 0X31;
    public final static int RETURN = 0X32;
    public final static int DISPOSEATTEND_RESULTCODE = 0X34;
    public final static int ACCOUNT_RESULTCODE = 0X35;
    public final static int ACCOUNT_DELETE = 0X84;
    public final static int CONST_REQUESTCODE = 0X35;
    public final static int PHOTO_REQUEST_AlBUM = 0X36;
    public final static int SWITCH_ROLER = 0X37;
    public final static int REQUESTCODE_CHANGFSYNCHOBJECT = 0X38;
    public final static int RESULTCODE_CHANGFSYNCHOBJECT = 0X39;
    public final static int PERSON = 0X40;
    public final static int REFRESH = 0X41;
    public final static int REQUESTCODE_SINGLECHAT = 0X42;
    public final static int CLICK_SINGLECHAT = 0X43;
    public final static int RESULTCODE_DELETEPEOPLE = 0X45;
    public final static int REQUESTCODE_SYNCHPRO = 0X46;
    public final static int SYNC_SUCCESS = 0X47;
    public final static int REQUESTCODE_ADDCONTATS = 0X48;
    public final static int RESULTCODE_ADDCONTATS = 0X49;
    public final static int REQUESTCODE_SELECTCITY = 0X50;
    public final static int REQUESTCODE_START = 0X51;
    public final static int RESULTCODE_FINISH = 0X52;
    public final static int CHECKSELFPERMISSION = 0X53;
    public final static int ACCOUNT_UPDATE = 0X36;
    public final static int REQUESTCODE_LOCATION = 0X54;
    public final static int REQUESTCODE_MSGEDIT = 0X50;
    public final static int REQUESTCODE_EDITPROJECT = 0X51;
    public final static int EDITOR_SUCCESS = 0X58;
    public final static int SWITCH_MANAMGER = 0X59;
    public final static int SALARYMODESETTING_REQUESTCODE = 0X60;
    public final static int SALARYMODESETTING_RESULTCODE = 0X61;
    public final static int CLICK_GROUP_CHAT = 0X62;
    public final static int SET_PRO_NAME = 0X63;
    public static final int MAIN_GAGE_ONE = 0X64;
    public final static int REQUESTCODE_ALLWORKCOMPANT = 0X66;
    public final static int RESULTCODE_ALLWORKCOMPANT = 0X67;
    public final static int UPDATE_TEL_SUCCESS = 0X68;
    public static final int PUBLICSH_SUCCESS = 0X69;
    public static final int SELECTED_PRINCIPAL = 0X70;
    public static final int SELECTED_ACTOR = 0X71;
    public static final int UPDATE_SUCCESS = 0X72;
    public static final int CANCEL_MOVE_FILE = 0X73;
    public static final int REQUEST_IMAGE = 0X74;
    public static final int DEGRADE = 0X75;
    public static final int requestCode_msg = 0X76;
    public static final int FIND_WORKER_CALLBACK = 0X77;
    public static final int SCAN_CODE_JUMP_DEVICE = 0X78;
    public static final int IS_INFO_YES = 0X79;
    public static final int DELETE_MEMBER = 0X81; //删除成员
    public static final int DELETE_GROUP_CHAT_MEMBER = 0X82; //删除群聊成员
    public final static int UPGRADE = 0X83; //升级为项目组
    public static final int GET_PROJECT_INFO = 0X84;
    public static final int REQUEST_PAY = 0X85;
    public static final int ADD_SOURCE_DATA_MEMBER = 0X86; //添加数据来源人
    public static final int BIND_ACCOUNT_SUCCESS = 0X87;
    public static final int BALANCE_WITHDRAW_SUCCESS = 0X88;
    public final static int SAVE_BATCH_ACCOUNT = 0X89;
    public final static int SCAN_MEETING_SUCCESS = 0X91;
    public final static int DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT = 0X92;
    public final static int DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST = 0X93;
    public final static int DELETE_OR_UPDATE_OR_CREATE_CHECK_PLAN = 0X94;
    public final static int SELECTED_CALLBACK = 0X95;
    public final static int SEND_ADD_FRIEND_SUCCESS = 0X97;
    public final static int CHANGE_ACCOUNT_SHOW_TYPE = 0X98;
    public final static int SELECTE_PROJECT = 0X99;
    public final static int MANUAL_ADD_OR_EDITOR_PERSON = 0X100;
    public final static int SELECTE_PROXYER = 0X103;
    public final static int SET_CITY_INFO_SUCCESS = 0X105;
    public final static int FLUSH_NICKNAME = 0X106;//刷新昵称
    public final static int GO_MAIN_ACTIVITY = 0X107;//去主页
    public final static int OPEN_WECHAT_WERVICE = 0X108;//开通微信服务
    public final static int BIND_WECHAT = 0X109;//开通微信服务
    public static final int WAY_CREATE_GROUP_CHAT = 0X14; //创建群聊、班组、项目组
    public static final int CANCEL_SELECTE = 0x109; //取消选中
    public final static int REQUESTCODE_ADD_SUB_PRONAME = 0X110;
    public final static int RESULTCODE_ADD_SUB_PRONAME = 0X111;
    public final static int REFRESH_CONFIRM_ACCOUNT_STATUS = 0x112;
    public final static int EVALUATE_SUCCESS = 0x113;

    public final static String SET_INDEX = "set_index";
    /**
     * Intent 每次传递的对象变量名
     */
    public static final String TASK_ID = "task_id";
    public static final String GINFO = "ginfo";
    public static final String BEAN_CONSTANCE = "BEAN"; //Intent 每次传递的对象变量名
    public static final String IS_ENTER_GROUP = "is_enter_group"; //Intent 每次传递的对象变量名

    public static final String BEAN_CONSTANCE1 = "BEAN1"; //Intent 每次传递的对象变量名
    public static final String TITLE = "title"; //标题
    /**
     * Intent 每次传递的Boolean类型
     */
    public static final String BEAN_BOOLEAN = "BOOLEAN";
    /**
     * Intent 每次传递的Boolean类型
     */
    public static final String BEAN_BOOLEAN1 = "BOOLEAN1";
    /**
     * Intent 每次传递的Boolean类型,记多人
     */
    public static final String BEAN_MORE_ACCOUNT = "BOOLEAN_ACCOUNT_MORE";
    /**
     * Intent 每次传递的String
     */
    public static final String BEAN_STRING = "STRING";
    public static final String COMMENT_NAME = "comment_name";
    /**
     * 聊天室名称
     */
    public static final String GROUP_NAME = "group_name";

    /**
     * 已存在的电话号码 用逗号隔开
     */
    public static final String EXIST_TELPHONES = "exist_telphones";

    public static final String SWITCH_ROLER_BROADCAST = "switch_roler_broadcast";
    /**
     * 组id
     */
    public static final String GROUP_ID = "group_id";
    public static final String GROUP = "group";
    public static final String TEAM = "team";
    public static final String CLASSTYPE = "classType";
    public static final String TEAM_ID = "team_id";
    public static final String PRONAME = "pro_name";
    public static final String ISMSGBILL = "isMsgBill";
    public static final String INSPLAN_ID = "insPlan_id"; //检查计划id
    public static final String PRO_ID = "pro_id"; //检查项id
    /**
     * Intent 每次传递的File
     */
    public static final String BEAN_FILE = "FILE";
    /**
     * Intent 每次传递的date
     */
    public static final String DATE = "DATE";

    /**
     * Intent 每次传递的int类型
     */
    public static final String BEAN_INT = "INT";
    /**
     * 分页字段
     */
    public static final String PAGE = "pg";

    public static final String PAGESIZE = "pagesize";

    /**
     * 分页显示最大数据
     */
    public static final int PAGE_SIZE = 20;
    public static final int PAGE_SIZE30 = 30;
    /**
     * 分页显示最大数据
     */
    public static final int EVALUATION_PAGE_SIZE = 5;
    public static final String JOIN_STATUS = "JOIN_STATUS";
    public static final String IS_MY_GROUP_INFO = "is_my_group_info"; //Intent 每次传递的int类型
    public static final String MEMBER_NUMBER = "member_num"; //Intent 添加类型
    /**
     * 年
     */
    public static final String YEAR = "year";

    /**
     * 月
     */
    public static final String MONTH = "month";

    /**
     * 项目id
     */
    public static final String PID = "pid";

    /**
     * 是否关闭
     */
    public static final String IS_CLOSED = "is_closed";
    /**
     * 是否是创建者
     */
    public static final String IS_CREATOR = "is_creator";
    /**
     * 是否是创建者
     */
    public static final String IS_ADMIN = "is_admin";

    /**
     * 项目名称
     */
    public static final String PROJECTNAME = "projectName";
    public static final String WORKNAME = "WORKNAME";
    /**
     * 角色
     */
    public static final String ROLE = "role";
    public static final String ID = "id";
    /** 角色扮演 */
    /**
     * 工友
     */
    public static final String ROLETYPE_WORKER = "1";
    /**
     * 工头
     */
    public static final String ROLETYPE_FM = "2";
    /**
     * 旧时间
     */
    public static final String OLDTIME = "OLDTIME";
    /**
     * 当前mei有对应角色
     */
    public static final int IS_INFO_NO = 0;
    public static final String SUCCES_S = "success";
    /**
     * 点工
     */
    public static final String HOUR_WORKER_GUIDE = "HOUR_WORKER_GUIDE";
    /**
     * 包工
     */
    public static final String CONSTRACTOR_GUIDE = "CONSTRACTOR_GUIDE";
    /**
     * 借支
     */
    public static final String BORROWING_GUIDE = "BORROWING_GUIDE";
    /**
     * 总包
     */
    public static final String MAIN_CONTRACTOR = "3";

    public enum enum_parameter {
        PHONE, TOKEN, NOVALUE, ISLOGIN, ROLETYPE, IS_INFO, LIITLEWORK, CONTRACTOR, PEN, HASREALNAME;
    }

    public static final int RIGISTR_ORIGIN_PROJECTTYPE = 1;
    public static final int RIGISTR_ORIGIN_WORKERTYPE = 2;
    public static final String REQUEST_HEAD = "Authorization";
    /**
     * Intent 每次传递的数组变量名
     */
    public static final String BEAN_ARRAY = "ARRAY";
    /**
     * 点击记工清单人
     */
    public static final int TYPE_PERSON = 1;
    /**
     * 点击记工清单项目
     */
    public static final int TYPE_PROJECT = 2;
    /**
     * 记工清单详情
     */
    public static final int TYPE_DETAIL = 3;
    /**
     * 记工清单详情
     */
    public static final int STARTTIME = 20140101;
//    public static final String SUPPLEMENT_NAME = "supplement_name";
    public static final String VOICEPATH = Environment.getExternalStorageDirectory() + "/nickming_recorder_audios";
    public static final int CREATE_PRO_ADD_MEMBER = 1; //创建项目添加成员
    public static final int DELETE_GROUP_MEMBER = 5; //删除班組成員
    public static final int DELETE_SOURCE_DATA_MEMBER = 0X102; //删除数据来源人
    public static final int DELETE_TEAM_MEMBER = 7; //删除项目组成員
    public static final String DELETE_MEMBER_TYPE = "DELETE_MEMBER_TYPE"; //Intent 添加类型
    public static final String DELETE_UID = "DELETE_UID"; //Intent 添加类型
    public static final String sign_id = "sign_id"; //组id
    public static final String UID = "uid";//token
    public static final String ACCOUNT_TYPE = "accounts_type";//记账类型
    public static final String HOME = "home";  //家乡
    public static final String EXPECTEDWORK = "OLDTIME"; //期望工作地
    public static final String GROUP_CHAT_ID = "chatId"; //消息id
    public static final String STARTTIME_STRING = "start_time"; //期望工作地
    public static final String ENDTIME_STRING = "end_time"; //消息id


    /**
     * 当前有对应角色
     */

    //  1、登陆验证码    2、修改手机号验证码  3、合伙人提现验证码   4、注销账户
    public static final String LOGIN_APP_CODE = "1";
    public static final String UPDATE_TELPHONE_CODE = "2";
    public static final String CASH = "3";
    public static final String UN_SUBSCRIBE = "4";
    public static final int FINISH_WEBVIEW = 0X100;
    public static final String CONNECTION = "connection";
    public static final String CONSTRACTOR_TYPE = "constractor_type";
    public static final String HEAD = "#topdisplay=1";


    /**
     * URL scheme jigongjia://
     */
    public static final String SCHEME = "jigongjia://h5/";
    /**
     * 完整的url scheme地址
     */
    public static final String COMPLETE_SCHEME = "com.jigongjia.complete_scheme";
    public static final String URL_JUMP_ACTION = "com.jigongjia.jump.action";

    public static class SCHEME_TYPE {

        public static final String MY = Constance.SCHEME + "my";

        public static final String JOB = Constance.SCHEME + "job";

        public static final String FIND = Constance.SCHEME + "find";


    }
}

