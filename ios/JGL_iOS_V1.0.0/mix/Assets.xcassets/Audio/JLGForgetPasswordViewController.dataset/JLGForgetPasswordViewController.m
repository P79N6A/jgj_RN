//
//  JLGForgetPasswordViewController.m
//  mix
//
//  Created by jizhi on 15/11/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGForgetPasswordViewController.h"

#import "TYPredicate.h"
#import "TYTextField.h"
#import "TYShowMessage.h"
#import "CALayer+SetLayer.h"
#import "JLGGetVerifyButton.h"

@interface JLGForgetPasswordViewController()

@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;
@property (weak, nonatomic) IBOutlet UIButton *savePwdButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTFOther;

@end

@implementation JLGForgetPasswordViewController

#pragma mark - scrollView 隐藏键盘
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initVc];
}

- (void)initVc{
    [self.savePwdButton.layer setLayerCornerRadius:4.0];
    [self.getVerifyButton.layer setLayerCornerRadius:4.0];
    [self.pwdTF.layer setLayerCornerRadius:4.0];
    [self.pwdTFOther.layer setLayerCornerRadius:4.0];
    [self.getVerifyButton initColorWithH:JGJMainColor WithL:AppFontc7c7c7Color WithTimeCount:60];
    UITextField *textFieldOne = [self.view viewWithTag:1];
    [textFieldOne becomeFirstResponder];
    
    self.phoneTF.text = self.phoneStr;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    UITextField *textFieldOne = [self.view viewWithTag:1];
    UITextField *textFieldTwo = [self.view viewWithTag:2];
    UITextField *textFieldThree = [self.view viewWithTag:3];
    UITextField *textFieldFour = [self.view viewWithTag:4];
    
    textFieldOne.delegate = nil;
    textFieldTwo.delegate = nil;
    textFieldThree.delegate = nil;
    textFieldFour.delegate = nil;
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    if (textField.tag > 2) {
        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';
        if (!(single >='0' && single<='9'))//数据格式正确
        {
            return NO;
        }
    }

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

    if ((textField.tag == 1)||(textField.tag == 2)) {
        if ([toBeString length] > 30) { //密码最多30个字
            textField.text = [toBeString substringToIndex:30];
            return NO;
        }
        
        if (self.phoneTF.text.length > 1 && textField.tag == 2){//如果填写了电话,并且是第二个输入框
            UITextField *firstPwdTF = [self.view viewWithTag:1];

            //当2个密码相同的情况
            if ([firstPwdTF.text isEqualToString:toBeString]) {
                self.getVerifyButton.backgroundColor = JGJMainColor;
            }
        }

    }
    
    if (textField.tag==3)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    
    
    if (textField.tag == 4) {
        if ((self.phoneTF.text.length > 1)&&(self.savePwdButton.enabled == NO)) {
            self.savePwdButton.enabled = YES;
            self.savePwdButton.backgroundColor = JGJMainColor;
        }
    }
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        UITextField *firstPwdTF = [self.view viewWithTag:1];
        UITextField *secondPwdTF = [self.view viewWithTag:2];
        if (![secondPwdTF.text isEqualToString:firstPwdTF.text]) {
            [TYShowMessage showPlaint:@"两次输入的密码不一致,请再次确认"];
            return NO;
        }else{//如果密码没问题，将获取验证码的按钮修改为可使用
            self.getVerifyButton.backgroundColor = JGJMainColor;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        if ((textField.text.length < 6)||(textField.text.length > 30)) {
            [TYShowMessage showPlaint:@"密码位数在6~30位"];
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

- (IBAction)getVerifyBtnClick:(JLGGetVerifyButton *)sender {

    if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        return;
    }
    
    sender.codeType = 2;
    sender.phoneStr = self.phoneTF.text;
    sender.enabled = NO;
}

- (IBAction)savePwdBtnClick:(UIButton *)sender {
    NSMutableDictionary *parametesDic = [NSMutableDictionary dictionary];
    parametesDic[@"telph"]  = self.phoneTF.text;
    parametesDic[@"vcode"]  = self.verifyTF.text;
    
    UITextField *firstPwd = [self.view viewWithTag:1];
    UITextField *secondPwd = [self.view viewWithTag:2];
    parametesDic[@"pwdone"] = firstPwd.text;
    parametesDic[@"pwdtwo"] = secondPwd.text;
    
    
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/recoverpwd" parameters:parametesDic success:^(id responseObject) {
        TYLog(@"忘记密码修改成功");
        [TYShowMessage showSuccess:@"修改密码成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
