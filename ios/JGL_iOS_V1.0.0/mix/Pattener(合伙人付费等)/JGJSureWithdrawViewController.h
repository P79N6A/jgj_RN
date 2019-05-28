//
//  JGJSureWithdrawViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSureWithdrawViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) JGJAccountListModel *AccountListModel;
@property (strong, nonatomic) JGJOrderListModel *orderListModel;

@end
