//
//  JGJTaskModel.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    WaitTaskCellDefaultType, //默认为待处理字体
    
    WaitTaskCellCompleteType //已完成头像%70 灰度 和字体要变为999999
    
} WaitTaskCellType;

@interface JGJTaskCommonModel : NSObject

@end

@interface JGJTaskModel : JGJTaskCommonModel

@property (nonatomic, copy) NSString *task_content;

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *task_level;

@property (nonatomic, copy) NSString *task_finish_time;

@property (nonatomic, copy) NSString *principal_head_pic;
@property (nonatomic, copy) NSString *task_status;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, assign) BOOL is_can_deal;

@property (nonatomic, copy) NSString *task_finish_time_type;

@property (nonatomic, copy) NSString *task_id;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) BOOL group_isclosed;
@property (nonatomic, copy) NSString *pub_uid;

//任务发布者
@property (nonatomic, strong) JGJSynBillingModel *pub_user_info;

//任务负责人
@property (nonatomic, strong) JGJSynBillingModel *principal_user_info;

@property (nonatomic, assign) CGFloat taskHeight;

@property (nonatomic, assign) BOOL isSelectedTask;

//判断cell类型改变字体。已完成和和其他类型
@property (nonatomic, assign) WaitTaskCellType waitTaskCellType;

@end

@interface JGJTaskLevelSelModel : JGJTaskCommonModel

@property (nonatomic, copy) NSString *levelName;

@property (nonatomic, copy) NSString *levelUid; //等级标记

@property (nonatomic, assign) BOOL iSLevelSel;

@end

@interface JGJTaskListModel : JGJTaskCommonModel

@property (nonatomic, strong) NSArray <JGJTaskModel *> *task_list;

@property (nonatomic, copy) NSString *un_deal_count;

@property (nonatomic, copy) NSString *complete_count; //我完成的

@property (nonatomic, copy) NSString *my_admin_count; //我管理的

@property (nonatomic, copy) NSString *my_join_count; //我参与的

@property (nonatomic, copy) NSString *my_submit_count; //我提交的 is_new_message

@property (nonatomic, copy) NSString *is_admin_msg; //我负责的新消息

@property (nonatomic, copy) NSString *is_join_msg; //我参与的新消息

@property (nonatomic, copy) NSString *from_group_name;

@property (nonatomic, copy) NSArray *filterCounts;

@property (nonatomic, copy) NSArray *aboutMeCounts;

@property (nonatomic, assign) BOOL is_new_message;
@end

