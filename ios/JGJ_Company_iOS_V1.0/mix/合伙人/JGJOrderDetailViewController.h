//
//  JGJOrderDetailViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJOrderDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;
@property (strong ,nonatomic) NSString *trade_no;//订单号

@end
