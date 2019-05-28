//
//  JGJMsgSendAlertView.h
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJChatGroupListModel;

@interface JGJMsgSendAlertView : UIView
/** 聊天消息模型 */
@property (nonatomic, strong) JGJChatMsgListModel *message;
@property (nonatomic, copy) void(^ensureAction)();
@property (nonatomic, copy) void(^cancelAction)();

/** 留言信息 */
@property (nonatomic, copy) NSString *leftMessage;
/** 聊天会话数组 */
@property (nonatomic, strong) NSArray<JGJChatGroupListModel *> *conversations;

/** 发送按钮是否显示发送数量(在setConversations之前设置) */
@property (nonatomic, assign) BOOL showSendNumber;


- (void)show;
- (void)dismiss;
@end
