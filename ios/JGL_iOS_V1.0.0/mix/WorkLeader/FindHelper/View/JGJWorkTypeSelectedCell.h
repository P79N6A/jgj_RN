//
//  JGJWorkTypeSelectedCell.h
//  mix
//
//  Created by celion on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFHLeaderModel.h"

typedef void(^BlockWorkTypeModel)(FHLeaderWorktype *);
@interface JGJWorkTypeSelectedCell : UITableViewCell
@property (nonatomic, strong) FHLeaderWorktype *workTypeModel;
@property (nonatomic, copy) BlockWorkTypeModel blockWorkTypeModel;
@property (nonatomic, assign) BOOL isSelected;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
