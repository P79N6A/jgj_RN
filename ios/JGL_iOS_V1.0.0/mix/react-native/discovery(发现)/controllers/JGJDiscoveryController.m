//
//  JGJDiscoveryController.m
//  mix
//
//  Created by Json on 2019/4/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJDiscoveryController.h"
#import <React/RCTRootView.h>
#import "JGJWebAllSubViewController.h"
#import <React/RCTBridgeModule.h>
#import "JGJKnowRepoVc.h"
#import "JGJCommonTool.h"
#import "JLGLoginViewController.h"


static JGJDiscoveryController *_discoveryVc;
@interface JGJDiscoveryController ()<RCTBridgeModule>

@end

@implementation JGJDiscoveryController

RCT_EXPORT_MODULE();

- (void)viewDidLoad {
    [super viewDidLoad];
    _discoveryVc = self;
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(statusBarH);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}



/**
 token失效,打开登录页面
 */
#pragma mark - token失效,打开登录页面

RCT_EXPORT_METHOD(login){
    JLGLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    [_discoveryVc.navigationController pushViewController:loginVC animated:YES];
    loginVC.backVc = _discoveryVc;
//    __weak typeof(_discoveryVc) weakSelf = _discoveryVc; //2.1.0 -yj登录进来刷新页面
    loginVC.handleWebViewRefreshBlock = ^(UIViewController *backVc, BOOL isRefresh){
        if (isRefresh) {
        }
    };
}

#pragma mark - 打开webview,加载网页

RCT_EXPORT_METHOD(openWebView:(NSString *)path){
    NSString *url = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,path];
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];   webVc.hidesBottomBarWhenPushed = YES;
    [_discoveryVc.navigationController pushViewController:webVc animated:YES];
}


#pragma mark - 打开资料库页面

RCT_EXPORT_METHOD(openRepository){
    JGJKnowRepoVc *knowBaseVc = [[UIStoryboard storyboardWithName:@"JGJKnowRepo" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJKnowRepoVc"];
    knowBaseVc.hidesBottomBarWhenPushed = YES;
    [_discoveryVc.navigationController pushViewController:knowBaseVc animated:YES];
}

#pragma mark - 打开建工计算器页面

RCT_EXPORT_METHOD(openCalculator:(id)data){
    
    NSString *url = data[@"url"];
    JGJWebAllSubViewController *webVc;
    if ([data[@"title"] isEqualToString:@"玩游戏"]) {
        webVc = [[JGJWebAllSubViewController alloc] initWithUrl:[JGJCommonTool getGame1758PlatformURl]];
    }else if([data[@"title"] isEqualToString:@"资讯"]){
        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeNewLifeNews];
    }else if([data[@"title"] isEqualToString:@"交朋友"]){
        if (![_discoveryVc checkIsLogin]) {
            return ;
        }else if(!JLGIsRealName){
            return;
        }
        
        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMakeFriend];
    }
    
    //2.3.0添加外部地址
    
    if ([url rangeOfString:JGJWebDomainURL].location != NSNotFound && [url rangeOfString:@"topdisplay=1"].location != NSNotFound) {
        
        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:url];
        
    }else if ([url rangeOfString:JGJWebDomainURL].location != NSNotFound) {
        
        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
        
    } else{

        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:data[@"url"]];
    }
    
    NSString *title = data[@"title"];
    
    if (![NSString isEmpty:title]) {
        
        webVc.title = title;
    }
    webVc.needCloseButton = YES;
    webVc.hidesBottomBarWhenPushed = YES;
    [_discoveryVc.navigationController pushViewController:webVc animated:YES];
}

-(BOOL)checkIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}






@end
