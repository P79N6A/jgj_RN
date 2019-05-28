//
//  JGJNewHomeViewController.h
//  mix
//
//  Created by Tony on 2019/3/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBaseViewController.h"

typedef enum : NSUInteger {
    
    JYSlideSegmentTinyAndContractControlllerType,// 点工 考勤 包工记账
    YZGMateWorkitemsViewControllerType,// 每日考勤
    JYSlideSegmentBorrowAndCloseCountControlllerType,// 借支 结算
    JGJTeamWorkListViewControllerType,// 记多人选择项目列表
    JGJMoreDayViewControllerType// 记多天
    
} SelectedViewControllerType;

@interface JGJNewHomeViewController : JGJBaseViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@property (nonatomic, assign) SelectedViewControllerType selectedControllerType;
- (void)updateRoleInfo;

- (void)dealTabbarUnreadMessageCount;
@end
