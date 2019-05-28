//
//  JLGAgreementViewController.m
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGAgreementViewController.h"

#define JLGAgreementUrl  @"web/html/mine/ph-agreement.html"

@interface JLGAgreementViewController()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation JLGAgreementViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    CGRect bouds = [[UIScreen mainScreen]applicationFrame];
    self.webView = [[UIWebView alloc]initWithFrame:bouds];
    [self.view addSubview:self.webView];

    self.webView.scrollView.bounces = NO;
    _webView.scalesPageToFit = NO;
    NSString *url = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"my/agreement"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //加载地址数据
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;

}

@end
