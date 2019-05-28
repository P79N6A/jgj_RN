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
#import "TYTextField.h"
#import "JGJWebAllSubViewController.h"
#import <AddressBook/AddressBook.h>
#import "JGJAddressBookTool.h"

#import "YZGSelectedRoleViewController.h"

#import "JGJLogAlertView.h"

#import "WXApi.h"

#import "JGJBindTelVc.h"
#import "JGJLoginFindAccountNumberViewController.h"

#import "JGJChatOffLineMsgTool.h"
#import "JGJChatMsgDBManger.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"

#import "JGJLocationManger.h"

#import <BaiduMobStatCodeless/BaiduMobStat.h>
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
#import "JGJDeviceTokenManager.h"


#define errorMessage @"请输入正确的手机号码"

#define LoginWidthFloat 0.5
//设置输入框
#define LoginBorderColor TYColorHex(0xc7c7c7)

#define TYISIphone5Ratio (TYIS_IPHONE_5 ? 0.5 : (TYIS_IPHONE_4_OR_LESS ? 0.3 : 1))

typedef void(^WXBindTelBlock)(id response);

typedef void(^JGJAuthorBindTelBlock)(JGJWeiXinuserInfo *wxUserInfo);

@interface JLGLoginViewController () <JLGGetVerifyButtonDelegate, WXApiDelegate>
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

@property (weak, nonatomic) IBOutlet UIView *thirdLoginView;


- (IBAction)findAccountAction:(UIButton *)sender;


@end

@implementation JLGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录失效先清除登录状态
    JLGExitLogin;

    [self initVc];
    
    [self initSubView];
    
    [TYNotificationCenter addObserver:self
     
                             selector:@selector(keyboardShow:)
     
                                 name:UIKeyboardWillShowNotification object:nil];
    [TYNotificationCenter addObserver:self
     
                             selector:@selector(keyboardWillHidden:)
     
                                 name:UIKeyboardWillHideNotification object:nil];
    
//    [TYNotificationCenter addObserver:self selector:@selector(wxBindpostNotification:) name:JGJWXBindpostNotification object:nil];
    
    TYWeakSelf(self);
    
    JLGAppDelegate *app = ((JLGAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    app.thirdAuthorLoginSuccessBlock = ^(JGJWeiXinuserInfo *wxUserInfo) {
      
        [weakself wxBindWithwxUserInfo:wxUserInfo];
        
    };
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.thirdLoginView.hidden = ![WXApi isWXAppInstalled] || TYIS_IPAD;
    
    if (!self.phoneTF.isFirstResponder) {
        
//        [self.phoneTF becomeFirstResponder];
    }
    // 拉起闪验授权页并进行登录
    [self shanyanQuickAuthLogin];

    
}

/**
 拉起闪验授权页并进行登录
 */
- (void)shanyanQuickAuthLogin
{
    // 防止JLGLoginViewController创建多次时,下面闪验block捕获的是第一次创建的对象,产生bug
    static JLGLoginViewController *_loginVc;

    UIImage *logoImage = [UIImage imageNamed:@"quick-login-logo"];
    //电信定制界面
    CLCTCCUIConfigure * ctccUIConfigure = [CLCTCCUIConfigure new];
    ctccUIConfigure.viewController = self;
    ctccUIConfigure.logoImg = logoImage;
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
    _loginVc = self;
    NSTimeInterval timeOut = 1.0;
    // 防止闪验sdk回调未执行,导致self.view.userInteractionEnabled一直是NO
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _loginVc.view.userInteractionEnabled = YES;
    });

    
    [CLShanYanSDKManager quickAuthLoginWithConfigureCTCC:ctccUIConfigure CMCC:cmccUIConfigure CUCC:cuccUIConfigure timeOut:1 complete:^(CLCompleteResult * _Nonnull completeResult) {
        // 解除登录页面禁止点击
        _loginVc.view.userInteractionEnabled = YES;
        
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
            [_loginVc requestShanyanLoginWithData:completeResult.data];
        }
        _loginVc = nil;
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
    params[@"role"] = JLGisMateBool?@"1":@"2";
    [JLGHttpRequest_AFN PostWithApi:url parameters:params success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [self didLoginSuccess:responseObject wxBindTelBlock:nil];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showError:@"免密登录失败，请使用验证码登录"];
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

- (void)initSubView
{
    if (TYGetUIScreenWidth <= TYIS_IPHONE_5) {
        
        _verifyTF.placeholder = @"请输入收到的验证码";
        
        [_getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
    NSString *firstStr = @"登录即同意";
    
    NSString *secStr = @"《吉工家用户服务协议》";
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //登录页面去掉返回按钮，未登录强制进入登录页面
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    //登录页面关闭socket
    [JGJSocketRequest closeSocket];
    
    //结束心跳包
    [JGJSocketRequest socketHeartTimerEnd];
    
    
    
}


#pragma mark - 加这句的目的是web页面进入原生登录会造成当前第一响应者不可控
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (TYGetUIScreenHeight < 667 && TYIS_IPAD) {
        
        self.scrollView.contentSize = CGSizeMake(TYGetUIScreenWidth, 667);
    }
}

- (void)initVc{
    self.verifyTF.maxLength = 4;
    
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
    [self.getVerifyButton initColorWithH:AppFontEB4E4EColor WithL:TYColorHex(0xc7c7c7) WithTimeCount:60];
    //设置登录键
    self.loginButton.enabled = NO;
    _loginButton.layer.shadowColor = AppFontEFB8B8Color.CGColor;
    _loginButton.layer.cornerRadius = 4;
    _loginButton.layer.shadowOffset = CGSizeMake(0, 4);
    _loginButton.layer.shadowOpacity = 0.8;
    [_loginButton setTitleColor:AppFontffffffColor forState:UIControlStateDisabled];
    _loginButton.titleLabel.alpha = .5;
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = AppFontEB4E4EColor;
    
    self.loginButton.enabled = NO;

    
//去掉返回按钮

    UIView *defaultView = [UIView new];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:defaultView];
    
    if (TYIS_IPHONE_6P) {
        
        self.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
    }
  
}

- (void)backToVc{
    
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [jlgAppDelegate setRootViewController];
    
    TYWeakSelf(self);

//    jlgAppDelegate.setRootSuccessBlock = ^{
//
//        [weakself dismissLoginVc];
//
//    };
    
}

- (void)dismissLoginVc {
    
    self.view.hidden = YES;
    
    if (self.presentationController) {

        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    else
    {
        [TYShowMessage showPlaint:errorMessage];
    }
}

#pragma mark - 选择身份
- (void)selRoleVc {
    
    [TYUserDefaults setBool:YES forKey:JGJLoginFirstChangeRole];
    
    YZGSelectedRoleViewController *selRoleVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    
    selRoleVc.view.tag = 1;//如果为1，说明是从首页present的
    
    selRoleVc.isHiddenCancelButton = YES;
    
    [self presentViewController:selRoleVc animated:YES completion:nil];
    
    TYWeakSelf(self);
    
    selRoleVc.selRoleSuccessBlock = ^{
      
        [weakself dismissLoginVc];
        
        [TYUserDefaults setBool:NO forKey:JGJLoginFirstChangeRole];
        
        // 选完角色预加载首页数据
        [JGJChatGetOffLineMsgInfo http_getHomeCalendarData];
    };
    
}

#pragma mark - 这句主要用于打补丁使用当前版本上传通信录被拒绝
- (BOOL)isPermitAddressBook {
    
    return YES;
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

#pragma mark - 已授权按才上传联系人，这里弹框读取联系人审核可能不会过，因为弹出的对话框。使用者不明白为什么在登录也要弹授权访问框
- (void)loadAddressBook{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                [TYAddressBook loadAddressBookByHttp];
        });
        [TYAddressBook loadAddressBookByHttp];
    }
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
    
    sender.backgroundColor = [UIColor whiteColor];
    
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
        
//        [TYShowMessage showPlaint:@"未检测到“微信”应用，请通过手机号登录"];
        
    }
    
}

- (void)wxBindWithwxUserInfo:(JGJWeiXinuserInfo *)wxUserInfo {
    
//    JGJWeiXinuserInfo *wxUserInfo = notify.object;
    
    self.request.wechatid = wxUserInfo.unionid;
    
    [TYUserDefaults setObject:wxUserInfo.unionid forKey:JGJUnionid];
    
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

- (void)requestUserInfoBlock:(WXBindTelBlock)wxBindTelBlock {
 
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    
    self.request.telph = self.phoneTF.text;
    
    self.request.vcode = self.verifyTF.text;
    
//    self.request.os = @"I";
    
    self.request.role = JLGisMateBool?@"1":@"2";
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    __weak typeof(self) weakSelf = self;
    //正确的手机号处理的结果
    [JLGHttpRequest_AFN PostWithApi:self.request.api parameters:parameters success:^(NSDictionary *responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf didLoginSuccess:responseObject wxBindTelBlock:wxBindTelBlock];
        
    }failure:^(NSError *error) {
        
        self.request.wechatid = nil;
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
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

    NSDictionary *dic = [NSDictionary dictionary];
    [TYUserDefaults setObject:dic forKey:JLGLastRecordBillPeople];
    //保存状态
    [TYUserDefaults setObject:responseObject[JLGUserUid] forKey:JLGUserUid];
    [TYUserDefaults setBool:YES forKey:JLGLogin];
    
    if (![NSString isEmpty:userInfo.telephone]) {
        
        [TYUserDefaults setObject:userInfo.telephone forKey:JLGPhone];
    }else {
        
        [TYUserDefaults setObject:self.phoneTF.text forKey:JLGPhone];
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
    
    // 登录成功 获取首页班组信息
    [JGJChatGetOffLineMsgInfo http_getChatIndexList];
    
    // 登录成功 获取聊聊列表
    [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:nil];
    
    //获取离线消息
    [JGJChatOffLineMsgTool getOfflineMessageListCallBack:nil];
    
    // 获取关闭的项目班组
    [JGJChatGetOffLineMsgInfo http_getClosedGroupList];
    
    // 登录成功获取记事本信息
    [self getNoteListSituation];
    
    // 清空缓存的首页数据
    [TYUserDefaults setObject:@{} forKey:JGJHomeCalendarBillData];
    if (!JGJIsSelRoleBool) {
        
        //选择身份
        [self selRoleVc];
    }
    
    //确定当前身份
    NSInteger role = [workZone.role integerValue];
    
    if (role == 2) {
        
        [TYUserDefaults setBool:NO forKey:JLGMateIsInfo];
        
        [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
        
    }else{
        
        [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
        
        [TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
    }
    
    //登录后移除之前的key
    [TYUserDefaults removeObjectForKey:JGJHomeLoadStatusKey];
    
    //            [weakSelf changeLoginStatus]; //登录状态改变刷新webView页面
    //登录成功以后上传通讯录
    if ([self isPermitAddressBook]) {
        
        [self loadAddressBook];
    }
    
    NSString *channelID = [TYUserDefaults objectForKey:JGJDevicePushToken];
    if (![NSString isEmpty:channelID]) {
        //延迟的原因主要是需要cookie重置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            //上传channelID
            [JGJDeviceTokenManager postDeviceToken:channelID];

        });
    }
    
    //如果有权限，直接赋权限,并且跳转到对应的权限界面
    if ([responseObject[@"is_info"] integerValue] == 1) {
        
        //设置权限
        NSInteger roleNum = [responseObject[@"double_info"] integerValue];
        if (roleNum == 1) {
            [TYUserDefaults setBool:NO forKey:JLGisLeader];
            [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
            [TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
        }else if (roleNum == 2){
            [TYUserDefaults setBool:YES forKey:JLGisLeader];
            [TYUserDefaults setBool:NO forKey:JLGMateIsInfo];
            [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
        }else{//保持当前的状态
            [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
            [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
        }
        
    }else{
        [TYUserDefaults synchronize];
        
    }
    
    [TYUserDefaults synchronize];
    
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    infoVer += 1;
    [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
    
    //登录后发送位置给服务器
    
    [JGJLocationManger requstLocation];
    
    //连接socket
    
    [JGJSocketRequest socketReconnect];
    
    [JGJSocketRequest socketHeartTimerStart];
    
    [self backToVc];
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (![NSString isEmpty:uid]) {
        
        [[BaiduMobStat defaultStat] setUserId:uid];
    }
}

- (void)getNoteListSituation {
    
    BOOL isLoadNoteList = [TYUserDefaults boolForKey:JGJHomeIsLoadNoteList];
    
    if (!isLoadNoteList) {
        
        NSDictionary *param = @{@"content_key":@"",
                                @"pg":@(1),
                                @"pagesize":@(20)
                                };
        
        [JLGHttpRequest_AFN PostWithNapi:@"notebook/get-list" parameters:param success:^(id responseObject) {
            
            [TYUserDefaults setBool:YES forKey:JGJHomeIsLoadNoteList];
            NSArray *noteList = [NSArray arrayWithObject:responseObject];
            if (noteList.count > 0) {
                
                [TYUserDefaults setBool:YES forKey:JGJUserHaveMakeANote];
                
            }else {
                
                [TYUserDefaults setBool:NO forKey:JGJUserHaveMakeANote];
            }
        } failure:^(NSError *error) {
            
            [TYUserDefaults setBool:NO forKey:JGJHomeIsLoadNoteList];
        }];
    }
}

- (JGJLoginUserInfoRequest *)request {
    
    if (!_request) {
        
        _request = [JGJLoginUserInfoRequest new];
        
        _request.os = @"I";
        
        _request.role = JLGisMateBool?@"1":@"2";
        
        _request.telph = @"";
        
        _request.vcode = @"";
    }
    
    return _request;
}

-(void)keyboardShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y;
    
    CGRect convertRect = [self.loginButton.superview convertRect:self.loginButton.frame toView:self.view];
    
    CGFloat loginBtnOffset = TYGetUIScreenHeight - convertRect.origin.y - TYGetViewH(self.loginButton);
    
    CGFloat offset = loginBtnOffset - yEndOffset;
    
    if (offset <= 0) {
        
        offset = fabs(80 - fabs(offset));
        
        _scrollView.transform =CGAffineTransformMakeTranslation(0, -offset);
        
    }else if (TYIS_IPHONE_6) {
        
        _scrollView.transform = CGAffineTransformMakeTranslation(0, -55);
 
    }
    
}

-(void)keyboardWillHidden:(NSNotification*)aNotification {
    
    _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    
}

// 找回账号
- (IBAction)findAccountAction:(UIButton *)sender {
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:[[JGJLoginFindAccountNumberViewController alloc] init] animated:YES];
}

@end
