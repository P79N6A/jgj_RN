package com.jizhi.jlongg.network;

/**
 * Created by Administrator on 2017/1/7 0007.
 */

public class NetWorkRequest {


    public static final String HTTP_OR_HTTPS_REQUEST_HEAD = "http://";
    public static final String WEBSOCKET_HEAD = "ws://";

//    public static final String IP_ADDRESS = "http://api.test.jgjapp.cn/";
//    public static final String SERVER = "ws://api.test.jgjapp.cn/websocket";

    /**
     * 开发版
     */
//    public static final String API_DOMAIN_NEW = "napi.ex.yzgong.com/";//新的api域名
//    public static final String API_DOMAIN = "api.ex.yzgong.com/";//api域名
//    public static final String WEB_DOMAIN = "nm.ex.yzgong.com/"; //web域名
//    public static final String IP_ADDRESS = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN;
//    public static final String IP_ADDRESS_NEW = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN_NEW;
//    public static final String WEBURLS = HTTP_OR_HTTPS_REQUEST_HEAD + WEB_DOMAIN;
//    public static final String EXAPLETABLE = HTTP_OR_HTTPS_REQUEST_HEAD + "wx2.ex.yzgong.com/statistics/chart?class_type=team&sync_from=示例数据&tag_id=0&sync_id=17&pro_name=保利玫瑰花语&is_demo=1";
//    public static final String CDNURL = HTTP_OR_HTTPS_REQUEST_HEAD + "ex.cdn.yzgong.com/";
//    public static final String SERVER = WEBSOCKET_HEAD + "ws.ex.yzgong.com/websocket";


    /**
     * 测试版
     */
    public static final String EXAPLETABLE = HTTP_OR_HTTPS_REQUEST_HEAD + "wx2.test.jgjapp.com/statistics/chart?class_type=team&sync_from=示例数据&tag_id=0&sync_id=17&pro_name=保利玫瑰花语&is_demo=1";
    public static final String API_DOMAIN = "api.test.jgjapp.com/";//api域名
    public static final String API_DOMAIN_NEW = "napi.test.jgjapp.com/";//新的api域名
    public static final String WEB_DOMAIN = "nm.test.jgjapp.com/"; //web域名
    public static final String IP_ADDRESS_NEW = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN_NEW;
    public static final String IP_ADDRESS = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN;
    public static final String WEBURLS = HTTP_OR_HTTPS_REQUEST_HEAD + WEB_DOMAIN;
    public static final String CDNURL = HTTP_OR_HTTPS_REQUEST_HEAD + "test.cdn.jgjapp.com/";
    public static final String SERVER = WEBSOCKET_HEAD + "ws.test.jgjapp.com/websocket";


    /**
     * Beta
     */
//    public static final String API_DOMAIN = "api.beta.jgjapp.com/";//api域名
//    public static final String WEB_DOMAIN = "nm.beta.jgjapp.com/"; //web域名
//    public static final String IP_ADDRESS = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN;
//    public static final String WEBURLS = HTTP_OR_HTTPS_REQUEST_HEAD + WEB_DOMAIN;
//    public static final String API_DOMAIN_NEW = "napi.beta.jgjapp.com/";//新的api域名
//    public static final String IP_ADDRESS_NEW = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN_NEW;
//    public static final String EXAPLETABLE = HTTP_OR_HTTPS_REQUEST_HEAD + "wx2.beta.jgjapp.com/statistics/chart?class_type=team&sync_from=示例数据&tag_id=0&sync_id=17&pro_name=保利玫瑰花语&is_demo=1";
//    public static final String CDNURL = HTTP_OR_HTTPS_REQUEST_HEAD + "beta.cdn.jgjapp.com/";
//    public static final String SERVER = WEBSOCKET_HEAD + "ws.beta.jgjapp.com/websocket";

    /**
     * 正式版
     */
//    public static final String API_DOMAIN_NEW = "napi.jgjapp.com/";//新的api域名
//    public static final String API_DOMAIN = "api.jgjapp.com/"; //api域名
//    public static final String WEB_DOMAIN = "nm.jgjapp.com/"; //web域名
//    public static final String IP_ADDRESS = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN;
//    public static final String IP_ADDRESS_NEW = HTTP_OR_HTTPS_REQUEST_HEAD + API_DOMAIN_NEW;
//    public static final String WEBURLS = HTTP_OR_HTTPS_REQUEST_HEAD + WEB_DOMAIN;
//    public static final String EXAPLETABLE = HTTP_OR_HTTPS_REQUEST_HEAD + "wx2.jgjapp.com/statistics/chart?class_type=team&sync_from=示例数据&tag_id=0&sync_id=17&pro_name=保利玫瑰花语&is_demo=1";
//    public static final String CDNURL = HTTP_OR_HTTPS_REQUEST_HEAD + "cdn.jgjapp.com/";
//    public static final String SERVER = WEBSOCKET_HEAD + "ws.jgjapp.com/websocket";


    /**
     * 正式版、测试版 访问路径
     */
    public static final String NETURL = IP_ADDRESS;
    /**
     * 用户协议
     */
    public static final String AGREEMENT = NETURL + "web/html/mine/ph-agreement.html";
    /**
     * 联系我们
     */
    public static final String CONTACT = WEBURLS + "my/contact";
    /**
     * 找工作
     */
    public static final String WORK = WEBURLS + "work";
    /**
     * 我的
     */
    public static final String MY = WEBURLS + "my";
    /**
     * 找帮手
     */
    public static final String JOB = WEBURLS + "job";
    /**
     * 名片
     */
    public static final String POSTCARD = WEBURLS + "job/userinfo";
    /**
     * 新生活
     */
    public static final String NEWLIFE = WEBURLS + "find";
    /**
     * 项目组报表
     */
    public static final String STATISTICSCHARTS = WEBURLS + "statistical/charts";
    /**
     * 账单
     */
    public static final String BILL = WEBURLS + "bill";
    /**
     * 我的收藏
     */
    public static final String user = WEBURLS + "dynamic/user?uid=";
    /**
     * 关于我们
     */
    public static final String ABOUT_US = WEBURLS + "my/about";
    /**
     * 帮助中心
     */
    public static final String HELP_CENTER = WEBURLS + "help";
    /**
     * 质量/安全统计页面
     */
    public static final String STCHARTS = WEBURLS + "stcharts?";
    /**
     * 工友端交朋友
     */
    public static final String FRIENDWORK = NETURL + "web/html/make-friends/ph-make-friends.html?region=";
    /**
     * 验证码登录
     */
    public static final String LOGIN = NETURL + "v2/signup/login";
    /**
     * 版本检测
     */
    public static final String CHECK_VERSION = NETURL + "jlsys/version";
    /**
     * 获取验证码
     */
    public static final String GET_CODE = NETURL + "v2/signup/getvcode";
    /**
     * 绑定channel_id
     */
    public static final String POST_CHANNCELID = NETURL + "jlsys/channelid";

    /**
     * 新增评价
     */
    public static final String TOAPPRAISE = NETURL + "jlwork/toappraise";
    /**
     * 评价详情
     */
    public static final String APPRAISEDETAIL = NETURL + "jlwork/appraisedetail";
    /**
     * 完善资料 -- 名字
     */
    public static final String COMPLETE_REALNAME = NETURL + "jlsignup/upuserinfo";
    /**
     * 修改项目名称
     */
    public static final String UPPRONAME = NETURL + "jlworkday/upproname";
    /**
     * 删除项目
     */
    public static final String DELPRO = NETURL + "jlworkday/delpro";
    /**
     * 工头--找帮手
     */
    public static final String LOGOUT = NETURL + "jlsignup/logout";
    /**
     * 获取工种信息
     */
    public static final String CLASSLIST = NETURL + "jlcfg/classlist";
    /**
     * 获取服务器时间戳
     */
    public static final String GET_SERVER_TIME = NETURL + "Jlsys/getServerTimestamp";
    /**
     * 添加举报信息
     */
    public static final String ADD_REPORT = NETURL + "jlwork/report";
    /**
     * 上传通讯录
     */
    public static final String ADDRESSBOOK = NETURL + "jlsys/addressbook";
    /**
     * 切换角色
     */
    public static final String CHANGERROLE = NETURL + "jlsignup/changerole";
    /**
     * 工人批量记账
     */
    public static final String WORKERBATCHACCOUNT = IP_ADDRESS_NEW + "workday/relase";

    /** 1.1测试接口 */
    /**
     * 补充个人资料
     */
    public static final String MDUSERINFOS = NETURL + "jlsignup/upuserinfo";
    /**
     * 个人认证提交
     */
    public static final String IDAUTH = NETURL + "jlsignup/idAuth";

    /**
     * 查询个人资料
     */
    public static final String GETBASEINFO = NETURL + "jlsignup/getUnmappingFiled";
    /**
     * 获取工头班组长信息
     */
    public static final String JLWORKDAY = NETURL + "jlworkday/fmlist";
    /**
     * 添加记账对象
     */
    public static final String ADD_PERSON = IP_ADDRESS_NEW + "user/add-fm";
    /**
     * 发布记账时候查询与我相关的项目
     */
    public static final String QUERYPRO = NETURL + "jlworkday/querypro";
    /**
     * 发布记账时候添加新项目
     */
    public static final String ADDPRO = NETURL + "jlworkday/addpro";
    /**
     * 查询记账清单
     */
    public static final String WAGEDETAILDISH = NETURL + "jlworkstream/wagedetaildish";
    /**
     * 获取某一条记账信息详情
     */
    public static final String GETONEBILLDETAIL = NETURL + "jlworkstream/getonebilldetail";
    /**
     * 删除记账信息
     */
    public static final String DELSETSMOUNT = NETURL + "jlworkday/delinfo";
    /**
     * 修改差帐
     */
    public static final String MPOORINFO = NETURL + "jlworkstream/mpoorinfo";
    /**
     * 记工清单详情
     */
    public static final String STREAMDETAIL = NETURL + "jlworkstream/streamdetail";
    /**
     * 看人记工清单详情
     */
    public static final String GETWITHPEOPLEPROJECT = NETURL + "jlworkstream/getwithpeopleorproject";
    /**
     * 修改差帐后保存
     */
    public static final String MODIFYRELASE = NETURL + "jlworkday/modifyrelase";
    /**
     * 显示我的页面
     */
    public static final String LASTPRO = NETURL + "jlworkday/lastpro";
    /**
     * 获取、管理同步人列表
     */
    public static final String GETUSERSYNLIST = NETURL + "jlworksync/getusersynclist";
    /**
     * 新增和修改同步人信息
     */
    public static final String OPTUSERSYN = NETURL + "jlworksync/optusersync";
    /**
     * 针对某人已同步的项目列表，
     */
    public static final String SYNCEDPRO = NETURL + "jlworksync/prolist";
    /**
     * 删除此人
     */
    public static final String DELETESERDYNC = NETURL + "jlworksync/delusersync";
    /**
     * 关闭同步
     */
    public static final String CLOSESYNCH = NETURL + "jlworksync/shutsyncpro";
    /**
     * 同步同步
     */
    public static final String SYNCPRO = NETURL + "jlworksync/syncpro";
    /**
     * 拒绝同步项目
     */
    public static final String REFUSE_SYNC_PROJECT = IP_ADDRESS_NEW + "sync/refuse-sync-project";
    /**
     * 据uid获取用户信息
     */
    public static final String GET_USER_INFO_BY_UID = IP_ADDRESS_NEW + "sign/get-user-info-by-uid";
    /**
     * 视频
     */
    public static final String VIDEO = "http://m.tv.sohu.com/";
    /**
     * 段子
     */
    public static final String DUANZI = "http://www.jiongtoutiao.com/m";
    /**
     * 小说
     */
    public static final String BOOK = "http://m.ireadercity.com/webapp/home/index.html";
    /**
     * 删除记账人
     */
    public static final String DELFM = NETURL + "v2/workday/delfm";

    /**
     * 项目Banner
     */
    public static final String BANNER = NETURL + "v2/index/banner";

    /**
     * •banner点击统计r
     */
    public static final String BANNERSTA = NETURL + "v2/index/bannerstatistics";
    /**
     * 班组成员记工列表
     */
    public static final String GROUPWORKDAYLIST = IP_ADDRESS_NEW + "workday/group-workday-list";
    /**
     * 上传图片
     */
    public static final String UPLOAD = NETURL + "jlupload/upload";
    /**
     * 创建者记账班组成员列表
     */
    public static final String BILLGROUPLIST = NETURL + "v2/Workday/billToGroupMemberList";
    /**
     * 工资清单  person：按个人（默认）;project:按项目
     */
    public static final String PRYROLLLIST = NETURL + "v2/workdaystream/payPolllist";
    /**
     * 工资清单按年、月、日查看  person：按个人（默认）;project:按项目
     */
    public static final String PERANDPROALLBILL = NETURL + "v2/Workdaystream/perAndProAllBillList";

    /**
     * 获取每个月份，xx人的总项目 或 xx项目的人，记工统计（第三级别）
     */
    public static final String PERANDPROMONTHBILL = NETURL + "v2/Workdaystream/perAndProMonthBill";

    /**
     * 工资清单详情（第四级别)
     */
    public static final String STREAMDETAILSTANDARD = NETURL + "v2/workdaystream/streamDetailStandardInfo";

    /**
     * 获取知识库
     */
    public static final String GET_REPOSITORY = NETURL + "v2/knowledge/getColumnList";
    /**
     * 获取知识库 收藏列表
     */
    public static final String GET_COLLECTION_FILE = NETURL + "v2/knowledge/getCollectionFile";
    /**
     * 搜索知识库
     */
    public static final String SEARCH_FILE = NETURL + "v2/knowledge/searchFile";
    /**
     * 取消收藏、收藏
     */
    public static final String HAND_COLLECTION_FILE = NETURL + "v2/knowledge/handleCollectionFile";
    /**
     * 获取文件下载路径
     */
    public static final String GET_FILE_CONTENT = NETURL + "v2/knowledge/getFileContent";
    /**
     * 删除 质量、安全，日志
     */
    public static final String DELQUALITYANDSAFE = NETURL + "v2/quality/delQualitySafeLog";
    /**
     * 里所有的回复消息列表
     */
    public static final String GET_QUALITYSAFEALLLIST = NETURL + "v2/quality/getQualitySafeAllList";
    /**
     * 修改日志
     */
    public static final String MODIFY_LOG = NETURL + "v2/quality/modifyLog";
    /**
     * 修改电话号码
     */
    public static final String MODIFY_TELPHONE = NETURL + "v2/signup/modifyTelephone";
    /**
     * 获取当天某组的最近天气信息
     */
    public static final String GET_WEATHER_DAYBYGROUP = NETURL + "v2/weather/getWeatherDayByGroup";
    /**
     * 发布晴雨表天气
     */
    public static final String PUBLISH_WEATHER = NETURL + "v2/Weather/handleWeather";
    /**
     * 删除晴雨表天气
     */
    public static final String DELETE_WEATHER = NETURL + "v2/Weather/delWeather";
    /**
     * 获取晴雨表列表数据
     */
    public static final String GET_WEATHER_LIST = NETURL + "v2/Weather/getWeatherList";
    /**
     * 获取某天晴雨表的信息
     */
    public static final String GET_WEATHER_DAY_DETAIL = NETURL + "v2/Weather/getWeatherByDate";
    /**
     * 设置记录员
     */
    public static final String SET_REPORT = NETURL + "v2/weather/setReport";
    /**
     * 发布任务
     */
    public static final String PUBLISH_TASK = NETURL + "v2/task/taskPost";
    /**
     * 获取任务列表
     */
    public static final String TASK_TASKPOST = NETURL + "v2/task/taskList";
    /**
     * 通过任务id查询任务详情
     */
    public static final String TASKDETAIL = NETURL + "v2/task/taskDetail";
    /**
     * 任务回复列表
     */
    public static final String TASKREPLYLIST = NETURL + "v2/task/taskReplyList";
    /**
     * 对任务进行回复
     */
    public static final String TASKREPLY = NETURL + "v2/task/taskReply";
    /**
     * 修改任务状态
     */
    public static final String TASKSTATUSCHANGE = NETURL + "v2/task/taskStatusChange";
    /**
     * 审批
     */
    public static final String APPLYFOR = WEBURLS + "applyfor?class_type=team&group_id=";
    /**
     * 会议
     */
    public static final String CONFERENCE = WEBURLS + "conference?class_type=team&group_id=";

    //回复质量、安全
    public static final String REPLYMESSAGE = NETURL + "v2/quality/replyMessage";
    //获取质量安全的位置列表
    public static final String getQualitySafeLocation = NETURL + "v2/quality/getQualitySafeLocation";
    //获取质量安全的列表
    public static final String GET_QUALITYANDSAFELIST = NETURL + "v2/quality/getQualitySafeList";
    //获取质量安全的详细信息
    public static final String GET_GETQUALITYANDSAFEINFO = NETURL + "v2/quality/getQualitySafeInfo";
    public static final String GET_NOTICE_INFO = NETURL + "pc/Notice/noticeInfo";
    public static final String MODIFY_QUALITY_AND_SAFE = NETURL + "v2/quality/modifyQaulitySafe";
    //    http://nm.ex.yzgong.com/help/hpDetail?id=8
    public static final String HELPDETAIL = WEBURLS + "help/hpDetail?id=";
    //获取检查项信息列表
    public static final String GET_INSPECT_QUALITYLIST = NETURL + "v2/quality/getInspectQualityList";
    //发布、修改检查项目计划
    public static final String PUB_INSPECT_QUALITY = NETURL + "v2/quality/pubInspectQuality";
    //获取检查项目计划
    public static final String GET_PUBINSPECLIST = NETURL + "v2/quality/getPubInspectList";
    //获取检查项目计划详情
    public static final String GET_INSPECTQYALITYINFO = NETURL + "v2/quality/getInspectQualityInfo";
    //检查记录
    public static final String GET_CHILDINSPECTLIST = NETURL + "v2/quality/getChildInspectList";
    //删除检查计划
    public static final String DEL_INSPECRQUALITYLIST = NETURL + "v2/quality/delInspectQualityList";
    //回复检查项目
    public static final String RELAYINSPECTINFO = NETURL + "v2/quality/replayInspectInfo";
    //删除检查结果
    public static final String DEL_REPLAYINSPECTINFO = NETURL + "v2/quality/delReplayInspectInfo";
    //日志列表
    public static final String GET_LOG_LIST = NETURL + "pc/log/logList";
    //模版类别列表
    public static final String GET_APPOVALCSTLIST = NETURL + "v2/Approval/approvalCatList";
    //获取日志模板
    public static final String GET_APPOVALtTEMPLATE = NETURL + "v2/Approval/getApprovalTemplate";
    //发布日志
    public static final String PUBLOG = NETURL + "pc/Log/pubLog";
    // 日志详情(app,pc通用)
    public static final String LOGINFO = NETURL + "pc/Log/logInfo";
    // 日志回复列表
    public static final String LOGREPLYLIST = NETURL + "pc/Log/logReplyList";
    // 获取质量安全的回复列表
    public static final String GET_RPLYMESSAGRLIST = NETURL + "v2/quality/getReplyMessageList";

    /**
     * 扫码登录
     */
    public static final String SCAN_LOGIN = NETURL + "v2/Signup/qrcodeLogin";
    /**
     * 云盘文件列表
     */
    public static final String GET_OSSLIST = NETURL + "v2/cloud/getOssList";
    /**
     * 创建云盘目录
     */
    public static final String CREATE_CLOUD_DIR = NETURL + "v2/cloud/createCloudDir";

    /**
     * 移动文件
     */
    public static final String MOVE_FILE = NETURL + "v2/cloud/moveFiles";
    /**
     * 搜索文件
     */
    public static final String SEARCH_CLOUD_FILE = NETURL + "v2/cloud/searchFile";
    /**
     * 删除文件
     */
    public static final String DEL_FILE = NETURL + "v2/cloud/delFiles";
    /**
     * 下载文件
     */
    public static final String DOWN_FILE = NETURL + "v2/cloud/downFile";
    /**
     * 上传文件
     */
    public static final String UPLOAD_FILE = NETURL + "v2/cloud/uploadFiles";
    /**
     * 还原文件
     */
    public static final String RESTORE_FILEES = NETURL + "v2/cloud/restoreFiles";
    /**
     * 重命名文件
     */
    public static final String RENAME_FILE = NETURL + "v2/cloud/renameFile";
    /**
     * 显示当前目录下的文件/文件夹
     */
    public static final String EXCLOUD_FILES = NETURL + "v2/cloud/excloudFiles";
    /**
     * 获取订单列表
     */
    public static final String ORDER_LIST = NETURL + "v2/order/orderList";
    /**
     * 支付订单
     */
    public static final String PAY_ORDER = NETURL + "v2/order/payOrder";
    /**
     * 我加入的项目组列表(app，pc通用)
     */
    public static final String GET_TEAM_LIST = NETURL + "pc/Project/getTeamList";
    /**
     * 获取订单信息
     */
    public static final String GET_ORDER_INFO = NETURL + "v2/order/getServerNameList";
    /**
     * 提现手机号列表
     */
    public static final String PARTNER_WITHDRAWTELELIST = NETURL + "v2/partner/partnerWithdrawTeleList";
    /**
     * 删除提现账户
     */
    public static final String DEL_PARTNER_WITHDRAWTELELIST = NETURL + "v2/partner/delPartnerWithdrawTele";
    /**
     * 降级处理
     */
    public static final String DEGRADE_GROUP_HANDLE = NETURL + "v2/cloud/degradeGroupHandle";
    /**
     * 删除日志
     */
    public static final String DEL_LOG = NETURL + "pc/log/delLog";
    /**
     * 更改任务的负责人或者参与人
     */
    public static final String TASK_PERSON_CHANGE = NETURL + "v2/task/taskPersonChange";
    /**
     * 添加提现手机号
     */
    public static final String ADDPARTNERWITHDRAWTELE = NETURL + "v2/partner/addPartnerWithdrawTele";
    /**
     * 提现金额
     */
    public static final String GET_MONEY_FROM_BALANCE = NETURL + "v2/partner/getMoneyFromBalance";
    /**
     * 提交保证金
     */
    public static final String PAY_DEPOSIT = NETURL + "v2/pay/payDeposit";
    /**
     * 日志回复
     */
    public static final String LOG_REPLY_MESSAGE = NETURL + "pc/log/replyMessage";

    /**
     * 项目组报表
     */
    public static final String WEBSITE = WEBURLS + "website?group_id=";

    /**
     * 设备管理
     */
    public static final String EQUIPENT = WEBURLS + "equipment?group_id=";

    //2.3.2

    public static final String WEBURLS_SHARE = "http://m.test.jgjapp.com/";
    /**
     * 记工详情
     */
    /**
     * 记工待确认列表
     */
    public static final String CONFIRM_WORK = IP_ADDRESS_NEW + "workday/wait-confirm-list";
    /**
     * 记工待确认
     */
    public static final String CONFIRM_ACCOUNT = NETURL + "v2/workday/confirmAccount";
    /**
     * 每日考勤
     */
    public static final String ERVER_DAY_WORK = IP_ADDRESS_NEW + "workday/work-items";
    /**
     * 添加检查计划
     */
    public static final String ADD_CHECK_PLAN = NETURL + "v2/inspect/addInspectPlan";
    /**
     * 检查点状态操作(完成操作和不用检查操作)
     */
    public static final String HANDLE_INSPECT_DOTSTATUS = NETURL + "v2/inspect/handleInspectDotStatus";
    /**
     * 整改通知
     */
    public static final String REFORMINSPECT = NETURL + "v2/inspect/reformInspect";
    /**
     * 检查计划中记录
     */
    public static final String GET_INSPECT_PLAN_LOG = NETURL + "v2/inspect/getInspectPlanLog";
    /**
     * 删除检出计划
     */
    public static final String DEL_INSPECTPLAN = NETURL + "v2/inspect/delInspectPlan";
    /**
     * 工作提醒
     */
    public static final String GET_ALLNOTICEMESSAGE = NETURL + "v2/Quality/getAllNoticeMessage";
    /**
     * 清除工作消息
     */
    public static final String CLEAR_REPLYMESSAGE = NETURL + "v2/Quality/cleanReplyMessage";
    /**
     * 质量/安全首页
     */
    public static final String GET_QUALITYSAFEINDEX = NETURL + "v2/quality/getQualitySafeIndex";
    /**
     * 任务首页
     */
    public static final String TASK_HOME_PAGE = NETURL + "v2/task/taskHomepage";
    /**
     * 活动期间赠送接口
     */
    public static final String DONATESANIORCLOUD = NETURL + "v2/order/donateSeniorCloud";
    /**
     * 检查项列表数据
     */
    public static final String GETINSPECTPROORCONTENT = NETURL + "v2/inspect/getInspectProOrContent";
    /**
     * 添加检查内容
     */
    public static final String ADD_CHECK_CONTENT = NETURL + "v2/inspect/addInspectContent";
    /**
     * 修改检查项内容
     */
    public static final String UPDATE_CHECK_CONTENT = NETURL + "v2/inspect/updateInspectContent";
    /**
     * 获取检查内容详情
     */
    public static final String GET_CHECK_CONTENT_DETAIL = NETURL + "v2/inspect/getInspectContentINfo";
    /**
     * 检查首页
     */
    public static final String GET_CHECK_CONTENT_HOME_PAGE_DATA = NETURL + "v2/inspect/getInspectIndex";
    /**
     * 获取检查项详情
     */
    public static final String GET_CHECK_LIST_DETAIL = NETURL + "v2/inspect/getInspectProInfo";
    /**
     * 添加检查项
     */
    public static final String ADD_CHECK_LIST = NETURL + "v2/inspect/addInspecPro";
    /**
     * 删除检查内容
     */
    public static final String DELETE_CHECK_CONTENT = NETURL + "v2/inspect/delInspectContent";
    /**
     * 删除检查项
     */
    public static final String DELETE_CHECK_LIST = NETURL + "v2/inspect/delInspecPro";
    /**
     * 获取检查项内容列表
     */
    public static final String GET_CHECK_LIST_CONTENT_LIST = NETURL + "v2/inspect/getInspectContentList";
    /**
     * 修改检查项
     */
    public static final String UPDATE_CHECK_LIST = NETURL + "v2/inspect/updateInspecPro";
    /**--------------------------------2.3.4-----------------------------**/
    /**
     * 检查计划列表
     */
    public static final String GET_INSPECTPLANLIST = NETURL + "v2/inspect/getInspectPlanList";
    /**
     * 获取检查计划详情
     */
    public static final String GET_INSPECTPLAN_INFO = NETURL + "v2/inspect/getInspectPlanInfo";
    /**
     * 获取检查计划中的检查项
     */
    public static final String GET_PLAN_PRO_INFO = NETURL + "v2/inspect/getPlanProInfo";
    /**
     * 检查项列表
     */
    public static final String CHECK_LIST = NETURL + "v2/inspect/getInspecProList";
    /**
     * 修改检查计划
     */
    public static final String UPDATE_CHECK_PLAN = NETURL + "v2/inspect/updateInspectPlan";
    /**
     * 会议详情
     */
    public static final String MEETINGDETAILS = WEBURLS + "conference/details?";

    /**
     * 记工统计
     */
    public static final String STATISTICAL_WORK = IP_ADDRESS + "v2/workday/getWorkRecordStatistics";
    /**
     * 未结工资
     */
    public static final String UN_PAY_SALARY_LIST = IP_ADDRESS_NEW + "workday/get-unpaysalary-list";
    /**
     * 无金额点工
     */
    public static final String NO_MONEY_LITTLE_WORK = IP_ADDRESS_NEW + "workday/get-unset-salarytpl-by-uid-list";
    /**
     * 记工统计按照月统计
     */
    public static final String GET_MONTH_RECORD_STATISTICS = IP_ADDRESS + "v2/workday/getMonthRecordStatistics";
    /**
     * 首页 /一人记多天首页
     */
    public static final String WORKER_MONTH_TOTAL = IP_ADDRESS_NEW + "workday/worker-month-total";
    /**
     * 获取待结算金额
     */
    public static final String GET_UNBALANCEANDSALARYTPL = IP_ADDRESS_NEW + "workday/get-unpaysalary-list-total";
    /**
     * 获取项目，工人，工头
     */
    public static final String GET_TARGETNAMELIST = NETURL + "v2/workday/getTargetNameList";
    /**
     * 差账显示账单
     */
    public static final String SHOW_POOR_TIP = NETURL + "v2/workday/showpoorTip";
    /**
     * 注销账户
     */
    public static final String ACCOUNT_CANCELLATION = NETURL + "v2/Signup/accountCancellation";
    /**
     * 账户状态
     */
    public static final String ACCOUNT_STATUS = NETURL + "v2/Signup/accountStatus";
    /**
     * 人脉推荐
     */
    public static final String RECOMMENDLIST = NETURL + "v2/user/recommendList";
    /**
     * 获取微信绑定状态
     */
    public static final String GET_WECHAT_BIND_INFO = NETURL + "v2/user/getwechatbindInfo";
    /**
     * 微信解除绑定
     */
    public static final String UN_BIND_WX = NETURL + "v2/user/unbindUnionid";
    /**
     * 微信登录
     */
    public static final String WX_LOGIN = NETURL + "v2/signup/wxlogin";
    /**
     * 精彩小视频
     */
    public static final String WONDERFUL_VIDEO = IP_ADDRESS_NEW + "video/socialvideolist";
    /**
     * 精彩小视频点赞
     */
    public static final String WONDERFUL_VIDEO_LIKE = IP_ADDRESS + "v2/dynamic/dynamicLiked";
    /**
     * POST /notebook/post-one
     * 新增记事本单条记录
     */
    public static final String ADD_NOTEBOOK = IP_ADDRESS_NEW + "notebook/post-one";
    /**
     * POST /notebook/put-one
     * 更新记事本单条记录
     */
    public static final String PUR_NOTEBOOK = IP_ADDRESS_NEW + "notebook/put-one";
    /**
     * POST /notebook/get-list
     * 记事本列表
     */
    public static final String GET_NOTEBOOK_LIST = IP_ADDRESS_NEW + "notebook/get-list";
    /**
     * POST /notebook/delete-one
     * 记事本删除单条
     */
    public static final String NOTEBOOK_DELETE = IP_ADDRESS_NEW + "notebook/delete-one";
    /**
     * POST /notebook/get-one
     * 获取记事本单条详情
     */
    public static final String NOTEBOOK_DETAIL = IP_ADDRESS_NEW + "notebook/get-one";
    /**
     * POST /workday/relase
     * 记工记账
     */
    public static final String RELASE_NEW = IP_ADDRESS_NEW + "workday/relase";
    /**
     * POST /workday/work-detail
     * 记工详情
     */
    public static final String WORKDETAIL = IP_ADDRESS_NEW + "workday/work-detail";
    /**
     * POST /workday/modify-relase
     * 修改记账
     */
    public static final String MODIFYRELASE_NEW = IP_ADDRESS_NEW + "workday/modify-relase";
    /**
     * 获取评价详情
     */
    public static final String EVALUATE_INFO = IP_ADDRESS_NEW + "evaluate/evaluate-info";
    /**
     * 奖励开发者
     */
    public static final String REWARD_COMMIT = IP_ADDRESS_NEW + "reward/commit";
    /**
     * 工头或者工人列表
     */
    public static final String FOREMAN_WORKER_LIST = IP_ADDRESS_NEW + "workday/worker-role-list";
    /**
     * 去评价获取信息
     */
    public static final String EVALUATE_PAGE_INFO = IP_ADDRESS_NEW + "evaluate/evaluate-page-info";
    /**
     * 标签搜索
     */
    public static final String SEARCH_TAGS = IP_ADDRESS_NEW + "evaluate/search-tags";
    /**
     * 提交评价
     */
    public static final String SUBMIT_EVALUATE = IP_ADDRESS_NEW + "evaluate/evaluate-submit";
    /**
     * 评价列表
     */
    public static final String EVALUATE_LIST = IP_ADDRESS_NEW + "evaluate/evaluate-list";
    /**
     * 同步列表数据
     */
    public static final String SYNCED_TARGET_LIST = IP_ADDRESS_NEW + "sync/synced-to-target-list";
    /**
     * 同步给我的项目
     */
    public static final String SYNCED_TO_ME = IP_ADDRESS_NEW + "sync/synced-to-me-list";
    /**
     * 要求某人同步
     */
    public static final String ASK_USER_TO_SYNC = IP_ADDRESS + "v2/workday/askUserToSync";
    /**
     * 获取某天班组成员的记工情况
     */
    public static final String WORKDAY_GROUP_MEMBERS_TPL = IP_ADDRESS_NEW + "workday/group-members-tpl";
    /**
     * 提交批量记账1天记多人
     */
    public static final String WORKDAY_RELEASE = IP_ADDRESS_NEW + "workday/relase";
    /**
     * 获取工头班组长信息 可以获取到包工记工天模板
     */
    public static final String JLWORKDAY_NEW = IP_ADDRESS_NEW + "workday/fm-list";
    /**
     * 文件上传
     */
    public static final String UPLOAD_NEW = IP_ADDRESS_NEW + "file/upload";
    /**
     * 删除每日考勤记账信息
     */
    public static final String DELETE_JLWORKDAY = IP_ADDRESS + "jlworkday/delinfo";
    /**
     * 下载每日考勤账单
     */
    public static final String DOWNLOAD_WORKDAY_LIST = IP_ADDRESS_NEW + "workday/group-workday-list";
    /**
     * 找回账号 问题3
     */
    public static final String FIND_ACCOUNT_QUESTION3 = IP_ADDRESS + "v2/signup/findaccount";
    /**
     * 找回账号 验证
     */
    public static final String FIND_ACCOUNT_VALIDATION = IP_ADDRESS + "v2/signup/findaccountcheck";
    /**
     * 修改手机号码
     */
    public static final String FIND_ACCOUNT_CHANGE_TELPHONE = IP_ADDRESS + "v2/signup/changeTelephone";
    /**
     * 删除回复消息记录
     */
    public static final String DEL_REPLY_MSG = IP_ADDRESS + "v2/quality/delReplyMessage";
    /**
     * 设置代班长
     */
    public static final String SET_PROXY_GROUPER = IP_ADDRESS_NEW + "workday/set-proxy-grouper";
    /**
     * 找回密码，换一组问题
     */
    public static final String REFRESH_FIND_ACCOUNT_QUESTION = IP_ADDRESS + "v2/signup/refreshfindaccountques";
    /**
     * 新记工流水
     */
    public static final String GET_WORK_RECORD_FLOW = IP_ADDRESS_NEW + "workday/get-work-record-flow";
    /**
     * 记工变更
     */
    public static final String GET_WORK_RECORD_CHANGE_LIST = IP_ADDRESS_NEW + "workday/get-workday-change-list";
    /**
     * 获取签名信息
     */
    public static final String GET_SIGNUP = IP_ADDRESS + "v2/signup/userstatus";
    /**
     * 聊聊首页
     */
    public static final String GET_CHAT_MAIN_INFO = IP_ADDRESS_NEW + "chat/get-index-list";
    /**
     * 聊聊聊天列表信息
     */
    public static final String GET_CHAT_LIST = IP_ADDRESS_NEW + "chat/get-chat-list";
    /**
     * 签到
     */
    public static final String SIGN_IN = IP_ADDRESS_NEW + "sign/sign-in";
    /**
     * 签到列表
     */
    public static final String SIGN_LIST = IP_ADDRESS_NEW + "sign/sign-list";
    /**
     * 签到列表POST
     */
    public static final String NOTICE_LIST = IP_ADDRESS_NEW + "notice/notice-list";
    /**
     * 某个成员签到记录
     */
    public static final String SIGN_RECORD_LIST = IP_ADDRESS_NEW + "sign/sign-record-list";
    /**
     * 签到详情
     */
    public static final String SIGN_RECORD_DETAIL = IP_ADDRESS_NEW + "sign/sign-record-detaill";
    /**
     * 发通知
     */
    public static final String PUB_NOTICE = IP_ADDRESS_NEW + "group/pub-notice";
    /**
     * 发布质量/安全
     */
    public static final String PUB_QUALITY_OR_SAFE = IP_ADDRESS_NEW + "group/pub-quality-or-safe";
    /**
     * 未读数的成员列表，消息
     */
    public static final String GET_GROUP_MEMBER_BY_MESSAGE = IP_ADDRESS_NEW + "chat/get-group-members-by-message";
    /**
     * 未读数的成员列表通知等
     */
    public static final String GET_TYPE_MEMBER_BY_MESSAGE = IP_ADDRESS_NEW + "chat/get-type-members-by-message";
    /**
     * 创建班组
     */
    public static final String CREATE_GROUP = IP_ADDRESS_NEW + "group/create-group";
    /**
     * 创建班组,获取所在项目列表
     */
    public static final String CREATE_GROUP_GET_PRO_LIST = IP_ADDRESS_NEW + "group/group-pro-list";
    /**
     * 面对面建群 根据验证码获取成员数量
     */
    public static final String FACE_TO_FACE_BY_CODE_GET_INFO = IP_ADDRESS_NEW + "group/face-to-face";
    /**
     * 面对面建群 根据验证码获取成员数量
     */
    public static final String GET_MEMBER_LIST = IP_ADDRESS_NEW + "group/get-members-list";
    /**
     * 离线消息列表
     */
    public static final String GET_OFFLINE_MESSAGE_LIST = IP_ADDRESS_NEW + "chat/get-offline-message-list";
    /**
     * 漫游消息
     */
    public static final String GET_ROAM_MESSAGE_LIST = IP_ADDRESS_NEW + "chat/get-roam-message-list";
    /**
     * 某个成员信息
     */
    public static final String GET_CHAT_MEMBER_INFO = IP_ADDRESS_NEW + "chat/get-chat-member-info";
    /**
     * 好友申请
     */
    public static final String ADD_FRIEND = IP_ADDRESS_NEW + "chat/add-friends";
    /**
     * 好友申请 模板列表
     */
    public static final String SEND_MESSAGE_MOUDLE = IP_ADDRESS_NEW + "chat/get-message-tpl-list";
    /**
     * 根据电话查找用户信息
     */
    public static final String ACCORD_TEL_FIND_USERINFO = IP_ADDRESS_NEW + "chat/get-lookup-member";
    /**
     * 好友申请列表
     */
    public static final String ADD_FRIEND_LIST = IP_ADDRESS_NEW + "chat/add-friends-list";
    /**
     * 加入黑名单
     */
    public static final String ADD_BLACK_LIST = IP_ADDRESS_NEW + "group/add-black-list";
    /**
     * 移除黑名单
     */
    public static final String RM_BLACK_LIST = IP_ADDRESS_NEW + "group/rm-black-list";
    /**
     * 是否在黑名单
     */
    public static final String IS_BLACK_LIST = IP_ADDRESS_NEW + "group/is-black-list";
    /**
     * 判断是否资格添加朋友
     */
    public static final String GET_FRIENDS_CONFIDITION = IP_ADDRESS_NEW + "chat/get-friends-confidition";
    /**
     * 设置首页聊天信息
     */
    public static final String SET_INDEX_LIST = IP_ADDRESS_NEW + "chat/set-index-list";
    /**
     * 删除班组、项目
     */
    public static final String DEL_GROUP = IP_ADDRESS_NEW + "group/del-group";
    /**
     * 重新开启班组、项目组
     */
    public static final String REOPEN_GROUP = IP_ADDRESS_NEW + "group/reenable-group";
    /**
     * 删除成员
     */
    public static final String DEL_MEMBER = IP_ADDRESS_NEW + "group/del-members";
    /**
     * 删除好友
     */
    public static final String DEL_FRIEND = IP_ADDRESS_NEW + "group/del-friend";
    /**
     * 已关闭的项目组、班组
     */
    public static final String GET_CLOSE_CHAT_LIST = IP_ADDRESS_NEW + "chat/get-close-chat-list";
    /**
     * 班组、项目组详情
     */
    public static final String GET_GROUP_INFO = IP_ADDRESS_NEW + "group/get-group-info";
    /**
     * 班组、项目组详情
     */
    public static final String GROUP_MODIFY = IP_ADDRESS_NEW + "group/group-modify";
    /**
     * 设置用户备注
     */
    public static final String SET_USER_COMMENT_NAME = IP_ADDRESS_NEW + "user/modify-comment-name";
    /**
     * 同意好友申请
     */
    public static final String AGREE_FRIENDS = IP_ADDRESS_NEW + "chat/agree-friends";
    /**
     * 退出班组、项目组
     */
    public static final String QUIT_GROUP = IP_ADDRESS_NEW + "group/quit-members";
    /**
     * 黑名单列表
     */
    public static final String BLACK_LIST = IP_ADDRESS_NEW + "chat/get-black-list";
    /**
     * 管理员列表
     */
    public static final String ADMIN_LIST = IP_ADDRESS_NEW + "chat/oper-members-list";
    /**
     * 删除好友请求
     */
    public static final String DEL_ADD_FRIENDS_APPLY = IP_ADDRESS_NEW + "chat/del-add-friends";
    /**
     * 移除、添加管理员
     */
    public static final String REMOVE_OR_ADD_ADMIN = IP_ADDRESS_NEW + "chat/handle-admin";
    /**
     * 转让群聊管理权
     */
    public static final String SWITCH_MANAGER = IP_ADDRESS_NEW + "group/switch-manager";
    /**
     * 通讯录好友
     */
    public static final String FRIEND_LIST = IP_ADDRESS_NEW + "chat/get-friends-list";
    /**
     * 获取最后一个好友申请人的头像
     */
    public static final String GET_TEMPORARY_FRIEND = IP_ADDRESS_NEW + "chat/get-temporary-friend-list";
    /**
     * 关闭班组、群聊、项目组
     */
    public static final String CLOSE_TEAM_GROUP = IP_ADDRESS_NEW + "group/close-group";
    /**
     * 群聊升级成班组
     */
    public static final String UPGRADE_GROUP = IP_ADDRESS_NEW + "group/upgrade-group";
    /**
     * 删除数据来源人
     */
    public static final String DELETE_SOURCE_MEMBER = IP_ADDRESS_NEW + "group/del-source-member";
    /**
     * 添加成员
     */
    public static final String ADD_MEMBERS = IP_ADDRESS_NEW + "group/add-members";
    /**
     * 根据电话号码获取成员信息
     */
    public static final String USERTEL_GET_USERINFO = IP_ADDRESS_NEW + "user/useTelGetUserInfo";
    /**
     * 创建群聊
     */
    public static final String CREATE_GROUPCHAT = IP_ADDRESS_NEW + "group/create-chat";
    /**
     * 根据二维码查询班组、项目组、群聊信息
     */
    public static final String QRCODE = IP_ADDRESS_NEW + "group/create-qrcode";
    /**
     * 获取数据来源人 数据源
     */
    public static final String SYNCPRO_FROM_SOURCE_LIST = IP_ADDRESS_NEW + "group/syncpro-from-source-list";
    /**
     * 数据来源人关闭同步，同时退出项目组
     */
    public static final String TEAM_MEMBER_CLOSE_SYNC = IP_ADDRESS_NEW + "group/closeSync";
    /**
     * 获取服务器我上传上去的手机通讯录
     */
    public static final String GET_MEMBER_TELEPHONE = IP_ADDRESS_NEW + "chat/get-member-telephone";
    /**
     * 添加数据来源人
     */
    public static final String ADD_SOURCE_MEMBER = IP_ADDRESS_NEW + "group/add-source-member";
    /**
     * 移除数据来源人
     */
    public static final String REMOVE_SOURCE = IP_ADDRESS_NEW + "group/remove-sync-source";
    /**
     * 微信二维码
     */
    public static final String CREATE_WX_QRCODE = IP_ADDRESS_NEW + "wxchat/create-wx-qrcode";
    /**
     * 微信绑定状态
     */
    public static final String CREATE_WX_STATUS = IP_ADDRESS_NEW + "wxchat/get-wx-status";
    /**
     * 微信绑定状态POST
     */
    public static final String GET_EX_UNBOND = IP_ADDRESS_NEW + "wxchat/get-wx-unbound";
    /**
     * 根据消息id获取已读未读数
     */
    public static final String GET_MESSAGE_READED_NUM = IP_ADDRESS_NEW + "chat/get-message-readed-num";
    /**
     * 获取签到列表下载地址
     */
    public static final String SIGN_EXPORT = IP_ADDRESS_NEW + "sign/sign-export";
    /**
     * 批量设置记工的工资标准
     */
    public static final String SET_WORKDAY_TPL = IP_ADDRESS_NEW + "workday/set-workday-tpl";
    /**
     * 批量删除工人，班组长
     */
    public static final String DEL_FM_LIST = IP_ADDRESS_NEW + "workday/del-fm";
    /**
     * 每天记账详情
     */
    public static final String WORKDAY_RECORD = IP_ADDRESS_NEW + "workday/get-index-workrecord-total";
    /**
     * 获取记账模版
     */
    public static final String GET_WORK_TPL_BY_UID = IP_ADDRESS_NEW + "workday/get-work-tpl-by-uid";
    /**
     * 删除所在项目app
     */
    public static final String WORKDAY_DEL_PRO = IP_ADDRESS_NEW + "workday/del-pro";
    /**
     * 修改所在项目
     */
    public static final String WORKDAY_MODIFY_PRO = IP_ADDRESS_NEW + "workday/modify-pro";
    /**
     * 快速加入群列表
     */
    public static final String FAST_GROUP_CHAT_LIST = IP_ADDRESS_NEW + "group/fast-group-chat-list";
    /**
     * 用户各种类型消息上一次接收人
     */
    public static final String LAST_RECUID_LIST = IP_ADDRESS_NEW + "group/last-recuid_list";
    /**
     * 上传地址
     */
    public static final String UPLOC = IP_ADDRESS_NEW + "sys/common";
    /**
     * 我的个人资料
     */
    public static final String MYINFO = WEBURLS + "my/list";
    /**
     * 记事本日历
     */
    public static final String NOTES_CALENDAR = IP_ADDRESS_NEW + "notebook/calendar";
    /**
     * h5发现小红点
     */
    public static final String DISCOVER_NEW_MSG_COUNT = IP_ADDRESS + "v2/dynamic/newMsgNum";
    /**
     * 对账开关功能
     */
    public static final String RECORD_CONFIRM_ON_OFF = IP_ADDRESS_NEW + "workday/set-record-confirm-on-off";
    /**
     * 获取对账开关的状态
     */
    public static final String RECORD_CONFIRM_OFF_STATUS = IP_ADDRESS_NEW + "workday/get-record-confirm-off-status";
    /**
     * 获取对账成员列表
     */
    public static final String WORKDAY_PARTNER_LIST = IP_ADDRESS_NEW + "workday/get-workday-partner-list";
    /**
     * 批量设置工资金额
     */
    public static final String BATCH_SALARY_TPL = IP_ADDRESS_NEW + "workday/set-batch-salary-tpl";
    /**
     * 获取包工模版
     */
    public static final String GET_CONTRACTOR_TPL_LIST = IP_ADDRESS_NEW + "workday/get-contractor-tpl-list";
    /**
     * 记工统计一级页面(3.5.2)
     */
    public static final String WORK_RECORD_STATISTICS = IP_ADDRESS_NEW + "workday/get-work-record-statistics";
    /**
     * 记工统计 月统计(第三级页面)(3.5.2)
     */
    public static final String WORK_MONTH_RECORD_STATISTICS = IP_ADDRESS_NEW + "workday/get-month-record-statistics";
    /**
     * 记工统计 项目中按工人统计 二级页面(3.5.2)
     */
    public static final String WORK_PERSON_RECORD_STATISTICS = IP_ADDRESS_NEW + "workday/get-person-record-statistics";
    /**
     * 批量工资模版设置
     */
    public static final String SET_BATCH_SALARY_TPL = IP_ADDRESS_NEW + "workday/set-batch-salary-tpl";
    /**
     * 截屏反馈
     */
    public static final String FEEDBACK_POST = WEBURLS + "my/feedback-post";
    /**
     * 获取班组
     */
    public static final String GET_GROUP_LIST = IP_ADDRESS_NEW + "group/forman-group-list";
    /**
     * 针对某个人返回点工+包工考勤模版
     */
    public static final String GET_ALL_TPL_BY_UID = IP_ADDRESS_NEW + "workday/get-all-tpl-by-uid";
    /**
     * 立即认证地址
     */
    public static final String IDCARD = WEBURLS + "my/idcard";
    /**
     * 删除包工分项模版
     */
    public static final String DELETE_SUB_PRO = IP_ADDRESS_NEW + "workday/del-contractor-tpl";
    /**
     * 获取名片信息
     */
    public static final String GET_WORK_INFO_PRO_INFO = IP_ADDRESS_NEW + "user/get-work-info-pro-info";
    /**
     * 分享到工友圈
     */
    public static final String DYNAMIC_COMMENT = WEBURLS + "dynamic/comment";
    /**
     * 完善资料
     */
    public static final String MY_RESUME = WEBURLS + "my/resume";
    /**
     * 闪验登录
     */
    public static final String FLASH_LOGIN = IP_ADDRESS + "v2/Signup/flashlogin";
    /**
     * 闪验登录
     */
    public static final String DEL_CHAT = IP_ADDRESS_NEW + "chat/del-chat";
}




