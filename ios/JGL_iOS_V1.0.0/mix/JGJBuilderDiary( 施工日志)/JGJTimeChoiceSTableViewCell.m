//
//  JGJTimeChoiceSTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTimeChoiceSTableViewCell.h"

@implementation JGJTimeChoiceSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}
-(void)setModel:(JGJSelfLogTempRatrueModel *)model
{
    _titleLable.text = model.element_name;
    _contentLable.text = [@"请选择" stringByAppendingString:model.element_name];
    
}
@end
