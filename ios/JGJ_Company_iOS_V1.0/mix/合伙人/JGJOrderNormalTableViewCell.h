//
//  JGJOrderNormalTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJOrderNormalTableViewCell : UITableViewCell
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;

@property (strong, nonatomic) IBOutlet UILabel *serviceTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *detailLable;
@end
