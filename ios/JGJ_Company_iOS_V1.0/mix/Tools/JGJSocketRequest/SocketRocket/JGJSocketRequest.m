//
//  JGJSocketRequest.m
//  mix
//
//  Created by yj on 16/8/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSocketRequest.h"
#import "NSString+Extend.h"
#import "JGJCommonTool.h"
#import "AFNetworkReachabilityManager.h"

#import "JGJSocketRequest+ChatMsgService.h"

#import "JGJChatOffLineMsgTool.h"


#ifdef DEBUG
#define JGJSocketLog(...) NSLog(@"\n\nTony调试打印信息:%@\n",[NSString stringWithFormat:__VA_ARGS__])
#else
#define JGJSocketLog(...) do { } while (0);
#endif

static const CGFloat kSocketReconnectTime = 3.0f;//socket重连时间

@implementation SocketRequestOperate
- (void)setTimeOut:(NSInteger)timeOut{
    _timeOut = timeOut;
    
    //3.3.0去掉因聊天查看图片有时闪退问题
    //    if ([self isKindOfClass:NSClassFromString(@"SocketRequestOperate")]) {
    //
    //        [self performSelector:@selector(isTimeOut) withObject:nil afterDelay:timeOut];
    //    }
    
}

#pragma mark - 超时处理
////3.3.0去掉因聊天查看图片有时闪退问题
//- (void)isTimeOut{
//    if (self.failure) {
//        self.failure(nil,self.parameters);
//    }
//}
@end
static JGJSocketRequest *_socketRequest;
@interface JGJSocketRequest ()
<
SRWebSocketDelegate
>
@property (nonatomic, strong) SRWebSocket *webSocket;

//心跳的计时器
@property (nonatomic, strong) NSTimer* heartTimer;

//保存请求的参数，用于连接成功后用
@property (nonatomic, strong) NSMutableDictionary *reconnectSuccessDic;

//保存success,failure,parameters的dic
@property (nonatomic, strong) NSMutableDictionary *operatesDic;

//@property (nonatomic, assign) BOOL timerInvalidate;//进入后台timer失效，进入前台有效

@end


@implementation JGJSocketRequest

+ (instancetype)shareSocketConnect
{
    NSString *myUid = [TYUserDefaults objectForKey:JLGToken];
    
    if ([NSString isEmpty:myUid] || !JLGisLoginBool) {
        
        return nil;
    }
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _socketRequest = [[self alloc] init];
        
        [_socketRequest reconnect];
    });
    
    return _socketRequest;
}

+ (void)closeSocket{
    
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    
    [socketRequest.webSocket close];
    
    //这句话很重要清除之前的通道
    socketRequest.webSocket = nil;
    
    TYLog(@"**********手动关了socket**********");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _operatesDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)reconnectWithSuccessDic:(NSDictionary *)dic{
    
    self.reconnectSuccessDic = dic.copy;
    
    switch (self.webSocket.readyState) {
        case SR_CONNECTING:
        {
            TYLog(@"Websocket 正在连接");
            
        }
            break;
            
        case SR_OPEN:
        {
            TYLog(@"Websocket 已连接");
            
        }
            break;
        case SR_CLOSING:
        {
            TYLog(@"Websocket 正在关闭");
        }
            break;
        case SR_CLOSED:
        {
            TYLog(@"Websocket 关闭");
            
        }
            break;
        default:
            break;
    }
    
    //如果关闭了就重置
    if (self.webSocket.readyState >= SR_CLOSING) {
        self.webSocket.delegate = nil;
        [self.webSocket close];
        self.webSocket = nil;
        TYLog(@"self.webSocket = nil=allocsocketUrlConnect");
    }
    
    if (self.webSocket == nil) {
        
        self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self socketUrl]]]];
        
        TYLog(@"allocsocketUrlConnect-------%@", [self socketUrl]);
    }
    TYLog(@"socketUrlConnect-------%@", [self socketUrl]);
    
    if (self.webSocket.delegate == nil) {
        self.webSocket.delegate = self;
    }
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    //如果是connetcting就可以open,如果是open就没有必要open
    BOOL isConnecting = (self.webSocket.readyState == SR_CONNECTING);
    BOOL isReachableStatus = status != AFNetworkReachabilityStatusNotReachable;
    
    if (isConnecting && isReachableStatus && self.webSocket.readyState != SR_OPEN) {
        TYLog(@"isConnecting =  %d,self.webSocket.readyState = %@",isConnecting,@(self.webSocket.readyState));
        
        [self.webSocket open];
    }
}

- (void)reconnect {
    
    //没有token不能重连
    
    NSString *token = [TYUserDefaults objectForKey:JLGToken];
    
    if ([NSString isEmpty:token]) {
        
        return;
    }
    
    [self.webSocket close];
    
    [self reconnectWithSuccessDic:nil];
    
}

#pragma mark - socket重连获取离线消息
+ (void)requestOfflineMsg {
    
    if (!JGJIslLaunchOfflineMsgBool) {

        [JGJChatOffLineMsgTool getOfflineMessageListCallBack:^(NSArray *msglist) {

            TYLog(@"socket连接拉离线消息--%@",@(msglist.count));

        }];
    }
    
}

#pragma mark - socket重新连接
+ (void)socketReconnect{
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    [socketRequest reconnect];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    TYLog(@"Websocket 已经连接");
    if (self.reconnectSuccessDic) {
        
        
        [self sendWebSocketRequest:self.reconnectSuccessDic];
        self.reconnectSuccessDic = nil;
    }
    
    [self heartTimerStart];
    JGJSocketLog(@"Websocket 已经连接");
    
    //重连到打开拉取离线消息 3.5.0去掉socket断开到打开拉取离线消息
    
    if (webSocket.readyState == SR_OPEN) {
        
//        [JGJSocketRequest requestOfflineMsg];
        
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    TYLog(@" Websocket 连接失败 Error %@", error);
    
    [self webSocketFailWithError:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    NSDictionary *receiveMessageDic = [self dictionaryWithJsonString:message];
    JGJSocketLog(@"接收的Json内容 %@", message);
    JGJSocketLog(@"接收的内容 %@", receiveMessageDic);
    
    NSString *keyStr = receiveMessageDic[@"action"];
    
    //    if (msgList.count > 0 && [receiveMessageDic[@"action"] isEqualToString:@"sendMessage"]) {
    //
    //        keyStr = [self configKeyStr:receiveMessageDic keyStr:keyStr];
    //
    //    }else {
    //
    //        keyStr = [self configKeyStr:receiveMessageDic keyStr:keyStr];
    //    }
    
    NSInteger code = [receiveMessageDic[@"code"] integerValue];
    
    SocketRequestOperate *srOperate = self.operatesDic[keyStr];
    
    if ([receiveMessageDic[@"code"] intValue] == 0) {
        
        [JGJSocketRequest insertWebSocketReceiveChatMsg:receiveMessageDic];
        
    }else {
        // 如果是转发的消息,发送失败后不提示错误
        NSDictionary *result = receiveMessageDic[@"result"];
        NSInteger isSource = [result[@"is_source"] integerValue];
        if (isSource != 1 && isSource != 2) {
            [TYShowMessage showError: receiveMessageDic[@"msg"]];
        }
    }
    
    if ([receiveMessageDic[@"code"] intValue] == 0) {
        
        if (srOperate.success) {
            
            NSArray *msgList = receiveMessageDic[@"result"];
            
            if ([msgList isKindOfClass:[NSArray class]]) {
                
                if (msgList.count > 0) {
                    
                    srOperate.success(msgList);
                    
                }
            }else {
                
                srOperate.success(receiveMessageDic[@"result"]);
                
            }
            
            srOperate.failure = nil;
            
        }
        
    }
    
    //关闭的聊天
    if (code == 800032) {
        
        if (![NSString isEmpty:receiveMessageDic[@"msg"]] && JLGisLoginBool) {
            
            [TYShowMessage showError:receiveMessageDic[@"msg"]];
        }
        
        return;
    }

    if (code == 10035 && JLGisLoginBool) {
        
        //        //登录失效，需要跳转到登录界面
        [TYNotificationCenter postNotificationName:JLGLoginFail object:nil];
        
        if (![NSString isEmpty:receiveMessageDic[@"msg"]]) {
            
            [TYShowMessage showError:receiveMessageDic[@"msg"]];
        }
        
        return;
    }
    
    if (!srOperate) {
        return;
    }
    
    if (code == 800076) {
        
        return;
    }
    
    if ([receiveMessageDic[@"state"] intValue] == 1) {
        if (srOperate.success) {
            srOperate.success(receiveMessageDic[@"values"]);
            srOperate.failure = nil;
            
        }
    } else {
        if (code == 800050) {
            //扫描加入
            if (srOperate.failure) {
                srOperate.failure(nil,receiveMessageDic[@"errno"]);
            }
        }

        if (srOperate.failure) {
            srOperate.failure(nil,receiveMessageDic);
        }
    }
    
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    JGJSocketLog(@"WebSocket 关闭 ---%@", reason);
    
    NSString *token = [TYUserDefaults objectForKey:JLGToken];
    
    if ([NSString isEmpty:token] || !JLGisLoginBool) {
        
        //结束心跳
        [JGJSocketRequest socketHeartTimerEnd];
        
        return;
    }
    
    [self heartTimerEnd];
    
    //重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSocketReconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reconnect];
    });
}

- (void)webSocketFailWithError:(NSError *)error{
    //执行失败的block
    NSArray <SocketRequestOperate *>*allValues = [self.operatesDic allValues];
    [allValues enumerateObjectsUsingBlock:^(SocketRequestOperate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.timeOut > 0 && obj.failure) {
            obj.failure(error,nil);
        }
    }];
}

+ (void)WebSocketWithParameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure {
    [self WebSocketWithParameters:parameters success:success failure:failure showHub:YES];
}

+ (void)WebSocketWithParameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure showHub:(BOOL )showHub{
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    //||status == AFNetworkReachabilityStatusUnknown;
    [TYUserDefaults setBool:isReachableStatus forKey:JGJNotReachableStatus];
    [TYUserDefaults synchronize];
    
    if (isReachableStatus && showHub) {
        
        [TYShowMessage showPlaint:@"网络连接不可用"];
        if (failure) {
            failure(nil,nil);
        }
        return;
    }
    
    NSDictionary *dic = [self configCommonDic:parameters];
    
    if (!dic && failure) {
        failure(nil,nil);
        return ;
    }
    
    SocketRequestOperate *srOperate = [SocketRequestOperate new];
    
    srOperate.parameters = dic;
    
    srOperate.success = success;
    
    srOperate.failure = failure;
    
    srOperate.timeOut = 10.0;
    
    //    NSString *keyStr = [parameters[@"ctrl"] stringByAppendingString:parameters[@"action"]];
    
    NSString *keyStr = parameters[@"action"];
    
    //    keyStr = [self configKeyStr:parameters keyStr:keyStr];
    
    [socketRequest.operatesDic setObject:srOperate forKey:keyStr?:@""];
    
    JGJSocketLog(@"上传参数: %@", dic);
    
    if (socketRequest.webSocket.readyState == SR_OPEN ) {
        [socketRequest sendWebSocketRequest:dic];
    }else{
        [socketRequest reconnectWithSuccessDic:dic];
    }
}

+ (void)WebSocketAddMonitor:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure {
    NSDictionary *dic = [self configCommonDic:parameters];
    
    if (!dic && failure) {
        failure(nil,nil);
        return ;
    }
    
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    SocketRequestOperate *srOperate = [SocketRequestOperate new];
    
    srOperate.parameters = dic;
    if (success) {
        srOperate.success = success;
    }
    
    if (failure) {
        srOperate.failure = failure;
    }
    
    JGJSocketLog(@"监听参数: %@", dic);
    
    //    NSString *keyStr = [parameters[@"ctrl"] stringByAppendingString:parameters[@"action"]];
    
    NSString *keyStr = parameters[@"action"];
    
    //    keyStr = [self configKeyStr:parameters keyStr:keyStr];
    
    [socketRequest.operatesDic setObject:srOperate forKey:keyStr];
}

+ (void)WebSocketRemoveMonitor:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error,id values))failure {
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    
    //    NSString *keyStr = [parameters[@"ctrl"] stringByAppendingString:parameters[@"action"]];
    
    NSString *keyStr = parameters[@"action"];
    
    //    keyStr = [self configKeyStr:parameters keyStr:keyStr];
    
    SocketRequestOperate *srOperate = socketRequest.operatesDic[keyStr];
    
    if (!srOperate) {
        return;
    }
    
    if (srOperate.success) {
        srOperate.success = nil;
    }
    
    if (srOperate.failure) {
        srOperate.failure = nil;
    }
    
    if (success) {
        success(nil);
    }
    
    if (failure) {
        failure(nil,nil);
    }
    
}

+ (NSDictionary *)configCommonDic:(NSDictionary *)parameters{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //获取token，如果不存在返回空字符串
    NSString *socketUserTokenStr = [TYUserDefaults objectForKey:JLGToken];
    NSString *socketShorverStr = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    
    dic = @{@"token" : socketUserTokenStr ?:[NSNull null],
            @"os" : @"I",
            @"client_type":@"manage",
            @"ver":socketShorverStr}.mutableCopy;
    
    [dic addEntriesFromDictionary:parameters];
    
    NSString *signStr = [JGJCommonTool getSignStr:[dic copy] key:@"OaxhSsnvFnRCUql53jVDUVVp26pQkYea"];
    [dic setValue:signStr forKey:@"sign"];
    
    return dic;
}

+ (NSString *)configKeyStr:(NSDictionary *)parameters keyStr:(NSString *)keyStr{
    if ([parameters[@"action"] isEqualToString:@"sendMessage"] && parameters[@"local_id"]) {
        keyStr = [keyStr stringByAppendingString:parameters[@"local_id"]];
    }else if([parameters[@"action"] isEqualToString:@"getOtherMessageList"] && parameters[@"msg_type"]){
        keyStr = [keyStr stringByAppendingString:parameters[@"msg_type"]];
    }
    
    return keyStr;
}

- (NSString *)configKeyStr:(NSDictionary *)parameters keyStr:(NSString *)keyStr{
    if ([parameters[@"action"] isEqualToString:@"sendMessage"]) {
        if (parameters && parameters[@"local_id"]) {
            NSString *local_id = [NSString stringWithFormat:@"%@", parameters[@"local_id"]];
            keyStr = [keyStr stringByAppendingString:local_id];
        }
    }
    
    return keyStr;
}

- (void)sendWebSocketRequest:(NSDictionary *)dic {
    if ([NSString isEmpty:[TYUserDefaults objectForKey:JLGToken]]) {
        return ;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    TYLog(@"jsonString = %@ readyState==== %@",jsonString, @(self.webSocket.readyState));
    [self.webSocket send:jsonString];
}

#pragma mark - 发送心跳
- (void )heartTimerStart{
    
    [self heartTimerEnd];
    
    //设置定时器向服务器发送心跳消息
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:25 //秒
                                                       target:self
                                                     selector:@selector(heartKeep:)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.heartTimer fire];
}

#pragma mark-心跳包结束
+ (void)socketHeartTimerEnd {
    
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    [socketRequest heartTimerEnd];
}

#pragma mark-心跳包开启
+ (void)socketHeartTimerStart {
    
    JGJSocketRequest *socketRequest = [JGJSocketRequest shareSocketConnect];
    [socketRequest heartTimerStart];
}

- (void)heartKeep:(NSTimer*)heartTimer

{
    
    NSString *token = [TYUserDefaults objectForKey:JLGToken];
    
    if ([NSString isEmpty:token]) {
        
        return;
    }
    
    if (self.webSocket.readyState == SR_OPEN) {
        
        [JGJSocketRequest WebSocketWithParameters:@{@"ctrl":@"message",@"action":@"heartbeat"} success:^(NSDictionary* responseObject) {
            
            NSString *server_time = [NSString stringWithFormat:@"%@", responseObject[@"server_time"]];
            if (![NSString isEmpty:server_time]) {
                
                
                NSInteger timeStamp =  [[NSDate date] timeIntervalSince1970];
                
                NSString *diffValue = [NSString stringWithFormat:@"%f",[server_time doubleValue] - timeStamp];
                
                [TYUserDefaults setObject:diffValue forKey:@"userStamp"];
                
            }
            
        } failure:^(NSError *error, id values) {
            
            
        }];
    }
    
    //    NSError *error;
    //
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"ctrl":@"message",@"action":@"heartbeat"} options:NSJSONWritingPrettyPrinted error:&error];
    //
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    //    [self.webSocket sendPing:jsonData];
    
}

- (void )heartTimerEnd{
    [self.heartTimer invalidate];
    self.heartTimer = nil;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        JGJSocketLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
    
}

-(NSString *)socketUrl{
    
    //获取token，如果不存在返回空字符串
    NSString *socketUserTokenStr = [TYUserDefaults objectForKey:JLGToken];
    NSString *socketShorverStr = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    
    NSMutableDictionary *dic = @{@"token" : socketUserTokenStr ?:[NSNull null],
                                 @"os" : @"I",
                                 @"client_type":@"manage",
                                 @"ver":socketShorverStr}.mutableCopy;
    
    //    [dic addEntriesFromDictionary:parameters];
    
    NSString *signStr = [JGJCommonTool getSignStr:[dic copy] key:@"OaxhSsnvFnRCUql53jVDUVVp26pQkYea"];
    [dic setValue:signStr forKey:@"sign"];
    
    
    NSString *socketUrl = [NSString stringWithFormat:@"token=%@&os=I&client_type=manage&ver=%@",socketUserTokenStr ?:@"",socketShorverStr];
    
    socketUrl = [NSString stringWithFormat:@"%@?%@", JGJ_WebSocket_IP, socketUrl];
    
    return socketUrl;
    
    //    return JGJ_WebSocket_IP;
}


@end


