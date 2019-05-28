//
//  JGJFSCalendarTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFSCalendarTableViewCell.h"

@implementation JGJFSCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCalender];
}
-(void)setCalender{
    
    _DayCalendar.delegate   = self;
    _DayCalendar.dataSource = self;
    _DayCalendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _DayCalendar.allowsMultipleSelection = YES;
    _DayCalendar.appearance.borderSelectionColor = JGJMainColor;
    _DayCalendar.appearance.cellShape = FSCalendarCellShapeRectangle;//取消圆角显示
    _DayCalendar.appearance.titleSelectionColor = [UIColor blackColor];
    _DayCalendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _DayCalendar.appearance.titleTodayColor = [UIColor blackColor];
    _DayCalendar.appearance.subtitleTodayColor = [UIColor blackColor];
    _DayCalendar.selectShow = YES;
    _DayCalendar.header.delegate = self;
    _DayCalendar.header.needSelectedTime = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    
    
}
@end
