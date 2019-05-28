//
//  TYPermission.m
//  mix
//  只适配iOS8以后的
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYPermission.h"
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#import "NSString+Extend.h"

#define TYPeriOSVersion         [[[UIDevice currentDevice] systemVersion] floatValue]
#define TYPeriOS9Later          (!(TYPeriOSVersion < 9.0))
#define TYPeriOS8Later          (!(TYPeriOSVersion < 8.0))
#define TYPeriOS7Later          (!(TYPeriOSVersion < 7.0))

@implementation TYPermission

#pragma mark - 相册相关
+ (BOOL)isCanPhoto
{
//    NotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
//    Restricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
//    Denied,            // 用户已经明确否认了这一照片数据的应用程序访问
//    Authorized         // 用户已经授权应用访问照片数据} CLAuthorizationStatus;
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == PHAuthorizationStatusRestricted || authorStatus == PHAuthorizationStatusDenied ) {
        return NO;
    }
    return YES;
}

+ (BOOL)isCanPhotoWithStr:(NSString *)str
{
    if (!str) {
        str = @"请在允许浏览相册";
    }
    
    if ([self isCanPhoto]) {
        return YES;
    }else{
        [self skipWithStr:str];
        return NO;
    }
}

#pragma mark - 录音相关
//新增api,获取录音权限. 返回值,YES为可以,NO为拒绝录音.
+ (BOOL)isCanRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}


+ (BOOL)isCanRecordWithStr:(NSString *)str
{
    if (!str) {
        str = @"请允许访问你的手机麦克风";
    }
    
    if ([self isCanRecord]) {
        return YES;
    }else{
        [self skipWithStr:str];
        return NO;
    }
}

#pragma mark - 定位相关
//新增api,获取定位权限. 返回值,YES为可以,NO为拒绝定位.
+ (BOOL)isCanLocation
{
    //是否开启定位
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isCanLocationWithStr:(NSString *)str
{
    if (!str) {
        str = @"请允许开启定位";
    }
    
    if ([self isCanLocation]) {
        return YES;
    }else{
        [self skipWithStr:str];
        return NO;
    }
}

#pragma mark - 通讯录相关
//新增api,获取通讯录权限. 返回值,YES为可以,NO为拒绝获取通讯录
+ (BOOL)isCanReadAddressBook
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined && ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)isCanReadAddressBookWithStr:(NSString *)str
{
    if (!str) {
        str = @"请允许读取通讯录,便于添加联系人";
    }
    
    if ([self isCanReadAddressBook]) {
        return YES;
    }else{
       
        if ([self isShowAuthorPopView]) {
             [self skipWithStr:str];
        }
        return NO;
    }
}

+ (void)requestRecordPermission:(void (^)(AVAudioSessionRecordPermission recordPermission))callback {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    switch (audioSession.recordPermission) {
            
        case AVAudioSessionRecordPermissionGranted:
            callback(AVAudioSessionRecordPermissionGranted);
            break;
        case AVAudioSessionRecordPermissionDenied:
            [self promptRecordPermissionDeniedAlert];
            
            callback(AVAudioSessionRecordPermissionDenied);
            break;
            
        case AVAudioSessionRecordPermissionUndetermined: {
            callback(AVAudioSessionRecordPermissionUndetermined);
            
            [audioSession requestRecordPermission:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!granted) {
                        
                        [self promptRecordPermissionDeniedAlert];
                    }
                    
                    callback(granted ? AVAudioSessionRecordPermissionGranted : AVAudioSessionRecordPermissionDenied);
                });
            }];
        }
            break;
    }
}

+ (void)promptRecordPermissionDeniedAlert {
    
    [TYPermission skipWithStr:@"请允许访问你的手机麦克风"];
}


#pragma mark - 是否授权打开通信录显示弹框 1.1.0当前版本审核不通过加一个打补丁使用
+ (BOOL)isShowAuthorPopView{
    return YES;
}

+(BOOL )isCanCamera{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied){
        return NO;
    }else{
        return YES;
    }
}

+(BOOL )isCanPush
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }

    return NO;
}

+ (void)skipWithStr:(NSString *)str{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 更新界面
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
@end
