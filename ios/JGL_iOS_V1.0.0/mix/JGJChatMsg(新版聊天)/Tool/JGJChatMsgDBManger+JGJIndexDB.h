//
//  JGJChatMsgDBManger+JGJIndexDB.h
//  mix
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger.h"
#import "JGJIndexDataModel.h"
@interface JGJChatMsgDBManger (JGJIndexDB)

// 插入一条数据
+ (BOOL)insertIndexModelToIndexTable:(JGJIndexDataModel *)indexModel;

// 更新数据
+ (BOOL)updateIndexModelToIndexTable:(JGJIndexDataModel *)indexModel;

/**
 *
 *更新首页未读数
 *
 **/
+ (BOOL)updateIndexChatMsgUnreadToIndexTable:(JGJIndexDataModel *)indexModel;

/**
 *
 *更新首页项目对应的人数
 *
 **/
+ (BOOL)updateIndexChatMsgMemberCountWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type count:(NSString *)memberCount;

/**
 *
 *更新首页工作回复数
 *
 **/
+ (BOOL)updateIndexWorkReplyUnreadToIndexTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type work_message_num:(NSString *)wor_message_num;

/**
 *
 *更新首页的项目关闭情况
 *
 */
+ (BOOL)updateIs_ClosedToIndexTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type is_closed:(BOOL)is_closed;

// 删除数据
+ (BOOL)deleteIndexModelInIndexTable;

// 获取首页数据
+ (JGJIndexDataModel *)getTheIndexModelInIndexTable;
@end
