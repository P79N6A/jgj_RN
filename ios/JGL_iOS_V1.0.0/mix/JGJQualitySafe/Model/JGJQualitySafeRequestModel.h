//
//  JGJQualitySafeRequestModel.h
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJQualitySafeRequestCommonModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface JGJQualitySafeRequestModel : JGJQualitySafeRequestCommonModel

//当前类型
@property (nonatomic, copy) NSString *chatListType;

//发送的文字
@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, strong) NSArray *imgsAddressArr;

//是否整改（1：整改；0：不需要），如果是msg_type为quality，safe时
@property (nonatomic, strong) NSString *is_rectification;

//严重程度（1：一般,2:严重），如果是msg_type为quality，safe时

@property (nonatomic, strong) NSString *severity;

//location	否	string	位置，如果是msg_type为quality，safe时

@property (nonatomic, strong) NSString *location;

//principal_uid	否	int	负责人（与字段is_rectification连用）（v2.2.3）
@property (nonatomic, strong) NSString *principal_uid;

//finish_time	是	int	完成时间（如果：20160909）
@property (nonatomic, strong) NSString *finish_time;

//statu	否	int	1:待整改；2：待复查；3：已完结，如果是msg_type为quality，safe时
@property (nonatomic, strong) NSString *statu;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, strong) NSString *msg_type;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, strong) NSString *location_id;

@property (nonatomic, strong) NSArray *pic_w_h;

//2.3.0

//检查项id
@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, copy) NSString *pu_inpsid;

//2.3.7

//整改措施
@property (nonatomic, copy) NSString *msg_step;

//local_id
@property (nonatomic, copy) NSString *local_id;

@end

@interface JGJQualitySafeListRequestModel : JGJQualitySafeRequestCommonModel

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *is_special;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *severity;

@property (nonatomic, copy) NSString *send_stime;

@property (nonatomic, copy) NSString *send_etime;

@property (nonatomic, copy) NSString *modify_stime;

@property (nonatomic, copy) NSString *modify_etime;

@property (nonatomic, copy) NSString *send_uid;

@property (nonatomic, copy) NSString *in_time;

@property (nonatomic, copy) NSString *principal_uid;

//2.3.4我提交的标识
@property (nonatomic, copy) NSString *question_status;

//2.3.4我提交的标识
@property (nonatomic, copy) NSString *is_my_offer;

//3.3.2添加用于保存信息
@property (nonatomic, strong) NSString *principal_name;

@property (nonatomic, copy) NSString *question_name;

@property (nonatomic, copy) NSString *severity_name;

@property (nonatomic, copy) NSString *status_name;

//提交人
@property (nonatomic, copy) NSString *send_name;

@end

@interface JGJQualityReplyRequestModel : JGJQualitySafeRequestCommonModel

@property (nonatomic, copy) NSString *ctrl;

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *reply_type;

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *reply_text;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *client_type;

@property (nonatomic, strong) NSArray *msg_src;

@property (nonatomic, copy) NSString *bill_id;

@property (nonatomic, copy) NSString *statu;

@property (nonatomic, copy) NSString *is_rect;

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *finish_time;

@property (nonatomic, copy) NSString *msg_type;

//回复人的uid
@property (nonatomic, copy) NSString *reply_uid;

//2.3.7添加 整改措施

@property (nonatomic, copy) NSString *msg_steps;

//日志详情回复id
@property (nonatomic, copy) NSString *id;

@end

//2.3.0 发布、修改检查项目计划


@interface JGJPubCheckPlanRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *principal_uid;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

//检查项Id，默认以‘，’隔开
@property (nonatomic, copy) NSString *insp_id;

//pu_inpsid、text暂时不用
//检查项目计划id
@property (nonatomic, copy) NSString *pu_inpsid;

//描述
@property (nonatomic, copy) NSString *text;

@end

//检查记录
@interface JGJQuaSafeCheckRecordRequestModel : NSObject

@property (nonatomic, copy) NSString *insp_id;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSString *text;

//2.3.0
@property (nonatomic, copy) NSString *reply_id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *principal_uid;

//发布项目计划的id
@property (nonatomic, copy) NSString *pu_inpsid; 

@end

