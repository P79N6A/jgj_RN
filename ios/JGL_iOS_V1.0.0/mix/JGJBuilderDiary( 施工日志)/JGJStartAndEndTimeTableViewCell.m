//
//  JGJStartAndEndTimeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJStartAndEndTimeTableViewCell.h"

@implementation JGJStartAndEndTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *s_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickStartTime)];
    self.startView.userInteractionEnabled = YES;
    [self.startView addGestureRecognizer:s_tap];
    
    
    UITapGestureRecognizer *e_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEndTime)];
    self.startView.userInteractionEnabled = YES;
    [self.endView addGestureRecognizer:e_tap];
}
- (void)clickStartTime
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoiceStartTime)]) {
        [self.delegate clickChoiceStartTime];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoiceStartTimeandTag:isStartTime:)]) {
        [self.delegate clickChoiceStartTimeandTag:self.tag isStartTime:YES];
    }
}
- (void)clickEndTime
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoiceEndTime)]) {
        [self.delegate clickChoiceEndTime];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoiceEndTimeandTag:isStartTime:)]) {
        [self.delegate clickChoiceEndTimeandTag:self.tag isStartTime:NO];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//这个模型是筛选日志的模型
- (void)setFilterModel:(JGJFilterLogModel *)filterModel
{
    _startPlaceHolder.text = filterModel.startTime;
    _endPlaceHolder.text  = filterModel.endTime;
    _startPlaceHolder.textColor = AppFont666666Color;
    _endPlaceHolder.textColor = AppFont666666Color;
}
-(void)setModel:(JGJSelfLogTempRatrueModel *)model
{
    _startPlaceHolder.text = [model.list.firstObject element_name];
    _endPlaceHolder.text = [model.list.lastObject element_name];

    _startLable.text = [model.list[0] element_name];
    _endLable.text = [model.list[1] element_name];
}
@end
