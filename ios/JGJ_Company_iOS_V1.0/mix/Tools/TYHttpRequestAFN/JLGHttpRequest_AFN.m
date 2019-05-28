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
#import "NSString+Extend.h"
#import "TYShowMessage.h"
#import "NSString+JSON.h"
#import "JGJKnowBaseDownLoadPopView.h"
#import <UMAnalytics/MobClick.h>

#import "JGJKnowledgeDaseTool.h"

#import "JGJCustomPopView.h"

#import "JGJknowledgeDownloadTool.h"

#ifdef DEBUG
#define AFNHttpLog(...) NSLog(@"\n\nAFN调试打印信息:%@\n",[NSString stringWithFormat:__VA_ARGS__])
#else
#define AFNHttpLog(...) do { } while (0);
#endif

static JLGHttpRequest_AFN *_httpRequest_AFN;

typedef void(^HandleDownloadProgressBlock)();

@interface JLGHttpRequest_AFN ()

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, copy) HandleDownloadProgressBlock handleDownloadProgressBlock;

@property (nonatomic, assign) CGFloat timeInterval; //时间间隔

@property (nonatomic, strong) NSURLSessionDownloadTask *task; //下载任务用于取消下载

@property (nonatomic, strong) NSMutableArray *downFileModels;//保存下载模型

@property (nonatomic, strong) JGJKnowledgeDaseTool *knowledgeDaseTool; //知识库分享工具

@end

@implementation JLGHttpRequest_AFN
//2.0要注意个地方：IOS7及其以后，采用AFHTTPSessionManager，IOS7之前采用AFHTTPRequestOperationManager。
+(NSString *)transformWithString:(NSString *)urlString{
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,urlString];
    
    NSString* encodedString = [serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedString;
}

//3.1.0(api修改为Napi)要注意个地方：IOS7及其以后，采用AFHTTPSessionManager，IOS7之前采用AFHTTPRequestOperationManager。
+(NSString *)transformNapiWithString:(NSString *)urlString{
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@",JGJHttpAPIRequest_IP,urlString];
    
    NSString* encodedString = [serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedString;
}


//manger统一管理地方
+ (AFHTTPSessionManager *)getManagerByApi:(NSString *)api{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //超时时间设置
    
    mgr.requestSerializer.timeoutInterval = 30;
    
//2.3.2之前只有一种格式
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", @"text/json",nil];
    
    BOOL isTokenApi = ![api isEqualToString:@"jlupload/foremanheadimg"] || ![api isEqualToString:@"jlsignup/login"];
    NSString *jlgToken = [TYUserDefaults objectForKey:JLGToken];
    if (isTokenApi && JLGLoginBool) {
        NSString *AuthorizationStr = [NSString stringWithFormat:@"I %@",jlgToken];
        
        [mgr.requestSerializer setValue:AuthorizationStr forHTTPHeaderField:@"Authorization"];
        
        AFNHttpLog(@"AuthorizationStr %@",AuthorizationStr);
    }
    
    return mgr;
}

//显示成功的信息
+ (void )showSuccessMessageByUrl:(NSString *)url respondse:(id )responseObject parameters:(id )parameters requestOperation:(NSURLSessionDataTask * _Nullable) operation{
    AFNHttpLog(@"AFN返回信息====>>\n申请地址:%@\n返回数据%@\n上传数据:%@\n返回原始数据:%@",url,responseObject,parameters,operation.response.URL);
    
    AFNHttpLog(@"token %@",[TYUserDefaults objectForKey:JLGToken]);
    NSString *state = [NSString stringWithFormat:@"%@", responseObject[@"errno"]];
    
    NSString *errMsg = nil;
    
    errMsg = responseObject[@"errmsg"];
    
    NSInteger errNO = 0;
    
    if ([url containsString:@"napi."]) {
        
        [self showNApiMessage:responseObject];
        
    }
    
    if (![NSString isEmpty:state]) {
        
        errNO = [state integerValue];
        
        //已删除的质量安全日志不显示提示框空间不足提示
        if (errNO == 820020 || errNO == 800107 || errNO == 810507) {
            
            return;
        }
        
        if (![NSString isEmpty:errMsg] && JLGisLoginBool) {
            
            [TYShowMessage showError:errMsg];
        }
        
        if ((errNO == 10007 || errNO == 10035) && JLGisLoginBool) {
            //登录失效，需要跳转到登录界面
            [TYNotificationCenter postNotificationName:JLGLoginFail object:nil];
            
        }
        
    }
}

+ (void)showNApiMessage:(NSDictionary *)responseObject {
    
    NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
    
    if ([code integerValue] == 10035 && JLGisLoginBool) {
        
        //登录失效，需要跳转到登录界面
        [TYNotificationCenter postNotificationName:JLGLoginFail object:nil];
        
    }
    
}

//显示失败的信息
+ (void )showFailureMessageByUrl:(NSString *)url parameters:(id )parameters requestOperation:(NSURLSessionDataTask * _Nullable )operation{
    AFNHttpLog(@"AFN错误信息====>>\n申请地址:%@\n上传数据:%@\n服务器错误信息%@",url,parameters,operation.response.URL);
}

#pragma mark - Get方式
+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr GET:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success
{
    [self GetWithApi:api parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:nil];
}
+(void)PostWithOtherApi:(NSString *)api parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求花费时间:%f",[[NSDate date] timeIntervalSince1970] - requestTime);
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:api respondse:responseObject parameters:parameters requestOperation:task];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            //失败返回数据
            failure(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:api parameters:parameters requestOperation:task];
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark - Post方式
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求花费时间:%f",[[NSDate date] timeIntervalSince1970] - requestTime);
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            
            [TYShowMessage showError:responseObject[@"errmsg"]];
            //失败返回数据
            failure(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success
{
    
    [self PostWithApi:api parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:nil];
}

#pragma mark - 单个图片上传
+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [self uploadImageWithApi:api parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] image:image progress:nil success:success failure:failure];
}

+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    
    [manager POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传小于60Kb的照片
        [formData appendPartWithFileData:[TYUIImage imageData:image] name:@"head_pic" fileName:@"picImages.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        //返回正常的信息
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 多个图片上传
+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSMutableArray *)imgarray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [mgr POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接图片
        for (int i=0; i<[imgarray count]; i++)
        {
            [formData appendPartWithFileData:[TYUIImage imageData:[imgarray objectAtIndex:i]]  name:[NSString stringWithFormat:@"imgs%d",i ] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSArray *)imgarray otherDataArray:(NSArray *)otherDataPathArray dataNameArray:(NSArray *)dataNameArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformWithString:api];
    
    [mgr POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接图片
        for (int i=0; i<[imgarray count]; i++){
            [formData appendPartWithFileData:UIImageJPEGRepresentation([imgarray objectAtIndex:i],0.01) name:[NSString stringWithFormat:@"imgs%d",i ] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpeg"];
        }
        
        [otherDataPathArray enumerateObjectsUsingBlock:^(NSString *dataPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",dataPath]];
            [formData appendPartWithFileURL:fileURL name:dataNameArray[idx] fileName:[NSString stringWithFormat:@"file%@.amr",@(idx)] mimeType:@"audio/AMR" error:NULL];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger state = [responseObject[@"state"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        //返回正常的信息
        if (state == 1 && success) {
            success(responseObject[@"values"]);
        }
        
        if (state == 0 && failure) {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        if (failure) {
            failure(error);
        }
    }];
}

//3.1.0将api修改为npi换新接口
+ (void)PostWithNapi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
        
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    
    NSString *url = [self transformNapiWithString:api];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"请求花费时间:%f",[[NSDate date] timeIntervalSince1970] - requestTime);
        NSUInteger state = [responseObject[@"code"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
        //返回正常的信息
        if (state == 0 && success) {
            
            success(responseObject[@"result"]);
            
        }else if (failure) {
            
            [TYShowMessage showError:responseObject[@"msg"]];
            
            failure(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //打印并显示错误信息
        [self showFailureMessageByUrl:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] requestOperation:task];
        
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

+ (void)newUploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSArray *)imgarray otherDataArray:(NSArray *)otherDataPathArray dataNameArray:(NSArray *)dataNameArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *mgr = [self getManagerByApi:api];
    NSString *url = [self transformNapiWithString:api];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    mutableParameters[@"ver"] = currentVersion;
    
    [mgr POST:url parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:mutableParameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接图片
        for (int i=0; i<[imgarray count]; i++){
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation([imgarray objectAtIndex:i],0.01) name:[NSString stringWithFormat:@"file[%d]",i] fileName:[NSString stringWithFormat:@"pic%d.jpg",i] mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger state = [responseObject[@"code"] integerValue];
        //打印正确的信息
        [self showSuccessMessageByUrl:url respondse:responseObject parameters:[JLGHttpRequest_AFN accordingDicReturnMutableDic:parameters] requestOperation:task];
        
        //返回正常的信息
        if (state == 0 && success) {
            
            success(responseObject[@"result"]);
            
        }else {
            
            failure(nil);
            [TYShowMessage showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath downModel:(JGJKnowBaseModel *)downModel progress:(JGJDownloadProgress)progressBlock success:(JGJResponseSuccess)success failure:(JGJResponseFail)failure {
    
    //统计下载知识库
    [MobClick event:@"downloading_repository"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSString* urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    _httpRequest_AFN = [self shareHttpRequest_AFN];
    
    [_httpRequest_AFN.downFileModels addObject:downModel];
    
    [TYNotificationCenter addObserver:_httpRequest_AFN selector:@selector(handleDelDownFileNotification:) name:@"DelDownFileNotification" object:nil];
    
    _httpRequest_AFN.timeInterval = 0.5;
    
    [_httpRequest_AFN progressTimer];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
   __block NSInteger count = [[TYUserDefaults objectForKey:JGJKnowBaseShareCount] integerValue];
    
    if (count >= 5) {
        
        if (!_httpRequest_AFN.knowledgeDaseTool) {
            
            JGJKnowledgeDaseTool *tool = [JGJKnowledgeDaseTool new];
            
            _httpRequest_AFN.knowledgeDaseTool = tool;
        }
        
        _httpRequest_AFN.knowledgeDaseTool.targetVc = TYKey_Window.rootViewController;
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = @"分享成功后即可继续免费查看资料";
        desModel.leftTilte = @"取消";
        desModel.rightTilte = @"分享";
        desModel.lineSapcing = 5.0;
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        alertView.messageLable.textAlignment = NSTextAlignmentCenter;
        alertView.onOkBlock = ^{
            
            NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo_manage.jpg"];
            
            NSString *url = @"http://m.jgjapp.com/manage";
            
            NSString *title = [NSString stringWithFormat:@"%@.%@", downModel.file_name, downModel.file_type];
            
            [_httpRequest_AFN.knowledgeDaseTool showShareBtnClick:img desc:@"我在吉工宝资料库下载了该资料，更有大量专项施工资料任你免费获取！" title:title url:url];
            
        };
        
        //start ---这段代码刷新界面，不然分享之后，点同一个要点击两次才有效
        downModel.progress = 0;
        
        _httpRequest_AFN.timeInterval = 2;
        
        _httpRequest_AFN.handleDownloadProgressBlock = ^{
            
            if (progressBlock) {
                
                // 在此处间隔0.1进行UI刷新
                
                JGJKnowBaseModel *knowBaseModel = downModel;
                
                CGFloat progress = 0.0;
                
                knowBaseModel.progress = progress;
                
                if ([_httpRequest_AFN.downFileModels containsObject:knowBaseModel]) {
                    
                    [TYNotificationCenter postNotificationName:@"downFileNotification" object:knowBaseModel];
                    
                    progressBlock(0, 100);
                }
                
                [_httpRequest_AFN.progressTimer invalidate];
                
                _httpRequest_AFN.progressTimer = nil;
            }
            
        };
        //end ---
        return;
        
    }else {
        
//        count += 1;
//
//        [TYUserDefaults setObject:@(count) forKey:JGJKnowBaseShareCount];
    }
    
    JGJKnowBaseDownLoadPopView *popView = [JGJKnowBaseDownLoadPopView knowBaseDownLoadPopViewWithModel:downModel];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //大于10M更新间隔2s
        if (downloadProgress.totalUnitCount > 10485760) {
            
            _httpRequest_AFN.timeInterval = 2;
        }
        
        dispatch_async(mainQueue, ^{
            
            // 在此处间隔0.1进行UI刷新
            
            JGJKnowBaseModel *knowBaseModel = downModel;
            
            _httpRequest_AFN.handleDownloadProgressBlock = ^{
                
                if (progressBlock) {
                    
                    CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                    
                    knowBaseModel.progress = progress;
                    
                    if (progress == 1.0) {
                        
                         knowBaseModel.downloaddate = [NSDate date].timestamp;
                        
                        [JGJknowledgeDownloadTool addCollectKnowBaseModel:knowBaseModel];
                        
                    }
                    
                    //发出通知其他页面使用，搜索之类的使用正在下载
                    
                    //当前下载模型包含的话返回，下载完毕移除
                    if ([_httpRequest_AFN.downFileModels containsObject:knowBaseModel]) {
                        
                        [TYNotificationCenter postNotificationName:@"downFileNotification" object:knowBaseModel];
                        
                        progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount); //下载中列表进度不需要
                    }
                    
                }
                
            };
            
            CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            
            if (progress == 1) {
                
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                
                //下载完毕移除下载模型
                [_httpRequest_AFN.downFileModels removeObject:downModel];
                
                knowBaseModel.progress = 1;
                
                [TYNotificationCenter postNotificationName:@"downFileNotification" object:knowBaseModel];
                
                //下载完毕移除下载进度弹框
                [popView dismiss];
                
                count += 1;
                
                [TYUserDefaults setObject:@(count) forKey:JGJKnowBaseShareCount];

            }
            
            //取消下载
            popView.handleKnowBaseCancelDownLoadBlock = ^(JGJKnowBaseModel *knowBaseModel) {
                
                knowBaseModel.progress = 0; //取消之后进度从0开始
                
                [_httpRequest_AFN downCancel];
                
                [TYShowMessage showPlaint:@"读取已取消"];
                
                //刷新cell进度，返回0
                progressBlock(0, downloadProgress.totalUnitCount);
                
            };
            
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:saveToPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        AFNHttpLog(@"filePath = %@  error = %@", filePath, error);
        
        dispatch_async(mainQueue, ^{
            // 在此处进行UI刷新
            
            if (!error) {
                if (success) {
                    
                    //                    [_httpRequest_AFN.progressTimer invalidate];
                    
                    success(filePath);
                }
            }else{
                if (failure) {
                    
                    //                    [_httpRequest_AFN.progressTimer invalidate];
                    failure(error);
                }
            }
        });
        
        
    }];
    
    _httpRequest_AFN.task = task;
    
    [task resume];
}

#pragma mark - Session 下载下载文件
+ (void)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath success:(void (^)(NSString *fileURL,NSString *fileName))success fail:(void (^)())fail
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString* urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    __block NSString *path;
    __block NSString *name;
    NSURLSessionDownloadTask *task = [mgr downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //指定下载文件保存的路径
        return [NSURL fileURLWithPath:saveToPath];
        
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

- (NSTimer *)progressTimer {
    
    if (!_progressTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:_httpRequest_AFN.timeInterval target:self selector:@selector(freshProgress:) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    }
    
    return _progressTimer;
}

- (void)freshProgress:(NSTimer *)timer {
    
    if (self.handleDownloadProgressBlock) {
        
        self.handleDownloadProgressBlock();
    }
    
    if (_httpRequest_AFN.downFileModels.count == 0) {
        
        [_httpRequest_AFN.progressTimer invalidate];
        
        _httpRequest_AFN.progressTimer = nil;
    }
    
}

- (void)handleDelDownFileNotification:(NSNotification *)notification {
    
    [self downCancel];
}

- (void)downCancel {
    
    if (_httpRequest_AFN.task.state == NSURLSessionTaskStateRunning) {
        
        [_httpRequest_AFN.task cancel];
    }
    [_httpRequest_AFN.progressTimer invalidate];
    _httpRequest_AFN.progressTimer = nil;
}


+ (NSDictionary *)accordingDicReturnMutableDic:(id)dic
{
    
    NSArray *array = [NSArray array];
    array = [JGJSHA1Sign componentsSeparatedByString:@"-"];
    NSMutableDictionary *SignParmDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [SignParmDic setObject:array.firstObject forKey:@"sign"];
    //时间戳
    [SignParmDic setObject:array.lastObject forKey:@"timestamp"];
    //客户端类型
    [SignParmDic setObject:@"manage" forKey:@"client_type"];
    // 移动平台(区分iOS和android)
    [SignParmDic setObject:@"I" forKey:@"os"];
    //版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [SignParmDic setObject:currentVersion forKey:@"ver"];
    NSDictionary *ParmsDIC = [[NSDictionary alloc]initWithDictionary:SignParmDic];
    return ParmsDIC;

}

#pragma mark - 下载文件时使用
+ (instancetype)shareHttpRequest_AFN
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _httpRequest_AFN = [[self alloc] init];
        
    });
    return _httpRequest_AFN;
}

- (NSMutableArray *)downFileModels {
    
    if (!_downFileModels) {
        
        _downFileModels = [NSMutableArray new];
    }
    
    return _downFileModels;
    
}
@end
