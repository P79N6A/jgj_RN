//
//  JGJworkteamTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJworkteamTableViewCell.h"

#import "UILabel+GNUtil.h"
@implementation JGJworkteamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}
-(void)setManNum:(NSString *)manNum
{
    
    self.contentLable.text = [NSString stringWithFormat:@"未记工工人(%@人)\n长按头像可修改工资标准",manNum];
//    [self.contentLable markText:@"(长按头像可修改工资标准)" withColor:AppFontEB4E4EColor];
    [self.contentLable markLineTextWithLeftTextAlignment:@"长按头像可修改工资标准" withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFontEB4E4EColor lineSpace:5];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setProname:(NSString *)proname
{
    
    _pronameLable.text = proname;

}
@end
