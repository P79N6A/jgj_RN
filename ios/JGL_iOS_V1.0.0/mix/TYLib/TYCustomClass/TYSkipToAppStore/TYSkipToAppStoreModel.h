//
//  TYSkipToAppStoreModel.h
//  TYSamples
//
//  Created by Tony on 2016/11/10.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <Foundation/Foundation.h>
//当前的Build版本号
#define  KToAppStore_ShortBuildVer @"CFBundleShortVersionString"

//上次保存天数
#define  KToAppStore_OldDays @"toAppStoreOldDays"

//上次保存的Build版本号
#define  KToAppStore_LocalBuildVer @"oldshortBuildVer"

//用户之前的选择
#define  KToAppStore_OldChoose @"userOldChoose"

//打开app的次数
#define  KToAppStore_OpenAppCount @"openAppCount"

@interface TYSkipToAppStoreModel : NSObject

//上一次用户的选择
@property (nonatomic,assign) NSUInteger oldChoose;

//当前的Build版本号
@property (nonatomic,assign) CGFloat shortBuildVer;

//上次保存的Build版本号
@property (nonatomic,assign) CGFloat oldshortBuildVer;

//上次保存天数
@property (nonatomic,assign) NSUInteger oldToAppStoreDays;

//当前的天数
@property (nonatomic,assign) NSUInteger nowDays;

//当前时间和上次跳转时间相差的天数
@property (nonatomic,assign) NSUInteger dValueDays;

//打开app的次数
@property (nonatomic,assign) NSUInteger openAppCount;

@end
