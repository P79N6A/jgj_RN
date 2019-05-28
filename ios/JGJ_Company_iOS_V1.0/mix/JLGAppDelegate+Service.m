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

+(void)handleOfflineMsgService {
    
    //App启动的时候标识没有处理消息，当前要处理 ，这个标识很重要，是否处理消息
    [TYUserDefaults removeObjectForKey:JGJIsHandlingMsg];
    
    //设置首次启动拉取离线消息,处理结束才获取重现socket消息
    
    [TYUserDefaults setBool:YES forKey:JGJIslLaunchOfflineMsg];
    
    if (JLGisLoginBool) {
        
        // 已经登录的 获取首页班组信息
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
        [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:^(BOOL responseObject) {
            
            //获取聊天消息
            [JLGAppDelegate chatMsgService];
            
        }];
        
        [JGJChatGetOffLineMsgInfo http_getClosedGroupList];
        
        //移除通讯录文件
        [JLGAppDelegate removeAddressbookFile];
    }
    
}

@end
