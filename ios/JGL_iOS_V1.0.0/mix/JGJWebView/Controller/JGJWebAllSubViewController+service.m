//
//  JGJWebAllSubViewController+service.m
//  mix
//
//  Created by yj on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJWebAllSubViewController+service.h"

#import "JGJChatRootVc.h"
#import "JGJDataManager.h"

@implementation JGJWebAllSubViewController (service)

#pragma mark - 找工作、招聘
- (void)handleH5ChatRecruitWithDic:(NSDictionary *)dic {
    
    JGJChatRecruitMsgModel *chatRecruitMsgModel = [JGJChatRecruitMsgModel mj_objectWithKeyValues:dic];
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
//    chatFindJobModel.isProDetail = YES; //招工信息进入聊天页面
    
//    proListModel.chatfindJobModel = chatFindJobModel;
    proListModel.class_type = @"singleChat";
//
    //这句是保证group_id唯一性用了setter方法
    
    proListModel.team_id = nil;
    
    proListModel.team_name = nil;
//
    proListModel.group_id = chatRecruitMsgModel.group_id; //个人uid
    
    proListModel.group_name = chatRecruitMsgModel.group_name;
    
    proListModel.is_find_job = YES;
    
//    //先赋值招聘信息
//    chatRootVc.chatRecruitMsgModel = chatRecruitMsgModel;
    
    proListModel.chatRecruitMsgModel = chatRecruitMsgModel;
    
    //在赋值组信息
    chatRootVc.workProListModel = proListModel;
    
    
    [self.navigationController pushViewController:chatRootVc animated:YES];
    
    TYWeakSelf(self);
    
    chatRootVc.chatRootBackBlock = ^{
        
        weakself.webView.frame = weakself.view.bounds;
        
    };
}

@end
