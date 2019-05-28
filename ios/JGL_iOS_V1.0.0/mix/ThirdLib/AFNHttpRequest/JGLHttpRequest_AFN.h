//
//  JGLHttpRequest_AFN.h
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

//服务器地址
#define TYHttpRequest_AFNUrl @"https://www.baidu.com/"

//证书名字
#define TYHttpRequest_AFNCsrName @"csrName"

@class TYUploadParam;
@interface JGLHttpRequest_AFN : NSObject


/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GETParameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 *  发送post请求
 *
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)PostParameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
@end
