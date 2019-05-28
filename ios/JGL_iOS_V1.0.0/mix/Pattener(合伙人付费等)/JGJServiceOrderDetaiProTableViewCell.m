//
//  JGJServiceOrderDetaiProTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJServiceOrderDetaiProTableViewCell.h"

@implementation JGJServiceOrderDetaiProTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{

    _proLable.text =  orderListModel.pro_name;
    _proLable.numberOfLines = 1;
}

@end
