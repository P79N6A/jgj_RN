//
//  TYPhone.m
//  mix
//
//  Created by jizhi on 15/12/15.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYPhone.h"

@implementation TYPhone

+ (void)callPhoneByNum:(NSString *)phoneNum{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)callPhoneByNum:(NSString *)phoneNum view:(UIView *)contentView{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [contentView addSubview:callWebview];
}
@end
