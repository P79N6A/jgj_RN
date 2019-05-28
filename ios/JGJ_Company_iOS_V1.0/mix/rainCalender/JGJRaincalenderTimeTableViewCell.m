//
//  JGJRaincalenderTimeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRaincalenderTimeTableViewCell.h"

@implementation JGJRaincalenderTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNameLable)];
    _nameLable.userInteractionEnabled = YES;

    [_nameLable addGestureRecognizer:tap];
    
    self.nameLable.textColor = AppFont628ae0Color;
}
-(void)tapNameLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapDetailNameLable:)]) {
        [self.delegate tapDetailNameLable:_nameLable.tag];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCalendermodel:(JGJRainCalenderDetailModel *)calendermodel
{
    _calendermodel = calendermodel;
    
    _timelable.text = calendermodel.day;
    _nameLable.text = calendermodel.record_info.real_name;
}
@end
