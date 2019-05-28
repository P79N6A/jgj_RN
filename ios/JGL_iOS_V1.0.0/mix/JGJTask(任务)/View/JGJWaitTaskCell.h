//
//  JGJWaitTaskCell.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

#import "JGJQualityMsgListImageView.h"

@class JGJWaitTaskCell;

typedef void(^HandleWaitTaskCellBlock)(JGJWaitTaskCell *);

@interface JGJWaitTaskCell : UITableViewCell

@property (nonatomic, strong) JGJTaskModel *taskModel;

@property (nonatomic, copy) HandleWaitTaskCellBlock handleWaitTaskCellBlock;

@end
