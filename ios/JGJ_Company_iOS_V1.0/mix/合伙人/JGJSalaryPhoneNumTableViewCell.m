//
//  JGJSalaryPhoneNumTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSalaryPhoneNumTableViewCell.h"

@implementation JGJSalaryPhoneNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJAccountListModel *)model
{
    _model = model;
    
    NSString *telephone = model.telephone;;
    
    if ([NSString isEmpty:telephone]) {
        
        telephone = [TYUserDefaults objectForKey:JLGPhone];

    }
    
    _phoneLable.text = telephone;

}

@end
