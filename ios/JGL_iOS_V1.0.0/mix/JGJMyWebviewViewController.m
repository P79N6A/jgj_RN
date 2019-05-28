//
//  JGJMyWebviewViewController.m
//  mix
//
//  Created by Tony on 2017/10/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMyWebviewViewController.h"

@interface JGJMyWebviewViewController ()
<
UIWebViewDelegate
>
@property (nonatomic ,strong)UIWebView *webView;
@end

@implementation JGJMyWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    
    return _webView;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
 

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [TYShowMessage showError:@"地址异常"];
}


@end
