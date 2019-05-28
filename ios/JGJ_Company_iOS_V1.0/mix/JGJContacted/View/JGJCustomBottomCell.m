//
//  JGJCustomBottomCell.m
//  JGJCompany
//
//  Created by yj on 2017/5/2.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCustomBottomCell.h"

@interface JGJCustomBottomCell ()

@end

@implementation JGJCustomBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomButton.backgroundColor = AppFontd5252cColor;
    [self.bottomButton.layer setLayerCornerRadius:JGJCornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleButtonPressedAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customBottomCellButtonPressed:)]) {

        [self.delegate customBottomCellButtonPressed:self];
    }
    
}


@end
