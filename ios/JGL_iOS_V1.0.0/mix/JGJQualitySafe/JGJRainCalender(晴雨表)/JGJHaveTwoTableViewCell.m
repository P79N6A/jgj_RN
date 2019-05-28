//
//  JGJHaveTwoTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHaveTwoTableViewCell.h"

@implementation JGJHaveTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImageArr:(NSMutableArray *)imageArr
{
    _upimagview.image = [UIImage imageNamed:imageArr.firstObject];
    _downimageview.image = [UIImage imageNamed:imageArr.lastObject];

}
@end
