//
//  JGJChatOffLineMsgTool.h
//  mix
//
//  Created by yj on 2018/8/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^getOffLineCallBack)(BOOL complete);
@interface JGJChatOffLineMsgTool : NSObject

+ (instancetype)shareChatOffLineMsgTool;

@property (nonatomic, copy) getOffLineCallBack offLineCallBack;

/*
 *获取离线消息
 *
 */
+ (void)getOfflineMessageListCallBack:(void(^)(NSArray *msglist))callBack;

/*
 *存取离线消息
 *
 */
+ (void)handleOfflineMsgs:(NSArray *)msgs type:(JGJMsgCallBackType)type callBack:(void(^)(NSArray *msglist))callBack;

/*
 *回去最大的消息
 *
 */
+ (void)maxMsgDic:(NSMutableDictionary *)lastDic msgModel:(JGJChatMsgListModel *)msgModel;

///*
// *获取漫游消息
// *
// */
//+ (void)getRoamMessageListCallBack:(void(^)(NSArray *msglist))callBack;

@end

