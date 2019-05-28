//
//  JGJCheckContentDetailListTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckContentDetailListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) JGJCheckItemListDetailListModel *model;

@end
