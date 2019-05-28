//
//  TYLoadingHub.m
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYLoadingHub.h"
#import "TYLoadingView.h"

static const CGFloat afterDelayTime = 5.0;
@implementation TYLoadingHub

+ (id)showLoadingWithMessage:(id )message{
    return [self showLoadingViewTo:nil message:message];
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message{
    CGFloat loadingH = 100;
    CGFloat loadingW = loadingH*2;
    CGFloat loadingX = ([[UIScreen mainScreen] bounds].size.width -  loadingW)/2;
    CGFloat loadingY = ([[UIScreen mainScreen] bounds].size.height - loadingH)/2;
    CGRect frame = CGRectMake(loadingX, loadingY, loadingW, loadingH);
    return [self showLoadingViewTo:view message:message frame:frame];
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message frame:(CGRect )frame{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    TYLoadingView *loadView = [[TYLoadingView alloc] initWithTitle:message WithFrame:frame];
    loadView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:GetUIScreenRect];
    backView.backgroundColor = [UIColor clearColor];

    [backView addSubview:loadView];
    backView.tag = MAX_CANON;
    [view addSubview:backView];
    
    [TYLoadingHub performSelector:@selector(hideLoadingView:) withObject:view afterDelay:afterDelayTime];
    
    return loadView;
}

+ (void)hideLoadingView{
    [self hideLoadingView:nil];
}

+ (void)hideLoadingView:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    UIView *backView = [view viewWithTag:MAX_CANON];
    [backView removeFromSuperview];
    TYLoadingView *loadView = [self subForView:view];
    [loadView removeFromSuperview];
}


+ (id)subForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[TYLoadingView class]]) {
            return (TYLoadingView *)subview;
        }
    }
    return nil;
}
@end
