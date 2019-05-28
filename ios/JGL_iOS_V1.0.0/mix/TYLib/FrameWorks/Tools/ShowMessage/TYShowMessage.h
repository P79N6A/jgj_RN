//
//  TYShowMessage.h
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;
@interface TYShowMessage : NSObject

/**
 *  只显示文本
 */
+(void)showHUDOnly:(NSString *)message;

/**
 *  Alert
 */
+(void)showAlertTextOnly:(NSString *)message;

/**
 *  显示加载的信息
 */
+(void)showHUDWithMessage:(NSString *)message;

/**
 *  一直显示加载的信息
 */
+(void)showKeepHUDrWithMessage:(NSString *)message;

/**
 *  显示错误提示
 */
+ (void)showError:(NSString *)error;//显示1秒
+ (void)showError:(NSString *)error afterDelay:(NSInteger )delay;//自定义时间

/**
 *  显示成功提示
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示感叹号的提示
 */
+ (void)showPlaint:(NSString *)plaint;

/**
 *  显示关联view的提示
 */

+(MBProgressHUD *)showHUBWithMessage:(NSString *)message WithView:(UIView *)view;

/**
 *  隐藏一般的提示框
 */
+ (void)hideHUD;

/**
 *  隐藏关联view的提示框
 */
+(void)hideHUBWithView:(UIView *)view;

/**
 *  隐藏一直显示的提示框
 */
+(void)hideHUBKeepAler;

/**
 *  本地推送
 */
+ (void)showLocalPush:(NSString *)pushStr;

/**
 *  取消本地推送
 */
+(void)cancelLocalPush:(NSString *)pushStr;

/**
 *  判断浮点数是否为0
 */
+ (BOOL)isFloatZero:(CGFloat)v;
@end
