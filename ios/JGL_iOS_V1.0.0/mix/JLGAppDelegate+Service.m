//
//  JLGAppDelegate+Service.m
//  mix
//
//  Created by yj on 2018/8/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JLGAppDelegate+Service.h"

#import "JGJChatOffLineMsgTool.h"

#import "JGJAddressBookTool.h"

@implementation JLGAppDelegate (Service)

+(void)chatMsgService {
    
    [JGJChatOffLineMsgTool getOfflineMessageListCallBack:^(NSArray *msglist) {

        TYLog(@"离线消息获取成功====%@", msglist);

    }];
    
}

+(void)removeAddressbookFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isRemove = NO;
    
    if ([fileManager fileExistsAtPath:JGJAddressBookToolPath]) {
        
        isRemove = [fileManager removeItemAtPath:JGJAddressBookToolPath error:nil];
    }
    
    if ([fileManager fileExistsAtPath:JGJAddFreiendAddressBookPath]) {
        
       isRemove = [fileManager removeItemAtPath:JGJAddFreiendAddressBookPath error:nil];
    }
    
    TYLog(@"移除通讯录====%@ JGJAddressBookToolPath===%@ JGJAddFreiendAddressBookPath==%@", isRemove?@"移除通讯录成功":@"移除通讯录文件失败", JGJAddressBookToolPath, JGJAddFreiendAddressBookPath);

}

@end
