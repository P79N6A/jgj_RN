//
//  JGJLoginFilterTypeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLoginFilterTypeTableViewCell.h"

@implementation JGJLoginFilterTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFilterModel:(JGJFilterLogModel *)filterModel
{

    _filterLogType.text = filterModel.logType;
}
@end
