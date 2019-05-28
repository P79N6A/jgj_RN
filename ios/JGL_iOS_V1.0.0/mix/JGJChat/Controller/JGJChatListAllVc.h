//
//  JGJChatListAllVc.h
//  mix
//
//  Created by Tony on 2016/8/31.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"
//底部输入相关
#import "JGJChatInputView.h"
#import "JGJChatBootomView.h"

@interface JGJChatListAllVc : JGJChatListBaseVc

@property (nonatomic,assign) CGFloat bottomRootViewOldH;//记录初始的高度

@property (nonatomic,assign) CGFloat bottomRootViewAddH;//记录初始的高度

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet JGJChatInputView *chatInputView;

//底部显示通知，质量等的View
@property (weak, nonatomic) IBOutlet JGJChatBootomView *chatBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomRootViewConstraintH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraintB;

- (void)chatListKeyboardDidShowFrame:(NSNotification *)notification;
@end
