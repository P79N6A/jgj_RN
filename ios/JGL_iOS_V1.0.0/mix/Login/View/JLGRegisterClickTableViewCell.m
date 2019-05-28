//
//  JLGRegisterClickTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGRegisterClickTableViewCell.h"

@implementation JLGRegisterClickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailTF.textColor = AppFont999999Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
