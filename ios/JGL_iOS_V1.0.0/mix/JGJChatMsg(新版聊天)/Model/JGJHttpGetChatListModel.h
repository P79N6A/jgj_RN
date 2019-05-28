//
//  JGJHttpGetChatListModel.h
//  mix
//
//  Created by Tony on 2018/8/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJHttpGetChatListModel : NSObject

@property (nonatomic, copy) NSString *all_pro_name;
@property (nonatomic, copy) NSString *at_message;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *creater_uid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSArray *members_head_pic;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *msg_text;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *send_time;
@property (nonatomic, copy) NSString *unread_msg_count;
@property (nonatomic, copy) NSString *sys_msg_type;
@property (nonatomic, copy) NSString *msg_sender;
@property (nonatomic, copy) NSString *msg_id;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *close_time;
@property (nonatomic, copy) NSString *unread_quality_count;
@property (nonatomic, copy) NSString *unread_safe_count;
@property (nonatomic, copy) NSString *unread_inspect_count;
@property (nonatomic, copy) NSString *unread_task_count;
@property (nonatomic, copy) NSString *unread_notice_count;
@property (nonatomic, copy) NSString *unread_sign_count;
@property (nonatomic, copy) NSString *unread_meeting_count;
@property (nonatomic, copy) NSString *unread_approval_count;
@property (nonatomic, copy) NSString *unread_log_count;
@property (nonatomic, copy) NSString *unread_billRecord_count;
@property (nonatomic, copy) NSString *unread_bill_count;

@property (nonatomic, copy) NSString *unread_weath_count;

@property (nonatomic, strong) JGJSynBillingModel *agency_group_user;


@property (nonatomic, assign) BOOL can_at_all;
@property (nonatomic, assign) BOOL is_closed;
@property (nonatomic, assign) BOOL is_no_disturbed;
@property (nonatomic, assign) BOOL is_sticked;

@end
