//
//  JGJChatRecruitMsgModel.h
//  mix
//
//  Created by yj on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJChatShareLinkModel : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *describe;

@end

@interface JGJChatCooperateTypeModel : NSObject

@property (nonatomic, copy) NSString * _Nullable type_name;

@property (nonatomic, assign) NSInteger type_id;

@end

@interface JGJChatRecruitClassesModel : NSObject

@property (nonatomic, copy) NSString *total_scale;//总规模

@property (nonatomic, copy) NSString *balance_way;

//开始时间
@property (nonatomic, copy) NSString *work_begin;

@property (nonatomic, copy) NSString *contractor;

//金额的最小范围
@property (nonatomic, copy) NSString *money;

//金额的最大范围
@property (nonatomic, copy) NSString *max_money;

@property (nonatomic, copy) NSString *unitMoney;

//@property (nonatomic, strong) Worklevel *worklevel;

@property (nonatomic, strong) JGJChatCooperateTypeModel *cooperate_type;

//@property (nonatomic, strong) Worktype *worktype;

@property (nonatomic,copy) NSString *person_count;

@end



NS_ASSUME_NONNULL_BEGIN

@interface JGJChatRecruitUserInfoModel : NSObject

//工种类型
@property (nonatomic, strong) NSArray *work_type;

@end

//招工、名片模型
@interface JGJChatRecruitMsgModel : NSObject

//名片信息

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *group_name; //名字

@property (nonatomic, copy) NSString *nation;// 民族

@property (nonatomic, copy) NSString *nationality;// 民族

@property (nonatomic, copy) NSString *work_year;//年龄

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *scale; //规模

@property (nonatomic, copy) NSString *verified;// 是否实名 3->已实名 其他->未实名

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, assign) NSInteger group_verified; //group_verified、person_verified其中任意一个认证都是认证。(Bool发送给服务器是json true/false，改正NSInteger)

@property (nonatomic, assign) NSInteger person_verified;

@property (nonatomic, assign) NSInteger is_chat;//能否聊天

@property (nonatomic, strong) JGJChatRecruitUserInfoModel *worker_info;

@property (nonatomic, strong) JGJChatRecruitUserInfoModel *foreman_info;

@property (nonatomic, copy) NSString *click_type;//1、名片 2、工作

//招工信息
@property (nonatomic, strong) JGJChatRecruitClassesModel *classes;

@property (nonatomic, copy) NSString *pro_title; //规模

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *role_type;//角色

//是否完成了名片信息
@property (nonatomic, copy) NSString *is_info;

@end

NS_ASSUME_NONNULL_END
