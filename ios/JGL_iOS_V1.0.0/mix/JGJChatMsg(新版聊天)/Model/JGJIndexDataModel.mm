//
//  JGJIndexDataModel.m
//  mix
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJIndexDataModel.h"
#import <WCDB/WCDB.h>

@interface JGJIndexDataModel ()<WCTTableCoding>

@end
@implementation JGJIndexDataModel

- (BOOL)isAutoIncrement {
    
    return YES;
}
#pragma mark - 定义绑定到数据库表的类
WCDB_IMPLEMENTATION(JGJIndexDataModel)

//#pragma mark - 定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(JGJIndexDataModel, primary_key)
WCDB_SYNTHESIZE(JGJIndexDataModel, group_id)
WCDB_SYNTHESIZE(JGJIndexDataModel, class_type)
WCDB_SYNTHESIZE(JGJIndexDataModel, group_name)
WCDB_SYNTHESIZE(JGJIndexDataModel, local_head_pic)
WCDB_SYNTHESIZE(JGJIndexDataModel, creater_uid)
WCDB_SYNTHESIZE(JGJIndexDataModel, chat_unread_msg_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_quality_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_safe_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_inspect_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_task_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_notice_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_sign_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_meeting_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_approval_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_log_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, group_info_wcdb)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_billRecord_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_bill_count)

WCDB_SYNTHESIZE(JGJIndexDataModel, unread_weath_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, work_message_num)
WCDB_SYNTHESIZE(JGJIndexDataModel, is_closed)
WCDB_SYNTHESIZE(JGJIndexDataModel, is_senior_expire)
WCDB_SYNTHESIZE(JGJIndexDataModel, create_default)
WCDB_SYNTHESIZE(JGJIndexDataModel, unread_msg_count)
WCDB_SYNTHESIZE(JGJIndexDataModel, new_user)
WCDB_SYNTHESIZE(JGJIndexDataModel, is_cloud_expire)
WCDB_SYNTHESIZE(JGJIndexDataModel, is_senior)
WCDB_SYNTHESIZE(JGJIndexDataModel, members_num)
WCDB_SYNTHESIZE(JGJIndexDataModel, pro_id)
WCDB_SYNTHESIZE(JGJIndexDataModel, all_pro_name)
WCDB_SYNTHESIZE(JGJIndexDataModel, is_cloud)
WCDB_SYNTHESIZE(JGJIndexDataModel, user_id)
WCDB_SYNTHESIZE(JGJIndexDataModel, agency_group_userInfo)


//#pragma mark - 设置主键
WCDB_PRIMARY_AUTO_INCREMENT(JGJIndexDataModel, primary_key)
//#pragma mark - 设置索引
WCDB_INDEX(JGJIndexDataModel, "_index", group_id)
WCDB_INDEX(JGJIndexDataModel, "_index", class_type)

- (JGJMyWorkCircleProListModel *)group_info {
    
    NSDictionary *dic = [self.group_info_wcdb mj_JSONObject];

    return [JGJMyWorkCircleProListModel mj_objectWithKeyValues:dic];
}
@end
