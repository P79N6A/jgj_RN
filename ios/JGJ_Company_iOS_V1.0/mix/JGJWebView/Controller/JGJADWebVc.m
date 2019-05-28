//
//  JGJADWebVc.m
//  JGJCompany
//
//  Created by Tony on 2016/10/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJADWebVc.h"

@interface JGJADWebVc ()

@property (nonatomic,copy) NSString *HTMLString;

@end

@implementation JGJADWebVc

-(instancetype)initWithHTMLString:(NSString *)HTMLString{
    self = [super init];
    if (self) {
        self.HTMLString = HTMLString;
        [self.webView loadHTMLString:self.HTMLString baseURL:nil];
    }
    return self;
}

- (void)loadWebView{
    if (self.HTMLString) {
        [self.webView loadHTMLString:self.HTMLString baseURL:nil];
    }else{
        [super loadWebView];
    }
}
@end
