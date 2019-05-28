//
//  JGJMsgSendAlertView.m
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMsgSendAlertView.h"
#import "JGJMsgSendContentView.h"
#import "JGJChatGroupListModel.h"

/** alertView宽度占据屏幕宽度比例 */
CGFloat const contentWidthRatio = 0.70;

@interface JGJMsgSendAlertView ()
@property (nonatomic, weak) UIButton *maskView;
@property (nonatomic, weak) JGJMsgSendContentView *contentView;
@property (nonatomic, assign) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic, strong) MASConstraint *contentViewCenterY;
@end

@implementation JGJMsgSendAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *maskView = [[UIButton alloc] init];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.75;
        [maskView addTarget:self action:@selector(maskClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:maskView];
        self.maskView = maskView;
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        JGJMsgSendContentView *contentView = [[JGJMsgSendContentView alloc] init];
        contentView.backgroundColor = AppFontffffffColor;
        [contentView.layer setLayerCornerRadius:5];
        [self addSubview:contentView];
        self.contentView = contentView;
        CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width * contentWidthRatio;
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            _contentViewCenterY = make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(contentWidth);
        }];
        
        // 监听按钮点击
        __weak typeof(self) weakSelf = self;
        contentView.ensureAction = ^{
            [weakSelf dismiss];
            if (weakSelf.ensureAction) {
                weakSelf.ensureAction();
            }
        };
        contentView.cancelAction = ^{
            [weakSelf dismiss];
            if (weakSelf.cancelAction) {
                weakSelf.cancelAction();
            }
        };
 
        contentView.textViewDidChange = ^(NSString *text){
            weakSelf.leftMessage = text;
        };
        
        // 监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {

    CGRect endFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat keyboardH = endFrame.size.height;
    CGFloat maxY = CGRectGetMaxY(self.contentView.frame);

    [_contentViewCenterY uninstall];
    CGFloat contentViewBottomH = (self.height - self.contentView.height) * 0.5;
    
    if (maxY > keyboardY) {
        contentViewBottomH = keyboardH + 10;
    }
    
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-contentViewBottomH);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}


- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
}
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)maskClicked
{
    [self dismiss];
}



#pragma mark - setter方法

- (void)setConversations:(NSArray<JGJChatGroupListModel *> *)conversations
{
    _conversations = conversations;
    self.contentView.conversations = conversations;
}

- (void)setMessage:(JGJChatMsgListModel *)message
{
    _message = message;
    self.contentView.message = message;
}

- (void)setShowSendNumber:(BOOL)showSendNumber
{
    _showSendNumber = showSendNumber;
    self.contentView.showSendNumber = showSendNumber;
}



@end
