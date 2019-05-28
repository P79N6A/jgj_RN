//
//  JGJDateLogPickerview.h
//  JGJCompany
//
//  Created by Tony on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,datePickerModelType)
{
year_month_week_dayModel,
hour_minitmodel,
year_month_week_day_hourmodel,
year_model,
year_monthmodel,

};
typedef void(^selectTime)(NSDate *date);
@protocol selectDatePickerTimeDatedelegate <NSObject>

- (void)JLGDataPickerSelect:(NSDate *)date;

@end
@interface JGJDateLogPickerview : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *datePickerview;
//@property (strong, nonatomic)  UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic)  NSDate *currentDate;
@property (strong, nonatomic)  id <selectDatePickerTimeDatedelegate> delegate;
@property (copy, nonatomic)  selectTime selectTimeBlock;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

@property (strong, nonatomic) IBOutlet UIView *topview;
+(void)showDatePickerAndSelfview:(UIView *)view anddatePickertype:(datePickerModelType)datetype andblock:(selectTime)date;

@end
