//
//  JLGDatePickerView.h
//  mix
//
//  Created by Tony on 16/1/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JLGDatePickerViewDelegate <NSObject>
@optional
- (void)JLGDataPickerSelect:(NSDate *)date;
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath;
@end

@interface JLGDatePickerView : UIView
@property (weak, nonatomic) id<JLGDatePickerViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

/**
 *  设置最大日期和最小日期,传入时间的格式需要为@"yyyy-MM-dd"
 *
 */
- (void)setDatePickerMinDate:(NSString *)minDateString maxDate:(NSString *)maxDateString;

/**
 *  设置顶部标题
 *
 *  @param titleLabelText 标题
 */
- (void)setTitleLabelText:(NSString *)titleLabelText;
- (void)showDatePicker;
- (void)hiddenDatePicker;
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath;

@end
