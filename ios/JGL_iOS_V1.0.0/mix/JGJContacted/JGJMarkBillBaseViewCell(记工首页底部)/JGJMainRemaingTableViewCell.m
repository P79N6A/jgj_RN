//
//  JGJMainRemaingTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMainRemaingTableViewCell.h"

@implementation JGJMainRemaingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JGJRecordMonthBillModel *)model
{
    self.amountLable.text = [NSString stringWithFormat:@"%@%@%@",model.b_total.pre_unit?:@"",model.b_total.total?:@"0.00",model.b_total.unit?:@""];
}
@end
