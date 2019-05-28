//
//  HomeVC+ServiceApiRequest.m
//  mix
//
//  Created by yj on 2018/8/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "HomeVC+ServiceApiRequest.h"

#import "JGJWebAllSubViewController.h"

#import "JGJFeedBackView.h"

@implementation HomeVC (ServiceApiRequest)

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
        
        if (self.tabBarController.viewControllers.count > 3) {
            
            if (self.tabBarController.selectedIndex == 3) {
                
                JGJWebAllSubViewController *findWebVc = self.tabBarController.viewControllers[3];
                
                if ([findWebVc isMemberOfClass:[JGJWebAllSubViewController class]]) {
                    
                    [findWebVc handleLoginInfo];
                }
            }
            
        }
        
        return;
    }
    
    //获取动态发现小红点
    [self requestDynamicMsgNum];
    
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

#pragma mark - 获取服务器时间戳校正

- (void)serviceTimestampSuccessBlock:(void (^)(id responseObject))success {
    
    [JLGHttpRequest_AFN PostWithApi:@"Jlsys/getServerTimestamp" parameters:nil success:^(id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    }];
    
}

@end
