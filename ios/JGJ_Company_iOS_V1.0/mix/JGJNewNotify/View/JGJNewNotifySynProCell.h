//
//  JGJNewNotifySynProCell.h
//  JGJCompany
//
//  Created by yj on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
typedef enum : NSUInteger {
    JGJNewNotifySynProCreatTeamType, //创建项目组
    JGJNewNotifySynProJoinTeamType, //加入现有项目组
    JGJNewNotifySynProDelTeamType //删除项目组
} JGJNewNotifySynProCellButtonType;

@class JGJNewNotifySynProCell;
@protocol JGJNewNotifySynProCellDelegate <NSObject>
@optional
- (void)handleNewNotifySynProCellNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(JGJNewNotifySynProCellButtonType)buttonType;
@end
@interface JGJNewNotifySynProCell : UITableViewCell
@property (nonatomic, weak) id <JGJNewNotifySynProCellDelegate> delegate;
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
