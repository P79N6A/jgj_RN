//
//  JGJSocketRequest+ChatMsgService.h
//  mix
//
//  Created by yj on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSocketRequest.h"

typedef enum : NSUInteger {
    
    JGJMsgCallBackReadedType, //已读回执
    
    JGJMsgCallBackReceivedType //确认收到回执

} JGJMsgCallBackType; //消息回执类型

typedef void(^MessageReadedCallback)(JGJChatMsgListModel *msgModel);

typedef void(^ReceivedMsgCallback)(JGJChatMsgListModel *msgModel);

typedef void(^ContactListMsgCallBack)(void);

@interface JGJSocketRequest (ChatMsgService)

@property (nonatomic, strong) JGJChatMsgListModel *readMsgModel;
//是否在读
@property (nonatomic, copy) NSString *is_readed;

/**
 *已读消息回执
 */
@property (nonatomic, copy) MessageReadedCallback messageReadedCallback;

/**
 *已接收的消息
 */
@property (nonatomic, copy) ReceivedMsgCallback receivedMsgCallback;

/**
 *
 *处理完消息聊聊列表回调
 *
 */
 @property (nonatomic, copy) ContactListMsgCallBack contactListCallBack;

/**
 *是否正在读消息
 */
+(void)readedMsgModel:(JGJChatMsgListModel *)msgModel isReaded:(BOOL)isReaded;

///**
// *进入页面把最大的消息赋值给聊聊表，并且已读。保持聊聊最大的已读消息id始终和接收的最大消息始终一致
// */
//+(void)messageReadedWithMsgModel:(JGJChatMsgListModel *)msgModel type:(JGJMsgCallBackType)type callback:(void(^)(JGJChatMsgListModel *msgModel))callBack;

///**
// *进入页面把下拉的消息拼接回执给服务器标记成已读
// */
//+(void)msgsReadedWithMsgModel:(JGJChatMsgListModel *)msgModel type:(JGJMsgCallBackType)type callback:(void(^)(JGJChatMsgListModel *msgModel))callBack;

/**
 *接收socket的消息
 */
+(void)insertWebSocketReceiveChatMsg:(id)receive;

/**
 *更新聊聊列表
 */
+ (void)insertDBGroupListWithChatMsgListModel:(JGJChatMsgListModel *)msgModel;

/**
 *接收自己发送的质量安全消息
 */
+(void)receiveMySendMsgModel:(JGJChatMsgListModel *)msgModel isReaded:(BOOL)isReaded;

/**
 *接收自己发送的质量安全消息
 */
+(void)receiveMySendMsgWithMsgs:(NSArray *)msgs action:(NSString *)action;

// 回执收到的消息
+(void)callbackServiceMaxMsgs:(NSString *)msgs maxMsgModel:(JGJChatMsgListModel *)maxMsgModel type:(JGJMsgCallBackType)type callback:(void(^)(JGJChatMsgListModel *msgModel))callBack;

// 回执聊聊表收到显示的消息
+(void)callbackGroupServiceWithMaxMsgs:(NSArray *)maxMsgs msgs:(NSArray *)msgs type:(JGJMsgCallBackType)type callback:(void(^)(NSArray *msgs))callBack;

/**
 *接收离线消息页面显示
 */
+(void)receiveCurGroupOffineMsgs:(NSArray *)msgs type:(JGJMsgCallBackType)type;

/**
 *回执服务器数据转换
 */
+(NSString *)dicWithMsgs:(NSArray *)msgs;

/**
 *拉取离线消息回执服务器,已读
 */

+(void)pullRoamMsgCallBackServiceWithMsgs:(NSArray *)msgs proListModel:(JGJMyWorkCircleProListModel *)proListModel;

/**
 *获取当前组消息未读人数
 */
+ (void)chatMessageReadedNumWithMyMsgs:(NSArray *)myMsgs callback:(void(^)(NSArray *msgs))callBack;

/**
 *消息显示的timer开始，App息屏后进入前台使用
 */
+(void)receiveMsgTimerStart;

/**
 *回执服务器收到的消息撤回成功
 */
+ (void)callBackServiceRecallSuccessWithMsgs:(NSArray *)msgs;

@end
