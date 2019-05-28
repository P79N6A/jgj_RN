//
//  JGJSocketRequest+GroupService.h
//  mix
//
//  Created by yj on 2018/10/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSocketRequest.h"

typedef void(^WorkTypeMsgCallBack)(NSArray *work_msg_array);

@interface JGJSocketRequest (GroupService)

//接收到的消息处理到聊聊表显示

+(void)receiveMsgCallBackGroup:(NSArray *)msgs maxMsgs:(NSArray *)maxMsgs type:(JGJMsgCallBackType)type;


/**
 *
 *处理完消息工作列表回调
 *
 */
@property (nonatomic, copy) WorkTypeMsgCallBack workTypeMsgCallBack;
@end
