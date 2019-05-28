//
//  TYShowMessage.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "TYShowMessage.h"
#import "MBProgressHUD.h"

#define pushKey @"key"

@implementation TYShowMessage

+(void)showHUDOnly:(NSString *)message{
    [self hideHUD];
    
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

+(void)showAlertTextOnly:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

+(void)showHUDWithMessage:(NSString *)message{
    if (!message) {
        message = @"无效输入";
    }
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    // 5秒之后再消失
    [hud hide:YES afterDelay:5];
}

+(void)showKeepHUDrWithMessage:(NSString *)message{
    if (!message) {
        message = @"无效输入";
    }
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:5];
}

+ (void)show:(NSString *)text icon:(NSString *)icon delay:(NSInteger )delay
{
    [self hideHUD];
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    
    CGFloat fontRation = 14.0/text.length;
    if (fontRation < 1.0) {//因为测试，默认的字体大小为16.0
        hud.labelFont = [UIFont systemFontOfSize:16.0*fontRation];
    }

    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:delay];
}

+ (void)showError:(NSString *)error
{
//    [self show:error icon:@"error.png" delay:2];
    
    [self show:error icon:@"plaint.png" delay:2];
}

+ (void)showError:(NSString *)error afterDelay:(NSInteger )delay
{
//    [self show:error icon:@"error.png" delay:delay];
    
    [self show:error icon:@"plaint.png" delay:delay];
}

+ (void)showSuccess:(NSString *)success
{
    [self show:success icon:@"success.png" delay:2];
}

+ (void)showPlaint:(NSString *)plaint
{
    [self show:plaint icon:@"plaint.png" delay:2];
}

+(MBProgressHUD *)showHUBWithMessage:(NSString *)message WithView:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    // 10秒之后再消失
    [hud hide:YES afterDelay:5];
    return hud;
}

+ (void)showLocalPush:(NSString *)pushStr{
    
    //1秒后发送
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    //chuagjian一个本地推送
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        //设置推送时间
        noti.fireDate = date;
        //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //设置重复间隔
        noti.repeatInterval = 0;
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;
        //内容
        noti.alertBody = @"推送内容,测试修改这里";
        noti.alertAction = @"打开";  //提示框按钮
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) {
            noti.alertTitle = @"你来打我啊";
        }
        
        //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:pushStr forKey:pushKey];
        noti.userInfo = infoDic;
        
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
    }
}

+(void)cancelLocalPush:(NSString *)pushStr{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    UILocalNotification *localNoti;
    
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:pushKey];
                if ([inKey isEqualToString:pushStr]) {
                    if (localNoti){
                        localNoti = nil;
                    }
                    
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNoti) {
            //不存在 初始化
            localNoti = [[UILocalNotification alloc] init];
        }
        
        if (localNoti) {
            //不推送 取消推送
            [app cancelLocalNotification:localNoti];
            return;
        }
    }
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+(void)hideHUBWithView:(UIView *)view{
    [self hideHUDForView:view];
}


+(void)hideHUBKeepAler{
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    [self hideHUDForView:view];
}

+ (BOOL)isFloatZero:(CGFloat)v{
    float epsinon = 0.00001;
    
    if (v > -epsinon && v < epsinon) {
        return YES;
    }
    return NO;
}
@end
