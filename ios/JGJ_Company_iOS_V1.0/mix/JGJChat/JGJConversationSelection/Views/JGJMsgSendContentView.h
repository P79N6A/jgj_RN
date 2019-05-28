//
//  JGJMsgSendContentView.h
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJChatGroupListModel;
@interface JGJMsgSendContentView : UIView
/** 聊天消息模型 */
@property (nonatomic, strong) JGJChatMsgListModel *message;

/** 聊天会话数组 */
@property (nonatomic, strong) NSArray<JGJChatGroupListModel *> *conversations;
/** 发送按钮是否显示发送数量(在setConversations之前设置) */
@property (nonatomic, assign) BOOL showSendNumber;

@property (nonatomic, copy) void(^ensureAction)();
@property (nonatomic, copy) void(^cancelAction)();
@property (nonatomic, copy) void(^textViewDidChange)(NSString *text);
@end
