//
//  JGJUpgradeGroupCell.h
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@class JGJUpgradeGroupCell;
@protocol JGJUpgradeGroupCellDelegate <NSObject>

@optional
- (void)upgradeGroupCell:(JGJUpgradeGroupCell *)cell upgradeGroupModel:(JGJCreatTeamModel *)upgradeGroupModel;
@end

@interface JGJUpgradeGroupCell : UITableViewCell
@property (nonatomic, strong) JGJCreatTeamModel *upgradeGroupModel;
@property (weak, nonatomic) id <JGJUpgradeGroupCellDelegate> delegate;
+ (CGFloat)upgradeGroupCellHeight;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
