//
//  JGJBaseViewController.m
//  mix
//
//  Created by yj on 2019/3/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJBaseViewController.h"

#import "JGJWebAllSubViewController.h"

#import "UITabBar+JGJTabBar.h"

#import "JGJFeedBackView.h"
#import "JGJNativeEventEmitter.h"
#import "NSString+JSON.h"

@interface JGJBaseViewController ()

@property (nonatomic, strong) JGJFeedBackView *feedBackView;

@end

@implementation JGJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - app启动服务
- (void)appLaunchServiceSuccessBlock:(void (^)(id responseObject))success {
    
    TYWeakSelf(self);
    
    [JGJBaseViewController serviceTimestampSuccessBlock:^(id responseObject) {
        
        [weakself handleDynamicDot];
        
        [weakself appLaunchServiceTimestampSuccess];
        
        if (success) {
            
            success(responseObject);
            
        }
    }];
    
}

#pragma mark - app启动服务器时间获取成功,子类可以使用
- (void)appLaunchServiceTimestampSuccess {
    
    
}

#pragma mark - 处理动态发现小红点

- (void)handleDynamicDot {
    
    //获取发现消息数量
    [self getDynamicMsgNum:NO];
    
    //注册发现小红点通知
    [self registerNotifyCenter];
    
    //监听小红点通知
    [self socketRequestReciveMessage];
}

- (BOOL)serviceTimestampDif {
    
    NSString *timeDifStampStr = [TYUserDefaults objectForKey:JLGUserstamp]?:@"0";
    
    double timeDifStamp =  fabs([timeDifStampStr doubleValue]);
    
    BOOL isDif = NO;
    
    if ([NSString isEmpty:timeDifStampStr]) {
        
        isDif = YES;
        
    }else if (timeDifStamp > 80 || [timeDifStampStr isEqualToString:@"0"]) { //服务器是120s这里我们取80.scoket也返回了时间戳校正时间
        
       isDif = YES;
        
    }else {
        
       isDif = NO;
    }
    
    return isDif;
}

#pragma mark - 接收消息的监控
- (void)socketRequestReciveMessage{
    
    TYWeakSelf(self);
    
    [JGJSocketRequest WebSocketAddMonitor:@{@"ctrl":@"message",@"action":@"reddotMessage"} success:^(id responseObject) {
        
        NSLog(@"红点推送 responseObject = %@",responseObject);
        //
        JGJChatMsgListModel *receiveMsg = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        
        if ([receiveMsg.msg_type isEqualToString:@"group_bill"]) {
            
//            self.proListModel.unread_billRecord_count = @"1";
//
//            [self.tableView reloadData];
            
        }else if ([receiveMsg.msg_type isEqualToString:@"findred"]) {
            
            [self showDynamicMsgRed];
            
        }
        
    } failure:nil];
    
    //监听接收到的消息
    
    [JGJSocketRequest WebSocketAddMonitor:@{@"ctrl":@"message",@"action":@"receiveMessage"} success:^(id responseObject) {
        
        JGJChatMsgListModel *receiveMsg = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];

        //子类更新未读数
        
        [weakself updateReciveSocketMessage:receiveMsg];

    } failure:nil];
    
}

#pragma makr - 子类使用
- (void)updateReciveSocketMessage:(JGJChatMsgListModel *)msgModel {
    
    
    
}

- (void)showDynamicMsgRed {
    
    [self getDynamicMsgNum:YES];
}

- (void)registerNotifyCenter {
    
    [TYNotificationCenter addObserver:self selector:@selector(handleDynamicMsgNumNotify:) name:JGJDynamicMsgNumNotify object:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}

- (void)handleDynamicMsgNumNotify:(NSNotification *)notification {
    
    [self hiddenDynamicMsgNum];
    
}

#pragma mark - 获取发现消息数量

- (void)getDynamicMsgNum:(BOOL)isFindred {
    
    //YES推送收到的消息确定是有红点，NO启动的时候调用接口
    
    if (isFindred) {
        
        [self showDynamicMsgNum];
        
//        if (self.tabBarController.viewControllers.count > 3) {
//
//            if (self.tabBarController.selectedIndex == 3) {
//
//                JGJWebAllSubViewController *findWebVc = self.tabBarController.viewControllers[3];
//
//                if ([findWebVc isMemberOfClass:[JGJWebAllSubViewController class]]) {
//
//                    [findWebVc handleLoginInfo];
//                }
//            }
//
//        }
        NSString *userToken = [TYUserDefaults objectForKey:JLGToken];
        NSString *os = @"I";
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        NSDictionary *loginInfoDic = JLGisLoginBool ? @{@"os" : os,
                                                        @"token" : userToken?:@"",
                                                        @"infover" : @(infoVer),
                                                        } : @{};
        NSString *loginInfojson = [NSString getJsonByData:loginInfoDic];
        [JGJNativeEventEmitter emitEventWithName:@"refreshRN" body:loginInfojson];

        
        return;
    }
    
    [self requestDynamicMsgNum];
    
}

#pragma mark - 获取服务器时间戳校正

+ (void)serviceTimestampSuccessBlock:(void (^)(id responseObject))success {
    
    [JLGHttpRequest_AFN PostWithApi:@"Jlsys/getServerTimestamp" parameters:nil success:^(id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    }];
    
}

#pragma mark - 获取动态消息数

- (void)requestDynamicMsgNum {
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/dynamic/newMsgNum" parameters:nil success:^(id responseObject) {
        
        JGJDynamicMsgNumModel *dynamicMsgNumModel = [JGJDynamicMsgNumModel mj_objectWithKeyValues:responseObject];
        
        NSInteger comment_num = [dynamicMsgNumModel.comment_num integerValue];
        
        NSInteger liked_num = [dynamicMsgNumModel.liked_num integerValue];
        
        NSInteger fans_num = [dynamicMsgNumModel.fans_num integerValue];
        
        if (fans_num > 0 || liked_num > 0 || comment_num > 0) {
            
            [self showDynamicMsgNum];
            
        }else {
            
            [self hiddenDynamicMsgNum];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)hiddenDynamicMsgNum {
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    
}

- (void)showDynamicMsgNum {
    
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    
    infoVer += 1;
    
    [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
    
    [TYUserDefaults synchronize];
    
}

//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    
    
    if (self.feedBackView) {
        
        [self.feedBackView removeFromSuperview];
    }
    
    if (!JLGisLoginBool) { return; }
    
    JGJFeedBackView *feedBackView = [[JGJFeedBackView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    self.feedBackView = feedBackView;
    
    feedBackView.targetVc = self;
    
    feedBackView.is_shot_screen = YES;
    
}

@end
