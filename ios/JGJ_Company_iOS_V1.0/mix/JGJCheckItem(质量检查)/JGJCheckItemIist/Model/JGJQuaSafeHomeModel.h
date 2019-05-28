//
//  JGJQuaSafeHomeModel.h
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JGJQuaSafeCheckSelCheckItemType, //检查项
    JGJQuaSafeCheckSelAllCheckPlanType, //所有计划
    JGJQuaSafeCheckSelCompletedPlanType, //已完成
    JGJQuaSafeCheckSelWaitMeExecuteType, //待我执行
    JGJQuaSafeCheckSelMyCreatType //我创建的
} JGJQuaSafeCheckSelType;

typedef enum : NSUInteger {
    
    JGJCheckModifyResultViewModifyButtontype = 1, //待整改
    
    JGJCheckModifyResultViewUnCheckButtontype,//不用检查
    
    JGJCheckModifyResultViewPassButtontype, //通过
    
} JGJCheckModifyResultViewButtontype;

@interface JGJQuaSafeHomeModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

//未读消息
@property (nonatomic, copy) NSString *unReadMsgCount;
@end


@interface JGJInspectHomeModel : NSObject

@property (nonatomic, copy) NSString *inspect_pro;  //检查项

@property (nonatomic, copy) NSString *inspect_all; //所有列表

@property (nonatomic, copy) NSString *inspect_finish; //已完成

@property (nonatomic, copy) NSString *inspect_my_oper; //待我操作

@property (nonatomic, copy) NSString *inspect_my_creater; //我创建的

@property (nonatomic, copy) NSString *inspect_my_oper_red; //待我操作，标红

@property (nonatomic, strong) NSArray *topTitles;//顶部标题类型 检查项、所有计划、已完成

@property (nonatomic, strong) NSArray *aboutMeTitles;//关于我的类型、待我执行、我创建的
@end


@interface JGJInspectListModel : NSObject

@property (nonatomic, copy) NSString *plan_id ; //计划id

@property (nonatomic, copy) NSString *plan_name ; //计划名称

@property (nonatomic, copy) NSString *group_id; //组id

@property (nonatomic, copy) NSString *class_type; //组类型

@property (nonatomic, copy) NSString *msg_type; //类型

@property (nonatomic, copy) NSString *execute_time; //执行时间

@property (nonatomic, copy) NSString *create_time; //创建时间

@property (nonatomic, copy) NSString *uid;//创建者

@property (nonatomic, copy) NSString *oper_type;//用户创建

@property (nonatomic, copy) NSString *pro_num; //检查项数

@property (nonatomic, copy) NSString *execute_name; //执行人

@property (nonatomic, copy) NSString *pass_percent;  //完成率

@property (nonatomic, copy) NSString *execute_percent;  // 执行率

@property (nonatomic, copy) NSString *is_operate;  // 操作权限

@end

@interface JGJInspectListDetailCheckItemModel : NSObject

@property (nonatomic, copy) NSString *pro_id; //检查项id

@property (nonatomic, copy) NSString *pro_name; //检查项名

@property (nonatomic, copy) NSString *status;  //状态

@property (nonatomic, copy) NSString *uid;   //操作人

@property (nonatomic, copy) NSString *update_time;  //操作时间

@property (nonatomic, copy) NSString *telephone;  //手机号

@property (nonatomic, copy) NSString *real_name;  //姓名

@property (nonatomic, copy) NSString *plan_id;  //检查计划id

@end

@interface JGJInspectListDetailModel : JGJInspectListModel

@property (nonatomic, strong) NSArray <JGJInspectListDetailCheckItemModel *> *pro_list;

@property (nonatomic, strong) NSArray <JGJSynBillingModel *> *member_list;

@end

#pragma mark - 检查内容分项回复信息
@interface JGJInspectPlanProInfoDotReplyModel : NSObject

@property (nonatomic, copy) NSString *plan_id; //检查计划id

@property (nonatomic, copy) NSString *pro_id; //检查项目id

@property (nonatomic, copy) NSString *content_id; //执行用户

@property (nonatomic, copy) NSString *dot_id; //检查内容分项id

@property (nonatomic, copy) NSString *uid; //执行用户

@property (nonatomic, copy) NSString *status; //回复状态  //0：未检查 1：待整改 2：不用检查 3：完成

@property (nonatomic, copy) NSString *comment; //回复内容

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *msg_type; //消息类型

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, strong) JGJSynBillingModel *user_info;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, copy) NSString *is_operate; //操作权限

@end

#pragma mark - 检查项目内容列表
@interface JGJInspectPlanProInfoDotListModel : NSObject

@property (nonatomic, copy) NSString *dot_id;

//检查点
@property (nonatomic, copy) NSString *dot_name;

//检查内容
@property (nonatomic, copy) NSString *content_name;

//检查内容id
@property (nonatomic, copy) NSString *content_id;

@property (nonatomic, strong) NSArray <JGJInspectPlanProInfoDotReplyModel *> *dot_status_list;

//展开高度
@property (nonatomic, assign) CGFloat cellHeight;

//收缩高度
@property (nonatomic, assign) CGFloat shrinkHeight;

//是否展开
@property (nonatomic, assign) BOOL isExPand;

@property (nonatomic, assign) QuaSafeUnDealedResultViewButtonType buttonType;

//是否展开第二级
//@property (nonatomic, assign) BOOL isExpand;

//状态
@property (nonatomic, copy) NSString *status;

//是否有权限操作，没有权限操作
@property (nonatomic, copy) NSString *is_operate;
@end

#pragma mark - 检查点列表
@interface JGJInspectPlanProInfoContentListModel : NSObject

@property (nonatomic, copy) NSString *content_id;

@property (nonatomic, copy) NSString *content_name;

@property (nonatomic, strong) NSArray <JGJInspectPlanProInfoDotListModel *> *dot_list;

@property (nonatomic, copy) NSString *status;

//是否展开第一级
@property (nonatomic, assign) BOOL isExpand;

@end


#pragma mark - 检查项
@interface JGJInspectPlanProInfoModel : NSObject

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *location_text;

@property (nonatomic, copy) NSString *oper_type;

@property (nonatomic, copy) NSString *oper_uid;

@property (nonatomic, copy) NSString *pro_id;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, strong) NSArray <JGJInspectPlanProInfoContentListModel *> *content_list;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *plan_name;

@property (nonatomic, copy) NSString *plan_id;

//检查人信息
@property (nonatomic, strong) JGJSynBillingModel *user_info;
@end

#pragma mark - 检查项

@class JGJInspectPlanRecordPathReplyModel;

@interface JGJInspectPlanRecordPathModel : NSObject

@property (nonatomic, copy) NSString *plan_name;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *pro_id;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *content_name;

@property (nonatomic, copy) NSString *dot_name;

@property (nonatomic, strong) NSArray <JGJInspectPlanRecordPathReplyModel *> *log_list;

@end

#pragma mark - 检查项
@interface JGJInspectPlanRecordPathReplyModel : JGJInspectPlanProInfoDotReplyModel

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat contentHeight;

//检查记录展开
@property (nonatomic, assign) BOOL isExpand;

@end


