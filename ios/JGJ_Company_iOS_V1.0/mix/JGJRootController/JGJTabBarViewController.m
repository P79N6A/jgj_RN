//
//  JGJTabBarViewController.m
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTabBarViewController.h"
#import "HomeVC.h"
#import "LeftMenuVC.h"
#import "NSDate+Extend.h"
#import "TYFMDB.h"
#import "JGJWebAllSubViewController.h"
#import "JGJContactedListVc.h"
#import "JLGCustomViewController.h"

#import "JGJCalendarViewController.h"

#import "JLGAppDelegate.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "JGJMangerTool.h"

@interface JGJTabBarViewController ()
@property (nonatomic, strong) JGJWebAllSubViewController *tempWebVc;

//刷新标记
@property (nonatomic,strong) NSMutableArray *freshFlags;

@property (nonatomic, assign) NSUInteger lastSelectedIndex;

@property (nonatomic, strong) JGJMangerTool *tool;
@end

@implementation JGJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGJMangerTool *tool = [JGJMangerTool mangerTool];
    self.tool = tool;
    
    [self commonSet];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIViewController *viewController;
    
    //如果保存了，就加载保存的位置
    NSInteger selectedIndex = [TYUserDefaults integerForKey:JGJTabBarSelectedIndex];
    if (selectedIndex) {
        self.selectedIndex = selectedIndex;
        [TYUserDefaults removeObjectForKey:JGJTabBarSelectedIndex];
    }

    viewController = self.childViewControllers[self.selectedIndex];
    
    if (self.selectedIndex == 0) {
        
        [self tabBarController:self selectViewController:viewController];
    }
//    (3.4.0)添加聊天进入他的资料多一个头子问题
    viewController.navigationController.navigationBarHidden = YES;
    
    _is_HiddenNav = NO;
    
#pragma mark - 加深背景颜色
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bgView.backgroundColor = [UIColor redColor];
//    [self.tabBar insertSubview:bgView atIndex:0];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!self.selectedIndex) {
        
        self.selectedIndex = 0;
    }
    
    [self calendarPopWebViewNavHidden];
    
    UIViewController *viewController = self.childViewControllers[self.selectedIndex];
    
//处理聊天点击图片的时候消失会多一个头子
    if (_is_HiddenNav) {
        
        _is_HiddenNav = NO;
        
        self.navigationController.navigationBarHidden = YES;
        
    }else {
        
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)commonSet{
    self.delegate = self;
    
    //主页
    HomeVC *homeVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeVC"];
    //聊天
    JGJContactedListVc *contactedListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedListVc"];
    
    JLGCustomViewController *contactedNav = [[JLGCustomViewController alloc] initWithRootViewController:contactedListVc];
    
//    //1.1.1动态
//    JGJWebAllSubViewController *dynamicWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeDynamic URL:@"dynamic"];
    
    //招劳务
    NSString *recruUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"mjob"];
    JGJWebAllSubViewController *recruWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:recruUrl];
    
    //发现
    JGJWebAllSubViewController *findWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeNewLife];

    //我的
    NSString *myUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"my"];
    JGJWebAllSubViewController *myWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:myUrl];
    
    self.vcsArr = @[homeVC,contactedNav, recruWebVc, findWebVc, myWebVc].mutableCopy;
    
    self.freshFlags = @[@(1), @(1), @(1),@(1),@(1)].mutableCopy;
    
    [self subVcSetDic];
    
    
    if (!self.viewControllersDic || self.vcsArr.count == 0) {
        return;
    }
    
    [self updateChildVc];
    
//    //预加载H5 js、css
//    NSURL *oriUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@404", JGJWebDiscoverURL]];
//    JGJWebAllSubViewController *tempWebVc = [[JGJWebAllSubViewController alloc] initWithUrl:oriUrl];
//    self.tempWebVc = tempWebVc;
//    [self.tempWebVc loadWebView];
}

- (void)updateChildVc{
    __weak typeof(self) weakSelf = self;
    
    NSArray *titlesArr = (NSArray *)self.viewControllersDic[@"vcTitles"];
    NSArray *imgsAsrr = (NSArray *)self.viewControllersDic[@"vcImages"];
    NSArray *selectedImgsAsrr = (NSArray *)self.viewControllersDic[@"vcSelectedImages"];
    
    [self.vcsArr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf addChildViewController:obj title:titlesArr[idx] image:imgsAsrr[idx] selectedImage:selectedImgsAsrr[idx]];
    }];
    
    //设置显示的颜色
    [self setOriginalTabBarItemImage];
}


/**
 *  设置图片为original加载模式
 */
- (void)setOriginalTabBarItemImage
{
    //如果是7.0以下就不用设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return ;
    }
    
    //设置tabBar的图片和文字的状态
    for (UIViewController *childVc in self.childViewControllers) {
        childVc.tabBarItem.selectedImage = [childVc.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        //设置文字的样式
        //选中状态
        NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
        selectTextAttrs[NSForegroundColorAttributeName] = AppFontEB4E4EColor;
        
        //普通状态
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] =  AppFont333333Color;
        
        [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    }
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    [self tabBarController:self selectViewController:self.viewControllers[selectedIndex]];
}

#pragma mark - H5的招工信息，进入聊天，强制返回到某一个页面，其实走了pop的方法。这里清楚标记的目的是，在这种情况下动态进入详情页 isUnlogin等于YES没有走隐藏底部，所以必须清零。

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self tabBarController:tabBarController selectViewController:viewController];
    
    if ([viewController isKindOfClass:[JGJWebAllSubViewController class]]) {
        JGJWebAllSubViewController *webVc = (JGJWebAllSubViewController *)viewController;
        webVc.isUnlogin = NO;
    }
        
    //定位弹框
    if (tabBarController.selectedIndex == 2) { // 点击招劳务
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) { // 未开启定位
            JLGAppDelegate *appDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
            if (!appDelegate.isAuthedLocal) { // 没有弹窗提示过
                NSString *message;
                BOOL locationEnable = [CLLocationManager locationServicesEnabled];
                if (locationEnable) {
                    message = @"开启定位服务你将获取到附近的招工信息，请到设置 > 隐私 > 定位服务中开启【吉工宝】定位服务。帮助你快速找到满意的劳务。";
                } else {
                    message = @"前往 设置 > 隐私 > 定位服务 打开位置信息，你将获取到附近的劳务信息，帮助你快速找到满意的劳务。";
                }
                [appDelegate unOpenLocalTilte:@"定位服务已关闭" message:message];
                appDelegate.isAuthedLocal = YES;
            }
        }
    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController selectViewController:(UIViewController *)viewController{
//    //第二个vc是找工作，找项目
    BOOL isSecondIndex = tabBarController.selectedIndex == 1;

    if (!isSecondIndex) {
        viewController.navigationController.navigationBarHidden = YES;

    }else if(isSecondIndex){
        viewController.navigationController.navigationBarHidden = YES;

    }
    
    if (self.selectedIndexVc == 1) {
        self.selectedViewController = self.childViewControllers[self.selectedIndexVc];
        self.tabBar.hidden = NO;
        self.selectedIndexVc = 0;
        
    }
    
    NSInteger freshCount = [self.freshFlags[tabBarController.selectedIndex] integerValue];
    
    if ([viewController isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
        
        if (freshCount) {
            
             [self loadWebViewRequestWithVc:viewController tabbarIndex:tabBarController.selectedIndex];
            
        }
        
        if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3 || tabBarController.selectedIndex == 4) {
            
            freshCount += 1;
            
            [self.freshFlags replaceObjectAtIndex:tabBarController.selectedIndex withObject:@(freshCount)];
        }
        
        if (self.lastSelectedIndex != tabBarController.selectedIndex) {
            
            //上次点击的清零，下次重新计数到1才刷新
             [self.freshFlags replaceObjectAtIndex:self.lastSelectedIndex withObject:@(0)];
        }
        
        self.lastSelectedIndex = tabBarController.selectedIndex;
        
    }else {
        
        [self clearFlag];
    }
    
    if (tabBarController.selectedIndex == 0 || tabBarController.selectedIndex == 1) {
        
        [JLGCustomViewController setStatusBarBackgroundColor:[UIColor clearColor]];
        
    }else {
        
        [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
    }
    
    //双击回聊聊顶部
    
     [self doubleTabChatIndex:tabBarController.selectedIndex];

}

- (void)doubleTabChatIndex:(NSInteger)selectedIndex {
    
    //双击聊聊回顶部
    
    if (selectedIndex == 1) {
        
        NSInteger chatClickCount = [self.freshFlags[1] integerValue];
        
        chatClickCount += 1;
        
        [self.freshFlags replaceObjectAtIndex:selectedIndex withObject:@(chatClickCount)];
        
        if (chatClickCount == 3) {
            
            if (self.clickChatBlock) {
                
                self.clickChatBlock();
            }
            
            [self.freshFlags replaceObjectAtIndex:selectedIndex withObject:@(1)];
        }
        
    }else {
        
        [self.freshFlags replaceObjectAtIndex:1 withObject:@(1)];
    }
}

- (void)handleFindHelperWithtabBarController:(UITabBarController *)tabBarController selectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2) { //找帮手
        if ([viewController isKindOfClass:[JGJWebAllSubViewController class]]) { //未登录重新加载页面

        }
    }else {
    
    }
}

- (void)loadWebViewRequestWithVc:(UIViewController *)vc  tabbarIndex:(NSInteger)index {
    
    if (![self.tool startTimer]) {
        
        [self.tool startTimer];
    }
    
    __weak JGJMangerTool *weakTool = self.tool;
    
    self.tool.toolTimerBlock = ^{
        
        JGJWebAllSubViewController *webSubView = (JGJWebAllSubViewController *)vc;
        
        [webSubView loadWebView];
        
        [weakTool inValidTimer];
        
    };
    
}

#pragma mark 子类继承的时候使用
- (void)subVcSetDic{
}

#pragma mark 添加子控制器的方法
- (void)addChildViewController:(UIViewController *)childVc
                         title:(NSString*)title
                         image:(NSString*)image
                 selectedImage:(NSString*)selectedImage {
    
    // 始终绘制图片原始状态，不使用Tint Color,系统默认使用了Tint Color（灰色）
    [childVc.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childVc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    childVc.tabBarItem.title = title;
    
    [self addChildViewController:childVc];
}

#pragma mark - 判断是否要跳转
- (BOOL )checkIsRight{
    if (![self checkIsLogin]) {
        return NO;
    }
    
    if (![self checkIsRealName]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)checkIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

- (void)setWorkType:(SelectedWorkType)workType{
    _workType = workType;

    
//    LeftMenuVC *leftMenuVC = (LeftMenuVC *)[self.vcsArr lastObject];
//    leftMenuVC.workType = _workType;
}

#pragma mark - 清楚标记
- (void)clearFlag {
    
    for (NSInteger index= 0 ; index < self.freshFlags.count; index++) {
        
       NSInteger freshCount = [self.freshFlags[index] integerValue];
        
        if (freshCount) {
            
            freshCount = 0;
            
            if (index != 1) {
                
                [self.freshFlags replaceObjectAtIndex:index withObject:@(freshCount)];
                
            }
        }
    }

}

#pragma mark - 日历特殊处理
- (void)calendarPopWebViewNavHidden {
    
    //当前的头子显示是因为进入日历会没有头子
    
    TYWeakSelf(self);
    
    for (UIViewController *subVc in self.navigationController.viewControllers) {
        
        if ([subVc isKindOfClass:NSClassFromString(@"JGJCalendarViewController")]) {
            
            JGJCalendarViewController *calendarVc = (JGJCalendarViewController *)subVc;
            
            calendarVc.calendarVcBlock = ^{
                
                [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
                
                weakself.navigationController.navigationBarHidden = YES;
            };
            
            self.navigationController.navigationBarHidden = NO;
            
            break;
        }
        
        if ([subVc isKindOfClass:NSClassFromString(@"JGJChatRootCommonVc")]) {
            
            self.navigationController.navigationBarHidden = NO;
            
            break;
        }
        
    }
}

@end
