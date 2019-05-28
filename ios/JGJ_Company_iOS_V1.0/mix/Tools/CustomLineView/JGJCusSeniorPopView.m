//
//  JGJCusSeniorPopView.m
//  mix
//
//  Created by yj on 2018/1/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusSeniorPopView.h"

#import "UILabel+GNUtil.h"

static JGJCusSeniorPopView *alertView;

@interface JGJCusSeniorPopView ()

@property (weak, nonatomic) IBOutlet UIButton *seniorServiceButton;

@property (weak, nonatomic) IBOutlet UILabel *messageLable;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *onlineChatButton;

@end

@implementation JGJCusSeniorPopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.cancelButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    self.messageLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLable.textColor = AppFont666666Color;
    [self.confirmButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.messageLable.textAlignment = NSTextAlignmentCenter;
    
    [self.onlineChatButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.onlineChatButton.adjustsImageWhenHighlighted = NO;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.onlineChatButton.titleLabel.text?:@""];
    
    NSRange strRange = {0,[str length]};
    
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    [self.onlineChatButton setAttributedTitle:str forState:UIControlStateNormal];
}

+ (JGJCusSeniorPopView *)showWithMessage:(JGJShareProDesModel *)desModel {
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    if (!alertView) {
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCusSeniorPopView" owner:self options:nil] lastObject];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.messageLable.text = desModel.popDetail;
    if (desModel.lineSapcing > 0) {
        [alertView.messageLable setAttributedText:alertView.messageLable.text lineSapcing:desModel.lineSapcing];
    }
    if (![NSString isEmpty:desModel.leftTilte]) {
        [alertView.cancelButton setTitle:desModel.leftTilte forState:UIControlStateNormal];
    }
    if (![NSString isEmpty:desModel.rightTilte]) {
        [alertView.confirmButton setTitle:desModel.rightTilte forState:UIControlStateNormal];
    }
    if (desModel.popTextAlignment > 0) {
        alertView.messageLable.textAlignment = desModel.popTextAlignment;
    }
    
    if (![NSString isEmpty:desModel.changeContent]) {
        
        [alertView.messageLable markLineText:desModel.changeContent withLineFont:[UIFont systemFontOfSize:AppFont28Size] withColor:AppFontEB4E4EColor lineSpace:desModel.lineSapcing];
        
        alertView.messageLable.textAlignment = desModel.popTextAlignment;
    }
    
    alertView.seniorServiceButton.hidden = !desModel.isShowTitle;

    [window addSubview:alertView];
    
    return alertView;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    
    [alertView dismissWithBlcok:alertView.leftButtonBlock];
    
}

- (IBAction)handleOkButtonAction:(UIButton *)sender {
    
    [self dismissWithBlcok:alertView.onOkBlock];
    
}

#pragma mark - 在线聊天按钮按下
- (IBAction)handleOnleChatButtonPressed:(UIButton *)sender {
    
    [alertView dismissWithBlcok:nil];
    
    if (self.onlineChatButtonBlock) {
        
        self.onlineChatButtonBlock();
    }
    
}

- (IBAction)seniorServiceInfoPressed:(UIButton *)sender {
    
    if (self.seniorServiceInfoBlock) {
        
        self.seniorServiceInfoBlock();
    }
    
    [alertView dismissWithBlcok:nil];
}


- (void)dismissWithBlcok:(void (^)(void))block {
    [UIView animateWithDuration:0.2 animations:^{
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [alertView removeFromSuperview];
        alertView = nil;
        if (block) {
            block();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView==self) {
        [alertView dismissWithBlcok:nil];
    }
}

@end
