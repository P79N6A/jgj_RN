//
//  JGJPaySuccesViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/8/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJPaySuccesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *popButton;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic)  NSString  *trade_no;
@property (strong, nonatomic) IBOutlet UILabel *firstLable;
@property (strong, nonatomic) IBOutlet UILabel *secondLable;
@property (strong, nonatomic) IBOutlet UILabel *telLable;
@property (strong, nonatomic)  JGJOrderListModel  *orderListmodel;

@end
