//
//  JGJModifyUserTelSecVc.m
//  mix
//
//  Created by yj on 2019/2/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJModifyUserTelSecVc.h"

#import "TYTextField.h"

#import "JLGGetVerifyButton.h"

#import "TYPredicate.h"

//设置输入框
#define LoginBorderColor TYColorHex(0xc7c7c7)

@interface JGJModifyUserTelSecVc ()<JLGGetVerifyButtonDelegate>

@property (weak, nonatomic) IBOutlet LengthLimitTextField *phoneTF;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *verifyTF;

@property (weak, nonatomic) IBOutlet UIView *phoneView;

@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmbtn;

@property (weak, nonatomic) IBOutlet UILabel *telDes;


@end

@implementation JGJModifyUserTelSecVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"更换手机号";
    
    [self initWithSubView];
    
    NSString *tel = [TYUserDefaults objectForKey:JLGPhone];
    
    self.telDes.text = [NSString stringWithFormat:@"当前手机号：%@", tel];
    
    self.telDes.font = [UIFont boldSystemFontOfSize:AppFont34Size];
}

- (void)initWithSubView{
    
    self.verifyTF.maxLength = 4;
    
    self.phoneTF.maxLength = 11;

    [self.phoneTF becomeFirstResponder];
    
    self.phoneTF.inputAccessoryView = [[UIView alloc] init];
    
    self.verifyTF.inputAccessoryView = [[UIView alloc] init];
    
    [self.phoneView.layer setLayerBorderWithColor:AppFontc7c7c7Color width:0.5 radius:4.0];
    
    [self.pwdView.layer setLayerBorderWithColor:AppFontc7c7c7Color width:0.5 radius:4.0];
    
    [self.getVerifyButton.layer setLayerCornerRadius:4.0];
    
    [self.getVerifyButton initColorWithH:AppFontEB4E4EColor WithL:AppFontc7c7c7Color WithTimeCount:60];
    
    _confirmbtn.enabled = NO;
    
    _confirmbtn.layer.shadowColor = AppFontEFB8B8Color.CGColor;
    
    _confirmbtn.layer.cornerRadius = 4;
    
    _confirmbtn.layer.shadowOffset = CGSizeMake(0, 4);
    
    _confirmbtn.layer.shadowOpacity = 0.8;
    
    [_confirmbtn setTitleColor:AppFontffffffColor forState:UIControlStateDisabled];
    
    _confirmbtn.titleLabel.alpha = .5;
    
    [_confirmbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _confirmbtn.backgroundColor = AppFontEB4E4EColor;
    
    self.view.backgroundColor = AppFontf1f1f1Color;

}

- (IBAction)verifyBtnPressed:(JLGGetVerifyButton *)sender {
    
    if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
        
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        
        return;
    }
    
    sender.backgroundColor = [UIColor whiteColor];
    
    if (!self.getVerifyButton.delegate) {
        
        self.getVerifyButton.delegate = self;
        
    }
    
    sender.phoneStr = self.phoneTF.text;
    
    sender.codeType = @"2";
    
    sender.enabled = NO;
    
    [self.verifyTF becomeFirstResponder];
    
}

#pragma mark - 获取验证码的结果
- (void)getVerifyButtonResult:(BOOL)resultBool{
    
    if (!resultBool) {
        
        [self.getVerifyButton stopTimer];
        
        self.confirmbtn.enabled = NO;
        
    }
}

- (IBAction)confirmBtnPressed:(UIButton *)sender {
    
    if (self.phoneTF.text.length == 11) {
        
        if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
            
            [TYShowMessage showPlaint:@"请输入正确的手机号码"];
            
            return ;
        }
        
        if (self.verifyTF.text.length == 0) {
            
            [TYShowMessage showPlaint:@"输入的验证码不正确"];
            
            return;
        }
        
        [self.verifyTF endEditing:YES];
        
        [self.phoneTF endEditing:YES];
        
    }
    
    else {
        
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        
        return;
    }
    
    [self modifyTelRequst];
}


#pragma mark - 修改手机

- (void)modifyTelRequst {
    
    NSString *tel = [TYUserDefaults objectForKey:JLGPhone];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:tel?:@"" forKey:@"telph"];    //原手机号码
    
    [paramDic setObject:self.phoneTF.text?:@"" forKey:@"ntelph"];//原手机号码（不传，验证原手机；传了验证新手机号码）
    
    [paramDic setObject:self.verifyTF.text?:@"" forKey:@"vcode"];//    验证码
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/modifyTelephone" parameters:paramDic success:^(id responseObject) {
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        
        infoVer += 1;
        
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        
        [TYShowMessage showSuccess:@"电话号码已修改成功"];
        
        [TYUserDefaults setObject:self.phoneTF.text?:@"" forKey:JLGPhone];
        
        [TYUserDefaults synchronize];
        
        [self popVc];
    }];
    
}

#pragma mark - 返回到设置控制器

- (void)popVc {
    
    BOOL isExistVc = NO;
    
    for (UIViewController *settVc in self.navigationController.viewControllers) {
        
        if ([settVc isKindOfClass:NSClassFromString(@"JGJMineSettingVc")]) {
            
            isExistVc = YES;
            
            [self.navigationController popToViewController:settVc animated:YES];
            
            break;
        }
        
    }
    
    NSInteger cnt = self.navigationController.viewControllers.count;
    
    if (!isExistVc && cnt >= 3) {
        
        UIViewController *vc = self.navigationController.viewControllers[cnt - 3];
        
        [self.navigationController popToViewController:vc animated:YES];
        
    }
    
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (textField.tag==1)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] >= 11) {
            textField.text = [toBeString substringToIndex:11];
            
            
            return NO;
        }
        
        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';
        if (!(single >='0' && single<='9'))//数据格式正确
        {
            return NO;
        }
        
        if ((self.verifyTF.text.length > 1)&&(_confirmbtn.enabled == NO)) {
            
            _confirmbtn.enabled = YES;
            
            _confirmbtn.backgroundColor = AppFontEB4E4EColor;
        }
    }
    
    if (textField.tag==2) {
        if ((self.phoneTF.text.length > 1)&&(_confirmbtn.enabled == NO)) {
            
            _confirmbtn.enabled = YES;
            
            _confirmbtn.backgroundColor = AppFontEB4E4EColor;
            
            _confirmbtn.titleLabel.alpha = 1;
            
        }
        
        if ([toBeString length] > 30) { //密码最多30个字
            
            textField.text = [toBeString substringToIndex:30];
            
            return NO;
        }
    }
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UIColor *phoneColor = textField.tag == 1?JGJMainColor:LoginBorderColor;
    
    UIColor *pwdColor = textField.tag == 1?LoginBorderColor:JGJMainColor;
    
    _confirmbtn.titleLabel.alpha = 1;
    
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    
    self.pwdView.layer.borderColor = pwdColor.CGColor;
    
    //如果有一条没有填没有，则改变状态
    if ([NSString isEmpty:self.verifyTF.text] || [NSString isEmpty:self.verifyTF.text]) {
        
        _confirmbtn.enabled = NO;
        
        _confirmbtn.backgroundColor = AppFontEB4E4EColor;
        
        _confirmbtn.titleLabel.alpha = 0.5;
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIColor *phoneColor = textField.tag == 2?JGJMainColor:LoginBorderColor;
    UIColor *pwdColor = textField.tag == 2?LoginBorderColor:JGJMainColor;
    
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    self.pwdView.layer.borderColor = pwdColor.CGColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
