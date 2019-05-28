//
//  JGJSumdetailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSumdetailTableViewCell.h"
#import "UILabel+GNUtil.h"
@implementation JGJSumdetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJRainCalenderDetailModel *)model
{
    _rainLable.text = model.weat_temp_wind;
    _rainLable.text = [NSString stringWithFormat:@"%@",model.weat];;
    _tempLable.text = [NSString stringWithFormat:@"%@",model.temp];
    [_tempLable markText:@"温度(℃)" withColor:AppFont333333Color];
    _windLable.text = [NSString stringWithFormat:@"%@",model.wind];
    [_windLable markText:@"风力(级)" withColor:AppFont333333Color];

}
@end
