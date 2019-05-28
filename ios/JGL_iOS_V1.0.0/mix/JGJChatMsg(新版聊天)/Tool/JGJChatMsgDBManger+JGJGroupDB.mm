//
//  JGJChatMsgDBManger+JGJGroupDB.m
//  mix
//
//  Created by yj on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatGroupListModel+JGJGroupListWCTTableCoding.h"
#import "JGJChatMsgListModel+JGJWCDB.h"
#import "NSDate+Extend.h"
#import "JGJChatMsgDBManger.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
static JGJChatMsgDBManger *DBManger = nil;
@interface JGJChatMsgDBManger()

@property (nonatomic,strong) WCTTable    *group_table;

@end

@implementation JGJChatMsgDBManger (JGJGroupDB)

+ (void)shareManagerGroupTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    
    DBManger = msgDBManger;
    DBManger.group_table = table;
}


+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListModel:(JGJChatGroupListModel *)model {
    
    if ([self queryGroupIsExistWithModel:model]) {
        
        return [self updateChatGroupListTableWithJGJChatMsgListModel:model];
        
    }else {
        
        return [DBManger.group_table insertObject:model];
    }
    
}

+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListModelNotUpdateNewestChatMsg:(JGJChatGroupListModel *)model {
    
    if ([model.last_msg_type isEqualToString:@"auth"]) {
        
        return NO;
    }
    if ([self queryGroupIsExistWithModel:model]) {
        
        return [self updateChatGroupListTableNotWithNewestChatMsgModel:model];
        
    }else {
        
        return [DBManger.group_table insertObject:model];
    }
}

+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListWork_ActivityModelNotUpdateNewestChatMsg:(JGJChatGroupListModel *)model {
    
    if ([self queryGroupIsExistWithModel:model]) {
        
        return [self updateChatGroupListTableNotWithNewestActivity_RecruitChatMsgModel:model];
        
    }else {
        
        return [DBManger.group_table insertObject:model];
    }
}


+ (BOOL)insertToChatGroupListTableWithNewestJGJChatMsgListModel:(JGJChatGroupListModel *)model {
    
    if ([self queryGroupIsExistWithModel:model]) {
        
        return [self updateNew_Chat_MsgToGroupTableWithGroupListModel:model];
        
    }else {
        
        return [DBManger.group_table insertObject:model];
    }
    
}


+ (BOOL)deleteChatGroupListDataWithModel:(JGJChatGroupListModel *)model {
    
    if ([NSString isEmpty:model.group_id]) {
        
        return NO;
    }
    
    return [DBManger.group_table deleteObjectsWhere:[self comConWithChatGroupModel:model]];
}

+ (BOOL)deleteAllChatGroupListData {
    
    return [DBManger.group_table deleteAllObjects];
}

+ (JGJChatGroupListModel *)getChatGroupListModelWithGroup_id:(NSString *)group_id classType:(NSString *)class_type {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table getOneObjectWhere:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (JGJChatGroupListModel *)getNewestCreatTimeChatGroupListModel {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    NSArray *arr = [[NSArray alloc] init];
    arr = [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == userId orderBy:JGJChatGroupListModel.create_time.order(WCTOrderedDescending)];
    
    return arr.firstObject;
}

+ (NSString *)getTheProjectNameWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    JGJChatGroupListModel *groupModel = [self getChatGroupListModelWithGroup_id:group_id classType:class_type];
    return groupModel.group_name;
}

+ (NSArray<JGJChatGroupListModel *> *)getCurrentGroupOrTeamProjecyList {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and (JGJChatGroupListModel.class_type == @"team" or JGJChatGroupListModel.class_type == @"group" ) and JGJChatGroupListModel.is_closed == NO and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.create_time.order(WCTOrderedDescending)];
}

+ (NSArray<JGJChatGroupListModel *> *)getCurrentGroupOrTeamProjecyClosedList {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and (JGJChatGroupListModel.class_type == @"team" or JGJChatGroupListModel.class_type == @"group" ) and JGJChatGroupListModel.is_closed == YES and JGJChatGroupListModel.creater_uid == user_id and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.create_time.order(WCTOrderedDescending)];
}

// 获取群聊
+ (NSArray<JGJChatGroupListModel *> *)getGroupChats {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    return [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and JGJChatGroupListModel.class_type == @"groupChat" && JGJChatGroupListModel.is_closed != 1 and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.create_time.order(WCTOrderedDescending)];
}

// 获取班组或者项目组
+ (NSArray<JGJChatGroupListModel *> *)getTeamChats {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    return [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and (JGJChatGroupListModel.class_type == @"team" or JGJChatGroupListModel.class_type == @"group") && JGJChatGroupListModel.is_closed != 1 and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.create_time.order(WCTOrderedDescending)];
}

+ (NSArray<JGJChatGroupListModel *> *)getAllGroupListModel {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    NSArray *is_topArr = [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and JGJChatGroupListModel.is_top == YES and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.list_sort_time.order(WCTOrderedDescending)];
    NSArray *is_notTopArr = [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and JGJChatGroupListModel.is_top == NO and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.list_sort_time.order(WCTOrderedDescending)];
    NSMutableArray *group_listArr = [[NSMutableArray alloc] init];
    if (is_topArr.count != 0) {
        
        [group_listArr addObjectsFromArray:is_topArr];
    }
    
    if (is_notTopArr.count != 0) {
        
        [group_listArr addObjectsFromArray:is_notTopArr];
        
    }
    
    // 清除聊聊列表班组名字为空的数据
    [DBManger.group_table deleteObjectsWhere:JGJChatGroupListModel.group_name.length() == 0];
    return group_listArr;
}

+ (NSArray<JGJChatGroupListModel *> *)getCurrentGroupAndTeamAndGroupChatAndSingleChatList {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table getObjectsWhere:JGJChatGroupListModel.user_id == user_id and (JGJChatGroupListModel.class_type == @"team" or JGJChatGroupListModel.class_type == @"group" or JGJChatGroupListModel.class_type == @"singleChat" or JGJChatGroupListModel.class_type == @"groupChat") and JGJChatGroupListModel.is_closed == NO and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.group_name.length() > 0 orderBy:JGJChatGroupListModel.list_sort_time.order(WCTOrderedDescending)];
}

+ (BOOL)insertToChatGroupListTableAfterSendMessageSuccessWithGroupListModel:(JGJChatGroupListModel *)model {
    
    if ([self queryGroupIsExistWithModel:model]) {
        
        return [self updateChatGroupListTableAfterSendMessageSuccessWithGroupListModel:model];
        
    }else {
        
        return [DBManger.group_table insertObject:model];
    }
}

+ (BOOL)updateChatGroupListTableAfterSendMessageSuccessWithGroupListModel:(JGJChatGroupListModel *)model {
    
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.last_msg_type,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.last_send_uid,JGJChatGroupListModel.last_send_name,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.chat_unread_msg_count,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.is_delete,JGJChatGroupListModel.msg_text,JGJChatGroupListModel.list_sort_time} withObject:model where:[self comConWithChatGroupModel:model]];
}

+ (BOOL)updateChatGroupListTableWithJGJChatMsgListModel:(JGJChatGroupListModel *)model {
    
    JGJIndexDataModel *proModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    
    if ([proModel.group_id isEqualToString:model.group_id] && [proModel.class_type isEqualToString:model.class_type]) {
        
        NSString *members_num = model.members_num;
        
        if ([NSString isEmpty:members_num]) {
            
            members_num = @"0";
            
        }
        
        [JGJChatMsgDBManger updateIndexChatMsgMemberCountWithGroup_id:model.group_id class_type:model.class_type count:members_num];
        
    }
    
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.group_id,JGJChatGroupListModel.class_type,JGJChatGroupListModel.group_name,JGJChatGroupListModel.local_head_pic,JGJChatGroupListModel.members_num,JGJChatGroupListModel.chat_unread_msg_count,JGJChatGroupListModel.creater_uid,JGJChatGroupListModel.create_time,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.is_no_disturbed,JGJChatGroupListModel.pro_id,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.last_msg_type,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.last_send_uid,JGJChatGroupListModel.last_send_name,JGJChatGroupListModel.is_delete,JGJChatGroupListModel.is_closed,JGJChatGroupListModel.close_time,JGJChatGroupListModel.msg_text,JGJChatGroupListModel.at_message,JGJChatGroupListModel.agency_group_user,JGJChatGroupListModel.title,JGJChatGroupListModel.list_sort_time} withObject:model where:[self comConWithChatGroupModel:model]];
    
}


+ (BOOL)updateChatGroupListTableNotWithNewestChatMsgModel:(JGJChatGroupListModel *)model {

    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.group_id,JGJChatGroupListModel.class_type,JGJChatGroupListModel.group_name,JGJChatGroupListModel.local_head_pic,JGJChatGroupListModel.members_num,JGJChatGroupListModel.creater_uid,JGJChatGroupListModel.create_time,JGJChatGroupListModel.is_no_disturbed,JGJChatGroupListModel.pro_id,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.is_delete,JGJChatGroupListModel.is_closed,JGJChatGroupListModel.close_time,JGJChatGroupListModel.agency_group_user,JGJChatGroupListModel.last_msg_type,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.last_send_uid,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.last_send_name,JGJChatGroupListModel.list_sort_time} withObject:model where:[self comConWithChatGroupModel:model]];
    
}

+ (BOOL)updateChatGroupListTableNotWithNewestActivity_RecruitChatMsgModel:(JGJChatGroupListModel *)model {
    
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.group_id,JGJChatGroupListModel.class_type,JGJChatGroupListModel.group_name,JGJChatGroupListModel.local_head_pic,JGJChatGroupListModel.members_num,JGJChatGroupListModel.creater_uid,JGJChatGroupListModel.create_time,JGJChatGroupListModel.is_no_disturbed,JGJChatGroupListModel.pro_id,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.is_delete,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.list_sort_time} withObject:model where:[self comConWithChatGroupModel:model]];
    
}
+ (BOOL)updateChatGroupListTableTheUnread_work_countWithGroupListModel:(JGJChatGroupListModel *)model group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.unread_quality_count,JGJChatGroupListModel.unread_safe_count,JGJChatGroupListModel.unread_task_count,JGJChatGroupListModel.unread_log_count,JGJChatGroupListModel.unread_meeting_count,JGJChatGroupListModel.unread_weath_count,JGJChatGroupListModel.unread_approval_count,JGJChatGroupListModel.unread_billRecord_count,JGJChatGroupListModel.unread_bill_count,JGJChatGroupListModel.unread_sign_count,JGJChatGroupListModel.unread_inspect_count,JGJChatGroupListModel.unread_notice_count,JGJChatGroupListModel.work_message_num} withObject:model where:JGJChatGroupListModel.group_id == group_id && JGJChatGroupListModel.class_type == class_type && JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateChatGroupListTableTheUnread_work_countWithGroupListModel:(JGJChatGroupListModel *)model group_id:(NSString *)group_id class_type:(NSString *)class_type chatListType:(JGJChatListType)chatListType{
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTPropertyList propertyList = [self groupPropertyListWithPropertyListType:chatListType];
    
    return [DBManger.group_table updateRowsOnProperties:propertyList withObject:model where:JGJChatGroupListModel.group_id == group_id && JGJChatGroupListModel.class_type == class_type && JGJChatGroupListModel.user_id == userId];
}


+ (BOOL)updateChatGroupListTableTheWork_Replay_countWithCount:(NSString *)count group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    WCTValue *value = count;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.work_message_num withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateMax_Readed_Msg_IdInGroupTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type msg_id:(NSString *)msg_id {
    
    if ([NSString isEmpty:group_id]) {
         
        return NO;
    }
    WCTValue *value = msg_id;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.max_readed_msg_id withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateMax_Asked_Msg_IdInGroupTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type msg_id:(NSString *)msg_id {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    WCTValue *value = msg_id;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.max_asked_msg_id withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateChat_msg_unread_countToGroupTableWithUnreadCount:(NSString *)unreadCount group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    WCTValue *value = unreadCount;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.max_readed_msg_id withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateIs_topToGroupTableWithIsTop:(BOOL)is_top group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    WCTValue *value = @(is_top);
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.is_top withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
    
}

+ (BOOL)updateList_sort_timeWithChatGroupListModel:(JGJChatGroupListModel *)groupModel {
    
    if ([NSString isEmpty:groupModel.group_id]) {
        
        return NO;
    }
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.list_sort_time withValue:groupModel.list_sort_time where:JGJChatGroupListModel.group_id == groupModel.group_id and JGJChatGroupListModel.class_type == groupModel.class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateAt_MessageToGroupTable:(NSString *)at_message group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    WCTValue *value = at_message;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.at_message withValue:value where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}

+ (BOOL)updateIs_deleteToGroupTableWithIsDelete:(JGJChatGroupListModel *)groupModel group_id:(NSString *)group_id class_type:(NSString *)class_type {
    
    if ([NSString isEmpty:group_id]) {
        
        return NO;
    }
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.is_delete,JGJChatGroupListModel.is_top,JGJChatGroupListModel.is_closed} withObject:groupModel where:JGJChatGroupListModel.group_id == group_id and JGJChatGroupListModel.class_type == class_type and JGJChatGroupListModel.user_id == userId];
}



+ (BOOL)updateNew_Chat_MsgToGroupTableWithGroupListModel:(JGJChatGroupListModel *)groupModel {
    
    if (groupModel.group_id == nil || [groupModel.last_msg_type isEqualToString:@"auth"]) {
        
        return NO;
    }

    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.last_send_uid,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.last_msg_type,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.is_delete,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.last_send_name,JGJChatGroupListModel.chat_unread_msg_count,JGJChatGroupListModel.msg_text,JGJChatGroupListModel.at_message,JGJChatGroupListModel.title,JGJChatGroupListModel.list_sort_time,JGJChatGroupListModel.recruitMsgTitle,JGJChatGroupListModel.linkMsgTitle,JGJChatGroupListModel.linkMsgContent} withObject:groupModel where:[self comConWithChatGroupModel:groupModel]];
}

+ (BOOL)updateNew_Chat_Msg_No_Chat_Unread_Msg_CountToGroupTableWithGroupListModel:(JGJChatGroupListModel *)groupModel {
    
    if (groupModel.group_id == nil) {
        
        return NO;
    }
    
    return [DBManger.group_table updateRowsOnProperties:{JGJChatGroupListModel.last_send_uid,JGJChatGroupListModel.sys_msg_type,JGJChatGroupListModel.last_msg_type,JGJChatGroupListModel.last_msg_send_time,JGJChatGroupListModel.max_asked_msg_id,JGJChatGroupListModel.last_msg_content,JGJChatGroupListModel.last_send_name,JGJChatGroupListModel.msg_text,JGJChatGroupListModel.at_message,JGJChatGroupListModel.title,JGJChatGroupListModel.list_sort_time} withObject:groupModel where:[self comConWithChatGroupModel:groupModel]];
}

+ (NSInteger)getAllUnreadMsgCount {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTResult result = {JGJChatGroupListModel.chat_unread_msg_count.inTable(@"JGJ_Chat_Group_Table")};
    WCTOneColumn *column = [DBManger.group_table getOneColumnOnResult:result where:JGJChatGroupListModel.user_id == userId and JGJChatGroupListModel.group_name.length() > 0 and JGJChatGroupListModel.is_no_disturbed == NO and JGJChatGroupListModel.is_delete == NO];
    NSInteger sum = 0;
    for (int i = 0; i < column.count; i ++) {
        
        WCTValue *value = column[i];
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *count = [NSString stringWithFormat:@"%@",value];
            sum = sum + [count integerValue];
        }
    }

    return sum;
}

+ (NSInteger)getAllUnreadMsgCountWithOutWork_activity_Recruit {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTResult result = {JGJChatGroupListModel.chat_unread_msg_count.inTable(@"JGJ_Chat_Group_Table")};
    WCTOneColumn *column = [DBManger.group_table getOneColumnOnResult:result where:JGJChatGroupListModel.user_id == userId and JGJChatGroupListModel.group_name.length() > 0 and JGJChatGroupListModel.is_no_disturbed == NO and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.class_type != @"singleChat" and JGJChatGroupListModel.class_type != @"groupChat" and JGJChatGroupListModel.class_type != @"work" and JGJChatGroupListModel.class_type != @"activity" and JGJChatGroupListModel.class_type != @"recruit"];
    NSInteger sum = 0;
    for (int i = 0; i < column.count; i ++) {
        
        WCTValue *value = column[i];
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *count = [NSString stringWithFormat:@"%@",value];
            sum = sum + [count integerValue];
        }
    }
    
    return sum;
}

+ (NSInteger)getRowCountWithResultList {
      
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    NSInteger totalcount = 0;
    WCTResultList result = {JGJChatGroupListModel.unread_quality_count,JGJChatGroupListModel.unread_safe_count,JGJChatGroupListModel.unread_inspect_count,JGJChatGroupListModel.unread_task_count,JGJChatGroupListModel.unread_notice_count,JGJChatGroupListModel.unread_sign_count,JGJChatGroupListModel.unread_meeting_count,JGJChatGroupListModel.unread_approval_count,JGJChatGroupListModel.unread_log_count,JGJChatGroupListModel.unread_billRecord_count,JGJChatGroupListModel.unread_bill_count,JGJChatGroupListModel.unread_weath_count,JGJChatGroupListModel.work_message_num};

    WCTColumnsXRows *rows = [DBManger.group_table getRowsOnResults:result where:JGJChatGroupListModel.user_id == userId and JGJChatGroupListModel.group_name.length() > 0  and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.class_type != @"work" and JGJChatGroupListModel.class_type != @"activity" and JGJChatGroupListModel.class_type != @"recruit" and JGJChatGroupListModel.class_type != @"singleChat" and JGJChatGroupListModel.class_type != @"groupChat"];
    
    for (NSArray *valueArr in rows) {
        
        for (WCTValue *value in valueArr) {
            
            NSString *count = [NSString stringWithFormat:@"%@",value];
            totalcount = totalcount + [count integerValue];
        }
    }
    return totalcount;
}

+ (NSInteger)getHomeAllUnreadMsgCount {
    
    // 获取首页项目
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    // 统计除我的项目班组展示的项目的未读消息数 排除群聊(groupChat)和单聊类型(singleChat)
    WCTResult result = {JGJChatGroupListModel.chat_unread_msg_count.inTable(@"JGJ_Chat_Group_Table")};
    WCTOneColumn *column = [DBManger.group_table getOneColumnOnResult:result where:JGJChatGroupListModel.user_id == userId and JGJChatGroupListModel.group_name.length() > 0 and JGJChatGroupListModel.is_no_disturbed == NO and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.class_type != @"work" and JGJChatGroupListModel.class_type != @"activity" and JGJChatGroupListModel.class_type != @"recruit" and JGJChatGroupListModel.class_type != @"singleChat" and JGJChatGroupListModel.class_type != @"groupChat" and (JGJChatGroupListModel.group_id != indexModel.group_id or JGJChatGroupListModel.class_type != indexModel.class_type)];
    NSInteger sum = 0;
    for (int i = 0; i < column.count; i ++) {
        
        WCTValue *value = column[i];
        if ([value isKindOfClass:[NSString class]]) {
            
            NSString *count = [NSString stringWithFormat:@"%@",value];
            sum = sum + [count integerValue];
        }
    }
    
    if (sum == 0) {
        
        // 统计除我的项目班组展示的项目的质量，安全等内容的红点数,排除群聊(groupChat)和单聊类型(singleChat)
        WCTResultList otherResult = {JGJChatGroupListModel.unread_quality_count,JGJChatGroupListModel.unread_safe_count,JGJChatGroupListModel.unread_inspect_count,JGJChatGroupListModel.unread_task_count,JGJChatGroupListModel.unread_notice_count,JGJChatGroupListModel.unread_meeting_count,JGJChatGroupListModel.unread_approval_count,JGJChatGroupListModel.unread_log_count,JGJChatGroupListModel.unread_billRecord_count};
        
        WCTColumnsXRows *rows = [DBManger.group_table getRowsOnResults:otherResult where:JGJChatGroupListModel.user_id == userId and JGJChatGroupListModel.group_name.length() > 0  and JGJChatGroupListModel.is_delete == NO and JGJChatGroupListModel.class_type != @"work" and JGJChatGroupListModel.class_type != @"activity" and JGJChatGroupListModel.class_type != @"recruit" and JGJChatGroupListModel.class_type != @"singleChat" and JGJChatGroupListModel.class_type != @"groupChat" and (JGJChatGroupListModel.group_id != indexModel.group_id or JGJChatGroupListModel.class_type != indexModel.class_type)] ;
        
        for (NSArray *valueArr in rows) {
            
            for (WCTValue *value in valueArr) {
                
                NSString *count = [NSString stringWithFormat:@"%@",value];
                sum = sum + [count integerValue];
            }
        }
    }
    
    return sum;
}
+ (BOOL)queryGroupIsExistWithModel:(JGJChatGroupListModel *)model {
    
    JGJChatGroupListModel *existModel = [DBManger.group_table getOneObjectWhere:[self comConWithChatGroupModel:model]];
    if (existModel != nil) {
        // 存在
        return YES;
    }else {
        // 不存在
        return NO;
    }
}

+ (BOOL)cleadGroupUnReadMsgCountWithModel:(JGJChatGroupListModel *)model {
    
    WCTValue *value = @0;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    return [DBManger.group_table updateRowsOnProperty:JGJChatGroupListModel.chat_unread_msg_count withValue:value where:JGJChatGroupListModel.group_id == model.group_id and JGJChatGroupListModel.class_type == model.class_type and JGJChatGroupListModel.user_id == userId];
}

+ (WCTCondition)comConWithChatGroupModel:(JGJChatGroupListModel *)groupModel {
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition = JGJChatGroupListModel.group_id == groupModel.group_id && JGJChatGroupListModel.class_type == groupModel.class_type && JGJChatGroupListModel.user_id == userId;
    
    return condition;
}

+(WCTPropertyList)groupPropertyListWithPropertyListType:(JGJChatListType)type {
    
    WCTPropertyList PropertyList = {JGJChatGroupListModel.unread_quality_count};
    
    switch (type) {
            
        case JGJChatListQuality:{
            
            PropertyList = {JGJChatGroupListModel.unread_quality_count};
        }
            
            break;
            
        case JGJChatListSafe:{
            
            PropertyList = {JGJChatGroupListModel.unread_safe_count};
        }
            
            break;
            
        case JGJChatListInspectType:{
            
            PropertyList = {JGJChatGroupListModel.unread_inspect_count};
        }
            
            break;
            
        case JGJChatListTaskType:{
            
            PropertyList = {JGJChatGroupListModel.unread_task_count};
        }
            
            break;
            
        case JGJChatListNotice:{
            
            PropertyList = {JGJChatGroupListModel.unread_notice_count};
        }
            
            break;
            
        case JGJChatListLog:{
            
            PropertyList = {JGJChatGroupListModel.unread_log_count};
        }
            
            break;
            
        case JGJChatListMeeting:{
            
            PropertyList = {JGJChatGroupListModel.unread_meeting_count};
        }
            
            break;
            
        case JGJChatListApproveType:{
            
            PropertyList = {JGJChatGroupListModel.unread_approval_count};
        }
            
            break;
            
            
        default:{
            //打开要报错
            //            PropertyList = JGJChatMsgListModel.AllProperties;
        }
            break;
    }
    
    return PropertyList;
    
}

//创建项目、班组群聊成功 插入数据库
+ (void)insertGroupDBWithGroupModel:(JGJChatGroupListModel *)groupModel isHomeVc:(BOOL)isHomeVc {
    
    groupModel.create_time = [JGJChatMsgDBManger localTime];
    [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModel:groupModel];
    
    BOOL needHttp = NO;
    if ([groupModel.class_type isEqualToString:@"team"] || [groupModel.class_type isEqualToString:@"group"]) {
        
        needHttp = YES;
    }
    
    if (![groupModel.class_type isEqualToString:@"groupChat"]) {
        
        [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:groupModel.group_id class_type:groupModel.class_type isNeedChangToHomeVC:isHomeVc isNeedHttpRequest:needHttp success:nil];
    }
    
    
}

+ (JGJChatGroupListModel *)getChatGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTCondition condition = JGJChatGroupListModel.extent_type == groupListModel.extent_type and JGJChatGroupListModel.user_id == userId;;
    
    if (![NSString isEmpty:groupListModel.class_type] && ![NSString isEmpty:groupListModel.group_id]) {
        
        condition = JGJChatGroupListModel.group_id == groupListModel.group_id and JGJChatGroupListModel.class_type == groupListModel.class_type and JGJChatGroupListModel.user_id == userId;
        
    }else if (![NSString isEmpty:groupListModel.extent_type]) {
        
        condition = JGJChatGroupListModel.extent_type == groupListModel.extent_type and JGJChatGroupListModel.user_id == userId;
        
    }
    
    JGJChatGroupListModel *groupModel = [DBManger.group_table getOneObjectWhere:condition];
    
    return groupModel;
    
}

+ (BOOL)updateExtentMsgWithChatGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    if ([NSString isEmpty:groupListModel.group_id] || [NSString isEmpty:groupListModel.class_type]) {
        
        return NO;
    }
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTPropertyList propertyList = {JGJChatGroupListModel.extent_msg};
    
    return [DBManger.group_table updateRowsOnProperties:propertyList withObject:groupListModel where:JGJChatGroupListModel.group_id == groupListModel.group_id && JGJChatGroupListModel.class_type == groupListModel.class_type && JGJChatGroupListModel.user_id == userId];
}

#pragma mark - 快速加群更新延展字段

+ (BOOL)updateQuickJoinGroupExtentTypeWithChatGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    if ([NSString isEmpty:groupListModel.group_id] || [NSString isEmpty:groupListModel.class_type]) {
        
        return NO;
    }
    
    groupListModel.list_sort_time = [JGJChatMsgDBManger localTime];
    
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTPropertyList propertyList = {JGJChatGroupListModel.extent_type, JGJChatGroupListModel.list_sort_time};
    
    return [DBManger.group_table updateRowsOnProperties:propertyList withObject:groupListModel where:JGJChatGroupListModel.group_id == groupListModel.group_id && JGJChatGroupListModel.class_type == groupListModel.class_type && JGJChatGroupListModel.user_id == userId];
}

@end
