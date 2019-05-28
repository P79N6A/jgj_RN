//
//  TYBaseTool.m
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import "TYBaseTool.h"
#import "UIKit/UIKit.h"
#import "JLGAppDelegate.h"
#import "NSString+Extend.h"

//唯一设备号
#import "SSKeychain.h"
#import "JGJDetailViewController.h"


#import "JGJTaskViewController.h"

#import "JGJQualityDetailVc.h"

#import "JGJWebAllSubViewController.h"

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
    [self setupNavByNarBar:navBar BybarTintColor:[UIColor whiteColor] tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
    
    //设置导航栏的透明度
    if(TYiOS8Later) {
        navBar.translucent = NO;
    }

#if 0
    //设置返回键
    //将返回按钮的文字position设置不在屏幕上显示
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    
//iOS 11 导航栏按钮，包括标题 居然消失不见了，经过排查发现问题出现在下面代码中，注释掉就ok
    
    if (!TYISGreatVersion11) {
        
       [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];//不显示文字
    }
    
    //设置背景图片
    UIImage *image = [[UIImage imageNamed:@"barButtonItem_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
#endif
}

+(void)setupNavByNarBar:(UINavigationBar *)navBar BybarTintColor:(UIColor *)barTintColor tintColor:(UIColor *)tintColor titleColor:(UIColor *)titleColor{
    //设置导航条的颜色
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_image_icon"] forBarMetrics:UIBarMetricsDefault];
    
    //设置返回键的颜色
    navBar.tintColor = tintColor;
    //设置标题文字
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = titleColor;
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:JGJNavBarFont];
    [navBar setTitleTextAttributes:dictAtt];
    
    [[UIApplication sharedApplication] setStatusBarStyle:CGColorEqualToColor(titleColor.CGColor, [UIColor whiteColor].CGColor) animated:YES];
}

+ (UIButton *)getLeftButtonByTitle:(NSString *)title titleNormalColor:(UIColor *)titleNormalColor titleHighlightColor:(UIColor *)titleHighlightColor normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage
{//不能使用懒加载，如果使用懒加载就会造成重影
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 70, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
    
    return button;
}

// 设置本地推送
+ (void)registerLocalNotification:(NSDictionary *)userInfo{
    if (!userInfo[@"aps"]) {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDictionary *apsDic = userInfo[@"aps"];
    
    // 通知内容
    notification.alertBody =  apsDic[@"alert"];
    notification.applicationIconBadgeNumber = [apsDic[@"badge"] integerValue];
    
    // 通知被触发时播放的声音
    notification.soundName = @"default";
    
    // 通知参数
    __block NSMutableDictionary *userDict = [userInfo mutableCopy];
    [userDict removeObjectForKey:@"aps"];
    
    NSDictionary *tmpUserDict = [userDict copy]?:nil;
    [tmpUserDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([NSString isEmpty:[NSString stringWithFormat:@"%@",obj]]) {
            [userDict removeObjectForKey:key];
        }
    }];

    notification.userInfo = [userDict copy]?:nil;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - 根据推送消息跳转界面
+ (void)notificationNav:(UINavigationController *)navVc PushToVc:(NSDictionary *)userInfo{
    if ([userInfo[@"accounts_code"] integerValue]) {//跳转到记账界面
        if (!JLGisLoginBool) {
            return;//没有登录不能跳转
        }
        
        NSInteger roleNum = [userInfo[@"role"] integerValue];
        
        //没有注册就调到注册界面
        if (roleNum == 1) {
            SEL gotoTransfVc = NSSelectorFromString(@"gotoTransfVc");
            IMP imp = [navVc methodForSelector:gotoTransfVc];
            void (*func)(id, SEL) = (void *)imp;
            func(navVc, gotoTransfVc);
            return ;
        }

    }
}

//设置全局的TextFiled光标
+ (void)setupGlobalTextField{
    [[UITextField appearance] setTintColor:JGJMainColor];
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
    return height/iPhone6W*TYGetUIScreenWidth;
}


+(void)notificationNav:(UINavigationController *)navVc PushToNoticationDetail:(NSDictionary *)userInfo
{
    if (![userInfo.allKeys containsObject:@"msg_type"]) {
        return;
    }
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:userInfo];
    if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"log"] || [userInfo[@"msg_type"]?:@"" isEqualToString:@"notice"]) {
        JGJDetailViewController *detailVC = [[JGJDetailViewController alloc]init];
        detailVC.chatRoomGo = YES;
        detailVC.jgjChatListModel = msgModel;
        
        [navVc pushViewController:detailVC animated:YES];
    }else if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"task"]){
        JGJTaskViewController *taskVc = [[JGJTaskViewController alloc]init];
        taskVc.jgjChatListModel = msgModel;
        [navVc pushViewController:taskVc animated:YES];
    }else if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"approval"]){
        
        JGJQualitySafeListModel *detailListModel = [JGJQualitySafeListModel mj_objectWithKeyValues:userInfo];
        
        NSString *applyStr = [NSString stringWithFormat:@"%@applyfor?group_id=%@&class_type=%@",JGJWebDiscoverURL, detailListModel.group_id, detailListModel.class_type];
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:applyStr];
        
        [navVc pushViewController:webVc animated:YES];
        //审批
    }else if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"quality"] || [userInfo[@"msg_type"]?:@"" isEqualToString:@"safe"]){
        
        JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
        
        if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"quality"]) {
            
            commonModel.type = JGJChatListQuality;
            
            commonModel.msg_type = @"quality";
            
        }else {
            
            commonModel.type = JGJChatListSafe;
            
            commonModel.msg_type = @"safe";
        }
        
        JGJQualitySafeListModel *detailListModel = [JGJQualitySafeListModel mj_objectWithKeyValues:userInfo];
        
        JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
        
        detailVc.commonModel = commonModel;
        
        detailVc.listModel = detailListModel;
        
        [navVc pushViewController:detailVc animated:YES];
        
        //质量
    }else if ([userInfo[@"msg_type"]?:@"" isEqualToString:@"meeting"]){
        
        NSString *meetingStr = userInfo[@"url"];
        
        if ([NSString isEmpty:meetingStr]) {
            
            return;
        }

        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:meetingStr];
        
        [navVc pushViewController:webVc animated:YES];
        
        
    }
    
}

@end
