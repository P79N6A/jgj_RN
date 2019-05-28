//
//  LZChatRefreshHeader.m
//  LZEasemob3
//
//  Created by nacker on 16/7/19.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZChatRefreshHeader.h"

@interface LZChatRefreshHeader()

@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end

@implementation LZChatRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loading.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}
@end
