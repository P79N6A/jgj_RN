//
//  JGJRecordWorkRequestModel.h
//  mix
//
//  Created by yj on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJRecordWorkRequestModel : NSObject

@end

//记工统计
@interface JGJRecordWorkStaRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

//    个人person(默认),项目project
@property (nonatomic, copy) NSString *class_type;

//如果是项目端，值表示项目id,如果是个人端，值表示人的uid
@property (nonatomic, copy) NSString *class_type_id;

@property (nonatomic, copy) NSString *class_type_target_id; //如果是class_type_id项目端，值表示人的id,如果是class_type_id是人的id，标识class_type_target_id项目id

//按天、按月统计
@property (nonatomic, copy) NSString *is_day;

//代理人uid自己
@property (nonatomic, copy) NSString *agency_uid;

//班组id
@property (nonatomic, copy) NSString *group_id;

//类型
@property (nonatomic, copy) NSString *accounts_type;

@end


//记工流水

@interface JGJRecordWorkPointRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *date;

//如1,2,3 类型 1：点工2：包工3：借支4：结算5：包工考勤
@property (nonatomic, copy) NSString *accounts_type;

//是否备注
@property (nonatomic, copy) NSString *is_note;

//代理班组流水传班组id
@property (nonatomic, copy) NSString *group_id;

//是否有代理班组长
@property (nonatomic, copy) NSString *is_agency;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, assign) NSInteger pg;

//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

//是否是同步带过来的数据
@property (nonatomic, copy) NSString *is_sync;

@end


@interface JGJSetBatchSalaryTplRequestModel : NSObject

@property (nonatomic, copy) NSString *record_id;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *accounts_type;

- (void)requstSetBatchSalaryTplSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end

@interface JGJSetWorkdayTplRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *salary_tpl;

@property (nonatomic, copy) NSString *work_hour_tpl;

@property (nonatomic, copy) NSString *overtime_hour_tpl;

@property (nonatomic, copy) NSString *accounts_type;

@property (nonatomic, copy) NSString *params;

- (void)requstSetWorkdayTplSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end

