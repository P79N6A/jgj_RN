//
//  JGJCustomProInfoAlertVIew.m
//  mix
//
//  Created by yj on 16/10/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCustomProInfoAlertVIew.h"
#import "TYPhone.h"
#import "UILabel+GNUtil.h"

@interface JGJCustomProInfoAlertVIew ()
@property (nonatomic, strong) JGJCustomProInfoAlertVIew *alertView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *telphone;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *containTelView;
@property (weak, nonatomic) IBOutlet UIView *contailDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDetailViewHeight;
@end

@implementation JGJCustomProInfoAlertVIew

static JGJCustomProInfoAlertVIew *alertView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.masksToBounds = YES;
    [self.containTelView.layer setLayerCornerRadius:10.0];
    [self.contailDetailView.layer setLayerCornerRadius:5.0];
}

+ (JGJCustomProInfoAlertVIew *)alertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCustomProInfoAlertVIew" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    alertView.messageLable.text = commonModel.alertmessage;
    alertView.name.text = commonModel.teamModelModel.name;
    alertView.telphone.text = commonModel.teamModelModel.telphone;
    [alertView.messageLable setAttributedText:alertView.messageLable.text lineSapcing:4.0];
    alertView.messageLable.textAlignment = commonModel.alignment;
    if (commonModel.alertViewHeight > 0) {
        alertView.containDetailViewHeight.constant = commonModel.alertViewHeight;
    }
    [window addSubview:alertView];
    return alertView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (IBAction)handleConfirmButtonPressed:(UIButton *)sender {
    [self dismiss];
    
    if (self.confirmButtonBlock) {
        
        self.confirmButtonBlock();
    }
    
//    [TYPhone callPhoneByNum:alertView.telphone.text view:self];
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
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

@end