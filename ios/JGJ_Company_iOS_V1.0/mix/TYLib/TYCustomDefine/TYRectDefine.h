//
//  TYRectDefine.h
//  mix
//
//  Created by jizhi on 16/5/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef TYRectDefine_h
#define TYRectDefine_h

#pragma mark - 判断设备类型
//判断设备类型
#define TYIS_IPAD               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define TYIS_IPHONE             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TYIS_RETINA             ([[UIScreen mainScreen] scale] >= 2.0)

#define TYIS_IPHONE_4_OR_LESS   (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH < 568.0)
#define TYIS_IPHONE_5_OR_LESS   (TYIS_IPHONE_4_OR_LESS || TYIS_IPHONE_5)
#define TYIS_IPHONE_5           (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH == 568.0)
#define TYIS_IPHONE_6           (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH == 667.0)
#define TYIS_IPHONE_6P          (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH == 736.0)
#define TYIS_NOT_IPHONE_6P      (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH < 736.0)

#define TYIST_IPHONE_X          (TYIS_IPHONE && TYGetUIScreen_MAX_LENGTH == 812.0)

#define TYISGreatVersion11      ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0)
#pragma mark - 获取frame参数
//获取frame参数
#define TYGetViewW(v)                         v.frame.size.width
#define TYGetViewH(v)                         v.frame.size.height
#define TYGetViewX(v)                         v.frame.origin.x
#define TYGetViewY(v)                         v.frame.origin.y

#define TYGetMaxX(v)                          CGRectGetMaxX(v.frame)
#define TYGetMaxY(v)                          CGRectGetMaxY(v.frame)
#define TYGetMinX(v)                          CGRectGetMinX(v.frame)
#define TYGetMinY(v)                          CGRectGetMinY(v.frame)
#define TYGetMidX(v)                          CGRectGetMidX(v.frame)
#define TYGetMidY(v)                          CGRectGetMidY(v.frame)

#define TYGetRectX(f)                         f.origin.x
#define TYGetRectY(f)                         f.origin.y
#define TYGetRectWidth(f)                     f.size.width
#define TYGetRectHeight(f)                    f.size.height

#define IMAGE(_NAME) [UIImage imageNamed:_NAME]
#define FONT(A) [UIFont systemFontOfSize:A]
#pragma mark - 通过切图计算倍数
//通过切图计算倍数
#define TYGetUIScreenWidthRatio               (TYGetUIScreenWidth/320.0)

#define IS_IPHONE_X_Later \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define TYGetUIScreenMain                     [UIScreen mainScreen]
#define TYGetUIScreenRect                     [[UIScreen mainScreen] bounds]
#define TYGetUIScreenWidth                    [[UIScreen mainScreen] bounds].size.width
#define TYGetUIScreenHeight                   [[UIScreen mainScreen] bounds].size.height
#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)//是否是iphoneX

#define TYGetUIScreen_MAX_LENGTH              (MAX(TYGetUIScreenWidth, TYGetUIScreenHeight))
#define TYGetUIScreen_MIN_LENGTH              (MIN(TYGetUIScreenWidth, TYGetUIScreenHeight))

#pragma mark - 设置frame参数
//设置frame参数
#define TYSetRect(x, y, w, h)                 CGRectMake(x, y, w, h)
#define TYSetSize(w, h)                       CGSizeMake(w, h)
#define TYSetPoint(x, y)                      CGPointMake(x, y)
#define TYSetRectWidth(f, w)                  CGRectMake(TYGetRectX(f), TYGetRectY(f), w, TYGetRectHeight(f))
#define TYSetRectHeight(f, h)                 CGRectMake(TYGetRectX(f), TYGetRectY(f), TYGetRectWidth(f), h)
#define TYSetRectX(f, x)                      CGRectMake(x, TYGetRectY(f), TYGetRectWidth(f), TYGetRectHeight(f))
#define TYSetRectY(f, y)                      CGRectMake(TYGetRectX(f), y, TYGetRectWidth(f), TYGetRectHeight(f))
#define TYSetRectSize(f, w, h)                CGRectMake(TYGetRectX(f), TYGetRectY(f), w, h)
#define TYSetRectOrigin(f, x, y)              CGRectMake(x, y, TYGetRectWidth(f), TYGetRectHeight(f))

#define TYTableViewFooterHeight 50

#define iphoneXNav isiPhoneX?44:0

#define iphoneXbar isiPhoneX?-34:0

#define iphoneXheightbar [JGJTime  iphoneXModifybar]

#define iphoneXheightnav [JGJTime iphoneXModifynav]

#define iphoneXheightscreen [JGJTime iphoneXModifyscreen]

#define JGJ_IphoneX_BarHeight ((TYIST_IPHONE_X || IS_IPHONE_X_Later) ? 34 : 0)

#define JGJ_IphoneX_Or_Later TYIST_IPHONE_X || IS_IPHONE_X_Later
#define iphoneXHeight isiPhoneX?78:0//全局调整

#define JGJ_StatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

#define JGJ_NAV_HEIGHT (JGJ_StatusBar_Height + 44.0) //整个导航栏高度

#define JGJiphoneOffsetY 89

#pragma mark - 设置图片参数
#define PNGIMAGE(NAME)          [UIImage imageNamed:(NAME)]

#pragma mark - 判断是真机还是模拟器
//判断是真机还是模拟器
//真机
#if TARGET_OS_IPHONE
#endif

//模拟器
#if TARGET_IPHONE_SIMULATOR
#endif

#endif /* TYRectDefine_h */
