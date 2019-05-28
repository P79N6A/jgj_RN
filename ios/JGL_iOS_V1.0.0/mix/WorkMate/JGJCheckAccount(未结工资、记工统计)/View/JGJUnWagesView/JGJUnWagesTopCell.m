//
//  JGJUnWagesTopCell.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJUnWagesTopCell.h"

@interface JGJUnWagesTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *unWagesLable;

@property (weak, nonatomic) IBOutlet UILabel *unWagesTitleLable;

@end

@implementation JGJUnWagesTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unWagesLable.textColor = AppFont5BA0EDColor;
    
    self.unWagesTitleLable.font = [UIFont boldSystemFontOfSize:AppFont60Size];
    
    self.unWagesTitleLable.textColor = AppFont666666Color;
    
    self.unWagesTitleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    
}

- (void)setRecordUnWageModel:(JGJRecordUnWageModel *)recordUnWageModel {
    
    _recordUnWageModel = recordUnWageModel;
    
    self.unWagesLable.text = recordUnWageModel.total_amount;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
