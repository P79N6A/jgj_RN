//
//  JGJMarkBillTinyTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillTinyTableViewCell.h"

@implementation JGJMarkBillTinyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLable.textColor = AppFont000000Color;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
