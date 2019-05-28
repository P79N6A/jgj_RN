//
//  JGJmodifiPhoneViewController.m
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJmodifiPhoneViewController.h"
#import "JGJCustomAlertView.h"
#import "NSString+Extend.h"
@interface JGJmodifiPhoneViewController ()
<
UITextFieldDelegate
>
{
    int time;
    UITextField *textfiled;
    NSString *oldPhoneNumber;
    NSString *newPhoneNumber;
    NSString *modifyNum;//输入的验证码
    NSString *NmodifyNum;//获取的验证码

    JGJCustomAlertView *customAlertView;
}
@property(nonatomic,assign)BOOL keyBoardlsVisible;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *phoneTextWidth;//号码输入框的宽度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *numTextheight;//验证码输入框的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *numtextwidth;//验证码输入框的宽度

@end

@implementation JGJmodifiPhoneViewController

- (void)viewDidLoad {
//    _numtextwidth.constant = 300;
    
    _phoneTextfiled.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextfiled.delegate = self;
    [super viewDidLoad];
    [self loadviewxib];
    self.title = @"修改手机号码";
    _keyBoardlsVisible = NO;
    [textfiled addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [_phoneTextfiled addTarget:self
                  action:@selector(phoneTextChange:)
        forControlEvents:UIControlEventEditingChanged];
    CGFloat Hconstant = TYGetUIScreenHeight / 667;
    CGFloat Wconstant = TYGetUIScreenWidth / 375;

//    _phoneTextfiled.layer.borderColor = [[UIColor clearColor] CGColor];
    _phoneTextfiled.borderStyle =  UITextBorderStyleNone;
    _numTextheight.constant = 59 * Hconstant;
    _phoneTextWidth.constant = 161 * Wconstant;
    _phoneTextfiled.text = [TYUserDefaults objectForKey:JLGPhone];
    if (_phoneTextfiled.text.length > 0) {
        _phoneTextfiled.font = [UIFont systemFontOfSize:20];
    }
    if ([NSString isEmpty:_fourthlable.text ]) {
        _nextstpbutton.backgroundColor = AppFontccccccColor;
        [_nextstpbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextstpbutton.userInteractionEnabled = NO;
        _nextstpbutton.layer.cornerRadius = 5;
        _nextstpbutton.layer.masksToBounds = YES;
        _nextstpbutton.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextstpbutton.layer.borderWidth = 1;
    }
//    _numtextwidth.constant  =
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

//  键盘弹出触发该方法
- (void)keyboardDidShow
{
    _keyBoardlsVisible = YES;
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide
{
    _keyBoardlsVisible =NO;
}
- (UIButton *)closeButton
{
    if (!_closeButton) {
        //270
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2+107,TYGetUIScreenHeight/2 - 82, 20, 20)];
        [_closeButton setImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;

}
-(void)clickCloseButton
{
    [customAlertView dismiss];

}
- (IBAction)getnumfromserver:(id)sender {
    
    if (![self validateContactNumber:_phoneTextfiled.text]) {
        [TYShowMessage showError:@"请输入正确的手机号码"];
        return;
    }
    if ([_nextstpbutton.titleLabel.text containsString:@"确认更换"]) {
        newPhoneNumber = _phoneTextfiled.text;
    }else{
        oldPhoneNumber = _phoneTextfiled.text;
    }
    [self getCheckNum];
    time = 60;

    [_getNumButton setTitle:[NSString stringWithFormat:@"%d秒后重发",time] forState:UIControlStateDisabled];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerrecordTime) userInfo:nil repeats:YES];
    _getNumButton.backgroundColor = AppFontccccccColor;
    [_getNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _getNumButton.userInteractionEnabled = NO;
    _getNumButton.layer.cornerRadius = 5;
    _getNumButton.layer.masksToBounds = YES;
    _getNumButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _getNumButton.layer.borderWidth = 1;
    
    if ([NSString isEmpty:_fourthlable.text]) {
        _nextstpbutton.backgroundColor = AppFontccccccColor;
        [_nextstpbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextstpbutton.userInteractionEnabled = NO;
        _nextstpbutton.layer.cornerRadius = 5;
        _nextstpbutton.layer.masksToBounds = YES;
        _nextstpbutton.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextstpbutton.layer.borderWidth = 1;
  
    }
    
}
- (IBAction)nextstep:(id)sender {
    
    
    if ([NSString isEmpty:_fourthlable.text]) {
        [TYShowMessage showError:@"请输入正确的验证码"];

        return;
    }
//    if (![NmodifyNum isEqualToString:modifyNum]) {
//        [TYShowMessage showError:@"请输入正确的验证码"];
//        return;
//    }else{
//        
        [self modifyPhoneNumber];
/*去掉
        if ([_nextstpbutton.titleLabel.text isEqualToString:@"确认更换"]) {
            if (_phoneTextfiled.text.length >= 11 && _fourthlable.text && [_nextstpbutton.titleLabel.text containsString:@"确认更换"]) {
                [self modifyPhoneNumber];
            }

        }else{
            [self modifyPhoneNumber];


        }
 */
//    }
   
}



//第一步验证码验证正确 调到第二部
-(void)jumpCHangePhoneNUmber
{
    if (_phoneTextfiled.text.length >= 11 && _fourthlable.text && ![_nextstpbutton.titleLabel.text containsString:@"确认更换"]) {
        [_nextstpbutton setTitle:@"确认更换" forState:UIControlStateNormal];
        _phoneTextfiled.text = nil;
        _phoneTextfiled.placeholder = @"请输入新手机号";
        time = 0;
        _firstlable.text = nil;
        _secondlable.text = nil;
        _thirdlable.text = nil;
        _fourthlable.text = nil;
        textfiled.text = nil;
        
    }
    if ([NSString isEmpty:_fourthlable.text ]) {
        _nextstpbutton.backgroundColor = AppFontccccccColor;
        [_nextstpbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextstpbutton.userInteractionEnabled = NO;
        _nextstpbutton.layer.cornerRadius = 5;
        _nextstpbutton.layer.masksToBounds = YES;
        _nextstpbutton.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextstpbutton.layer.borderWidth = 1;
    }

   
}

- (IBAction)clicknotownMe:(id)sender {
    
    
//    JGJCustomAlertView *customAlertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"请联系客服解决!\n400 862 3818"];
     customAlertView = [JGJCustomAlertView customAlertViewShowWithMessagecallphone:@"请联系客服解决!\n400 862 3818"];
    customAlertView.message.font = [UIFont systemFontOfSize:AppFont34Size];
    [customAlertView addSubview:self.closeButton];
    customAlertView.onClickedBlock = ^{
        NSString * str=[NSString stringWithFormat:@"tel:%@",@"4008623818"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)timerrecordTime
{
    time --;
    [_getNumButton setTitle:[NSString stringWithFormat:@"%d秒后重发",time] forState:UIControlStateNormal];

    if (time <= 0) {
        [_timer invalidate];
        _getNumButton.userInteractionEnabled = YES;
        [_getNumButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        _getNumButton.layer.cornerRadius = 5;
        _getNumButton.layer.masksToBounds = YES;
        _getNumButton.layer.borderColor = AppFontd7252cColor.CGColor;
        _getNumButton.layer.borderWidth = 1;
        _getNumButton.backgroundColor = [UIColor whiteColor];
        [_getNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _nextstpbutton.layer.cornerRadius = 5;
        _nextstpbutton.layer.masksToBounds = YES;
        _nextstpbutton.layer.borderColor = AppFontd7252cColor.CGColor;
        _nextstpbutton.layer.borderWidth = 1;
        _nextstpbutton.backgroundColor = JGJMainColor;
    }
}
- (BOOL)validateContactNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       || ([regextestPHS evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadviewxib{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplable)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplable)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplable)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplable)];

    _firstlable.layer.cornerRadius = 5;
    _firstlable.layer.masksToBounds = YES;
    _firstlable.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _firstlable.layer.borderWidth = 1;
    _firstlable.userInteractionEnabled = YES;
    [_firstlable addGestureRecognizer:tap];
    textfiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    textfiled.keyboardType = UIKeyboardTypeNumberPad;
    [_firstlable addSubview:textfiled];
    _secondlable.layer.cornerRadius = 5;
    _secondlable.layer.masksToBounds = YES;
    _secondlable.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _secondlable.layer.borderWidth = 1;
    [_secondlable addGestureRecognizer:tap1];
    _secondlable.userInteractionEnabled = YES;

    _thirdlable.layer.cornerRadius = 5;
    _thirdlable.layer.masksToBounds = YES;
    _thirdlable.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _thirdlable.layer.borderWidth = 1;
    [_thirdlable addGestureRecognizer:tap2];
    _thirdlable.userInteractionEnabled = YES;

    _fourthlable.layer.cornerRadius = JGJCornerRadius;
    _fourthlable.layer.masksToBounds = YES;
    _fourthlable.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _fourthlable.layer.borderWidth = 1;
    _fourthlable.userInteractionEnabled = YES;

    [_fourthlable addGestureRecognizer:tap3];

    
    _getNumButton.backgroundColor = [UIColor whiteColor];
    _getNumButton.layer.cornerRadius = JGJCornerRadius;
    _getNumButton.layer.masksToBounds = YES;
    _getNumButton.layer.borderColor = AppFontd7252cColor.CGColor;
    _getNumButton.layer.borderWidth = 1;
    
    
    _nextstpbutton.layer.cornerRadius = JGJCornerRadius;
    _nextstpbutton.layer.masksToBounds = YES;
    _nextstpbutton.layer.borderColor = AppFontd7252cColor.CGColor;
    _nextstpbutton.layer.borderWidth = 1;
    
    
    _notUsebutton.layer.cornerRadius =CGRectGetHeight(_notUsebutton.frame)/2;
    _notUsebutton.layer.masksToBounds = YES;
    _notUsebutton.layer.borderColor = AppFontd7252cColor.CGColor;
    _notUsebutton.layer.borderWidth = 1;
    
}
-(void)taplable
{
    
    if (_phoneTextfiled.text.length >=11) {
        [textfiled becomeFirstResponder];
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField.tag == 4) {
//        if (textField.text.length <=0) {
//            _phoneTextfiled.font = [UIFont systemFontOfSize:14];
//        }else{
//        
//            _phoneTextfiled.font = [UIFont systemFontOfSize:20];
//
//        }
//    }
    if (textField.text.length > 10 && ![NSString isEmpty:string]){
        return NO;
    }
        return YES;
}
-(void)textFieldDidChange:(UITextField *)textfileds
{
    if (textfileds.text.length <= 0) {
        _firstlable.text = @"";
        _secondlable.text = @"";
        _thirdlable.text = @"";
        _fourthlable.text = @"";
        _phoneTextfiled.font = [UIFont systemFontOfSize:14];
        
    }else if (textfileds.text.length ==1){
        _firstlable.text = textfileds.text;
        _secondlable.text = @"";
        _thirdlable.text = @"";
        _fourthlable.text = @"";

    
    }else if (textfileds.text.length == 2){
    
        _firstlable.text = [textfileds.text substringWithRange:NSMakeRange(0, 1)];
        _secondlable.text = [textfileds.text substringWithRange:NSMakeRange(1, 1)];
        _thirdlable.text = @"";
        _fourthlable.text = @"";

    }else if (textfileds.text.length == 3){
        _firstlable.text = [textfileds.text substringWithRange:NSMakeRange(0, 1)];
        _secondlable.text = [textfileds.text substringWithRange:NSMakeRange(1, 1)];
        _thirdlable.text = [textfileds.text substringWithRange:NSMakeRange(2, 1)];
        _fourthlable.text = @"";

    }else if (textfileds.text.length == 4){
        _firstlable.text = [textfileds.text substringWithRange:NSMakeRange(0, 1)];
        _secondlable.text = [textfileds.text substringWithRange:NSMakeRange(1, 1)];
        _thirdlable.text = [textfileds.text substringWithRange:NSMakeRange(2, 1)];
        _fourthlable.text = [textfileds.text substringWithRange:NSMakeRange(3, 1)];
        
        _nextstpbutton.layer.cornerRadius = 5;
        _nextstpbutton.layer.masksToBounds = YES;
        _nextstpbutton.layer.borderColor = AppFontd7252cColor.CGColor;
        _nextstpbutton.layer.borderWidth = 1;
        _nextstpbutton.backgroundColor = JGJMainColor;

        _nextstpbutton.userInteractionEnabled = YES;
    }else{
    
        textfileds.text = [textfileds.text substringWithRange:NSMakeRange(0, 4)];
        
    }
    modifyNum = textfileds.text;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 获取验证码
-(void)getCheckNum
{

    
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/getvcode" parameters:@{@"telph":[_nextstpbutton.titleLabel.text containsString:@"确认更换"]?newPhoneNumber:oldPhoneNumber,@"type":@"2"} success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NmodifyNum = responseObject[@"code"];
  
        }
        
//        if ([modifyNum isEqualToString:responseObject[@"code"]]) {
//            [self jumpCHangePhoneNUmber];
//        }else{
//            [TYShowMessage showError:@"请输入正确的验证码"];
//        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark - 修改手机
-(void)modifyPhoneNumber
{

    if ([_nextstpbutton.titleLabel.text containsString:@"确认更换"]) {
        newPhoneNumber = _phoneTextfiled.text;
    }else{
        oldPhoneNumber = _phoneTextfiled.text;
    }

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:oldPhoneNumber?:@"" forKey:@"telph"];	//原手机号码
//    [paramDic setObject:newPhoneNumber?:@"" forKey:@"ntelph"];//原手机号码（不传，验证原手机；传了验证新手机号码）
//    [paramDic setObject:@"1101" forKey:@"vcode"];//	验证码
    if (_fourthlable.text) {
    [paramDic setObject:modifyNum?:@"" forKey:@"vcode"];//	验证码
    }

    
[JLGHttpRequest_AFN PostWithApi:@"v2/signup/modifyTelephone" parameters:paramDic success:^(id responseObject) {
    if (!newPhoneNumber||newPhoneNumber.length <= 11) {
        [self jumpCHangePhoneNUmber];
    }
    
    if (newPhoneNumber.length > 10) {
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];

        [TYShowMessage showSuccess:@"电话号码已修改成功"];
        [TYUserDefaults setObject:newPhoneNumber forKey:JLGPhone];
        
        [TYUserDefaults synchronize];
        
        if (self.successBlock) {
            
            self.successBlock(newPhoneNumber);
            
        }

        [self.navigationController popViewControllerAnimated:YES];
        
    }
}];

}
-(void)phoneTextChange:(UITextField *)textfileds
{
    if (![NSString isEmpty:textfileds.text]) {
        _phoneTextfiled.font = [UIFont systemFontOfSize:20];
    }else{
        _phoneTextfiled.font = [UIFont systemFontOfSize:14];

    }
}
@end
