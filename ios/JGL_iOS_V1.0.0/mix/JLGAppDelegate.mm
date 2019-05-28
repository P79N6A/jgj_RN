//
//  JGLAppDelegate.m
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGAppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJMD5.h"

#import "WXApi.h"

//Tool
#import "TYFMDB.h"
#import "TYDistance.h"
#import "TYBaseTool.h"
#import "TYShowMessage.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "TYGuideVc.h"
#import "JKNotifier.h"
#import "YZGGetIndexRecordViewController.h"
//读取联系人
#import "NSString+JSON.h"
#import "TYAddressBook.h"
//友盟推送修改
//#import <UMPush/UMessage.h>

#import "UMessage.h"

//#import "UserNotifications.h"
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "JLGCustomViewController.h"
#import "YZGWageBestDetailModel.h"

//百度地图KEY
#define BMKMap_KEY @"fD1vxacofouqlM08pSwsnYha"

//百度推送
//#import "BPush.h"
//百度推送的Key
#define BPushKey   @"560PSG94ctCiny1cK0Tmav9Q"

//#define androidJson YES
#ifdef androidJson
#import "NSString+JSON.h"
#endif

#import "AppDelegate+JLGThirdLib.h"
#import "JGJSocketRequest.h"

#import "JGJChatListTool.h"
#import "JGJWebAllSubViewController.h"
#import "JGJAddressBookTool.h"
#import <AddressBook/AddressBook.h>
#import <AlipaySDK/AlipaySDK.h>
#import "JGJWeiXin_pay.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JLGAppDelegate+Service.h"

#import "JGJChatOffLineMsgTool.h"

#import "JGJSocketRequest+ChatMsgService.h"

#import <BaiduMobStatCodeless/BaiduMobStat.h>

#import "JGJCustomPopView.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

#import "JGJNewHomeViewController.h"
#import "JLGLoginViewController.h"
#import "JGJDeviceTokenManager.h"

#import <Growing.h>
#import "JGJNativeEventEmitter.h"

//定位的最小距离，超过就更新
#define locationDistance 3000

BMKMapManager* _mapManager;

// 闪验SDK
#define CL_SDK_APPID    @"84p7WvGo"
#define CL_SDK_APPKEY   @"hALXRDEd"

#define GrowingIO_AccountId @"942447e1e20005b7"

typedef NS_ENUM(NSUInteger, SettingFail) {
    SettingFailDefault = 0,//默认的
    SettingFailNetWorking,//网络
    SettingFailLocation,//定位
    SettingFailRemote//推送
};

@interface JLGAppDelegate ()
<
    UIAlertViewDelegate,
    BMKGeneralDelegate,//网络
    BMKGeoCodeSearchDelegate,//Geo
    BMKLocationServiceDelegate,//定位
    UNUserNotificationCenterDelegate,
    CLLocationManagerDelegate
>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}
@property (nonatomic,assign) SettingFail failType;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;
//@property (nonatomic,assign) BOOL isLaunchedByNotification;//记录是否点击的推送栏，用于本地推送时app打开和关闭情况下的判断

//上传位置到服务器
@property (nonatomic, assign) BOOL isUploadLocalService;
//@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation JLGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 测试合并
    
#ifdef androidJson
    [NSString showJSON:@"CityData"];
#endif
    
    [TYUserDefaults setObject:@"0" forKey:JLGUserstamp];
    
    [TYUserDefaults synchronize];
    
    // 用于首页显示滑动更多蒙层
    [TYUserDefaults setInteger:0 forKey:JGJHomeVCIsShowScrollShowMoreMasking];
    
    //App启动的时候标识没有处理消息，当前要处理 ，这个标识很重要，是否处理消息
    [TYUserDefaults removeObjectForKey:JGJIsHandlingMsg];
    
    //设置首次启动拉取离线消息,处理结束才获取重现socket消息
    
    [TYUserDefaults setBool:YES forKey:JGJIslLaunchOfflineMsg];
   
    // 闪验SDK初始化
    [CLShanYanSDKManager initWithAppId:CL_SDK_APPID AppKey:CL_SDK_APPKEY timeOut:1.0 complete:^(CLCompleteResult * _Nonnull completeResult) {
        if (completeResult.error) {
            TYLog(@"==闪验SDK初始化失败===>%@",completeResult.error);
        }else {
            TYLog(@"==闪验SDK初始化成功===>%@",completeResult.data);
        }
    }];
    // GrowingIO统计
    [Growing startWithAccountId:GrowingIO_AccountId];
    
    // 开启Growing调试日志 可以开启日志
     [Growing setEnableLog:YES];

    
    if (JLGisLoginBool) {
        
        // 获取是否记过事情况，用于首页显示蒙层
        [self getNoteListSituation];
        
        // 已经登录的 获取首页班组信息
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
        [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:^(BOOL responseObject) {
            
            //获取聊天消息
            [JLGAppDelegate chatMsgService];
            
        }];
        
        [JGJChatGetOffLineMsgInfo http_getClosedGroupList];
        
        // 预加载首页数据
        [JGJChatGetOffLineMsgInfo http_getHomeCalendarData];
        //移除通讯录文件
        [JLGAppDelegate removeAddressbookFile];
        
        NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        if (![NSString isEmpty:uid]) {
            
            [[BaiduMobStat defaultStat] setUserId:uid];
        }
        
    }
    
    //保证每次启动调用一次
    
    [TYUserDefaults setBool:NO forKey:JGJAppIsDidCallBackGroups];
    
    [TYUserDefaults synchronize];
    
    //服务器时间
    [self getStamp];
    
    //百度地图
    [self BMKMapConfig];
    
    [CLLocationManager locationServicesEnabled];
    
    //设置全局状态
    [TYBaseTool setGlobalStatus];

    // 获取通知权限开启情况
//    [self isMessageNotificationServiceOpen];

    [self umenSendWithlaunchOptions:launchOptions];

    //设置根目录
    [self RootViewControllerConfig];
    
    //版本号检测
//    [self GetVersionConfig];

    
    [JGJSocketRequest shareSocketConnect]; //链接Socket
    

    //操作本地缓存
    [self setCache];
    [self weixin_pay];
    
//    //上传位置到服务器，获取位置的时候调用 3.5.0修改
//    [self uploadLocalServiceRequst];
    
//    bug号12005  吉工家和吉工宝的闪屏停留时间延长，用2秒
    
    //百度统计key
    [[BaiduMobStat defaultStat] startWithAppId:BaiduStaApp_key];
    
    
    
//3.4.1又要延长2s
    
    if (!TYIS_IPHONE_6 && !TYIS_IPHONE_6P && !TYIS_IPHONE_5) {
        
        [NSThread sleepForTimeInterval:2];
    }
    
    
    
    return YES;
}

- (void)getNoteListSituation {
    
    BOOL isLoadNoteList = [TYUserDefaults boolForKey:JGJHomeIsLoadNoteList];
    
    if (!isLoadNoteList) {
        
        NSDictionary *param = @{@"content_key":@"",
                                @"pg":@(1),
                                @"pagesize":@(20)
                                };
        
        [JLGHttpRequest_AFN PostWithNapi:@"notebook/get-list" parameters:param success:^(id responseObject) {
            
            [TYUserDefaults setBool:YES forKey:JGJHomeIsLoadNoteList];
            NSArray *noteList = [NSArray arrayWithObject:responseObject];
            if (noteList.count > 0) {
                
                [TYUserDefaults setBool:YES forKey:JGJUserHaveMakeANote];
                
            }else {
                
                [TYUserDefaults setBool:NO forKey:JGJUserHaveMakeANote];
            }
        } failure:^(NSError *error) {
            
            [TYUserDefaults setBool:NO forKey:JGJHomeIsLoadNoteList];
        }];
    }
}

#pragma mark - 微信支付接入
- (void)weixin_pay
{
//    [WXApi registerApp:@"wx0d7055be43182b5e" withDescription:@"personwxinlogin"];
    
//    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
//        NSLog(@"log : %@", log);
//
//    }];
    
    //向微信注册
    [WXApi registerApp:@"wx0d7055be43182b5e"];
    
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    //    return  [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];
    
    [Growing handleUrl:url];
    
    return  [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];
}


-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary * _Nullable))reply
{
    
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    [Growing handleUrl:url];
    
    if ([url.host containsString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if ([url.absoluteString containsString:AuthorLogin]) {
        
        //        登录授权成功返回
        
        [self loginAuthorSuccess];
        
    }
    
    else if ([url.scheme containsString:@"jigongjia"]) {// 外部浏览器唤醒app
        
        TYLog(@"url.absoluteString = %@",url.absoluteString);
        NSString *urlStr = url.absoluteString;
        //必须登录才能使用
        if ([self unLoginStatus]) {
            
            return YES;
        }
        
        
        NSString *subStr = [urlStr substringFromIndex:12];
        if ([NSString isEmpty:subStr]) {// 只是唤醒
            
            
        }else {
            
            // 先处理特殊情况  h5/job -> tabbar选中找活招工  h5/my -> tabbar选中我的 h5/find -> tabbar选中发现  其他情况 新起web打开链接
            
            JLGCustomViewController *customNavhomeVC = (JLGCustomViewController *)self.window.rootViewController;
            for (UIViewController *vc in customNavhomeVC.viewControllers) {
                
                if ([vc isKindOfClass:[JGJWebAllSubViewController class]]) {
                    
                    [customNavhomeVC popViewControllerAnimated:YES];
                }
            }
            
            if ([subStr isEqualToString:@"h5/job"]) {
               
                for (UITabBarController *tabBarVc in customNavhomeVC.viewControllers) {
                    
                    for (UIViewController *vc in tabBarVc.viewControllers) {
                        
                        if ([vc isKindOfClass:[JGJWebAllSubViewController class]]) {
                            
                            JGJWebAllSubViewController *webVC = (JGJWebAllSubViewController *)vc;
                            [webVC loadWebView];
                            
                        }
                    }
                    if ([tabBarVc isKindOfClass:[UITabBarController class]]) {
                        if (tabBarVc.tabBar.hidden) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                tabBarVc.tabBar.hidden = NO;
                                
                            });
                        }
                        tabBarVc.selectedIndex = 2;
                        
                        break;
                    }
                }
                
            }else if ([subStr isEqualToString:@"h5/find"]) {
                
                for (UITabBarController *tabBarVc in customNavhomeVC.viewControllers) {
                    
                    for (UIViewController *vc in tabBarVc.viewControllers) {
                        
                        if ([vc isKindOfClass:[JGJWebAllSubViewController class]]) {
                            
                            JGJWebAllSubViewController *webVC = (JGJWebAllSubViewController *)vc;
                            [webVC loadWebView];
                            
                        }
                    }
                    if ([tabBarVc isKindOfClass:[UITabBarController class]]) {
                        
                        if (tabBarVc.tabBar.hidden) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                tabBarVc.tabBar.hidden = NO;
                                
                            });
                        }
                        tabBarVc.selectedIndex = 3;
                        
                        break;
                    }
                }
            }else if ([subStr isEqualToString:@"h5/my"]) {
                
                for (UITabBarController *tabBarVc in customNavhomeVC.viewControllers) {
                    
                    for (UIViewController *vc in tabBarVc.viewControllers) {
                        
                        if ([vc isKindOfClass:[JGJWebAllSubViewController class]]) {
                            
                            JGJWebAllSubViewController *webVC = (JGJWebAllSubViewController *)vc;
                            [webVC loadWebView];
                            
                        }
                    }
                    
                    if ([tabBarVc isKindOfClass:[UITabBarController class]]) {
                        
                        if (tabBarVc.tabBar.hidden) {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                tabBarVc.tabBar.hidden = NO;
                                
                            });
                        }
                        
                        tabBarVc.selectedIndex = 4;
                        break;
                    }
                }
            }else {
                
                NSString *urlStr = [subStr substringFromIndex:3];
                NSString *webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,urlStr];
                JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
                [customNavhomeVC pushViewController:webVc animated:YES];
            }
        }

    }
    
    return [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];
    
    
    
}

#pragma mark - 登录授权成功返回
- (void)loginAuthorSuccess {
    
    JGJWeiXin_pay *wxPay = [JGJWeiXin_pay sharedManager];
    
    TYWeakSelf(self);
    
    wxPay.wxAuthorSuccessBlock = ^(JGJWeiXinuserInfo *wxUserInfo) {
        
//        [TYNotificationCenter postNotificationName:JGJWXBindpostNotification object:wxUserInfo];
        
        if (weakself.thirdAuthorLoginSuccessBlock) {
            
            weakself.thirdAuthorLoginSuccessBlock(wxUserInfo);
        }
    };
    
}

//方法是被弃用了的
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //    return [WXApi handleOpenURL:url delegate:self];
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];
    
}

// 获取通知是否开启权限
- (void)isMessageNotificationServiceOpen {
    
    TYWeakSelf(self);
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
           
            NSLog(@"setting = %@",settings);

            if(settings.authorizationStatus == UNAuthorizationStatusAuthorized){

                weakself.isOpenNotificationJurisdiction = YES;

            } else {

                weakself.isOpenNotificationJurisdiction = NO;
            }
        }];


    } else if ([[UIDevice currentDevice].systemVersion doubleValue] == 8.0) {

        self.isOpenNotificationJurisdiction = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];

    } else {

        self.isOpenNotificationJurisdiction = UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
    
}

//友盟推送
- (void)umenSendWithlaunchOptions:(NSDictionary *)launchoption
{
    
//友盟推送修改
    
    [UMessage startWithAppkey:UmengApp_KEY launchOptions:launchoption];

    [UMessage registerForRemoteNotifications];
    
    [UMessage setLogEnabled:YES];
    
    //开发模式 no为生产模式
//    [UMessage openDebugMode:NO];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //友盟推送修改
//    [UMessage setLogEnabled:YES];
}

/**
 * 锁屏的监控
 */
- (void)YZGLockAllScreen:(NSNotification *)notification
{
    if (TYiOS9Later) {
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        [topVC.view endEditing:YES];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    //    //系统设置的判断
//    [self SettingsConfig];
    
    [self networkingConfig];
    
    //进入前台就开始定位
    [_locService startUserLocationService];
    
//    //角标清0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //连接socket
    
    [self socketConnect];
    
}

- (void)socketConnect {
    
    JGJSocketRequest *socket = [JGJSocketRequest shareSocketConnect];
    
    TYLog(@"进入前台之前applicationWillEnterForeground-readyState------%@", @(socket.webSocket.readyState));
    
    NSString *token = [TYUserDefaults objectForKey:JLGToken];
    
    if (socket.webSocket.readyState >= SR_CLOSING && ![NSString isEmpty:token] && JLGisLoginBool) {
        
        [JGJSocketRequest closeSocket];
        
        [JGJSocketRequest socketReconnect];
        
        //socket的timer使用
        [JGJSocketRequest socketHeartTimerStart];
        
        //消息显示的timer使用
        [JGJSocketRequest receiveMsgTimerStart];
    }
    
    TYLog(@"进入前台之后applicationWillEnterForeground-readyState------%@", @(socket.webSocket.readyState));
    
}

#pragma mark - 版本号检测
- (void)GetVersionConfig{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *keyChainIdentifierString = [TYBaseTool getKeychainIdentifier];
    if (keyChainIdentifierString != nil) {
        parametersDic = [NSMutableDictionary dictionaryWithDictionary:@{@"os":@"I",@"device_id":keyChainIdentifierString,@"version":currentVersion}];
    }else{
        return;
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"jlsys/version" parameters:parametersDic success:^(id responseObject) {
        if ([responseObject[@"ifaddressBook"] integerValue] == 1) {//需要上传通讯录
            //读取联系人
            if ([self isPermitAddressBook]) {
                [self loadAddressBook];
            }
        }
    
        NSInteger forceUpdate = [responseObject[@"forceUpdate"] integerValue];
        if (forceUpdate == 2) {
            TYLog(@"强制升级");
            exit(0);
        }else if(forceUpdate == 1){
            TYLog(@"一般的更新");
        }else{
            TYLog(@"不更新");
        }
    }];
}
#pragma mark - 这句主要用于打补丁使用当前版本上传通信录被拒绝
- (BOOL)isPermitAddressBook {
    return YES;
}

#pragma mark - 百度地图
- (void)BMKMapConfig{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMKMap_KEY generalDelegate:self];
    NSString *isSuccess = ret?@"成功":@"失败";
    TYLog(@"百度地图启动%@!",isSuccess);
    
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//
//    if (status !=kCLAuthorizationStatusDenied && status != kCLAuthorizationStatusNotDetermined) {
//
//        [self initilalUserUnSelLocal];
//
//    }
    
    [self initilalUserUnSelLocal];
    
    //进入的时候先设置没有定位成功
    [TYUserDefaults setBool:NO forKey:JLGLocation];
    [TYUserDefaults synchronize];
}

#pragma mark - 用户没选择定位开启定位弹框
- (void)initilalUserUnSelLocal {
    
    //定位不能用
    
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    //设定定位的最小更新距离
    _locService.distanceFilter = locationDistance;
    // 设定定位精度,3Km更新。
    _locService.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    [_locService startUserLocationService];
    
    //geo搜索
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    _geocodesearch.delegate = self;
}

#pragma mark - 没打开定位描述
- (void)unOpenLocalTilte:(NSString *)title message:(NSString *)message {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self initilalUserUnSelLocal];
    }else {
        BOOL locationEnable = [CLLocationManager locationServicesEnabled];
        CGFloat systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
        NSString *urlString;
        if (locationEnable) {
            urlString = UIApplicationOpenSettingsURLString;
        } else {
            urlString = (systemVersion >= 10.0) ? @"App-Prefs:root=Privacy&path=LOCATION" : @"prefs:root=Privacy&path=LOCATION";
        }
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        if ([NSString isEmpty:title]) {
            desModel.title = @"定位服务已关闭";
        } else {
            desModel.title = title;
        }
        desModel.popDetail = message;
        
        desModel.leftTilte = @"以后设置";
        
        desModel.rightTilte = @"前往开启";
        
        desModel.changeContents = @[@"【吉工家】"];
        
        desModel.changeContentColor = AppFont000000Color;
        
        desModel.lineSapcing = 0;
        
        desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
        
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.messageLable.textAlignment = NSTextAlignmentLeft;
        
        __weak typeof(self) weakSelf = self;
        
        alertView.onOkBlock = ^{
    
            NSURL *url = [NSURL URLWithString:urlString];
            if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }else if (systemVersion >= 10.0) {  // iOS10.0及以后
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        }];
                    }
                }
            }
        };
    }
    
}


//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    TYLog(@"locationManager");
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
//
//            NSString *city = [TYUserDefaults objectForKey:JLGCityName];
//
//            NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
//
//            NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
//
//            NSString *province = [TYUserDefaults objectForKey:JLGProvinceName];
//
//            NSDictionary *callBackDic = @{@"adcode" : adcode?:@"",
//
//                                          @"city" : city?:@"",
//
//                                          @"lat" : lat?:@"",
//
//                                          @"lng" : lng ?:@"",
//
//                                          @"province" : province?:@""
//
//                                          };
//            NSString *localJson = [NSString getJsonByData:callBackDic];
//
//            [JGJNativeEventEmitter emitEventWithName:@"getPlace" body:localJson];
//
//        });
//
//    }
//}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
    
    //如果定位精度大于3公里或者不正确就不做操作
    if (accuracy > kCLLocationAccuracyThreeKilometers || accuracy == -1) {
        return;
    }
    
    CLLocationDegrees latitude  = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    TYLog(@"百度地图更新经纬度:\nlat %f,\nlong %f",latitude,longitude);
    
    NSString *latitudeString = [NSString stringWithFormat:@"%.6f",latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%.6f",longitude];
    
    CGFloat distance = [TYDistance getDistanceBylat1:latitude lng1:longitude lat2:[[TYUserDefaults objectForKey:JLGLatitude] floatValue] lng2:[[TYUserDefaults objectForKey:JLGLongitude] floatValue]];
    
    if (!self.parametersDic) {
        self.parametersDic = [[NSMutableDictionary alloc] init];
        self.parametersDic[@"location"] = [NSString stringWithFormat:@"%@,%@",longitudeString,latitudeString];
        
    }
    [TYUserDefaults setBool:YES forKey:JLGLocation];
    [TYUserDefaults setObject:latitudeString forKey:JLGLatitude];
    [TYUserDefaults setObject:longitudeString forKey:JLGLongitude];
    [TYUserDefaults synchronize];
    
    //发起反向地理编码检索
    //初始化检索对象
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];

    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    NSString *geoString = flag == YES?@"成功":@"失败";
    TYLog(@"反Geo检索发送%@",geoString);
}


#pragma mark 接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == BMK_SEARCH_NO_ERROR) {
        [TYUserDefaults setObject:[NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district] forKey:JLGCityWebName];
        
        NSString *locationAddress = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
        [TYUserDefaults setObject:locationAddress forKey:JGJLocationAddress];
        
        BMKPoiInfo *poiInfo = (BMKPoiInfo *)[result.poiList firstObject];
        [TYUserDefaults setObject:poiInfo.name forKey:JGJLocationAddressDetail];
        
        //上传到服务器的地址是县级和保存到本地的不一样
        NSString *sysCityString = [NSString string];//上传到服务器的需要县
        if (![NSString isEmpty:result.addressDetail.district]) {
            sysCityString = [NSString getSubString:result.addressDetail.district Exclude:@[@"市",@"区",@"县"]];
        }
        NSMutableArray *sysDataArray = [[TYFMDB searchCitybyKeyID:TYFMDBCityName byKey:sysCityString] mutableCopy];
        JLGCityModel *sysJlgCityModel = [sysDataArray firstObject];
        TYLog(@"城市信息:%@====>>%@",sysJlgCityModel.city_name,sysJlgCityModel.city_code);
        
        NSString *latitudeString = [NSString stringWithFormat:@"%.6f",result.location.latitude];
        
        NSString *longitudeString = [NSString stringWithFormat:@"%.6f",result.location.longitude];
        
        NSString *location = [NSString stringWithFormat:@"%@,%@", longitudeString,latitudeString];
        
        if (!self.parametersDic) {
            
            self.parametersDic = [[NSMutableDictionary alloc] init];
        }
        
        self.parametersDic[@"location"] = location?:@"";
        
        //保存cityNo
        NSString *cityString = [NSString string];
        if (![NSString isEmpty:result.addressDetail.city]) {
            
            cityString = [NSString getSubString:result.addressDetail.city Exclude:@[@"市",@"区",@"县"]];
            
        }else{
            
            TYLog(@"百度地图没有查找到数据");
            [TYUserDefaults setObject:@"" forKey:JLGSelectCityNo];
            [TYUserDefaults setObject:@"未定位" forKey:JLGSelectCityName];
            [TYUserDefaults setObject:@"" forKey:JLGCityWebNo];
            [TYUserDefaults synchronize];
            return;
        }

        NSMutableArray *dataArray = [[TYFMDB searchCitybyKeyID:TYFMDBCityName byKey:cityString] mutableCopy];
        JLGCityModel *jlgCityModel = [dataArray firstObject];
        
        if (self.parametersDic && !_isUploadLocalService && ![NSString isEmpty:jlgCityModel.city_code] && JLGisLoginBool) {
            
            self.parametersDic[@"region"] = jlgCityModel.city_code;
            
            [JLGHttpRequest_AFN PostWithNapi:@"sys/common" parameters:self.parametersDic success:^(id responseObject) {
                
                 _isUploadLocalService = YES;
                
            } failure:^(NSError *error) {
                
                
            }];
            
        }
        
        if (jlgCityModel.city_code) {
            [TYUserDefaults setObject:jlgCityModel.city_code forKey:JLGCityWebNo];
            [TYUserDefaults setObject:jlgCityModel.city_code forKey:JLGCityNo];
            
            if (![NSString isEmpty:result.addressDetail.province]) {
                
                   [TYUserDefaults setObject:result.addressDetail.province?:@"" forKey:JLGProvinceName];
            }
            
            if (![NSString isEmpty:jlgCityModel.city_name]) {
                
                [TYUserDefaults setObject:jlgCityModel.city_name forKey:JLGCityName];
            }
            
            [TYUserDefaults synchronize];
            
            //更新的间隔时间超过了10秒才更新
            [TYNotificationCenter postNotificationName:JLGCityNoUp object:nil];
            
        }else{//如果没有查找到，比如在香港，没有查找到数据
//            TYLog(@"数据库没有查找到对应的数据");
//            [TYUserDefaults setObject:@"" forKey:JLGSelectCityNo];
//            [TYUserDefaults setObject:@"未定位" forKey:JLGSelectCityName];
//            [TYUserDefaults setObject:@"" forKey:JLGCityWebNo];
//            [TYUserDefaults setObject:@"" forKey:JLGProvinceName];
//            [TYUserDefaults synchronize];
        }
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!(kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)) {
        TYLog(@"定位失败");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 != iError) {
        TYLog(@"百度地图联网失败:%d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 != iError) {
        TYLog(@"百度地图授权失败:%d",iError);
    }
}

#pragma mark - 判断是否开启系统服务
- (void)SettingsConfig{
    //是否开启定位
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [self goToSettingsByType:SettingFailLocation];
    }
    
    //网络状态监控
    [self networkingConfig];
}

//网络状态的判断
- (void)networkingConfig
{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
//             case AFNetworkReachabilityStatusNotReachable:
                 TYLog(@"网络状态:未知网络状态或者无网络连接");
                 [weakSelf goToSettingsByType:SettingFailNetWorking];
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 TYLog(@"网络状态:移动网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 TYLog(@"网络状态:Wifi");
                 break;
             default:
                 break;
         }
     }];
}

-(void)goToSettingsByType:(SettingFail )failType
{
    self.failType = failType;
    NSString *title;
    NSString *message;
    if (self.failType == SettingFailLocation) {
        title = @"打开定位";
        message = @"定位服务未开启,请进入系统:\n【设置】->【隐私】->【定位服务】\n中允许使用定位服务";
    }else if(self.failType == SettingFailNetWorking){
        title = @"打开网络连接";
        message = @"网络连接失败,请确定已经连接上网络";
    }
    
    UIAlertView *alter;
    if (TYiOS8Later) {
        alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开启",nil];
    }else {
        alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }

    [alter show];
}

//选中的按钮操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //iOS8以后可以直接跳转到应用的设置
    if (buttonIndex == 1) {
        NSURL *url;
        //跳转到【设置】对应的应用界面
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 修改根控制器
- (void )RootViewControllerConfig{
    
    if ([self enterGuideViewController]) {
        //如果当前版本号和之前的版本号不相等，就显示引导页面
        return;
    }

    self.window.backgroundColor = AppFontfafafaColor;
    [self setRootViewController];
}

//设置rootVc
- (void)setRootViewController{
#if 1
    
    //必须登录才能使用
    if ([self unLoginStatus]) {
        
        return;
    }
    
    UINavigationController *rootVc = (UINavigationController *)self.window.rootViewController;
    if ([rootVc isKindOfClass:[JLGCustomViewController class]]) {
        if (rootVc.viewControllers.count) {
            UIViewController *tabBarVc = (UIViewController * )rootVc.viewControllers[0];
            tabBarVc = nil;
        }
    }
    rootVc = nil;
    self.window.rootViewController = nil;
    
    NSString *storyBordStr = JLGisMateBool?@"WorkMateMain":@"WorkLeaderMain";
//    NSString *storyBordStr = JLGisMateBool?@"JGJRecordWork":@"JGJleaderWork";

    JLGCustomViewController *customNavhomeVC = [[UIStoryboard storyboardWithName:storyBordStr bundle:nil] instantiateViewControllerWithIdentifier:@"JLGCustomViewController"];
    self.window.backgroundColor = AppFontf1f1f1Color;
    self.window.rootViewController = customNavhomeVC;
    
    //设置成功回调消失页面
    if (self.setRootSuccessBlock) {
        
        self.setRootSuccessBlock();
        
    }
    
#else//测试的时候用
    UIViewController *gotoVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListRecordVc"];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:gotoVc];
    self.window.backgroundColor = AppFontfafafaColor;
#endif
    
}

- (BOOL)unLoginStatus {
    
    if (!JLGisLoginBool) {
        
        // 防止多次调用,创建多次JLGLoginViewController
        UIViewController *rootVc = self.window.rootViewController;
        if ([rootVc isKindOfClass:JLGCustomViewController.class]) {
            if ([((JLGCustomViewController *)rootVc).topViewController isKindOfClass:JLGLoginViewController.class] ) {
                return !JLGisLoginBool;
            }
        }
        
        UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        
        [changeToVc setValue:@YES forKey:@"goToRootVc"];
        
        JLGCustomViewController *contactedNav = [[JLGCustomViewController alloc] initWithRootViewController:changeToVc];
        
        self.window.rootViewController = contactedNav;
        
    }
    
    return !JLGisLoginBool;
}

// 是否进入引导页
- (BOOL )enterGuideViewController
{
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [TYUserDefaults objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if (![currentVersion isEqualToString:lastVersion])
    {// 这次打开的版本和上一次不一样，引导页
        //如果版本号不一致，先更新数据库文件
        [TYSaveFilePath copyFileAtPath:TYDesFileNamePath SrcFileName:TYSaveSrcFileNamePath];
        
        self.window.rootViewController = [[TYGuideVc alloc] initWithBlock:^{

        }];
        // 将当前的版本号存进沙盒
        [TYUserDefaults setObject:currentVersion forKey:key];
        [TYUserDefaults synchronize];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 读取联系人
- (void)loadAddressBook{
    if (!JLGLoginBool) {//没有登录不传
        return;
    }
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            [TYAddressBook loadAddressBookByHttp];
        });
        [TYAddressBook loadAddressBookByHttp];
    }
}

#pragma mark - 百度推送
//- (void)BPushConfigWithOptions:(NSDictionary *)launchOptions{
//    // iOS8 下需要使用新的 API
//    // 判读系统版本是否是“iOS 8.0”以上
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
//        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
//        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        // 定义用户通知设置
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        // 注册用户通知 - 根据用户通知设置
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }
////    else { // iOS8.0 以前远程推送设置方式
////        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
////        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
////        
////        // 注册远程通知 -根据远程通知类型
////        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
////    }
//    
//    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
////#ifdef DEBUG
//////    [BPush registerChannel:launchOptions apiKey:BPushKey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
////#else
////    [BPush registerChannel:launchOptions apiKey:BPushKey pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
////#endif
////    // App 是用户点击推送消息启动
////    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
////    if (userInfo) {
////        TYLog(@"从消息启动:%@",userInfo);
//////        [BPush handleNotification:userInfo];
////    }
////    //角标清0
////    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
////    //是否开启推送
////    BOOL isRemoteNotType = [self isAllowedNotification];
////    if (isRemoteNotType == UIUserNotificationTypeNone) {
////        TYLog(@"没有开启推送");
////    }else{
////        TYLog(@"开启推送");
////    }
//}
//
-(BOOL)isAllowedNotification
{
    
    //iOS8 check if user allow notification
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(UIUserNotificationTypeNone != setting.types) {
                return
                YES;
        }
    }
//    else
//    {//iOS7
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        
//        if(UIRemoteNotificationTypeNone != type)
//            return YES;
//    }
    
    return NO;
}

#pragma mark - 后台接收远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [UMessage didReceiveRemoteNotification:userInfo];
    [self dealpushWithApplication:application remoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
    JGJApsMsgModel *apsModel = [JGJApsMsgModel mj_objectWithKeyValues:userInfo[@"aps"]];
    
    NSString *msg_type = apsModel.msg_type;
    
//    [TYShowMessage showSuccess:[apsModel mj_JSONString]];
    
    if ([NSString isEmpty:msg_type]) {
        
        msg_type = @"";
    }
    
    NSArray *alert_types = @[@"pic",@"text",@"voice"];
    
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;

    if (appState == UIApplicationStateActive) {

        if ([alert_types containsObject:msg_type] || [NSString isEmpty:msg_type]) {


////            //当应用处于前台时提示设置，需要哪个可以设置哪一个
//            completionHandler(UNNotificationPresentationOptionBadge);
            
        }

    }else {


        //当应用处于后台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);

    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if((application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)){
        [JKNotifier showNotifer:notification.alertBody];
        TYLog(@"应用在前台 或者后台开启状态下，不跳转页面，让用户选择 userInfo = %@",notification.userInfo);
    }else if(application.applicationState == UIApplicationStateInactive){
        TYLog(@"后台状态下，直接跳转到跳转页面 userInfo = %@",notification.userInfo);
//        [self dealPushWithInfo:notification.userInfo];
    }
}

// 此方法是 用户点击了《通知》，应用在前台 或者开启后台并且应用在后台时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);

    [self dealpushWithApplication:application remoteNotification:userInfo];
}

- (void)dealpushWithApplication:(UIApplication *)application remoteNotification:(NSDictionary *)userInfo{
    //这段为测试
//    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeSendPushType URL:[[JGJWebDiscoverURL stringByAppendingString:DownLoadBillURL] stringByAppendingString:[NSString stringWithFormat:@"role=%@&uid=%@&type=%@&target_id=%@&date=%@&week=%@",userInfo[@"role"],userInfo[@"uid"],userInfo[@"type"],userInfo[@"target_id"],userInfo[@"date"],userInfo[@"week"]]]];
//    [(UINavigationController *)self.window.rootViewController pushViewController:webViewController animated:YES];
 

    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        TYLog(@"应用在前台 或者后台开启状态下，不跳转页面，发送一个本地推送 userInfo = %@",userInfo);
        if ([userInfo[@"msg_type"] isEqualToString:@"recorded"]) {//记账成功
            [TYBaseTool registerLocalNotification:userInfo];
        }
    }else{
//        TYLog(@"后台状态下，直接跳转到跳转页面");
//        [self dealPushWithInfo:userInfo];
    }
    
   
}
-(void)applicationWillTerminate:(UIApplication *)application
{
    [JGJSocketRequest closeSocket];
    
//    //是否进入聊天页面，锁屏后返回首页
//    [TYUserDefaults removeObjectForKey:JGJIsChatLockScreen];
    
    [self appDidisEnterBackground:@"1" responseBlock:nil];
    
}

- (void )dealPushWithInfo:(NSDictionary *)userInfo{
    
    JLGCustomViewController *customNav = (JLGCustomViewController *)self.window.rootViewController;
    
    if ([customNav isKindOfClass:[JLGCustomViewController class]]) {
        
        [customNav popToRootViewControllerAnimated:NO];
    }
    
    if ([userInfo[@"msg_type"] isEqualToString:@"recorded"]) {//记账成功
        [TYBaseTool notificationNav:(UINavigationController *)self.window.rootViewController PushToVc:userInfo];
    }else if([userInfo[@"msg_type"] isEqualToString:@"receiveMessage"]){//接受消息
        
        JLGCustomViewController *customNavhomeVC = (JLGCustomViewController *)self.window.rootViewController;

        for (UITabBarController *tabBarVc in customNavhomeVC.viewControllers) {

            if ([tabBarVc isKindOfClass:[UITabBarController class]]) {

                tabBarVc.selectedIndex = 1;

                break;
            }
        }
        
    }else if ([userInfo[@"msg_type"] isEqualToString:@"batchRecorded"]){
        [TYBaseTool notificationNav:(UINavigationController *)self.window.rootViewController PushToMoreVc:userInfo];
    }else if ([userInfo[@"msg_type"] isEqualToString:@"weekly_bills"]){
        [self testWebBillRecordWithUrl:userInfo[@"url"] withparm:userInfo];
    }else if ([userInfo[@"msg_type"] isEqualToString:@"notice"]||
              [userInfo[@"msg_type"] isEqualToString:@"log"]||
              [userInfo[@"msg_type"] isEqualToString:@"safe"]||
              [userInfo[@"msg_type"] isEqualToString:@"quality"]||
              [userInfo[@"msg_type"] isEqualToString:@"task"]||
              [userInfo[@"msg_type"] isEqualToString:@"approval"]||
              [userInfo[@"msg_type"] isEqualToString:@"meeting"]){
        
//        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:userInfo];
        [TYBaseTool notificationNav:(UINavigationController *)self.window.rootViewController PushToNoticationDetail:userInfo];
    
    }
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    [UMessage registerDeviceToken:deviceToken];
    
    NSString *channelID = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
        stringByReplacingOccurrencesOfString: @">" withString: @""]
        stringByReplacingOccurrencesOfString: @" " withString: @""];
    TYLog(@"获取DeviceToken成功====>%@",channelID);
    
    [TYUserDefaults setObject:channelID forKey:JGJDevicePushToken];
    [TYUserDefaults synchronize];
    
    if ([NSString isEmpty:channelID]) { return; }
    if (!JLGisLoginBool) { return; }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JGJDeviceTokenManager postDeviceToken:channelID];
    });

}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    TYLog(@"DeviceToken 获取失败，原因：%@",error);
    
}

#pragma mark - 从后台进入前台，重新请求未关闭班组，获取为读数和信息
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
    [self dealApplicationIconBageNumber];
    
    [self monitorNetStatusNotReachable];
    
    [self appDidisEnterBackground:@"0" responseBlock:nil];
    
    if (JLGisLoginBool) {
        
        [TYUserDefaults setBool:YES forKey:JGJSuspendlOfflineMsg];
        
        [JGJChatOffLineMsgTool getOfflineMessageListCallBack:^(NSArray *msglist) {
            
            TYLog(@"即将进入前台获取离线数据----%@", msglist);
            
            if (JGJSuspendlOfflineMsgBool) {
                
                [TYUserDefaults removeObjectForKey:JGJSuspendlOfflineMsg];
                
            }
            
        }];
        
//        JGJNewHomeViewController *homeVC = self.
    }
    
    [TYUserDefaults setBool:NO forKey:JGJAppIsDidisEnterBackground];
    
    [TYUserDefaults synchronize];
    
    [TYUserDefaults setObject:@"0" forKey:JLGUserstamp];
    
    [TYUserDefaults synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self dealApplicationIconBageNumber];
    
    [self appDidisEnterBackground:@"1" responseBlock:nil];
    
    JGJSocketRequest *socket = [JGJSocketRequest shareSocketConnect];
    
    TYLog(@"进入后台applicationDidEnterBackground-readyState------%@", @(socket.webSocket.readyState));
    
    [TYUserDefaults setBool:YES forKey:JGJAppIsDidisEnterBackground];
    
    [TYUserDefaults synchronize];

//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

#pragma mark - 进入后台告诉服务器，不要推logo的角标
- (void)appDidisEnterBackground:(NSString *)isEnterBackground responseBlock:(void(^)(id response))responseBlock {
    
    NSString *userUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([NSString isEmpty:userUid] || self.isUnCanReceiveChatMsg) {
        
        self.isUnCanReceiveChatMsg = NO;
        
        return;
    }
    
    TYLog(@"这里调用是否接受推送消息接口");
}

//#pragma mark - 从后台进入前台，重新请求未关闭班组，获取为读数和信息
//- (void)getActiveGroupList {
//    UIViewController *vc = self.window.rootViewController;
//    if ([vc isKindOfClass:[JLGCustomViewController class]]) {
//        JLGCustomViewController *cusNav = (JLGCustomViewController *)vc;
//        UITabBarController *tabBarVc = (UITabBarController * )cusNav.viewControllers[0];
//        if ([HomeVC isKindOfClass:[HomeVC class]]) {
//            HomeVC *homeVC = tabBarVc.viewControllers[0];
//            if ([homeVC isKindOfClass:[homeVC class]] && cusNav.viewControllers.count == 1 ) {
//                [homeVC loadActiveGroupList];
//                [homeVC.tableView reloadData];
//            }
//        }
//    }
//}

#pragma mark - 获取联系人
- (void)saveAddressBookContacts {
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取手机通讯录
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [JGJAddressBookTool saveAddressBookContacts];
    }
}

#pragma mark - 监听网络状态sd
- (void)monitorNetStatusNotReachable {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    [TYUserDefaults setBool:isReachableStatus forKey:JGJNotReachableStatus];
    [TYUserDefaults synchronize];
}

#pragma mark - cache
- (void)setCache {
    
    //2.0.3版本需要清除一次缓存
    if (![TYUserDefaults boolForKey:JGJ_Geren_2_0_3_ClearCache]) {
        [JGJChatListTool deleteSqlite];
        [TYUserDefaults setBool:YES forKey:JGJ_Geren_2_0_3_ClearCache];
        [TYUserDefaults synchronize];
    }
}

#pragma mark - web推送账单调试
- (void)testWebBillRecordWithUrl:(NSString *)url withparm:(id)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *MD5str = [JGJMD5 retrunMD5Withdic:dic[@"param"]];
        JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[NSString stringWithFormat:@"%@&uid=%@&param=%@",url,[TYUserDefaults objectForKey:JLGUserUid]?:@"0",MD5str]];
        
        NSLog(@"--- %@",[NSString stringWithFormat:@"%@&uid=%@&param=%@",url,[TYUserDefaults objectForKey:JLGUserUid]?:@"0",MD5str]);
        [(UINavigationController *)self.window.rootViewController pushViewController:webViewController animated:YES];
    }
}
-(void)getStamp
{
    [TYUserDefaults removeObjectForKey:JLGUserstamp];
    
   [JLGHttpRequest_AFN GetWithApi:@"Jlsys/getServerTimestamp" parameters:nil success:^(id responseObject) {
       NSInteger timeStamp =  [[NSDate date] timeIntervalSince1970];
       NSString *diffValue = [NSString stringWithFormat:@"%f",[responseObject[@"server_time"] doubleValue] - timeStamp];
       [TYUserDefaults setObject:diffValue forKey:JLGUserstamp];
       
       [TYUserDefaults synchronize];
       
   } failure:^(NSError *) {
       [TYUserDefaults setObject:@"0" forKey:JLGUserstamp];
       
       [TYUserDefaults synchronize];
   }];
    
    [TYUserDefaults synchronize];
    
    TYLog(@"JLGUserstamp-----%@", [TYUserDefaults objectForKey:JLGUserstamp]);
    
}
-(void)onReq:(BaseReq *)req
{
    
    
    
}

-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

#pragma mark - 上传位置到服务器
- (void)uploadLocalServiceRequst {
    
    //当前会退到后台调用，不接收聊天消息，在这里因为会重新更换token导致登录会不成功
    
    if (self.isUnCanReceiveChatMsg) {
        
         self.isUnCanReceiveChatMsg = NO;
        
        return;
    }
    
    NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
    
    NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
    
    NSString *location = [NSString stringWithFormat:@"%@,%@", lng,lat];
    
    if (![NSString isEmpty:adcode] && ![NSString isEmpty:lat] && ![NSString isEmpty:lng]) {
        
        NSDictionary *parameters = @{@"region" : adcode?:@"",
                                     
                                     @"location" : location?:@""
                                     };
        
        [JLGHttpRequest_AFN PostWithNapi:@"sys/common" parameters:parameters success:^(id responseObject) {
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }
    
}


//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//
//    if(_isFull)
//
//        return UIInterfaceOrientationMaskAll;
//
//    return UIInterfaceOrientationMaskPortrait;
//
//}


- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    
//    if (JGJIsChatLockScreenBool) {
//        
//        JLGCustomViewController *customNav = (JLGCustomViewController *)self.window.rootViewController;
//        
//        if ([customNav isKindOfClass:[JLGCustomViewController class]]) {
//            
//            [customNav popToRootViewControllerAnimated:NO];
//        }
//        
//        [self setRootViewController];
//    }
    
}

- (void) applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    
 
}

- (void)dealApplicationIconBageNumber {
    
    UIViewController *vc = self.window.rootViewController;
    if ([vc isKindOfClass:[JLGCustomViewController class]]) {
        // fix微信登录崩溃bug
        JLGCustomViewController *cusNav = (JLGCustomViewController *)vc;
        UIViewController *firstVc = cusNav.viewControllers.firstObject;
        if (![firstVc isKindOfClass:[UITabBarController class]]) {
            return;
        }
        UITabBarController *tabBarVc = (UITabBarController *)firstVc;
        JGJNewHomeViewController *homeVC = tabBarVc.viewControllers.firstObject;
        [homeVC dealTabbarUnreadMessageCount];
    }
    
}

@end
