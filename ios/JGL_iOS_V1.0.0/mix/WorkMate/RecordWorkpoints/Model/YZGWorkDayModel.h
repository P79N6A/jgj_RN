//
//  YZGWorkDayModel.h
//  mix
//
//  Created by Tony on 16/2/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class WorkDayDtn_desc;
@interface YZGWorkDayModel : TYModel

@property (nonatomic, assign) CGFloat y_total;

@property (nonatomic, assign) CGFloat m_total;

@property (nonatomic, copy) NSArray *abnormal;

@property (nonatomic, copy) NSArray *normal;

@property (nonatomic, assign) BOOL recorded;

@property (nonatomic, strong) WorkDayDtn_desc *btn_dest;

@property (nonatomic, assign) NSInteger todaybill_count;

@property (nonatomic, assign) NSInteger yestodaybill_count;

//添加工人的今日收入
@property (nonatomic, assign) CGFloat d_total;
@property (nonatomic, copy) NSString *showDate;//年月日星期
@property (nonatomic, copy) NSString *endDate;//当月结束时间
@property (nonatomic, assign) SelectedWorkType selectType; //添加工人、班组长/工头；类型


@property (nonatomic, assign) CGFloat total_workday;

@property (nonatomic, assign) CGFloat total_amounts;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) BOOL isUnReaded;//当前新消息是否已读

@property (nonatomic, copy) NSString *todayRecordStr; //今日是否已记

//2.1.0未读数添加
@property (nonatomic, copy) NSString *unread_msg_count; //工作消息未读数

//2.2.0
@property (nonatomic, copy) NSString *total_overtime; //工人加班时长
@end

@interface WorkDayDtn_desc : TYModel

@property (nonatomic, assign) CGFloat amount;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL self_lable;

@property (nonatomic,assign) NSInteger accounts_type;

@end
