//
//  TYLoadingHub.m
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYLoadingHub.h"
#import "TYLoadingView.h"

static const CGFloat afterDelayTime = 15.0;
@implementation TYLoadingHub

+ (id)showLoadingWithMessage:(id )message{
    
    return [TYLoadingHub showLoadingNoDataDefultWithMessage:message];
    
//    return [self showLoadingViewTo:nil message:message]; 3.0.0替换为注水动画
}

+ (id)showLoadingWithMessage:(id )message lineNum:(NSInteger )lineNum{
    return [self showLoadingViewTo:nil message:message lineNum:lineNum];
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message lineNum:(NSInteger )lineNum{
    CGFloat loadingH = 100;
    CGFloat loadingW = loadingH*2;
    CGFloat loadingX = ([[UIScreen mainScreen] bounds].size.width -  loadingW)/2;
    CGFloat loadingY = ([[UIScreen mainScreen] bounds].size.height - loadingH)/2;
    CGRect frame = CGRectMake(loadingX, loadingY, loadingW, loadingH);
    return [self showLoadingViewTo:view message:message frame:frame lineNum:lineNum];
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message{
    
    return [self showLoadingViewTo:view message:message lineNum:0];
    
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message frame:(CGRect )frame{
    return [self showLoadingViewTo:view message:message frame:frame lineNum:0];
}

+ (id)showLoadingViewTo:(UIView *)view message:(id )message frame:(CGRect )frame lineNum:(NSInteger )lineNum{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    TYLoadingView *loadView = [[TYLoadingView alloc] initWithTitle:message WithFrame:frame];
    loadView.backgroundColor = [UIColor clearColor];
    if (lineNum) {
        loadView.lineNum = lineNum;
    }
    
    loadView.defultBool = NO;

    UIView *backView = [[UIView alloc] initWithFrame:TYGetUIScreenRect];
    backView.backgroundColor = [UIColor clearColor];

    [backView addSubview:loadView];
    backView.tag = MAX_CANON;
    [view addSubview:backView];
    
    [TYLoadingHub performSelector:@selector(hideLoadingView:) withObject:view afterDelay:afterDelayTime];
    
    return loadView;
}

+ (void)hideLoadingView{
    
//2.3.4添加异步到主线程
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        // 在此处进行UI刷新
        TYLog(@"mainQueue -- %@",[NSThread currentThread]);
        
        [self hideLoadingView:nil];
    });
    
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
        
        if (subview.tag == MAX_CANON) {
            
            return (TYLoadingView *)subview;
        }
        
    }
    return nil;
}


#pragma mark - 无数据是的加载动画

+ (id)showLoadingNoDataDefultWithMessage:(id)message
{
    return [self showLoadingNodataDefultViewViewTo:nil message:message];
    
}
+ (id)showLoadingNodateDefultViewViewTo:(UIView *)view message:(id )message lineNum:(NSInteger )lineNum
{
    
    CGFloat loadingH = 104;
    CGFloat loadingW = 104;
    CGFloat loadingX = ([[UIScreen mainScreen] bounds].size.width -  loadingW)/2;
    CGFloat loadingY = ([[UIScreen mainScreen] bounds].size.height - loadingH)/2;
    CGRect frame = CGRectMake(loadingX, loadingY, loadingW, loadingH);
    return [self showLoadingNodataDefultViewTo:view message:message frame:frame lineNum:lineNum];
    
}
+ (id)showLoadingNodataDefultViewViewTo:(UIView *)view message:(id )message{
    return [self showLoadingNodateDefultViewViewTo:view message:message lineNum:0];
}
+ (id)showLoadingNodataDefultViewTo:(UIView *)view message:(id )message frame:(CGRect )frame lineNum:(NSInteger )lineNum{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    TYLoadingView *loadView = [[TYLoadingView alloc] initNodataDefultWithTitle:message WithFrame:frame];

    loadView.backgroundColor = [UIColor clearColor];
    if (lineNum) {
        loadView.lineNum = lineNum;
    }
    
    
    UIView *backView = [[UIView alloc] initWithFrame:TYGetUIScreenRect];
    
    backView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:loadView];
    
    backView.tag = MAX_CANON;
    
    [view addSubview:backView];
    
    [TYLoadingHub performSelector:@selector(hideLoadingView:) withObject:view afterDelay:afterDelayTime];
    
    return loadView;
}


@end
