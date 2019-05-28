//
//  JGJMeIndentTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMeIndentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumLable;
@property (strong, nonatomic) IBOutlet UILabel *proNameLable;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *goodsTypeLable;
@property (strong, nonatomic) IBOutlet UILabel *goodsSalaryLable;
@property (strong, nonatomic) IBOutlet UILabel *totalSalaryLable;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) JGJOrderListModel *model;
@end
