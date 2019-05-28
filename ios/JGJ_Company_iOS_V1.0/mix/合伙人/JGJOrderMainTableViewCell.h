//
//  JGJOrderMainTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJOrderMainTableViewCell : UITableViewCell
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;//我的列表跳转
@property (strong ,nonatomic)JGJOrderListModel *orderModel;//直接生成上平订单

@property (strong, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLable;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLable;
@property (assign ,nonatomic)BOOL VipGoods;//直接生成上平订单

@end
