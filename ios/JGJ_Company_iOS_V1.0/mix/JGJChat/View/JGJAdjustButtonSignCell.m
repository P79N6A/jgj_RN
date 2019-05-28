//
//  JGJAdjustButtonSignCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAdjustButtonSignCell.h"

@interface JGJAdjustButtonSignCell ()

@end

@implementation JGJAdjustButtonSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.adjustButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
}

- (IBAction)adjustButtonPressed:(UIButton *)sender {
    
    self.buttonSignType = JGJAdjustButtonSignType;
    
    if (self.handleAdjustButtonSignCellBlock) {
        
        self.handleAdjustButtonSignCellBlock(self);
    }
}

- (IBAction)handleRetryButtonAction:(UIButton *)sender {
    
    self.buttonSignType = JGJRetryButtonSignType;
    
    if (self.handleAdjustButtonSignCellBlock) {
        
        self.handleAdjustButtonSignCellBlock(self);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
