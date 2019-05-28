//
//  JGJTimesTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTimesTableViewCell.h"

@implementation JGJTimesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _placeHoldView.layer.masksToBounds = YES;
    _placeHoldView.layer.cornerRadius  = JGJCornerRadius;
    if (_BigBool) {
        _leftLogo.transform = CGAffineTransformMakeScale(2, 2);
    }
    if (TYGetUIScreenWidth<=320) {
        _titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
        _subTitleLable.font = [UIFont systemFontOfSize:11];
        _titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    }
   else  {
        _subTitleLable.font = [UIFont systemFontOfSize:12.5];
    }
    _leftLogo.layer.masksToBounds = YES;
    _leftLogo.layer.cornerRadius  = CGRectGetWidth(_leftLogo.frame)/2;
    
    _subTitleLable.textColor = AppFontbdbdc3Color;
}
-(void)setBigBool:(BOOL)BigBool
{
    if (BigBool) {
        _leftLogo.backgroundColor = [UIColor whiteColor];
        _leftLogo.transform = CGAffineTransformMakeScale(2.6, 2.6);
        _upDepartlable.transform = CGAffineTransformMakeTranslation(0, -4);
        _bottomLable.transform   = CGAffineTransformMakeTranslation(0, 4);
    }else{
        _leftLogo.backgroundColor = AppFonte8e8e8Color;
        _upDepartlable.transform = CGAffineTransformMakeTranslation(0, 0);
        _bottomLable.transform   = CGAffineTransformMakeTranslation(0, 0);
        
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTimeStr:(NSString *)timeStr
{

    _subTitleLable.text = timeStr;

}
@end
