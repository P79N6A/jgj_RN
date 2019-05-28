//
//  JGJSelectedSuitDayConditionCell.h
//  mix
//
//  Created by yj on 16/6/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJSelectedSuitDayConditionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateStrLable;
@property (weak, nonatomic) IBOutlet UILabel *dateDetailLable;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
