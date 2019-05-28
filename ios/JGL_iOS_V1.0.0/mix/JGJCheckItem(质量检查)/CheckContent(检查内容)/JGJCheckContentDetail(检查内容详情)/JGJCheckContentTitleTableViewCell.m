//
//  JGJCheckContentTitleTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckContentTitleTableViewCell.h"

@implementation JGJCheckContentTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJCheckContentDetailModel *)model
{

    self.titleNameLable.text =model.content_name?:@"";
}
@end
