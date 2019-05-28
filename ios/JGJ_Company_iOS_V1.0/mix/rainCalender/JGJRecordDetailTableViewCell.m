//
//  JGJRecordDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordDetailTableViewCell.h"

@implementation JGJRecordDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _recordButton.backgroundColor = JGJMainColor;
    _recordButton.layer.masksToBounds = YES;
    _recordButton.layer.cornerRadius = JGJCornerRadius;
    // Initialization code
}
-(void)setHiddenButton:(BOOL)hiddenButton
{
    if (hiddenButton) {
        _placeLable.hidden = YES;
        _placeButton.hidden = YES;
        _detailLable.hidden = NO;
    }else{
        _placeButton.hidden = NO;
        _placeLable.hidden  = NO;
        _detailLable.hidden = YES;
    
    }

}
- (IBAction)clickRecordWeather:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clicKRecordWeatherButtonTagert)]) {
        [self.delegate clicKRecordWeatherButtonTagert];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJRainCalenderDetailModel *)model
{
    _detailLable.text = model.detail;

}
@end
