//
//  JGJChatGroupListModel+JGJGroupListWCTTableCoding.h
//  mix
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatGroupListModel.h"
#import <WCDB/WCDB.h>
@interface JGJChatGroupListModel (JGJGroupListWCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(primary_key);
WCDB_PROPERTY(user_id);
WCDB_PROPERTY(group_id);
WCDB_PROPERTY(pro_id);
WCDB_PROPERTY(class_type);
WCDB_PROPERTY(group_name);
WCDB_PROPERTY(server_head_pic);
WCDB_PROPERTY(local_head_pic);
WCDB_PROPERTY(creater_uid);
WCDB_PROPERTY(create_time);
WCDB_PROPERTY(members_num);
WCDB_PROPERTY(chat_unread_msg_count);
WCDB_PROPERTY(last_send_uid);
WCDB_PROPERTY(last_send_name);
WCDB_PROPERTY(last_msg_type);
WCDB_PROPERTY(last_msg_content);
WCDB_PROPERTY(last_msg_send_time);
WCDB_PROPERTY(sys_msg_type);
WCDB_PROPERTY(agency_group_uid);
WCDB_PROPERTY(is_no_disturbed);
WCDB_PROPERTY(modified_time);
WCDB_PROPERTY(max_readed_msg_id);
WCDB_PROPERTY(max_asked_msg_id);
WCDB_PROPERTY(at_message);
WCDB_PROPERTY(is_top);
WCDB_PROPERTY(all_pro_name);
WCDB_PROPERTY(can_at_all);
WCDB_PROPERTY(is_closed);
WCDB_PROPERTY(is_sticked);
WCDB_PROPERTY(is_delete);
WCDB_PROPERTY(close_time);
WCDB_PROPERTY(list_sort_time);


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
WCDB_PROPERTY(unread_weath_count);
WCDB_PROPERTY(msg_text);
WCDB_PROPERTY(title);

WCDB_PROPERTY(recruitMsgTitle);

WCDB_PROPERTY(linkMsgTitle);
WCDB_PROPERTY(linkMsgContent);

//3.4.2yj添加扩展字段

WCDB_PROPERTY(extent_type);

//3.4.2当前是群聊使用(招工找活关键词防骗提示yj),是昨天或者是空的信息就显示。

WCDB_PROPERTY(extent_msg);
@end
