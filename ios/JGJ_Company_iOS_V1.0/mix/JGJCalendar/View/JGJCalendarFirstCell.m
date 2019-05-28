//
//  JGJCalendarFirstCell.m
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarFirstCell.h"
#import "UIButton+JGJUIButton.h"
@interface JGJCalendarFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *showDateLable;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLable;
@property (weak, nonatomic) IBOutlet UILabel *lunarLable;
@property (weak, nonatomic) IBOutlet UIView *containFestivalView;
@property (weak, nonatomic) IBOutlet UILabel *festivalLable;
@property (weak, nonatomic) IBOutlet UIButton *returnTodayButton;
@end
@implementation JGJCalendarFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.returnTodayButton.layer setLayerBorderWithColor:AppFontdab270Color width:1 radius:3.0];
    [self.returnTodayButton setEnlargeEdgeWithTop:20.0 right:20.0 bottom:20.0 left:20.0];
}

- (void)setCalendarModel:(JGJCalendarModel *)calendarModel {
    _calendarModel = calendarModel;
    self.showDateLable.text = [NSString stringWithFormat:@"公元%@年%@月", calendarModel.year,calendarModel.month];
    self.lunarLable.text = [NSString stringWithFormat:@"农历  %@", calendarModel.zh_calendarDate];
    self.festivalLable.text = calendarModel.jieqi;
    self.dayLable.text = calendarModel.day;
    self.weekDayLable.text = calendarModel.weekday;
    self.containFestivalView.hidden = !(calendarModel.jieqi != nil && calendarModel.jieqi.length > 0);
    self.returnTodayButton.hidden = calendarModel.timeinterval == 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
