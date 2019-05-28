//
//  JGJContactsDetailCallCell.h
//  mix
//
//  Created by yj on 16/6/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFHLeaderDetailModel.h"
#define BottomH 13
#define RowH 71
@interface JGJContactsDetailCallCell : UITableViewCell
@property (nonatomic, strong) FindResultModel *findResultModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
