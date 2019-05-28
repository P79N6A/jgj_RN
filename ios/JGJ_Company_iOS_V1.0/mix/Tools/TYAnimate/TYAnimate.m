//
//  TYAnimate.m
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYAnimate.h"

static const CGFloat kDurationTimeFloat = 0.5;

@implementation TYAnimate

+ (void)showWithView:(UIView *)showView byStartframe:(CGRect )startframe endFrame:(CGRect )endFrame byBlock:(TYAnimateBlock )animateBlock{
    __weak typeof(showView) weakShowView = showView;
    
    [UIView animateWithDuration:kDurationTimeFloat animations:^{
        weakShowView.frame = startframe;
    } completion:^(BOOL finished){
        if (finished)
        {
            [UIView animateWithDuration:kDurationTimeFloat/2.0 animations:^
             {
                 weakShowView.frame = endFrame;
             }completion:^(BOOL finished) {
                 if (animateBlock) {
                     animateBlock();
                 }
             }];
        }
    }];
}

+ (void)showWithView:(UIView *)showView byStartframe:(CGRect )startframe endFrame:(CGRect )endFrame{
    [self showWithView:showView byStartframe:startframe endFrame:endFrame byBlock:nil];
}

+ (void)hiddenView:(UIView *)hiddenView byHiddenFrame:(CGRect )hiddenFrame byBlock:(TYAnimateBlock )animateBlock{
    
    __weak typeof(hiddenView) weakHiddenView = hiddenView;
    [UIView animateWithDuration:kDurationTimeFloat animations:^{
        weakHiddenView.frame = hiddenFrame;
    }completion:^(BOOL finished) {
        if (animateBlock) {
            animateBlock();
        }
    }];
}


+ (void)hiddenView:(UIView *)hiddenView byHiddenFrame:(CGRect )hiddenFrame{
    [self hiddenView:hiddenView byHiddenFrame:hiddenFrame byBlock:nil];
}
@end
