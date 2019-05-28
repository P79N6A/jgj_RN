//
//  JGJChatGetOffLineMsgInfo.m
//  mix
//
//  Created by Tony on 2018/8/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatGetOffLineMsgInfo.h"
#import "JGJHttpGetChatListModel.h"
#import "JGJChatMsgDBManger.h"
#import "JGJSocketRequest+ChatMsgService.h"
static JGJChatGetOffLineMsgInfo *maneger = nil;
@implementation JGJChatGetOffLineMsgInfo

+ (JGJChatGetOffLineMsgInfo *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maneger = [[JGJChatGetOffLineMsgInfo alloc] init];
    });
    
    return maneger;
}

+ (void)initialize {
    
    if (!maneger) {
        
        maneger = [self shareManager];
    }
}

#pragma mark - 获取首页项目列表
+ (void)http_getChatIndexList{
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-index-list" parameters:nil success:^(id responseObject) {
        
        NSLog(@"首页消息 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            return;
        }
        JGJIndexDataModel *indexModel = [JGJIndexDataModel mj_objectWithKeyValues:responseObject];
        indexModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
        indexModel.group_id = [responseObject[@"group_info"][@"group_id"] stringValue];
        indexModel.class_type = responseObject[@"group_info"][@"class_type"];
        indexModel.members_num = [NSString stringWithFormat:@"%ld",[responseObject[@"group_info"][@"members_num"] integerValue]];
        indexModel.group_info_wcdb = [responseObject[@"group_info"] mj_JSONString];
        [JGJChatMsgDBManger deleteIndexModelInIndexTable];
        
        BOOL insertSuccess = [JGJChatMsgDBManger insertIndexModelToIndexTable:indexModel];
        
        if (insertSuccess) {
            
            [self refreshIndexTbToHomeVC];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取班组列表
+ (void)http_getChatGroupListSuccess:(void (^)(BOOL responseObject))success{
    
    NSMutableArray *existGoupListArr = [[NSMutableArray alloc] init];
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-chat-list" parameters:nil success:^(id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        NSArray *list = [JGJHttpGetChatListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        for (int i = 0; i < list.count; i++) {
            
            JGJHttpGetChatListModel *listModel = list[i];
            
            JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
            groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
            groupModel.group_id = listModel.group_id;
            groupModel.pro_id = listModel.pro_id;
            groupModel.group_name = listModel.group_name;
            groupModel.class_type = listModel.class_type;
            groupModel.local_head_pic = [listModel.members_head_pic mj_JSONString];
            groupModel.members_num = listModel.members_num;
            groupModel.creater_uid = listModel.creater_uid;
            groupModel.create_time = listModel.create_time;
            groupModel.is_no_disturbed = listModel.is_no_disturbed;
            groupModel.is_top = listModel.is_sticked;
            groupModel.all_pro_name = listModel.all_pro_name;
            groupModel.can_at_all = listModel.can_at_all;
            groupModel.is_sticked = listModel.is_sticked;
            groupModel.is_closed = listModel.is_closed;
            groupModel.sys_msg_type = listModel.sys_msg_type;
            groupModel.max_asked_msg_id = listModel.msg_id;
            
            // 获取聊聊是否移除过
            JGJChatGroupListModel *existGroup = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:listModel.group_id classType:listModel.class_type];
            groupModel.is_delete = existGroup.is_delete;
//            groupModel.extent_type = existGroup.extent_type;
            
            [existGoupListArr addObject:groupModel];
            
            // 获取对应组最大的消息
            JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
            msgModel.group_id = listModel.group_id;
            msgModel.class_type = listModel.class_type;
            if ([listModel.class_type isEqualToString:@"work"]) {
                
                msgModel.msg_total_type = JGJChatWorkMsgType;
                
            }else if ([listModel.class_type isEqualToString:@"activity"]) {
                
                msgModel.msg_total_type = JGJChatActivityMsgType;
                
            }else if ([listModel.class_type isEqualToString:@"recruit"]) {
                
                msgModel.msg_total_type = JGJChatRecruitMsgType;
                
            }else {
                
                msgModel.msg_total_type = JGJChatNormalMsgType;
            }
            
            JGJChatMsgListModel *maxMsgModel = [JGJChatMsgDBManger maxGroupListModelWithChatMsgListModel:msgModel];
            
            groupModel.last_msg_type = maxMsgModel.msg_type;
            groupModel.last_msg_content = maxMsgModel.msg_text;
            groupModel.last_send_uid = maxMsgModel.msg_sender;
            groupModel.last_msg_send_time = maxMsgModel.send_time;
            groupModel.last_send_name = maxMsgModel.send_name;
            groupModel.list_sort_time = maxMsgModel.send_time;
            BOOL insertResult = NO;
            if ([listModel.class_type isEqualToString:@"recruit"] || [listModel.class_type isEqualToString:@"activity"]) {
                
                groupModel.is_delete = NO;
                
                insertResult = [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListWork_ActivityModelNotUpdateNewestChatMsg:groupModel];
                
            }else{
                
                if ([listModel.class_type isEqualToString:@"work"]) {
                    
                    groupModel.is_delete = NO;
                }else {
                    
                    JGJChatGroupListModel *existGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:groupModel.group_id classType:groupModel.class_type];
                    
                    groupModel.is_delete = existGroupModel.is_delete;
                }
                
                insertResult = [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModelNotUpdateNewestChatMsg:groupModel];
            }
            
            
            if (insertResult) {
                
                JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
                if ([indexModel.group_id isEqualToString:groupModel.group_id] && [indexModel.class_type isEqualToString:groupModel.class_type]) {// 当前接收到的消息 是首页显示的项目
                    
                    [self refreshIndexTbToHomeVC];
                }
            }
        }
        
        [self fileterExistArrWithGroupArr:existGoupListArr];
        [TYNotificationCenter postNotificationName:@"get_chat_list_success" object:nil];
        if (success) {
            
            success(YES);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)http_getSingleChatGroupWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type success:(void (^)(JGJChatGroupListModel *groupModel))success{
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-chat-list" parameters:@{@"group_id":group_id?:@"",@"class_type":class_type?:@""} success:^(id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        JGJHttpGetChatListModel *listModel = [JGJHttpGetChatListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]].lastObject;
        
        JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
        groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
        groupModel.group_id = listModel.group_id;
        groupModel.pro_id = listModel.pro_id;
        groupModel.group_name = listModel.group_name;
        groupModel.class_type = listModel.class_type;
        groupModel.local_head_pic = [listModel.members_head_pic mj_JSONString];
        groupModel.members_num = listModel.members_num;
        groupModel.creater_uid = listModel.creater_uid;
        groupModel.create_time = listModel.create_time;
        groupModel.is_no_disturbed = listModel.is_no_disturbed;
        groupModel.is_top = listModel.is_sticked;
        groupModel.all_pro_name = listModel.all_pro_name;
        groupModel.can_at_all = listModel.can_at_all;
        groupModel.is_sticked = listModel.is_sticked;
        groupModel.is_closed = listModel.is_closed;
        groupModel.sys_msg_type = listModel.sys_msg_type;
        groupModel.max_asked_msg_id = listModel.msg_id;

        
        if (success) {
            success(groupModel);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 获取已关闭列表
+ (void)http_getClosedGroupList{
    
    NSMutableArray *existArr = [[NSMutableArray alloc] init];
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-close-chat-list" parameters:nil success:^(id responseObject) {
        
        NSLog(@"closedgroupList = %@",responseObject);
        NSArray *list = [JGJHttpGetChatListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (JGJHttpGetChatListModel *listModel in list) {
            
            JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
            groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
            groupModel.group_id = listModel.group_id;
            groupModel.pro_id = listModel.pro_id;
            groupModel.group_name = listModel.group_name;
            groupModel.class_type = listModel.class_type;
            groupModel.local_head_pic = [listModel.members_head_pic mj_JSONString];
            groupModel.members_num = listModel.members_num;
            groupModel.creater_uid = listModel.creater_uid;
            groupModel.is_no_disturbed = listModel.is_no_disturbed;
            groupModel.is_top = listModel.is_sticked;
            groupModel.all_pro_name = listModel.all_pro_name;
            groupModel.can_at_all = listModel.can_at_all;
            groupModel.is_sticked = listModel.is_sticked;
            groupModel.is_closed = listModel.is_closed;
            groupModel.sys_msg_type = listModel.sys_msg_type;
            groupModel.max_asked_msg_id = listModel.msg_id;
            groupModel.close_time = listModel.close_time;
            BOOL insertResult = [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModel:groupModel];
            [existArr addObject:groupModel];
        }
        
        [self fileterExistArrWithGroupArr:existArr];
    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)fileterExistArrWithGroupArr:(NSMutableArray *)existArr {
    
    NSMutableArray *localGroupArr = [[NSMutableArray alloc] initWithArray:[JGJChatMsgDBManger getAllGroupListModel]];
    NSMutableArray *filterArr = [[NSMutableArray alloc] init];
    // 从本地剔除出列表没有返回的数据
    for (int i = 0; i < existArr.count; i ++) {
        JGJChatGroupListModel *existModel = existArr[i];
        
        BOOL isHaveLocalModel = NO;
        for (int j = 0; j < localGroupArr.count; j ++) {
            
            JGJChatGroupListModel *localGroupModel = localGroupArr[j];
            if ([localGroupModel.group_id isEqualToString:existModel.group_id] && [localGroupModel.class_type isEqualToString:existModel.class_type]) {
                
                isHaveLocalModel = YES;
                break;
            }
        }
        if (!isHaveLocalModel) {
            
            [filterArr addObject:existModel];
        }
    }
    
    if (filterArr.count > 0) {
        
        for (JGJChatGroupListModel *groupModel in filterArr) {
            
            [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
        }
    }
}

#pragma mark - 切换项目
+ (void)http_gotoTheGroupHomeVCWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type isNeedChangToHomeVC:(BOOL)needChange isNeedHttpRequest:(BOOL)needRequest success:(void (^)(BOOL isSuccess))success{
    
    NSDictionary *body = @{
                           @"class_type" : class_type?:@"",
                           @"group_id" : group_id?:@""
                           };
    
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-index-list" parameters:body success:^(id responseObject) {
        
        TYLog(@"切换项目首页responseObject = %@",responseObject);
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
        JGJIndexDataModel *indexModel = [self getTheIndexDataModelWithGroup_id:group_id classType:class_type];
        
        // 1.先删除本地的
        BOOL deleteSuccess = [JGJChatMsgDBManger deleteIndexModelInIndexTable];
        if (deleteSuccess) {
            
            // 2.再插入切换的
            BOOL insertSuccess = [JGJChatMsgDBManger insertIndexModelToIndexTable:indexModel];
            
            NSArray *class_types = @[@"group", @"team"];
            
            if (insertSuccess) {
                
                if (maneger.getIndexListSuccess) {
                    
                    if (needChange && [class_types indexOfObject:class_type] != NSNotFound) {
                        
                        UITabBarController *tabVc = [JGJChatGetOffLineMsgInfo shareManager].vc.tabBarController;
                        
                        if ([tabVc isKindOfClass:[UITabBarController class]]) {
                            
                            tabVc.selectedIndex = 0;
                            
                            tabVc.tabBar.hidden = NO;
                        }
                        
                    }
                    [self refreshIndexTbToHomeVC];
                }
            }
        }
        
        if (success) {
            
            success(YES);
        }
        
    } failure:^(NSError *error) {
        
    }];
}


+ (JGJIndexDataModel *)getTheIndexDataModelWithGroup_id:(NSString *)group_id classType:(NSString *)class_type {
    
    // 获取该项目组信息
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:group_id classType:class_type];
    
    JGJIndexDataModel *indexModel = [[JGJIndexDataModel alloc] init];
    indexModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
    indexModel.group_id = group_id;
    indexModel.class_type = class_type;
    indexModel.unread_task_count = groupModel.unread_task_count;
    indexModel.unread_inspect_count = groupModel.unread_inspect_count;
    indexModel.unread_notice_count = groupModel.unread_notice_count;
    indexModel.unread_safe_count = groupModel.unread_safe_count;
    indexModel.unread_sign_count = groupModel.unread_sign_count;
    indexModel.unread_log_count = groupModel.unread_log_count;
    indexModel.chat_unread_msg_count = groupModel.chat_unread_msg_count;
    indexModel.unread_quality_count = groupModel.unread_quality_count;
    indexModel.unread_billRecord_count = groupModel.unread_billRecord_count;
    indexModel.unread_approval_count = groupModel.unread_approval_count;
    indexModel.unread_weath_count = groupModel.unread_weath_count;
    indexModel.unread_meeting_count = groupModel.unread_meeting_count;
    
    indexModel.chat_unread_msg_count = groupModel.chat_unread_msg_count;
    
    JGJMyWorkCircleProListModel *group_info = [[JGJMyWorkCircleProListModel alloc] init];
    group_info.group_id = group_id;
    group_info.class_type = class_type;
    group_info.isClosedTeamVc = groupModel.is_closed;
    group_info.creater_uid = groupModel.creater_uid;
    group_info.members_head_pic = [groupModel.local_head_pic mj_JSONObject];
    group_info.group_name = groupModel.group_name;
    group_info.pro_name = groupModel.group_name;
    group_info.group_id = groupModel.group_id;
    group_info.members_num = groupModel.members_num;
    group_info.all_pro_name = groupModel.all_pro_name;
    group_info.pro_id = groupModel.pro_id;
    
    //能否@所有人
    group_info.can_at_all = groupModel.can_at_all;
    
    indexModel.group_info_wcdb = [group_info mj_JSONString];
    
    return indexModel;
}

#pragma mark - 回调首页
+ (void)refreshIndexTbToHomeVC {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    
    // 封装获取班组数据
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    
    //  获取关闭项目情况
    JGJMyWorkCircleProListModel *group_info = [[JGJMyWorkCircleProListModel alloc] init];
    group_info = indexModel.group_info;
    group_info.members_num = indexModel.members_num;
    
    if (![NSString isEmpty:groupModel.local_head_pic]) {
        
        group_info.local_head_pic = groupModel.local_head_pic;
        
    }else {
        
        group_info.local_head_pic = indexModel.group_info.local_head_pic;
    }
    
    if (![NSString isEmpty:groupModel.group_name]) {
        
        group_info.group_name = groupModel.group_name;
        group_info.pro_name = groupModel.group_name;
        
        group_info.all_pro_name = groupModel.all_pro_name;
    }else {
        
        group_info.group_name = indexModel.group_info.group_name;
        group_info.pro_name = indexModel.group_info.group_name;
        group_info.all_pro_name = indexModel.all_pro_name;
    }
    
    group_info.is_report = indexModel.group_info.is_report;
    group_info.can_at_all = indexModel.group_info.can_at_all;
    
    // 回到给首页的数据模型
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    proListModel.unread_task_count = indexModel.unread_task_count;
    proListModel.unread_inspect_count = indexModel.unread_inspect_count;
    proListModel.unread_notice_count = indexModel.unread_notice_count;
    proListModel.unread_safe_count = indexModel.unread_safe_count;
    proListModel.unread_sign_count = indexModel.unread_sign_count;
    proListModel.unread_log_count = indexModel.unread_log_count;
    proListModel.unread_quality_count = indexModel.unread_quality_count;
    proListModel.unread_billRecord_count = indexModel.unread_billRecord_count;
    proListModel.unread_approval_count = indexModel.unread_approval_count;
    proListModel.unread_weath_count = indexModel.unread_weath_count;
    proListModel.unread_meeting_count = indexModel.unread_meeting_count;
    proListModel.work_message_num = indexModel.work_message_num;
    
    proListModel.chat_unread_msg_count = groupModel.chat_unread_msg_count;
    
    proListModel.group_info = group_info;
    
    if (maneger.getIndexListSuccess) {
        
        maneger.getIndexListSuccess(proListModel);
    }
}

+ (void)getTheNewestCreatTimeGroupProjectInsertToHomeVcTb {
    
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    JGJIndexDataModel *indexModel = [[JGJIndexDataModel alloc] init];
    
    // 获取班组未读数
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    groupModel = [JGJChatMsgDBManger getNewestCreatTimeChatGroupListModel];
    
    indexModel.chat_unread_msg_count = groupModel.chat_unread_msg_count;
    
    indexModel.unread_task_count = groupModel.unread_task_count;
    indexModel.unread_inspect_count = groupModel.unread_inspect_count;
    indexModel.unread_notice_count = groupModel.unread_notice_count;
    indexModel.unread_safe_count = groupModel.unread_safe_count;
    indexModel.unread_sign_count = groupModel.unread_sign_count;
    indexModel.unread_log_count = groupModel.unread_log_count;
    indexModel.unread_quality_count = groupModel.unread_quality_count;
    indexModel.unread_billRecord_count = groupModel.unread_billRecord_count;
    indexModel.unread_approval_count = groupModel.unread_approval_count;
    indexModel.unread_weath_count = groupModel.unread_weath_count;
    indexModel.unread_meeting_count = groupModel.unread_meeting_count;
    
    //  获取关闭项目情况
    JGJMyWorkCircleProListModel *group_info = [[JGJMyWorkCircleProListModel alloc] init];
    group_info.class_type = groupModel.class_type;
    group_info.isClosedTeamVc = groupModel.is_closed;
    group_info.creater_uid = groupModel.creater_uid;
    group_info.members_head_pic = [groupModel.local_head_pic mj_JSONObject];
    group_info.group_name = groupModel.group_name;
    group_info.group_id = groupModel.group_id;
    group_info.members_num = groupModel.members_num;
    group_info.all_pro_name = groupModel.all_pro_name;
    //能否@所有人
    group_info.can_at_all = groupModel.can_at_all;
    indexModel.group_info_wcdb = [group_info mj_JSONString];
    
    // 1.先删除本地的
    BOOL deleteSuccess = [JGJChatMsgDBManger deleteIndexModelInIndexTable];
    if (deleteSuccess) {
        
        // 2.在插入新数据
        [JGJChatMsgDBManger insertIndexModelToIndexTable:indexModel];
    }
    
}

+ (void)recieveClosedTeamOrGroupWithIndexModel:(JGJIndexDataModel *)indexModel {
    
    [JGJChatMsgDBManger deleteIndexModelInIndexTable];
    
    //  获取关闭项目情况
    JGJMyWorkCircleProListModel *group_info = [[JGJMyWorkCircleProListModel alloc] init];
    group_info = indexModel.group_info;
    group_info.isClosedTeamVc = YES;
    indexModel.group_info_wcdb = [group_info mj_JSONString];
    BOOL indesrtSuccess = [JGJChatMsgDBManger insertIndexModelToIndexTable:indexModel];
    
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    
    proListModel.group_info = group_info;
    
    if (maneger.getIndexListSuccess) {
        
        maneger.getIndexListSuccess(proListModel);
    }
    
}
@end
