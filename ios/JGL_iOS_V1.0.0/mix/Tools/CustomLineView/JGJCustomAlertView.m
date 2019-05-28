//
//  JGJCustomAlertView.m
//  mix
//
//  Created by yj on 16/6/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCustomAlertView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"

@interface JGJCustomAlertView ()

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraintT;


@property (weak, nonatomic) IBOutlet UIButton *iknowButton;
@end
@implementation JGJCustomAlertView
static JGJCustomAlertView *alertView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 6;
    self.alertView.layer.masksToBounds = YES;
    self.confirmButton.backgroundColor = AppFontd7252cColor;
    self.message.font = [UIFont systemFontOfSize:AppFont30Size];
    self.message.textColor = AppFont666666Color;
    self.message.textAlignment = NSTextAlignmentLeft;
}

+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg {

    if(alertView && alertView.superview) [alertView removeFromSuperview];
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomAlertView" owner:self options:nil] lastObject];
    alertView.message.text = msg;
    [alertView.message setAttributedText:msg lineSapcing:8];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.message.preferredMaxLayoutWidth = 238;
    
    CGFloat height = [NSString stringWithContentWidth:238 content:msg font:AppFont30Size lineSpace:8] + 120;

    alertView.containViewHeight.constant = height;
    
    alertView.messageLabelTopConstraint.constant = 20;
    
    [window addSubview:alertView];
    
    return alertView;
}

+ (JGJCustomAlertView *)showMessageWithMsg:(NSString *)msg {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomAlertView" owner:self options:nil] lastObject];
    alertView.message.text = msg;
    
    [alertView.message setAttributedText:msg lineSapcing:8];
    
    return alertView;
}


+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor{
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomAlertView" owner:self options:nil] lastObject];
    alertView.message.text = msg;
    alertView.message.font = [UIFont systemFontOfSize:12.0];
    alertView.title.text= title;
    alertView.message.textColor = messageColor;
    alertView.title.textColor = titleColor;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.messageLabelTopConstraint.constant = 21;
    alertView.titleTopConstraintT.constant += 10;
    [window addSubview:alertView];
    return alertView;
}

+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor titleFontSize:(CGFloat )titleFontSize messageFontSize:(CGFloat )messageFontSize iknowFontSize:(CGFloat )iknowFontSize{
    
    alertView = [JGJCustomAlertView customAlertViewShowWithTitle:title message:msg titleColor:titleColor messageColor:messageColor];
    alertView.message.font = [UIFont systemFontOfSize:messageFontSize];
    alertView.title.font = [UIFont systemFontOfSize:titleFontSize];
    alertView.iknowButton.titleLabel.font = [UIFont systemFontOfSize:iknowFontSize];
    
    return alertView;
}
+ (JGJCustomAlertView *)customAlertViewShowWithMessagecallphone:(NSString *)msg {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomAlertView" owner:self options:nil] lastObject];
    [alertView.confirmButton setTitle:@"拨打客服电话" forState:UIControlStateNormal];
    alertView.message.text = msg;
    [alertView.message setAttributedText:msg lineSapcing:8];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.messageLabelTopConstraint.constant = 36;
    [window addSubview:alertView];
    return alertView;
}

+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg changeColorMsg:(NSString *)changeColorMsg {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomAlertView" owner:self options:nil] lastObject];
    alertView.message.text = msg;
    
    if (![NSString isEmpty:changeColorMsg]) {
        
        [alertView.message markText:changeColorMsg withColor:AppFontEB4E4EColor lineSpace:5 alignment:NSTextAlignmentLeft];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.messageLabelTopConstraint.constant = 12;
    [window addSubview:alertView];
    return alertView;
}

- (IBAction)didClickedButtonPressed:(UIButton *)sender {
    
    if (self.onClickedBlock) {
        self.onClickedBlock();
    }
    [self dismiss];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _alertView.transform = CGAffineTransformScale(_alertView.transform,0.9,0.9);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//2.0 和1.0发版前加上点击空白区域移除
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView==self) {
        
        if (self.touchDismissBlock) {
            
            self.touchDismissBlock();
        }
        [self dismiss];
    }
}

@end
