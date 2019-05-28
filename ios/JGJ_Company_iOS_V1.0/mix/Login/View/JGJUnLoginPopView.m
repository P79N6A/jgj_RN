//
//  JGJUnLoginPopView.m
//  JGJCompany
//
//  Created by yj on 16/10/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUnLoginPopView.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJUnLoginPopView ()
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *popImageView;
@end

@implementation JGJUnLoginPopView

static JGJUnLoginPopView *popView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.layer.cornerRadius = 6;
    self.popView.layer.masksToBounds = YES;
    self.confirmButton.backgroundColor = AppFontd7252cColor;
    self.message.font = [UIFont systemFontOfSize:AppFont30Size];
    self.message.textColor = AppFont666666Color;
    self.message.textAlignment = NSTextAlignmentCenter;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

+ (JGJUnLoginPopView *)popViewImageStr:(NSString *)imageStr  popMessage:(NSString *)popMessage buttonTitle:(NSString *)buttonTitle {

    if(popView && popView.superview) [popView removeFromSuperview];
    popView = [[[NSBundle mainBundle] loadNibNamed:@"JGJUnLoginPopView" owner:self options:nil] lastObject];
    if (![NSString isEmpty:popMessage]) {
        popView.message.text = popMessage;
    }
    if (![NSString isEmpty:imageStr]) {
        popView.popImageView.image = [UIImage imageNamed:imageStr];
    }
    if (![NSString isEmpty:buttonTitle]) {
        [popView.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    popView.frame = window.bounds;
    [window addSubview:popView];
    [popView.message setAttributedText:popMessage lineSapcing:4.0];
    popView.message.textAlignment = NSTextAlignmentCenter;
    return popView;
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
        _popView.transform = CGAffineTransformScale(_popView.transform,0.9,0.9);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
