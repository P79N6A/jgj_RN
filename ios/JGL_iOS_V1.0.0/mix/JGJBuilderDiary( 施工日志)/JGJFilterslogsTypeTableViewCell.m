//
//  JGJFilterslogsTypeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFilterslogsTypeTableViewCell.h"

@implementation JGJFilterslogsTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJGetLogTemplateModel *)model
{
    _typeLable.text = model.cat_name;
}
@end
