//
//  JLGValidityDateTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGValidityDateTableViewCell.h"
#import "JLGBlueBorderButton.h"

@implementation JLGValidityDateTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    JLGBlueBorderButton *firstButton = [self viewWithTag:1];
    [self firstBtnClick:firstButton];
}

- (void)setSelectedNum:(NSUInteger)selectedNum{
    _selectedNum = selectedNum;
}

- (IBAction)firstBtnClick:(JLGBlueBorderButton *)sender {
    sender.selected = YES;
    JLGBlueBorderButton *secondButton = [self viewWithTag:2];
    JLGBlueBorderButton *thirdButton = [self viewWithTag:3];
    
    secondButton.selected = NO;
    thirdButton.selected = NO;
    
    self.selectedNum = 0;
}

- (IBAction)secondBtnClick:(JLGBlueBorderButton *)sender {
    sender.selected = YES;
    JLGBlueBorderButton *firstButton = [self viewWithTag:1];
    JLGBlueBorderButton *thirdButton = [self viewWithTag:3];
    
    firstButton.selected = NO;
    thirdButton.selected = NO;
    self.selectedNum = 1;
}


- (IBAction)thirdBtnClick:(JLGBlueBorderButton *)sender {
    sender.selected = YES;
    JLGBlueBorderButton *firstButton = [self viewWithTag:1];
    JLGBlueBorderButton *secondButton = [self viewWithTag:2];
    
    firstButton.selected = NO;
    secondButton.selected = NO;
    self.selectedNum = 2;
}
@end
