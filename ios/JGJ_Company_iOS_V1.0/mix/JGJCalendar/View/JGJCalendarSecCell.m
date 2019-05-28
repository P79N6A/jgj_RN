//
//  JGJCalendarSecCell.m
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarSecCell.h"
#import "UIImage+Extend.h"
#import "UILabel+GNUtil.h"

@interface JGJCalendarSecCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *luckDayLable;
@property (weak, nonatomic) IBOutlet UILabel *avoidDayLable;
@property (weak, nonatomic) IBOutlet UILabel *oriLable;

@end

@implementation JGJCalendarSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage resizeWithImageName:@"calendar_content_background"];
    self.backImageView.image = image;
    self.luckDayLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.avoidDayLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.oriLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.luckDayLable.textColor = AppFont333333Color;
    self.avoidDayLable.textColor = AppFont333333Color;
    self.oriLable.textColor = AppFont333333Color;
}

- (void)setCalendarModel:(JGJCalendarModel *)calendarModel {
    _calendarModel = calendarModel;
    self.luckDayLable.text = calendarModel.yi ?: @"无";
    self.avoidDayLable.text = calendarModel.ji ?: @"无";
    self.oriLable.text = calendarModel.orientation;
    [self.luckDayLable setAttributedText:self.luckDayLable.text lineSapcing:3.0 textAlign:NSTextAlignmentLeft];
    [self.avoidDayLable setAttributedText:self.avoidDayLable.text lineSapcing:3.0 textAlign:NSTextAlignmentLeft];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
