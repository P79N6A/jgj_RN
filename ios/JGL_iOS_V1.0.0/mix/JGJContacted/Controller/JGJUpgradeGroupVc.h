//
//  JGJUpgradeGroupVc.h
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJUpgradeGroupVc;
@protocol JGJUpgradeGroupVcDelegate <NSObject>

@optional
- (void)upgradeGroupVc:(JGJUpgradeGroupVc *)upgradeGroupVc upgrageGroupModel:(JGJCreatTeamModel *)upgrageGroupModel;
@end
@interface JGJUpgradeGroupVc : UIViewController
@property (weak, nonatomic) id <JGJUpgradeGroupVcDelegate> delegate;
@property (copy ,nonatomic) NSString *nameStr;
@end
