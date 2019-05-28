//
//  JGJQuaSafeInspectRequset.h
//  JGJCompany
//
//  Created by yj on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGJPageSize 20

@interface JGJQuaSafeInspectCommonRequset : NSObject

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@end

@interface JGJQuaSafeInspectListRequset : JGJQuaSafeInspectCommonRequset

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, copy) NSString *status; //表示已完成 status:3

@property (nonatomic, copy) NSString *my_creater; //我创建标识 为 1 ；

@property (nonatomic, copy) NSString *my_oper; //待我执行标识 为 1 ；

@end

@interface JGJQuaSafeRectNotifyRequset : JGJQuaSafeInspectCommonRequset

@property (nonatomic, copy) NSString *pro_id; //检查项id

@property (nonatomic, copy) NSString *plan_id; //检查计划id

@property (nonatomic, copy) NSString *content_id; //检查内容id

@property (nonatomic, copy) NSString *dot_id; //  检查点id

@property (nonatomic, copy) NSString *msg_type; //类型 quality,safe,task

@property (nonatomic, copy) NSString *text; //    内容

@property (nonatomic, copy) NSString *location_text; //      隐患文字

@property (nonatomic, copy) NSString *severity; //    隐含程度

@property (nonatomic, copy) NSString *principal_uid; //   整改人

@property (nonatomic, copy) NSString *finish_time; //    内容

@property (nonatomic, copy) NSString *status; //    status,传值2or3

@property (nonatomic, copy) NSString *comment; //    回复
@end
