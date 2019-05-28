//
//  GeoSearchTableViewCell.m
//  HuDuoDuoLogistics
//
//  Created by jizhi on 15/8/6.
//  Copyright (c) 2015年 JiZhiShengHuo. All rights reserved.
//

#import "GeoSearchTableViewCell.h"

@implementation GeoSearchTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.searchDetailTextLabel.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;

}

@end
