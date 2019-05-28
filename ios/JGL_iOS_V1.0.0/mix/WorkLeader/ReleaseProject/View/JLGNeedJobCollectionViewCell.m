//
//  JLGNeedJobCollectionViewCell.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGNeedJobCollectionViewCell.h"
#import "CALayer+SetLayer.h"

@interface JLGNeedJobCollectionViewCell ()

@end

@implementation JLGNeedJobCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.jobTypeButton.layer setLayerBorderWithColor:TYColorHex(0xb8b8b8) width:1.0 radius:12.0];
    [self.jobTypeButton setTitleColor:TYColorHex(0xb8b8b8) forState:UIControlStateNormal];
    [self.jobTypeButton setTitleColor:TYColorHex(0x46a8ff) forState:UIControlStateSelected];
}


- (void)jobTypeButtonSelected:(BOOL)isSelected{
    self.jobTypeButton.selected = !isSelected;
    [self jobTypeBtnClick:self.jobTypeButton];
}

- (IBAction)jobTypeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIColor *borderColor = sender.selected?TYColorHex(0x46a8ff):TYColorHex(0xb8b8b8);
    
   [self.jobTypeButton.layer setLayerBorderWithColor:borderColor width:1.0 radius:12.0];
    
    if ([self.delegate respondsToSelector:@selector(needJobCollectionCellBtnClikIndex:selected:)]) {
        [self.delegate needJobCollectionCellBtnClikIndex:self.tag selected:sender.selected];
    }
}

@end
