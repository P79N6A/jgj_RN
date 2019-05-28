//
//  JGJClassifyChoiceTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJClassifyChoiceTableViewCell.h"

@implementation JGJClassifyChoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJSelfLogTempRatrueModel *)model
{
    _model = model;
    _titleLable.text = model.element_name;
    _contentLable.text = [@"请选择" stringByAppendingString: model.element_name ];
}
@end
