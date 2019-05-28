//
//  TYPermission.m
//  mix
//  只适配iOS8以后的
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecordingServices.h"

@interface TYPermission : NSObject
/**
 *  图片相关
 */
+ (BOOL)isCanPhoto;

+ (BOOL)isCanPhotoWithStr:(NSString *)str;

/**
 *  录音相关
 */
+ (BOOL)isCanRecord;

+ (BOOL)isCanRecordWithStr:(NSString *)str;

/**
 *  定位相关
 */
+ (BOOL)isCanLocation;

+ (BOOL)isCanLocationWithStr:(NSString *)str;

/**
 *  通讯录相关
 */
+ (BOOL)isCanReadAddressBook;

+ (BOOL)isCanReadAddressBookWithStr:(NSString *)str;

/**
 *  相机相关
 */
+(BOOL )isCanCamera;

/**
 *  推送相关
 */
+(BOOL )isCanPush;

/**
 *  自定义
 */
+ (void)skipWithStr:(NSString *)str;

/**
 *  语音权限
 */
+ (void)requestRecordPermission:(void (^)(AVAudioSessionRecordPermission recordPermission))callback;
@end
