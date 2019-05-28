//
//  TYBaseTool.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYBaseTool.h"
#import "JLGAppDelegate.h"
#import "UIKit/UIKit.h"

//唯一设备号
#import "SSKeychain.h"

@implementation TYBaseTool

+ (void)setGlobalStatus{
    [self setStatusBar];
    [self setupGlobalNavTheme];
    [self setupGlobalTextField];
}

+(void)setStatusBar{
    //设置状态栏字体颜色
    //    1、配置Info.plist:
    //    添加key:
    //    View controller-based status bar appearance  -->为NO
    //    2、设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];//取消隐藏
    
    //    状态栏的字体为黑色： UIStatusBarStyleDefault
    //    状态栏的字体为白色： UIStatusBarStyleLightContent
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//设置颜色
}

#pragma mark - 设置导航条样式
+(void)setupGlobalNavTheme{
    //设置导航条为全局使用
    UINavigationBar *navBar = [UINavigationBar appearance];
    [self setupNavByNarBar:navBar BybarTintColor:AppFontfafafaColor tintColor:JGJMainRedColor titleColor:AppFont333333Color];
    //设置导航栏的透明度
    if(iOS8Later) {
        navBar.translucent = NO;
    }
    
#if 0
    //设置返回键
    //将返回按钮的文字position设置不在屏幕上显示
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];//不显示文字

    //设置背景图片
    UIImage *image = [[UIImage imageNamed:@"barButtonItem_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
#endif
}

+(void)setupNavByNarBar:(UINavigationBar *)navBar BybarTintColor:(UIColor *)barTintColor tintColor:(UIColor *)tintColor titleColor:(UIColor *)titleColor{
    //设置导航条的颜色
    navBar.barTintColor = barTintColor;
    //设置返回键的颜色
    navBar.tintColor = tintColor;
    
    //设置标题文字
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = titleColor;
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:dictAtt];
}

+ (UIButton *)getLeftButtonByTitle:(NSString *)title titleNormalColor:(UIColor *)titleNormalColor titleHighlightColor:(UIColor *)titleHighlightColor normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
    
    return button;
}

//设置全局的TextFiled光标
+ (void)setupGlobalTextField{
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
}

#pragma mark - 设置启动图片的动效
+ (void)setLaunchImage{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    UIView *launchView = viewController.view;
    JLGAppDelegate *delegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
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

#pragma mark - 获取唯一设备号
+(NSString *) getKeychainIdentifier{
    NSString *myUniqueIdentifier = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]account:@"uuid"];
    
    if ( myUniqueIdentifier == nil || [myUniqueIdentifier isEqualToString:@""]){
        [SSKeychain setPassword:[self getuuid]
                     forService:[[NSBundle mainBundle] bundleIdentifier]account:@"uuid"];
        myUniqueIdentifier = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]account:@"uuid"];
    }
    
    TYLog(@"唯一设备号:%@", myUniqueIdentifier);
    return myUniqueIdentifier;
}

//get uuid c style function
+ (NSString *)getuuid{
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref= CFUUIDCreateString(nil, uuid_ref);
    NSString * uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuid_string_ref));
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    return uuid;
}


+ (CGFloat )transiTionHeight:(CGFloat )height{
    CGFloat iPhone6W = 750;
    return height/iPhone6W*GetUIScreenWidth;
}
@end
