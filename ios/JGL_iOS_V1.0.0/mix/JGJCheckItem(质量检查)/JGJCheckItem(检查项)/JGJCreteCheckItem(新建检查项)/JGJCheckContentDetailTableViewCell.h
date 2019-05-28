//
//  JGJCheckContentDetailTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckContentDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (nonatomic ,strong) JGJCheckItemListDetailListModel *model;
@end
