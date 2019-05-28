//
//  JGJLogoutPopView.m
//  mix
//
//  Created by yj on 2018/1/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutPopView.h"

#import "TYTextField.h"

#import "JLGGetVerifyButton.h"

@interface JGJLogoutPopView () <JLGGetVerifyButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *logoutDes;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *verCode;

@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (weak, nonatomic) IBOutlet UIView *contentVerCodeView;


@end

@implementation JGJLogoutPopView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    [self.contentDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.contentDetailView.clipsToBounds = YES;
    
    [self.cancelBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.confirmBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.title.textColor = AppFontEB4E4EColor;
    
    self.verCode.maxLength = 4;
    
    [self.contentDetailView.layer setLayerCornerRadius:3.0];
    
    [TYNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    NSString *tel = [TYUserDefaults objectForKey:JLGPhone];
    
    self.logoutDes.text = [NSString stringWithFormat:@"你正在申请注销账号  %@", tel?:@""];
    
    self.getVerifyButton.delegate = self;
    
    [self.getVerifyButton initColorWithH:[UIColor whiteColor] WithL:TYColorHex(0xc7c7c7) WithTimeCount:60];
    
    //注销账号用4
    self.getVerifyButton.codeType = @"4";
    
    TYWeakSelf(self);
    self.verCode.valueDidChange = ^(NSString *value) {
      
        if (weakself.logoutPopViewBlock) {
            
            weakself.logoutPopViewBlock(value);
        }
    };
    
    [self.contentVerCodeView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:3];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 38)];
    
    self.verCode.leftView = leftView;
    
    self.verCode.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)verifyBtnPressed:(JLGGetVerifyButton *)sender {
    
    NSString *tel = [TYUserDefaults objectForKey:JLGPhone];
    
    sender.phoneStr = tel?:@"";
    
    sender.enabled = NO;
    
    [self.verCode becomeFirstResponder];
}

- (IBAction)cancelBtnPressed:(UIButton *)sender {
    
    [self hiddenPopView];
}


- (IBAction)confirmBtnPressed:(UIButton *)sender {
    
    [self hiddenPopView];
    
    if (self.logoutPopViewOkBlock) {
        
        self.logoutPopViewOkBlock();
    }
}

- (void)showPopView {
    
    self.frame = TYGetUIScreenRect;
    
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
    
}

- (void)hiddenPopView {
    
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        
        [self removeFromSuperview];
    }
    
    [self.verCode resignFirstResponder];
}

#pragma mark - 获取验证码的结果
- (void)getVerifyButtonResult:(BOOL)resultBool{
    
    if (!resultBool) {
        
        [self.getVerifyButton stopTimer];

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self hiddenPopView];
    
    [self endEditing:YES];
}

/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distance =   endKeyboardRect.origin.y - TYGetMaxY(self.contentDetailView) ;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (distance < 80) {
            
            self.contentDetailView.transform = CGAffineTransformMakeTranslation(0, -80);
            
        } else {
            
            self.contentDetailView.transform = CGAffineTransformIdentity;
        }
    }];

}

- (void)dealloc{
    
    [TYNotificationCenter removeObserver:self];
}

@end
