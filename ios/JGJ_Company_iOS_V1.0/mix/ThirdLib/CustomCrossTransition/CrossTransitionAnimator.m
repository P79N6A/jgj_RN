//
//  CrossTransitionAnimator.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CrossTransitionAnimator.h"

@implementation CrossTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)])
    {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else
    {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    fromView.alpha = 1.0;
    toView.alpha = 0.0;
    
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.alpha = 0.0f;
        toView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

@end
