//
//  JGJMineViewController.m
//  mix
//
//  Created by Json on 2019/4/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMineViewController.h"
#import "JGJWebAllSubViewController.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTRootView.h>
#import "JGJWebAllSubViewController.h"
#import "YZGSelectedRoleViewController.h"
#import "JGJMineSettingVc.h"
#import "NSString+JSON.h"
#import <React/RCTEventEmitter.h>
#import "JLGLoginViewController.h"
#import "JGJNativeEventEmitter.h"

static JGJMineViewController *_mineVc;

@interface JGJMineViewController ()<RCTBridgeModule>

@end

@implementation JGJMineViewController

RCT_EXPORT_MODULE();

- (void)viewDidLoad {
    [super viewDidLoad];
    _mineVc = self;
    
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(statusBarH);
    }];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self refreshUserInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 更改状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (dispatch_queue_t)methodQueue
{
    return  dispatch_get_main_queue();
}

#pragma mark - RN通信方法

#pragma mark - token失效,打开登录页面

RCT_EXPORT_METHOD(login){
    JLGLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    [_mineVc.navigationController pushViewController:loginVC animated:YES];
    loginVC.backVc = _mineVc;
//    __weak typeof(_mineVc) weakSelf = _mineVc; //2.1.0 -yj登录进来刷新页面
    loginVC.handleWebViewRefreshBlock = ^(UIViewController *backVc, BOOL isRefresh){
        if (isRefresh) {
        }
    };
}

#pragma mark - 切换身份

RCT_EXPORT_METHOD(chooseRole){
    TYLog(@"点击了切换身份");
    YZGSelectedRoleViewController *selRoleVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    
    selRoleVc.isHiddenCancelButton = YES;
    selRoleVc.view.tag = 1;
    
    [_mineVc presentViewController:selRoleVc animated:YES completion:nil];
}

#pragma mark - 打开设置

RCT_EXPORT_METHOD(openSet){
    TYLog(@"点击了设置");
    JGJMineSettingVc *settingVc = [[JGJMineSettingVc alloc] init];
    settingVc.hidesBottomBarWhenPushed = YES;
    [_mineVc.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - 打开webview,加载网页

RCT_EXPORT_METHOD(openWebView:(NSString *)path){
    NSString *url = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,path];
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
    webVc.hidesBottomBarWhenPushed = YES;
    [_mineVc.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - 私有方法

- (void)refreshUserInfo
{
    NSString *userToken = [TYUserDefaults objectForKey:JLGToken];
    NSString *os = @"I";
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    NSDictionary *loginInfoDic = JLGisLoginBool ? @{@"os" : os,
                                                    @"token" : userToken?:@"",
                                                    @"infover" : @(infoVer),
                                                    } : @{};
    NSString *loginInfojson = [NSString getJsonByData:loginInfoDic];
    [JGJNativeEventEmitter emitEventWithName:@"refreshRN" body:loginInfojson];
}

@end
