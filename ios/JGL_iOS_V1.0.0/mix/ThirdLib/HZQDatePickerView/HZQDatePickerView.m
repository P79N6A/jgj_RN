//
//  HZQDatePickerView.m
//  HZQDatePickerView
//
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import "HZQDatePickerView.h"

@interface HZQDatePickerView ()

@property (nonatomic, copy) NSDictionary *dateDic;

@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backgVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPadding;

@end

@implementation HZQDatePickerView

+ (HZQDatePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HZQDatePickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib
{
    self.backgVIew.layer.cornerRadius = 5;
    self.backgVIew.layer.borderWidth = 1;
    self.backgVIew.layer.borderColor = [[UIColor clearColor] CGColor];
    self.backgVIew.layer.masksToBounds = YES;
    
    /** 确定 */
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.borderWidth = 1;
    
    [self.sureBtn setTitleColor:ColorHex(0x37ca79) forState:UIControlStateNormal];

    self.sureBtn.layer.borderColor = ColorHex(0x37c3a9).CGColor;
    self.sureBtn.layer.masksToBounds = YES;
    
    /** 取消按钮 */
    self.cannelBtn.layer.cornerRadius = 4;
    self.cannelBtn.layer.borderWidth = 1;
    self.cannelBtn.layer.borderColor = ColorHex(0xbab9b9).CGColor;
    self.cannelBtn.layer.masksToBounds = YES;
    
    if (GetUIScreenWidth > 320) {
        // IPHONE 6
        self.leftPadding.constant += 20;
        self.rightPadding.constant += 20;
        if (GetUIScreenWidth > 400) {
            // IPHONE 6 PLUS
            self.leftPadding.constant += 20;
            self.rightPadding.constant += 20;
        }
    }
}

- (NSDictionary *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSInteger timestamp = [selected timeIntervalSince1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    
    NSDictionary *dateDic = @{@"dateStr":currentOlderOneDateStr,@"timestamp":@(timestamp)};
    return dateDic;
}

- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
}

// 退出键盘
- (IBAction)blackBtnClick:(id)sender {
    [self.superview endEditing:YES];
}

// 取消
- (IBAction)removeBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 确定
- (IBAction)sureBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    
    if ([self.delegate respondsToSelector:@selector(getSelectDate:type:)]) {
        //delegate
        [self.delegate getSelectDate:[[self timeFormat] copy] type:self.type];
    }

    [self removeBtnClick:nil];
}

@end


