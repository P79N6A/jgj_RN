//
//  JGJFreshFriendListCell.h
//  mix
//
//  Created by yj on 17/2/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "SWTableViewCell.h"
#import "CustomView.h"

@class JGJFreshFriendListCell;
@protocol JGJFreshFriendListCellDelegate <NSObject>
- (void)JGJFreshFriendListWithCell:(JGJFreshFriendListCell *)cell didSelectedFriendListModel:(JGJFreshFriendListModel *)friendListModel;
@end

@interface JGJFreshFriendListCell : SWTableViewCell
@property (nonatomic, strong) JGJFreshFriendListModel *friendListModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) id <JGJFreshFriendListCellDelegate> friendListCellDelegate;
@end
