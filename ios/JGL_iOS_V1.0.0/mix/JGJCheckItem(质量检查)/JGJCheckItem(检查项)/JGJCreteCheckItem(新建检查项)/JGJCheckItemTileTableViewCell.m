//
//  JGJCheckItemTileTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckItemTileTableViewCell.h"

@implementation JGJCheckItemTileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseView.backgroundColor = AppFontf1f1f1Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
