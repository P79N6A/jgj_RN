//
//  JGJUnWagesMemberCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWagesMemberCell.h"

#import "JGJCusBottomButtonView.h"

@interface JGJUnWagesMemberCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

//选择
@property (weak, nonatomic) IBOutlet UIButton *selButton;

//结算
@property (weak, nonatomic) IBOutlet UIButton *settleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selButtonW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settleButtonW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTrail;


@end

@implementation JGJUnWagesMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLable.textColor = AppFont333333Color;
    
    self.moneyLable.textColor = AppFont333333Color;
    
    [self.settleButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius / 2.0];
}

- (void)setListModel:(JGJRecordUnWageListModel *)listModel {
    
    _listModel = listModel;
    
    self.nameLable.text = _listModel.user_info.name;
    
    self.moneyLable.text = _listModel.amounts;
    
    self.selButton.selected = _listModel.isSel;
    
    if (self.isBatch) {
        
        self.settleButton.hidden = YES;
        
        self.settleButtonW.constant = 0;
        
        self.selButton.hidden = NO;
        
        self.selButtonW.constant = 40;
        
        self.moneyTrail.constant = 0;
        
    }else {
        
        self.settleButton.hidden = NO;
        
        self.settleButtonW.constant = 60;
        
        self.moneyTrail.constant = 10;
        
        self.selButton.hidden = YES;
        
        self.selButtonW.constant = 10;
    }
    
}

- (IBAction)selButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(unWagesMemberCellWithCell:buttonType:)]) {
        
        [self.delegate unWagesMemberCellWithCell:self buttonType:JGJUnWagesMemberCellSelButtonType];
    }
}


- (IBAction)settleButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(unWagesMemberCellWithCell:buttonType:)]) {
        
        [self.delegate unWagesMemberCellWithCell:self buttonType:JGJUnWagesMemberCellSettleButtonType];
        
    }
    
}

- (void)setIsScreenShowLine:(BOOL)isScreenShowLine {
    
    _isScreenShowLine = isScreenShowLine;
    
    if (_isScreenShowLine) {
        
        self.trail.constant = 0;
        
        self.leading.constant = 0;
        
    }else {
        
        self.trail.constant = 12;
        
        self.leading.constant = 12;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
