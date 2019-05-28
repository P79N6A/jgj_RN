//
//  JGJChatAskSynCell.h
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgBaseCell.h"

@class JGJChatSynInfoCell;

@protocol JGJChatSynInfoCellDelegate<NSObject>

@optional

- (void)chatSynInfoCell:(JGJChatSynInfoCell *)cell btnType:(JGJChatSynBtnType)btnType;

@end

@interface JGJChatSynInfoCell : JGJChatMsgBaseCell

@property (nonatomic, weak) id <JGJChatSynInfoCellDelegate> synCellDelegate;

@property (nonatomic, strong) JGJChatMsgListModel *msgModel;

@end
