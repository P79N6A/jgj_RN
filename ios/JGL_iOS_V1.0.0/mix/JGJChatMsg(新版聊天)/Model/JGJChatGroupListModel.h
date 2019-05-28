//
//  JGJChatGroupListModel.h
//  mix
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJChatGroupListModel : NSObject

@property (nonatomic, assign) NSInteger primary_key;
@property (nonatomic, copy) NSString *all_pro_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *class_type;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *server_head_pic;
@property (nonatomic, copy) NSString *local_head_pic;
@property (nonatomic, copy) NSString *creater_uid;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *chat_unread_msg_count;
@property (nonatomic, copy) NSString *members_num;
@property (nonatomic, copy) NSString *last_send_uid;
@property (nonatomic, copy) NSString *last_send_name;
@property (nonatomic, copy) NSString *last_msg_type;
@property (nonatomic, copy) NSString *last_msg_content;
@property (nonatomic, copy) NSAttributedString *last_msg_html_content;
@property (nonatomic, copy) NSString *last_msg_send_time;
@property (nonatomic, copy) NSString *list_sort_time;
@property (nonatomic, copy) NSString *sys_msg_type;
@property (nonatomic, copy) NSString *agency_group_uid;
@property (nonatomic, assign) BOOL is_no_disturbed;
@property (nonatomic, copy) NSString *modified_time;
@property (nonatomic, copy) NSString *max_readed_msg_id;
@property (nonatomic, copy) NSString *max_asked_msg_id;
@property (nonatomic, copy) NSString *at_message;
@property (nonatomic, copy) NSString *close_time;
@property (nonatomic, strong) JGJSynBillingModel *agency_group_userInfo;
@property (nonatomic, copy) NSString *agency_group_user;

@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, assign) BOOL can_at_all;
@property (nonatomic, assign) BOOL is_closed;
@property (nonatomic, assign) BOOL is_sticked;


@property (nonatomic, copy) NSString *unread_quality_count;
@property (nonatomic, copy) NSString *unread_safe_count;
@property (nonatomic, copy) NSString *unread_inspect_count;
@property (nonatomic, copy) NSString *unread_task_count;
@property (nonatomic, copy) NSString *unread_notice_count;
@property (nonatomic, copy) NSString *unread_sign_count;
@property (nonatomic, copy) NSString *unread_meeting_count;
@property (nonatomic, copy) NSString *unread_approval_count;
@property (nonatomic, copy) NSString *unread_log_count;
@property (nonatomic, copy) NSString *unread_billRecord_count;// 记工报表
@property (nonatomic, copy) NSString *unread_bill_count; //出勤公示未读数
@property (nonatomic, copy) NSString *unread_weath_count;


@property (nonatomic, copy) NSString *work_message_num;//工作恢复消息数



@property (nonatomic, assign) BOOL is_selected;// 是否选中，用于选择项目列表
@property (nonatomic, assign) CGFloat checkProCellHeight;//查看项目cell高度
//是否是查看已关闭的项目
@property (nonatomic, assign) BOOL isCheckClosedPro;
@property (nonatomic, copy) NSString *headerTilte;
@property (nonatomic, assign) BOOL isUnExpand;// 是否展开项目
@property (nonatomic, assign) BOOL is_delete;// 项目是否删除

@property (nonatomic, copy) NSString *msg_text;
@property (nonatomic, copy) NSString *title;// 标题

// v4.0.1 招工信息消息 标题
@property (nonatomic, copy) NSString *recruitMsgTitle;

// 链接消息标题
@property (nonatomic, copy) NSString *linkMsgTitle;
// 链接消息内容
@property (nonatomic, copy) NSString *linkMsgContent;



//3.4.2yj添加扩展字段
@property (nonatomic, copy) NSString *extent_type;

//3.4.2当前是群聊使用(招工找活关键词防骗提示yj),是否已显示提示 有时间就和今天作比较 ，是昨天或者是空的信息就显示。今天就不显示

@property (nonatomic, copy) NSString *extent_msg;

@end

