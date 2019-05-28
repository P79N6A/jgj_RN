//
//  JGJOrderCopyTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJOrderCopyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumlable;
@property (strong, nonatomic) IBOutlet UIButton *CopyOrderNButton;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;

@end
