//
//  JGJSerViceTimeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSerViceTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong , nonatomic)JGJSureOrderListModel *orderModel;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UILabel *deaTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *desLable;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (strong, nonatomic) IBOutlet UILabel *deslable;

@end
