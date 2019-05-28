//
//  JGJSerViceTimeTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSerViceTimeTableViewCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@implementation JGJSerViceTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  _deaTimeLable.text =   [self fromTimeDayStr:@"180"];
//    [_titleLable markText:@"(半年=183天)" withColor:AppFont999999Color];
    if (TYGetUIScreenWidth <= 320) {
        _deslable.font = [UIFont systemFontOfSize:13];
    }else{
        _deslable.font = [UIFont systemFontOfSize:15];
    }
}


-(void)setOrderModel:(JGJSureOrderListModel *)orderModel
{
 
    if (![NSString isEmpty:orderModel.serviceTime]) {
        _timeLable.text = [orderModel.serviceTime stringByAppendingString:@"年"];
        if ([orderModel.serviceTime floatValue] > 5) {
        _timeLable.text = orderModel.serviceTime;
        }
        
        if ([orderModel.serviceTime isEqualToString:@"0.5"]) {
        _timeLable.text = [_timeLable.text stringByAppendingString:@"(半年)"];
        }
        
        _deaTimeLable.text = [self fromTimeStr:orderModel.serviceTime];
        
    }
}

-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _orderListModel = [JGJOrderListModel new];
    _orderListModel = orderListModel;
    if (![NSString isEmpty:orderListModel.add_serverTime]) {
        _timeLable.text = [orderListModel.add_serverTime stringByAppendingString:@"年"];
        if ([orderListModel.add_serverTime floatValue] > 5) {
            _timeLable.text = orderListModel.add_serverTime;
            
        }
        if ([orderListModel.add_serverTime isEqualToString:@"0.5"]) {
            _timeLable.text = [_timeLable.text stringByAppendingString:@"(半年)"];
        }
//        _deaTimeLable.text = [self fromTimeStr:orderListModel.add_serverTime];
        if (orderListModel.isPayDay && ![NSString isEmpty: orderListModel.add_serverTime ]) {
        _deaTimeLable.text = [self fromTimeDayStr:orderListModel.add_serverTime];
            if ([orderListModel.add_serverTime isEqualToString:@"90"]) {
            _timeLable.text = @"3个月";
   
            }else{
            
            _timeLable.text = [orderListModel.add_serverTime stringByAppendingString:@"天"];

            }

        }
        if (!orderListModel.isPayDay) {
            _deaTimeLable.text = [self fromTimeDayStr:[NSString stringWithFormat:@"%f", [orderListModel.add_serverTime floatValue] * 360]];
        }
    }
    
}

//计算有效期
-(NSString *)fromTimeStr:(NSString *)str
{
    if ([NSString isEmpty:str]) {
        return @"";
    }
    NSString *yearStr;
    NSString *monthStr;
    NSString *dayStr;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_orderListModel.timestamp longLongValue]];

    NSDateFormatter *yearformatter = [[NSDateFormatter alloc]init];
    [yearformatter setDateFormat:@"yyyy"];
    NSDateFormatter *monthformatter = [[NSDateFormatter alloc]init];
    [monthformatter setDateFormat:@"MM"];
    NSDateFormatter *dayformatter = [[NSDateFormatter alloc]init];
    [dayformatter setDateFormat:@"dd"];
    yearStr   = [yearformatter stringFromDate:confromTimesp];
    monthStr = [monthformatter stringFromDate:confromTimesp];
    dayStr   =  [dayformatter stringFromDate:confromTimesp];
    NSString *intStr = [NSString stringWithFormat:@"%d",[str intValue]];
    yearStr = [NSString stringWithFormat:@"%d",[intStr intValue] + [yearStr intValue]];
    
    float month =([str floatValue] - [str intValue])*10;
    if ([monthStr intValue] + month > 12) {
        
        monthStr = [NSString stringWithFormat:@"%f",[monthStr intValue] + month - 12];
        yearStr = [NSString stringWithFormat:@"%d",[yearStr intValue] + 1 ];
    }else{
        monthStr = [NSString stringWithFormat:@"%f",[monthStr intValue] + month ];
    }
    monthStr = [NSString stringWithFormat:@"%d",[monthStr intValue]];
    if (monthStr.length == 1) {
        monthStr = [@"0" stringByAppendingString:monthStr];
    }
    if (dayStr.length == 1) {
        dayStr = [@"0" stringByAppendingString:dayStr];
    }
    NSString *limiteStr;
    limiteStr = [@"有效期至：" stringByAppendingString:[[[[yearStr stringByAppendingString:@"-"] stringByAppendingString:monthStr] stringByAppendingString:@"-"] stringByAppendingString:dayStr] ];
    return limiteStr;
}
-(NSString *)fromTimeDayStr:(NSString *)str
{
    if ([NSString isEmpty: _orderListModel.timestamp ]) {
        return @"" ;
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_orderListModel.timestamp longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *laterDate = [confromTimesp dateByAddingTimeInterval:60 * 60 * 24 * ([str intValue ])];
    NSString *dayStr = [formatter stringFromDate:laterDate];
    return [@"有效期至：" stringByAppendingString: dayStr];

}
-(float)RowNodepartHeight:(NSString *)Str
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width/2 + 10;
}


@end
