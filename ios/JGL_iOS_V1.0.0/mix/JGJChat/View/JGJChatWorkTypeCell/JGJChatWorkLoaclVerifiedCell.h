//
//  JGJChatWorkLoaclVerifiedCell.h
//  mix
//
//  Created by ccclear on 2019/4/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJChatWorkLoaclVerifiedCell;

@protocol JGJChatWorkLoaclVerifiedCelldelegate <NSObject>

- (void)loaclVerifiedCellGotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkLoaclVerifiedCell *)cell;
@end

@interface JGJChatWorkLoaclVerifiedCell : UITableViewCell
@property (nonatomic, strong) JGJChatMsgListModel *chatListModel;

@property (nonatomic, weak) id<JGJChatWorkLoaclVerifiedCelldelegate> delegate;

@end

