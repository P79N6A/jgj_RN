//
//  JGJAddAccountViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddAccountViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JGJSureWithdrawViewController.h"
#import "JGJWeiXin_pay.h"
//#import "Order.h"
//#import "APAuthV2Info.h"
@interface JGJAddAccountViewController ()
<WXApiDelegate,
WXApiManagerDelegate
>
@property (strong ,nonatomic)JGJAccountListModel *AccountListModel;

@end

@implementation JGJAddAccountViewController

- (void)viewDidLoad {
    _aliPayButton.selected = YES;
    _aliPayButton.transform = CGAffineTransformMakeScale(1.4, 1.4);

    [super viewDidLoad];
    self.title = @"正在添加提现账户";
    _loginType = alipayType;
//    UIView *departView = [[UIView alloc]initWithFrame:CGRectMake(0, 129.5, TYGetUIScreenWidth, 1)];
//    departView.backgroundColor = AppFontdbdbdbColor;
//    [self.baseView addSubview:departView];
//    [self.baseView addSubview:self.imageview];


    [self cheackInstallWxin];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)clickAlipaybutton:(id)sender {
    [self.view endEditing:YES];
    _loginType = alipayType;
    _aliPayButton.selected = YES;
    _wxinButton.selected = NO;
    
    _wexinNameLable.hidden = YES;
    _alipaynameLable.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        _aliPayButton.transform = CGAffineTransformMakeScale(1.4, 1.4);
        _wxinButton.transform = CGAffineTransformMakeScale(1, 1);
        _filedHeight.constant = 50;
        _filledDepart.constant = 37;
        if ([WXApi isWXAppInstalled]) {
            [self transImageviewToCenter:_aliPayButton];
  
        }
        
    }];
    
    [_addAccount setTitle:@"立即绑定支付宝" forState:UIControlStateNormal];

}

- (void)cheackInstallWxin
{
    //强制隐藏微信提现
//        if ([WXApi isWXAppInstalled]) {
//        //安装了微信
//           
//        }else{
        //未安装微信
            _wexinNameLable.hidden = YES;
            _alipaynameLable.hidden = NO;
           _wxinButton.hidden = YES;
           [self setAlipayButtonCenter];
//        }

}
-(void)setAlipayButtonCenter
{

    _alipayCenter.constant = -20;
    _imageviewcenter.constant = -8.5;
    _alipayNamelableConstance.constant = -43;
}
- (IBAction)clickWxinbutton:(id)sender {
    
    
    [self.view endEditing:YES];
    _loginType = wxintype;

    _aliPayButton.selected = NO;
    _wxinButton.selected = YES;
    _wexinNameLable.hidden = NO;
    _alipaynameLable.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{

    _aliPayButton.transform = CGAffineTransformMakeScale(1, 1);
    _wxinButton.transform = CGAffineTransformMakeScale(1.4, 1.4);
    _filedHeight.constant = 0;
    _filledDepart.constant = 0;
    [self transImageviewToCenter:_wxinButton];
    }];
    [_addAccount setTitle:@"立即绑定微信" forState:UIControlStateNormal];

}
- (IBAction)clickAddAccountButton:(id)sender {
    if (_loginType == wxintype) {
        //绑定微信
        [JGJWeiXin_pay sharedManager].delegate = self;

    [self sendAuthRequest];

    }else{
    //绑定支付宝
        [self AddAlipayAccount];

    }
}

- (void)transImageviewToCenter:(UIButton *)button
{
    CGRect rect = _imageview.frame;
    rect.origin.x = button.frame.origin.x +22.5;
    _imageview.frame = rect;
    

}
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"" ;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark - 绑定支付宝帐号
-(void)AddAlipayAccount
{
    if ([NSString isEmpty:_textFiled.text]) {
    [TYShowMessage showError:@"请先输入绑定账户"];
    return;
    }
    
    NSDictionary *paramDic = @{
                               @"pay_type":@"2",
                               @"account_name":_textFiled.text,
                               };
    [JLGHttpRequest_AFN PostWithApi:@"v2/partner/addPartnerWithdrawTele" parameters:paramDic success:^(id responseObject) {
        
        self.AccountListModel = [JGJAccountListModel mj_objectWithKeyValues:responseObject];
        
        JGJSureWithdrawViewController *SureVC = [[UIStoryboard storyboardWithName:@"JGJSureWithdrawViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSureWithdrawVC"];
        SureVC.AccountListModel = self.AccountListModel;
        [self.navigationController pushViewController:SureVC animated:YES];
        
        //        [self.navigationController popViewControllerAnimated:YES];
        [TYShowMessage showSuccess:@"绑定成功"];
    }failure:^(NSError *error) {
    
    }];
}
-(void)weiXinAddAcountSuccessAndpopVCAndModel:(JGJAccountListModel *)accountModel
{
    JGJSureWithdrawViewController *SureVC = [[UIStoryboard storyboardWithName:@"JGJSureWithdrawViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSureWithdrawVC"];
    SureVC.AccountListModel = accountModel;
    [self.navigationController pushViewController:SureVC animated:YES];


}
@end
