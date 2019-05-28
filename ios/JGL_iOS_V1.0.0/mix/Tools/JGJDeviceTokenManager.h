//
//  JGJDeviceTokenManager.h
//  mix
//
//  Created by Json on 2019/5/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JGJDeviceTokenManager : NSObject

/**
 上传channelID(DeviceToken)
 @param token DeviceToken
 */
+ (void)postDeviceToken:(NSString *)token;
/**
 上传channelID(DeviceToken),并回调
 @param token DeviceToken
 */
+ (void)postDeviceToken:(NSString *)token success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end


