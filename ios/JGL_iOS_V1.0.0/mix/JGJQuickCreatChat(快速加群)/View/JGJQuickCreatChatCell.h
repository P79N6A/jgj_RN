//
//  JGJQuickCreatChatCell.h
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJQuickCreatChatModel.h"

@class JGJQuickCreatChatCell;

@protocol JGJQuickCreatChatCellDelegate<NSObject>

@optional

- (void)quickCreatChatCell:(JGJQuickCreatChatCell *)cell chatListModel:(JGJQuickCreatChatListModel *)chatListModel;

@end

@interface JGJQuickCreatChatCell : UITableViewCell

@property (nonatomic, strong) JGJQuickCreatChatListModel *chatListModel;

@property (nonatomic, weak) id <JGJQuickCreatChatCellDelegate>delegate;

@property (weak, nonatomic,readonly) IBOutlet NSLayoutConstraint *lineLeading;

@end
