 //
//  JLGCustomViewController.m
//  mix
//
//  Created by Tony on 16/1/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCustomViewController.h"

#import "PopBoxView.h"
#import "FDAlertView.h"
#import "JLGAppDelegate.h"
//#import "REFrostedViewController.h"
#import "JGJSyncProlistVC.h"
#import "JGJSynBillingManageVC.h"
#import "JGJFindJobAndProViewController.h"
#import "JGJUnLoginPopView.h"
#import "JGJUnLoginAddNameHUBView.h"
@interface JLGCustomViewController ()
<
    FDAlertViewDelegate,
    PopBoxViewDelegate,
    UINavigationBarDelegate,
    UINavigationControllerDelegate,
    JGJUnLoginAddNameHUBViewDelegate
>
@property (nonatomic,strong) UIImage *backImageNormal;
@property (nonatomic,strong) UIImage *backImageHighlighted;

@property (nonatomic,strong) UIImage *backImageNormalWhite;
@property (nonatomic,strong) UIImage *backImageHighlightedWhite;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@end
@implementation JLGCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.loginBackGoToRootVc = YES;
}
//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    [self.view layoutSubviews];
//}

#pragma mark - 切换到登录界面
-(BOOL )checkIsLogin{
    if (JLGLoginBool) {
        return YES;
    }
    NSString *message = @"招工找活 手机记工\n就用吉工家App";;
    JGJUnLoginPopView *popView = [JGJUnLoginPopView popViewImageStr:nil popMessage:message buttonTitle:nil];
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
    //(JLGisMateBool && !JLGMateIsInfoBool)     工人补充资料
    //(JLGisLeaderBool && !JLGLeaderIsInfoBool) 班组长/工头补充资料
    if ((JLGisMateBool && !JLGMateIsInfoBool) || (JLGisLeaderBool && !JLGLeaderIsInfoBool)) {
        
        [self gotoTransfVc];
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
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 隐藏tabbar
//    BOOL isHiddenBottomBar =  ![viewController isKindOfClass:NSClassFromString(@"JGJContactedListVc")] && ![viewController isKindOfClass:NSClassFromString(@"JGJFindJobAndProViewController")];
//    if (isHiddenBottomBar) {
//        if (TYiOSVersion < 12.1) {
//
//            viewController.hidesBottomBarWhenPushed = YES;
//        }
//        
//    }
    //如果使用的是button
    if ([viewController.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
        UIButton *rightBarButton = (UIButton * )viewController.navigationItem.rightBarButtonItem.customView;
        rightBarButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    }
    
    if ([viewController.navigationItem.rightBarButtonItem isKindOfClass:[UIBarButtonItem class]]) {
        [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont]} forState:UIControlStateNormal];
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

- (UIButton *)getLeftButton
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [self getLeftNoTargetButton];
    [button addTarget:self action:@selector(navigationPop:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - JGJUnLoginAddNameHUBViewDelegate
//点击聊聊未完善姓名完善之后进入聊聊
- (void)AddNameHubSaveSuccess:(JGJUnLoginAddNameHUBView *)contactsView {
    UITabBarController *tabBar = (UITabBarController *)self.viewControllers.lastObject;
    BOOL isSelected = ([tabBar isKindOfClass:NSClassFromString(@"JGJLeaderViewController")] || [tabBar isKindOfClass:NSClassFromString(@"JGJWorkerViewController")])&& [contactsView.currentVcStr isEqualToString:@"JGJContactedListVc"];
    if (isSelected) {
        tabBar.selectedIndex = 1;
    }
    
    if (self.customVcBlock) {
        
        self.customVcBlock(contactsView);
        
    }
    
    TYLog(@"viewControllers=== %@", self.navigationController.viewControllers);
    
}

- (UIButton *)getLeftNoTargetButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    
    [button setImage:self.backImageNormal forState:UIControlStateNormal];
    
    [button setImage:self.backImageHighlighted forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, JGJLeftButtonHeight);
    
    button.adjustsImageWhenHighlighted = NO;
    
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [button setTitleColor:JGJMainColor forState:UIControlStateNormal];
    
    [button setTitleColor:JGJBackHightColor forState:UIControlStateHighlighted];
    
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
    
    button.frame = CGRectMake(0, 0, 60, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    button.adjustsImageWhenHighlighted = NO;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:JGJBackHightColor forState:UIControlStateHighlighted];
    
    [button setTitle:@"返回" forState:UIControlStateHighlighted];

    
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
        _backImageNormal = [UIImage imageNamed:@"barButtonItem_back"];
    }
    return _backImageNormal;
}

- (UIImage *)backImageHighlighted
{
    if (!_backImageHighlighted) {
        _backImageHighlighted = [UIImage imageNamed:@"barButtonItem_back_L"];
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

@end
