//
//  GYZCustomCalendarPickerView.h
//  GYZCalendarPicker
//
//  Created by GYZ on 16/6/22.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDJChineseCalendar.h"
#import "IDJCalendarUtil.h"
#import "GYZCommon.h"

#define YEAR_START 2012//滚轮显示的起始年份
#define YEAR_END 2020//滚轮显示的结束年份


//日历显示的类型
typedef NS_ENUM(NSUInteger, CalendarType) {
    GregorianCalendar=1,//公历、阳历
    ChineseCalendar  //农历、阴历
};

@protocol GYZCustomCalendarPickerViewDelegate;

@interface GYZCustomCalendarPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource> 

@property (nonatomic) CalendarType calendarType;
//@property (nonatomic, strong)  IDJCalendar *cal;//日期类
@property (nonatomic, assign) id<GYZCustomCalendarPickerViewDelegate> delegate;

- (instancetype)initWithCalendarTitle:(NSString *)calendarTitle IDJCalendar:(IDJCalendar *)calendar;
-(void)show;

- (void)_setYears;//设置总年
- (void)_setMonthsInYear:(NSUInteger)_year;//设置总月份
- (void)_setDaysInMonth:(NSString *)_month year:(NSUInteger)_year;//设置总天数
@end

@protocol GYZCustomCalendarPickerViewDelegate <NSObject>
//通知使用这个控件的类，用户选取的日期
- (void)notifyNewCalendar:(IDJCalendar *)cal;
@end