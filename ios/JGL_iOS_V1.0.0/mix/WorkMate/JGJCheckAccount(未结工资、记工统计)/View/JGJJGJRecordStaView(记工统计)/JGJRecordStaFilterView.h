//
//  JGJRecordStaFilterView.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StartTime @"选择开始日期"

#define EndTime @"选择结束日期"

@class JGJRecordStaFilterView;

typedef void(^JGJRecordStaFilterViewBlock)(NSString *stTime, NSString *endTime, BOOL isReset);

typedef void(^JGJRecordStaFilterButtonBlock)(JGJRecordStaFilterView *filterView);

//查看统计时间段
typedef void(^JGJRecordStaTimeButtonBlock)(JGJRecordStaFilterView *filterView);

//筛选内容
typedef void(^JGJRecordStaFilterAccountypesBlock)(JGJRecordWorkStaModel *recordWorkStaModel, CGFloat height);

@interface JGJRecordStaFilterView : UIView

@property (copy, nonatomic) JGJRecordStaFilterViewBlock recordStaFilterViewBlock;

//搜索按钮按下
@property (copy, nonatomic) JGJRecordStaFilterButtonBlock staFilterButtonBlock;

//查看统计时间段
@property (copy, nonatomic) JGJRecordStaTimeButtonBlock staTimeBlock;

//开始时间
@property (copy, nonatomic) NSString *startTimeStr;

//结束时间
@property (copy, nonatomic) NSString *endTimeStr;

//农历开始时间
@property (copy, nonatomic, readonly) NSString *lunarStTime;

//农历结束时间
@property (copy, nonatomic, readonly) NSString *lunarEnTime;

//是否隐藏查看时间段统计按钮
@property (assign, nonatomic) BOOL is_hidden_checkStaBtn;

//是否隐藏搜索查看按钮
@property (assign, nonatomic) BOOL is_hidden_searchBtn;

@property (weak, nonatomic,readonly) IBOutlet UIButton *filterButton;

//是否能点击
@property (assign ,nonatomic) BOOL is_unCan_click;

//设置筛选数据
- (void)setFilterRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel staFilterAccountypesBlock:(JGJRecordStaFilterAccountypesBlock)staFilterAccountypesBlock;

-(CGFloat)staFilterViewHeight;

@end
