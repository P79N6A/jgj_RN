//
//  JGJChatListOtherPicCell.h
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListOtherCell.h"

@class JGJChatListOtherPicCell;

@protocol JGJChatListOtherPicCellDelegate <NSObject>

@optional

- (void)chatListOtherPicCell:(JGJChatListOtherPicCell *)cell;

@end

@interface JGJChatListOtherPicCell : JGJChatListOtherCell

@property (nonatomic, weak) id <JGJChatListOtherPicCellDelegate> otherPicDelegate;

@end
