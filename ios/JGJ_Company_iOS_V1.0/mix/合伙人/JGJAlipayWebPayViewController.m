//
//  JGJAlipayWebPayViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/8/2.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAlipayWebPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface JGJAlipayWebPayViewController ()
<
UIWebViewDelegate
>

@end

@implementation JGJAlipayWebPayViewController

/*
https://openapi.alipay.com/gateway.do?timestamp=2013-01-01 08:08:08&method=alipay.trade.wap.pay&app_id=1990&sign_type=RSA2&sign=ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE&version=1.0&biz_content=
{
    "body":"对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。",
    "subject":"大乐透",
    "out_trade_no":"70501111111S001111119",
    "timeout_express":"90m",
    "total_amount":9.00,
    "product_code":"QUICK_WAP_WAY"
}*/
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect bouds = [UIScreen mainScreen].bounds;
    _webview = [[UIWebView alloc]initWithFrame:bouds];
    _webview.delegate  = self;
    _webview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:_webview];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://openapi.alipay.com/gateway.do?%@",_urlPar]];//创建URL
//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://alipay.trade.wap.pay"]];//创建URL

    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webview loadRequest:request];//加载
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    typeof(self)__weak weakself = self;
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:@"alisdkdemo" callback:^(NSDictionary *result) {
        // 处理支付结果
        NSLog(@"%@", result);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([result[@"isProcessUrlPay"] boolValue]) {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = result[@"returnUrl"];
            [weakself loadWithUrlStr:urlStr];
        }
    }];
    
    if (isIntercepted) {
        return NO;
    }
    return YES;
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webview loadRequest:webRequest];
        });
    }
}

@end
