//
//  PayPasswordAlertView.m
//  MarketEleven
//
//  Created by Bergren Lam on 12/22/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView+GNUtil.h"

@interface CustomAlertView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *contentButtonView;
@property (weak, nonatomic) IBOutlet UILabel *showSuccessLable;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oKButtonW;
@property (weak, nonatomic) IBOutlet YLImageView *stateImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateImageViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *succcessLableTop;
@property (weak, nonatomic) IBOutlet UIView *paddingLineView;

@property (weak, nonatomic) IBOutlet UIButton *middleButton;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;


@end

@implementation CustomAlertView

static CustomAlertView *alertView;

- (void)dealloc {
    
}

- (void)showSuccessImageView {

    self.stateImageViewTop.constant = 25;
    self.succcessLableTop.constant = 10;
    self.stateImageViewW.constant = 60;
    self.stateImageViewH.constant = 60;
    self.contentButtonView.backgroundColor = AppFontd7252cColor;
    self.cancelButton.backgroundColor = AppFontd7252cColor;
    self.okButton.height = 40;
    self.oKButtonW.constant = TYGetViewW(self.contentButtonView);
    self.cancelButton.hidden = YES;
    [self.okButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lineView.hidden = YES;
    self.messageLabel.hidden = YES;
    self.paddingLineView.hidden = YES;
    self.stateImageView.hidden = NO;
    self.showSuccessLable.hidden = NO;
    self.okButton.hidden = NO;
    self.contentButtonView.hidden = NO;
    self.showSuccessLable.text = @"祝贺,  同步成功 !";
    self.showSuccessLable.textColor = AppFont666666Color;
    self.stateImageView.image = [UIImage imageNamed:@"SuccessIcon"];
}

- (void)didCancelButttonShowMessage:(NSString *)message {
    self.okButton.hidden = NO;
    self.paddingLineView.hidden = YES;
    self.lineView.hidden = YES;
    self.cancelButton.hidden = YES;
    self.contentButtonView.backgroundColor = AppFontd7252cColor;
    self.cancelButton.backgroundColor = AppFontd7252cColor;
    self.oKButtonW.constant = TYGetViewW(self.contentButtonView);
    [self.okButton setTitle:message forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.onOkBlock) {
      self.onOkBlock();   
    }
}

- (void)showProgressImageView {
    [self showProgressImageView:@"正在同步..."];
}

- (void)showProgressImageView:(NSString *)text{
    self.stateImageViewW.constant = TYGetViewW(self.contentView) - 60;
    self.stateImageViewH.constant = 8;
    self.stateImageViewTop.constant = 70;
    self.succcessLableTop.constant = 28;
    self.contentButtonView.hidden = YES;
    self.messageLabel.hidden = YES;
    self.lineView.hidden = YES;
    self.stateImageView.hidden = NO;
    self.showSuccessLable.hidden = NO;
    self.stateImageView.image = [YLGIFImage imageNamed:@"progressIcon.gif"];
    self.showSuccessLable.text = text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    [self.cancelButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    self.okButton.layer.cornerRadius = 4;
    self.okButton.clipsToBounds = YES;
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    [self.okButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    self.tipLabel.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    self.tipLabel.textColor = AppFont666666Color;
    self.messageLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLabel.textColor = AppFont666666Color;
    self.messageLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.messageLabel.textColor = AppFont666666Color;
    self.showSuccessLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.showSuccessLable.textColor = AppFontd7252cColor;
    self.stateImageView.hidden = YES;
    self.showSuccessLable.hidden = YES;
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    
}

+ (instancetype)customAlertView {

    return  [[[NSBundle mainBundle] loadNibNamed:@"CustomAlertView" owner:self options:nil] lastObject];
}

+ (CustomAlertView *)showWithMessage:(NSString *)msg   leftButtonTitle:(NSString *)lt midButtonTitle:(NSString *)title rightButtonTitle:(NSString *)rt {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];

    if (!alertView) {
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"CustomAlertView" owner:self options:nil] lastObject];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    [window addSubview:alertView];
    
    if (title.length != 0 && title != nil) {
        
        alertView.middleButton.hidden = NO;
        [alertView.middleButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [alertView.middleButton setTitle:title forState:UIControlStateNormal];
    }
    
    if (rt.length > 0 && lt == nil) {
        [alertView didCancelButttonShowMessage:rt];
    }
    
    [alertView.messageLabel setAttributedText:msg lineSapcing:8];
    [alertView.cancelButton setTitle:lt forState:UIControlStateNormal];
    [alertView.okButton setTitle:rt forState:UIControlStateNormal];
    alertView.stateImageView.hidden = YES;
    alertView.messageLabel.hidden = NO;

    if (!rt) {
        alertView.middleButton.hidden = NO;
        alertView.okButton.hidden = YES;
        alertView.cancelButton.hidden = YES;

    }
    
    if (rt && lt) {
        
        alertView.cancelButton.hidden = NO;
        alertView.okButton.hidden = NO;
        alertView.middleButton.hidden = YES;
    }
    
    CGSize s = [alertView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [alertView.contentView resetHeightConstraint:s.height];
    [alertView layoutIfNeeded];
    
    return alertView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;
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

+(void)dismiss{
    [alertView dismissWithBlcok:nil];
}

- (IBAction)onCancelButton:(id)sender {
    [self dismissWithBlcok:nil];
}
- (IBAction)onOkButton:(id)sender {
    [self dismissWithBlcok:alertView.onOkBlock];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self removeFromSuperview];
//}

@end
