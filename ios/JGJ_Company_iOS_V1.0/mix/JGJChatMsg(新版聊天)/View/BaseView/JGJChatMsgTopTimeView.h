//
//  JGJChatMsgTopTimeView.h
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJChatMsgTopTimeView;

@protocol JGJChatMsgTopTimeViewDelegate<NSObject>

@optional

- (void)chatMsgTopTimeView:(JGJChatMsgTopTimeView *)topTimeView chatMsgModel:(JGJChatMsgListModel *)chatMsgModel;

@end

@interface JGJChatMsgTopTimeView : UIView

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (nonatomic, weak) id <JGJChatMsgTopTimeViewDelegate> delegate;

@end
