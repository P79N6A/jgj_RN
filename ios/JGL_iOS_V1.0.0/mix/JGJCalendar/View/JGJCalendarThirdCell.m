//
//  JGJCalendarThirdCell.m
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarThirdCell.h"
#import "UIImage+Extend.h"
#import "JGJCalendarTool.h"

@interface JGJCalendarThirdCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodLuckLable;
@property (weak, nonatomic) IBOutlet UILabel *goodLuckTitleLable;
@property (weak, nonatomic) IBOutlet YYTextView *luckDayView;

@end
@implementation JGJCalendarThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage resizeWithImageName:@"calendar_content_background"];
    self.backImageView.image = image;
    self.goodLuckTitleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.goodLuckLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.goodLuckTitleLable.textColor = AppFont333333Color;
    self.goodLuckLable.textColor = AppFont333333Color;
    self.luckDayView.backgroundColor = [UIColor clearColor];
}

- (void)setCalendarModel:(JGJCalendarModel *)calendarModel {
    _calendarModel = calendarModel;
    self.goodLuckTitleLable.text = calendarModel.jishiTitle;
    NSMutableAttributedString *attributedString = [JGJCalendarTool setAllText:calendarModel.jishi compare:@"吉" font:[UIFont systemFontOfSize:AppFont30Size]];
    self.luckDayView.attributedText = attributedString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
