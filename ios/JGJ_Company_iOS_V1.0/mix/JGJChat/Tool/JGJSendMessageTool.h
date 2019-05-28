//
//  JGJSendMessageTool.h
//  mix
//
//  Created by yj on 2018/11/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JGJSendMessageSelPicBlock)(JGJChatMsgListModel *msgModel);

typedef void(^JGJSendMessageSuccessBlock)(JGJChatMsgListModel *msgModel);

@interface JGJSendMessageTool : NSObject

+ (instancetype)shareSendMessageTool;

//发送消息队列，这里现在主要处理发送图片，发送成功之后移除

@property (nonatomic, strong) NSMutableArray *sendMsgQueues;

//我自己发送的消息

@property (nonatomic, strong) NSMutableArray *muSendMsgArray;

//项目、班组等模型主要获取聊天的group_id,class_type

@property (nonatomic, strong) JGJMyWorkCircleProListModel *workProListModel;

//选中图片回调显示

@property (nonatomic, copy) JGJSendMessageSelPicBlock sendMsgSelPicBlock;

//发送消息成功回调替换数据

@property (nonatomic, copy) JGJSendMessageSuccessBlock sendMsgSuccessBlock;

//我的用户信息用于发消息，展示用
@property (nonatomic, strong) JGJChatMsgListModel *myMsgModel;

/*
 *  imagesArr(image) 当前显示用
 *  chatSelAssets 图片唯一标识。用于失败显示用。
 *  selPicBlock   显示回调
 *  sendMessageSuccessBlock   发送成功回调
 */

- (void)addPicMessage:(NSArray *)imagesArr assets:(NSArray *)assets sendMessageSelPicBlock:(JGJSendMessageSelPicBlock)selPicBlock sendMessageSuccessBlock:(JGJSendMessageSuccessBlock)sendMessageSuccessBlock;

//重发图片消息

- (void)resendMsgModel:(JGJChatMsgListModel *)msgModel sendMessageSuccessBlock:(JGJSendMessageSuccessBlock)sendMessageSuccessBlock;

//发送消息
+ (instancetype)sendMsgModel:(JGJChatMsgListModel *)msgModel successBlock:(JGJSendMessageSuccessBlock)successBlock;

//发送消息组

+ (instancetype)sendMsgs:(NSArray *)msgs successBlock:(JGJSendMessageSuccessBlock)successBlock;

/*
 *  上传UIImage图片数组images，返回图片地址数组
 */
+ (void)uploadImages:(NSArray <UIImage *>*)images success:(void (^)(NSArray *))success failure:(void(^)(NSError *))failure;

@end
