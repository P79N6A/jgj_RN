//
//  JLGLoginViewController.m
//  mix
//
//  Created by jizhi on 15/11/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGLoginViewController.h"

#import "TYBaseTool.h"
#import "TYShowMessage.h"
#import "TYPredicate.h"
#import "TYTextField.h"
#import "TYLoadingHub.h"
#import "TYAddressBook.h"
#import "NSString+JSON.h"
#import "CALayer+SetLayer.h"
#import "NSString+Extend.h"
#import "JLGAppDelegate.h"
#import "NSString+Password.h"
#import "JLGCustomViewController.h"
#import "JLGForgetPasswordViewController.h"
#import "JLGGetVerifyButton.h"
#import "UILabel+GNUtil.h"
#import "TYTextField.h"
#import "JGJWebAllSubViewController.h"
#import "JGJAddressBookTool.h"
#import "JLGAgreementViewController.h"

#import "JGJLogAlertView.h"

#import "WXApi.h"

#import "JLGLoginViewController.h"

#import "JGJBindTelVc.h"

#import "JLGAppDelegate+Service.h"

#import <BaiduMobStatCodeless/BaiduMobStat.h>

#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

#define errorMessage @"请输入正确的手机号码"

#define LoginWidthFloat 0.5
//设置输入框
#define LoginBorderColor TYColorHex(0xc7c7c7)

#define TYISIphone5Ratio (TYIS_IPHONE_5 ? 0.5 : (TYIS_IPHONE_4_OR_LESS ? 0.3 : 1))

typedef void(^WXBindTelBlock)(id response);

typedef void(^JGJAuthorBindTelBlock)(JGJWeiXinuserInfo *wxUserInfo);

@interface JLGLoginViewController () <JLGGetVerifyButtonDelegate,UITextFieldDelegate, WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *verifyTF;
@property (weak, nonatomic) IBOutlet JLGGetVerifyButton *getVerifyButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *proButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logImageViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxContainViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proButtonTop;

@property (strong, nonatomic) JGJLoginUserInfoRequest *request; //登录请求

//授权绑定手机号
@property (nonatomic, copy) JGJAuthorBindTelBlock authorBindTelBlock;
@property (weak, nonatomic) IBOutlet UIView *wxContainView;

@end

@implementation JLGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //登录失效先清除登录状态
    JLGExitLogin;
    
    
    [self initVc];
    [self initSubView];
    [TYNotificationCenter addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [TYNotificationCenter addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
//    [TYNotificationCenter addObserver:self selector:@selector(wxBindpostNotification:) name:JGJWXBindpostNotification object:nil];
    
    TYWeakSelf(self);
    
    JLGAppDelegate *app = ((JLGAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    app.thirdAuthorLoginSuccessBlock = ^(JGJWeiXinuserInfo *wxUserInfo) {
        
        [weakself wxBindWithwxUserInfo:wxUserInfo];
        
    };
    
    self.wxContainView.hidden = ![WXApi isWXAppInstalled];
   
    // 拉起闪验授权页并进行登录
    [self shanyanQuickAuthLogin];
    
}

/**
 拉起闪验授权页并进行登录
 */
- (void)shanyanQuickAuthLogin
{
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    //电信定制界面
    CLCTCCUIConfigure * ctccUIConfigure = [CLCTCCUIConfigure new];
    ctccUIConfigure.logoImg = logoImage;
    ctccUIConfigure.viewController = self;
    //移动定制界面
    CLCMCCUIConfigure * cmccUIConfigure = [CLCMCCUIConfigure new];
    cmccUIConfigure.viewController = self;
    cmccUIConfigure.logoImg = logoImage;
    //联通定制界面
    CLCUCCUIConfigure * cuccUIConfigure = [CLCUCCUIConfigure new];
    cuccUIConfigure.viewController = self;
    cuccUIConfigure.UAPageContentLogo = logoImage;
    
    // 禁止登录页面点击
    self.view.userInteractionEnabled = NO;
    [CLShanYanSDKManager quickAuthLoginWithConfigureCTCC:ctccUIConfigure CMCC:cmccUIConfigure CUCC:cuccUIConfigure timeOut:1 complete:^(CLCompleteResult * _Nonnull completeResult) {
        // 解除登录页面禁止点击
        self.view.userInteractionEnabled = YES;
        
        if (completeResult.error) {
            TYLog(@"===获取闪验accessToken失败==>%@==\n错误码==>%zd",completeResult.error,completeResult.code);
            // 1.拉起授权页失败
            // 2.授权页成功拉起,请求accessToken失败
            // 错误码1011:点击返回
            
            // 1.拉起授权页失败,不做处理
            if ([CLShanYanSDKManager clSDKInitStutas] != CLSDKInitStutasSUCCESS) return;
            // 2.拉起授权页成功,请求accessToken失败

            // 2.1 点击返回按钮,取消一键登录,不做处理
            if (completeResult.code == 1011) return;
            // 2.2 其他情况
            [TYShowMessage showError:@"免密登录失败，请使用验证码登录"];
            
        } else {
            // 闪验一键登录
            [self requestShanyanLoginWithData:completeResult.data];
        }
    }];
}

/**
 闪验一键登录
 */
- (void)requestShanyanLoginWithData:(NSDictionary *)data
{
    
    [TYLoadingHub showLoadingWithMessage:nil];
    NSString *url = @"v2/Signup/flashlogin";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telecom"] = data[@"telecom"] ?: @"";
    params[@"accessToken"] = data[@"accessToken"] ?: @"";
    params[@"flashtimestamp"] = data[@"timestamp"] ?: @"";
    params[@"randoms"] = data[@"randoms"] ?: @"";
    params[@"flashsign"] = data[@"sign"] ?: @"";
    params[@"flashversion"] = data[@"version"] ?: @"";
    params[@"device"] = data[@"device"] ?: @"";
    params[@"role"] = @"4";
    [JLGHttpRequest_AFN PostWithApi:url parameters:params success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [self didLoginSuccess:responseObject wxBindTelBlock:nil];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

/**
 点击授权页面上的其他登录
 */
- (void)otherLoginWayBtnCliced:(UIButton *)loginBtn
{
    self.view.userInteractionEnabled = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}
/**
 登录成功之后的操作
 */
- (void)didLoginSuccess:(NSDictionary *)responseObject wxBindTelBlock:(WXBindTelBlock)wxBindTelBlock
{
    //清楚wechatid
    self.request.wechatid = nil;
    
    JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
    
    BOOL isBind = ![userInfo.is_bind isEqualToString:@"1"];
    
    if (wxBindTelBlock && isBind) {
        
        wxBindTelBlock(responseObject);
        
        return ;
    }
    
    //保存状态
    [TYUserDefaults setObject:responseObject[JLGUserUid] forKey:JLGUserUid];
    [TYUserDefaults setBool:YES forKey:JLGLogin];
    [TYUserDefaults setBool:NO forKey:JLGIsRequestChatList];
    if (![NSString isEmpty:userInfo.telephone]) {
        
        [TYUserDefaults setObject:userInfo.telephone forKey:JLGPhone];
        
    }else if (![NSString isEmpty:self.phoneTF.text]) {
        
        [TYUserDefaults setObject:self.phoneTF.text forKey:JLGPhone];
    }
    
    
    [TYUserDefaults setObject:responseObject[JLGToken] forKey:JLGToken];
    
    [TYUserDefaults setObject:responseObject[JLGHeadPic] forKey:JLGHeadPic];
    
    //登录成功以后上传通讯录
    if ([self isPermitAddressBook]) {
        
        [self loadAddressBook];
    }
    
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
    [self backToVc];
    
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    
    infoVer += 1;
    
    [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
    
    TYLog(@"loginStsocketUrlConnect-------%@", [TYUserDefaults objectForKey:JLGToken]);
    
    TYLog(@"infoVer-----%@", @(infoVer));
    //登录处理消息
    
    [JLGAppDelegate handleOfflineMsgService];
    
    //连接socket
    
    [JGJSocketRequest socketReconnect];
    
    [JGJSocketRequest socketHeartTimerStart];
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (![NSString isEmpty:uid]) {
        
        [[BaiduMobStat defaultStat] setUserId:uid];
    }
    
    TYLog(@"loginsocketReconnectStsocketUrlConnect-------%@", [TYUserDefaults objectForKey:JLGToken]);
    
    //延迟的原因主要是需要cookie重置
    NSString *channelID = [TYUserDefaults objectForKey:JLGPushChannelID];
    if (![NSString isEmpty:channelID]) {
        //延迟的原因主要是需要cookie重置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //上传channelID
            [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:@{@"channel_id":[TYUserDefaults objectForKey:JLGPushChannelID]?:@"",@"os":@"I"} success:^(id responseObject) {
            }];
        });
    }
}



-(void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;

    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y;

    CGRect convertRect = [self.loginButton.superview convertRect:self.loginButton.frame toView:self.view];
    
    CGFloat loginBtnOffset = TYGetUIScreenHeight - convertRect.origin.y - TYGetViewH(self.loginButton);

    CGFloat offset = loginBtnOffset - yEndOffset;
    
    if (offset <= 0) {

        offset = fabs(80 - fabs(offset));

        _scrollView.transform =CGAffineTransformMakeTranslation(0, -offset);
    }
    
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //登录页面去掉返回按钮，未登录强制进入登录页面
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [JLGCustomViewController setStatusBarBackgroundColor:[UIColor whiteColor]];
    
    TYLog(@"viewWillAppearcloseSocket-----%@", [TYUserDefaults objectForKey:JLGToken]);
    
//    JGJSocketRequest *socket = [JGJSocketRequest shareSocketConnect];
    
    //登录页面关闭socket
    [JGJSocketRequest closeSocket];
    
    //结束心跳包
    [JGJSocketRequest socketHeartTimerEnd];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];//设置颜色

}
#pragma mark - 加这句的目的是web页面进入原生登录会造成当前第一响应者不可控
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (TYGetUIScreenHeight < 667 && TYIS_IPAD) {
        
        self.scrollView.contentSize = CGSizeMake(TYGetUIScreenWidth, 667);
    }
    
//    if (!self.phoneTF.isFirstResponder) {
//        [self.phoneTF becomeFirstResponder];
//    }
}
- (void)initSubView
{
    if (TYGetUIScreenWidth <= TYIS_IPHONE_5) {
        
        _verifyTF.placeholder = @"请输入收到的验证码";
        
        [_getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    NSString *firstStr = @"登录即同意";
    
    NSString *secStr = @"《吉工宝用户服务协议》";
    
    NSString * proStr = [NSString stringWithFormat:@"%@ %@", firstStr, secStr];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:proStr];

    NSRange range1 = [proStr rangeOfString:firstStr];
    
    NSRange range2 = [proStr rangeOfString:secStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:AppFontd7252cColor range:range2];
    
    [str addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:range1];
    
    [self.proButton setAttributedTitle:str forState:UIControlStateNormal];
    
    [self.proButton addTarget:self action:@selector(proButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.logImageViewTop.constant = TYISIphone5Ratio * self.logImageViewTop.constant;
    
    self.contentViewTop.constant = TYISIphone5Ratio * self.contentViewTop.constant;
    
    self.wxContainViewTop.constant = TYISIphone5Ratio * self.wxContainViewTop.constant;
    
    self.proButtonTop.constant = TYISIphone5Ratio * self.proButtonTop.constant;
}

- (void)initVc{
    
    self.verifyTF.maxLength = 4;
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
     //web进入当前页面最后响应者是输入验证码，这里必须注销
    if (self.verifyTF.isFirstResponder) {
        [self.verifyTF resignFirstResponder];
        [self.phoneTF resignFirstResponder];
    }
    //不使用IQKeyborad的inputAccessoryView
    self.phoneTF.inputAccessoryView = [[UIView alloc] init];
    self.verifyTF.inputAccessoryView = [[UIView alloc] init];
    [self.phoneView.layer setLayerBorderWithColor:LoginBorderColor width:LoginWidthFloat radius:4.0];
    [self.pwdView.layer setLayerBorderWithColor:LoginBorderColor width:LoginWidthFloat radius:4.0];
     [self.getVerifyButton.layer setLayerCornerRadius:4];
     [self.getVerifyButton initColorWithH:JGJMainColor WithL:TYColorHex(0xc7c7c7) WithTimeCount:60];

    self.loginButton.enabled = NO;
    _loginButton.layer.shadowColor = AppFontEFB8B8Color.CGColor;
    _loginButton.layer.cornerRadius = 4;
    _loginButton.layer.shadowOffset = CGSizeMake(0, 4);
    _loginButton.layer.shadowOpacity = 0.8;
    [_loginButton setTitleColor:AppFontffffffColor forState:UIControlStateDisabled];
    _loginButton.titleLabel.alpha = .5;
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = AppFontEB4E4EColor;
    //返回键
    JLGCustomViewController *navVc = (JLGCustomViewController *)self.navigationController;
    UIButton *leftButton = [navVc getLeftNoTargetButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backToVc{
    
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    [jlgAppDelegate setRootViewController];
    
}


- (IBAction)loginBtnClick:(id)sender {
    if (self.phoneTF.text.length == 11)
    {
        if (![TYPredicate isRightPhoneNumer:self.phoneTF.text]) {
            
            [TYShowMessage showPlaint:errorMessage];
            
            return ;
        }
        
        if (self.verifyTF.text.length == 0) {
            
            [TYShowMessage showPlaint:@"输入的验证码不正确"];
            
            return;
        }
        
        [self.verifyTF endEditing:YES];
        
        [self.phoneTF endEditing:YES];
        
        //登录接口
        self.request.api = @"v2/signup/login";
        
        [self requestUserInfoBlock:nil];
        
    }
    
    else {
        
        [TYShowMessage showPlaint:errorMessage];
    }
    
}

#pragma mark - 这句主要用于打补丁使用当前版本上传通信录被拒绝
- (BOOL)isPermitAddressBook {
    
    return NO;
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
        
        if ((self.verifyTF.text.length > 1)&&(self.loginButton.enabled == NO)) {
            self.loginButton.enabled = YES;
            self.loginButton.backgroundColor = AppFontEB4E4EColor;
        }
    }
    
    if (textField.tag==2) {
        if ((self.phoneTF.text.length > 1)&&(self.loginButton.enabled == NO)) {
            self.loginButton.enabled = YES;
            self.loginButton.backgroundColor = AppFontEB4E4EColor;
            _loginButton.titleLabel.alpha = 1;

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
    _loginButton.titleLabel.alpha = 1;
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    self.pwdView.layer.borderColor = pwdColor.CGColor;
    
    //如果有一条没有填没有，则改变状态
    if ([NSString isEmpty:self.verifyTF.text] || [NSString isEmpty:self.verifyTF.text]) {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = AppFontEB4E4EColor;
        _loginButton.titleLabel.alpha = 0.5;

    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIColor *phoneColor = textField.tag == 2?JGJMainColor:LoginBorderColor;
    UIColor *pwdColor = textField.tag == 2?LoginBorderColor:JGJMainColor;
    
    self.phoneView.layer.borderColor = phoneColor.CGColor;
    self.pwdView.layer.borderColor = pwdColor.CGColor;
}

#pragma mark - scrollView 隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 读联系人
- (void)loadAddressBook{
    [TYAddressBook loadAddressBookByHttp];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender{
    if ([segue.destinationViewController isKindOfClass:[JLGForgetPasswordViewController class]]) {
        JLGForgetPasswordViewController *forgetPassVc = (JLGForgetPasswordViewController *)segue.destinationViewController;
        forgetPassVc.phoneStr = self.phoneTF.text;
    }
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
        
        self.loginButton.enabled = NO;
 
    }
    
    [self.view endEditing:YES];

}
-(void)loginAndSenddevicetoken
{
    NSString *deviceToken = [TYUserDefaults objectForKey:JGJDevicePushToken];
    
    if (![NSString isEmpty:deviceToken]) {
        
        [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:@{@"channel_id":deviceToken?:@"",@"os":@"I",@"service_type":@"umeng"}  success:^(id responseObject) {
            TYLog( @"%@",responseObject);
        } failure:^(NSError *error) {
            TYLog( @"%@",[error description]);
            
        }];
    }

}

#pragma mark - 请求用户信息
- (void)requestUserInfoBlock:(WXBindTelBlock)wxBindTelBlock {
    
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    
    __weak typeof(self) weakSelf = self;
    
    self.request.telph = self.phoneTF.text;
    
    self.request.vcode = self.verifyTF.text;
    
    self.request.role = @"4";
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    //正确的手机号处理的结果
    [JLGHttpRequest_AFN PostWithApi:self.request.api parameters:parameters success:^(NSDictionary *responseObject) {
        [TYLoadingHub hideLoadingView];
        [weakSelf didLoginSuccess:responseObject wxBindTelBlock:wxBindTelBlock];
        
    }failure:^(NSError *error) {
        
        self.request.wechatid = nil;
        [TYLoadingHub hideLoadingView];
    }];
    
    
}

- (IBAction)proButtonPressed:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"my/agreement"];
    
    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc]
                                                     initWithWebType:JGJWebTypeInnerURLType URL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)wxLoginPressed:(UIButton *)sender {
    
    [self weChatLogin];
}

-(void)weChatLogin {
    
    //当前会退到后台调用，不接收聊天消息，在这里因为会重新更换token导致登录会不成功
    
    JLGAppDelegateAccessor.isUnCanReceiveChatMsg = YES;
    
        if ([WXApi isWXAppInstalled]) {
            
            //    方法二：手机没有安装微信也可以使用，推荐使用这个
            
            SendAuthReq *req = [[SendAuthReq alloc] init];
            
            req.scope = @"snsapi_userinfo";
            
            req.state = AuthorLogin;
            
            [WXApi sendAuthReq:req viewController:self delegate:self];
            

        } else {

            [TYShowMessage showPlaint:@"未检测到“微信”应用，请通过手机号登录"];
            
        }
    
}

- (void)wxBindWithwxUserInfo:(JGJWeiXinuserInfo *)wxUserInfo {
    
//    JGJWeiXinuserInfo *wxUserInfo = notify.object;
    
    self.request.wechatid = wxUserInfo.unionid;
    
    //授权不传电话和验证码
    self.request.telph = @"";
    
    self.request.vcode = @"";
    
    TYLog(@"-------%@", wxUserInfo.unionid);
    
    TYWeakSelf(self);
    
     self.request.api = @"v2/signup/wxlogin";
    
    //请求用户信息 是否绑定
    [self requestUserInfoBlock:^(id response) {
        
        [weakself bindTelVcWithWXUserInfo:wxUserInfo];
        
    }];
    

}

- (void)bindTelVcWithWXUserInfo:(JGJWeiXinuserInfo *)wxUserInfo{
    
    //请求用户信息 是否绑定
    JGJBindTelVc *bindTelVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBindTelVc"];
    
    bindTelVc.wxUserInfo = wxUserInfo;
    
    [self.navigationController pushViewController:bindTelVc animated:YES];
    
}

- (JGJLoginUserInfoRequest *)request {
    
    if (!_request) {
        
        _request = [JGJLoginUserInfoRequest new];
        
        _request.os = @"I";
        
        _request.role = @"4";
        
        _request.telph = @"";
        
        _request.vcode = @"";
    }
    
    return _request;
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

- (IBAction)findAccountAction:(id)sender {
    
    
}


@end
