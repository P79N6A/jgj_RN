//
//  JGJChatListBaseVc+SelService.m
//  mix
//
//  Created by yj on 2018/8/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc+SelService.h"

#import "JGJReadRootInfoVc.h"

#import "JLGCustomViewController.h"

#import "JGJPerInfoVc.h"

@interface JGJChatListBaseVc()

@end

@implementation JGJChatListBaseVc (SelService)

- (void)chatMsgTopTimeView:(JGJChatMsgTopTimeView *)topTimeView chatMsgModel:(JGJChatMsgListModel *)chatMsgModel {
    
    JGJReadRootInfoVc *readRootInfoVc = [JGJReadRootInfoVc new];
    
    readRootInfoVc.chatMsgListModel = chatMsgModel;
    
    JLGCustomViewController *nav = (JLGCustomViewController *)self.view.window.rootViewController;

    [self pushVc:readRootInfoVc];
    
}

- (void)registerAddObserverModifyNameNotify {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleModifyNameNotify:) name:JGJAddObserverModifyNameNotify object:nil];
    
    //修改用户头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleModifyNameNotify:) name:JGJAddObserverModifyUserHeadPicNotify object:nil];
    
}

- (void)handleModifyNameNotify:(NSNotification *)notify {
    
    JGJChatPerInfoModel *perInfoModel = notify.object;
    
    [self modifyUserInfo:perInfoModel];
    
    TYLog(@"-----修改了名字");
    
}

//点击头像跳转到他的资料
- (void)handleClickAvatarWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = msgModel.user_info.uid;
    
    perInfoVc.jgjChatListModel.group_id = msgModel.group_id;
    
    perInfoVc.jgjChatListModel.class_type = msgModel.class_type;
    
    //转换对象
    JGJMyWorkCircleProListModel *archProListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.workProListModel]];
    
    //这里用于看是否修改单聊名字
    perInfoVc.workProListModel = archProListModel;
    
    TYWeakSelf(self);
    
    perInfoVc.modifyUserInfoBlock = ^(JGJChatPerInfoModel *perInfoModel) {
        
        [weakself modifyUserInfo:perInfoModel];
    };
    
    if (self.skipToNextVc) {
        
        
        self.skipToNextVc(perInfoVc);
    }
}

- (void)baseMsgView:(JGJBaseOutMsgView *)baseMsgView msgModel:(JGJChatMsgListModel *)msgModel {

    [self handleClickAvatarWithMsgModel:msgModel];
}

- (void)modifyUserInfo:(JGJChatPerInfoModel *)perInfoModel {
    
    //修改临时数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender == %@", perInfoModel.uid];
    
    NSArray *chatModels = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    
    NSString *common_name = perInfoModel.comment_name;
    
    if (![NSString isEmpty:perInfoModel.comment_name]) {
        
        common_name = perInfoModel.comment_name;
        
    }else if (![NSString isEmpty:perInfoModel.chat_name]) {
        
        common_name = perInfoModel.chat_name;
        
    }else if (![NSString isEmpty:perInfoModel.real_name]) {
        
        common_name = perInfoModel.real_name;
        
    }
    
    for (JGJChatMsgListModel *chatMsgModel in chatModels) {
        
        chatMsgModel.user_name = common_name;
        
        JGJChatUserInfoModel *userInfo = [JGJChatUserInfoModel mj_objectWithKeyValues:[chatMsgModel.user_info mj_keyValues]];
        
        chatMsgModel.modify_head_pic = perInfoModel.head_pic;
        
        userInfo.head_pic = perInfoModel.head_pic;
        
        userInfo.real_name = common_name;
        
        chatMsgModel.wcdb_user_info = [userInfo mj_JSONString];
        
    }
    
    [self.tableView reloadData];
    
}

- (void)pushVc:(UIViewController *)vc {
    
    JLGCustomViewController *nav = (JLGCustomViewController *)self.view.window.rootViewController;
    
    [nav pushViewController:vc animated:YES];
}

@end
