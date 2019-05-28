//
//  JGJBaseOutMsgView.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBaseOutMsgView.h"

#import "UIButton+JGJUIButton.h"

@interface JGJBaseOutMsgView ()

@end

@implementation JGJBaseOutMsgView

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
    
    [self setSubViewsUI];
}

-(void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    _jgjChatListModel = jgjChatListModel;
    
    self.contentLabel.hidden = YES;
    
    //设置头像
    [self setHeadPicWithJgjChatListModel:jgjChatListModel];
    
    //设置大小
    [self setSubViewsUIFrame:jgjChatListModel];
    
    //设置时间未读数
    self.topTimeView.jgjChatListModel = jgjChatListModel;
    
    
    if (jgjChatListModel.belongType != JGJChatListBelongMine || jgjChatListModel.chatListType == JGJChatListPic) {
        
        [self stopAnimating];
        
    }else {
        
        //我自己发送的消息状态处理
        
        [self myMsgSendType];

    }
}

#pragma mark -自己发送的消息状态

- (void)myMsgSendType{
    
    self.sendFailureImageView.hidden = YES;
    
    switch (_jgjChatListModel.sendType) {
            
        case JGJChatListSendSuccess:{
            
             [self stopAnimating];
            
        }
            break;
            
        case JGJChatListSendFail:{
        
            [self stopAnimating];
            
            self.sendFailureImageView.hidden = NO;
        }
        
            break;
            
        case JGJChatListSendDefault:
        case JGJChatListSendStart:{
            
            [self startAnimating];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setHeadPicWithJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
 
    if (jgjChatListModel.msg_total_type == JGJChatNormalMsgType) {// 普通聊天消息
        
        UIColor *backGroundColor = [NSString modelBackGroundColor:jgjChatListModel.user_name];
        
        [self.headBtn setMemberPicButtonWithHeadPicStr:jgjChatListModel.head_pic memberName:jgjChatListModel.user_name?:@"" memberPicBackColor:backGroundColor];
        
        self.headBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        
    }else if (jgjChatListModel.msg_total_type == JGJChatWorkMsgType) {// 工作类型消息
        
        if (jgjChatListModel.chatListType == JGJChatListQuality) {// 质量
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_quality") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListSafe) {// 安全
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_safe") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListInspectType) {// 检查
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_check") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListTaskType) {// 任务
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_task") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListNotice) {// 通知
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_notice") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListMeeting) {// 会议
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_meeting") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListApproveType) {// 审批
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_approve") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListLog) {// 日志
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_log") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListOssType) {// 云盘
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_cloud_dish") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListCancellSyncBillType || jgjChatListModel.chatListType == JGJChatListCancellSyncProjectType || jgjChatListModel.chatListType == JGJChatListRefuseSyncBillType || jgjChatListModel.chatListType == JGJChatListRefuseSyncProjectType || jgjChatListModel.chatListType == JGJChatListDemandSyncBillType ||  jgjChatListModel.chatListType == JGJChatListDemandSyncProjectType || jgjChatListModel.chatListType == JGJChatListSyncBillToYouType || jgjChatListModel.chatListType == JGJChatListSyncProjectToYouType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectType || jgjChatListModel.chatListType == JGJChatListagreeSyncBillType || jgjChatListModel.chatListType == JGJChatListCreateNewTeamType || jgjChatListModel.chatListType == JGJChatListJoinTeamType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {// 项目同步类型
            
            [self.headBtn setBackgroundImage:IMAGE(@"synchronization_project") forState:(UIControlStateNormal)];
            
        }else if (jgjChatListModel.chatListType == JGJChatListJoinType || jgjChatListModel.chatListType == JGJChatListReopenType || jgjChatListModel.chatListType == JGJChatListRemoveType || jgjChatListModel.chatListType == JGJChatListCloseType || jgjChatListModel.chatListType == JGJChatListSwitchgroupType || jgjChatListModel.chatListType == JGJChatListDismissGroupType || jgjChatListModel.chatListType == JGJChatListFriendType) {
            
            [self.headBtn setBackgroundImage:IMAGE(@"working_inner_type") forState:(UIControlStateNormal)];
        }
        
    }else if (jgjChatListModel.msg_total_type == JGJChatRecruitMsgType) {// 招聘类型消息
        
        [self.headBtn setBackgroundImage:IMAGE(@"recruit_signPics") forState:(UIControlStateNormal)];
    }else if (jgjChatListModel.msg_total_type == JGJChatActivityMsgType) {// 活动类型消息
        
        if (jgjChatListModel.chatListType == JGJChatListIntegralType || jgjChatListModel.chatListType == JGJChatListLocalGroupChatType || jgjChatListModel.chatListType == JGJChatListWorkGroupChatType) {
            
            [self.headBtn setBackgroundImage:IMAGE(@"activity_integral") forState:(UIControlStateNormal)];
        }
        
    }
    
    
}

- (void)setSubViewsUI {
    
    CGFloat padding = ChatPadding;

    UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding, ChatHeadWH, ChatHeadWH)];
    
    [headBtn addTarget:self action:@selector(checkMemberInfo) forControlEvents:UIControlEventTouchUpInside];

    self.headBtn = headBtn;
    
    [self addSubview:headBtn];
    
    JGJChatMsgTopTimeView *topTimeView = [[JGJChatMsgTopTimeView alloc] init];
    
    self.topTimeView = topTimeView;
    
    [self addSubview:topTimeView];
    
    JGJCusYyLable *date = [[JGJCusYyLable alloc] init];
    
    self.date = date;
    
    UIView *containView = [[UIView alloc] init];
    
    self.containView = containView;
    
    containView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:containView];
    
//    UIImageView *popImageView = [[UIImageView alloc] init];
//
//    UIImage *outImage = [UIImage imageNamed:@"Chat_listWhitePOP"];
//
//    popImageView.image = [outImage resizableImageWithCapInsets:UIEdgeInsetsMake(outImage.size.height - 13 , outImage.size.width / 2, 9.6, outImage.size.width / 2 - 5) resizingMode:UIImageResizingModeStretch];
//
//    self.popImageView = popImageView;
//
//    [containView addSubview:popImageView];
//
//    JGJCusYyLable *contentLable = [[JGJCusYyLable alloc] init];
//
//    contentLable.numberOfLines = 0;
//
//    contentLable.font = [UIFont systemFontOfSize:AppFont32Size];
//
//    contentLable.textColor = AppFont000000Color;
//
//    self.contentLabel = contentLable;
//
//    [containView addSubview:contentLable];
    
    self.backgroundColor = AppFontf1f1f1Color;
    
    UIImageView *sendFailureImageView = [[UIImageView alloc] init];
    
    sendFailureImageView.image = [UIImage imageNamed:@"Chat_sendFail"];
    
    sendFailureImageView.hidden = YES;
    
    self.sendFailureImageView = sendFailureImageView;
    
    [self addSubview:sendFailureImageView];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [indicatorView stopAnimating];
    
    indicatorView.hidden = YES;
    
    indicatorView.hidesWhenStopped = YES;
    
    self.indicatorView = indicatorView;
    
    [self addSubview:indicatorView];
    
}

#pragma mark - 子类使用
- (void)setSubViewsUIFrame:(JGJChatMsgListModel *)jgjChatListModel{
    
    CGFloat padding = ChatPadding;
    
    self.headBtn.frame = CGRectMake(padding, padding, ChatHeadWH, ChatHeadWH);
    
    self.topTimeView.frame = CGRectMake(TYGetMaxX(self.headBtn) + padding, TYGetMinY(self.headBtn), TYGetUIScreenWidth - (TYGetMaxX(self.headBtn) + padding), 14);
    
    self.containView.frame = CGRectMake(TYGetMaxX(self.headBtn) + padding, PopViewY, jgjChatListModel.cellWidth, jgjChatListModel.workCellHeight - 38);
    self.containView.layer.borderWidth = 0.5;
    self.containView.layer.borderColor = AppFontccccccColor.CGColor;
    self.containView.clipsToBounds = YES;
    self.containView.layer.cornerRadius = 3;
        
}

- (void)startAnimating {
    
    [self.indicatorView startAnimating];
    
    self.indicatorView.hidden = NO;
}

- (void)stopAnimating {
    
    [self.indicatorView stopAnimating];
    
    self.indicatorView.hidden = YES;
}

- (void)checkMemberInfo {
    
    if ([self.delegate respondsToSelector:@selector(baseMsgView:msgModel:)]) {
        
        [self.delegate baseMsgView:self msgModel:_jgjChatListModel];
        
    }
}

@end
