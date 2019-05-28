//
//  YZGRecordWorkpointTool.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkpointTool.h"
#import "TYFMDB.h"

@implementation YZGRecordWorkpointTool

#pragma mark - 设置记账的label
+ (void )setLabel:(UILabel *)label topString:(NSString *)topString bottomString:(NSString *)bottomString{
    if (topString.length > 0 && bottomString.length > 0 ) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",topString,bottomString]];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:ColorHex(0x5f5f5f) range:NSMakeRange(0, topString.length)];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:ColorHex(0x999999) range:NSMakeRange(topString.length + 1,bottomString.length)];
        
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, topString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(topString.length + 1, bottomString.length)];
        label.attributedText = contentStr;
    }else if(topString.length > 0 && bottomString.length == 0){
        label.textColor = ColorHex(0x5f5f5f);
        label.text = topString;
    }
}

+ (void )setLabel:(UILabel *)label manHour:(NSString *)manHour overhour:(NSString *)overHour{
    [self setLabel:label topString:manHour bottomString:overHour];
}

+ (void)setLabel:(UILabel *)label amount:(CGFloat )amounts{
    UIColor *amoutsColror = amounts >= 0?JGJMainColor:ColorHex(0x92c977);

    label.textColor = amoutsColror;
    label.text = [NSString stringWithFormat:@"￥%.2lf" ,amounts];
}

+ (void)setFabsLabel:(UILabel *)label amount:(CGFloat )amounts{
    NSString *symbolString = amounts >= 0?@"￥":@"-￥";
    UIColor *amoutsColror = amounts >= 0?JGJMainColor:ColorHex(0x92c977);
    
    label.textColor = amoutsColror;
    label.text = [NSString stringWithFormat:@"%@%@",symbolString,@(fabs(amounts))];
}

+ (UITableViewCell *)getJGJTipCell:(UITableView *)tableView{
    static NSString *JGJTipCellID = @"JGJTipCellID";
    UITableViewCell *JGJTipCell = [tableView dequeueReusableCellWithIdentifier:JGJTipCellID];
    if (!JGJTipCell) {
        JGJTipCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JGJTipCellID];
        JGJTipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        JGJTipCell.backgroundColor = AppFontf1f1f1Color;
        JGJTipCell.textLabel.textColor = AppFont999999Color;
        JGJTipCell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return JGJTipCell;
}
@end
