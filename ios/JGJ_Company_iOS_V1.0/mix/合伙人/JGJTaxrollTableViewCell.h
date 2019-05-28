//
//  JGJTaxrollTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTaxrollTableViewCell : UITableViewCell
@property (strong, nonatomic) JGJAccountListModel *model;
@property (strong, nonatomic) IBOutlet UILabel *moneyDeslable;
@property (strong, nonatomic) IBOutlet UILabel *MymoneyLable;

@end
