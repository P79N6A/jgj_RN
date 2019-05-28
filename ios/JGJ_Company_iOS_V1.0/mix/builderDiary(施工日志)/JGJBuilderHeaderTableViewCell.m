//
//  JGJBuilderHeaderTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBuilderHeaderTableViewCell.h"

@implementation JGJBuilderHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setProName:(NSString *)proName
{
    _pronameLable.text = [NSString stringWithFormat:@"当前项目：%@",proName];
}
@end
