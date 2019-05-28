//
//  JGJTaskRequestModel.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJTaskRequestCommonModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface JGJTaskRequestModel : JGJTaskRequestCommonModel

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *task_type;

@property (nonatomic, copy) NSString *task_status;

@property (nonatomic, copy) NSString *refer_id;

@property (nonatomic, copy) NSString *page_operate;

@end

@interface JGJTaskPublishRequestModel : JGJTaskRequestCommonModel

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *task_content;

//任务负责人uid
@property (nonatomic, copy) NSString *principal_uid;

//任务参与者uids,格式:11,22,33

@property (nonatomic, copy) NSString *priticipant_uids;

@property (nonatomic, copy) NSString *task_finish_time;

//任务级别(1:一般；2：紧急；3：非常紧急)
@property (nonatomic, copy) NSString *task_level;

@end

