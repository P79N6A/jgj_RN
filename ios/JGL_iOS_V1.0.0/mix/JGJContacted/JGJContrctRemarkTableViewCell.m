//
//  JGJContrctRemarkTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJContrctRemarkTableViewCell.h"

#import "UILabel+GNUtil.h"
@implementation JGJContrctRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentLable markText:@"(该备注信息仅自己可见)" withFont:[UIFont systemFontOfSize:13] color:AppFont999999Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
