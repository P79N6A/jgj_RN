//
//  JGJrecordWorkTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJrecordWorkTableViewCell.h"

@implementation JGJrecordWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _TitleLable.layer.masksToBounds = YES;
    _TitleLable.layer.cornerRadius = 2.5;
    _TitleLable.layer.borderColor = AppFontd7252cColor.CGColor;
    _TitleLable.layer.borderWidth = 0.5;
    
    // Initialization code
}
-(void)setDetailStrs:(NSString *)detailStrs
{

    _TitleLable.text = detailStrs;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
