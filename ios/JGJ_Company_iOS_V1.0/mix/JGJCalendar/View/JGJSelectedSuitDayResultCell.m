//
//  JGJSelectedSuitDayResultCell.m
//  mix
//
//  Created by yj on 16/6/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSelectedSuitDayResultCell.h"
#import "UILabel+GNUtil.h"
#import "UIView+Extend.h"
#import "NSString+Extend.h"
@interface JGJSelectedSuitDayResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateStrLable;
@property (weak, nonatomic) IBOutlet UILabel *dateDetailLbale;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateDetailWidth;
@end
@implementation JGJSelectedSuitDayResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dateStrLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.dateDetailLbale.font = [UIFont systemFontOfSize:AppFont24Size];
    self.dateStrLable.textColor = AppFont333333Color;
    self.dateDetailLbale.textColor = AppFontf0791bColor;
    [self.dateDetailLbale.layer setLayerBorderWithColor:AppFontf0791bColor width:0.5 radius:3.0];
}

-(void)setCalendar:(JGJCalendarModel *)calendar {
    _calendar = calendar;
    NSString *space = calendar.zh_day.length == 1 ? @"    " : @"";
    self.dateStrLable.text = [NSString stringWithFormat:@"%@   %@%@%@   %@", calendar.all_date, calendar.zh_month, calendar.zh_day, space, calendar.weekday];
    NSString *flagOrderString = calendar.timeinterval > 0 ? @"天前" :(calendar.timeinterval == 0 ? @"今天" :@"天后");
    self.dateDetailLbale.text = [NSString stringWithFormat:@"%@%@", (calendar.timeinterval != 0 ? @(calendar.timeinterval): @"") ,flagOrderString];
    CGFloat width = [self.dateDetailLbale contentSizeFixWithWidth:200].width + 8;
    self.dateDetailWidth.constant = width > 60 ? width : 60;
    self.dateDetailLbale.text = [self.dateDetailLbale.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
