//
//  JGJNewNotifyTool.h
//  mix
//
//  Created by YJ on 16/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^NotifyToolBlock)();
@interface JGJNewNotifyTool : NSObject
/**
 *  返回更新网路请求数据结果
 */
@property (copy, nonatomic) NotifyToolBlock notifyToolBlock;
/**
 *  返回第page页的收藏的通知数据:page从1开始
 */
+ (NSArray *)collectNotifies:(int)page;
/**
 *  收藏一个消息
 */
+ (BOOL)addCollectNotifies:(JGJNewNotifyModel *)notifyModel;
/**
 *  取消收藏一个消息
 */
+ (BOOL)removeCollectNotify:(JGJNewNotifyModel *)notifyModel;

/**
 *  通知是否收藏
 */
//+ (BOOL)isExistNotifyModel:(JGJNewNotifyModel *)notifyModel;

+ (BOOL)isExistNotifyModel:(JGJNewNotifyModel *)notifyModel;

/**
 *  返回所有数据
 */
+ (NSArray *)allNotifies;

/**
 *  更新数据
 */
+ (BOOL)updateNotifyModel:(JGJNewNotifyModel *)notifyModel;

/**
 *  点击新通知查看时除，同步项目、加入班组外其余传给服务器
 */
+ (NSArray *)allReadedNofies;

/**
 *  返回未读的通知数据
 *
 */
+ (NSString *)allUnReadedNofies;

+ (instancetype)shareNotifyTool;
/**
 *  程序启动调用一次
 */
+ (void)updateNoticeListNetData;
@end
