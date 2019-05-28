//
//  JGJWebLoginViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWebLoginViewController.h"

@interface JGJWebLoginViewController ()

@end

@implementation JGJWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView{
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    _loginButton.layer.borderWidth = 0.7;
    _loginButton.layer.cornerRadius = JGJCornerRadius;
    [self initBackBarButton];

}
- (IBAction)sureLogin:(id)sender {
    [self logWeb:_paramDic];
}
- (IBAction)cancelLogin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)initBackBarButton
{
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backVC)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)backVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)logWeb:(NSDictionary *)paramters
{
    if (!_paramDic) {
        return;
    }
    [JLGHttpRequest_AFN PostWithApi:@"v2/Signup/qrcodeLogin" parameters:@{@"qrcode_token":_qrcode_token} success:^(id responseObject) {
//        [TYShowMessage showSuccess:@"网页已登录"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
    } failure:^(NSError *error) {
        
    }];
}

@end
