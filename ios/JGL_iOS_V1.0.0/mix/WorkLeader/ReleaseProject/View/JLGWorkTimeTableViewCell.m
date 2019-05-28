//
//  JLGWorkTimeTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGWorkTimeTableViewCell.h"
#import "NSDate+Extend.h"

@interface JLGWorkTimeTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@end

@implementation JLGWorkTimeTableViewCell

- (IBAction)selectedDateClick:(UIButton *)sender {
    DateType selectedType = (sender.tag == 1)?DateTypeOfStart:DateTypeOfEnd;
    if ([self.delegate respondsToSelector:@selector(getSelectDateType:)]) {
        [self.delegate getSelectDateType:selectedType];
    }
}

- (void)setStartTime:(NSUInteger )startTimeTamp endTime:(NSUInteger )endTimeTamp{
    NSUInteger minTimeTamp = 1420041600;//2015年1月1日0时0分0秒
    if (startTimeTamp > minTimeTamp) {
        NSString *startTimeStr = [NSDate getJLGTimeStrYMd:[NSString stringWithFormat:@"%@",@(startTimeTamp)]];
        [self.startTimeButton setTitle:startTimeStr forState:UIControlStateNormal];
        [self.startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    if (endTimeTamp > minTimeTamp) {
        NSString *endTimeStr = [NSDate getJLGTimeStrYMd:[NSString stringWithFormat:@"%@",@(endTimeTamp)]];
        [self.endTimeButton setTitle:endTimeStr forState:UIControlStateNormal];
        [self.endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
@end
