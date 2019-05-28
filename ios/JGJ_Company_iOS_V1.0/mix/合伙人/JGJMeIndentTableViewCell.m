//
//  JGJMeIndentTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMeIndentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+GNUtil.h"
@implementation JGJMeIndentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _payButton.layer.masksToBounds = YES;
    _payButton.layer.cornerRadius = JGJCornerRadius;
    _payButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    _payButton.layer.borderWidth = .5;
    
}
- (IBAction)goPay:(id)sender {
}
-(void)setModel:(JGJOrderListModel *)model
{
    _orderNumLable.text = [@"订单编号：" stringByAppendingString: model.order_sn];
    _proNameLable.text = model.pro_name;
    _goodsTypeLable.text = model.server_name;
//    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.msg_src]];
    _goodsSalaryLable.text = model.price_detail;
    _totalSalaryLable.text =  model.amount ;
    
    if (![NSString isEmpty:model.price_detail]) {
        if ([model.price_detail containsString:@"/人/半年"]) {
            [_goodsSalaryLable markText:@"/人/半年" withColor:AppFont999999Color];

        }else if ([model.price_detail containsString:@"/10G/半年"]){
            [_goodsSalaryLable markText:@"/10G/半年" withColor:AppFont999999Color];

        }
    }
//    1是已支付  2是未完成
    if ([model.order_status isEqualToString:@"2"]) {
        _payButton.hidden = YES;
    }
    if ([model.order_type isEqualToString:@"1"] || [model.order_type isEqualToString:@"2"]){
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,model.msg_src]] placeholderImage:[UIImage imageNamed:@"黄金服务版"]];
    }else if ([model.order_type isEqualToString:@"3"] || [model.order_type isEqualToString:@"4"])
    {
     [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,model.msg_src]] placeholderImage:[UIImage imageNamed:@"组-17"]];
    }
}
@end
