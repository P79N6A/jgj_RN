//
//  JGJWeatherNewDeatailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWeatherNewDeatailTableViewCell.h"
#import "JGJTime.h"
@implementation JGJWeatherNewDeatailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNameLable)];
    [_nameLable addGestureRecognizer:tap];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCalendermodel:(JGJRainCalenderDetailModel *)calendermodel
{
    _daylable.text =calendermodel.create_time;
//    _daylable.text = [NSString stringWithFormat:@"%@  %@  %@",calendermodel.create_time,[JGJTime getChineseCalendarWithDate:[NSDate date]],@"星期一"];
//    _daylable.text = [NSString stringWithFormat:@"%@  %@  %@",calendermodel.create_time,calendermodel.lunar_date,calendermodel.weekday];
    
    
    
    if ([calendermodel.temp isEqualToString:@""] && [calendermodel.wind isEqualToString:@""]) {
        _windHeight.constant = 0;
        _tempHeight.constant = 0;
        _heightConstance.constant = 25;
    }
 else   if (([calendermodel.wind isEqualToString:@""] && ![calendermodel.temp isEqualToString:@""])||(![calendermodel.wind isEqualToString:@""] && [calendermodel.temp isEqualToString:@""])) {
     if ([calendermodel.wind isEqualToString:@""]) {
         _windHeight.constant = 0;
     }else{
         _tempHeight.constant = 0;
     }
        _heightConstance.constant = 50;
 }else{
  }
    _tempLable.text = calendermodel.temp;
    _windLable.text = calendermodel.wind;
    _daylable.text = calendermodel.day;
    _nameLable.text = calendermodel.record_info.real_name;
    _weatherLable.text = calendermodel.weat;
//    _weathercContentLable.text = [NSString stringWithFormat:@"%@%@%@",];
    _contentLable.text = calendermodel.detail;
    if (_contentLable.text.length <=0) {
        _departLable.hidden = YES;
    }else{
        _departLable.hidden = NO;

    }
    if ([calendermodel.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        _nameLable.textColor = AppFont333333Color;
    }else{
        
    }

    
}
-(void)tapNameLable
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapDetailNameLable:)]) {
        [self.delegate tapDetailNameLable:_nameLable.tag];
    }

}
@end
