//
//  JLGHttpRequest_AFN.h
//  TYDebugDemo
//
//  Created by Tony on 15/10/22.
//  Copyright © 2015年 tony. All rights reserved.
#import <Foundation/Foundation.h>

//@"http://api.yzgong.com/"//正式
//@"http://api.test.yzgong.com/"//测试
//@"http://192.168.1.242:81/" //开发服务器

//#define Release YES//正式环境
#ifdef Release
#define JLGHttpRequest_IP           @"http://api.yzgong.com/"
#define JLGHttpRequest_AFNUrl       JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl JLGHttpRequest_IP
#else
#define JLGHttpRequest_IP           @"http://192.168.1.242:81/"
#define JLGHttpRequest_AFNUrl       [NSString stringWithFormat:@"%@%@",JLGHttpRequest_IP,@"interface/public/"]
#define JLGHttpRequest_UpLoadPicUrl [NSString stringWithFormat:@"%@%@",JLGHttpRequest_IP,@"interface/app/"]
#endif

#define TYHttpCompressionQuality 0.8
#define TYHttpRequest_AFNCsrName @"csrName"

#define JLGHttpImageJPEGRepQuality  0.01

typedef NS_ENUM(NSUInteger, RoleType) {
    RoleTypeMate = 1,
    RoleTypeLeader
};

@class TYUploadParam;
@interface JLGHttpRequest_AFN : NSObject


/**
 *  发送get请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 *  发送get请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 */
+ (void)GetWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success;

/**
 *  发送post请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  发送post请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 */
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success;

/**
 *  上传身份证
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param imgarray   图片数组
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)uploadIDCardWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSMutableArray *)imgarray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  上传多张图片
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param imgarray   图片数组
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSMutableArray *)imgarray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  上传多张图片和文件
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param imgarray   图片数组
 *  @param otherDataPath 其他文件的文件路径的数组
 *  @param dataName      需要传的文件名的数组
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)uploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSArray *)imgarray otherDataArray:(NSArray *)otherDataPathArray dataNameArray:(NSArray *)dataNameArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  下载文件
 *
 *  @param url     文件的url
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)downloadWithUrl:(NSString *)url success:(void (^)(NSString *fileURL,NSString *fileName))success fail:(void (^)())fail;

/**
 *  上传单张图片
 *
 *  @param api        <#api description#>
 *  @param parameters <#parameters description#>
 *  @param image      <#image description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
