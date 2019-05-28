//
//  JGJCusAlertView.m
//  mix
//
//  Created by yj on 17/3/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusAlertView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
static JGJCusAlertView *alertView;
@interface JGJCusAlertView ()

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

@end

@implementation JGJCusAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.leftButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    
    self.contentView.layer.cornerRadius = JGJCornerRadius;
    self.contentView.layer.masksToBounds = YES;
    
    self.messageLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLable.textColor = AppFont666666Color;
    
    [self.rightButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLable.textAlignment = NSTextAlignmentLeft;
    self.messageLable.text = @"记账成功\n永不丢失，随时查看！";
    
    // 判断登陆身份,工人身份 左侧按钮文字未再记一笔，右侧为返回上级，班组长身份保持原来不变，3.1.0v cc改变
    if (JLGisMateBool) {
        [self.leftButton setTitle:@"再记一笔" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [self.rightButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    int index = arc4random()%3;
    switch (index) {
        case 0:
            _desTitleLable.text = @">别忘去积分商城免费抽大奖<";

            break;
        case 1:
            _desTitleLable.text = @">记得推荐给身边的工友<";

            break;
        case 2:
            _desTitleLable.text = @">没事儿去工友圈逛逛吧<";

            break;


        default:
            break;
    }
}


+ (JGJCusAlertView *)cusAlertViewShowWithDesModel:(JGJShareProDesModel *)desModel {

    if(alertView && alertView.superview) [alertView removeFromSuperview];
    if (!alertView) {
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCusAlertView" owner:self options:nil] lastObject];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    alertView.frame = window.bounds;
    
    if (![NSString isEmpty:desModel.popDetail]) {
        alertView.messageLable.text = desModel.popDetail;
    }
    
    if (desModel.lineSapcing > 0) {
        [alertView.messageLable setAttributedText:alertView.messageLable.text lineSapcing:desModel.lineSapcing];
    }
    if (![NSString isEmpty:desModel.leftTilte]) {
        [alertView.leftButton setTitle:desModel.leftTilte forState:UIControlStateNormal];
    }
    if (![NSString isEmpty:desModel.rightTilte]) {
        [alertView.rightButton setTitle:desModel.rightTilte forState:UIControlStateNormal];
    }
    if (desModel.popTextAlignment == 0) {
        alertView.messageLable.textAlignment = desModel.popTextAlignment;
    }
    
    if (desModel.contentViewHeight > 0) {
        alertView.contentViewH.constant = desModel.contentViewHeight;
    }
    
    
    [window addSubview:alertView];

    return alertView;
}

- (IBAction)handleLeftButtonPressedAction:(UIButton *)sender {
    
    if (self.customLeftButtonAlertViewBlock) {
//        self.customAlertViewBlock();
        [self dismissWithBlcok:self.customLeftButtonAlertViewBlock];
    }
    
}


- (IBAction)handleRightButtonPressedAction:(UIButton *)sender {
    if (self.customRightButtonAlertViewBlock) {
        [self dismissWithBlcok:self.customRightButtonAlertViewBlock];
    }
}

- (void)dismissWithBlcok:(void (^)())block {
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

@end
