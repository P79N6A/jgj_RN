//
//  JGJChatMsgComTool.h
//  mix
//
//  Created by yj on 2018/9/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJChatMsgComTool : NSObject

// 修改昵称修改数据库，和聊天的临时数据

+ (void)handleModifyChatModel:(JGJChatMsgListModel *)modifyChatModel;

// 更新单聊表

+ (void)updateSingleDBChatModel:(JGJChatMsgListModel *)msgModel;

@end
