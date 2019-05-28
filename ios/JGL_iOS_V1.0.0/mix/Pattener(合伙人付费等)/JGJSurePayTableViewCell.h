//
//  JGJSurePayTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSurePayTableViewCell : UITableViewCell
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (strong, nonatomic) IBOutlet UILabel *discountsLable;
@property (strong, nonatomic) IBOutlet UILabel *salaryLable;
@property (strong, nonatomic) IBOutlet UIButton *payButton;

@end
