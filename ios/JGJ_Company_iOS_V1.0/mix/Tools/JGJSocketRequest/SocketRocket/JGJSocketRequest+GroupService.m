//
//  JGJSocketRequest+GroupService.m
//  mix
//
//  Created by yj on 2018/10/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSocketRequest+GroupService.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger.h"

static NSString *workTypeMsg_callback_key = @"workTypeMsg_callback_key";
static NSString *msg_idSet_callback_key = @"msg_idSet_callback_key";
static NSString *normale_msg_idSet_callback_key = @"normale_msg_idSet_callback_key";
@interface JGJSocketRequest ()

@property (nonatomic, strong) NSMutableSet *msg_idSet;
@property (nonatomic, strong) NSMutableSet *normale_msg_idSet;

@end
@implementation JGJSocketRequest (GroupService)

+(void)receiveMsgCallBackGroup:(NSArray *)msgs maxMsgs:(NSArray *)maxMsgs type:(JGJMsgCallBackType)type {
    
    // 过滤相同msg_id的消息
    NSMutableArray *distinct_msgArray = [self distinctMsg_idWithMsg_array:msgs];
    // 取出每个组对应的离线消息数量
    for (int i = 0; i < maxMsgs.count; i ++) {
        
        JGJChatMsgListModel *msgModel = maxMsgs[i];
        JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class_type=%@ and group_id=%@ and wcdb_msg_id > %ld", msgModel.class_type,msgModel.group_id,[groupModel.max_asked_msg_id integerValue]];
        NSArray *countArr = [distinct_msgArray filteredArrayUsingPredicate:predicate];
        msgModel.offLine_message_count = countArr.count;
    }
    
    // 1.从离线消息中剥离出工作 活动 招聘类消息
    NSPredicate *workPredicate = [NSPredicate predicateWithFormat:@"sys_msg_type!=%@", @"normal"];
    NSArray *workMsgs = [msgs filteredArrayUsingPredicate:workPredicate];
    if (workMsgs.count > 0) {
        
        [self dealOffLineWorkMsg:workMsgs];
    }
    
    // 2.从消息中剥离出普通聊天类消息
    NSPredicate *normalPredicate = [NSPredicate predicateWithFormat:@"sys_msg_type==%@", @"normal"];
    NSArray *normalMsgs = [maxMsgs filteredArrayUsingPredicate:normalPredicate];
    
    if (normalMsgs.count > 0) {
        
        [self dealOffLineNormalMsg:normalMsgs];
    }
}

// 处理离线普通类的消息
+ (void)dealOffLineNormalMsg:(NSArray *)normalMsgs {
    
    for (int i = 0; i < normalMsgs.count; i ++) {
        
        JGJChatMsgListModel *msgModel = normalMsgs[i];
        
        if (msgModel.chatListType ==  JGJChatListSyncNoticeTargetType || msgModel.chatListType ==  JGJChatListSyncProjectToYouType || msgModel.chatListType ==  JGJChatListJoinTeamType || msgModel.chatListType == JGJChatListCreateNewTeamType || msgModel.chatListType == JGJChatListSyncedSyncGroupToGroupType || [msgModel.can_recive_client isEqualToString:@"person"]) {// 排除脏数据
            
            break;
            
        }else {
            
            JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
            groupModel.group_id = msgModel.group_id;
            groupModel.class_type = msgModel.class_type;
            groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
            
            if (![TYUserDefaults objectForKey:@"shareSocketConnect_normale_msg_idSet"]) {
                
                [JGJSocketRequest shareSocketConnect].normale_msg_idSet = [[NSMutableSet alloc] init];
            }else {
                
                [JGJSocketRequest shareSocketConnect].normale_msg_idSet = [[NSMutableSet alloc] initWithArray:[TYUserDefaults objectForKey:@"shareSocketConnect_normale_msg_idSet"]];
            }
            
            if ([NSString isEmpty:msgModel.msg_id]) {
                
                return;
            }
            
            JGJChatGroupListModel *max_groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
            
            if (msgModel.wcdb_msg_id < [max_groupModel.max_asked_msg_id integerValue]) {
                
                return;
            }
            
            if ([[JGJSocketRequest shareSocketConnect].normale_msg_idSet containsObject:msgModel.msg_id] || msgModel.chatListType == JGJChatListSign || msgModel.chatListType == JGJChatListRemoveType || msgModel.chatListType == JGJChatListDelmemberType || msgModel.chatListType == JGJChatListMemberJoin || msgModel.chatListType == JGJChatListJoinType || msgModel.chatListType == JGJChatListSwitchgroupType) {// 这里聊天面板中的系统提示消息，不作为未读消息显示未读数在班组、群、项目组的头像显示
                
                msgModel.offLine_message_count = 0;
                
            }else {
                
                msgModel.offLine_message_count = 1;
                [[JGJSocketRequest shareSocketConnect].normale_msg_idSet addObject:msgModel.msg_id];
                
            }
            if ([JGJSocketRequest shareSocketConnect].normale_msg_idSet.count > 99) {
                
                [[JGJSocketRequest shareSocketConnect].normale_msg_idSet removeAllObjects];
            }
            
            [TYUserDefaults setObject:[[JGJSocketRequest shareSocketConnect].normale_msg_idSet allObjects] forKey:@"shareSocketConnect_normale_msg_idSet"];
            
            // 判断本地有没有班组 群聊等数据
            if (msgModel.chatListType != JGJChatListSyncNoticeTargetType) {
                
                if (![JGJChatMsgDBManger queryGroupIsExistWithModel:groupModel]) {
                    
                    if (JLGisLoginBool) {
                        
                        [JGJChatGetOffLineMsgInfo http_getSingleChatGroupWithGroup_id:msgModel.group_id class_type:msgModel.class_type success:^(JGJChatGroupListModel *insertGroupModel) {
                            
                            BOOL insertSuccess = [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModelNotUpdateNewestChatMsg:insertGroupModel];
                            
                            if (insertSuccess) {
                                
                                [self insertNormalMessageToDBGroupListWithChatMsgListModel:msgModel];
                            }
                        }];
                    }
                    
                    
                }else {
                    
                    [self insertNormalMessageToDBGroupListWithChatMsgListModel:msgModel];
                }
            }
        }
    }
}

// 处理离线工作类的消息
+ (void)dealOffLineWorkMsg:(NSArray *)workMsgs {
    
    for (int i = 0; i < workMsgs.count; i ++) {
        
        JGJChatMsgListModel *msgModel = workMsgs[i];

        if (msgModel.chatListType ==  JGJChatListSyncNoticeTargetType || msgModel.chatListType ==  JGJChatListDemandSyncBillType || msgModel.chatListType ==  JGJChatListSyncBillToYouType || msgModel.chatListType == JGJChatListagreeSyncBillType || msgModel.chatListType == JGJChatListRefuseSyncBillType || msgModel.chatListType == JGJChatListCancellSyncBillType || [msgModel.class_type isEqualToString:@"group"] || [msgModel.origin_class_type isEqualToString:@"group"] || msgModel.chatListType == JGJChatListIntegralType || msgModel.chatListType == JGJChatListEvaluateType || [msgModel.can_recive_client isEqualToString:@"person"]) {// 排除脏数据
            
            break;
            
        }else {
            
            if (![TYUserDefaults objectForKey:@"shareSocketConnect_msg_idSet"]) {
                
                [JGJSocketRequest shareSocketConnect].msg_idSet = [[NSMutableSet alloc] init];
            }else {
                
                [JGJSocketRequest shareSocketConnect].msg_idSet = [[NSMutableSet alloc] initWithArray:[TYUserDefaults objectForKey:@"shareSocketConnect_msg_idSet"]];
            }
            
            if ([NSString isEmpty:msgModel.msg_id]) {
                
                return;
            }
            if ([[JGJSocketRequest shareSocketConnect].msg_idSet containsObject:msgModel.msg_id] || [[JGJSocketRequest shareSocketConnect].msg_idSet containsObject:msgModel.bill_id]) {
                
                msgModel.offLine_message_count = 0;
            }else {
                
                msgModel.offLine_message_count = 1;
                if ([msgModel.sys_msg_type isEqualToString:@"newFriends"]) {
                    
                    [[JGJSocketRequest shareSocketConnect].msg_idSet addObject:msgModel.bill_id];
                }
                [[JGJSocketRequest shareSocketConnect].msg_idSet addObject:msgModel.msg_id];
                
            }
            if ([JGJSocketRequest shareSocketConnect].msg_idSet.count > 30) {
                
                [[JGJSocketRequest shareSocketConnect].msg_idSet removeAllObjects];
            }
            [TYUserDefaults setObject:[[JGJSocketRequest shareSocketConnect].msg_idSet allObjects] forKey:@"shareSocketConnect_msg_idSet"];
            [self insertWork_Activity_RecruitMessageToDBGroupListWithChatMsgListModel:msgModel];
            
        }
    }
    
    
    // 回调给工作消息列表
    if ([JGJSocketRequest shareSocketConnect].workTypeMsgCallBack) {
        
        [JGJSocketRequest shareSocketConnect].workTypeMsgCallBack(workMsgs);
    }
}

// 更新工作 活动 招聘类型列表
+ (void)insertWork_Activity_RecruitMessageToDBGroupListWithChatMsgListModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    
    groupModel.group_id = msgModel.group_id;
    groupModel.class_type = msgModel.class_type;
    groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    groupModel.last_send_uid = msgModel.msg_sender;
    groupModel.last_msg_type = msgModel.msg_type;
    groupModel.last_msg_send_time = msgModel.send_time;
    groupModel.list_sort_time = msgModel.send_time;
    groupModel.last_send_name = msgModel.user_info.real_name;
    groupModel.sys_msg_type = msgModel.sys_msg_type;
    groupModel.max_asked_msg_id = msgModel.msg_id;
    groupModel.msg_text = msgModel.msg_text;
    groupModel.at_message = msgModel.at_message;
    
    groupModel.last_msg_content = msgModel.msg_text;

    groupModel.title = msgModel.title;
#pragma mark - 处理普通聊天的消息表
    // 被邀请加入新班组或者项目组
    if (msgModel.chatListType == JGJChatListJoinType || msgModel.chatListType == JGJChatListMemberJoin) {
        
        [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:^(BOOL responseObject) {

            [JGJChatGetOffLineMsgInfo http_getChatIndexList];

        }];
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
    }else if (msgModel.chatListType == JGJChatListRemoveType) { // 被移除班组或者项目组
        
        // 删除列表数据
        JGJChatGroupListModel *removeGroupModel = [[JGJChatGroupListModel alloc] init];
        removeGroupModel.group_id = msgModel.origin_group_id;
        removeGroupModel.class_type = msgModel.origin_class_type;
        BOOL delSuccess = [JGJChatMsgDBManger deleteChatGroupListDataWithModel:removeGroupModel];
        
        if (delSuccess) {
            
            [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:nil];
            
            [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        }
        
    }else if (msgModel.chatListType == JGJChatListCloseType) { // 关闭班组或者项目推送
        
        JGJChatGroupListModel *_delGroup = [[JGJChatGroupListModel alloc] init];
        _delGroup.group_id = msgModel.origin_group_id;
        _delGroup.class_type = msgModel.origin_class_type;
        _delGroup.sys_msg_type = msgModel.sys_msg_type;
        _delGroup.is_delete = YES;
        _delGroup.is_top = NO;
        _delGroup.is_closed = YES;
        BOOL is_delete_success = [JGJChatMsgDBManger updateIs_deleteToGroupTableWithIsDelete:_delGroup group_id:_delGroup.group_id class_type:_delGroup.class_type];
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
    }else if (msgModel.chatListType == JGJChatListReopenType) {// 重启班组或者项目组
        
        JGJChatGroupListModel *_delGroup = [[JGJChatGroupListModel alloc] init];
        _delGroup.group_id = msgModel.origin_group_id;
        _delGroup.class_type = msgModel.origin_class_type;
        _delGroup.sys_msg_type = msgModel.sys_msg_type;
        _delGroup.is_delete = NO;
        _delGroup.is_top = NO;
        _delGroup.is_closed = NO;
        BOOL is_delete_success = [JGJChatMsgDBManger updateIs_deleteToGroupTableWithIsDelete:_delGroup group_id:_delGroup.group_id class_type:_delGroup.class_type];
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
    }else if (msgModel.chatListType == JGJChatListDismissGroupType) {// 群解散通知
        
        // 删除列表数据
        JGJChatGroupListModel *removeGroupModel = [[JGJChatGroupListModel alloc] init];
        removeGroupModel.group_id = msgModel.origin_group_id;
        removeGroupModel.class_type = msgModel.origin_class_type;
        [JGJChatMsgDBManger deleteChatGroupListDataWithModel:removeGroupModel];
        
    }
    
    // 根据当前工作消息类型 处理对应的未读数
    JGJChatGroupListModel *originGroupModel = [[JGJChatGroupListModel alloc] init];
    originGroupModel.group_id = msgModel.origin_group_id;
    originGroupModel.class_type = msgModel.origin_class_type;
    [self updateUnread_work_countWithGroupModel:originGroupModel chatListType:msgModel.chatListType];
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:msgModel.origin_group_id class_type:msgModel.origin_class_type chatListType:msgModel.chatListType];
    
    // 更新工作类型消息的最新消息和未读数
    if (msgModel.msg_total_type == JGJChatActivityMsgType) {// 活动
        
        groupModel.group_name = @"活动消息";
        
    }else if (msgModel.msg_total_type == JGJChatRecruitMsgType) {// 招聘
        
        groupModel.group_name = @"招聘小助手";
        
    }else if (msgModel.msg_total_type == JGJChatNewFriendsMsgType) {// 新的好友
        
        groupModel.group_name = @"新的好友";
        
    }else {
        
        groupModel.group_name = @"工作消息";
        
    }
    groupModel.chat_unread_msg_count = [self getUnreadMsgNum:groupModel msgModelMsg_type:msgModel];
    BOOL insertSuccess = [JGJChatMsgDBManger updateNew_Chat_MsgToGroupTableWithGroupListModel:groupModel];
    
    if (insertSuccess) {
        
        JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
        if ([indexModel.group_id isEqualToString:msgModel.origin_group_id] && [indexModel.class_type isEqualToString:msgModel.origin_class_type]) {// 当前接收到的消息 是首页显示的项目
            
            [self updateUnread_index_countWithGroupModelChatListType:msgModel.chatListType indexModel:indexModel];
            [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
            // 更新首页未读数
            [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
        }
        
        if ([JGJSocketRequest shareSocketConnect].contactListCallBack) {
            
            [JGJSocketRequest shareSocketConnect].contactListCallBack();
        }
        
        
    }
    
}

+ (void)insertNormalMessageToDBGroupListWithChatMsgListModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    
    groupModel.group_id = msgModel.group_id;
    groupModel.class_type = msgModel.class_type;
    groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (msgModel.chatListType == JGJChatListDelmemberType && ![msgModel.msg_sender isEqualToString:groupModel.user_id]) {// 被移除群通知
        
        // 删除列表数据
        JGJChatGroupListModel *removeGroupModel = [[JGJChatGroupListModel alloc] init];
        removeGroupModel.group_id = msgModel.group_id;
        removeGroupModel.class_type = msgModel.class_type;
        [JGJChatMsgDBManger deleteChatGroupListDataWithModel:removeGroupModel];
        
    }else if (msgModel.chatListType == JGJChatListUpgradeGroupChatType) {// 群主升级班组通知
        
        // 删除列表数据
        JGJChatGroupListModel *removeGroupModel = [[JGJChatGroupListModel alloc] init];
        removeGroupModel.group_id = msgModel.origin_group_id;
        removeGroupModel.class_type = msgModel.origin_class_type;
        BOOL removeSuccess = [JGJChatMsgDBManger deleteChatGroupListDataWithModel:removeGroupModel];
        
        if (removeSuccess) {
            
            groupModel.last_send_uid = msgModel.msg_sender;
            groupModel.last_msg_type = msgModel.msg_type;
            groupModel.last_msg_send_time = msgModel.send_time;
            groupModel.list_sort_time = msgModel.send_time;
            groupModel.last_send_name = msgModel.user_info.real_name;
            groupModel.sys_msg_type = msgModel.sys_msg_type;
            groupModel.max_asked_msg_id = msgModel.msg_id;
            groupModel.is_delete = NO;// 把收到消息的项目标记为 未删除
            groupModel.msg_text = msgModel.msg_text;
            groupModel.at_message = msgModel.at_message;
            groupModel.title = msgModel.title;
            //正在读的话把当前消息id直接赋值给聊聊最大id
            if ([self readGroupMsgWithMsgModel:msgModel]) {
                
                groupModel.max_readed_msg_id = msgModel.msg_id;
            }
            
            groupModel.last_msg_content = msgModel.msg_text;
            
            groupModel.chat_unread_msg_count = [self getUnreadMsgNum:groupModel msgModelMsg_type:msgModel];
            
            [JGJChatMsgDBManger insertToChatGroupListTableWithNewestJGJChatMsgListModel:groupModel];
        }
        
    }else {
        
        if ([msgModel.class_type isEqualToString:@"singleChat"]) {
            
            groupModel.group_name = msgModel.user_info.real_name;
            groupModel.local_head_pic = [@[msgModel.user_info.head_pic ?:@""] mj_JSONString];
        }
        
        groupModel.last_send_uid = msgModel.msg_sender;
        groupModel.last_msg_type = msgModel.msg_type;
        groupModel.last_msg_send_time = msgModel.send_time;
        groupModel.list_sort_time = msgModel.send_time;
        groupModel.last_send_name = msgModel.user_info.real_name;
        groupModel.sys_msg_type = msgModel.sys_msg_type;
        groupModel.max_asked_msg_id = msgModel.msg_id;
        groupModel.is_delete = NO;// 把收到消息的项目标记为 未删除
        groupModel.msg_text = msgModel.msg_text;
        groupModel.at_message = msgModel.at_message;
        groupModel.title = msgModel.title;
        
        groupModel.recruitMsgTitle = msgModel.recruitMsgModel.pro_title;
        groupModel.linkMsgTitle = msgModel.shareMenuModel.title;
        groupModel.linkMsgContent = msgModel.shareMenuModel.describe;
        //正在读的话把当前消息id直接赋值给聊聊最大id
        if ([self readGroupMsgWithMsgModel:msgModel]) {
            
            groupModel.max_readed_msg_id = msgModel.msg_id;
        }
        
        groupModel.last_msg_content = msgModel.msg_text;
        
        groupModel.chat_unread_msg_count = [self getUnreadMsgNum:groupModel msgModelMsg_type:msgModel];
        
        BOOL insertSuccess = [JGJChatMsgDBManger insertToChatGroupListTableWithNewestJGJChatMsgListModel:groupModel];
        
        if (insertSuccess) {
            
            JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
            if ([indexModel.group_id isEqualToString:groupModel.group_id] && [indexModel.class_type isEqualToString:groupModel.class_type]) {// 当前接收到的消息 是首页显示的项目
                
                // 更新首页未读数
                [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
            }
            
            
        }
    }
    if ([JGJSocketRequest shareSocketConnect].contactListCallBack) {
        
        [JGJSocketRequest shareSocketConnect].contactListCallBack();
    }
    
    
}



#pragma mark - 更新工作类型消息 未读数 首页 只显示红点 所以只需要 数量大于0
+ (void)updateUnread_work_countWithGroupModel:(JGJChatGroupListModel *)groupModel chatListType:(JGJChatListType)type {
    
    switch (type) {
        case JGJChatListQuality:// 质量
        {
            groupModel.unread_quality_count = @"1";
            
        }
            break;
        case JGJChatListSafe:// 安全
        {
            groupModel.unread_safe_count = @"1";
        }
            break;
            
        case JGJChatListInspectType:// 检查
        {
            groupModel.unread_inspect_count = @"1";
        }
            break;
            
        case JGJChatListTaskType:// 任务
        {
            groupModel.unread_task_count = @"1";
        }
            break;
            
        case JGJChatListNotice:// 通知
        {
            groupModel.unread_notice_count = @"1";
        }
            break;
        case JGJChatListLog:// 日志
        {
            groupModel.unread_log_count = @"1";
        }
            break;
        case JGJChatListMeeting:// 会议
        {
            groupModel.unread_meeting_count = @"1";
        }
            break;
            
        case JGJChatListApproveType:// 会议
        {
            groupModel.unread_approval_count = @"1";
        }
            break;
            
        default:
            break;
    }
}

+ (void)updateUnread_index_countWithGroupModelChatListType:(JGJChatListType)type indexModel:(JGJIndexDataModel *)indexModel{
    
    switch (type) {
        case JGJChatListQuality:// 质量
        {
            indexModel.unread_quality_count = @"1";
            
        }
            break;
        case JGJChatListSafe:// 安全
        {
            indexModel.unread_safe_count = @"1";
        }
            break;
            
        case JGJChatListInspectType:// 检查
        {
            indexModel.unread_inspect_count = @"1";
        }
            break;
            
        case JGJChatListTaskType:// 任务
        {
            indexModel.unread_task_count = @"1";
        }
            break;
            
        case JGJChatListNotice:// 通知
        {
            indexModel.unread_notice_count = @"1";
        }
            break;
        case JGJChatListLog:// 日志
        {
            indexModel.unread_log_count = @"1";
        }
            break;
        case JGJChatListMeeting:// 会议
        {
            indexModel.unread_meeting_count = @"1";
        }
            break;
            
        case JGJChatListApproveType:// 会议
        {
            indexModel.unread_approval_count = @"1";
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 获取未读数
+(NSString *)getUnreadMsgNum:(JGJChatGroupListModel *)groupModel msgModelMsg_type:(JGJChatMsgListModel *)msg_model{
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.class_type = groupModel.class_type;
    
    msgModel.group_id = groupModel.group_id;
    
    msgModel.sys_msg_type = groupModel.class_type;
    
    NSString *chat_unread_count;
    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
    //正在读的话把当前消息id直接赋值给聊聊最大id
    if ([self readGroupMsgWithMsgModel:msgModel]) {
        
        chat_unread_count = @"0";
        
    }else {
        
        // 获取消息对应的班组是否设置了静音
        JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
        if ([msg_model.msg_sender isEqualToString:userId]) {//发送者是自己 未读数不加1
            
            chat_unread_count = [NSString stringWithFormat:@"%ld",(long)[originGroupModel.chat_unread_msg_count integerValue]];
            
        }else {
            
            chat_unread_count = [NSString stringWithFormat:@"%ld",[originGroupModel.chat_unread_msg_count integerValue] + msg_model.offLine_message_count];
        }
        
    }
    
    return chat_unread_count;
}

#pragma mark - 是否在在读当前组的消息
+(BOOL)readGroupMsgWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatMsgListModel *readMsgModel = [JGJSocketRequest shareSocketConnect].readMsgModel;
    
    if ([NSString isEmpty:msgModel.group_id] || [NSString isEmpty:msgModel.class_type]) {
        
        return NO;
    }
    
    BOOL is_read = NO;
    if ([[JGJSocketRequest shareSocketConnect].is_readed isEqualToString:@"1"] && [readMsgModel.class_type isEqualToString:msgModel.class_type] && [readMsgModel.group_id isEqualToString:msgModel.group_id]) {
        
        is_read = YES;
    }
    
    return is_read;
}

- (WorkTypeMsgCallBack)workTypeMsgCallBack {
    
    return objc_getAssociatedObject(self, &workTypeMsg_callback_key);
}

- (void)setWorkTypeMsgCallBack:(WorkTypeMsgCallBack)workTypeMsgCallBack {
    
    objc_setAssociatedObject(self, &workTypeMsg_callback_key, workTypeMsgCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSMutableSet *)msg_idSet {
    
    return objc_getAssociatedObject(self, &msg_idSet_callback_key);
}

- (void)setMsg_idSet:(NSMutableSet *)msg_idSet {
    
    objc_setAssociatedObject(self, &msg_idSet_callback_key, msg_idSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet *)normale_msg_idSet {
    
    return objc_getAssociatedObject(self, &normale_msg_idSet_callback_key);
}

- (void)setNormale_msg_idSet:(NSMutableSet *)normale_msg_idSet {
    
    objc_setAssociatedObject(self, &normale_msg_idSet_callback_key, normale_msg_idSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSMutableArray *)distinctMsg_idWithMsg_array:(NSArray *)array {
    
    NSString *_last_msg_id = @"0";
    NSMutableArray *distinct_array = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        
        JGJChatMsgListModel *msgModel = array[i];
        if ( i == 0) {
            
            _last_msg_id = msgModel.msg_id;
            [distinct_array addObject:msgModel];
            
        }else if (![_last_msg_id isEqualToString:msgModel.msg_id]) {
            
            _last_msg_id = msgModel.msg_id;
            [distinct_array addObject:msgModel];
        }
        
    }
    return distinct_array;
}

@end
