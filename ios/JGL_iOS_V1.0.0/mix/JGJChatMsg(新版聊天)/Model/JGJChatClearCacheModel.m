//
//  JGJChatClearCacheModel.m
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatClearCacheModel.h"

#import <WCDB/WCDB.h>

@implementation JGJChatClearCacheModel

- (BOOL)isAutoIncrement {
    
    return YES;
}

WCDB_IMPLEMENTATION(JGJChatClearCacheModel)

// 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(JGJChatClearCacheModel, primary_key)

WCDB_SYNTHESIZE(JGJChatClearCacheModel, group_id)

WCDB_SYNTHESIZE(JGJChatClearCacheModel, class_type)

//#pragma mark - 设置主键
WCDB_PRIMARY_AUTO_INCREMENT(JGJChatClearCacheModel, primary_key)

//#pragma mark - 设置索引
WCDB_INDEX(JGJChatClearCacheModel, "_index", group_id)

WCDB_INDEX(JGJChatClearCacheModel, "_index", class_type)

@end
