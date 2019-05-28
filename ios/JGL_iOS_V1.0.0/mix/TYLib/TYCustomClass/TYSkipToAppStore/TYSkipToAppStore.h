//
//  TYSkipToAppStore.h
//  TYSamples
//
//  Created by Tony on 2016/11/10.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SkipToAppStoreType) {
    ToAppStoreTypeDefault = 0,
    ToAppStoreTypeDay,//通过时间
    ToAppStoreTypeOpenConut//通过打开次数
};

@interface TYSkipToAppStore : NSObject<UIAlertViewDelegate>
/*
 *  需要跳转的AppID
 */
@property (nonatomic,copy) NSString *appID;//appID

/*
 *  弹出的标题，默认没有
 */
@property (nonatomic,copy) NSString *showTitle;

/*
 *  弹出的内容,不设置就使用默认的
 */
@property (nonatomic,assign) NSString *showMessage;

/*
 *  拒绝，不设置就使用默认的
 */
@property (nonatomic,assign) NSString *showRefuseStr;

/*
 *  同意，不设置就使用默认的
 */
@property (nonatomic,assign) NSString *showAcceptStr;

/*
 *  升级以后是否需要弹出，默认不弹出
 */
@property (nonatomic,assign) BOOL showAfterUpdate;

/*
 *  弹出以后，经过多少天再弹出,默认是15天
 */
@property (nonatomic,assign) NSUInteger showAgainAfterDays;

/*
 *  打开app的次数,默认20次
 */
@property (nonatomic,assign) NSUInteger openAppCount;

/*
 *  弹出判断的方式，有通过时间的判断和通过次数的判断
 */
@property (nonatomic,assign) SkipToAppStoreType skipType;

/*
 *  弹出提示框，如果没有设置弹出的判断方式，默认使用时间判断
 */
- (void)skipToAppStore:(UIViewController *)Vc;

/*
 *  弹出提示框，通过设置的弹出方式来进行时间或者次数的选择
 */
- (void)skipToAppStore:(UIViewController *)Vc type:(SkipToAppStoreType )skipType;

/*
 *  弹出提示框，如果没有设置弹出的判断方式，默认使用时间判断
 */
+ (void)skipToAppStore:(UIViewController *)Vc appID:(NSString *)appID;

/*
 *  弹出提示框，通过设置的弹出方式来进行时间或者次数的选择
 */
+ (void)skipToAppStore:(UIViewController *)Vc type:(SkipToAppStoreType )skipType appID:(NSString *)appID;
@end
