//
//  JGJChatListOtherCell.h
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseCell.h"

@protocol JGJChatListOtherCellDelegate <NSObject>
@optional
- (void)playAudioEnd:(NSIndexPath *)indexPath chatListModel:(JGJChatMsgListModel *)chatListModel;

- (void)playAudioBegin:(NSIndexPath *)indexPath chatListModel:(JGJChatMsgListModel *)chatListModel;
@end

@interface JGJChatListOtherCell : JGJChatListBaseCell

@property (nonatomic , weak) id<JGJChatListOtherCellDelegate > otherCellDelegate;

@end
