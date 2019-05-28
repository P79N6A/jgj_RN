 //
//  JGJTabBarViewController.m
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTabBarViewController.h"

#import "LeftMenuVC.h"
#import "NSDate+Extend.h"
#import "TYFMDB.h"
#import "JGJContactedListVc.h"
#import "JLGCustomViewController.h"

#import "JLGAppDelegate.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "JGJMangerTool.h"
#import "UIImage+Color.h"
#import "JGJNewHomeViewController.h"
#import "JGJMineViewController.h"
#import "JGJDiscoveryController.h"
#import "JGJNavigationController.h"
#import "JGJRecruitmentController.h"
#import "JGJNativeEventEmitter.h"

@interface JGJTabBarViewController ()

//找工作和找帮手可能变化，所以就持有
@property (nonatomic, strong) UIViewController *findJobVc;

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
    
    UIViewController *viewController = self.childViewControllers[self.selectedIndex];
    
    if (self.selectedIndex == 0) {

       [self tabBarController:self selectViewController:viewController];
    }
    
    viewController.navigationController.navigationBarHidden = YES;
    
    _is_HiddenNav = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (!self.selectedIndex) {
        
        self.selectedIndex = 0;
    }
    
    UIViewController *viewController = self.childViewControllers[self.selectedIndex];
    
    //解决首页切换身份和聊聊查看图片导航栏出现
    
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
//    HomeVC *homeVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeVC"];
    JGJNewHomeViewController *homeVC = [[JGJNewHomeViewController alloc] init];
    
    //聊天
    JGJContactedListVc *contactedListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedListVc"];
    
    JLGCustomViewController *contactedNav = [[JLGCustomViewController alloc] initWithRootViewController:contactedListVc];
    
    //我的
//    NSString *myUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"my"];
//    JGJWebAllSubViewController *myWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:myUrl];
    
    JGJMineViewController *mineController = [[JGJMineViewController alloc] init];
    mineController.moudleName = @"my";
    JLGCustomViewController *mineNav = [[JLGCustomViewController alloc] initWithRootViewController:mineController];

    //发现
//    JGJWebAllSubViewController *findWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeNewLife];
    
    JGJDiscoveryController *discoveryController = [[JGJDiscoveryController alloc] init];
    discoveryController.moudleName = @"find";
    JLGCustomViewController *discoveryNav = [[JLGCustomViewController alloc] initWithRootViewController:discoveryController];
    
    
    // 找活招工
//    JLGCustomViewController *findJobVcNav = [[JLGCustomViewController alloc] initWithRootViewController:self.findJobVc];
    
    JGJRecruitmentController *recruitmentController = [[JGJRecruitmentController alloc] init];
    recruitmentController.moudleName = @"job";
    JLGCustomViewController *recruitmentNav = [[JLGCustomViewController alloc] initWithRootViewController:recruitmentController];
    
    
    self.vcsArr = @[homeVC,contactedNav,recruitmentNav,discoveryNav,mineNav].mutableCopy;
    
    self.freshFlags = @[@(1), @(1), @(1),@(1), @(1)].mutableCopy;
    
    [self subVcSetDic];
    
    if (!self.viewControllersDic || self.vcsArr.count == 0) {
        return;
    }
    
    [self updateChildVc];

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
        selectTextAttrs[NSForegroundColorAttributeName] = JGJMainColor;
        selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:AppFont26Size];

        
        //普通状态
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] =  AppFont333333Color;
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:AppFont26Size];
        
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
    
}

- (void)tabBarController:(UITabBarController *)tabBarController selectViewController:(UIViewController *)viewController{

    viewController.navigationController.navigationBarHidden = YES;
    
    if (tabBarController.viewControllers.count - 1 == tabBarController.selectedIndex) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
    } else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    }
    
    //这里是动态找工作页面，进入聊天返回聊聊页面用
    if (self.selectedIndexVc == 1) {
        self.selectedViewController = self.childViewControllers[self.selectedIndexVc];
        self.tabBar.hidden = NO;
        self.selectedIndexVc = 0;
    }
    
    NSInteger freshCount = [self.freshFlags[tabBarController.selectedIndex] integerValue];
    
    if ([viewController isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
        
        if (freshCount >= 1) {
            
            [self loadWebViewRequestWithVc:viewController tabbarIndex:tabBarController.selectedIndex];
        }
        
        if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3 || tabBarController.selectedIndex == 4) {
            
            freshCount += 1;
            
            [self.freshFlags replaceObjectAtIndex:tabBarController.selectedIndex withObject:@(freshCount)];
        }
        
        if (self.lastSelectedIndex != tabBarController.selectedIndex) {

            [self.freshFlags replaceObjectAtIndex:self.lastSelectedIndex withObject:@(0)];
        }

        self.lastSelectedIndex = tabBarController.selectedIndex;
        
    }else {
        
        [self clearFlag];
    }
    
    //定位弹框
    if (tabBarController.selectedIndex == 2) { // 点击找活招工
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) { // 未开启定位
            JLGAppDelegate *appDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
            if (!appDelegate.isAuthedLocal) { // 没有弹窗提示过
                NSString *message;
                BOOL locationEnable = [CLLocationManager locationServicesEnabled];
                if (locationEnable) { // 全局定位(GPS)开启,但是app定位未开启
                    message = @"开启定位服务你将获取到附近的招工信息，请到设置 > 隐私 > 定位服务中开启【吉工家】定位服务。帮助你快速找到满意的工作。";
                } else { // 全局定位(GPS)未开启
                    message = @"前往 设置 > 隐私 > 定位服务 打开位置信息，你将获取到附近的招工信息，帮助你快速找到满意的工作。";
                }
                [appDelegate unOpenLocalTilte:@"定位服务已关闭" message:message];
                appDelegate.isAuthedLocal = YES;
            }
        }
        
        // 调用RN方法
        [JGJNativeEventEmitter emitEventWithName:@"offSelect" body:nil];
    
    }

    //双击聊聊回顶部
    
     [self doubleTabChatIndex:tabBarController.selectedIndex];
    
    //工头才需要切换地址
    if (self.viewControllers.count  > 2 && tabBarController.selectedIndex  == 2 && JLGisLeaderBool) {

        [self clickTabBarRecruitWithVc:tabBarController.selectedViewController];

    }
    
}

#pragma mark - 没有项目和班组的人员如果首页进入了招聘然后点击tabBar招聘后地址还原
- (void)clickTabBarRecruitWithVc:(UIViewController *)webVc {
    
     JGJWebAllSubViewController *recrVc = (JGJWebAllSubViewController *)webVc;
    
    if ([recrVc isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")] && [recrVc respondsToSelector:@selector(requestWebviewWithWebType:)] && !recrVc.isDefaultClickedRecuit) {
        
        if (recrVc.isCanChangeRecruURL) {
            
            recrVc.isCanChangeRecruURL = NO;
            
            recrVc.isDefaultClickedRecuit = YES;
            
            JGJWebType webType = JLGisLeaderBool ? JGJWebTypeRecruitJob : JGJWebTypeFindJob;
            
            [recrVc requestWebviewWithWebType:webType];
            
        }
        
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

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    //重新设置所有 item 的字体
//    for (UITabBarItem *unSelItem in tabBar.items) {
//        if (unSelItem == item) {//选中的设置他的状态
//            NSDictionary *textTitleOptions = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
//            [item setTitleTextAttributes:textTitleOptions forState:UIControlStateNormal];
//        }else {//未选中的设置他的状态
//            NSDictionary *textTitleOptions = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
//            [unSelItem setTitleTextAttributes:textTitleOptions forState:UIControlStateNormal];
//        }
//    }
//}

#pragma mark - 判断是否要跳转
- (BOOL )checkIsRight{
    if (![self checkIsLogin]) {
        return NO;
    }
    
    if (![self checkIsInfo]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 判断是否要跳转
- (BOOL )checkDidSeledtedGroupChatIsRight{
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

-(BOOL)checkIsInfo{
    SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
    IMP imp = [self.navigationController methodForSelector:checkIsInfo];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsInfo)) {
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
//    HomeVC *homeVc = (HomeVC *)[self.vcsArr firstObject];
//    homeVc.workType = _workType;
    
//    LeftMenuVC *leftMenuVC = (LeftMenuVC *)[self.vcsArr lastObject];
//    leftMenuVC.workType = _workType;
}

#pragma mark 如果状态变化了，改变"找工作界面的内容"
- (BOOL )changeFindJobVc{
    //找工作找项目
    NSString *vcID = [NSString string];
    NSString *storyboardName = [NSString string];
    if (JLGLeaderIsInfoBool) {
        
        storyboardName = @"NewWorkItemDetail";
        vcID = @"findJobAndPro";
        
    } else {
        
        storyboardName = @"FindProject";
        vcID = @"JGJTouristFindItemViewController";
    }
    
    if ([_findJobVc.restorationIdentifier isEqualToString:vcID]) {
        return NO;
    }
    
    _findJobVc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcID];
    
    return YES;
}

- (UIViewController *)findJobVc
{
    if (!_findJobVc) {
        [self changeFindJobVc];
    }
    return _findJobVc;
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

@end
