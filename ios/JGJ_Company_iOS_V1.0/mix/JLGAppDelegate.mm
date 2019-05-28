//
//  JGLAppDelegate.m
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGAppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJWebAllSubViewController.h"
#import "JGJMD5.h"
//Tool
#import "TYFMDB.h"
#import "TYDistance.h"
#import "TYBaseTool.h"
#import "TYShowMessage.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "TYGuideVc.h"
#import "JKNotifier.h"
#import "UMessage.h"
//#import "UserNotifications.h"
//读取联系人
#import "NSString+JSON.h"
#import "TYAddressBook.h"
#import <AlipaySDK/AlipaySDK.h>
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "JLGCustomViewController.h"

//百度地图企业端key
#define BMKMap_KEY @"qHZXk1YgiPhstLc2tUDOv9m5qSN45sSG"

//百度推送
#import "BPush.h"
//百度推送的企业端API KEY
#define BPushKey   @"N7edwl4NhjdaZ4vK5oXbn5VG"

//#define androidJson YES
#ifdef androidJson
#import "NSString+JSON.h"
#endif

#import "AppDelegate+JLGThirdLib.h"
#import "JGJSocketRequest.h"
#import "HomeVC.h"
#import "JGJChatListTool.h"
#import "JGJWeiXin_pay.h"
#import "JGJAddressBookTool.h"
#import <AddressBook/AddressBook.h>
#import "JGJHistoryText.h"
#import "JGJAddAccountViewController.h"

#import "JLGLoginViewController.h"

#import "JGJTabBarViewController.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JLGAppDelegate+Service.h"

#import "JGJChatOffLineMsgTool.h"

#import <BaiduMobStatCodeless/BaiduMobStat.h>

#import "JGJCustomPopView.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

//定位的最小距离，超过就更新
#define locationDistance 3000

// 闪验SDK
#define CL_SDK_APPID    @"r74vjQcM"
#define CL_SDK_APPKEY   @"cFCBX2Vq"

BMKMapManager* _mapManager;

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
WXApiDelegate
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

@end

@implementation JLGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef androidJson
    [NSString showJSON:@"CityData"];
#endif
    
    // 闪验SDK初始化
    [CLShanYanSDKManager initWithAppId:CL_SDK_APPID AppKey:CL_SDK_APPKEY timeOut:3.0 complete:^(CLCompleteResult * _Nonnull completeResult) {
        if (completeResult.error) {
            TYLog(@"==闪验SDK初始化失败===>%@",completeResult.error);
        }else {
            TYLog(@"==闪验SDK初始化成功===>%@",completeResult.data);
        }
    }];
    
    //离线消息处理
    
    [JLGAppDelegate handleOfflineMsgService];
    
     if (JLGisLoginBool) {
         
         NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
         
         if (![NSString isEmpty:uid]) {
             
             [[BaiduMobStat defaultStat] setUserId:uid];
         }
         
     }
    
    [self getStamp];

//    //百度地图
    [self BMKMapConfig];
    
    //设置全局状态
    [TYBaseTool setGlobalStatus];

    //百度推送
#if 0
    [self BPushConfigWithOptions:launchOptions];
#else 
    [self uMenSendPushand:launchOptions];
#endif
    //设置根目录
    [self RootViewControllerConfig];
    
    //版本号检测
//    [self GetVersionConfig];
    
    [JGJSocketRequest shareSocketConnect]; //链接Socket
//    //缓存通信录联系人
//    if ([self isPermitAddressBook]) {
//         [self saveAddressBookContacts];   
//    }
    //操作本地缓存
    [self setCache];
    [self weixin_pay];

//    //上传位置到服务器
//    [self uploadLocalServiceRequst];
    
    //百度统计key
    [[BaiduMobStat defaultStat] startWithAppId:BaiduStaApp_key];
    
    //    bug号12005  吉工家和吉工宝的闪屏停留时间延长，用2秒
    
    //3.4.1又要延长2s
    
    if (!TYIS_IPHONE_6 && !TYIS_IPHONE_6P && !TYIS_IPHONE_5) {
        
        [NSThread sleepForTimeInterval:2];
    }

    return YES;
}
#pragma mark - 微信支付接入
- (void)weixin_pay
{
    [WXApi registerApp:@"wx4aef8d4d0753d388"];
}
//方法是被弃用了的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
//    return  [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];

    return  [WXApi handleOpenURL:url delegate:self];
}
-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary * _Nullable))reply
{


}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
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
    
    else if ([url.scheme containsString:@"jigongbao"]) {// 外部浏览器唤醒app
        
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

//    return [WXApi handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:[JGJWeiXin_pay sharedManager]];

}

- (BOOL)unLoginStatus {
    
    if (!JLGisLoginBool) {
        
        UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        
        [changeToVc setValue:@YES forKey:@"goToRootVc"];
        
        JLGCustomViewController *contactedNav = [[JLGCustomViewController alloc] initWithRootViewController:changeToVc];
        
        self.window.rootViewController = contactedNav;
        
    }
    
    return !JLGisLoginBool;
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
- (void)uMenSendPushand:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:@"57eccabde0f55a2fc2003b01" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:YES];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
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

    return NO;
}

#pragma mark - 百度地图
- (void)BMKMapConfig{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMKMap_KEY generalDelegate:self];
    NSString *isSuccess = ret?@"成功":@"失败";
    TYLog(@"百度地图启动%@!",isSuccess);
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status !=kCLAuthorizationStatusDenied && status != kCLAuthorizationStatusNotDetermined) {
        
        [self initilalUserUnSelLocal];
        
    }
    
    //进入的时候先设置没有定位成功
    [TYUserDefaults setBool:NO forKey:JLGLocation];
    [TYUserDefaults synchronize];
}

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
    
//    if (JLGLoginBool&&(distance > locationDistance)) {
//        self.parametersDic = [[NSMutableDictionary alloc] init];
//        self.parametersDic[@"location"] = [NSString stringWithFormat:@"%@,%@",longitudeString,latitudeString];
//    }
    
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
        
        //省份
        [TYUserDefaults setObject:result.addressDetail.province forKey:JLGProvince];
        
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
            [TYUserDefaults setObject:@"510100" forKey:JLGSelectCityNo];
            [TYUserDefaults setObject:@"成都市" forKey:JLGSelectCityName];
            [TYUserDefaults setObject:@"510100" forKey:JLGCityWebNo];
            [TYUserDefaults setObject:@"四川省" forKey:JLGProvinceName];
            [TYUserDefaults synchronize];
            return;
        }

        NSMutableArray *dataArray = [[TYFMDB searchCitybyKeyID:TYFMDBCityName byKey:cityString] mutableCopy];
        JLGCityModel *jlgCityModel = [dataArray firstObject];
        
        //上传位置确定同乡关系
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
            [TYUserDefaults setObject:jlgCityModel.city_name forKey:JLGCityName];
            [TYUserDefaults setObject:jlgCityModel.provinceCityName forKey:JLGProvinceName];
            [TYUserDefaults synchronize];
            
            //更新的间隔时间超过了10秒才更新
            [TYNotificationCenter postNotificationName:JLGCityNoUp object:nil];
        }else{//如果没有查找到，比如在香港，没有查找到数据
            TYLog(@"数据库没有查找到对应的数据");
            [TYUserDefaults setObject:@"510100" forKey:JLGSelectCityNo];
            [TYUserDefaults setObject:@"成都市" forKey:JLGSelectCityName];
            [TYUserDefaults setObject:@"510100" forKey:JLGCityWebNo];
            [TYUserDefaults synchronize];
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
             case AFNetworkReachabilityStatusNotReachable:
                  [TYUserDefaults setBool:YES forKey:JGJNotReachableStatus];
                 break;
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
        message = @"项目管理的“签到”功能需要你的同意，才能在使用期间访问位置信息";
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

#pragma mark - 用户没选择定位开启定位弹框
- (void)initilalUserUnSelLocal {
    
    //定位不能用
    
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    //设定定位的最小更新距离
    _locService.distanceFilter = locationDistance;
    // 设定定位精度,3Km更新。
    _locService.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
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
        float systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
        BOOL locationEnable = [CLLocationManager locationServicesEnabled];
        NSString *urlString;
        if (locationEnable) {
            urlString = UIApplicationOpenSettingsURLString;
        } else {
            urlString = (systemVersion >= 10.0) ? @"App-Prefs:root=Privacy" : @"prefs:root=Privacy";
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
    
    //未登录进入登录页面，登录之后才进入首页（工作页面）
    if (!JLGisLoginBool) {
        
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
        
        
        UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        
        [changeToVc setValue:@YES forKey:@"goToRootVc"];
        
        JLGCustomViewController *contactedNav = [[JLGCustomViewController alloc] initWithRootViewController:changeToVc];
        
        self.window.rootViewController = contactedNav;
        
        
        
    }else {
    
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_image_icon"] forBarMetrics:(UIBarMetricsDefault)];
        JLGCustomViewController *customNavhomeVC = [[UIStoryboard storyboardWithName:@"JGJRoot" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGCustomViewController"];
        
        self.window.rootViewController = customNavhomeVC;
    }
    
#else//测试的时候用
    UIViewController *gotoVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListAllVc"];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:gotoVc];
    self.window.backgroundColor = AppFontfafafaColor;
#endif
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
- (void)BPushConfigWithOptions:(NSDictionary *)launchOptions{
    // iOS8 下需要使用新的 API
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
//    else { // iOS8.0 以前远程推送设置方式
//        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        
//        // 注册远程通知 -根据远程通知类型
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
#ifdef DEBUG
    [BPush registerChannel:launchOptions apiKey:BPushKey pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
#else
    [BPush registerChannel:launchOptions apiKey:BPushKey pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
#endif
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        TYLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //是否开启推送
    BOOL isRemoteNotType = [self isAllowedNotification];
    if (isRemoteNotType == UIUserNotificationTypeNone) {
        TYLog(@"没有开启推送");
    }else{
        TYLog(@"开启推送");
    }
}



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

#pragma mark - 接收远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    // App 收到推送的通知
////    [BPush handleNotification:userInfo];
    [UMessage didReceiveRemoteNotification:userInfo];
//    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    [self dealpushWithApplication:application remoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    if((application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)){
        [JKNotifier showNotifer:notification.alertBody];
        TYLog(@"应用在前台 或者后台开启状态下，不跳转页面，让用户选择 userInfo = %@",notification.userInfo);
    }else if(application.applicationState == UIApplicationStateInactive){
        TYLog(@"后台状态下，直接跳转到跳转页面 userInfo = %@",notification.userInfo);
        [self dealPushWithInfo:notification.userInfo];
    }
    
}

// 此方法是 用户点击了《通知》，应用在前台 或者开启后台并且应用在后台时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self dealpushWithApplication:application remoteNotification:userInfo];
    
}

- (void)dealpushWithApplication:(UIApplication *)application remoteNotification:(NSDictionary *)userInfo{
    
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

- (void )dealPushWithInfo:(NSDictionary *)userInfo{
    
    JLGCustomViewController *customNav = (JLGCustomViewController *)self.window.rootViewController;
    
    if ([customNav isKindOfClass:[JLGCustomViewController class]]) {
        
        customNav.navigationBarHidden = NO;
        
        [customNav popToRootViewControllerAnimated:NO];
        
    }
    
//    if ([userInfo[@"msg_type"] isEqualToString:@"recorded"]) {//记账成功
//        [TYBaseTool notificationNav:(UINavigationController *)self.window.rootViewController PushToVc:userInfo];
//    }else if([userInfo[@"msg_type"] isEqualToString:@"reciveMessage"]){//接受消息
//        JGJChatMsgListModel *msgListModel = [JGJChatMsgListModel new];
//        [msgListModel mj_setKeyValues:userInfo[@"msg_info"]];
//        [JGJChatListTool addOrUpdateChatMessage:nil chatMsgListModel:msgListModel];
//    }else if ([userInfo[@"msg_type"] isEqualToString:@"weekly_bills"]){
//        [self testWebBillRecordWithUrl:userInfo[@"url"] withparm:userInfo];
//    }
    
    if ([userInfo[@"msg_type"] isEqualToString:@"recorded"]) {//记账成功
        [TYBaseTool notificationNav:(UINavigationController *)self.window.rootViewController PushToVc:userInfo];
    }else if([userInfo[@"msg_type"] isEqualToString:@"reciveMessage"]){//接受消息
        
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
- (void)testWebBillRecordWithUrl:(NSString *)url withparm:(id)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *MD5str = [JGJMD5 retrunMD5Withdic:dic[@"param"]];
        JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[NSString stringWithFormat:@"%@&uid=%@&param=%@",url,[TYUserDefaults objectForKey:JLGUserUid]?:@"0",MD5str]];
        [(UINavigationController *)self.window.rootViewController pushViewController:webViewController animated:YES];
        NSLog(@"%@ url = %@",MD5str,[NSString stringWithFormat:@"%@&uid=%@&param=%@",url,[TYUserDefaults objectForKey:JLGUserUid]?:@"0",MD5str]);
    }
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;

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
    
    if ([NSString isEmpty:msg_type]) {
        
        msg_type = @"";
    }
    
    NSArray *alert_types = @[@"pic",@"text",@"voice"];
    
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    
    if (appState == UIApplicationStateActive) {
        
        if ([alert_types containsObject:msg_type] || [NSString isEmpty:msg_type]) {
            
            //当应用处于前台时提示设置，需要哪个可以设置哪一个
//            completionHandler(UNNotificationPresentationOptionBadge);
            
        }
        
    }else {
        
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
        
    }
    
}
//
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self dealPushWithInfo:userInfo];

    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    TYLog(@"deviceToken:%@",deviceToken);
//    [BPush registerDeviceToken:deviceToken];
//    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
//        if (result) {
//            if ([TYUserDefaults objectForKey:JLGPhone]) {
//                [BPush setTag:[TYUserDefaults objectForKey:JLGPhone] withCompleteHandler:^(id result, NSError *error) {
//                }];
//            }
//            
//            [TYUserDefaults setValue:result[@"channel_id"] forKey:JLGPushChannelID];
//            [TYUserDefaults synchronize];
//            
//            //上传channelID
//            if (result[@"channel_id"]) {
//                [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:@{@"channel_id":result[@"channel_id"],@"os":@"I"} success:^(id responseObject) {
//                }];
//            }
//        }
//    }];
    
    
    [UMessage registerDeviceToken:deviceToken];
    NSString *deviceTokens = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [TYUserDefaults setObject:deviceTokens forKey:JGJDevicePushToken];

    [UMessage registerDeviceToken:deviceToken];
    if (![NSString isEmpty:deviceTokens]&&JLGisLoginBool) {
        
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
               [JLGHttpRequest_AFN PostWithApi:@"jlsys/channelid" parameters:@{@"channel_id":deviceTokens,@"os":@"I",@"service_type":@"umeng"} success:^(id responseObject) {
                   
               }];
           
        });

        
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {

    [JGJSocketRequest closeSocket];
    [JGJHistoryText clean];
    
//    //是否进入聊天页面，锁屏后返回首页
//    [TYUserDefaults removeObjectForKey:JGJIsChatLockScreen];
    
    [self appDidisEnterBackground:@"1" responseBlock:nil];
    
}
// 当 DeviceToken 获取失败时，系统会回调此方法
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    TYLog(@"DeviceToken 获取失败，原因：%@",error);
//}

#pragma mark - 从后台进入前台，重新请求未关闭班组，获取为读数和信息
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
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
        
    }
    
    [TYUserDefaults setBool:NO forKey:JGJAppIsDidisEnterBackground];
    
    [TYUserDefaults synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self appDidisEnterBackground:@"1" responseBlock:nil];

    [TYUserDefaults setBool:YES forKey:JGJAppIsDidisEnterBackground];
    
    [TYUserDefaults synchronize];
}

#pragma mark - 进入后台告诉服务器，不要退logo的角标
- (void)appDidisEnterBackground:(NSString *)isEnterBackground responseBlock:(void(^)(id response))responseBlock {
    NSString *userUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([NSString isEmpty:userUid] || self.isUnCanReceiveChatMsg) {
        
        self.isUnCanReceiveChatMsg = NO;
        
        return;
    }
    
    TYLog(@"这里调用是否接受推送消息接口");
}

#pragma mark - 获取联系人
- (void)saveAddressBookContacts {
    //    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取手机通讯录
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [JGJAddressBookTool saveAddressBookContacts];
    }
}
#pragma mark - 监听网络状态
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
    if (![TYUserDefaults boolForKey:JGJ_Guanli_1_0_3_ClearCache]) {
        [JGJChatListTool deleteSqlite];
        [TYUserDefaults setBool:YES forKey:JGJ_Guanli_1_0_3_ClearCache];
        [TYUserDefaults synchronize];
    }
}
-(void)getStamp
{
    //    [JLGHttpRequest_AFN GetWithApi:@"http://doc.ex.yzgong.com/index.php?s=/10&page_id=467" parameters:nil success:^(id responseObject) {
    //
    //    }];
    
    [TYUserDefaults removeObjectForKey:@"userStamp"];
    
    [JLGHttpRequest_AFN GetWithApi:@"Jlsys/getServerTimestamp" parameters:nil success:^(id responseObject) {
        NSInteger timeStamp =  [[NSDate date] timeIntervalSince1970];
        NSString *diffValue = [NSString stringWithFormat:@"%f",[responseObject[@"server_time"] doubleValue] - timeStamp];
        [TYUserDefaults setObject:diffValue forKey:@"userStamp"];
    } failure:^(NSError *) {
        
        [TYUserDefaults setObject:@"0" forKey:@"userStamp"];
        
    }];
    
    
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
    
    NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
    
    NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
    
    NSString *location = [NSString stringWithFormat:@"%@,%@", lng,lat];
    
    if (![NSString isEmpty:adcode] && ![NSString isEmpty:lat] && ![NSString isEmpty:lng]) {
       
        NSDictionary *parameters = @{@"region" : adcode?:@"",
                                     
                                     @"location" : location?:@""
                                     };
        
        [JLGHttpRequest_AFN PostWithNapi:@"sys/common" parameters:parameters success:^(id responseObject) {
            
            
        }failure:^(NSError *error) {
            
            
        }];
        
    }
    
}

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

@end
