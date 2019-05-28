//
//  JGJChatMsgListModel+JGJWCDB.h
//  mix
//
//  Created by yj on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgListModel.h"
#import <WCDB/WCDB.h>

@interface JGJChatMsgListModel (JGJWCDB)<WCTTableCoding>

WCDB_PROPERTY(primary_key);

WCDB_PROPERTY(local_id);

WCDB_PROPERTY(msg_id);

WCDB_PROPERTY(wcdb_msg_id);

WCDB_PROPERTY(group_id);

WCDB_PROPERTY(class_type);

WCDB_PROPERTY(send_time);

WCDB_PROPERTY(server_head_pic);

WCDB_PROPERTY(local_head_pic);

WCDB_PROPERTY(msg_sender);

WCDB_PROPERTY(send_name);

WCDB_PROPERTY(msg_text);

WCDB_PROPERTY(msg_type);

WCDB_PROPERTY(recall_time);

WCDB_PROPERTY(unread_members_num);

WCDB_PROPERTY(readed_members_num);

WCDB_PROPERTY(sendType);

WCDB_PROPERTY(msg_total_type);

WCDB_PROPERTY(wcdb_user_info);

WCDB_PROPERTY(msg_src);

WCDB_PROPERTY(pic_w_h);

WCDB_PROPERTY(assetlocalIdentifier);

WCDB_PROPERTY(is_received);

WCDB_PROPERTY(is_readed);

WCDB_PROPERTY(user_unique);

WCDB_PROPERTY(voice_long);
WCDB_PROPERTY(extend_int);
//工作、招聘字段
WCDB_PROPERTY(job_detail);

//修改后用户的头像
WCDB_PROPERTY(modify_head_pic)

//聊天延展字段
WCDB_PROPERTY(wcdb_extend)

// cc添加
WCDB_PROPERTY(group_name);
WCDB_PROPERTY(isplayed);
WCDB_PROPERTY(detail);
WCDB_PROPERTY(work_message);
WCDB_PROPERTY(at_message);
WCDB_PROPERTY(status);
WCDB_PROPERTY(modify);
WCDB_PROPERTY(bill_id);
WCDB_PROPERTY(url);
WCDB_PROPERTY(origin_group_id);
WCDB_PROPERTY(origin_class_type);
WCDB_PROPERTY(title);
WCDB_PROPERTY(role_type);
WCDB_PROPERTY(can_recive_client);

//4.0.1招工招聘
WCDB_PROPERTY(msg_text_other);


@end
