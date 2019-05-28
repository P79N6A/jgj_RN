//
//  TYGlobalDefine.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//  全局使用的宏定义

#ifndef TYGlobalDefine_h
#define TYGlobalDefine_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TYRectDefine.h"
#import "JGJGlobalDefine.h"
#import "JGJWeiXin_pay.h"

#endif

#pragma mark - 头文件添加步骤
// 1、Build Settings
// 2、Prefix header 改为YES
// 3、$(SRCROOT)/HuduoduoDebug/TYGlobalDefine.h

#pragma mark - 弱引用/强引用
#define TYWeakSelf(type)  __weak typeof(type) weak##type = type;
#define TYStrongSelf(type)  __strong typeof(type) strong##type = weak##type;

#pragma mark - Delegate
//Delegate
#define TYAppDelegate       ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#pragma mark - 通知中心
//通知中心
#define TYNotificationCenter [NSNotificationCenter defaultCenter]

#pragma mark - Key_Window
#define TYKey_Window         [UIApplication sharedApplication].keyWindow

#pragma mark - 判断版本
//判断版本
#define TYiOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define TYiOS10Later                           (!(TYiOSVersion < 10.0))
#define TYiOS9Later                           (!(TYiOSVersion < 9.0))
#define TYiOS8Later                           (!(TYiOSVersion < 8.0))
#define TYiOS7Later                           (!(TYiOSVersion < 7.0))

#pragma mark - 状态栏网络状态
//状态栏网络状态
#define TYNetworkActivityIndicatorHidden         TYNetworkActivityIndicatorVisible(YES)
#define TYNetworkActivityIndicatorShow           TYNetworkActivityIndicatorVisible(NO)
#define TYNetworkActivityIndicatorVisible(x)     [UIApplication sharedApplication].networkActivityIndicatorVisible = (x)


#pragma mark - 角度、弧度
//角度、弧度
// 由角度获取弧度
#define TYDegreesToRadian(x) (M_PI * (x) / 180.0)
// 由弧度获取角度
#define TYRadianToDegrees(radian) (radian*180.0)/(M_PI)

#pragma mark - 打印
//打印
#ifdef DEBUG
#define TYLog(...) NSLog(@"\n\n调试\n函数:%s 行号:%d\n打印信息:%@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TYLog(...) do { } while (0);
#endif

#pragma mark - 文件路径
//文件路径
#define TYUserBundle          [NSBundle mainBundle]

#define TYUserDefaults        [NSUserDefaults standardUserDefaults]

// Document路径
#define TYUserDocumentPaths   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

// Cache路径
#define TYUserCachePaths      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#pragma mark - 断言
//断言
#ifdef DEBUG
#define TYAPP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define TYAPP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define TYAPP_ASSERT_STOP                     do {} while (0);
#define TYAPP_ASSERT(condition)               do {} while (0);
#endif


#endif /* TYGlobalDefine_h */
