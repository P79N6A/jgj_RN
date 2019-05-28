//
//  JGJChatMsgTopTimeView.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgTopTimeView.h"

#import "JGJCusYyLable.h"

#import "JGJTime.h"

#import "NSDate+Extend.h"

@interface JGJChatMsgTopTimeView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *dateLable;


@end

@implementation JGJChatMsgTopTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.dateLable.textColor = AppFont666666Color;
    
    self.dateLable.font = [UIFont systemFontOfSize:AppFont24Size];
}

-(void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    _jgjChatListModel = jgjChatListModel;
    
    NSString *type = @"";
    
    NSString *topTimeDes = [NSDate chatMsgListShowDateWithTimeStamp:jgjChatListModel.send_time];
    
    if (jgjChatListModel.msg_total_type == JGJChatNormalMsgType) {// 普通聊天消息
        
        self.dateLable.text = topTimeDes;
        
    }else if (jgjChatListModel.msg_total_type == JGJChatWorkMsgType) {// 工作类型消息
        
        if (jgjChatListModel.chatListType == JGJChatListQuality) {// 质量
            
            type = @"质量";
            
        }else if (jgjChatListModel.chatListType == JGJChatListSafe) {// 安全
            
            type = @"安全";
            
        }else if (jgjChatListModel.chatListType == JGJChatListInspectType) {// 检查
            
            type = @"检查";
            
        }else if (jgjChatListModel.chatListType == JGJChatListTaskType) {// 任务
            
            type = @"任务";
            
        }else if (jgjChatListModel.chatListType == JGJChatListNotice) {// 通知
            
            type = @"通知";
            
        }else if (jgjChatListModel.chatListType == JGJChatListMeeting) {// 会议
            
            type = @"会议";
            
        }else if (jgjChatListModel.chatListType == JGJChatListApproveType) {// 审批
            
            type = @"审批";
            
        }else if (jgjChatListModel.chatListType == JGJChatListLog) {// 日志
            
            type = @"日志";
        }else if (jgjChatListModel.chatListType == JGJChatListOssType) {// 云盘
            
            type = @"云盘";
            
        }else if (jgjChatListModel.chatListType == JGJChatListCancellSyncBillType || jgjChatListModel.chatListType == JGJChatListCancellSyncProjectType || jgjChatListModel.chatListType == JGJChatListRefuseSyncBillType || jgjChatListModel.chatListType == JGJChatListRefuseSyncProjectType || jgjChatListModel.chatListType == JGJChatListDemandSyncBillType ||  jgjChatListModel.chatListType == JGJChatListDemandSyncProjectType || jgjChatListModel.chatListType == JGJChatListSyncBillToYouType || jgjChatListModel.chatListType == JGJChatListSyncProjectToYouType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectType || jgjChatListModel.chatListType == JGJChatListagreeSyncBillType || jgjChatListModel.chatListType == JGJChatListCreateNewTeamType || jgjChatListModel.chatListType == JGJChatListJoinTeamType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {
            
            type = @"同步项目";
            
        }else if (jgjChatListModel.chatListType == JGJChatListJoinType || jgjChatListModel.chatListType == JGJChatListReopenType || jgjChatListModel.chatListType == JGJChatListRemoveType || jgjChatListModel.chatListType == JGJChatListCloseType || jgjChatListModel.chatListType == JGJChatListSwitchgroupType || jgjChatListModel.chatListType == JGJChatListFriendType) {
           
            type = @"工作消息";
            
        }
        
    }else if (jgjChatListModel.msg_total_type == JGJChatRecruitMsgType) {// 招聘类型消息
        
        type = @"招聘小助手";
    }else if (jgjChatListModel.msg_total_type == JGJChatActivityMsgType) {
        
        if (jgjChatListModel.chatListType == JGJChatListIntegralType) {
            
            type = @"积分";
        }else if (jgjChatListModel.chatListType == JGJChatListLocalGroupChatType || jgjChatListModel.chatListType == JGJChatListWorkGroupChatType) {
            
            type = @"活动消息";
        }
        
    }
    
    self.dateLable.text = [NSString stringWithFormat:@"%@ %@",type,topTimeDes];
    
    JGJChatListBelongType belongType = self.jgjChatListModel.belongType;
    
    TYWeakSelf(self);
    
    
    self.dateLable.textAlignment = NSTextAlignmentLeft;
    
    self.dateLable.backgroundColor = AppFontf1f1f1Color;
    
}

@end
