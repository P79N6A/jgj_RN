//
//  JGJChatMsgComTool.m
//  mix
//
//  Created by yj on 2018/9/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgComTool.h"

#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

@implementation JGJChatMsgComTool

#pragma mark - 修改昵称修改数据库，和聊天的临时数据
+ (void)handleModifyChatModel:(JGJChatMsgListModel *)modifyChatModel {
    
    if ([NSString isEmpty:modifyChatModel.user_name]) {
        
        return;
    }
        
    JGJChatMsgListModel *oriMsgModel = [JGJChatMsgDBManger getMaxUserMsgModel:modifyChatModel];
    
    JGJChatUserInfoModel *userInfo = [JGJChatUserInfoModel mj_objectWithKeyValues:[oriMsgModel.wcdb_user_info mj_keyValues]];
    
    oriMsgModel.send_name =  modifyChatModel.user_name;
    
    userInfo.head_pic = modifyChatModel.head_pic;
    
    //主要更改聊天用的 real_name
    userInfo.real_name = modifyChatModel.user_name;
    
    NSString *wcdb_user_info = [userInfo mj_JSONString];
    
    oriMsgModel.wcdb_user_info = wcdb_user_info;
    
    [JGJChatMsgDBManger updateUserInfoRowPropertyWithJGJChatMsgListModel:oriMsgModel propertyListType:JGJChatMsgDBUpdateUserInfoPropertyType];
    
}

#pragma mark - 更新单聊表
+ (void)updateSingleDBChatModel:(JGJChatMsgListModel *)msgModel {
    
    //更新单聊用户的group_id /singleChat
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.uid classType:@"singleChat"];
    
    if (groupModel) {
        
        groupModel.local_head_pic = [@[msgModel.head_pic] mj_JSONString];
        
        groupModel.group_name = msgModel.send_name;
        
        [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupModel];
    }
    
    TYLog(@"send_name======%@  head_pic======%@", msgModel.send_name, msgModel.head_pic);
    
}

@end
