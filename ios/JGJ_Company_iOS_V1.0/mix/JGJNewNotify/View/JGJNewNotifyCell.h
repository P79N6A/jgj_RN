//
//  JGJNewNotifyCell.h
//  mix
//
//  Created by yj on 16/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@protocol JGJNewNotifyCellDelegate <NSObject>
- (void)handleJGJNewNotifyCellNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType;
@end
@interface JGJNewNotifyCell : UITableViewCell
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@property (nonatomic, weak) id <JGJNewNotifyCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
