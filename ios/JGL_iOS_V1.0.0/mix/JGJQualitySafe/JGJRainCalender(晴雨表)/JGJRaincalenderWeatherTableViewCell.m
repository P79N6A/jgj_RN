//
//  JGJRaincalenderWeatherTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRaincalenderWeatherTableViewCell.h"

@implementation JGJRaincalenderWeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCalendermodel:(JGJRainCalenderDetailModel *)calendermodel
{
    _weatherLable.text = calendermodel.weat;
}
@end
