//
//  JGJChatMsgDBManger+JGJClearCacheDB.h
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger.h"

#import "JGJChatClearCacheModel.h"

@interface JGJChatMsgDBManger (JGJClearCacheDB)

/**
 * 插入消息
 *
 **/
+ (BOOL)insertToCacheModelTableWithCacheModel:(JGJChatClearCacheModel *)cacheModel;

/**
 *转换为JGJChatClearCacheModel
 *
 **/
+(JGJChatClearCacheModel *)cacheModelWithClass_type:(NSString *)class_type group_id:(NSString *)group_id;

/**
 * 获取当前组指定的模型
 *
 **/
+(JGJChatClearCacheModel *)cacheModel:(JGJChatClearCacheModel *)cacheModel;

@end
