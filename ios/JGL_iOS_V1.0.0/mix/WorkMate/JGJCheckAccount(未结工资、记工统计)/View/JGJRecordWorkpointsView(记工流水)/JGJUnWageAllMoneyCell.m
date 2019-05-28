//
//  JGJUnWageAllMoneyCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWageAllMoneyCell.h"

@interface JGJUnWageAllMoneyCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@end

@implementation JGJUnWageAllMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.moneyLable.textColor = AppFont5BA0EDColor;
    
    self.moneyLable.font = [UIFont boldSystemFontOfSize:AppFont60Size];
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    if (![NSString isEmpty:recordWorkStaModel.balance_amount]) {
        
        self.titleLable.text = @"未结: ";
        
        self.moneyLable.text = [NSString stringWithFormat:@"%@", recordWorkStaModel.balance_amount?:@""];
        
    }else {
        
        self.titleLable.text = @"";
        
        self.moneyLable.text = @"";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
