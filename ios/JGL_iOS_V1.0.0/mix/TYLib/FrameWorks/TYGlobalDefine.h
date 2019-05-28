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
#import "JLGHttpRequest_AFN.h"

#import "MJExtension.h"
#import "TYShowMessage.h"
#import "TYLoadingHub.h"
#import "CALayer+SetLayer.h"
#import "UITableViewCell+Extend.h"

#import "CommonModel.h"

#endif

/////////////////////通过切图计算倍数///////////////////////////////
//倍数:p = 切图宽度/320,如果切图的字体是16px,则实际字体大小为:16/p

#pragma mark - 头文件添加步骤
// 1、Build Settings
// 2、Prefix header 改为YES
// 3、$(SRCROOT)/HuduoduoDebug/TYGlobalDefine.h

// 通知中心
#define TYNotificationCenter [NSNotificationCenter defaultCenter]

///////////////////////颜色/////////////////////////////////
// RGB颜色
#define ColorRGB(r, g, b)           [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

// RGB颜色
#define ColorRGBA(r, g, b, a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 16进制颜色,color输入为:0x080808
#define ColorHex(color)             [UIColor colorWithRed:((color>>16)&0xFF)/255.0f green:((color>>8)&0xFF)/255.0f blue:(color&0xFF)/255.0f alpha:1.0f]

// 16进制颜色,带alpha,color输入为:0x080808
#define ColorHexAlpha(color,alphaValue)  [UIColor colorWithRed:((color>>16)&0xFF)/255.0f green:((color>>8)&0xFF)/255.0f blue:(color&0xFF)/255.0f alpha:alphaValue]

// 随机色
#define ColorRandom                 ColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//项目蓝色
#define JLGBlueColor ColorHex(0x46a8ff)

/**********1.4版本定义字体大小开始*********/
//工人工头详情页字体大小设置
#define AppFontOriginalData 0.5

#define AppFont36Size      36 * AppFontOriginalData //姓名字体大小
#define AppFont34Size      34 * AppFontOriginalData
#define AppFont32Size      32 * AppFontOriginalData 
#define AppFont30Size      30 * AppFontOriginalData
#define AppFont28Size      28 * AppFontOriginalData
#define AppFont26Size      26 * AppFontOriginalData
#define AppFont24Size      24 * AppFontOriginalData

/**********1.4版本定义字体大小结束*********/


/**********1.4版本定义颜色开始*********/
//项目主色调
#define JGJMainColor             AppFontd7252cColor
#define JGJMainBackColor         AppFontf1f1f1Color
#define JGJMainRedColor          AppFontd7252cColor

#define AppFontf1f1f1Color       ColorHex(0Xf1f1f1) //主背景色调
#define AppFontd7252cColor       ColorHex(0Xd7252c) //主色调
#define AppFontf3f3f3Color       ColorHex(0Xf3f3f3) 
#define AppFontfafafaColor       ColorHex(0Xfafafa) //顶部的背景颜色
#define AppFont333333Color       ColorHex(0X333333) //顶部的字体颜色
#define AppFont666666Color       ColorHex(0X666666)
#define AppFontbbbbbbColor       ColorHex(0Xbbbbbb) 
#define AppFontf7f7f7Color       ColorHex(0Xf7f7f7)
#define AppFontf1f1f1Color       ColorHex(0Xf1f1f1)
#define AppFontaaaaaaColor       ColorHex(0Xeeeeee)
#define AppFonteeeeeeColor       ColorHex(0Xeeeeee)
#define AppFontccccccColor       ColorHex(0Xcccccc)
#define AppFont999999Color       ColorHex(0X999999)
#define AppFontdbdbdbColor       ColorHex(0Xdbdbdb) 
#define AppFontc9c9c9Color       ColorHex(0Xc9c9c9) 
#define AppFontff9700Color       ColorHex(0Xff9700) //黄色
#define AppFontff6733Color       ColorHex(0Xff6733) //淡红
#define AppFont46a8ffColor       ColorHex(0X46a8ff) //蓝色
#define AppFontc7c7c7Color       ColorHex(0Xc7c7c7) //灰色
#define AppFontf3c120Color       ColorHex(0Xf3c120) //黄色
#define AppFontd7252cColor       ColorHex(0Xd7252c)
/**********1.4版本定义颜色结束*********/

///////////////////////判断版本/////////////////////////////////
#define iOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS9Later                           !(iOSVersion < 9.0)
#define iOS8Later                           !(iOSVersion < 8.0)
#define iOS7Later                           !(iOSVersion < 7.0)

///////////////////////判断是@1下,@2x,@3x/////////////////////////////////
#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA           ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && GetUIScreen_MAX_LENGTH < 568.0)
#define IS_IPHONE_5         (IS_IPHONE && GetUIScreen_MAX_LENGTH == 568.0)
#define IS_IPHONE_6         (IS_IPHONE && GetUIScreen_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P        (IS_IPHONE && GetUIScreen_MAX_LENGTH == 736.0)
#define IS_NOT_IPHONE_6P    (IS_IPHONE && GetUIScreen_MAX_LENGTH < 736.0)

#define FONT_SIZE(IPHONE_6_FONT_PX) (IPHONE_6_FONT_PX / 2.0)

#define FONT_SIZE_WITH_FONT(IPHONE_6_FONT_SIZE) [UIFont systemFontOfSize:FONT_SIZE(IPHONE_6_FONT_SIZE.pointSize)]

#define IPHONE_6_PX_WIDTH (750.0)
#define IPHONE_6_PX_HEIGHT (1334.0)
#define IPHONE_6_PX_HEIGHT (1334.0)


#define HorizontalSpace(x) (GetUIScreenWidth * (x / IPHONE_6_PX_WIDTH))
#define VerticalSpace(y) (GetUIScreenHeight * (y / IPHONE_6_PX_HEIGHT))

///////////////////////获取frame参数/////////////////////////////////
#define GetViewW(v)                         v.frame.size.width
#define GetViewH(v)                         v.frame.size.height
#define GetViewX(v)                         v.frame.origin.x
#define GetViewY(v)                         v.frame.origin.y

#define GetMaxX(v)                          CGRectGetMaxX(v.frame)
#define GetMaxY(v)                          CGRectGetMaxY(v.frame)
#define GetMinX(v)                          CGRectGetMinX(v.frame)
#define GetMinY(v)                          CGRectGetMinY(v.frame)
#define GetMidX(v)                          CGRectGetMidX(v.frame)
#define GetMidY(v)                          CGRectGetMidY(v.frame)

#define GetRectX(f)                         f.origin.x
#define GetRectY(f)                         f.origin.y
#define GetRectWidth(f)                     f.size.width
#define GetRectHeight(f)                    f.size.height

#define GetUIScreenWidthRatio               (GetUIScreenWidth/320.0)

#define GetUIScreenMain                     [UIScreen mainScreen]
#define GetUIScreenRect                     [[UIScreen mainScreen] bounds]
#define GetUIScreenWidth                    [[UIScreen mainScreen] bounds].size.width
#define GetUIScreenHeight                   [[UIScreen mainScreen] bounds].size.height

#define GetUIScreen_MAX_LENGTH              (MAX(GetUIScreenWidth, GetUIScreenHeight))
#define GetUIScreen_MIN_LENGTH              (MIN(GetUIScreenWidth, GetUIScreenHeight))
///////////////////////设置frame参数/////////////////////////////////
#define SetRect(x, y, w, h)                 CGRectMake(x, y, w, h)
#define SetSize(w, h)                       CGSizeMake(w, h)
#define SetPoint(x, y)                      CGPointMake(x, y)
#define SetRectWidth(f, w)                  CGRectMake(GetRectX(f), GetRectY(f), w, GetRectHeight(f))
#define SetRectHeight(f, h)                 CGRectMake(GetRectX(f), GetRectY(f), GetRectWidth(f), h)
#define SetRectX(f, x)                      CGRectMake(x, GetRectY(f), GetRectWidth(f), GetRectHeight(f))
#define SetRectY(f, y)                      CGRectMake(GetRectX(f), y, GetRectWidth(f), GetRectHeight(f))
#define SetRectSize(f, w, h)                CGRectMake(GetRectX(f), GetRectY(f), w, h)
#define SetRectOrigin(f, x, y)              CGRectMake(x, y, GetRectWidth(f), GetRectHeight(f))

///////////////////////状态栏网络状态/////////////////////////////////
#define ShowNetworkActivityIndicator()      NetworkActivityIndicatorVisible(YES)
#define HideNetworkActivityIndicator()      NetworkActivityIndicatorVisible(NO)
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

///////////////////////角度、弧度/////////////////////////////////
// 由角度获取弧度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
// 由弧度获取角度
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


///////////////////////断言/////////////////////////////////
#ifdef DEBUG
#define APP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define APP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define APP_ASSERT_STOP                     do {} while (0);
#define APP_ASSERT(condition)               do {} while (0);
#endif

///////////////////////判断模拟器，真机/////////////////////////////////
// 判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

///////////////////////打印/////////////////////////////////
#ifdef DEBUG
#define TYLog(...) NSLog(@"\n\nTony调试\n函数:%s 行号:%d\n打印信息:%@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TYLog(...) do { } while (0);
#endif

///////////////////////路径/////////////////////////////////
#define UserBundle          [NSBundle mainBundle]

#define UserDefaults        [NSUserDefaults standardUserDefaults]

// Document路径
#define UserDocumentPaths   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

// Cache路径
#define UserCachePaths       [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

/////////////////userDefaults需要使用的string/////////////////////////
#define JLGLogin            @"JLGLogin"//登录的标识
#define JLGisLoginBool      [UserDefaults boolForKey:JLGLogin]//登录的标识
#define JLGLoginFail        @"JLGLoginFail"//登录失效
#define JLGManageVcUpdate   @"JLGManageVcUpdate"//发布完项目以后更新
#define JLGLoginBool        [UserDefaults boolForKey:JLGLogin]//是否登录
#define JLGisMateBool       !JLGisLeaderBool//[UserDefaults boolForKey:JLGisMate]//是否是工友登录
#define JLGisLeader         @"JLGisLeader"//工头的标识
#define JLGisLeaderBool     [UserDefaults boolForKey:JLGisLeader]//!JLGisMateBool//是否是工头登录
#define JLGMateIsInfo       @"JLGMateIsInfo"//是否有工友权限
#define JLGLeaderIsInfo     @"JLGLeaderIsInfo"//是否有工头权限
#define JLGMateIsInfoBool       [UserDefaults boolForKey:JLGMateIsInfo]//是否有工友权限
#define JLGLeaderIsInfoBool     [UserDefaults boolForKey:JLGLeaderIsInfo]//是否有工头权限

#define JLGLatitude         @"JLGLatitude"//纬度
#define JLGLongitude        @"JLGLongitude"//经度
#define JLGLocation         @"JLGLocation"//定位是否成功
#define JLGLocationTime     @"JLGLocationTime"//更新定位间隔时间
#define JLGCityNo           @"JLGCityNo"//城市编码
#define JLGCityName         @"JLGCityName"//城市名字
#define JLGCityNoUp         @"JLGCityNoUp"//城市编码更新
#define JLGSelectCityNo     @"JLGSelectCityNo"//选择的城市编码
#define JLGSelectCityName   @"JLGSelectCityName"//选择的城市名字

#define JLGToken            @"token"//用户Token
#define JLGPhone            @"JLGPhone"//电话号码
#define JLGFirstPid         @"JLGFirstPid"//最新项目的Pid

#define JLGOldTime          @"oldTime"//上一次保存的时间
#define JLGAddressBookTime  @"JLGAddressBookTime"//上一次联系人读取的时间

#define YZGGetSysServerData @"GetSysServerData"//上一次读取服务器的时间
#define YZGGuideFirstBool   @"YZGGuideFirstBool"//是否是第一次进入,NO:没有这个值，说明是第一个进入
#define YZGLockScreen       @"YZGLockScreen"//锁屏

//退出
#define JLGExitLogin        {[UserDefaults setBool:NO forKey:JLGLogin];[UserDefaults setBool:NO forKey:JLGMateIsInfo];[UserDefaults setBool:NO forKey:JLGLeaderIsInfo];[UserDefaults removeObjectForKey:JLGToken];[UserDefaults synchronize];}

//向上或者向下偏移的像素超过了设置的就改变navbar的显示或者隐藏
#define scrollOffsetHiddenNavBar 10

#define tableSectionHeaderHeight 30

typedef enum : NSUInteger {
    workCellType,
    workLeaderCellType
} SelectedWorkType;
//#define scrollToHidden YES//是否隐藏状态栏
#endif /* TYGlobalDefine_h */
