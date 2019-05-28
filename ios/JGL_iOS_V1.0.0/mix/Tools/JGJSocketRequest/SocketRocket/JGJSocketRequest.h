//
//  JGJSocketRequest.h
//  mix
//
//  Created by yj on 16/8/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRWebSocket.h"

typedef void(^successBlock)(id values);
typedef void(^failureBlock)(NSError *error,id values);


@interface SocketRequestOperate : NSObject

//成功的block
@property (nonatomic, copy) successBlock success;

//失败的block
@property (nonatomic, copy) failureBlock failure;

//传入的参数
@property (nonatomic, copy) NSDictionary *parameters;

//超时时间
@property (nonatomic, assign) NSInteger timeOut;

@end

@interface JGJSocketRequest : NSObject

@property (nonatomic, strong, readonly) SRWebSocket *webSocket;

+ (void)closeSocket;//关闭socket

//重现连接
+ (void)socketReconnect;

+ (void)socketHeartTimerEnd; //socket心跳包结束

+ (void)socketHeartTimerStart; //socket心跳包开启

+ (instancetype)shareSocketConnect;//初始化链接

+ (void)WebSocketWithParameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure;

+ (void)WebSocketWithParameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure showHub:(BOOL )showHub;

+ (void)WebSocketAddMonitor:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure;

+ (void)WebSocketRemoveMonitor:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure;

@end
