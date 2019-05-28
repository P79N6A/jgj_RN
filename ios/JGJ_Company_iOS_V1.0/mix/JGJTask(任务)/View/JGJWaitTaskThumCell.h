//
//  JGJWaitTaskThumCell.h
//  JGJCompany
//
//  Created by yj on 2017/6/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

#import "JGJWaitTaskCell.h"

@class JGJWaitTaskThumCell;

typedef void(^HandleWaitTaskThumCellBlock)(JGJWaitTaskThumCell *);

@interface JGJWaitTaskThumCell : UITableViewCell

@property (nonatomic, copy) HandleWaitTaskThumCellBlock handleWaitTaskThumCellBlock;

@property (nonatomic, strong) JGJTaskModel *taskModel;

@end
