//
//  JLGAppDelegate+Service.h
//  mix
//
//  Created by yj on 2018/8/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JLGAppDelegate.h"

@interface JLGAppDelegate (Service)

+(void)chatMsgService;

//移除通讯录文件
+(void)removeAddressbookFile;

//获取离线消息
+(void)handleOfflineMsgService;

@end

