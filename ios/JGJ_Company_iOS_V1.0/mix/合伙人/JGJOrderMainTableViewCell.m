//
//  JGJOrderMainTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJOrderMainTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@implementation JGJOrderMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _goodsNameLable.text = orderListModel.server_name;
    _goodsPriceLable.text = orderListModel.price_detail;
    if (![NSString isEmpty: orderListModel.produce_info.units]) {
        if ([orderListModel.price_detail containsString:orderListModel.produce_info.units]) {
            [_goodsPriceLable markText:orderListModel.produce_info.units withColor:AppFont999999Color];
        }
    }
    UIImage *image;
    if (_VipGoods) {
        image = [UIImage imageNamed:@"黄金服务版"];
    }else{
        image = [UIImage imageNamed:@"组-17"];
    }
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,orderListModel.msg_src]]placeholderImage:image];

}
-(void)setOrderModel:(JGJOrderListModel *)orderModel
{
    _goodsNameLable.text = orderModel.server_name;
//    if (![NSString isEmpty:orderModel.price] && ![NSString isEmpty:orderModel.units]) {
//        _goodsPriceLable.text = [NSString stringWithFormat:@"%@/%@",orderModel.price,orderModel.units];
// 
//    }
    UIImage *image;

    if (_VipGoods) {
        image = [UIImage imageNamed:@"黄金服务版"];
        if (![NSString isEmpty:orderModel.price] && ![NSString isEmpty:orderModel.units]) {
            _goodsPriceLable.text = [NSString stringWithFormat:@"%@/%@",orderModel.price,orderModel.units];
            [_goodsPriceLable markText:orderModel.units withColor:AppFont999999Color];
        }
    }else{
        if (![NSString isEmpty:orderModel.cloud_price] && ![NSString isEmpty:orderModel.units]) {
            _goodsPriceLable.text = [NSString stringWithFormat:@"%@/%@",orderModel.cloud_price,orderModel.units];
            [_goodsPriceLable markText:orderModel.units withColor:AppFont999999Color];

            
        }
        image = [UIImage imageNamed:@"组-17"];
    }

    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,orderModel.msg_src]]
     placeholderImage:image];
}
@end
