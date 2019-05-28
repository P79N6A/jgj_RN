//
//  JGJQualitySafeModel.h
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JGJChatMsgListModel.h"

typedef enum : NSUInteger {
    
    JGJQualityDetailReviewResultStatusButtonType = 1, //复查结果
    
    JGJQualityDetailModifyCompleteStatusButtonType, //整改完成
    
    JGJQualityDetailHeadStatusButtonType, //点击人头像
    
} JGJQualityDetailStatusButtonType;

typedef enum : NSUInteger {
    
    QuaSafeUnDealedResultViewModifyButtonType = 1, //整改
    
    QuaSafeUnDealedResultViewUnRelationButtonType = 2, //未涉及
    
    QuaSafeUnDealedResultViewPassButtonType = 3 //通过
    
} QuaSafeUnDealedResultViewButtonType;

typedef enum : NSUInteger {
    
    QuaSafeFilterWaitModifyType, //待整改
    
    QuaSafeFilterReviewType, //待复查
    
    QuaSafeFilterCompletedType, //已完成
    
    QuaSafeFilterStaType, //统计
    
    QuaSafeFilterMyModifyType, //待我整改
    
    QuaSafeFilterMyReviewType, //待我复查
    
    QuaSafeFilterMyCommitType, //我提交的
    
} QuaSafeFilterType;

@interface JGJQualitySafeCommonModel : NSObject

@property (nonatomic, assign) JGJChatListType type;


@property (nonatomic, copy) NSString *msg_type; //质量安全类型

@property (nonatomic, copy) NSString *quaSafeCheckType; //质量安全检查类型

@end

@interface JGJQualitySafeListModel : JGJQualitySafeCommonModel

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *team_id;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, copy) NSString *msg_type_num;

@property (nonatomic, copy) NSString *bill_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *principal_uid;

//整改负责人
@property (nonatomic, copy) NSString *principal_name;

@property (nonatomic, copy) NSString *statu;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *location_text;

@property (nonatomic, copy) NSString *severity;

//严重程度文字描述
@property (nonatomic, copy) NSString *severity_text;

@property (nonatomic, copy) NSString *is_rectification;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *finish_time;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *statu_text;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *finish_time_status;

//负责人信息
@property (nonatomic, strong) JGJSynBillingModel *user_info;

//1:红灯；2:黄灯；3:绿灯
@property (nonatomic, copy) NSString *show_bell;
@end

@interface JGJQualitySafeModel : JGJQualitySafeCommonModel

@property (nonatomic, strong) NSArray <JGJQualitySafeListModel *> *list;

@property (nonatomic, copy) NSString *is_statu_rect;

@property (nonatomic, copy) NSString *is_statu_check;

@property (nonatomic, copy) NSString *rect_me;

@property (nonatomic, copy) NSString *check_me;

@property (nonatomic, copy) NSString *is_specail;

@property (nonatomic, copy) NSString *list_counts;

@property (nonatomic, copy) NSString *is_new_message;

@property (nonatomic, strong) NSArray *filterCounts;//质量安全筛选类型

//2.3.0

@property (nonatomic, copy) NSString *allnum;

@property (nonatomic, copy) NSString *quality_red;

@property (nonatomic, copy) NSString *inspect_red;

@property (nonatomic, copy) NSString *check_me_red;

@property (nonatomic, copy) NSString *rect_me_red;

//2.3.4

//我提交的
@property (nonatomic, copy) NSString *offer_me;

@property (nonatomic, strong) NSArray *aboutMeCounts;//关于我质量安全筛选类型

@end

@interface JGJQualityDetailReplayListModel : JGJQualitySafeCommonModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *reply_type;

@property (nonatomic, copy) NSString *reply_text;

@property (nonatomic, copy) NSString *reply_status;

@property (nonatomic, copy) NSString *reply_status_text;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, copy) NSString *from_group_name;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *cat_name;

@property (nonatomic, copy) NSString *week_day;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, copy) NSString *reply_id;

@property (nonatomic, copy) NSString *reply_mode;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, strong) NSArray *reply_msg_src;

@property (nonatomic, strong) JGJSynBillingModel *user_info; //用户信息

//质量安全详情回复高度
@property (nonatomic, assign) CGFloat cellHeight;

//任务高度详情有图片回复高度
@property (nonatomic, assign) CGFloat taskHeight;

//用户id
@property (nonatomic, copy) NSString *uid;

//2.3.4 系统回复消息

@property (nonatomic, assign) BOOL is_system_reply;

//是否能删除
@property (nonatomic, assign) BOOL operate_delete;

@end

@interface JGJQualityDetailModel : JGJQualitySafeCommonModel

@property (nonatomic, copy) NSString *bill_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *statu;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, copy) NSString *location_id;

@property (nonatomic, copy) NSString *severity;

@property (nonatomic, copy) NSString *severityDes;

@property (nonatomic, copy) NSString *severity_text; //严重程度文字描述

@property (nonatomic, strong) NSString *is_rectification;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *finish_time;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *principal_name;

@property (nonatomic, strong) NSArray *reply_list;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) JGJQualityDetailStatusButtonType statusButtonType;

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *is_creater;

@property (nonatomic, copy) NSString *is_admin;

@property (nonatomic, assign) BOOL isAuthorModify; //是否有权限修改

//单张图片宽高
@property (nonatomic, assign) CGFloat imageW;

@property (nonatomic, assign) CGFloat imageH;

@property (nonatomic, assign) CGFloat imageSize;

//单张图片
@property (nonatomic, strong) UIImageView *singleImageView;

@property (nonatomic, copy) NSString *from_group_name;

@property (nonatomic, copy) NSString *finish_time_status;

//1:红灯；2:黄灯；3:绿灯
@property (nonatomic, copy) NSString *show_bell;

//2.3.7添加 整改措施

@property (nonatomic, copy) NSString *msg_steps;
@end

@interface JGJQualityLocationModel : JGJQualitySafeCommonModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *create_time;

@end

//2.3.0发布检查计划模型

@interface JGJQuaSafePubCheckInfoModel : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *uid; //创建者

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *type;//类型

@property (nonatomic, copy) NSString *text;//名称

@property (nonatomic, copy) NSString *insp_id; //检查项Id

@property (nonatomic, copy) NSString *child_num;


@end

@interface JGJQuaSafeCheckPlanModel : NSObject

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, copy) NSString *inspect_name;

@property (nonatomic, copy) NSString *child_inspect_name;

@property (nonatomic, copy) NSString *uncheck;

@property (nonatomic, copy) NSString *change_color;

//是否有权限删除
@property (nonatomic, copy) NSString *is_privilege;

@property (nonatomic, copy) NSString *pu_inpsid;

@end

@interface JGJQuaSafeCheckListModel : JGJQualitySafeCommonModel

@property (nonatomic, copy) NSString *pu_inpsid;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *inspect_name;

@property (nonatomic, copy) NSString *finish;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *child_inspect_name;

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *pass;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, copy) NSString *statu;

@property (nonatomic, strong) JGJSynBillingModel *user_info;

@property (nonatomic, strong) JGJSynBillingModel *send_user_info;

@end

@interface JGJQuaSafeCheckModel : NSObject

@property (nonatomic, strong) NSArray <JGJQualitySafeListModel *> *list;

@property (nonatomic, copy) NSString *check; //待检查数量

@property (nonatomic, copy) NSString *check_me; //待我检查数量

@property (nonatomic, strong) NSArray *checkFilterCounts;//检查筛选类型

@property (nonatomic, copy) NSString *allnum;

@property (nonatomic, copy) NSString *quality_red;

@property (nonatomic, copy) NSString *inspect_red;

@property (nonatomic, copy) NSString *check_me_red;
@end



@interface JGJQuaSafeCheckRecordReplyModel : NSObject

@property (nonatomic, copy) NSString *replyId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, copy) NSString *quality_id;

@property (nonatomic, copy) NSString *statu;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *statu_name;

@end

@interface JGJQuaSafeCheckRecordListModel : NSObject

@property (nonatomic, copy) NSString *inspect_name;

@property (nonatomic, copy) NSString *parent_id;

//uid发布者
@property (nonatomic, copy) NSString *uid;

//执行人uid
@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, strong) NSArray <JGJQuaSafeCheckRecordReplyModel *> *reply_list;

//展开高度
@property (nonatomic, assign) CGFloat cellHeight;

//收缩高度
@property (nonatomic, assign) CGFloat shrinkHeight;

//是否展开
@property (nonatomic, assign) BOOL isExPand;

@property (nonatomic, assign) QuaSafeUnDealedResultViewButtonType buttonType;

@property (nonatomic, assign) BOOL isShowContainBottomBtnView;

//发布检查计划id
@property (nonatomic, copy) NSString *pu_inpsid;

@end

@interface JGJQuaSafeCheckRecordModel : NSObject

@property (nonatomic, copy) NSString *inspect_name;

@property (nonatomic, strong) NSArray <JGJQuaSafeCheckRecordListModel *> *list;

@end


