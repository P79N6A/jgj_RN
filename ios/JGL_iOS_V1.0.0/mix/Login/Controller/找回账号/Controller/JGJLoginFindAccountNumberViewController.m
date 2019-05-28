//
//  JGJLoginFindAccountNumberViewController.m
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoginFindAccountNumberViewController.h"
#import "JGJLoginFindAccountNumberIsCertificationVC.h"
#import "JGJFindAccountNumberNextBtnView.h"
#import "TYPredicate.h"
#import "YYText.h"
@interface JGJLoginFindAccountNumberViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneNumberInput;

@property (nonatomic, strong) JGJFindAccountNumberNextBtnView *nextStepBtnView;

@end

@implementation JGJLoginFindAccountNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"找回账号";
    self.navigationController.navigationBar.barTintColor = AppFontfafafaColor;
    self.view.backgroundColor = AppFontffffffColor;
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.phoneNumberInput];
    [self.view addSubview:self.nextStepBtnView];
    [self setUpLayout];
    
    [_phoneNumberInput updateLayout];
    
    _phoneNumberInput.layer.cornerRadius = 5;
    
    
    __weak typeof(self) weakSelf = self;
    // 下一步
    _nextStepBtnView.nextStep = ^{
        
        if (weakSelf.phoneNumberInput.text.length == 0) {
            
            [TYShowMessage showPlaint:@"请输入原手机号码"];
            return;
        }
        //1 .验证手机号码格式
        BOOL isPhoneNumber = [TYPredicate isRightPhoneNumer:weakSelf.phoneNumberInput.text];
        if (isPhoneNumber) {
            
            
            // 2 进入下一页
            JGJLoginFindAccountNumberIsCertificationVC * vc = [[JGJLoginFindAccountNumberIsCertificationVC alloc] init];
            vc.originalPhoneNumber = weakSelf.phoneNumberInput.text;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            // 3提示错误
            [TYShowMessage showPlaint:@"手机号码格式有误"];
        }
    };
}

- (void)setUpLayout {
    
    _phoneNumberInput.sd_layout.leftSpaceToView(self.view, 62).topSpaceToView(self.view, 70).rightSpaceToView(self.view, 64).heightIs(45);
    _nextStepBtnView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(60);
}

- (UITextField *)phoneNumberInput {
    
    if (!_phoneNumberInput) {
        
        _phoneNumberInput = [[UITextField alloc] init];
        _phoneNumberInput.placeholder = @"请输入原手机号码";
        _phoneNumberInput.font = FONT(AppFont36Size);
        _phoneNumberInput.layer.borderWidth = 1;
        _phoneNumberInput.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _phoneNumberInput.textColor = AppFont000000Color;
        _phoneNumberInput.textAlignment = NSTextAlignmentCenter;
        _phoneNumberInput.delegate = self;
        _phoneNumberInput.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _phoneNumberInput;
}

- (JGJFindAccountNumberNextBtnView *)nextStepBtnView {
    
    if (!_nextStepBtnView) {
        
        _nextStepBtnView = [[JGJFindAccountNumberNextBtnView alloc] init];
    }
    return _nextStepBtnView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] >= 11) {
        textField.text = [toBeString substringToIndex:11];
    
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
