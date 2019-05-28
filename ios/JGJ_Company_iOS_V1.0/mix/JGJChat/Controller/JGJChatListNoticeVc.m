//
//  JGJChatListNoticeVc.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListNoticeVc.h"

#import "JGJChatNoticeVc.h"

#import "JGJQualityMsgReplyListVc.h"

#import "JGJMsgFlagView.h"

#import "JGJHelpCenterTitleView.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJChatListNoticeVc ()

@property (weak, nonatomic) IBOutlet UIButton *releaseNoticeButton;

@property (strong, nonatomic) JGJMsgFlagView *msgFlagView; //新消息标记

@end

@implementation JGJChatListNoticeVc
- (void)dataInit{
    [super dataInit];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewNotifyType;
    
    titleView.title = @"通知";
    
    self.navigationItem.titleView = titleView;
    
    [self.releaseNoticeButton.layer setLayerCornerRadius:JGJCornerRadius];
    self.title = @"通知";
    self.msgType = @"notice";
    if (self.workProListModel.isClosedTeamVc) {
        
        _noticeConstance.constant = 0;
        _releaseNoticeButton.hidden = YES;
    }
    [self delUnread_notice_work_count];
}

- (void)delUnread_notice_work_count {
    
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_notice_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
}

#pragma mark - 消息回复列表
- (void)replyButtonClick {
    
    JGJQualityMsgReplyListVc *msgReplyListVc = [JGJQualityMsgReplyListVc new];
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    commonModel.msg_type = @"notice";
    
    msgReplyListVc.commonModel = commonModel;
    
    msgReplyListVc.proListModel = self.workProListModel;
    
    [self.navigationController pushViewController:msgReplyListVc animated:YES];
    
}

- (IBAction)releaseNoticeButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    JGJChatNoticeVc *noticeVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
    noticeVc.pro_name = self.workProListModel.pro_name;
    noticeVc.chatListType = JGJChatListNotice;
    noticeVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:noticeVc animated:YES];
    
}

- (JGJMsgFlagView *)msgFlagView {
    
    if (!_msgFlagView) {
        
        _msgFlagView = [[JGJMsgFlagView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        
        [_msgFlagView setHiddenFlagView:YES];
    }
    
    return _msgFlagView;
}

#pragma mark - 接收的通知回复消息
- (void)socketRequestReceiveMessage{
    
    __weak typeof(self) weakSelf = self;
    
    [JGJSocketRequest WebSocketAddMonitor:@{@"ctrl":@"message",@"action":@"reciveMessage"} success:^(id responseObject) {
        
        NSString *classType = responseObject[@"msg_type"];
        
        if ([classType isEqualToString:@"reply_notice"]) {
            
            [weakSelf.msgFlagView setHiddenFlagView:NO];
        }
        
    } failure:nil];
}

#pragma mark - 小铃铛标识
- (void)freshMessage {
    
    [self.msgFlagView setHiddenFlagView:!self.is_new_message];
}

@end
