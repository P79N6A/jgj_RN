//
//  JGJSearchCityCell.h
//  mix
//
//  Created by celion on 16/4/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCityModel.h"
@interface JGJSearchCityCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JLGCityModel *cityModel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
