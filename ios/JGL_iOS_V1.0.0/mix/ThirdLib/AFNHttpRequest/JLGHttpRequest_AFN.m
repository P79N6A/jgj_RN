//
//  JLGHttpRequest_AFN.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "JLGHttpRequest_AFN.h"
#import "AFNetworking.h"
//自己封装的工具库
#import "TYUIImage.h"
#import "TYShowMessage.h"
#import "NSString+JSON.h"
#import "JLGHttpDataArray.h"


#ifdef DEBUG
#define AFNHttpLog(...) NSLog(@"\n\nTony调试打印信息:%@\n",[NSString stringWithFormat:__VA_ARGS__])
#else
#define AFNHttpLog(...) do { } while (0);
#endif

@implementation JLGHttpRequest_AFN
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

+(NSString *)transformWithString:(NSString *)urlString{
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_AFNUrl,urlString];
    
    NSString* encodedString = [serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedString;
}

//manger统计管理地方
+ (AFHTTPRequestOperationManager *)getManagerByApi:(NSString *)api{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    BOOL isTokenApi = ![api isEqualToString:@"jlupload/foremanheadimg"] || ![api isEqualToString:@"jlsignup/login"];
    NSString *jlgToken = [UserDefaults objectForKey:JLGToken];
    if (isTokenApi && JLGLoginBool) {
        NSString *AuthorizationStr = [NSString stringWithFormat:@"I %@",jlgToken];
        
        [mgr.requestSerializer setValue:AuthorizationStr forHTTPHeaderField:@"Authorization"];
        
        AFNHttpLog(@"AuthorizationStr %@",AuthorizationStr);
    }

    return mgr;
}

//显示成功的信息
+ (void )showSuccessMessageByUrl:(NSString *)url respondse:(id )responseObject parameters:(id )parameters requestOperation:(AFHTTPRequestOperation * )operation{
    AFNHttpLog(@"AFN返回信息====>>\n申请地址:%@\n返回数据%@\n上传数据:%@\n返回原始数据:%@",url,responseObject,parameters,operation.responseString);
    
    AFNHttpLog(@"token %@",[UserDefaults objectForKey:JLGToken]);
    NSUInteger state = [responseObject[@"state"] integerValue];
    NSString *errMsg = nil;
    errMsg = responseObject[@"errmsg"];
    
    NSInteger errNO = 0;
    if (responseObject[@"errno"] != [NSNull null]) {
        errNO = [responseObject[@"errno"] integerValue];
        
        if (![errMsg isEqualToString:@""] && state == 0) {
            [TYShowMessage showError:errMsg];
        }
        
        if (errNO == 10007 || errNO == 10035) {
            //登录失效，需要跳转到登录界面
            [TYNotificationCenter postNotificationName:JLGLoginFail object:nil];
        }
    }
}

//显示失败的信息
+ (void )showFailureMessageByUrl:(NSString *)url parameters:(id )parameters requestOperation:(AFHTTPRequestOperation *)operation{
    AFNHttpLog(@"AFN错误信息====>>\n申请地址:%@\n上传数据:%@\n服务器错误信息%@",url,parameters,operation.responseString);
}

#pragma mark - Get方式
+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr GET:url parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:mutableParameters requestOperation:operation];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:mutableParameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success
{
    [self GetWithApi:api parameters:parameters success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:nil];
}

#pragma mark - Post方式
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr POST:url parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:mutableParameters requestOperation:operation];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:mutableParameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success
{
    [self PostWithApi:api parameters:parameters success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:nil];
}

#pragma mark - 单个图片上传
+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传小于60Kb的照片
        [formData appendPartWithFileData:[TYUIImage imageData:image] name:@"head_pic" fileName:@"picImages.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:parameters requestOperation:operation];
        
        //返回正常的信息
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:parameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 上传身份证
+ (void)uploadIDCardWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSMutableArray *)imgarray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *idCardFileName = @[@"head_pic",@"idc_face",@"idc_back"];
        //拼接图片
        for (int i=0; i< 3; i++)
        {
            //上传小于60Kb的照片
            [formData appendPartWithFileData:[TYUIImage imageData:[imgarray objectAtIndex:i]] name:idCardFileName[i] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:parameters requestOperation:operation];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:parameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 多个图片上传
+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSMutableArray *)imgarray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //拼接图片
        for (int i=0; i<[imgarray count]; i++)
        {
            [formData appendPartWithFileData:[TYUIImage imageData:[imgarray objectAtIndex:i]]  name:[NSString stringWithFormat:@"imgs%d",i ] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:parameters requestOperation:operation];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:parameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSArray *)imgarray otherDataArray:(NSArray *)otherDataPathArray dataNameArray:(NSArray *)dataNameArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //拼接图片
        for (int i=0; i<[imgarray count]; i++){
            [formData appendPartWithFileData:UIImageJPEGRepresentation([imgarray objectAtIndex:i],0.01) name:[NSString stringWithFormat:@"imgs%d",i ] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpeg"];
        }
        
        [otherDataPathArray enumerateObjectsUsingBlock:^(NSString *dataPath, NSUInteger idx, BOOL * _Nonnull stop) {
           NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",dataPath]];
           [formData appendPartWithFileURL:fileURL name:dataNameArray[idx] fileName:[NSString stringWithFormat:@"file%@.amr",@(idx)] mimeType:@"audio/AMR" error:NULL];
        }];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:parameters requestOperation:operation];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:parameters requestOperation:operation];
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Session 下载下载文件
+ (void)downloadWithUrl:(NSString *)url success:(void (^)(NSString *fileURL,NSString *fileName))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSString *urlString = [self transformWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    __block NSString *path;
    __block NSString *name;
    NSURLSessionDownloadTask *task = [mgr downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //指定下载文件保存的路径
        AFNHttpLog(@"targetPath = %@ response.suggestedFilename = %@", targetPath, response.suggestedFilename);
        
        //将下载文件保存在缓存路径中
        path = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        name = response.suggestedFilename;
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        AFNHttpLog(@"filePath = %@  error = %@", filePath, error);
        
        if (!error) {
            if (success) {
                success(path,name);
            }
        }else{
            if (fail) {
                fail();
            }
        }
    }];

    [task resume];
}
@end
