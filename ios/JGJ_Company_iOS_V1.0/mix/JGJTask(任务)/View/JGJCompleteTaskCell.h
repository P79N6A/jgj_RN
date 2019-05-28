//
//  JGJCompleteTaskCell.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

@class JGJCompleteTaskCell;

typedef void(^HandleCompleteTaskCellBlock)(JGJCompleteTaskCell *);

@interface JGJCompleteTaskCell : UITableViewCell

@property (nonatomic, strong) JGJTaskModel *taskModel;

@property (nonatomic, copy) HandleCompleteTaskCellBlock handleCompleteTaskCellBlock;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
