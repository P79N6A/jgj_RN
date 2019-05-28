//
//  JGLHttpRequest_AFN.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "JGLHttpRequest_AFN.h"
#import "AFNetworking.h"

#define TYHttpRequest_AFNUrl @"https://www.baidu.com/"
#define TYHttpRequest_AFNCsrName @"csrName"

@implementation JGLHttpRequest_AFN


+(NSString *)transformWithString:(NSString *)urlString{
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@",TYHttpRequest_AFNUrl,urlString];
    
    NSString* encodedString = [serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedString;
}

+ (void)GETParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[self transformWithString:@"demo"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)PostParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:[self transformWithString:@"demo"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - AFN使用证书
//2.0要注意个地方：IOS7及其以后，采用AFHTTPSessionManager，IOS7之前采用AFHTTPRequestOperationManager。
+ (AFSecurityPolicy*)customSecurityPolicy
{
    /*** SSL Pinning ***/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:TYHttpRequest_AFNCsrName ofType:@"csr"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:@[certData]];
    /**** SSL Pinning ****/

    return securityPolicy;
}

@end
