//
//  JGJChatListType.h
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"
#import "TYSingleton.h"


/**
 *  amrFilePath:amr文件的路径
 *  fileName:amr文件的名字
 *  filePath:wav文件的路径
 *  fileName:amr文件的路径
 *  fileSize:文件的大小
 *  fileTime:文件的时间
 */


typedef enum : NSUInteger {
    JGJChatListDefault = 0,
    JGJChatListText,//文字
    JGJChatListAudio,//语音
    JGJChatListRecord,//记账
    JGJChatListNotice,//通知
    JGJChatListSafe,//安全
    JGJChatListQuality,//质量
    JGJChatListMemberJoin,//加入的信息
    JGJChatListReadInfo,//未读消息
    JGJChatListLog,//施工日志
    JGJChatListSign,//签到
    JGJChatListCount,//统计
    JGJChatListPic,//单一图片
    JGJChatListRecall,//撤回
    JGJChatListDefaultText,//默认只显示文字的类型
    JGJChatListSingleChat,//单聊
    JGJChatListGroupChat,//群聊
    JGJChatListProDetailType,//找工作找帮手聊天类型  2.1.2-yj
    JGJChatListAddGroupFriendType, //添加朋友返回的数据
    JGJChatActivityType, //活动类型 3.4添加
    JGJChatSynInfoType, //同步类型
    JGJChatRecruitType, //招聘类型
    JGJChatListMeeting,// 会议类型
    JGJChatListChecking,// 检查类型
    JGJChatListTaskType,// 任务类型
    JGJChatListApproveType,// 审批类型
    JGJChatListSyncGroupToGroupType,// 记工同步请求
    JGJChatListSyncedSyncGroupToGroupType,//记工同步通知
    JGJChatListSyncNoticeTargetType,// 对你同步项目
    JGJChatListJoinType,// 加入班组组
    JGJChatListSyncProjectType,// 被要求同步项目
    JGJChatListInspectType,// 检查inspect
    JGJChatListAgreeFriendsType,// 好友请求通过
    JGJChatListAgreeFriendsNoticeType, // 我同意别人好友请求
    JGJChatListRemoveType,// 被移除班组
    JGJChatListCloseType,// 收到关闭班组或者项目组推送
    JGJChatListReopenType,// 收到项目重启推送
    JGJChatListSwitchgroupType,// 收到转让管理权限
    JGJChatListOssType,// 云盘消息推送
    JGJChatListEvaluateType,// 评价推送
    JGJChatListIntegralType,// 积分推送
    
    
    JGJChatListDelmemberType, //删除成员收到的推送，聊天界面系统消息类型显示
    JGJChatListDismissGroupType, //群主解散群通知
    
    JGJChatListUpgradeGroupChatType, //本班组由群聊升级而来
    
    JGJChatListCancellSyncBillType,// 取消同步记账（记工记账）
    JGJChatListCancellSyncProjectType,// 取消同步项目（记工）
    JGJChatListRefuseSyncBillType,//拒绝同步记工
    JGJChatListDemandSyncBillType,//要求同步记工
    JGJChatListSyncBillToYouType,//记工同步通知
    JGJChatListCreateNewTeamType,//创建新项目组
    JGJChatListJoinTeamType,//加入现有项目组
    JGJChatListRefuseSyncProjectType,//拒绝同步项目
    JGJChatListSyncProjectToYouType,//对你同步项目
    JGJChatListDemandSyncProjectType,//要求同步项目
    JGJChatListAgreeSyncProjectType,// 同意同步项目
    JGJChatListagreeSyncBillType,// 同意同步记工
    JGJChatListAgreeSyncProjectToYouType,// 同意对你同步项目的类型
    JGJChatListFriendType,// 好友注册通知 
    JGJChatListLocalGroupChatType, // 加入当地群
    JGJChatListWorkGroupChatType,// 加入工种群
    JGJChatListBottomDefaultSpaceType,// 底部空白cell类型
    JGJChatListModifyNameType,// 修改项目名称
    JGJChatListActivityType,// 活动消息类型(图文展示)
    
    JGJChatListAuthpassType, //劳务认证审核已通过
    JGJChatListAuthfailType, //劳务认证审核未通过
    JGJChatListAuthexpiredType, //劳务认证过期通知
    JGJChatListAuthdueType, //劳务认证临近到期通知
    JGJChatListWorkremindType, //新工作提醒
    JGJChatListProjectInfoType, //招工情况消息
        
    JGJChatListFeedbackType, //举报反馈消息
    
    JGJChatListBillRecord,//出勤公示 3.5.0添加
    
    JGJChatLocalPostcardType, //4.0.1 本地名片消息类型
    
    JGJChatLocalRecruitmentType,//4.0.1 本地招工消息类型
    JGJChatLocaLVerifiedType,//4.0.1 本地是否 认证消息
    
    JGJChatPostcardType,//4.0.1 服务器名片消息类型
    
    JGJChatRecruitmentType,//4.0.1 服务器招工消息类型
    JGJChatAuthType,//4.0.1 认证消息类型
    JGJChatListLinkType,//4.0.1 分享链接消息类型

    JGJChatListPostCensorType,//4.0.2活动消息 帖子违规
    
    JGJChatListUnKonownMsgType,// 未知消息类型
    
    
} JGJChatListType;

typedef enum : NSUInteger {
    JGJChatListBelongDefault = 0,
    JGJChatListBelongMine,//自己的
    JGJChatListBelongOther,//别人的,但是是项目组内的
    JGJChatListBelongGroupOut,//项目组外的
} JGJChatListBelongType;


typedef enum : NSUInteger {
    JGJChatListSendDefault = 0,
    JGJChatListSendStart,//开始发送
    JGJChatListSendSuccess,//成功
    JGJChatListSendFail,//失败
    JGJChatListSending//正在发送
} JGJChatListSendType;


typedef NS_ENUM(NSUInteger, JGJChatListIdentityType) {
    JGJChatListIdentityCreater,
    JGJChatListIdentityManage,
    JGJChatListIdentityMember,
};

@interface JGJChatListTypeModel : TYModel

TYSingleton_interface(chatListTypeModel)

@property (nonatomic,copy) NSArray  *listTypeColor;

@property (nonatomic,copy) NSArray  *listTypeImgs;

@property (nonatomic,copy) NSArray  *listTypeTitles;

@property (nonatomic,copy) NSArray  *listTypePOPImgsOther;

@property (nonatomic,copy) NSArray  *listTypePOPImgsMine;
@end

@interface JGJChatRootRequestModel : TYModel

@property (nonatomic, copy) NSString *last_msg_id;//最后一条信息的id

@property (nonatomic, copy) NSString *group_id;//班组ID

@property (nonatomic, copy) NSString *ctrl;//控制器名

@property (nonatomic, copy) NSString *action;//massegeList

@property (nonatomic, copy) NSString *msg_type;//all 全部,notice通知,log 日志,signIn 签到,safe 安全,quality 质量

@property (nonatomic, copy) NSString *pageturn;//@"pre"向上翻页，@"next"向下翻页,刚进来也是向下翻页

@property (nonatomic, copy) NSString *class_type;
@end
