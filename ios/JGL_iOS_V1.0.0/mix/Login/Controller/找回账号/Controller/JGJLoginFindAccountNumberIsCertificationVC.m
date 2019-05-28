//
//  JGJLoginFindAccountNumberIsCertificationVC.m
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoginFindAccountNumberIsCertificationVC.h"
#import "JGJLoginFindAccountNumberQuestionTwoVC.h"
#import "JGJQuestionTitleView.h"
#import "JGJFindAccountNumberNextBtnView.h"
#import "JGJOriginalPhoneNumberTopView.h"
#import "TYPredicate.h"
@interface JGJLoginFindAccountNumberIsCertificationVC ()

@property (nonatomic, strong) JGJOriginalPhoneNumberTopView *originalPhoneNumberTopView;
@property (nonatomic, strong) JGJQuestionTitleView *questionTitleView;
@property (nonatomic, strong) JGJFindAccountNumberNextBtnView *nextStepBtnView;

@property (nonatomic, strong) UIView *haveCertificationBackView;
@property (nonatomic, strong) UIButton *haveCertification;// 已实名认证按钮
@property (nonatomic, strong) UITextField *inputIDCardNumber;

@property (nonatomic, strong) UIButton *nonCertification;// 未实名认证


@end

@implementation JGJLoginFindAccountNumberIsCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回账号";
    self.navigationController.navigationBar.barTintColor = AppFontfafafaColor;
    self.view.backgroundColor = AppFontffffffColor;
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.originalPhoneNumberTopView];
    [self.view addSubview:self.questionTitleView];
    [self.view addSubview:self.haveCertificationBackView];
    [self.haveCertificationBackView addSubview:self.haveCertification];
    [self.haveCertificationBackView addSubview:self.inputIDCardNumber];
    [self.view addSubview:self.nonCertification];
    [self.view addSubview:self.nextStepBtnView];
    [self setUpLayout];
    
    [_haveCertificationBackView updateLayout];
    [_nonCertification updateLayout];
    
    _haveCertificationBackView.layer.cornerRadius = 5;
    _nonCertification.layer.cornerRadius = 5;
    
    __weak typeof(self) weakSelf = self;
    _nextStepBtnView.nextStep = ^{
        
        if (!weakSelf.haveCertification.selected && !weakSelf.nonCertification.selected) {
            
            [TYShowMessage showPlaint:@"请选择答案"];
            return ;
        }
        
        JGJLoginFindAccountNumberQuestionTwoVC *vc = [[JGJLoginFindAccountNumberQuestionTwoVC alloc] init];
        vc.phoneNumberStr = weakSelf.originalPhoneNumber;
        vc.idCardStr = weakSelf.inputIDCardNumber.text;
        
        // 1.按钮是否选中
        if (weakSelf.haveCertification.selected || weakSelf.nonCertification.selected) {

            // 2.判断是已实名选中还是为实名选中判断是选了已实名认证还是为实名认证
            if (weakSelf.haveCertification.selected) {

                // 3,判断身份证号码格式是否填写正确
                if (weakSelf.inputIDCardNumber.text.length == 0) {

                    [TYShowMessage showPlaint:@"请输入身份证号码"];
                    return;
                }
                
                if (weakSelf.inputIDCardNumber.text.length < 18) {
                    
                    [TYShowMessage showPlaint:@"请输入正确的身份证号码！"];
                    return;
                }
                BOOL isRightIDCard = [TYPredicate isRightIDCard:weakSelf.inputIDCardNumber.text];
                if (isRightIDCard) {

                    vc.idCardStr = weakSelf.inputIDCardNumber.text;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else {

                    [TYShowMessage showPlaint:@"请输入正确的身份证号码！"];

                }
            }else {

                // 4.未实名选中
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }

        }
        
    };
}

- (void)setUpLayout {
    
    _originalPhoneNumberTopView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(80);
    _questionTitleView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_originalPhoneNumberTopView, 0).rightSpaceToView(self.view, 0).heightIs(130);
    _haveCertificationBackView.sd_layout.leftSpaceToView(self.view, 60).rightSpaceToView(self.view, 60).topSpaceToView(_questionTitleView, 25).heightIs(44);
    _haveCertification.sd_layout.leftSpaceToView(_haveCertificationBackView, 0).rightSpaceToView(_haveCertificationBackView, 00).topSpaceToView(_haveCertificationBackView, 0).heightIs(44);
    _inputIDCardNumber.sd_layout.leftSpaceToView(_haveCertificationBackView, 15).rightSpaceToView(_haveCertificationBackView, 15).topSpaceToView(_haveCertification, 0).heightIs(0);
    
    _nonCertification.sd_layout.leftSpaceToView(self.view, 60).rightSpaceToView(self.view, 60).topSpaceToView(_haveCertificationBackView, 20).heightIs(44);
    _nextStepBtnView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(60);
}

- (void)setOriginalPhoneNumber:(NSString *)originalPhoneNumber {
    
    _originalPhoneNumber = originalPhoneNumber;
    
    self.originalPhoneNumberTopView.phoeNumberStr = _originalPhoneNumber;
    
}

#pragma mark - method
- (void)certificationBtnClick:(UIButton *)sender {
    
    NSInteger senderTag = sender.tag - 100;
    if (!sender.selected) {
        
        sender.selected = YES;
        if (senderTag == 0) {
            
            _haveCertificationBackView.layer.borderColor = AppFontEB4E4EColor.CGColor;
            
            _haveCertificationBackView.sd_layout.heightIs(108);
            _inputIDCardNumber.sd_layout.heightIs(45);
            _inputIDCardNumber.hidden = NO;
            [_inputIDCardNumber updateLayout];
            _inputIDCardNumber.layer.cornerRadius = 5;
        }else {
            
            sender.layer.borderColor = AppFontEB4E4EColor.CGColor;
        }
        
    }
    
    if (senderTag == 0) {
        
        _nonCertification.selected = NO;
        _nonCertification.layer.borderColor = AppFontdbdbdbColor.CGColor;
        
    }else if (senderTag == 1) {
        
        _haveCertification.selected = NO;
        _haveCertificationBackView.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _haveCertificationBackView.sd_layout.heightIs(44);
        _inputIDCardNumber.sd_layout.heightIs(0);
        _inputIDCardNumber.hidden = YES;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    _nonCertification.selected = NO;
    _nonCertification.layer.borderColor = AppFontdbdbdbColor.CGColor;
    
    
    _haveCertification.selected = NO;
    _haveCertificationBackView.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _haveCertificationBackView.sd_layout.heightIs(44);
    _inputIDCardNumber.sd_layout.heightIs(0);
    _inputIDCardNumber.hidden = YES;
}

#pragma mark - getter/setter
- (JGJOriginalPhoneNumberTopView *)originalPhoneNumberTopView {
    
    if (!_originalPhoneNumberTopView) {
        
        _originalPhoneNumberTopView = [[JGJOriginalPhoneNumberTopView alloc] init];
    }
    return _originalPhoneNumberTopView;
}

- (JGJQuestionTitleView *)questionTitleView {
    
    if (!_questionTitleView) {
        
        _questionTitleView = [[JGJQuestionTitleView alloc] init];
        _questionTitleView.questionTitleStr = @"1.原手机号码是否实名认证?";
    }
    return _questionTitleView;
}

- (UIView *)haveCertificationBackView {
    
    if (!_haveCertificationBackView) {
        
        _haveCertificationBackView = [[UIView alloc] init];
        _haveCertificationBackView.backgroundColor = AppFontffffffColor;
        _haveCertificationBackView.layer.borderWidth = 1;
        _haveCertificationBackView.layer.borderColor = AppFontdbdbdbColor.CGColor;
    }
    return _haveCertificationBackView;
}

- (UIButton *)haveCertification {
    
    if (!_haveCertification) {
        
        _haveCertification = [UIButton buttonWithType:UIButtonTypeCustom];
        _haveCertification.backgroundColor = AppFontffffffColor;
        [_haveCertification setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_haveCertification setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        [_haveCertification setTitle:@"已实名认证" forState:(UIControlStateNormal)];
        _haveCertification.titleLabel.font = FONT(AppFont30Size);
        [_haveCertification setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_haveCertification setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _haveCertification.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _haveCertification.tag = 100;
        [_haveCertification addTarget:self action:@selector(certificationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _haveCertification;
}

- (UITextField *)inputIDCardNumber {
    
    if (!_inputIDCardNumber) {
        
        _inputIDCardNumber = [[UITextField alloc] init];
        _inputIDCardNumber.backgroundColor = AppFontf1f1f1Color;
        [_inputIDCardNumber setValue:AppFont999999Color forKeyPath:@"_placeholderLabel.textColor"];
        _inputIDCardNumber.textColor = AppFont000000Color;
        _inputIDCardNumber.font = FONT(AppFont36Size);
        _inputIDCardNumber.layer.borderWidth = 1;
        _inputIDCardNumber.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _inputIDCardNumber.placeholder = @"请输入身份证号码";
        _inputIDCardNumber.textAlignment = NSTextAlignmentCenter;
        _inputIDCardNumber.hidden = YES;
        
    }
    return _inputIDCardNumber;
}

- (UIButton *)nonCertification {
    
    if (!_nonCertification) {
        
        _nonCertification = [UIButton buttonWithType:UIButtonTypeCustom];
        _nonCertification.backgroundColor = AppFontffffffColor;
        [_nonCertification setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_nonCertification setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        [_nonCertification setTitle:@"未实名认证" forState:(UIControlStateNormal)];
        _nonCertification.titleLabel.font = FONT(AppFont30Size);
        [_nonCertification setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_nonCertification setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _nonCertification.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _nonCertification.tag = 101;
        _nonCertification.layer.borderWidth = 1;
        _nonCertification.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_nonCertification addTarget:self action:@selector(certificationBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nonCertification;
}


- (JGJFindAccountNumberNextBtnView *)nextStepBtnView {
    
    if (!_nextStepBtnView) {
        
        _nextStepBtnView = [[JGJFindAccountNumberNextBtnView alloc] init];
    }
    return _nextStepBtnView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
