//
//  JGJUnSetFormCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnSetFormCell.h"

#import "UILabel+GNUtil.h"

@interface JGJUnSetFormCell ()

@property (weak, nonatomic) IBOutlet UILabel *unSetFormDesLable;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation JGJUnSetFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unSetFormDesLable.textColor = AppFont666666Color;
    
    [self.checkButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius / 2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecordUnWageModel:(JGJRecordUnWageModel *)recordUnWageModel {
    
    _recordUnWageModel = recordUnWageModel;
    
    self.unSetFormDesLable.text = [NSString stringWithFormat:@"你还有 %@笔 点工的工资模板中未设置金额", _recordUnWageModel.un_salary_tpl];
    
    if (JLGisLeaderBool) {
        
        self.unSetFormDesLable.text = [NSString stringWithFormat:@"你的工人还有 %@笔 点工的工资模板中未设置金额", _recordUnWageModel.un_salary_tpl];
    }
 
    if (![NSString isEmpty:_recordUnWageModel.un_salary_tpl]) {
        
        NSString *changeStr = [NSString stringWithFormat:@"%@%@",_recordUnWageModel.un_salary_tpl, @"笔"];
        
         [self.unSetFormDesLable markText:changeStr withColor:AppFontEB4E4EColor];
    }
    
}

- (IBAction)checkButtonPressed:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(unSetFormCell:checkButton:)]) {
        
        [self.delegate unSetFormCell:self checkButton:sender];
    }

}


@end
