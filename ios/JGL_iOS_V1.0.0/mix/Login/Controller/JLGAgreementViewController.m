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
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation JLGAgreementViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.webView.scalesPageToFit = NO;
    self.webView.scrollView.bounces = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,JLGAgreementUrl]]];

    //加载地址数据
    [self.webView loadRequest:request];
}


@end
