//
//  JGJChatMsgDBManger+JGJClearCacheDB.m
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatClearCacheModel.h"

#import "JGJChatClearCacheModel+JGJWCDB.h"

static JGJChatMsgDBManger *DBManger = nil;

@interface JGJChatMsgDBManger()

@property (nonatomic,strong) WCTTable *cache_table;

@end

@implementation JGJChatMsgDBManger (JGJClearCacheDB)

+ (void)shareManagerCacheTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    
    DBManger = msgDBManger;
    
    DBManger.cache_table = table;
}

/**
 * 插入消息
 *
 **/
+ (BOOL)insertToCacheModelTableWithCacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    if ([self isEmptyCacheModel:cacheModel]) {
        
        return NO;
    }
    
    if ([self isExistCacheModel:cacheModel]) {
        
        return [self updateMsgModelTableWithCacheModel:cacheModel];
        
    }else {
        
        return [DBManger.cache_table insertObject:cacheModel];
    }
    
}

+ (BOOL)updateMsgModelTableWithCacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    if ([self isEmptyCacheModel:cacheModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    is_success = [DBManger.cache_table updateRowsOnProperties:JGJChatClearCacheModel.AllProperties withObject:cacheModel where:[self comConWithCacheModel:cacheModel]];
    
    return is_success;
}

/**
 * 获取当前组指定的模型
 *
 **/
+(JGJChatClearCacheModel *)cacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    if ([self isEmptyCacheModel:cacheModel]) {
        
        return nil;
    }
    
    JGJChatClearCacheModel *existModel = [DBManger.cache_table getObjectsWhere:[self comConWithCacheModel:cacheModel]].firstObject;
    
    return existModel;
}

+(BOOL)isExistCacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    JGJChatClearCacheModel *existModel = [self cacheModel:cacheModel];
    
    return ![NSString isEmpty:existModel.group_id] && ![NSString isEmpty:existModel.class_type];
}

+(WCTCondition)comConWithCacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJChatClearCacheModel.group_id == cacheModel.group_id && JGJChatClearCacheModel.class_type == cacheModel.class_type && JGJChatClearCacheModel.user_unique == user_id;
    
    return condition;
}

+(BOOL)isEmptyCacheModel:(JGJChatClearCacheModel *)cacheModel {
    
    BOOL isEmpty = NO;
    
    if ([NSString isEmpty:cacheModel.class_type] || [NSString isEmpty:cacheModel.group_id]) {
        
        isEmpty = YES;
    }
    
    return isEmpty;
}

+(JGJChatClearCacheModel *)cacheModelWithClass_type:(NSString *)class_type group_id:(NSString *)group_id {
    
    JGJChatClearCacheModel *cacheModel = [JGJChatClearCacheModel new];
    
    cacheModel.class_type = class_type;
    
    cacheModel.group_id = group_id;
    
    return cacheModel;
    
}

@end
