//
//  JGJWeatherCalendarTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWeatherCalendarTableViewCell.h"
#import "JGJTime.h"
@implementation JGJWeatherCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicktopLable)];
    _timelable.userInteractionEnabled = YES;
    [_timelable addGestureRecognizer:tap];
    NSString *TodayMonthStr = [JGJTime yearAppendMonthfromstamp:[NSDate date]];
    NSString *yearStr = [TodayMonthStr substringToIndex:4];
    NSString *monthStr = [TodayMonthStr substringWithRange:NSMakeRange(4, 2)];
    _timelable.text = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
    [_leftCalendarButton setImage:[UIImage imageNamed:@"left_real_arrows_icon"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"right_real_arrows_icon"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)clickCalenderButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectedcalendarButtonandTag:andText:)]) {
        [self.delegate didselectedcalendarButtonandTag:button.tag andText:_timelable.text];
    }
}

-(void)clicktopLable
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didselectedtimelableandLabletext:)]) {
        [self.delegate didselectedtimelableandLabletext:_timelable.text];
    }
}

@end
