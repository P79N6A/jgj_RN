//
//  JGJQualityReviewResultCell.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityReviewResultCell.h"

@interface JGJQualityReviewResultCell ()

@property (weak, nonatomic) IBOutlet UIButton *passButton;

@property (weak, nonatomic) IBOutlet UIButton *unPassButton;

@property (weak, nonatomic) UIButton *lastButton; //上次选择的按钮

@end

@implementation JGJQualityReviewResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.passButton.selected = YES;
    
    self.lastButton = self.passButton;
        
    [self.passButton setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    
    [self.passButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    [self.unPassButton setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    
    [self.unPassButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    self.passButton.backgroundColor = [UIColor whiteColor];
    
     [self.passButton.layer setLayerBorderWithColor:AppFontd7252cColor width:1 radius:2.5];
    
    self.unPassButton.backgroundColor = AppFontf1f1f1Color;
    
    [self.unPassButton.layer setLayerBorderWithColor:AppFontf1f1f1Color width:1 radius:2.5];
    
}

- (void)setQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {

    _qualityDetailModel = qualityDetailModel;
    
    if (self.handleQualityReviewResultBlock && self.passButton.selected) {
        
        self.handleQualityReviewResultBlock(JGJQualityReviewPassType);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleButtonPressed:(UIButton *)sender {
    
    JGJQualityReviewResultType reviewResultType = sender.tag - 100;
    
    sender.selected = !sender.selected;
    
    if (self.handleQualityReviewResultBlock && sender.selected) {
        
        self.handleQualityReviewResultBlock(reviewResultType);
    }
    
    if (self.lastButton.tag == sender.tag && self.lastButton.selected) {
        
        return;
    }
    
    self.lastButton = sender;
    
    if (sender.selected) {
        
        sender.backgroundColor = [UIColor whiteColor];
        
        [sender.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:2.5];
    }
    
    for (UIView *subButton in self.contentView.subviews) {
        
        if (subButton.tag != sender.tag && [subButton isKindOfClass:[UIButton class]]) {
            
            UIButton *selButton = (UIButton *)subButton;
            
            selButton.selected = NO;
            
            selButton.backgroundColor = AppFontf1f1f1Color;
            
            [selButton.layer setLayerBorderWithColor:AppFontf1f1f1Color width:0.5 radius:2.5];
        }
    }
    
}


@end
