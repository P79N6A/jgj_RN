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
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJChatListNoticeVc ()

@property (weak, nonatomic) IBOutlet UIButton *releaseNoticeButton;

@end

@implementation JGJChatListNoticeVc
- (void)dataInit{
    [super dataInit];
    
    [self.releaseNoticeButton.layer setLayerCornerRadius:JGJCornerRadius];
    self.title = @"通知";
    self.msgType = @"notice";
    if (self.workProListModel.isClosedTeamVc) {

        _heightConstance.constant = 0;
        _releaseNoticeButton.hidden = YES;
        
    }else{
        
        _heightConstance.constant = 63;
        _releaseNoticeButton.hidden = NO;
    }
    
    [self delUnread_notice_work_count];
}

- (void)delUnread_notice_work_count {
    

    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_notice_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_notice_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
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


@end
