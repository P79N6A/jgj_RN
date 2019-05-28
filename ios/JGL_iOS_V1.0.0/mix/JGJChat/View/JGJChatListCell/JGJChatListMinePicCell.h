//
//  JGJChatListMinePicCell.h
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseCell.h"

@class JGJChatListMinePicCell;

@protocol JGJChatListMinePicCellDelegate <NSObject>

@optional

- (void)chatListMinePicCell:(JGJChatListMinePicCell *)cell;

@end

@interface JGJChatListMinePicCell : JGJChatListBaseCell

@property (nonatomic, weak) id <JGJChatListMinePicCellDelegate> picCellDelegate;

@end
