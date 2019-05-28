//
//  JGJRaincalenderWindTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRaincalenderWindTableViewCell.h"

@implementation JGJRaincalenderWindTableViewCell

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
    _windLable.text = calendermodel.wind;

}
@end
