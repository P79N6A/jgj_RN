//
//  JGJBindTelVc.m
//  JGJCompany
//
//  Created by yj on 2018/3/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBindTelVc.h"

#import "JLGGetVerifyButton.h"

#import "TYTextField.h"

#import "TYPredicate.h"

#import "JLGAppDelegate.h"

#import "JLGCustomViewController.h"
#import "JGJDeviceTokenManager.h"

#define errorMessage @"请输入正确的手机号码"

#define LoginWidthFloat 0.5
//设置输入框
#define LoginBorderColor TYColorHex(0xc7c7c7)

@interface JGJBindTelVc () <JLGGetVerifyButtonDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;

@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *phoneTF;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *verifyTF;

@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation JGJBindTelVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVc];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)initVc{
    
    self.scrollView.scrollEnabled = NO;
    
    if (!self.phoneTF.isFirstResponder) {
        
        [self.phoneTF becomeFirstResponder];
    }
    
    self.phoneTF.maxLength = 11;
    
    self.verifyTF.maxLength = 4;

    //不使用IQKeyborad的inputAccessoryView
    self.phoneTF.inputAccessoryView = [[UIView alloc] init];
    
    self.verifyTF.inputAccessoryView = [[UIView alloc] init];
    
    [self.phoneView.layer setLayerBorderWithColor:LoginBorderColor width:LoginWidthFloat radius:4.0];
    
    [self.pwdView.layer setLayerBorderWithColor:LoginBorderColor width:LoginWidthFloat radius:4.0];
    
    [self.getVerifyButton.layer setLayerCornerRadius:4];
    
    [self.getVerifyButton initColorWithH:[UIColor whiteColor] WithL:TYColorHex(0xc7c7c7) WithTimeCount:60];
    
    [self.getVerifyButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:LoginWidthFloat radius:4.0];
    
//   设置绑定键

//    [self.bindButton.layer setLayerShadowWithColor:AppFontEFB8B8Color offset:CGSizeMake(0, 4) opacity:0.8 radius:4];
    
     self.bindButton.layer.shadowColor = AppFontEFB8B8Color.CGColor;

     self.bindButton.layer.cornerRadius = 4;

     self.bindButton.layer.shadowOffset = CGSizeMake(0, 4);

     self.bindButton.layer.shadowOpacity = 0.8;

    self.bindButton.enabled = NO;

    [self.bindButton setTitleColor:AppFontffffffColor forState:UIControlStateDisabled];

    self.bindButton.titleLabel.alpha = .5;

    [self.bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.bindButton.backgroundColor = AppFontEB4E4EColor;

}

- (IBAction)bindBtnClick:(id)sender {
    
    if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
        
        [TYShowMessage showPlaint:errorMessage];
        
        return ;
    }
    
    if ([TYPredicate isRightPhoneNumer:self.phoneTF.text])
    {
        
        if (self.verifyTF.text.length == 0) {
            
            [TYShowMessage showPlaint:@"输入的验证码不正确"];
            
            return;
        }
        
        [self.verifyTF endEditing:YES];
        
        [self.phoneTF endEditing:YES];
        
        NSDictionary *parameters = @{@"telph":self.phoneTF.text,
                                     
                                     @"vcode":self.verifyTF.text,
                                     
                                     @"os":@"I",
                                     
                                     @"role":@4,
                                     
                                     @"wechatid" : self.wxUserInfo.unionid?:@""
                                     
                                     };
        
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        
        __weak typeof(self) weakSelf = self;
        //正确的手机号处理的结果
        [JLGHttpRequest_AFN PostWithApi:@"v2/signup/login" parameters:parameters success:^(NSDictionary *responseObject) {
            JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
            [TYLoadingHub hideLoadingView];
            //保存状态
            [TYUserDefaults setObject:responseObject[JLGUserUid] forKey:JLGUserUid];
            [TYUserDefaults setBool:YES forKey:JLGLogin];
            
            if (![NSString isEmpty:userInfo.telephone]) {

                [TYUserDefaults setObject:userInfo.telephone forKey:JLGPhone];
            }else {
                
                [TYUserDefaults setObject:weakSelf.phoneTF.text forKey:JLGPhone];
            }

            [TYUserDefaults setObject:responseObject[JLGToken] forKey:JLGToken];
            [TYUserDefaults setObject:responseObject[JLGHeadPic] forKey:JLGHeadPic];
            
            //更新真实姓名的值
            [TYUserDefaults setBool:[responseObject[@"has_realname"] boolValue] forKey:JLGIsRealName];
            if (responseObject[JLGRealName]) {
                [TYUserDefaults setObject:responseObject[JLGRealName] forKey:JLGRealName];
            }else{
                [TYUserDefaults setObject:nil forKey:JLGRealName];
            }
            
            MyWorkZone *workZone = [MyWorkZone mj_objectWithKeyValues:responseObject];

            if (![NSString isEmpty:workZone.realname]) {
                
                [TYUserDefaults setObject:workZone.realname forKey:JGJUserName];
                
            }else if (![NSString isEmpty:workZone.user_name]) {
                
                [TYUserDefaults setObject:workZone.user_name forKey:JGJUserName];
            }
            
            [TYUserDefaults synchronize];
            
            [weakSelf backToVc];
//            //获取网络通讯录数据
//            [self loginSuccessLoadContacts];
            
            NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
            
            infoVer += 1;
            
            [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
            
            //延迟的原因主要是需要cookie重置
            NSString *channelID = [TYUserDefaults objectForKey:JGJDevicePushToken];
            if (![NSString isEmpty:channelID]) {
                //延迟的原因主要是需要cookie重置
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //上传channelID
                    [JGJDeviceTokenManager postDeviceToken:channelID];
                });
            }
            
        }failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
            
        }];
    }
    
}


- (void)backToVc{
    
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [jlgAppDelegate setRootViewController];
    
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

    if (textField.tag == 1)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] >= 11) {

            textField.text = [toBeString substringToIndex:11];

            //            //如果是电话，就自动变化
            //            [TYPredicate isRightPhoneNumer:textField.text] == YES?[self.verifyTF becomeFirstResponder]:[TYShowMessage showPlaint:errorMessage];

            return NO;
        }

        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';

        if (!(single >='0' && single<='9'))//数据格式正确
        {
            return NO;
        }

        if ((self.verifyTF.text.length > 1)&&(self.bindButton.enabled == NO)) {

            self.bindButton.enabled = YES;

            self.bindButton.backgroundColor = AppFontEB4E4EColor;

        }
    }

    if (textField.tag == 2) {

        if ((self.phoneTF.text.length > 1)&&(self.bindButton.enabled == NO)) {

            self.bindButton.enabled = YES;

            self.bindButton.backgroundColor = AppFontEB4E4EColor;

            self.bindButton.titleLabel.alpha = 1;

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
    self.bindButton.titleLabel.alpha = 1;
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    self.pwdView.layer.borderColor = pwdColor.CGColor;
    
    //如果有一条没有填没有，则改变状态
    if ([NSString isEmpty:self.verifyTF.text] || [NSString isEmpty:self.verifyTF.text]) {
        self.bindButton.enabled = NO;
        self.bindButton.backgroundColor = AppFontEB4E4EColor;
        self.bindButton.titleLabel.alpha = 0.5;
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    UIColor *phoneColor = textField.tag == 2?JGJMainColor:LoginBorderColor;
    
    UIColor *pwdColor = textField.tag == 2?LoginBorderColor:JGJMainColor;
    
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    
    self.pwdView.layer.borderColor = pwdColor.CGColor;
}

#pragma mark - 2.0添加
#pragma mark-获取验证码按钮按下

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
    
    [self.verifyTF becomeFirstResponder];
}

#pragma mark - 获取验证码的结果
- (void)getVerifyButtonResult:(BOOL)resultBool{
    
    if (!resultBool) {
        
        [self.getVerifyButton stopTimer];
        
        self.bindButton.enabled = NO;

    }
}

@end
