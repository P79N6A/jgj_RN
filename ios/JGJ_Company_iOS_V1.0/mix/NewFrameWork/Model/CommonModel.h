//
//  CommonModel.h
//  mix
//
//  Created by celion on 16/3/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//
#import "TYModel.h"
#import <Foundation/Foundation.h>
#import "JLGFindProjectModel.h"

#import "JGJChatRecruitMsgModel.h"

#define JGJWorkCircleDefaultHeight 95 //默认高度
#define WorkCircleTableViewHeaderHegiht 65
#define WorkCircleHeaderHegiht 40
#define WorkCircleTableViewFooterHegiht 70
#define JGJWorkCircleProGroupCellHeight 66.0
#define LineViewTop 0 //个人端保持统一。当前项目最后一个高度分开
#define BottomOffset 15
#define ProSetMemberRow 2
typedef NS_ENUM(NSInteger ,logType) {
    choicelogTemplateType,//选择日志
    pubLishNormalLogType,

};
typedef enum : NSUInteger {
    NoWorkType,
    WorkingType,
    WorkedAndFindingType
} StatusType;

//首页项目创建班组、扫码加入、关闭班组
typedef enum : NSUInteger {
    WorkCircleHeaderViewCreatGroupButtonType = 0,
    WorkCircleHeaderViewCreatSweepQrCodeButtonType,
    WorkCircleFooterViewShutGroupType,
    WorkCircleDefaultCellLoginButtonType,
    WorkCircleDefaultCellCheckProButtonType //查看项目
} WorkCircleHeaderFooterViewButtonType;

//班组成员显示类型 显示添加成员标记 、不显示标记、显示添加删除标记
typedef enum : NSUInteger {
    ShowAddTeamMemberFlagType = 1, //仅显示添加图片
    ShowAddAndRemoveTeamMemberFlagType, //显示添加移除标记图片
    DefaultTeamMemberFlagType //无标记类型
} MemberFlagType;

typedef enum : NSUInteger {
    JGJCreatTeamControllerType = 1,
    JGJTeamMangerControllerType,
    JGJAddProSourceMemberControllerType, //添加数据来源人
    JGJAddProNormalMemberControllerType //添加普通成员
} JGJTeamControllerType;

typedef enum : NSUInteger {
    CreatTeamCellBloneProType = 0,
    //    CreatTeamCellGenerateQrcodeType,
    CreatTeamCellTeamInfoType,
    CreatTeamCellTeamsType
} CreatTeamCellType;

//当前是添加通信录、还是移除班组成员
typedef enum : NSUInteger {
    JGJGroupMemberMangeAddMemberType = 1,
    JGJGroupMemberMangeRemoveMemberType,
    JGJGroupMemberMangePushNotifyType, //发送通知
    JGJAddFriendType //朋友类型添加 2.3.2
}  JGJGroupMemberMangeType;

typedef enum : NSUInteger {
    JGJNormalMemberTeamInfoVcType = 1, //班组信息
    JGJCreaterTeamMangerVcType, //班组管理
    JGJProMangerType,//超级项目管理员
    JGJProInfoType,//项目信息
    JGJSourceMemberType,//数据来源人
    JGJNormalProMangerType,//普通项目管理员
    JGJNormalProMangerAndSourceMemberType//普通项目管理员且是数据来源人
} JGJTeamMangerVcType;

//项目类型
typedef enum : NSUInteger {
    JGJProCreatTeamType = 1,
    JGJProExistedType
} JGJNewNotifyProType;

typedef enum : NSUInteger {
    WorkCircleExampleProType = 1,
    WorkCircleTrueProTye
} WorkCircleProType;

typedef enum : NSUInteger {
    JGJProMemberType = 1, //项目成员
    JGJProSourceMemberType //数据来源
} JGJMemberType;

#pragma mark - 通知类型
#define Class_types @[@"removeGroupMember", @"removeTeamMember", @"closeGroup", @"closeTeam", @"joinGroup", @"joinTeam", @"reopenGroup", @"reopenTeam", @"mergeTeam", @"splitTeam", @"syncProject", @"repulseSync", @"syncCreateTeamNotice", @"syncNoticeTarget", @"createSyncTeam", @"delSyncProject", @"syncedSyncProject", @"cloudExpiredNotice", @"cloud_lack", @"serviceExpiredNotice", @"syncGroupToGroup", @"syncedSyncGroupToGroup"]
typedef enum : NSUInteger {
    RemoveGroupMemberType = 0, //删除班组成员通知
    RemoveTeamMemberType, //删除项目组成员通知
    CloseGroupType,   //关闭班组通知
    CloseTeamType, //关闭项目组通知
    JoinGroupType,  //加入班组
    JoinTeamType, //加入项目组组
    ReopenGroupType,   //重新打开班组
    ReopenTeamType, //重新打开项目组组
    MergeTeamType,   //项目组合并
    SplitTeamType, //项目组拆分
    SyncProjectType, //要求同步项目
    //    NewBillingType, //新记账
    RepulseSyncType,
    SyncCreateTeamNoticeType,
    SyncNoticeTargetType, //同步项目给你
    CreateSyncTeamType,
    DelSyncProjectType, //表示要删除notice_id为3的消息
    SyncedSyncProjectType, //表示要更改notice_id为3的消息为已同步
    
    CloudExpiredNotice, // cloudExpiredNotice 云盘过期
    
    Cloud_lack, // cloud_lack云盘空间不足
    
    ServiceExpiredNotice,//serviceExpiredNotice 服务过期
    
    syncGroupToGroup, //记工同步请求
    
    syncedSyncGroupToGroup //记工同步通知
    
} JGJNewNotifyType;

#pragma mark - 企业端1.0添加
typedef enum : NSUInteger {
    WorkCircleTaskType,
    WorkCircleNoticeType,
    WorkCircleQualityType,
    WorkCircleSafeType,
    
    WorkCircleSignType,
    WorkCircleLogType,
    WorkCircleReportType,
    WorkCircleFormType,
    
    WorkCircleApproveType,
    WorkCircleWeatherType,
    WorkCircleKnowledgeBaseType,
    WorkCircleProMangerType
    
} WorkCircleCollectionViewCellType;

//1.1.0添加
typedef enum : NSUInteger {
    JGJCusSwitchRepulseMsgCell, //消息免打扰
    JGJCusSwitchStickMsgCell //置顶
} JGJCusSwitchMsgCellType;

//群聊和单聊区分
typedef enum : NSUInteger {
    JGJSingleChatType = 1,
    JGJGroupChatType
} JGJChatType;

typedef enum : NSUInteger {
    JGJGroupChatListDefaultVcType,
    JGJGroupChatListWorkVcType, //从项目选择
    JGJGroupChatListGroupChatType //选择群聊
} JGJGroupChatListVcType;

typedef enum : NSUInteger {
    JGJContactedAddressBookAddDefaultType,//默认是选择人员创建群聊
    JGJContactedAddressBookAddMembersVcType = 1, //当前是添加人员
    JGJGroupMangerAddMembersVcType,  //从班组管理添加人员
    JGJTeamMangerAddMembersVcType, //从项目管理添加人员
    JGJLaunchGroupChatVcType, //发起群聊排除未注册和已添加的人员
    JGJSingleChatCreatGroupChatVcType //单聊详情创建群聊
} JGJContactedAddressBookVcType;

//2.1.2
typedef enum : NSUInteger {
    JGJAddFriendSourceDefault,
    JGJAddFriendSourceMineStyle, //自己显示
    JGJAddFriendSourceQrcodeStyle, //扫一扫
    JGJAddFriendSourceAddressBookStyle,//通讯录
    JGJAddFriendSourceSearchResult//搜索结果
} JGJAddFriendSourceCellStyle;

//    1：未加入,2:已加入，3：已过期
typedef enum : NSUInteger {
    JGJFriendListDefaultMsgType,
    JGJFriendListUnAddMsgType, //1：未加入
    JGJFriendListAddedMsgType, //2:已加入
    JGJFriendListOverdueMsgType, //3：过期
} JGJFriendListMsgType;

typedef enum : NSUInteger {
    
    NotifyCellSyncButtonType = 1, //同步
    
    NotifyCellRefuseButtonType, //拒绝
    
    NotifyCellDeleteButtonType, //删除
    
    NotifyCellJoinTeamButtonType, //加入班组
    
    NotifyCellChangeProButtonType, //进入按钮按下，切换项目
    
    NotifyCellSyncGroupToGroup, //记工同步请求 3.2.0添加
    
    NotifyCellSyncedSyncGroupToGroup, //记工记账同步通知
    
//    NotifyCellSyncedSyncProjectType, //同步记工通知
    
    NotifyCellSyncNoticeTargetType //同步记工通知
    
    
} NotifyCellButtonType;


@interface CommonModel : NSObject

@end

//我的信息页面班组长
@interface MyWorkLeaderZone : CommonModel

@property (nonatomic, copy  ) NSString  *headpic;
@property (nonatomic, copy  ) NSString  *icno;
@property (nonatomic, assign) NSInteger overall;
@property (nonatomic, assign) NSInteger pros;
@property (nonatomic, assign) NSInteger userlevel;
@property (nonatomic, assign) NSInteger verified;
@property (nonatomic, assign) NSInteger wkmatecount;
@property (nonatomic, copy  ) NSString  *realname;
@property (nonatomic, copy  ) NSString  *telph;
@property (nonatomic, copy  ) NSString  *age;
@property (nonatomic, copy  ) NSString  *gender;
- (NSString *)verifiedString;
- (NSString *)roleString;
@end

//我的页面工友
@interface MyWorkZone : CommonModel

@property (nonatomic, copy  ) NSString  *headpic;
@property (nonatomic, copy  ) NSString  *nickname;
@property (nonatomic, assign) NSInteger userlevel;
@property (nonatomic, assign) NSInteger work_staus;
@property (nonatomic, assign) NSInteger reply_cnt;
@property (nonatomic, copy  ) NSString  *icno;
@property (nonatomic, copy  ) NSString  *realname;
@property (nonatomic, assign) NSInteger verified;
@property (nonatomic, copy  ) NSString  *telph;
@property (nonatomic, copy  ) NSString  *age;
@property (nonatomic, copy  ) NSString  *gender;
@property (nonatomic, copy  ) NSString  *user_name; //用户昵称>真实姓名
- (NSString *)statusString; //返回状态字符串
- (NSString *)verifiedString;
- (NSString *)roleString;
@end

@class JGJTeamMemberCommonModel;
#pragma Mark - 同步账单联系人
@interface JGJSynBillingModel :CommonModel
@property (nonatomic, copy  ) NSString  *gender;
@property (nonatomic, copy  ) NSString  *nickname;
@property (nonatomic, copy  ) NSString  *is_report;// 是不是记录员
@property (nonatomic, copy  ) NSString  *self_uid;// 已添加的同步人的id
@property (nonatomic, copy  ) NSString  *target_uid;// 已添加的同步人的id
@property (nonatomic, copy  ) NSString  *telephone;//已添加的同步人的id
@property (nonatomic, copy  ) NSString  *real_name;//已添加的同步人的名字
@property (nonatomic, copy  ) NSString  *descript;//已添加的同步人的备注
@property (nonatomic, copy  ) NSString  *firstLetteter;//已添加的同步人姓名的首字母
@property (nonatomic, copy  ) NSString  *secLetteter;//已添加的同步人名的首字母
@property (nonatomic, copy  ) NSString  *name_pinyin;//姓名全拼
/**
 * 姓名首字母全拼,大写(4.02)
 * 用于通讯录分组内排序(比如Z组内排序)
 */
@property (nonatomic, copy) NSString *nameHeadPinyin;

/**
 * 共同好友中的好友来源(4.0.2)
 */
@property (nonatomic, copy) NSString *addFrom;

@property (nonatomic, assign) NSInteger is_sync;//是否已经同步过此项目非必须返回
@property (nonatomic, strong) UIColor   *modelBackGroundColor;//模型的背景颜色
@property (nonatomic, assign) BOOL      isSelected;//是否选中当前模型
@property (nonatomic, assign) BOOL      isAddedSyn;//是否已添加
@property (nonatomic, copy  ) NSString  *name;//通信录姓名
@property (nonatomic, copy  ) NSString  *telph;// 通信录账号
@property (nonatomic, copy  ) NSString  *uid;// 记工记账通信录的uid (1.4.5添加) 该模型uid较多，没做替换
@property (assign, nonatomic) BOOL      isMoveRightButton;//根据是否显示索引右移按钮


//2.0添加
@property (nonatomic, copy) NSString *addHeadPic;//添加成员图片
@property (nonatomic, copy) NSString *removeHeadPic;//删除成员图片
@property (nonatomic, copy) NSString *head_pic;//详情pid
@property (assign, nonatomic) BOOL      isMangerModel;//根据此属性判断是不是添加和删除模型
@property (nonatomic, copy) NSString *is_creater;//是否是创建者
@property (nonatomic, copy) NSString *is_active;//是否是平台成员
@property (nonatomic, assign) JGJTeamMangerVcType teamMangerVcType;

@property (nonatomic, copy) NSString *sync_pro_num;//同步数量
//备注:该模型因最开始和通信录通用一个，和通信录相关的此阶段 用这个模型。造成字段不断增加

//1.0.2添加
@property (nonatomic, copy) NSString *synced;//是否正在同步,项目组数据来源人添加
@property (nonatomic, copy  ) NSString  *telphone;//班组详情电话

@property (nonatomic, copy) NSString *is_demand;//是否需要来源人同步
@property (nonatomic, copy) NSString *source_pro_id;//新通知来源人同步的项目id
//1.0.3添加
@property (nonatomic, assign) BOOL is_admin;//是否是普通管理员
@property (nonatomic, assign) BOOL is_source_member;//是否是数据来源人

//1.1.0添加
@property (nonatomic, strong) NSIndexPath *indexPathMember; //成员所在位置
@property (assign, nonatomic) BOOL      isRemoveModel;//是删除模型
@property (assign, nonatomic) BOOL      isAddModel;//是添加模型
@property (assign, nonatomic) BOOL      isSingleChatModel;//是否是单聊模型

@property (assign, nonatomic) BOOL      is_real_name;//没有真实姓名是

//2.1.2添加
@property (assign, nonatomic) BOOL      is_register;//用户是否注册

@property (copy, nonatomic) NSString *members_num;//显示申请好友个数

//@人时显示真实姓名
@property (copy, nonatomic) NSString *full_name;

//成员是否已存在 3.4-yj
@property (nonatomic, assign) BOOL is_exist;

@property (nonatomic, assign) BOOL is_agency; //我是否是代理班组人员

//用户是否签名
@property (nonatomic, copy) NSString *signature;

//2.3.7好友描述
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *msg_id;
@end

@interface JGJSynBillingCommonModel : CommonModel
@property (nonatomic, copy  ) NSString *synBillingTitle;// 同步账单管理标题
@property (nonatomic, assign) BOOL     isWageBillingSyn;//是否是工资清单进入同步账单页面
@end

//联系人排序后模型
@interface SortFindResultModel : CommonModel
@property (nonatomic, copy) NSString *firstLetter;
@property (nonatomic, strong ) NSMutableArray  *findResult;
@end

@interface JGJAddressBookModel : CommonModel
@property (nonatomic, copy  ) NSString *name;//通信录姓名
@property (nonatomic, copy  ) NSString *telph;// 通信录账号
@property (nonatomic, copy  ) NSString *firstLetteter;//姓名的首字母
@property (nonatomic, assign) BOOL     isAddedSyn;//是否已添加
@end

@interface JGJSyncProlistModel : CommonModel
@property (nonatomic, copy  ) NSString *pid;//项目ID
@property (nonatomic, copy  ) NSString *pro_name;// 项目名
@property (nonatomic, copy  ) NSString *tag_id;//包ID
@property (nonatomic, copy  ) NSString *sync_id;//项目同步信息的ID
@property (nonatomic, copy  ) NSString *self_uid;//被同步人的uid
@property (nonatomic, assign) BOOL     isSelected;//是否选中当前项目
@end

@interface JGJShowTimeModel : CommonModel
@property (nonatomic, assign) BOOL  ispayModel;//
@property (nonatomic, assign) BOOL  isDaySelect;//升级时是否选中的第一个默认天数

@property (nonatomic, assign) CGFloat  time;//时间显示
@property (nonatomic, assign) BOOL  isShowZero;//是否显示0
@property (nonatomic, assign) CGFloat  startTime;//开始的时间
@property (nonatomic, assign) CGFloat  endTime;//最大的时间

@property (nonatomic, assign) CGFloat  limitTime;//最长的时间限制
@property (nonatomic, assign) CGFloat  currentTime;//当前选中时长
@property (nonatomic, copy  ) NSString *timeStr;//时间显示
@property (nonatomic, assign) BOOL     isSelected;//是否选中当前时间
@property (nonatomic, assign) BOOL     isShowWorkTime;//是否显示工时
@property (nonatomic, copy)   NSString *titleStr;//如果存在，标题就洗那是titleStr
@property (nonatomic, assign) BOOL     isIntHour;//是否是整数的时间

@end

#pragma mark - 日历模型
@interface JGJCalendarModel : CommonModel
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *calendarDate;//阳历年月日
@property (nonatomic, copy) NSString *zh_year;
@property (nonatomic, copy) NSString *zh_month;
@property (nonatomic, copy) NSString *zh_day;
@property (nonatomic, copy) NSString *zh_calendarDate;//农历月日
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *festival;
@property (nonatomic, copy) NSString *all_date;
@property (nonatomic, copy) NSString *jieqi;
@property (nonatomic, copy) NSString *xishen;
@property (nonatomic, copy) NSString *fushen;
@property (nonatomic, copy) NSString *caishen;
@property (nonatomic, copy) NSString *orientation;
@property (nonatomic, copy) NSString *jishiTitle;
@property (nonatomic, copy) NSString *jishi;
@property (nonatomic, copy) NSString *yi;
@property (nonatomic, copy) NSString *ji;
@property (nonatomic, copy) NSString *favAvoidContent;//宜忌内容
@property (nonatomic, copy) NSString *jixiong;//获取到宜忌字段将jixiong_desc字段结合
@property (nonatomic, copy) NSString *jixiong_desc;
//选择吉日添加模型
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger timeinterval;//时间间隔
@property (nonatomic, assign) NSInteger favAvoidRow;//宜忌行
@property (nonatomic, assign) NSInteger favAvoidDetailRow;//宜忌详细内容行
@end

#pragma mark - 今日推荐模型

@interface JGJTodayRecomModel : CommonModel
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;
@end

#pragma mark - 记工记账编辑项目模型

@interface JGJBillEditProNameModel : CommonModel
@property (nonatomic, copy) NSString *proId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isDelete;//是否删除
@end

#pragma mark - 帮助中心模型

@interface JGJHelpCenterModel : CommonModel
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray *list;
@end

@interface JGJHelpCenterListModel : CommonModel
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end

@class JGJMyWorkCircleProListModel;
@interface JGJMyWorkCircleModel : CommonModel
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, strong) NSArray <JGJMyWorkCircleProListModel *>*list;
@end

@class JGJChatFindJobModel;
@interface JGJMyWorkCircleProListModel : CommonModel
@property (nonatomic, copy) NSString *cur_name;// 当前项目组或者班组昵称
@property (nonatomic, assign) logType logTypes;//发日志的类型是自定义选择日志还是通用日志

@property (nonatomic, copy) NSString *group_id; //班组id
@property (nonatomic, copy) NSString *team_id;//项目组id
@property (nonatomic, copy) NSString *classTypeDesc;//是班组管理、班组信息、项目管理、项目信息
@property (nonatomic, copy) NSString *proDetailButtontitle;//关闭项目、关闭同步、退出项目
@property (nonatomic, copy) NSString *group_name;//班组名字
@property (nonatomic, copy) NSString *team_name;//项目组名字
@property (nonatomic, copy) NSString *group_full_name;//班组全名 3.3.0添加
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *all_pro_name;//全称
@property (nonatomic, copy) NSString *cat_id;//模板id
@property (nonatomic, copy) NSString *bill_id;

@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, strong) NSArray *members_head_pic;
/**
 未读消息数(字符串),被处理过的,比如>99,为99+
 */
@property (nonatomic, copy) NSString *unread_msg_count;
/**
 未读消息数(整型),未被处理,真实的消息数
 */
@property (nonatomic, assign) NSInteger unreadMsgCount;

/**
 某个聊天(会话)最大的已读消息id
 */
@property (nonatomic, copy) NSString *maxReadeRdMsgId;

@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *myself_group;//区分是不是创建者
@property (nonatomic, assign) BOOL is_source_member;//区分是不是数据来源人
@property (nonatomic, copy) NSString *creater_uid;
@property (nonatomic, copy) NSString *creater_name;
//@property (nonatomic, assign) BOOL is_cloud_expire;//高级服务版是否过期 2.3.4注释掉
@property (nonatomic, assign) BOOL is_senior_expire;//云盘是否过期
@property (nonatomic, assign) BOOL tip_update;//付费提醒
@property (nonatomic, copy) NSString *creater_telp;
@property (nonatomic, copy) NSString *msg_text;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy) NSString *inviter_uid; //扫码时多一个邀请者id
@property (nonatomic, copy) NSString *class_type;//扫码时这个类型不一致,引起所以多了这个班组区分 和 group_type作用相同
@property (nonatomic, copy) NSString *class_typeIdValue; //统一使用class_typeIdValue 代替group_id team_id这里有一个需要注意的地方首页的班组和项目id后台均用的group_id
@property (nonatomic, copy) NSString *class_typeIdKey; //值为group_id 、team_id
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) WorkCircleProType workCircleProType;
@property (nonatomic, assign) JGJTeamMangerVcType teamMangerVcType; //区分班组、项目项目也类型
@property (nonatomic, assign) BOOL isClosedTeamVc;//当前班组详情页是已关闭,只能查看
@property (nonatomic, copy) NSString *team_comment;//项目组昵称

@property (nonatomic, copy) NSString *merge_last_msg_id;//2.0.2增加，用于区分消息是否是继承后的消息
//1.0.3添加
@property (nonatomic, assign) BOOL is_admin;//是否是普通管理员
@property (nonatomic, copy) NSString *at_message;//@信息
@property (nonatomic, copy) NSString *is_report;//是否是记录员

//1.1.0
@property (nonatomic, assign) BOOL is_no_disturbed;//是否免打扰
@property (nonatomic, assign) BOOL is_sticked;//是否置顶
@property (nonatomic, copy) NSString *send_time;//发送时间
@property (nonatomic, strong) NSIndexPath *indexPathPro;//项目所在行

//添加人员时排除,当前群添加的人员
@property (nonatomic, copy) NSString *cur_group_id;//当前组id
@property (nonatomic, copy) NSString *cur_class_type;//当前组类型

//添加人员时排除,当前群添加的人员
@property (nonatomic, copy) NSString *cur_group_name;//当前组名字
@property (nonatomic, copy) NSString *cur_member_num;//当前组人数

//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, assign) BOOL is_existed;//发起群聊 选择项目页面 1表示该成员已全部存在被添加的群里面 否则为0

//2.1.2-yj
@property (nonatomic, strong) JGJChatFindJobModel *chatfindJobModel;
@property (nonatomic, assign) BOOL is_find_job; //0:非招聘聊天;1：如果是招聘聊天，必传
@property (nonatomic, assign) BOOL isDynamic;//是否是动态进入聊天页面

//2.2.0

@property (nonatomic, copy) NSString *index_unread_msg_count;//首页消息未读数
@property (nonatomic, copy) NSString *work_unread_msg_count;//所有项目未读数
@property (nonatomic, copy) NSString *chat_unread_msg_count;////聊聊未读数
@property (nonatomic, copy) NSString *unread_system_count;//系统消息未读数

@property (nonatomic, copy) NSString *total_unread_msg_count;  //所有消息未读数
@property (nonatomic, copy) NSString *other_group_unread_msg_count;//其他组的未读数
@property (nonatomic, copy) NSString *unread_notice_count;  //通知未读数

@property (nonatomic, copy) NSString *unread_log_count;     //日志未读数
@property (nonatomic, copy) NSString *unread_safe_count;   //安全未读数
@property (nonatomic, copy) NSString *unread_quality_count;  //质量未读数
@property (nonatomic, copy) NSString *unread_sign_count;  //签到未读数
@property (nonatomic, copy) NSString *unread_billRecord_count;  //签到未读数

@property (nonatomic, copy) NSString *unread_task_count;     //任务未读数
@property (nonatomic, copy) NSString *unread_approval_count;   //审批未读数
@property (nonatomic, copy) NSString *unread_weath_count;  //签到未读数


@property (nonatomic, strong) JGJMyWorkCircleProListModel *group_info;//组名称、和头像


@property (nonatomic, copy) NSString *close_time;//关闭时间

@property (nonatomic, assign) BOOL isUnExpand;//是否展开

@property (nonatomic, copy) NSString *headerTilte;//查看项目头部标题

@property (nonatomic, assign) BOOL is_selected;//是否已经选中

@property (nonatomic, assign) BOOL isUnProInfo;//是否有项目的信息

//@property (nonatomic, assign) BOOL is_closed;//项目是否已关闭和isClosedTeamVc作用一样的。源代码使用的 isClosedTeamVc。当前模型已做转换

@property (nonatomic, assign) BOOL is_created_team;//是否有自己的项目，通知系统消息使用。创建项目还是加入项目

@property (nonatomic, copy) NSString *is_not_source;//是否有数据来源人记工报表使用，有数据来源人isDemo传1,否者传0

@property (nonatomic, assign) BOOL can_at_all; //是否具有@功能，创建和管理员

@property (nonatomic, copy) NSString *is_senior; //1:高级版 0：普通版

@property (nonatomic, assign) BOOL is_degrade; //是否具有降级权限

@property (nonatomic, copy) NSString *used_space; //云盘已用空间单位G

@property (nonatomic, copy) NSString *cloud_disk; //云盘总空间

//2.3.2 is_buyed当前有项目有没有购买过，免费试用
@property (nonatomic, assign) BOOL is_buyed;//是否显示免费试用按钮

//2.3.4

//未读工作消息数
@property (nonatomic, copy) NSString *work_message_num;

@property (nonatomic, copy) NSString *unread_inspect_count;//检查

@property (nonatomic, copy) NSString *unread_meeting_count;//会议

@property (nonatomic, assign) CGFloat checkProCellHeight;//查看项目cell高度

//是否是查看已关闭的项目
@property (nonatomic, assign) BOOL isCheckClosedPro;

//排除数据来源人
@property (nonatomic, copy) NSString *is_exclude_source;

//本地头像
@property (nonatomic, copy) NSString *local_head_pic;

//成员标识，加人时判断有无当前成员成员uid拼接
@property (nonatomic, copy) NSString *member_uids;

//3.4.2当前是群聊使用(招工找活关键词防骗提示yj),是昨天或者是空的信息就显示。

@property (nonatomic, copy) NSString *extent_msg;

//3.4.2当前是群聊使用(招工找活关键词防骗提示yj),YES就显示

@property (nonatomic, assign) BOOL is_show_job_alertMsg;

//H5进入招聘消息4.0.1
@property (nonatomic, strong) JGJChatRecruitMsgModel *chatRecruitMsgModel;

@end

@interface JGJClosedGroupModel : CommonModel
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *myself_group;//是否是我的群主
@property (nonatomic, copy) NSString *close_time;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, assign) BOOL canOpen;
@property (nonatomic, copy) NSArray *members_head_pic;
@property (nonatomic, copy) NSString *closed_group_count;//关闭班组个数，首页项目使用
@end

@interface JGJActiveGroupListModel : CommonModel
@property (nonatomic, strong) NSArray <JGJMyWorkCircleModel *>*list;//存储项目模型
@end

@class JGJCheckUnCloseProModel;
@interface JGJActiveGroupModel : CommonModel
/**
 *  已关闭班组
 */
@property (nonatomic, strong) JGJClosedGroupModel *closed;
///**
// *  未关闭班组
// */
//@property (nonatomic, strong) JGJActiveGroupListModel *unclose;

/**
 *  未关闭班组2.1.0修改
 */
@property (nonatomic, strong) NSArray <JGJMyWorkCircleProListModel *>*unclose;

@property (nonatomic, copy) NSString *chat_unread_msg_count;//聊天未读数

@property (nonatomic, copy) NSString *index_unread_msg_count;//首页消息未读数

@property (nonatomic, copy) NSString *work_unread_msg_count;//所有项目未读数

@property (nonatomic, copy) NSString * unread_notice_count;//工作消息数

@property (nonatomic, copy) NSString * total_unread_msg_count;//总的消息数

/**
 *  工作总高度
 */
@property (nonatomic, assign) CGFloat workCircleHeight;

/**
 *  工作圈个数
 */
@property (nonatomic, assign) NSUInteger workCircleCount;

/**
 *  是否存在我自己创建的项目
 */
@property (nonatomic, assign) BOOL isExistMyCreatTeam;

//2.2.0修改

@property (nonatomic, copy) NSString *closed_group_count;//关闭的群个数

@property (nonatomic, strong) NSArray *closed_list; //关闭的项目

@property (nonatomic, strong) JGJCheckUnCloseProModel *unclose_list;

@property (nonatomic, copy) NSString *fresh_friend_num;

@end

#pragma mark - 创建班组
@interface JGJCreatTeamModel : CommonModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) NSString *detailTitlePid;//详情pid
@property (nonatomic, copy) NSString *placeholderTitle;
@property (nonatomic, assign) BOOL isHiddenplaceholderTitle;
@property (nonatomic, strong) NSArray *teams;//班组成员
@property (nonatomic, assign) JGJTeamMangerVcType teamMangerVcType; //区分类型班组信息不能修改班组名字、班组地点、所在项目
@property (nonatomic, copy) NSString *members_num;//人员数量
@property (nonatomic, assign) BOOL isHiddenArrow;//隐藏箭头,隐藏文字

@property (nonatomic, assign) BOOL isShowGrayDetailTitle;//显示箭头,文字灰色

@property (nonatomic, assign) BOOL isOnlyContent;//隐藏箭头，显示文字

//1.1.0添加
@property (nonatomic, assign) BOOL isShowQrcode;//是否显示二维码


//颜色变化的信息 2.2.3添加
@property (nonatomic, copy) NSString *changeStr;

@property (nonatomic, strong) UIColor *changeColor;

@property (nonatomic, assign) BOOL isHiddenSubView;//是否隐藏全部控件

@property (nonatomic, copy) NSString *remarkInfo; //备用信息

@property (nonatomic, copy) NSString *pro_name; //项目名字

@property (nonatomic, copy) NSString *group_name;//班组名字

@end

#pragma mark - 班组成员模型
@interface JGJTeamMemberModel : CommonModel
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_pic;//详情pid
@property (nonatomic, copy) NSString *group_leader;//详情pid
@property (nonatomic, copy) NSString *addHeadPic;//添加成员图片
@property (nonatomic, copy) NSString *removeHeadPic;//删除成员图片
@end

#pragma mark - 班组成员模型
@interface JGJTeamMemberCommonModel : CommonModel
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) NSMutableArray *teamMemberModels;
@property (nonatomic, assign) BOOL isHiddenDeleteFlag;
@property (nonatomic, assign) NSUInteger count;//成员个数
@property (nonatomic, assign) JGJTeamControllerType teamControllerType; //创建班组 班组成员底部没有分割线，和人数
@property (nonatomic, strong) UIColor *headerTitleColor;//设置成员显示顶部标题背景色
@property (nonatomic, strong) UIColor *headerTitleTextColor;//设置成员显示顶部标题文字颜色
@property (nonatomic, strong) UIFont *headerTitleFont;//设置成员显示顶部标题文字大小
@property (nonatomic, assign) JGJMemberType memberType;//成员类型

//2.0发版前新需求弹框点击头像需要人员电话，和姓名。
@property (nonatomic, strong) JGJSynBillingModel *teamModelModel;
@property (nonatomic, copy) NSString *alertmessage;
@property (nonatomic, assign) CGFloat alertViewHeight;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) CGFloat lineSpace;

//2.0.2是否显示底部按钮
@property (nonatomic, assign) BOOL isHidden; //是否显示按钮
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic, assign) BOOL isRemoveSynMember; //移除同步人

//2.1.0添加
@property (nonatomic, copy) NSString *classType;//成员所属班组还是项目组
@end

#pragma mark - 新通知模型
//通知购买服务成功回调
typedef void(^NotifyServiceSuccessBlock)(id);

@interface JGJNewNotifyModel : CommonModel
@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, strong) NSArray *members_head_pic;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, copy) NSString *team_name;
@property (nonatomic, copy) NSString *split_befor; //拆分前
@property (nonatomic, copy) NSString *split_after; //拆分后

@property (nonatomic, copy) NSString *merge_befor; //合并前
@property (nonatomic, copy) NSString *merge_after; //合并后
//合并后的字符串
@property (nonatomic, copy) NSString *mergeStr;

@property (nonatomic, assign) BOOL isSuccessSyn;//是否成功 同步、订购

@property (nonatomic, assign) BOOL isRefused;//是否拒绝

@property (nonatomic, assign) BOOL isJoinTeam;//是否加入班组

@property (nonatomic, assign) JGJNewNotifyType notifyType; //通知类型

@property (nonatomic, copy) NSString *uid;//同步人的uid

@property (nonatomic, copy) NSString *team_id;//项目组id

@property (nonatomic, copy) NSString *group_id;//班组id

@property (nonatomic, copy) NSString *pro_id;//项目id 个人端用

@property (nonatomic, copy) NSString *target_uid;//自己的uid,这里用于同步人的uid

@property (nonatomic, assign) BOOL isReaded;//该通知是否读取

@property (nonatomic, copy) NSString *can_click;//该条通知能否点击

@property (nonatomic, copy) NSString *members_num;//成员数量

//2.0.2添加
@property (nonatomic, copy) NSString *myself_group;//区分是不是创建者
@property (nonatomic, assign) BOOL iSNotifySynCreatTeam;//是工作消息创建项目
@property (nonatomic, assign) BOOL iSNotifyJoinExistTeam;//是工作消息加入现有项目组
@property (nonatomic, copy) NSString *source_pro_id;//来源人同步的项目id
@property (nonatomic, copy) NSString *pro_name;//来源人同步的项目名。创建之后项名称和项目组名称一样team_name
@property (nonatomic, copy) NSString *team_comment;//项目组昵称
@property (nonatomic, copy) NSString *del_notice_id;//需更改的通知id delSyncProject syncedSyncProject 表示要更改notice_id为3的消息为已同步
@property (nonatomic, copy) NSString *merge_last_msg_id;//2.0.2增加，用于区分消息是否是继承后的消息

@property (nonatomic, assign) BOOL isExistMyCreatTeam;

//2.0.3添加
@property (nonatomic, assign) BOOL is_admin;//是否是普通管理员

@property (nonatomic, assign) CGFloat cellHeight;

//2.3.0 系统消息详情过期、云盘空间不足
@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *cloud_space; //购买的云盘空间

@property (nonatomic, copy) NSString *senior_person; //购买人数

@property (nonatomic, copy) NSString *used_space; //已使用云盘大小

@property (nonatomic, copy) NSString *cloud_lave_days; //云盘剩余天数

@property (nonatomic, copy) NSString *service_lave_days; //云盘剩余天数

@property (nonatomic, copy) NSString *sync_type; //同步类型。拒绝同步记工记账传1 ，同步项目记工传2

@end

#pragma mark - 班组成员
@interface JGJMemberListModel : CommonModel
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *telphone;
@end

#pragma mark - 班组信息
@interface JGJGroupInfoModel: CommonModel
@property (nonatomic, copy) NSString *class_type;// 班组类型
@property (nonatomic, copy) NSString *group_id; //班组id
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *group_name;//班组名字
@property (nonatomic, copy) NSString *team_name; //项目组名字
@property (nonatomic, copy) NSString *group_team_name; //group_name、team_name中间变量后面全用这个变量
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *team_comment; //项目组项目组名称
@property (nonatomic, copy) NSString *team_all_comment; //项目组项目组名称全名

@property (nonatomic, assign) BOOL is_admin;

@property (nonatomic, assign) BOOL is_creater;

@property (nonatomic, assign) BOOL is_senior;

@property (nonatomic, assign) NSInteger buyer_person;

@property (nonatomic, assign) NSInteger max_person;

@property (nonatomic, assign) BOOL is_cloud_expire;

@property (nonatomic, assign) BOOL is_senior_expire;

@property (nonatomic, assign) BOOL is_degrade;

//是否购买过当前产品
@property (nonatomic, assign) BOOL is_buyed;

//项目设置试用描述
@property (nonatomic, copy) NSString *buyed_desc;
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, assign) BOOL is_nickname;// 标识是否在班组内设置过名称
@end

@class JGJTeamServiceModel;
#pragma mark - 班组信息模型
@interface JGJTeamInfoModel : CommonModel
@property (nonatomic, copy) NSString *class_type; //班组和项目组类型
@property (nonatomic, copy) NSString *group_id; //班组id
@property (nonatomic, copy) NSString *team_id; //项目组id
@property (nonatomic, copy) NSString *class_TypeId; //项目组id 和班组id的中间变量

@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*member_list; //班组成员
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*team_members;//项目组成员
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*team_group_members;//中间变量替换 member_list、team_members

@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*report_user_list; //班组汇报对象
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*source_members; //项目组数据来源人
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *>*source_report_members; //中间变量替换 report_user_list、source_members
@property (nonatomic, strong) JGJGroupInfoModel *group_info; //班组详情
@property (nonatomic, strong) JGJGroupInfoModel *team_info; //项目组详情
@property (nonatomic, strong) JGJGroupInfoModel *team_group_info; //中间变量

@property (nonatomic, copy) NSString *can_split;//项目组能否被拆分，只有创建者自己创建的项目才能被拆分
@property (nonatomic, copy) NSString *source_members_num;//数据来源人数量
@property (nonatomic, copy) NSString *nickname;//昵称

@property (nonatomic, copy) NSString *admins_num;//管理员数量
@property (nonatomic, copy) NSString *members_num;//成员数量
@property (nonatomic, assign) BOOL is_admin;//我是否是普通管理员


//1.1.0
@property (nonatomic, assign) BOOL is_no_disturbed;//消息是否免打扰
@property (nonatomic, assign) BOOL is_sticked;//是否已置顶
@property (nonatomic, strong) NSArray *members_head_pic; //二维码显示的人头像

//2.3.0

@property (nonatomic, strong) NSArray <JGJTeamServiceModel *> *current_server;

@property (nonatomic, assign) BOOL is_senior; //是否是黄金会员

@property (nonatomic, assign) BOOL is_cloud;

@property (nonatomic, assign) BOOL is_senior_expire; //黄金会员是否过期

@property (nonatomic, assign) BOOL is_cloud_expire; //云盘是否过期

@property (nonatomic, assign) NSInteger buyer_person; //和当前人数作比较，判断是否升级人数

@property (nonatomic, assign) NSInteger max_person; //最大人数

//是否升级人数，实现里判断
@property (nonatomic, assign) BOOL isUpdatePer;

//是否具有降级权限
@property (nonatomic, assign) BOOL is_degrade;

@property (nonatomic, assign) NSInteger cur_member_num; //和当前选择人数作比较，判断是否升级人数

@property (nonatomic, copy) NSString *is_creater; //是否是创建者

//2.3.4 在线客户信息

@property (nonatomic, strong) JGJSynBillingModel *online_service;

@property (nonatomic, copy) NSString *group_full_name;//班组全名

//创建者uid

@property (nonatomic, copy) NSString *creater_uid;
@end

#pragma mark - 项目模型
@interface JGJProjectListModel : CommonModel
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *is_create_group;
@property (nonatomic, assign) BOOL isSelected; //项目是否选中
@property (nonatomic, assign) JGJNewNotifyProType proType;
@property (nonatomic, assign) BOOL isModifyPro;//当前是否能修改
@end

#pragma mark - 广告位模型
@interface JGJADModel : CommonModel
@property (nonatomic, copy) NSString *link_type;
@property (nonatomic, copy) NSString *link_key;
@property (nonatomic, copy) NSString *link_api;
@property (nonatomic, copy) NSString *img_path;

@property (nonatomic, copy) NSString *client; //唯一id

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *aid;
@end

@interface JGJADLinkKeyModel : CommonModel
//storyboard
@property (nonatomic, copy) NSString *storyboard_name;
@property (nonatomic, copy) NSString *vc_id;

//class
@property (nonatomic, copy) NSString *vc_class_name;

@end

//#pragma mark - 企业版1.0添加
//#pragma mark - 首页项目模型
//@interface JGJWorkCircleMiddleInfoModel : CommonModel
//@property (nonatomic, copy) NSString *InfoImageIcon;
//@property (nonatomic, copy) NSString *desc;
//@property (nonatomic, copy) NSString *unread_msg_count; //工作消息未读数
//@property (nonatomic, assign) WorkCircleCollectionViewCellType cellType;
//@end

//创建项目描述
@interface JGJCreatProDecModel : CommonModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@end

@interface JGJMergeSplitProModel : CommonModel
@property (nonatomic, copy) NSString *team_name;
@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *source_members_num;
@property (nonatomic, strong) NSArray *members_head_pic;
@property (nonatomic, strong) NSString *unread_msg_count;
@property (nonatomic, copy) NSString *creater_name;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface JGJShareProDesModel : CommonModel
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desTitle;
@property (copy, nonatomic) NSString *popTitle;
@property (copy, nonatomic) NSString *popDetail;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) BOOL isSplitDes;//是不是拆分说明
@property (assign, nonatomic) CGFloat contentViewHeight;
@property (copy, nonatomic) NSString *leftTilte; //按钮标题
@property (copy, nonatomic) NSString *rightTilte;
@property (assign, nonatomic) CGFloat lineSapcing;
@property (assign, nonatomic) NSTextAlignment popTextAlignment;

//隐藏左边按钮
@property (assign, nonatomic) BOOL isHiddenLeftButton;

//改变颜色的字体
@property (copy, nonatomic) NSString *changeContent;

//是否隐藏在线聊天按钮
@property (assign, nonatomic) BOOL isShowOnlineChatButton;

@property (assign, nonatomic) CGFloat onlineChatButtonH;

//信息底部距离
@property (assign, nonatomic) CGFloat messageBottom;


@property (nonatomic, assign) CGFloat checkProCellHeight;//查看项目cell高度

//显示标题
@property (assign, nonatomic) BOOL isShowTitle;

@property (assign, nonatomic) CGFloat titleLableTop;

@property (strong, nonatomic) UIFont *titleFont;

@property (strong, nonatomic) UIFont *messageFont;

@end

@interface JGJSplitProModel : CommonModel
@property (nonatomic, copy) NSString *team_name;
@property (nonatomic, copy) NSString *team_num;
@property (nonatomic, strong) NSArray <JGJMergeSplitProModel *>*list;//拆模型数组
@end

#pragma mark - 同步项目班组 项目组合并提示
@interface JGJSynMergecheckModel : CommonModel
@property (nonatomic, copy) NSString *from_pro_name;
@property (nonatomic, copy) NSString *from_team_name;
@property (nonatomic, copy) NSString *to_pro_name;
@end

#pragma mark - 聊天页面头部信息人数和姓名
@interface JGJTitleInfoModel : CommonModel
@property (nonatomic, copy) NSString *group_name; //班组名字
@property (nonatomic, copy) NSString *team_comment; //项目组名字
@property (nonatomic, copy) NSString *members_num; //人数
@end

#pragma mark - 2.0.2添加
#pragma mark -现有项目组信息
@interface JGJExistTeamInfoModel : CommonModel
@property (nonatomic, copy) NSString *team_id; //讨论组ID
@property (nonatomic, copy) NSString *team_name; //	讨论组名称
@property (nonatomic, assign) BOOL     isSelected;//是否选中当前项目组
@property (nonatomic, copy) NSString *pro_name; //	项目名称
@property (nonatomic, copy) NSString *mergeProName;//拼接的项目

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *pro_id;

@property (nonatomic, copy) NSString *group_name;

@end

#pragma mark - 同步项目列表

@interface JGJSourceSyncThirdInfoModel : CommonModel
@property (nonatomic, strong) NSMutableArray <JGJSyncProlistModel *>*list; //已同步项目列表
//@property (nonatomic, copy) NSString *count;//项目数量
@end

@interface JGJSourceSynProSeclistModel : CommonModel
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *real_name;//同步人的姓名
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *is_demand; //是否要求同步
@property (nonatomic, strong) JGJSourceSyncThirdInfoModel *sync_unsource;
@property (nonatomic, strong) JGJSourceSyncThirdInfoModel *sync_source;
@property (nonatomic, copy) NSString *source_pro_id;
@property (nonatomic, assign) BOOL isSelectedSource;
@property (nonatomic, strong) JGJSynBillingModel *synMemberModel; //同步人信息
@end

@interface JGJSyncProCountModel : CommonModel
@property (nonatomic, copy) NSString *sync_source_person_count;
@property (nonatomic, copy) NSString *sync_unsource_person_count;
@end

@interface JGJSourceSynProFirstModel : CommonModel
@property (nonatomic, strong) JGJSyncProCountModel *sync_count;
@property (nonatomic, strong) NSArray <JGJSourceSynProSeclistModel *>*list;
@property (nonatomic, strong) NSArray *selectedSync_sources;
//@property (nonatomic, copy) NSString *source_pro_id;
@property (nonatomic, copy) NSString *is_demand; //是否要求同步
@end

//1.1.0优化添加人员
@interface JGJAddressBookSortContactsModel : CommonModel
@property (nonatomic, strong) NSMutableArray *contactsLetters;//包含首字母
@property (nonatomic, strong) NSMutableArray <SortFindResultModel *> *sortContacts;//排序后联系人
@property (nonatomic, assign) BOOL isCacheSuccess;//缓存是否成功

@end

@interface JGJMineInfoThirdModel : CommonModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) NSString *workerIcon;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) BOOL isShowQrcode;//是否显示二维码
@property (nonatomic, assign) BOOL isShowRemark;//是否显示备注

@property (nonatomic, assign) BOOL is_unshow_detail_Flag;//是否Image

@property (nonatomic, assign) BOOL is_hidden_detail;

@end

@interface JGJMineInfoSecModel : CommonModel
@property (nonatomic, strong) NSArray <JGJMineInfoThirdModel *>*mineInfos;
@end

@interface JGJMineInfoFirstModel : CommonModel
@property (nonatomic, strong) NSArray<JGJMineInfoSecModel *> *mineInfos;
@end

@interface JGJAdminListModel : CommonModel
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray <JGJSynBillingModel *>*list;
@end

@interface JGJChatInputViewInfoModel : CommonModel
@property (nonatomic, copy) NSMutableAttributedString *inputStr; //输入文字信息
@property(nonatomic) NSRange selectedRange;
@end

@interface JGJUpdateVerInfoModel : CommonModel
@property (nonatomic, copy) NSString *downloadLink;//应用包的下载地址 IOS时返回值为空
@property (nonatomic, assign) NSUInteger ifaddressBook; //	是否上传通讯录 0：不上传，1上传
@property (nonatomic, assign) NSUInteger forceUpdate; //是否强制更新版本 0：不更新 1：更新 2强制更新
@property (nonatomic, copy) NSString *upinfo;//版本更新说明
@end

//1.1.0添加
@interface JGJChatDetailInfoCommonModel : CommonModel
@property (nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) JGJCusSwitchMsgCellType switchMsgType;
@end

@interface JGJChatPerInfoModel : CommonModel
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *comment_name;//备注名字
@property (nonatomic, copy) NSString *chat_name;
@property (nonatomic, assign) BOOL is_black; //对方是否已在黑名单列表
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, copy) NSString *top_name;//单聊标题name

//2.1.2  1:未加入；2已加入；3已过期
//@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) BOOL is_chat; //能聊天

@property (nonatomic, assign) BOOL is_friend;//能加为朋友

@property (nonatomic, assign) BOOL is_hidden; //后台给的隐藏打电话

//发帖的文字
@property (nonatomic, copy) NSString *content;

//发帖的图片
@property (nonatomic, strong) NSArray *pic_src;

//共同好友
@property (nonatomic, strong) NSArray <JGJSynBillingModel *> *common_friends;

//用户是否签名
@property (nonatomic, copy) NSString *signature;

//签名文字高度
@property (nonatomic, assign) CGFloat headHeight;

// 4.0.1添加
/** 添加好友时发送的验证信息 */
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) JGJFriendListMsgType status;

@end

@interface JGJSingleChatModel : CommonModel
@property (nonatomic, copy) NSString *class_type;//当前类型安卓对相同类型需特殊处理
@property (nonatomic, strong) NSMutableArray <JGJSynBillingModel *> *member_list;//单聊人员
@end

//2.1.2添加朋友来源类型
@interface JGJAddFriendStyleModel : CommonModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *des;
//@property (nonatomic, copy) NSString *styleImageViewStr;
@property (nonatomic, assign) BOOL isShowQrcode;//是否显示二维码
@property (nonatomic, assign) JGJAddFriendSourceCellStyle addFriendSourceCellStyle;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *telephone;
@end

@interface JGJAddFriendSendMsgModel : CommonModel
@property (nonatomic, copy) NSString *msg_text;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) BOOL isSelected;

//消息高度
@property (nonatomic, assign) CGFloat height;

@end

@interface JGJFreshFriendListModel : CommonModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sendMsg;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, assign) BOOL isAdded; //已添加
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *msg_text;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) JGJFriendListMsgType status; //当前信息状态  1：未加入,2:已加入，3：已过期
//账单model
@end

@interface JGJChatFindHelperModel : CommonModel
@property (nonatomic, copy) NSString *work_year;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *work_name;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, assign) NSInteger role_type; //工人/工头
@end

@interface JGJChatFindJobModel : CommonModel

@property (nonatomic, copy) NSString *class_type;

//值时1，2，3。3是已认证
@property (nonatomic, copy) NSString *verified;

@property (nonatomic, strong) JLGFindProjectModel *prodetailactive; //找工作、找项目
@property (nonatomic, strong) JGJChatFindHelperModel *searchuser;//找帮手
@property (nonatomic, copy) NSString *group_name;//当前用户姓名，和班组、项目组一致
@property (nonatomic, copy) NSString *group_id; //当前用户id，和班组、项目组一致
@property (nonatomic, assign) NSInteger is_chat;//能不能聊天，不能聊天跳转到加为朋友页面
@property (nonatomic, assign) NSInteger isProDetail;

@property (nonatomic, copy) NSString *work_name; //当前工种

/**
 * h5加载的页面的标识
 * 找活招工:job 人脉资源:connection 工友圈:dynamic
 */
@property (nonatomic, copy) NSString *page;


@end

@interface JGJShowShareDynamic : CommonModel
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dynamicId;
@end

@class JGJWXMiniModel;

@interface JGJShowShareMenuModel : CommonModel
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, strong) JGJShowShareDynamic *dynamic;
@property (nonatomic, strong) JGJWXMiniModel *wxMini;

//是否显示保存按钮

@property (nonatomic, assign) BOOL is_show_savePhoto;

@property (nonatomic, strong) UIImage *shareImage;

/**
 是否显示"吉工家好友","工友圈","面对面分享"
 */
@property (nonatomic, assign) NSInteger topdisplay;




@end

@class JGJTaskPubManModel;

@interface  JGJNotifyDetailMembersModel : CommonModel

@property (nonatomic, strong) NSArray *replyList; //已回复

@property (nonatomic, strong) NSArray *unrelay_members; //未反馈 members

@property (nonatomic, strong) NSArray *members; //已收到

@property (nonatomic, strong) JGJTaskPubManModel *pub_man; //已收到

@property (nonatomic, copy) NSString *create_date;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *is_can_deal;

@property (nonatomic, copy) NSString *readed_percent;

@property (nonatomic, copy) NSString *task_content;

@property (nonatomic, copy) NSString *task_done_time;

@property (nonatomic, copy) NSString *task_finish_time;

@property (nonatomic, strong) NSArray *task_imgs;

@property (nonatomic, copy) NSString *task_level;

@property (nonatomic, copy) NSString *task_status;

@property (nonatomic, copy) NSString *team_or_group_name;

@end

@interface JGJCheckUnCloseProModel : CommonModel

@property (nonatomic, copy) NSString *work_unread_msg_count;

@property (nonatomic, copy) NSString *chat_unread_msg_count;

@property (nonatomic, copy) NSString *unread_notice_count;

@property (nonatomic, copy) NSString *total_unread_msg_count;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, strong) NSArray *unclose; //存储未关闭的项目

@end

@interface JGJTeamServiceModel : CommonModel

@property (nonatomic, copy) NSString *first_title_name;

@property (nonatomic, copy) NSString *second_title_name;

@property (nonatomic, copy) NSString *is_expired;

//当前服务类型 1，(升级人数,续订)2(续订)
@property (nonatomic, copy) NSString *server_id;


//"buy_type":1://黄金版人数 "buy_type":2://黄金版续期

//"buy_type":3://云盘空间 "buy_type":4://云盘空间续期

@property (nonatomic, copy) NSString *buy_type;

//服务弹框描述
@property (nonatomic, copy) NSString *server_type_tip;

//服务类型
@property (nonatomic, copy) NSString *server_type;
@end
//发布者
@interface JGJTaskPubManModel : CommonModel

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *uid;

@end

@interface JGJLogoutItemDesModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desInfo;

//描述文字高度
@property (nonatomic, assign) CGFloat desH;

@property (nonatomic, strong) UIColor *desInfoColor;

@end

@interface JGJLoginUserInfoModel : NSObject

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *free_dates;

@property (nonatomic, copy) NSString *has_realname;

@property (nonatomic, copy) NSString *verified;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *is_info;

@property (nonatomic, copy) NSString *double_info;

@property (nonatomic, copy) NSString *is_bind;//是否绑定手机号

@property (nonatomic, copy) NSString *telephone;

//用户是否签名
@property (nonatomic, copy) NSString *signature;

@end

//微信小程序
@interface JGJWXMiniModel : NSObject

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *path;

//分享出去的图片
@property (nonatomic, strong) UIImage *wxMiniImage;

@property (nonatomic, copy) NSString *typeImg;

@end

@interface JGJLogoutReasonModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, assign) BOOL isSel;

//是否是其他原因
@property (nonatomic, assign) BOOL isOther;

@end

@interface JGJDynamicMsgNumModel : NSObject

@property (copy, nonatomic) NSString *comment_num; //新的评论消息数

@property (copy, nonatomic) NSString *liked_num; //新的点赞消息数

@property (copy, nonatomic) NSString *fans_num; //新的粉丝数

@end
