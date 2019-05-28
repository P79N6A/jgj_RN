//
//  JGJChatNoticeCell.h
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYInputView.h"
#import "JGJChatListType.h"

@class JGJChatNoticeCell;

@protocol JGJChatNoticeCellDelegate <NSObject>
@optional
- (void)cellHChanged:(JGJChatNoticeCell *)cell cellH:(CGFloat )cellH;

- (void)textChange:(JGJChatNoticeCell *)cell text:(NSString *)text;

- (void)textReturn:(JGJChatNoticeCell *)cell text:(NSString *)text;

- (void)textChange:(JGJChatNoticeCell *)cell text:(NSString *)text lastText:(NSString *)lastText;
@end

@interface JGJChatNoticeCell : UITableViewCell

@property (nonatomic , weak) id<JGJChatNoticeCellDelegate> delegate;

@property (nonatomic,assign) CGFloat cellH;//返回的外部的cell高度

@property (weak, nonatomic) IBOutlet TYInputView *inputView;

@property (nonatomic,assign) JGJChatListType chatListType;
@end
