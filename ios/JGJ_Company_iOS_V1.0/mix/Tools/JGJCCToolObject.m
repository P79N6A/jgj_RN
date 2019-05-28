//
//  JGJCCToolObject.m
//  mix
//
//  Created by Tony on 2018/6/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCCToolObject.h"
#import "JLGAppDelegate.h"
#import "NSDate+Extend.h"
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UserNotifications/UNNotificationSettings.h>
#import "JGJHomeGoToOpenNotificationJurisdictionView.h"
@implementation JGJCCToolObject

+ (void)judgeCountToAlertPopViewWithVC:(UIViewController *)vc dismissBlock:(void(^)())touchUpDismissBlock {
    
    __block BOOL isOpenNotificationJurisdiction = NO;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            NSLog(@"setting = %@",settings);
            
            if(settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                
                isOpenNotificationJurisdiction = YES;
                
            } else {
                
                isOpenNotificationJurisdiction = NO;
            }

            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self alertNotificationViewWithIsOpen:isOpenNotificationJurisdiction vc:vc dismissBlock:touchUpDismissBlock];
            });
            
        }];
        
        
    } else if ([[UIDevice currentDevice].systemVersion doubleValue] == 8.0) {
        
        isOpenNotificationJurisdiction = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];

        [self alertNotificationViewWithIsOpen:isOpenNotificationJurisdiction vc:vc dismissBlock:touchUpDismissBlock];
        
    } else {
        
        isOpenNotificationJurisdiction = UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        [self alertNotificationViewWithIsOpen:isOpenNotificationJurisdiction vc:vc dismissBlock:touchUpDismissBlock];
    }
    
}

+ (void)alertNotificationViewWithIsOpen:(BOOL)isOpen vc:(UIViewController *)vc dismissBlock:(void(^)())touchUpDismissBlock{
    
    UIWindow *window = TYKey_Window;
    
    __block NSInteger appOpenCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"appOpenCount"];
    __weak typeof(self) weakSelf = self;
    
    if (!isOpen) {
     
        NSDate *alertDate = [TYUserDefaults objectForKey:JGJNotificationAlertTime];
        
        // 第一次打开，判断没有开启通知，弹出去开启弹出
        if (!alertDate) {
            
            [self alertNotificationViewWithDismissBlock:touchUpDismissBlock];
            
        }else {
            
            // 之后 每天只弹出一次
            if (!alertDate.isToday) {
                
                [self alertNotificationViewWithDismissBlock:touchUpDismissBlock];
            }
            
        }
    }
    
}

+ (void)alertNotificationViewWithDismissBlock:(void(^)())touchUpDismissBlock {
    
    UIWindow *window = TYKey_Window;
    [TYUserDefaults setObject:[NSDate date] forKey:JGJNotificationAlertTime];
    JGJHomeGoToOpenNotificationJurisdictionView *notificationAlert = [[JGJHomeGoToOpenNotificationJurisdictionView alloc] init];
    notificationAlert.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
    [window addSubview:notificationAlert];
    
    notificationAlert.openNotificationBlock = ^{
        
        float systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
        
        if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }else if (systemVersion >= 10.0) {  // iOS10.0及以后
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    }];
                }
            }
        }
    };
    
    notificationAlert.touchDismissBlock = ^{
        
        if (touchUpDismissBlock) {
            
            touchUpDismissBlock();
        }
    };
}




@end
