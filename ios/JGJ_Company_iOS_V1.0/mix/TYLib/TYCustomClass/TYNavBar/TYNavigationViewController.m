//
//  TYNavigationViewController.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYNavigationViewController.h"

@interface TYNavigationViewController ()

@end

@implementation TYNavigationViewController

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        TYLog(@"隐藏 tabbar ");
    }else{
        TYLog(@"没有隐藏 tabbar viewControllers.count = %@",@(self.viewControllers.count));
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
