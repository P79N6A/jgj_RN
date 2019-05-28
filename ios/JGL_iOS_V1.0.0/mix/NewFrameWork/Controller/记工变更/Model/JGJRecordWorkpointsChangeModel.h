//
//  JGJRecordWorkpointsChangeModel.h
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JGJUser_infoChangeModel : NSObject

@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *uid;

@end

@interface JGJRecord_infoChangeModel : NSObject

@property (nonatomic, copy) NSString *accounts_type;
@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *fuid;
@property (nonatomic, copy) NSString *overtime;// 加班工时
@property (nonatomic, copy) NSString *overtime_hours;// 加班工天
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *proname;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *tpl;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *manhour;//上班工时
@property (nonatomic, copy) NSString *working_hours;// 上班工天
@property (nonatomic, copy) NSString *wuid;
@property (nonatomic, copy) NSString *worker_name;// 工人名字
@property (nonatomic, copy) NSString *foreman_name;// 班组长名字
@end

@interface JGJAdd_infoChangeModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *nl_date;
@property (nonatomic, copy) NSString *num;

@end

@class JGJUser_infoChangeModel;
@class JGJRecord_infoChangeModel;
@class JGJAdd_infoChangeModel;

@interface JGJRecordWorkpointsChangeModel : NSObject

@property (nonatomic, copy) NSArray<JGJAdd_infoChangeModel *> *add_info;
@property (nonatomic, copy) NSString *last_operate_msg;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *nl_date;
@property (nonatomic, copy) NSString *record_id;
@property (nonatomic, strong) JGJRecord_infoChangeModel *record_info;
@property (nonatomic, copy) NSString *record_time;
@property (nonatomic, copy) NSString *record_type;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) JGJUser_infoChangeModel *user_info;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isMySelfOprationRecord;// 区分是否是自己的操作记录


@property (nonatomic, copy) NSString *typeTitle;// 类型标题

@end
