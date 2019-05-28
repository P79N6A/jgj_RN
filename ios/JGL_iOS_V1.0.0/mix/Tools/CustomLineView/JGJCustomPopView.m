//
//  JGJCustomPopView.m
//  JGJCompany
//
//  Created by yj on 16/10/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCustomPopView.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"

static JGJCustomPopView *alertView;
@interface JGJCustomPopView ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;


@property (weak, nonatomic) IBOutlet UIView *bottomPaddingLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;

@property (weak, nonatomic) IBOutlet UIButton *onlineChatButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineChatButtonH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineChatButtonBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBottom;

@end


@implementation JGJCustomPopView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.cancelButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    self.TitleLable.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    self.TitleLable.textColor = AppFont666666Color;
    self.messageLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLable.textColor = AppFont666666Color;
    [self.confirmButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.messageLable.textAlignment = NSTextAlignmentCenter;
    
    [self.onlineChatButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.onlineChatButton.adjustsImageWhenHighlighted = NO;
    
    self.onlineChatButton.hidden = YES;
    
    self.onlineChatButtonH.constant = 0;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.onlineChatButton.titleLabel.text?:@""];
    
    NSRange strRange = {0,[str length]};
    
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    [self.onlineChatButton setAttributedTitle:str forState:UIControlStateNormal];
}

+ (JGJCustomPopView *)showWithMessage:(JGJShareProDesModel *)desModel {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    
    if (!alertView) {
        
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomPopView" owner:self options:nil] lastObject];
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
    
    if (![NSString isEmpty:desModel.title]) {
        
        alertView.TitleLable.text = desModel.title;
        
        alertView.titleLableTop.constant = desModel.titleLableTop > 5 ? desModel.titleLableTop : 25;
        
    }else {
        
        alertView.titleLableTop.constant = -10;
    }
    
    if (desModel.isHiddenLeftButton) {
        
        alertView.cancelButton.hidden = YES;
        
        alertView.cancelButtonW.constant = 0;
        
        alertView.bottomPaddingLineView.hidden = YES;

    }
    
    if (desModel.contentViewHeight > 0) {
        
        alertView.contentViewH.constant = desModel.contentViewHeight;
    }
    
    if (![NSString isEmpty:desModel.changeContent]) {
        
        [alertView.messageLable markLineText:desModel.changeContent withLineFont:[UIFont systemFontOfSize:AppFont28Size] withColor:AppFontEB4E4EColor lineSpace:desModel.lineSapcing];
        
        alertView.messageLable.textAlignment = desModel.popTextAlignment;
        
    }else if (desModel.changeContents.count > 0 && desModel.changeContentColor) {
        
        if (!desModel.messageFont) {
            
            desModel.messageFont = [UIFont systemFontOfSize:AppFont34Size];
        }
        
        [alertView.messageLable markattributedTextArray:desModel.changeContents color:desModel.changeContentColor font:desModel.messageFont isGetAllText:YES withLineSpacing:desModel.lineSapcing];
        
    }
    
    if (desModel.isShowOnlineChatButton) {
        
        alertView.onlineChatButton.hidden = !desModel.isShowOnlineChatButton;
        
    }
    
    if (desModel.onlineChatButtonH > 0) {
        
        alertView.onlineChatButtonH.constant = desModel.onlineChatButtonH;
        
    }
    
    if (alertView.messageBottom > 0) {
        
        alertView.messageBottom.constant = desModel.messageBottom;
    }
    
    if (desModel.titleFont) {
        
        alertView.TitleLable.font = desModel.titleFont;
    }
    
    if (desModel.messageFont) {
        
        alertView.messageLable.font = desModel.messageFont;
    }
    
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

- (void)setIsNotTouchViewHide:(BOOL)isNotTouchViewHide {
    
    _isNotTouchViewHide = isNotTouchViewHide;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView == self) {
        
        if (!_isNotTouchViewHide) {
            
//            [alertView dismissWithBlcok:nil];
            [alertView dismissWithBlcok:alertView.touchDismissBlock];
        }
        
    }
}

@end
