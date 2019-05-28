//
//  YZGWageDetailTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageDetailTableViewCell.h"
#import "YZGWageMoreDetailModel.h"
#import "YZGRecordWorkpointTool.h"


@interface YZGWageDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayouL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayouR;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLabelLayoutCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelLayoutR;
@end

@implementation YZGWageDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = JGJMainBackColor;
    self.leftLabel.textColor = TYColorHex(0x666666);
    self.rightLabel.textColor = self.leftLabel.textColor;
}

- (void)setIsLastCell:(BOOL)isLastCell{
    _isLastCell = isLastCell;

    self.bottomLineLayouL.constant = isLastCell?0:10;
    self.bottomLineLayouR.constant = isLastCell?0:10;
}

- (void)setWageDetailList:(WageDetailList *)wageDetailList{
    _wageDetailList = wageDetailList;
    
    self.leftLabel.text = wageDetailList.name;
    
    self.rightLabel.text = [NSString stringWithFormat:@"%@",@(wageDetailList.t_poor)];
    [YZGRecordWorkpointTool setLabel:self.middleLabel amount:wageDetailList.t_total];
}

- (void)setWageMoreDetailList:(WageMoreDetailList *)wageMoreDetailList{
    _wageMoreDetailList = wageMoreDetailList;
    self.leftLabel.text = self.wageDetailFilterType != WageDetailFilterPeople ?wageMoreDetailList.name:wageMoreDetailList.pname;
    
    self.middleLabel.text = [NSString stringWithFormat:@"%@笔",@(wageMoreDetailList.t_poor)];
    
    [YZGRecordWorkpointTool setLabel:self.rightLabel amount:wageMoreDetailList.t_total];
    self.leftLabelLayoutL.constant = 10;
    self.middleLabelLayoutCenterX.constant = -30;
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
}

@end
