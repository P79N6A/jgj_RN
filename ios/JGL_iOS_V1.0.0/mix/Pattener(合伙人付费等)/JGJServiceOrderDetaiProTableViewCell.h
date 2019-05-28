//
//  JGJServiceOrderDetaiProTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJServiceOrderDetaiProTableViewCell : UITableViewCell
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (strong, nonatomic) IBOutlet UILabel *proLable;

@end
