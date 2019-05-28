//
//  TYBaseTool.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYBaseTool.h"
#import "JGLAppDelegate.h"
#import "UIColor+JLGColor.h"
#import "UIKit/UIKit.h"

@implementation TYBaseTool

+(void)setStatusBar{
    //设置状态栏字体颜色
    //    1、配置Info.plist:
    //    添加key:
    //    View controller-based status bar appearance  -->为NO
    //    2、设置状态栏颜色
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];//取消隐藏
    
    //    状态栏的字体为黑色： UIStatusBarStyleDefault
    //    状态栏的字体为白色： UIStatusBarStyleLightContent
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];//设置颜色
}

#pragma mark - 设置导航条样式
+(void)setupNavGlobalTheme{
    //设置导航条为全局使用
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //设置导航条的颜色
    navBar.barTintColor = [UIColor JLGBlueColor];
    
    //设置返回键的颜色
    navBar.tintColor = [UIColor whiteColor];
    
    //设置标题文字
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:dictAtt];
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 设置启动图片的动效
+ (void)setLaunchImage{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    JGLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    [mainWindow addSubview:launchView];
    [mainWindow bringSubviewToFront:launchView];
    
    [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.3f, 1.3f, 1.0f);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
    }];
}

@end
