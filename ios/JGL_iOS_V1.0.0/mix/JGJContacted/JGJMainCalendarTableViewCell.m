//
//  JGJMainCalendarTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMainCalendarTableViewCell.h"
@interface JGJMainCalendarTableViewCell()
<
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarHeaderDelegate,
FSCalendarDelegateAppearance

>
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
@end
@implementation JGJMainCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpCalendar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUpCalendar{
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _holidayLunarCalendar = [NSCalendar currentCalendar];
    _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    //    _calendar.appearance.titleSelectionColor = [UIColor blackColor];
    //    _calendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _calendar.appearance.titleDefaultColor = AppFont333333Color;
    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    _calendar.appearance.selectionColor = AppFontfdf0f0Color;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
//    [self.calendar addSubview:self.backUpButton];
    [self setCalendarTheme];
}
- (void)setCalendarTheme
{
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
//    
    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
    //    _calendar.appearance.todaySelectionColor = JGJMainColor;
    //    _calendar.appearance.selectionColor = [UIColor blueColor];
    _calendar.appearance.todayColor = AppFontfafafaColor;
    _calendar.appearance.titleTodayColor =AppFontd7252cColor;
    _calendar.header.delegate = self;
    _calendar.header.needSelectedTime = YES;
    //    _calendar.header.leftAndRightShow = YES;
    
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.mainVC = YES;
    _calendar.showHeader = NO;

    //    _calendar.header.delegate = self;
    //    _calendar.header.needSelectedTime = YES;
    //    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    //    _calendar.appearance.titleSelectionColor = AppFont333333Color;
//    田家城左右显示剪头
}

@end
