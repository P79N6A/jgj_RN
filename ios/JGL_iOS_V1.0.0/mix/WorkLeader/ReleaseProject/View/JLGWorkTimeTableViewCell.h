//
//  JLGWorkTimeTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//日期选择
#import "HZQDatePickerView.h"

@protocol JLGWorkTimeCellDelegate <NSObject>
- (void)getSelectDateType:(DateType)type;
@end

@interface JLGWorkTimeTableViewCell : UITableViewCell
@property (nonatomic, weak) id<JLGWorkTimeCellDelegate> delegate;

- (void)setStartTime:(NSUInteger )startTimeTamp endTime:(NSUInteger )endTimeTamp;
@end
