//
//  JGJMyChatGroupsVc+chatWorkReplyAction.m
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsVc+chatWorkReplyAction.h"

#import "JLGCustomViewController.h"

#import "JGJChatRootVc.h"

#import "JGJQRCodeVc.h"

#import "JGJCreatTeamVC.h"

#import "JGJCheckProListVc.h"

#import "JGJWorkReplyViewController.h"

#import "PopoverView.h"

#import "JGJCommonButton.h"

@implementation JGJMyChatGroupsVc (chatWorkReplyAction)

#pragma mark - 聊天按钮按下

- (void)chatBtnPressed {
    
    [self handleButtonPressed:JGJMyChatGroupsChatActionType];
    
}

#pragma mark - 工作回复按钮按下

- (void)workReplyBtnPressed {
    
    [self handleButtonPressed:JGJMyChatGroupsWorkReplyActionType];
    
}

#pragma mark - 处理工作回复、聊天、其他项目按钮按下
- (void)handleButtonPressed:(JGJMyChatGroupsActionType)actionType {
    
    UIViewController *nextVc = nil;
    switch (actionType) {
            
        case JGJMyChatGroupsChatActionType:{
            
            nextVc = [self handleChatAction:self.proListModel.group_info];
            
        }
            
            break;
            
        case JGJMyChatGroupsWorkReplyActionType:{
            
            nextVc = [self workReplyButtonAction];
            
            self.proListModel.work_message_num = @"0";
            
            // 清空工作回复数
            [JGJChatMsgDBManger updateIndexWorkReplyUnreadToIndexTableWithGroup_id:self.proListModel.group_info.group_id class_type:self.proListModel.group_info.class_type work_message_num:@"0"];
        }
            
            break;
            
        case JGJMyChatGroupsSwitchGroupsActionType:{
            
            JGJCheckProListVc *proListVc = [JGJCheckProListVc new];
            
            proListVc.proListModel = self.proListModel.group_info;
            
            nextVc = proListVc;
            
        }
            
            break;
            
        case JGJMyChatGroupsQRSweepActionType:{
            
            JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];
            
            jgjQRCodeVc.popVc = self;
            
            nextVc = jgjQRCodeVc;
            
        }
            
            break;
            
        case JGJMyChatGroupsCreatGroupActionType:{
            
            JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
            
            creatTeamVC.popVc = self;
            
            nextVc = creatTeamVC;
            
        }
            
            break;
            
        default:
            break;
    }
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:nextVc animated:YES];
                
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:nextVc animated:YES];
    }
    
    //刷新未读数
    [self.collectionView reloadData];
}

#pragma mark - 聊天界面
- (UIViewController *)handleChatAction:(JGJMyWorkCircleProListModel *)worlCircleModel {
    
    JGJChatRootVc *chatRootVc;
    if ([worlCircleModel.class_type isEqualToString:@"team"] ||
        [worlCircleModel.class_type isEqualToString:@"group"] ) {
        chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    }
    
    chatRootVc.workProListModel = worlCircleModel;
    
    TYWeakSelf(self);
    
    chatRootVc.chatRootVcBackBlock = ^(JGJMyWorkCircleProListModel *workProListModel) {
        
        weakself.proListModel.group_info.unread_msg_count = @"0";
    };
    
    return chatRootVc;
    
}

#pragma mark - 工作回复
- (UIViewController *)workReplyButtonAction {
    
    JGJMyWorkCircleProListModel *proListModel = self.proListModel.group_info;
    
    JGJWorkReplyViewController *workNoticeVC = [[UIStoryboard storyboardWithName:@"JGJWorkReplyViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJWorkReplyVC"];
    
    workNoticeVC.WorkproListModel = proListModel;
    
    return workNoticeVC;
}

- (void)moreBtnPressed:(UIButton *)sender {
    
    PopoverView *popoverView = [PopoverView popoverView];
    
    popoverView.style = PopoverViewStyleDark;
    
    [popoverView showToView:sender withActions:[self JGJChatActions]];
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)checkIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    
    __weak typeof(self) weakSelf = self;
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"RichScan"] title:@"扫一扫" handler:^(PopoverAction *action) {
        
        [weakSelf handleButtonPressed:JGJMyChatGroupsQRSweepActionType];
        
    }];
    
    PopoverAction *creatProAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_home_New project"] title:@"新建班组" handler:^(PopoverAction *action) {
        
        [weakSelf handleButtonPressed:JGJMyChatGroupsCreatGroupActionType];
        
    }];
    
    return @[creatProAction,sweepAction];
    
}

- (void)creatRightItem {
    
    JGJCommonButton *rightButton = [JGJCommonButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 52, 40);
    
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [rightButton setImage:[UIImage imageNamed:@"chatlist_more_icon"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(moreBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

@end
