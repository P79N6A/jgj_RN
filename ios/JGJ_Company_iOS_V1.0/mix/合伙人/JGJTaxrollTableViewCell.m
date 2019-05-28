//
//  JGJTaxrollTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaxrollTableViewCell.h"

@implementation JGJTaxrollTableViewCell

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
    if ([model.amount floatValue] <= 0) {
        
        _moneyDeslable.text =@"-";
        _MymoneyLable.text  = @"-";
    }else{
//        _moneyDeslable.text =[NSString stringWithFormat:@"%.2f",[model.amount?:@"0" floatValue]*.12];
//        _MymoneyLable.text  = [NSString stringWithFormat:@"%.2f",[model.amount?:@"0" floatValue] * 0.88];
    }

}
@end
