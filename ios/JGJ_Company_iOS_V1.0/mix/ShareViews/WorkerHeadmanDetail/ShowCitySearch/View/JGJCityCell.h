//
//  YZGCityCell.h
//  mix
//
//  Created by yj on 16/4/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCityModel.h"
@interface JGJCityCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JLGCityModel *cityModel;
@end
