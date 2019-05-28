//
//  JGJCalendarCheckCategoryView.h
//  mix
//
//  Created by yj on 16/6/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJCalendarModel;
typedef void(^BlockCalendar)(JGJCalendarModel *);
@interface JGJCalendarCheckCategoryView : UIView
+ (instancetype) calendarCheckWithCalendarModel:(JGJCalendarModel *)calendarModel;
@property (nonatomic, copy) BlockCalendar blockCalendar;
- (void)showPickView;
@end
