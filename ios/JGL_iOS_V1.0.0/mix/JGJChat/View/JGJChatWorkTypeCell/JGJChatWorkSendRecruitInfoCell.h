//
//  JGJChatWorkSendRecruitInfoCell.h
//  mix
//
//  Created by ccclear on 2019/3/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGJChatWorkSendRecruitInfoCell;

@protocol JGJChatWorkSendRecruitInfoCelldelegate <NSObject>

- (void)sendRecruitInfoMsgWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendRecruitInfoCell *)cell;
- (void)recruitCellGotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendRecruitInfoCell *)cell;
@end

@interface JGJChatWorkSendRecruitInfoCell : UITableViewCell
@property (nonatomic, strong) JGJChatMsgListModel *chatListModel;
@property (nonatomic, weak) id<JGJChatWorkSendRecruitInfoCelldelegate> delegate;


@end

NS_ASSUME_NONNULL_END
