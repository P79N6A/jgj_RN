//
//  JGJChatWorkSendBusinessCardCell.h
//  mix
//
//  Created by ccclear on 2019/3/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGJChatWorkSendBusinessCardCell;

@protocol JGJChatWorkSendBusinessCardCelldelegate <NSObject>

- (void)sendBusinessCardMsgWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendBusinessCardCell *)cell;
- (void)gotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendBusinessCardCell *)cell;

@end
@interface JGJChatWorkSendBusinessCardCell : UITableViewCell

@property (nonatomic, strong) JGJChatMsgListModel *chatListModel;
@property (nonatomic, weak) id<JGJChatWorkSendBusinessCardCelldelegate> delegate;


@end

NS_ASSUME_NONNULL_END
