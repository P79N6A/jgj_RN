//
//  YZGWageDetailTitleTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageDetailTitleTableViewCell.h"

@interface YZGWageDetailTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLabelLayoutCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelLayoutR;
@end

@implementation YZGWageDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = JGJMainBackColor;
}

- (void)setLeftText:(NSString *)leftText{
    self.leftLabel.text = leftText;
}


- (void)setMiddleText:(NSString *)middleText{
    self.middleLabel.text = middleText;
}

- (void)setRightText:(NSString *)rightText{
    self.rightLabel.text = rightText;
}

- (void)setLeftText:(NSString *)leftText middleText:(NSString *)middleText rightText:(NSString *)rightText{
    self.leftLabel.text = leftText;
    self.middleLabel.text = middleText;
    self.rightLabel.text = rightText;
}

-(void)setLeftLabelLayoutLConstraint:(CGFloat )constraint{
    self.leftLabelLayoutL.constant = constraint;
}

-(void)setRighttLabelLayoutRConstraint:(CGFloat )constraint{
    self.rightLabelLayoutR.constant = constraint;
}

-(void)setMiddleLabelLayoutCenterXConstraint:(CGFloat )constraint{
    self.middleLabelLayoutCenterX.constant = constraint;
}

- (void)setLeftConstraint:(CGFloat )leftConstraint middleConstraint:(CGFloat )middleConstraint rightConstraint:(CGFloat )rightConstraint{
    self.leftLabelLayoutL.constant = leftConstraint;
    self.rightLabelLayoutR.constant = rightConstraint;
    self.middleLabelLayoutCenterX.constant = middleConstraint;
    [self.contentView layoutIfNeeded];
}
@end
