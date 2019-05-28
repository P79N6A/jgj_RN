//
//  JGJTaskLevelSelCell.h
//  mix
//
//  Created by yj on 2017/6/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

#import "CustomView.h"

@interface JGJTaskLevelSelCell : UITableViewCell

@property (nonatomic, strong) JGJTaskLevelSelModel *taskLevelSelModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;


@end
