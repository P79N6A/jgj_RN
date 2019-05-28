//
//  YZGDatePickerView.h
//  mix
//
//  Created by Tony on 16/3/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZGDatePickerViewDelegate <NSObject>
@optional
- (void)YZGDataPickerSelect:(NSDate *)date;
- (void)YZGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath;
@end

@interface YZGDatePickerView : UIView
@property (weak, nonatomic) id<YZGDatePickerViewDelegate> delegate;
@property (assign, nonatomic) BOOL defultTime;//默认选择时间

- (void)showDatePicker;
- (void)hiddenDatePicker;
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath;

- (void)setSelectedDate:(NSDate *)selectedDate;
/**
 *  设置最大日期和最小日期,传入时间的格式需要为@"yyyy-MM-dd"
 *  默认最大的时间是当前时间，最小时间是2014-01-01
 */
- (void)setDatePickerMinDate:(NSString *)minDateString maxDate:(NSString *)maxDateString;
/*
 *选择的日期
 */
@property (strong ,nonatomic)NSDate *date;


@property (weak, nonatomic,readonly) IBOutlet UILabel *title;
@end
