//
//  JGJNewSelectedDataPickerView.h
//  mix
//
//  Created by Tony on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoiceTheData)(NSArray *dataArray,NSString *timeStr);

@protocol JGJNewSelectedDataPickerViewDelegate <NSObject>

@optional
- (void)JGJNewSelectedDataPickerViewSelectedDate:(NSDate *)date;
- (void)JGJNewSelectedDataPickerViewClickMoreDayBtn;
@end
@interface JGJNewSelectedDataPickerView : UIView

@property (nonatomic, weak) id <JGJNewSelectedDataPickerViewDelegate> pickerDelegate;
@property (nonatomic, copy) ChoiceTheData choiceData;

@property (nonatomic, copy) NSString *selectedTimeStr;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) BOOL isNeedShowToday;
@property (nonatomic, assign) BOOL isNeddShowMoreDayChoiceBtn;
@property (nonatomic, assign) BOOL isNeedLimitTimeChoice;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, copy) NSString *start_time;// 代班开始时间
@property (nonatomic, copy) NSString *end_Time;// 代班结束时间

@property (nonatomic, assign) NSInteger timeAfterYear;// 今天之后多少年  用于记事本 可以选择今年之后两年的时间

- (void)show;
- (void)hiddenPicker;
@end
