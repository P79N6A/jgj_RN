//
//  JGJIndexDataModel+JGJIndexDataModel.h
//  mix
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//


#import "JGJIndexDataModel.h"
#import <WCDB/WCDB.h>

@interface JGJIndexDataModel (JGJIndexDataModel)<WCTTableCoding>

WCDB_PROPERTY(primary_key);
WCDB_PROPERTY(group_id);
WCDB_PROPERTY(class_type);
WCDB_PROPERTY(group_name);
WCDB_PROPERTY(server_head_pic);
WCDB_PROPERTY(local_head_pic);
WCDB_PROPERTY(creater_uid);
WCDB_PROPERTY(chat_unread_msg_count);
WCDB_PROPERTY(unread_quality_count);
WCDB_PROPERTY(unread_safe_count);
WCDB_PROPERTY(unread_inspect_count);
WCDB_PROPERTY(unread_task_count);
WCDB_PROPERTY(unread_notice_count);
WCDB_PROPERTY(unread_sign_count);
WCDB_PROPERTY(unread_meeting_count);
WCDB_PROPERTY(unread_approval_count);
WCDB_PROPERTY(unread_log_count);
WCDB_PROPERTY(unread_billRecord_count);
WCDB_PROPERTY(unread_bill_count);

WCDB_PROPERTY(unread_weath_count);
WCDB_PROPERTY(work_message_num);
WCDB_PROPERTY(is_closed);
WCDB_PROPERTY(is_senior_expire);
WCDB_PROPERTY(create_default);
WCDB_PROPERTY(unread_msg_count);
WCDB_PROPERTY(new_user);
WCDB_PROPERTY(is_cloud_expire);
WCDB_PROPERTY(is_senior);
WCDB_PROPERTY(members_num);
WCDB_PROPERTY(pro_id);
WCDB_PROPERTY(all_pro_name);
WCDB_PROPERTY(unread_log_cis_cloudount);
WCDB_PROPERTY(group_info_wcdb);
WCDB_PROPERTY(user_id);
WCDB_PROPERTY(agency_group_userInfo);


@end
