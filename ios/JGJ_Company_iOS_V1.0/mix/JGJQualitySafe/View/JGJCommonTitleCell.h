//
//  JGJCommonTitleCell.h
//  mix
//
//  Created by yj on 2018/1/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJCommonTitleCell : UITableViewCell

@property (nonatomic, strong) JGJCreatTeamModel *desModel;

@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制字体与控件边界的间隙

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
