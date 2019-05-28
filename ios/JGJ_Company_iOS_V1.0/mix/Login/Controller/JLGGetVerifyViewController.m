//
//  JLGGetVerifyViewController.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGGetVerifyViewController.h"

#import "TYShowMessage.h"
#import "TYPredicate.h"
#import "TYTextField.h"
#import "TYAddressBook.h"
#import "NSString+JSON.h"
#import "CALayer+SetLayer.h"
#import "NSString+Extend.h"
#import "JLGGetVerifyButton.h"
#import "JLGAppDelegate.h"
#import "JGJWebAllSubViewController.h"

#define errorMessage @"请输入正确的手机号码"

@interface JLGGetVerifyViewController()
<
    JLGGetVerifyButtonDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *PassWordTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvitationLabel;

@property (strong,nonatomic) NSMutableArray *imagesArray;

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UITextField *InvitationTF;
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;



@end

@implementation JLGGetVerifyViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //登录失效先清除登录状态
    JLGExitLogin;
    
    [self initVc];
    self.imagesArray = [NSMutableArray array];
}

- (IBAction)getVerifyBtnClick:(JLGGetVerifyButton *)sender {
    if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        return;
    }
    
    if (!self.getVerifyButton.delegate) {
        self.getVerifyButton.delegate = self;
    }
    sender.phoneStr = self.phoneTF.text;
    sender.enabled = NO;
}

- (void)initVc{
    [self.phoneTF becomeFirstResponder];
    
    self.nextStepButton.enabled = NO;
    
    self.InvitationLabel.textColor = JGJMainColor;
    self.PassWordTipLabel.textColor = JGJMainColor;
    [self.nextStepButton.layer setLayerCornerRadius:4];
    [self.getVerifyButton.layer setLayerCornerRadius:4];

    [self.realNameTF.layer setLayerCornerRadius:4.0];
    [self.phoneTF.layer setLayerCornerRadius:4];
    [self.getVerifyButton initColorWithH:JGJMainColor WithL:TYColorHex(0xc7c7c7) WithTimeCount:60];
    
    //设置协议的富文本
    NSMutableAttributedString *protocolString = [[NSMutableAttributedString alloc] initWithString:self.protocolButton.titleLabel.text];
    
    //灰色
    [protocolString addAttribute:NSForegroundColorAttributeName value:AppFontc7c7c7Color range:NSMakeRange(0, protocolString.length)];
    
    //黄色
    [protocolString addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(12, 9)];

    [self.protocolButton setAttributedTitle:protocolString forState:UIControlStateNormal];
    self.InvitationTF.backgroundColor = AppFontf7f7f7Color;
}

- (IBAction)nextStepBtnClick:(UIButton *)sender {
    if (self.phoneTF.text.length == 11)
    {
        if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
            [TYShowMessage showPlaint:errorMessage];
            return ;
        }
        
        if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 30) {
            [TYShowMessage showPlaint:@"密码位数在6~30位"];
            return;
        }
        
        
        if ([NSString isEmpty:self.realNameTF.text]) {
            [TYShowMessage showPlaint:@"请输入真实姓名"];
            return;
        }
        
        NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
        
        [parametersDic setObject:@"I" forKey:@"os"];
        [parametersDic setObject:self.pwdTF.text forKey:@"pwd"];
        [parametersDic setObject:self.phoneTF.text forKey:@"telph"];
        [parametersDic setObject:self.verifyTF.text forKey:@"vcode"];
        [parametersDic setObject:self.InvitationTF.text forKey:@"invitation_code"];
        [parametersDic setObject:@4 forKey:@"role"];
        [parametersDic setObject:self.realNameTF.text forKey:@"real_name"];
        
        __weak typeof(self) weakSelf = self;
        
        [TYLoadingHub showLoadingWithMessage:@""];
        [JLGHttpRequest_AFN PostWithApi:@"jlsignup/register" parameters:parametersDic success:^(id responseObject) {
            [weakSelf.view endEditing:YES];
            [weakSelf.getVerifyButton stopTimer];
            [TYUserDefaults setBool:YES forKey:JLGLogin];
            [TYUserDefaults setObject:responseObject[JLGToken] forKey:JLGToken];
            [TYUserDefaults synchronize];
            
            //上传通讯录
            if ([self isPermitAddressBook]) {
                 [weakSelf loadAddressBook];
            }
            
            JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
            [jlgAppDelegate setRootViewController];
            
            [TYLoadingHub hideLoadingView];
        }failure:^(NSError *error) {
            [TYLoadingHub hideLoadingView]; 
        }];
    }
    else
    {
        [TYShowMessage showPlaint:errorMessage];
    }
}

#pragma mark - 这句主要用于打补丁使用当前版本上传通信录被拒绝
- (BOOL)isPermitAddressBook {
    
    return NO;
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (textField.tag==1)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        
        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';
        if (!(single >='0' && single<='9'))//数据格式正确
        {
            return NO;
        }
        
    }
    
    if (textField.tag == 2) {
        if ((self.phoneTF.text.length > 1)&&(self.nextStepButton.enabled == NO)) {
            self.nextStepButton.enabled = YES;
            self.nextStepButton.backgroundColor = JGJMainColor;
        }
        
        if ([toBeString length] > 8) {
            textField.text = [toBeString substringToIndex:8];
            return NO;
        }
    }
    
    if (textField.tag == 3) {
        if ([toBeString length] > 30) { //密码最多30个字
            textField.text = [toBeString substringToIndex:30];
            return NO;
        }
    }
    
    if (textField.tag == 4)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }

    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [TYTextField textFieldDidBeginEditingColor:textField color:JGJMainColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [TYTextField textFieldDidBeginEditingColor:textField color:TYTextFieldDefualtColor];
}

#pragma mark scrollView的delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 获取验证码的结果
- (void)getVerifyButtonResult:(BOOL)resultBool{
    if (!resultBool) {
        [self.getVerifyButton stopTimer];
        self.nextStepButton.enabled = NO;
    }
}


#pragma mark - 读联系人
- (void)loadAddressBook{
    [TYAddressBook loadAddressBookByHttp];
}
@end
