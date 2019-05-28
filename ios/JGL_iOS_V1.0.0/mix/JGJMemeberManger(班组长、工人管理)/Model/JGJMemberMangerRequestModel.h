//
//  JGJMemberMangerRequestModel.h
//  mix
//
//  Created by yj on 2018/4/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJMemberMangerRequestBaseModel : NSObject

@end

@interface JGJMemberMangerAppraiseRequestModel : NSObject

/** 被评价人uid */
@property (nonatomic, copy) NSString *uid;

/** 标签名称，多个逗号分隔 */
@property (nonatomic, copy) NSString *tag_names;

/** 评价内容，最多200字 */
@property (nonatomic, copy) NSString *evaluate_content;

/** 工作态度或没有拖欠工资星星（当前用户是工头，则为工作态度）*/
@property (nonatomic, copy) NSString *attitude_or_arrears;

/** 专业技能或者辱骂工人星星（当前用户是工头，则为专业技能） */
@property (nonatomic, copy) NSString *professional_or_abuse;

/** 靠谱程度星星 */
@property (nonatomic, copy) NSString *reliance_degree;

/** 是否愿意再次合作，1愿意，0不愿意，默认0 */
@property (nonatomic, copy) NSString *is_cooperate_again;

@end

@interface JGJMemberEvaListRequestModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@end


@interface JGJAddUserRequest : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *telph;

@property (nonatomic, copy) NSString *group_id; //班组id

//包工承包传contractor_type = 1，承包添加人后不会马上加入常用人员列表
@property (nonatomic, copy) NSString *contractor_type;

@end
