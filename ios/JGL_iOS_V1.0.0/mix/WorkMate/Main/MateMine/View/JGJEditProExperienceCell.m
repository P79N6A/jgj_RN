//
//  JGJEditProExperienceCell.m
//  mix
//
//  Created by yj on 16/6/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJEditProExperienceCell.h"

@interface JGJEditProExperienceCell ()
@end
@implementation JGJEditProExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proDes.font = [UIFont systemFontOfSize:AppFont32Size];
    self.proDes.textColor = AppFont999999Color;
    self.proDesDetail.font = [UIFont systemFontOfSize:AppFont32Size];
    self.proDesDetail.textColor = AppFont333333Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
