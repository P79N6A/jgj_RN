//
//  JGJCustomButtonCell.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCustomButtonCell.h"

@implementation JGJCustomButtonModel

@end
@interface JGJCustomButtonCell ()
@property (weak, nonatomic) IBOutlet UIButton *commonButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonButtonTrail;
@end
@implementation JGJCustomButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.commonButton.layer setLayerCornerRadius:JGJCornerRadius];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setCustomButtonModel:(JGJCustomButtonModel *)customButtonModel {
    _customButtonModel = customButtonModel;
    [self.commonButton setTitleColor:customButtonModel.titleColor forState:UIControlStateNormal];
    [self.commonButton setTitle:customButtonModel.buttonTitle forState:UIControlStateNormal];
    [self.commonButton.layer setLayerBorderWithColor:customButtonModel.layerColor width:0.5 radius:JGJCornerRadius];
    self.commonButton.backgroundColor = customButtonModel.backColor;
    if (customButtonModel.contentBackColor) {
         self.contentView.backgroundColor = customButtonModel.contentBackColor;   
    }
    if (customButtonModel.isDefaulStyle ) {
        self.commonButtonTrail.constant = 0.0;
        self.commonButtonLeading.constant = 0.0;
        [self.commonButton.layer setLayerCornerRadius:0];
    }
    self.commonButton.hidden = customButtonModel.isHidden;
}

- (IBAction)handleButtonPressedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customButtonCell:ButtonCellType:)]) {
        [self.delegate customButtonCell:self ButtonCellType:self.customButtonModel.buttontype];
    }
}

@end
