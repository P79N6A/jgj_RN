//
//  JLGPadFundedTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGPadFundedTableViewCell.h"
#import "JLGBlueBorderButton.h"

@implementation JLGPadFundedTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    JLGBlueBorderButton *noNeedMoneyButton = [self viewWithTag:1];
    [self needMoneyBtnClick:noNeedMoneyButton];
}
- (IBAction)needMoneyBtnClick:(JLGBlueBorderButton *)sender {
    sender.selected = YES;
    JLGBlueBorderButton *noNeedMoneyButton = [self viewWithTag:2];
    noNeedMoneyButton.selected = NO;
    self.selectedNum = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(PadFundedSelected:)]) {
        [self.delegate PadFundedSelected:self.selectedNum];
    }
}

- (IBAction)notNeedMoneyBtnClick:(JLGBlueBorderButton *)sender {
    sender.selected = YES;
    JLGBlueBorderButton *noNeedMoneyButton = [self viewWithTag:1];
    noNeedMoneyButton.selected = NO;
    self.selectedNum = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(PadFundedSelected:)]) {
        [self.delegate PadFundedSelected:self.selectedNum];
    }
}

- (void)setSelectedNum:(NSUInteger)selectedNum{
    _selectedNum = selectedNum;
    NSInteger unSelectedNum = selectedNum == 0?2:1;
    selectedNum = selectedNum == 0?1:2;
    JLGBlueBorderButton *selectedNumButton = [self viewWithTag:selectedNum];
    JLGBlueBorderButton *unSelectedNumButton = [self viewWithTag:unSelectedNum];
    selectedNumButton.selected = YES;
    unSelectedNumButton.selected = NO;
}
@end
