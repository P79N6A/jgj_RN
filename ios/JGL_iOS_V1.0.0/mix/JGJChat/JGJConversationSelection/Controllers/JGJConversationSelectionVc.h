//
//  JGJConversationSelectionVc.h
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJConversationSelectionVc : UIViewController
@property (nonatomic, strong) JGJChatMsgListModel *message;

/** 消息已发送回调(点击完发送按钮) */
//@property (nonatomic, copy) void(^messageDidSend)(NSArray *messages);
/** 消息发送成功回调 */
//@property (nonatomic, copy) void(^messageSendSuccessed)(JGJChatMsgListModel *message);
@end
