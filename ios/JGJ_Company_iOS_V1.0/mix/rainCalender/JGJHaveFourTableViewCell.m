//
//  JGJHaveFourTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHaveFourTableViewCell.h"

@implementation JGJHaveFourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageArr:(NSMutableArray *)imageArr
{
    _upleftimagview.image = [UIImage imageNamed:imageArr.firstObject];
    _uprightimagview.image = [UIImage imageNamed:imageArr[1]];
    _downleftimagview.image = [UIImage imageNamed:imageArr[2]];
    _downRightimagview.image = [UIImage imageNamed:imageArr.lastObject];

}
@end
