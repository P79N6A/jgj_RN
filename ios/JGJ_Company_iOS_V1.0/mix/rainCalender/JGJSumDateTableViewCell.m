//
//  JGJSumDateTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSumDateTableViewCell.h"

@implementation JGJSumDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//编辑按钮
- (IBAction)clickEditeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditeRainCalenderButton)]) {
        [self.delegate clickEditeRainCalenderButton];
    }
}
-(void)setModel:(JGJRainCalenderDetailModel *)model
{
    _dateLable.text = model.day;
//    if (![model.record_info.is_report intValue] &&![model.record_info.is_admin intValue] && ![model.record_info.is_creater intValue]) {
//        _editeButton.hidden = YES;
//        _bigEditeButton.hidden = YES;
//    }else{
//        _editeButton.hidden = NO;
//        _bigEditeButton.hidden = NO;
//    }

}
-(void)setTime:(NSString *)time{
    
    NSRange range = [time rangeOfString:@" "];
    
    NSString *replaceDay = [time substringWithRange:NSMakeRange(range.location, 5)];
    
    NSString *date = [time stringByReplacingOccurrencesOfString:replaceDay withString:@""];
    
    _dateLable.text = date;
    
}
-(void)setWorkmodel:(JGJMyWorkCircleProListModel *)Workmodel
{
    if (![Workmodel.is_report intValue] &&!Workmodel.can_at_all &&![_Workmodel.myself_group intValue]) {
        _editeButton.hidden = YES;
        _bigEditeButton.hidden = YES;
    }else{
        _editeButton.hidden = NO;
        _bigEditeButton.hidden = NO;
    }


}
@end
