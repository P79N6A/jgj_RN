//
//  YZGRecordWorkpointTool.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkpointTool.h"
#import "TYFMDB.h"
#import "UILabel+GNUtil.h"
@implementation YZGRecordWorkpointTool

#pragma mark - 设置记账的label
+ (void )setLabel:(UILabel *)label topString:(NSString *)topString bottomString:(NSString *)bottomString{
    if (topString.length > 0 && bottomString.length > 0 ) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",topString,bottomString]];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x5f5f5f) range:NSMakeRange(0, topString.length)];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(topString.length + 1,bottomString.length)];
        int Bigfont = 0;
        int normal = 0;

        if (TYGetUIScreenWidth<=325) {
            Bigfont = 12;
            normal  = 10;
        }else{
            Bigfont = 14;
            normal  = 12;
        }
        
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Bigfont] range:NSMakeRange(0, topString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:normal] range:NSMakeRange(topString.length + 1, bottomString.length)];
        label.attributedText = contentStr;
    }else if(topString.length > 0 && bottomString.length == 0){
        label.textColor = TYColorHex(0x5f5f5f);
        label.text = topString;
    }
    
}
+ (void)setLabel:(UILabel *)label toptext:(NSString *)topString bottomtext:(NSString *)bottomString andManTextColor:(NSString *)manC andOverTextColor:(NSString *)overC
{
    if (![NSString isEmpty: topString ]) {
//        if ([topString floatValue] <= 0) {
//            topString = @"休息";
//            manC = @"";
//        }
    }
    
    if (![NSString isEmpty: bottomString ]) {
//        if ([bottomString floatValue] <= 0) {
//            bottomString = @"加班 无加班";
//            overC = @"";
//        }
    }
    
    if (topString.length > 0 && bottomString.length > 0 ) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",topString,bottomString]];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont333333Color range:NSMakeRange(0, topString.length)];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(topString.length - manC.length, manC.length)];

        
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont333333Color range:NSMakeRange(topString.length + 1,bottomString.length)];
        
        if (![NSString isEmpty:bottomString] && ![NSString isEmpty:overC]) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(bottomString.length - overC.length + topString.length + 1 , overC.length)];
           }

        
        int Bigfont = 0;
        int normal = 0;
        
        if (TYGetUIScreenWidth<=325) {
            Bigfont = 12;
            normal  = 12;
        }else{
            Bigfont = 13;
            normal  = 13;
        }
        
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Bigfont] range:NSMakeRange(0, topString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:normal] range:NSMakeRange(topString.length + 1, bottomString.length)];
        label.attributedText = contentStr;
    }else if(topString.length > 0 && bottomString.length == 0){
        label.textColor = AppFont333333Color;
        label.text = topString;
    }


}
+ (void )setLabel:(UILabel *)label manHour:(NSString *)manHour overhour:(NSString *)overHour{
    [self setLabel:label topString:manHour bottomString:overHour];
}
+(void)setLabel:(UILabel *)label manHourTexts:(NSString *)manHour overhourTexts:(NSString *)overHour ManColor:(NSString *)manC OverColor:(NSString *)OverC
{
    [self setLabel:label toptext:manHour bottomtext:overHour andManTextColor:manC andOverTextColor:OverC];

}

+ (void)setLabel:(UILabel *)label amount:(CGFloat )amounts{
   
    UIColor *amoutsColror = amounts >= 0?JGJMainColor:TYColorHex(0x92c977);
   
    label.textColor = amoutsColror;
    if (amounts < 0) {
   
        label.textColor = TYColorHex(0x92c977);
  
    }
    if (amounts == 0) {
        
        label.text = @"-.-";
        
    }else{

        label.text = [NSString stringWithFormat:@"%.2lf" ,amounts];
    }
}

+ (void)setFabsLabel:(UILabel *)label amount:(CGFloat )amounts{
    NSString *symbolString = amounts >= 0?@"￥":@"-￥";
    UIColor *amoutsColror = amounts >= 0?JGJMainColor:TYColorHex(0x92c977);
    
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
