//
//  JGJRaincalenderDetailsTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRaincalenderDetailsTableViewCell.h"

@implementation JGJRaincalenderDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _departLable.backgroundColor = AppFontf1f1f1Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCalendermodel:(JGJRainCalenderDetailModel *)calendermodel
{
    _contentLable.text = calendermodel.detail;

}
@end
