//
//  JGJMainYearDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMainYearDetailTableViewCell.h"

@implementation JGJMainYearDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(14, 0, TYGetUIScreenWidth - 24, 0.5)];
    line.backgroundColor = AppFontdbdbdbColor;
    [self.contentView addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJRecordMonthBillModel *)model
{
    self.leftAmountLable.text = [NSString stringWithFormat:@"%@%@%@",model.m_total.pre_unit?:@"" , model.m_total.total?:@"0.00",model.m_total.unit?:@""];
    
    self.rightAmountLable.text = [NSString stringWithFormat:@"%@%@%@",model.y_total.pre_unit?:@"" , model.y_total.total?:@"0.00",model.y_total.unit?:@""];

}
@end
