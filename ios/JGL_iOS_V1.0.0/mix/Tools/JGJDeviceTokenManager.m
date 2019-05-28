//
//  JGJDeviceTokenManager.m
//  mix
//
//  Created by Json on 2019/5/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJDeviceTokenManager.h"

@implementation JGJDeviceTokenManager

+ (void)postDeviceToken:(NSString *)token
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel_id"] = token;
    params[@"service_type"] = @"umeng";
    [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:params success:^(id responseObject) {
        TYLog(@"===上传channelID成功==>");
    } failure:^(NSError *error) {
        TYLog(@"===上传channelID失败==>%@",error);
    }];
}

+ (void)postDeviceToken:(NSString *)token success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    //上传channelID
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel_id"] = token;
    params[@"service_type"] = @"umeng";
    [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:params success:success failure:failure];
}

@end
