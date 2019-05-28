//
//  JGJChatMsgListModel.h
//  mix
//
//  Created by Tony on 2016/8/31.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"
#import "JGJChatListType.h"

#import "JGJChatRecruitMsgModel.h"

//3.4添加
typedef enum : NSUInteger {
    
    JGJChatAskSynType, //要求同步项目情况
    
    JGJChatRefuseSynType, //拒绝同步
    
    JGJChatAgreeSynType, //同意同步
    
    JGJChatCreatProType, //创建新项目
    
    JGJChatJoinproType, //加入现有项目
    
    JGJChatSynedproType, //同步了记工数据
    
} JGJChatSynBtnType;

typedef enum : NSUInteger {
    
    JGJChatNormalMsgType, //普通消息
    
    JGJChatWorkMsgType, //工作消息
    
    JGJChatActivityMsgType, //活动消息
    
    JGJChatRecruitMsgType,// 招聘消息
    JGJChatNewFriendsMsgType,// 新的好友
    
    JGJChatMsgSystemType //系统消息签到、加入等
    
} JGJChatMsgType; //全部的消息大类

extern NSString *const chatMsgTimeFormat;

@class JGJChatMsgListModel,ChatMsgList_Read_info,ChatMsgList_Read_User_List,JGJChatMsgExtendContentModel, JGJChatMsgExtendMsgContentModel;

@interface JGJChatOtherMsgListModel : TYModel

@property (nonatomic, copy) NSString *s_date;

@property (nonatomic, copy) NSString *fmt_date;

@property (nonatomic, strong) NSArray<JGJChatMsgListModel *> *list;

@end

//聊天用户模型
@interface JGJChatUserInfoModel : TYModel

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *head_pic;

//聊天用的名字
@property (nonatomic, copy) NSString *real_name;

//At用的名字
@property (nonatomic, copy) NSString *full_name;

@end

//聊天扩展content模型
@interface JGJChatMsgExtendContentModel : TYModel

@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *field;
@end

//聊天扩展msg_content模型
@interface JGJChatMsgExtendMsgContentModel : TYModel

@property (nonatomic, copy) NSString *system_msg;
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, assign) NSInteger all_num;
@property (nonatomic, assign) NSInteger today_num;
@property (nonatomic, assign) NSInteger view_count;
@property (nonatomic, copy) NSString *jump_url;

@end

//聊天扩展模型
@interface JGJChatMsgExtendModel : TYModel

@property (nonatomic, copy) NSString *cur_role;
@property (nonatomic, copy) NSString *pro_name;
@property (nonatomic, copy) NSArray<JGJChatMsgExtendContentModel *> *content;
@property (nonatomic, strong) JGJChatMsgExtendMsgContentModel *msg_content;

@end



typedef enum : NSUInteger {
    
    JGJShowMenuCopyType, //复制
    
    JGJShowMenuResendType, //重发
    
    JGJShowMenuDelType, //删除
    
    JGJShowMenuReCallType, //撤回
    
    JGJForwardMenuReCallType,// 转发
    
} JGJShowMenuType;

#pragma mark - JGJChatMsgListModel

@interface JGJChatMsgListModel : TYModel

//@property (nonatomic, copy) NSString *msg_id;
@property (nonatomic, copy) NSString *create_time;

@property (nonatomic,assign) BOOL IsCloseTeam;
@property (nonatomic, assign) BOOL chatRoomGoin;//从聊天室进入

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *id;


@property (nonatomic, copy) NSString *cat_name;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *real_name;//At人员使用

@property (nonatomic, strong) UIColor *user_nameColor;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *head_pic;

//@property (nonatomic, copy) NSString *group_id;

//@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSArray <NSString *>*msg_src;

@property (nonatomic, strong) ChatMsgList_Read_info *read_info;

@property (nonatomic,copy) NSString *is_out_member;

@property (nonatomic,copy) NSString *voice_long;

@property (nonatomic, assign) BOOL isAudioPlaying;// 语音是否被播放过
//@property (nonatomic,copy) NSString *class_type;

@property (nonatomic,copy) NSString *uid;
@property (nonatomic, strong) NSString *week_day;

//记账的id
@property (nonatomic,copy) NSString *bill_id;

//记账类型
@property (nonatomic,copy) NSString *accounts_type;

//记账类型
@property (nonatomic,copy) NSString *sign_id;

@property (nonatomic,copy) NSArray *pic_w_h;

@property (nonatomic,copy) NSString *at_uid;

@property (nonatomic,copy) NSString *from_group_name;
//本地自己添加的数据

@property (nonatomic,assign) JGJChatListSendType sendType;

@property (nonatomic,copy) NSString *voice_filePath;

//@property (nonatomic,copy) NSString *local_id;

@property (nonatomic,assign) JGJChatListType chatListType;

@property (nonatomic,assign) BOOL isDefaultText;

@property (nonatomic,assign) JGJChatListBelongType belongType;

@property (nonatomic,copy) NSString *displayDate;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *myself_group;


@property (nonatomic,copy) NSString *reply_uid;//回复指定人的UID

//已经播放了
@property (nonatomic,assign) BOOL isplayed;

//图片类型消息对应的图片
@property (nonatomic,strong) UIImage *picImage;

//上传图片的进度
@property (nonatomic,assign) CGFloat progress;

//项目名称
@property (nonatomic,copy) NSString *pro_name;

//上次发送是否失败了,主要用于替换数据的时候
@property (nonatomic,assign) BOOL isFailed;
////用户uid
//@property (nonatomic,copy) NSString *msg_sender;

//2.1.1添加五种类型，用于显示当前是否有未读信息对应标记小红点
@property (nonatomic,copy) NSString *notice;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,copy) NSString *quality;

@property (nonatomic,copy) NSString *billRecord;

@property (nonatomic,copy) NSString *safe;

//2.1.2-yj
//@property (nonatomic, strong) JGJChatFindJobModel *chatfindJobModel;

@property (nonatomic,assign) BOOL is_find_job; //0:非招聘聊天;1：如果是招聘聊天，必传

//找工作、招聘消息存入数据库用
@property (nonatomic, copy) NSString *job_detail;

@property (nonatomic, strong) JGJChatFindJobModel *msg_prodetail;

@property (nonatomic,copy) NSString *msg_type_num; //获取添加人员信息，人员数量当前类型 msg_type = add_friends

//当前消息发送之后服务器回传的状态 (消息状态 0。成功  1.失败  2.发送中)
@property (nonatomic,copy) NSString *msg_state;

@property (nonatomic, assign) BOOL is_qr_code; //是否是二维码加入班组或者项目组

@property (nonatomic, assign) CGFloat cellHeight; //当前cell高度
@property (nonatomic, assign) CGFloat workCellHeight; //当前工作消息 招聘小组手 活动消息 cell高度

@property (nonatomic, assign) CGFloat cellWidth; //当前文字宽度

@property (nonatomic, assign) CGFloat norMsgWidth; //普通消息，文字宽度、这里在plus6自己算宽度，有换行符有问题

@property (nonatomic, assign) CGSize imageSize;//等比例缩放一个图片尺寸

@property (nonatomic, strong) NSIndexPath *msgIndexPath; //消息的位置

@property (nonatomic,copy) NSString *weat_am; //通知列表用的发送时间
@property (nonatomic,copy) NSString *weat_pm; //通知列表用的发送时间
@property (nonatomic,copy) NSString *wind_am; //通知列表用的发送时间
@property (nonatomic,copy) NSString *wind_pm; //通知列表用的发送时间
@property (nonatomic,copy) NSString *techno_quali_log; //通知列表用的发送时间
@property (nonatomic,copy) NSString *temp_am; //通知列表用的发送时间
@property (nonatomic,copy) NSString *temp_pm; //通知列表用的发送时间
@property (nonatomic, copy) NSString *task_finish_time; //任务完成时间
@property (nonatomic, assign) BOOL is_can_deal; //是否具有修改任务状态的权限
@property (nonatomic, copy) NSString *task_finish_time_type; //1 任务已过期 2 临近过期 3 有截止时间 0 没有截止时间
@property (nonatomic, copy) NSString *task_level; //任务等级
@property (nonatomic, copy) NSString *task_status; //任务状态 0:待处理；1:已完成

//2.2.3添加

//是否整改（1：整改；0：不需要），如果是msg_type为quality，safe时
@property (nonatomic, copy) NSString *is_rectification;

//严重程度（1：一般,2:严重），如果是msg_type为quality，safe时

@property (nonatomic, copy) NSString *severity;

//location	否	string	位置，如果是msg_type为quality，safe时

@property (nonatomic, strong) NSString *location;

//principal_uid	否	int	负责人（与字段is_rectification连用）（v2.2.3）
@property (nonatomic, copy) NSString *principal_uid;

//finish_time	是	int	完成时间（如果：20160909）
@property (nonatomic, copy) NSString *finish_time;

//statu	否	int	1:待整改；2：待复查；3：已完结，如果是msg_type为quality，safe时
@property (nonatomic, copy) NSString *statu;

//	如果取原来的位置，
@property (nonatomic, copy) NSString *location_id;

//检查分项id 2.3.0
@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, copy) NSString *pu_inpsid;

//3.0.0 @使用的姓名
@property (nonatomic, copy) NSString *full_name;

// 通知接收人id
@property (nonatomic, copy) NSString *rec_uid;

//3.4测试字段

// 活动标题
@property (nonatomic, copy) NSString *act_title;

// 活动描述
@property (nonatomic, copy) NSString *act_des;

//是否隐藏查看按钮
@property (nonatomic, assign) BOOL isHiddenCheckBtn;

//外部读用户数据
@property (nonatomic, strong) NSString *wcdb_user_info;


// v3.4聊聊WCDB字段
@property (nonatomic, assign) NSInteger primary_key;//主键id

@property (nonatomic, copy) NSString *local_id;// 本地消息id

@property (nonatomic, copy) NSString *members_num;// 成员个数

@property (nonatomic, assign) NSInteger wcdb_msg_id;

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *origin_group_id;// 原始的班组group_id 工作类型消息需要

@property (nonatomic, copy) NSString *origin_class_type;// 原始的班组class_type 工作类型消息需要
@property (nonatomic, copy) NSString *extend_int;
@property (nonatomic, copy) NSString *send_time;

@property (nonatomic, copy) NSString *server_head_pic;

@property (nonatomic, copy) NSString *local_head_pic;

@property (nonatomic, copy) NSString *msg_sender;

@property (nonatomic, copy) NSString *send_name;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *recall_time;

@property (nonatomic, assign) NSInteger unread_members_num;

@property (nonatomic, assign) NSInteger readed_members_num;

@property (nonatomic, assign) BOOL is_send_success;

//用户的唯一标识
@property (nonatomic, copy) NSString *user_unique;

//消息类型 普通消息 normal 系统消息 system 红点 reddot
@property (nonatomic, copy) NSString *sys_msg_type;

// 活动描述
@property (nonatomic, copy) NSString *telephone;

//消息总类型
@property (nonatomic, assign) JGJChatMsgType msg_total_type;

//当前消息用户信息模型,数据库单存储 send_name(real_name) telephone uid(send_uid)
@property (nonatomic, strong) JGJChatUserInfoModel *user_info;

//相册唯一地址标示
@property (nonatomic, copy) NSString *assetlocalIdentifier;

//已读回执readed  别人查看回执received
@property (nonatomic, copy) NSString *type;

//当前消息是否已读
@property (nonatomic, copy) NSString *is_readed;

//当前消息是否已确认接收
@property (nonatomic, copy) NSString *is_received;

// 3.4 工作之类的推送消息 cc添加detail
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSMutableAttributedString *htmlStr;
@property (nonatomic, copy) NSString *at_message;// @人的标识
@property (nonatomic, copy) NSString *role_type;// 活动消息用
@property (nonatomic, assign) NSInteger offLine_message_count;
// 招聘需要的字段
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

// 通知列表 新增字段
@property (nonatomic, copy) NSString *send_date_str;
@property (nonatomic, copy) NSString *send_date;
@property (nonatomic, assign) BOOL is_recieve;

//能在聊天显示 work_message  工作消息是0,1 ,普通聊天是0,2
@property (nonatomic, assign) NSInteger work_message;

//status 查看评价是这个是角色 1，2。质量、安全、日志删除。
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *can_recive_client;// app端能显示的消息类型

@property (nonatomic, copy) NSString *modify;

//是普通聊天样式
@property (nonatomic, assign) BOOL is_normal;

//是否是普通消息
@property (nonatomic, assign) BOOL is_normal_msg;

//修改后的用户头像
@property (nonatomic, copy) NSString *modify_head_pic;

//聊聊消息延展模型
@property (nonatomic, strong) JGJChatMsgExtendModel *extend;

//聊天延展模型
@property (nonatomic, copy) NSString *wcdb_extend;


//4.0.1招工信息

@property (nonatomic, strong) JGJChatRecruitMsgModel *recruitMsgModel;

//招聘、招工、认证存数据库
@property (nonatomic, copy)   NSString *msg_text_other;

//分享链接模型
@property (nonatomic, strong) JGJChatShareLinkModel *shareMenuModel;

//本地消息类型。用于招工、名片进入聊天临时显示用 local_recruitment (临时招聘类型)、local_postcard(临时名片)
@property (nonatomic, copy) NSString *local_msg_type;

//分享数据  is_source => 1
//转发数据  is_source => 2
@property (nonatomic, assign) NSInteger is_source;

@end

#pragma mark - ChatMsgList_Read_info

@interface ChatMsgList_Read_info : TYModel

@property (nonatomic, strong) NSArray<ChatMsgList_Read_User_List *> *unread_user_list;

@property (nonatomic, copy) NSString *unread_user_num;

@property (nonatomic, strong) NSArray<ChatMsgList_Read_User_List *> *readed_user_list;

@end

#pragma mark - ChatMsgList_Read_User_List

@interface ChatMsgList_Read_User_List : TYModel

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, strong) UIColor *nameColor;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *uid;
@end

#pragma mark - JGJChatOfflineMsgModel

@interface JGJChatOfflineMsgModel : TYModel

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, strong) NSArray <JGJChatMsgListModel *>*list;

@end

#pragma mark - JGJApsMsgModel

//吉工家苹果推送消息

@interface JGJApsMsgModel : NSObject

@property (nonatomic, copy) NSString *alert;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *badge;

@end

