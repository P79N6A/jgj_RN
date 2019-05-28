//
//  JGJChatListSafeVc.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListSafeVc.h"
#import "JGJChatNoticeVc.h"

@interface JGJChatListSafeVc ()

@property (weak, nonatomic) IBOutlet UIButton *releaseSafeButton;


@end

@implementation JGJChatListSafeVc

- (void)dataInit{
    [super dataInit];
    
    self.title = @"安全";
    
    [self.releaseSafeButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.msgType = @"safe";
}

- (IBAction)releaseSafeButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    JGJChatNoticeVc *noticeVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
    noticeVc.pro_name = self.workProListModel.pro_name;
    noticeVc.chatListType = JGJChatListSafe;
    noticeVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:noticeVc animated:YES];
    
}

@end
