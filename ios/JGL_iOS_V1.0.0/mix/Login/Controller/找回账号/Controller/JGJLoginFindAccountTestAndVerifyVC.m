//
//  JGJLoginFindAccountTestAndVerifyVC.m
//  mix
//
//  Created by Tony on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoginFindAccountTestAndVerifyVC.h"
#import "JGJQuestionTitleView.h"
#import "JGJFindAccountNumberNextBtnView.h"
#import "JGJOriginalPhoneNumberTopView.h"
#import "TYPredicate.h"
#import "CustomAlertView.h"
#import "JGJCustomPopView.h"
#import "JGJmodifiPhoneViewController.h"
#import "JGJLoginFindAccountNumberIsCertificationVC.h"
@interface JGJLoginFindAccountTestAndVerifyVC ()<UITextFieldDelegate>

@property (nonatomic, strong) JGJOriginalPhoneNumberTopView *originalPhoneNumberTopView;
@property (nonatomic, strong) JGJQuestionTitleView *questionTitleView;
@property (nonatomic, strong) JGJFindAccountNumberNextBtnView *nextStepBtnView;

@property (nonatomic, strong) UITextField *phoneNumberInput;

@end

@implementation JGJLoginFindAccountTestAndVerifyVC

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
    [self.view addSubview:self.phoneNumberInput];
    [self.view addSubview:self.nextStepBtnView];
    [self setUpLayout];
    
    [_phoneNumberInput updateLayout];
    _phoneNumberInput.layer.cornerRadius = 5;
    
    __weak typeof(self) weakSelf = self;
    _nextStepBtnView.nextStep = ^{
        
        if (weakSelf.phoneNumberInput.text.length == 0) {
            
            [TYShowMessage showPlaint:@"请输入手机号码"];
            return;
        }
        //1 .验证手机号码格式
        BOOL isPhoneNumber = [TYPredicate isRightPhoneNumer:weakSelf.phoneNumberInput.text];
        if (isPhoneNumber) {
            
            // 2.开始验证
            CustomAlertView *alert = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
            
            [alert showProgressImageView:@"正在验证..."];
            NSDictionary *param = @{@"telephone":weakSelf.phoneNumberInput.text,
                                    @"cid":weakSelf.cid,
                                    @"token":weakSelf.token
                                    };
            [JLGHttpRequest_AFN PostWithApi:@"v2/signup/findaccountcheck" parameters:param success:^(id responseObject) {
                
                __block NSDictionary *dic = (NSDictionary *)responseObject;
                [alert dismissWithBlcok:^{
                    
                    if ([dic[@"is_pass"] integerValue] == 0) {
                        
                        [weakSelf verifyFailed];
                    }else {
                        
                        JGJmodifiPhoneViewController *modifyPhoneVC = [[UIStoryboard storyboardWithName:@"modifyphone" bundle:nil] instantiateViewControllerWithIdentifier:@"modifiPhoneVc"];
                        [modifyPhoneVC setIsFindAccoutInWithToken:YES token:weakSelf.token];
                        [weakSelf.navigationController pushViewController:modifyPhoneVC animated:YES];
                    }
                }];
                
            } failure:^(NSError *error) {
                
                [alert dismissWithBlcok:^{
                    
                    [weakSelf verifyFailed];
                }];
            }];
            
        }else {
            
            // 3提示错误
            [TYShowMessage showPlaint:@"手机号码格式有误"];
        }
    };
}

- (void)verifyFailed {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.title = @"验证失败";
    
    desModel.popDetail = @"如有疑问，请联系吉工家客服!";
    
    desModel.leftTilte = @"重新验证";
    
    desModel.rightTilte = @"联系客服";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.isNotTouchViewHide = YES;
    alertView.TitleLable.textColor = AppFont000000Color;
    alertView.TitleLable.font = FONT(AppFont36Size);
    
    alertView.messageLable.textInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
    alertView.messageLable.font = FONT(AppFont30Size);
    alertView.messageLable.textColor = AppFont666666Color;
    
    alertView.titleLableTop.constant = 45;
    alertView.messageLabelTop.constant = 0;
    __weak typeof(self) weakSelf = self;
    alertView.leftButtonBlock = ^{
        
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJLoginFindAccountNumberIsCertificationVC class]]) {
                
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
    };
    
    alertView.onOkBlock = ^{
        
        NSString * str = [NSString stringWithFormat:@"tel:%@",@"4008623818"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    };
}

- (void)setUpLayout {
    
    _originalPhoneNumberTopView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(80);
    _questionTitleView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_originalPhoneNumberTopView, 0).rightSpaceToView(self.view, 0).heightIs(130);
    _phoneNumberInput.sd_layout.leftSpaceToView(self.view, 60).topSpaceToView(_questionTitleView, 20).rightSpaceToView(self.view, 60).heightIs(45);
    
    _nextStepBtnView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(60);
}

- (void)setPhoneNumberStr:(NSString *)phoneNumberStr {
    
    _phoneNumberStr = phoneNumberStr;
    self.originalPhoneNumberTopView.phoeNumberStr = _phoneNumberStr;
}
- (void)setAnswerString:(NSString *)answerString {
    
    _answerString = answerString;
    self.questionTitleView.answerStr = _answerString;
    self.nextStepBtnView.isHavChoiceRecordWorkpoints = NO;
}

- (void)setCid:(NSString *)cid {
    
    _cid = cid;
}

- (void)setToken:(NSString *)token {
    
    _token = token;
}

- (JGJOriginalPhoneNumberTopView *)originalPhoneNumberTopView {
    
    if (!_originalPhoneNumberTopView) {
        
        _originalPhoneNumberTopView = [[JGJOriginalPhoneNumberTopView alloc] init];
    }
    return _originalPhoneNumberTopView;
}

- (JGJQuestionTitleView *)questionTitleView {
    
    if (!_questionTitleView) {
        
        _questionTitleView = [[JGJQuestionTitleView alloc] init];
    }
    return _questionTitleView;
}

- (UITextField *)phoneNumberInput {
    
    if (!_phoneNumberInput) {
        
        _phoneNumberInput = [[UITextField alloc] init];
        _phoneNumberInput.placeholder = @"请输入手机号码";
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
