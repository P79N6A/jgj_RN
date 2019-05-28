//
//  JGJIndexDataModel.h
//  mix
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJIndexDataModel : NSObject

@property (nonatomic, assign) NSInteger primary_key;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *server_head_pic;
@property (nonatomic, copy) NSString *local_head_pic;
@property (nonatomic, copy) NSString *agency_group_user;
@property (nonatomic, copy) NSString *creater_uid;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *group_info;
@property (nonatomic, copy) NSString *group_info_wcdb;


@property (nonatomic, copy) NSString *chat_unread_msg_count;

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
@property (nonatomic, copy) NSString *unread_weath_count;

@property (nonatomic, copy) NSString *work_message_num;
@property (nonatomic, assign) BOOL is_closed;
@property (nonatomic, assign) BOOL is_senior_expire;
@property (nonatomic, assign) BOOL create_default;
@property (nonatomic, copy) NSString *unread_msg_count;
@property (nonatomic, assign) BOOL new_user;
@property (nonatomic, assign) BOOL is_cloud_expire;
@property (nonatomic, assign) BOOL is_senior;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *all_pro_name;
@property (nonatomic, assign) BOOL is_cloud;
@end
