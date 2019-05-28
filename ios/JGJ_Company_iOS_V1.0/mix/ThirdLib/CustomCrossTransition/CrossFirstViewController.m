//
//  CrossFirstViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CrossFirstViewController.h"
#import "CrossSecondViewController.h"
#import "CrossTransitionAnimator.h"

@interface CrossFirstViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CrossFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)present:(id)sender
{
    CrossSecondViewController *secondCtl = [CrossSecondViewController new];
    secondCtl.modalPresentationStyle = UIModalPresentationFullScreen;
    secondCtl.transitioningDelegate = self;
    [self presentViewController:secondCtl animated:YES completion:NULL];
}

#pragma mark - <UIViewControllerTransitioningDelegate>
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [CrossTransitionAnimator new];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CrossTransitionAnimator new];
}


@end
