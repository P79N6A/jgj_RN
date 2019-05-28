//
//  JGJBaseOutMsgView.h
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJChatMsgTopTimeView.h"

#import "JGJCusYyLable.h"

#define ChatPadding 10

#define ChatHeadWH 40

#define PopViewY 28

@class JGJBaseOutMsgView;

@protocol JGJBaseOutMsgViewDelegate<NSObject>

@optional

- (void)baseMsgView:(JGJBaseOutMsgView *)baseMsgView msgModel:(JGJChatMsgListModel *)msgModel;

@end

@interface JGJBaseOutMsgView : UIView

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *contentLabel;

//@property (weak, nonatomic) IBOutlet JGJChatMsgTopTimeView *timeView;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) UIImageView *sendFailureImageView;

@property (strong, nonatomic)  UIImageView *popImageView;

@property (strong, nonatomic) JGJCusYyLable *date;

@property (strong, nonatomic) JGJChatMsgTopTimeView *topTimeView;

@property (strong, nonatomic) UIView *containView;

@property (weak, nonatomic) id <JGJBaseOutMsgViewDelegate> delegate;

@end
