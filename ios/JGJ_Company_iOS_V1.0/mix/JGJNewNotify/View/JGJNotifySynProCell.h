//
//  JGJNotifySynProCell.h
//  mix
//
//  Created by yj on 2018/4/28.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJNotifySynProCellDelegate <NSObject>

- (void)handleSynProCellNotifyModel:(JGJNewNotifyModel *)notifyModel buttonType:(NotifyCellButtonType)buttonType;

@end

@interface JGJNotifySynProCell : UITableViewCell

@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;

@property (nonatomic, weak) id <JGJNotifySynProCellDelegate> delegate;

/** 点击按钮之后系统消息高度缩减，隐藏底部按钮 */

+ (CGFloat)synCellShinkHeightWithNotifyModel:(JGJNewNotifyModel *)notifyModel;

@end
