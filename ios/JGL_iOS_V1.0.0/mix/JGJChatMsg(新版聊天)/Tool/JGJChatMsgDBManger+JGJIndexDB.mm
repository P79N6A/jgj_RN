//
//  JGJChatMsgDBManger+JGJIndexDB.m
//  mix
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger+JGJIndexDB.h"
#import "JGJIndexDataModel+JGJIndexDataModel.h"

static JGJChatMsgDBManger *DBManger = nil;

@interface JGJChatMsgDBManger ()

@property (nonatomic,strong) WCTTable    *index_table;
@end
@implementation JGJChatMsgDBManger (JGJIndexDB)

+ (void)shareManagerIndexTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    
    DBManger = msgDBManger;
    DBManger.index_table = table;
}

+ (BOOL)insertIndexModelToIndexTable:(JGJIndexDataModel *)indexModel {
    
    return [DBManger.index_table insertObject:indexModel];
}

+ (BOOL)updateIndexModelToIndexTable:(JGJIndexDataModel *)indexModel {
    
    return [DBManger.index_table updateRowsOnProperties:{JGJIndexDataModel.local_head_pic,JGJIndexDataModel.agency_group_userInfo,JGJIndexDataModel.chat_unread_msg_count,JGJIndexDataModel.unread_quality_count,JGJIndexDataModel.unread_safe_count,JGJIndexDataModel.unread_inspect_count,JGJIndexDataModel.unread_task_count,JGJIndexDataModel.unread_notice_count,JGJIndexDataModel.unread_sign_count,JGJIndexDataModel.unread_meeting_count,JGJIndexDataModel.unread_approval_count,JGJIndexDataModel.unread_log_count,JGJIndexDataModel.group_info_wcdb,JGJIndexDataModel.creater_uid,JGJIndexDataModel.chat_unread_msg_count,JGJIndexDataModel.work_message_num,JGJIndexDataModel.unread_billRecord_count,JGJIndexDataModel.unread_bill_count} withObject:indexModel where:[self comConWithChatIndexModel:indexModel]];
}

+ (BOOL)updateIndexChatMsgMemberCountWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type count:(NSString *)memberCount {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJIndexDataModel.group_id == group_id && JGJIndexDataModel.class_type == class_type && JGJIndexDataModel.user_id == userId;
    WCTValue *value = memberCount?:@"0";
    return [DBManger.index_table updateRowsOnProperty:JGJIndexDataModel.members_num withValue:value where:condition];
}
#pragma mark - 更新未读数
+ (BOOL)updateIndexChatMsgUnreadToIndexTable:(JGJIndexDataModel *)indexModel {
    
    return [DBManger.index_table updateRowsOnProperties:{JGJIndexDataModel.chat_unread_msg_count} withObject:indexModel where:[self comConWithChatIndexModel:indexModel]];
}

#pragma mark - 更新工作消息回复数
+ (BOOL)updateIndexWorkReplyUnreadToIndexTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type work_message_num:(NSString *)wor_message_num {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJIndexDataModel.group_id == group_id && JGJIndexDataModel.class_type == class_type && JGJIndexDataModel.user_id == userId;
    WCTValue *value = wor_message_num;
    return [DBManger.index_table updateRowsOnProperty:JGJIndexDataModel.work_message_num withValue:value where:condition];
}


+ (BOOL)updateIs_ClosedToIndexTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type is_closed:(BOOL)is_closed {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJIndexDataModel.group_id == group_id && JGJIndexDataModel.class_type == class_type && JGJIndexDataModel.user_id == userId;
    JGJIndexDataModel *indexModel = [DBManger.index_table getAllObjects].firstObject;
    JGJMyWorkCircleProListModel *group_info = [[JGJMyWorkCircleProListModel alloc] init];
    
    group_info.group_id = group_id;
    group_info.class_type = class_type;
    group_info.isClosedTeamVc = is_closed;
    group_info.creater_uid = indexModel.group_info.creater_uid;
    group_info.members_head_pic = indexModel.group_info.members_head_pic;
    group_info.group_name = indexModel.group_info.group_name;
    group_info.group_id = indexModel.group_info.group_id;
    group_info.members_num = indexModel.group_info.members_num;
    group_info.all_pro_name = indexModel.group_info.all_pro_name;
    group_info.pro_id = indexModel.group_info.pro_id;
    
    //能否@所有人
    group_info.can_at_all = indexModel.group_info.can_at_all;
    
    WCTValue *value = [group_info mj_JSONString];
    return [DBManger.index_table updateRowsOnProperty:JGJIndexDataModel.group_info_wcdb withValue:value where:condition];
    
}

+ (BOOL)deleteIndexModelInIndexTable {
    
    return  [DBManger.index_table deleteAllObjects];
}

+ (JGJIndexDataModel *)getTheIndexModelInIndexTable {
    
    return [DBManger.index_table getAllObjects].firstObject;
}

+ (BOOL)queryIndexModelIsExistInIndexTable:(JGJIndexDataModel *)model {
    
    JGJIndexDataModel *existModel = [DBManger.index_table getOneObjectWhere:[self comConWithChatIndexModel:model]];
    if (existModel != nil) {
        // 存在
        return YES;
    }else {
        // 不存在
        return NO;
    }
}

+ (WCTCondition)comConWithChatIndexModel:(JGJIndexDataModel *)indexModel {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJIndexDataModel.group_id == indexModel.group_id && JGJIndexDataModel.class_type == indexModel.class_type && JGJIndexDataModel.user_id == userId;
    
    return condition;
}
@end
