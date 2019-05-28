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

//ifndef 就是开发测试环境，ifdef 就是正式环境
#ifndef DEBUG
//正式环境

#define JGJHttpAPIRequest_IP        @"https://napi.jgjapp.com/"
#define JLGHttpRequest_IP           @"https://api.jgjapp.com/"
#define JLGHttpRequest_WX           @"https://wx1.jgjapp.com/"
#define JLGHttpRequest_M            @"https://m.jgjapp.com/"
#define JGJ_WebSocket_IP            @"wss://ws.jgjapp.com/websocket"
#define JLGHttpRequest_WX2          @"https://wx2.jgjapp.com/"
#define JGJWebFindHelperURL         @"https://nm.jgjapp.com/mjob" //找帮手 1.1.0正式
#define JGJWebDiscoverURL           @"https://nm.jgjapp.com/" //发现
#define JLGHttpRequest_IP_center     @"https://cdn.jgjapp.com/" //中心裁剪

#define JGJWebDomainURL           @"nm.jgjapp.com" //发现2.0.0-判断H5域名用于判断是内部地址还是外部地址

#define JLGHttpRequest_Source       JLGHttpRequest_M
#define JLGHttpRequest_Public       JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl_center_image JLGHttpRequest_IP_center

#define WXMiniProTypeRelease    YES //这个是正式的小程序

#else

//如果注释掉，就是开发环境，如果不注释就是测试
#define Releasehttp YES

//测试环境
#ifdef Releasehttp

////这里是beta地址
//#define JGJHttpAPIRequest_IP           @"http://napi.beta.jgjapp.com/"
//#define JLGHttpRequest_IP           @"http://api.beta.jgjapp.com/"
//#define JLGHttpRequest_WX           @"http://wx1.beta.jgjapp.com/"
//#define JLGHttpRequest_M            @"http://m.beta.jgjapp.com/"
//#define JGJ_WebSocket_IP            @"ws://napi.beta.jgjapp.com/websocket"
//#define JLGHttpRequest_WX2          @"http://wx2.beta.jgjapp.com/"
//#define JGJWebFindHelperURL         @"http://nm.beta.jgjapp.com/mjob" //找帮手 1.1.0测试
//#define JGJWebDiscoverURL           @"http://nm.beta.jgjapp.com/" //发现2.1.2-yj
//#define JLGHttpRequest_IP_center    @"http://beta.cdn.jgjapp.com/" //中心裁剪
//#define JGJWebDomainURL           @"nm.beta.jgjapp.com" //发现2.0.0-判断H5域名用于判断是内部地址还是外部地址

//这里是test地址

#define JGJHttpAPIRequest_IP        @"http://napi.test.jgjapp.com/"
#define JLGHttpRequest_IP           @"http://api.test.jgjapp.com/"
#define JLGHttpRequest_WX           @"http://wx1.test.jgjapp.com/"
#define JLGHttpRequest_M            @"http://m.test.jgjapp.com/"
#define JGJ_WebSocket_IP            @"ws://ws.test.jgjapp.com/websocket"//@"ws://napi.test.jgjapp.com/websocket"
#define JLGHttpRequest_WX2          @"http://wx2.test.jgjapp.com/"
#define JGJWebFindHelperURL         @"http://nm.test.jgjapp.com/mjob" //找帮手 1.1.0测试
#define JGJWebDiscoverURL           @"http://nm.test.jgjapp.com/" //发现2.1.2-yj
#define JLGHttpRequest_IP_center    @"http://test.cdn.jgjapp.com/" //中心裁剪
#define JGJWebDomainURL           @"nm.test.jgjapp.com" //发现2.0.0-判断H5域名用于判断是内部地址还是外部地址

#define JLGHttpRequest_Source       JLGHttpRequest_M
#define JLGHttpRequest_Public       JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl_center_image JLGHttpRequest_IP_center

#define WXMiniProTypeRelease    NO //这个是体验的小程序

#else

#define JGJHttpAPIRequest_IP           @"http://napi.ex.yzgong.com/"
#define JLGHttpRequest_IP           @"http://api.ex.yzgong.com/"
#define JLGHttpRequest_WX           @"http://wx1.ex.yzgong.com/"
#define JLGHttpRequest_M            @"http://m.ex.yzgong.com/"
#define JGJ_WebSocket_IP            /*@"ws://192.168.1.242:9509"*/@"ws://ws.ex.yzgong.com/websocket"
#define JLGHttpRequest_WX2          @"http://wx2.ex.yzgong.com/"

#define JGJWebFindHelperURL         @"http://nm.ex.yzgong.com/mjob" //找帮手 1.1.0开发
#define JGJWebDiscoverURL           @"http://nm.ex.yzgong.com/" //发现2.1.2-yj

#define JLGHttpRequest_IP_center         @"http://ex.cdn.yzgong.com/" //中心裁剪

#define JGJWebDomainURL           @"nm.ex.jgjapp.com" //发现2.0.0-判断H5域名用于判断是内部地址还是外部地址

#define JLGHttpRequest_Source       JLGHttpRequest_M
#define JLGHttpRequest_Public       JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl JLGHttpRequest_IP
#define JLGHttpRequest_UpLoadPicUrl_center_image JLGHttpRequest_IP_center

#define WXMiniProTypeRelease    NO //这个是体验的小程序

#endif
#endif

#define TYHttpCompressionQuality 0.8
#define TYHttpRequest_AFNCsrName @"csrName"

#define JLGHttpImageJPEGRepQuality  0.01

/*!
 *
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^JGJDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead);

typedef JGJDownloadProgress HYBGetProgress;
typedef JGJDownloadProgress HYBPostProgress;

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
//typedef NSURLSessionTask HYBURLSessionTask;
typedef void(^JGJResponseSuccess)(id response);
typedef void(^JGJResponseFail)(NSError *error);

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
 *  @param api        全部地址
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)PostWithOtherApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 */
+ (void)PostWithApi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success;

/**
 *  上传单张图片
 *
 *  @param api
 *  @param parameters
 *  @param image
 *  @param success
 *  @param failure
 */
+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  上传单张图片带进度条
 *
 *  @param api
 *  @param parameters
 *  @param image
 *  @param success
 *  @param failure
 */
+ (void)uploadImageWithApi:(NSString *)api parameters:(id)parameters image:(UIImage *)image progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

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

+ (void)newUploadImagesWithApi:(NSString *)api parameters:(id)parameters imagearray:(NSArray *)imgarray otherDataArray:(NSArray *)otherDataPathArray dataNameArray:(NSArray *)dataNameArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  下载文件
 *
 *  @param url     文件的url
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)downloadWithUrl:(NSString *)url success:(void (^)(NSString *fileURL,NSString *fileName))success fail:(void (^)())fail;

/*!
 *
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (void)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath downModel:(NSObject *)downModel progress:(JGJDownloadProgress)progressBlock success:(JGJResponseSuccess)success failure:(JGJResponseFail)failure;

//3.1.0新接口域名修改添加api变更为npi

/**
 *  发送post请求
 *
 *  @param api        请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)PostWithNapi:(NSString *)api parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath success:(void (^)(NSString *fileURL,NSString *fileName))success fail:(void (^)())fail;

@end
