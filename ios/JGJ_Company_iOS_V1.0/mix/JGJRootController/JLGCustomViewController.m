//
//  JLGCustomViewController.m
//  mix
//
//  Created by Tony on 16/1/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCustomViewController.h"
#import "HomeVC.h"
#import "PopBoxView.h"
#import "FDAlertView.h"
#import "JLGAppDelegate.h"
#import "JGJSyncProlistVC.h"
#import "JGJSynBillingManageVC.h"
#import "JGJUnLoginPopView.h"
#import "JGJUnLoginAddNameHUBView.h"
#import "JGJViewController.h"
#import "LeftMenuVC.h"
@interface JLGCustomViewController ()
<
    FDAlertViewDelegate,
    PopBoxViewDelegate,
    JGJUnLoginAddNameHUBViewDelegate,
    UINavigationBarDelegate,
    UINavigationControllerDelegate,
    JGJUnLoginAddNameHUBViewDelegate
>
@property (nonatomic,strong) UIImage *backImageNormal;
@property (nonatomic,strong) UIImage *backImageHighlighted;

@property (nonatomic,strong) UIImage *backImageNormalWhite;
@property (nonatomic,strong) UIImage *backImageHighlightedWhite;
@property (nonatomic, strong)  UIPanGestureRecognizer *panGesture;
@end

@implementation JLGCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.loginBackGoToRootVc = YES;
    self.view.backgroundColor = TYColorRGB(59, 59, 64);
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.view layoutSubviews];
}

#pragma mark - 切换到登录界面
-(BOOL )checkIsLogin{
    if (JLGLoginBool) {
        return YES;
    }
    NSString *popMessage = @"建筑施工 协同管理\n就用吉工宝App";
    JGJUnLoginPopView *popView = [JGJUnLoginPopView popViewImageStr:nil popMessage:popMessage buttonTitle:nil];
    
    __weak typeof(self) weakSelf = self;
    popView.onClickedBlock = ^{
        UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        
        BOOL isGotoRootVc = weakSelf.loginBackGoToRootVc == YES;
        [changeToVc setValue:@(isGotoRootVc) forKey:@"goToRootVc"];
        [weakSelf pushViewController:changeToVc animated:YES];
        
        weakSelf.loginBackGoToRootVc = YES;
    };
    
    return NO;
}

#pragma mark - 判断是否有权限
- (BOOL )checkIsInfo{
    return YES;
}


#pragma mark - 判断是否是真实姓名
- (BOOL )checkIsRealName{
    JGJUnLoginAddNameHUBView *jgjAddNameHUBView = [JGJUnLoginAddNameHUBView hasRealNameByVc:self];
    
    TYWeakSelf(self);
    
    jgjAddNameHUBView.unLoginAddNameHUBViewBlock = ^(id hubView) {
      
        if (weakself.customVcCancelButtonBlock) {
            
            weakself.customVcCancelButtonBlock(self);
        }
    };
    
    if (jgjAddNameHUBView) {
        return NO;
    }else{
        return YES;
    }
}

- (void)gotoTransfVc{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"完善资料" icon:nil message:@"完成资料，即可进行项目操作" delegate:self buttonTitles:@"立即完善", nil];
    alert.tag = 1;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        //跳转界面
        UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"addRegisterInfo"];
        
        [self pushViewController:changeToVc animated:YES];
    }
    
    alertView.delegate = nil;
    alertView = nil;
}

#pragma mark - 返回
- (void)navigationPop:(UIButton *)sender
{
    if ([self.viewControllers.lastObject isKindOfClass:[JGJSyncProlistVC class]]) {
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:[JGJSynBillingManageVC class]]) {
                JGJSynBillingManageVC *synBillingManageVC = (JGJSynBillingManageVC *)vc;
                [self popToViewController:synBillingManageVC animated:YES];
                return;
            }
        }
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark - 拦截所有push进来的控制器，用来设置标题
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isEqualBaseWebVc = [viewController isKindOfClass:NSClassFromString(@"JGJBaseWebViewController")]||[viewController isKindOfClass:NSClassFromString(@"JGJWebMsgsViewController")];//如果是网页
    if (self.childViewControllers.count > 0 && !isEqualBaseWebVc) { // 如果push进来的不是第一个控制器
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getLeftButton]];
    }
    // 隐藏tabbar
    BOOL isHiddenBottomBar =  ![viewController isKindOfClass:NSClassFromString(@"JGJContactedListVc")];
    if (isHiddenBottomBar) {
        if (TYiOSVersion < 12.1) {
            
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    //如果使用的是button
    if ([viewController.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
        UIButton *rightBarButton = (UIButton * )viewController.navigationItem.rightBarButtonItem.customView;
        rightBarButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    }
    
    if ([viewController.navigationItem.rightBarButtonItem isKindOfClass:[UIBarButtonItem class]]) {
        [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont]} forState:UIControlStateNormal];
    }
    
    //2.3.4添加
    if ([viewController isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
        
        self.navigationBarHidden = YES;
        
        [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
        
    }else {
        
        //所有push进入显示头子，注释掉会push进入没有头子。
        self.navigationBarHidden = NO;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    // 意思是，我们任然可以重新在push控制器的viewDidLoad方法中设置导航栏的leftBarButtonItem，如果设置了就会覆盖在push方法中设置的“返回”按钮，因为 [super push....]会加载push的控制器执行viewDidLoad方法。
    [super pushViewController:viewController animated:animated];
    
    if (TYiOSVersion > 12.0) {
        
        if ([viewController.tabBarController isKindOfClass:[UITabBarController class]]) {
            
            viewController.tabBarController.tabBar.hidden = YES;
        }
    }
}

#pragma mark - JGJUnLoginAddNameHUBViewDelegate
//点击聊聊未完善姓名完善之后进入聊聊
- (void)AddNameHubSaveSuccess:(JGJUnLoginAddNameHUBView *)contactsView {
    UITabBarController *tabBar = (UITabBarController *)self.viewControllers.lastObject;
    if ([tabBar isKindOfClass:NSClassFromString(@"JGJViewController")] && [contactsView.currentVcStr isEqualToString:@"JGJContactedListVc"]) {
        tabBar.selectedIndex = 1;
    }
    
    if (self.customVcBlock) {
        
        self.customVcBlock(contactsView);
    }
    
}

- (UIButton *)getLeftButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [self getLeftNoTargetButton];
    [button addTarget:self action:@selector(navigationPop:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)getLeftNoTargetButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:self.backImageNormal forState:UIControlStateNormal];
    [button setImage:self.backImageHighlighted forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 45, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    
    return button;
}

- (UIButton *)getWhiteLeftButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [self getWhiteLeftNoTargetButton];
    [button addTarget:self action:@selector(navigationPop:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)getWhiteLeftNoTargetButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:self.backImageNormalWhite forState:UIControlStateNormal];
    [button setImage:self.backImageHighlightedWhite forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 45, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];

    
    return button;
}

- (UIBarButtonItem *)getLeftBarButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];//设置颜色
    return [[UIBarButtonItem alloc] initWithCustomView:[self getLeftButton]];
}

- (UIBarButtonItem *)getWhiteLeftBarButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜色
    return [[UIBarButtonItem alloc] initWithCustomView:[self getWhiteLeftButton]];
}

- (UIImage *)backImageNormal
{
    if (!_backImageNormal) {
        _backImageNormal = [UIImage imageNamed:@"barButtonItem_back_white"];
    }
    return _backImageNormal;
}

- (UIImage *)backImageHighlighted
{
    if (!_backImageHighlighted) {
        _backImageHighlighted = [UIImage imageNamed:@"barButtonItem_back_white_L"];
    }
    return _backImageHighlighted;
}

- (UIImage *)backImageNormalWhite
{
    if (!_backImageNormalWhite) {
        _backImageNormalWhite = [UIImage imageNamed:@"barButtonItem_back_white"];
    }
    return _backImageNormalWhite;
}

- (UIImage *)backImageHighlightedWhite
{
    if (!_backImageHighlightedWhite) {
        _backImageHighlightedWhite = [UIImage imageNamed:@"barButtonItem_back_white_L"];
    }
    return _backImageHighlightedWhite;
}

//设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 设置导航栏风格 nav_image_icon(标准背景) clear_back_icon(透明背景)
+ (void)setNavBarStyle:(UIStatusBarStyle)statusBarStyle target:(UIViewController *)target statusBarColor:(UIColor *)statusBarColor backImageName:(NSString *)backImageName {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜色
    [target.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:backImageName] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:JGJNavBarFont];
    [target.navigationController.navigationBar setTitleTextAttributes:dictAtt];
    
    //导航条下面的黑线
    target.navigationController.navigationBar.clipsToBounds = NO;
    
    [JLGCustomViewController setStatusBarBackgroundColor:statusBarColor];
}

@end
