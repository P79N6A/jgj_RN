//
//  JGLAppDelegate.m
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JGLAppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "TYBaseTool.h"

//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

//百度地图KEY
#define BMKMap_KEY      @"fgnPT0WBQ2R2x2sStKrrCFoj"

BMKMapManager* _mapManager;

typedef NS_ENUM(NSUInteger, SettingFail) {
    SettingFailDefault = 0,//默认的
    SettingFailNetWorking,//网络
    SettingFailLocation,//定位
    SettingFailRemote//推送
};

@interface JGLAppDelegate ()
<
    UIAlertViewDelegate,
    BMKGeneralDelegate,
    BMKLocationServiceDelegate
>
{
    BMKLocationService* _locService;
}
@property (nonatomic,assign) SettingFail failType;
@end

@implementation JGLAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置状态栏颜色
    [TYBaseTool setStatusBar];
    
    //设置NavigationVc
    [TYBaseTool setupNavGlobalTheme];
    
    //百度地图
    [self BMKMapConfig];
    
    //系统设置的判断
    [self SettingsConfig];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
    
    //进入前台就开始定位
    [self startLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 百度地图
- (void)BMKMapConfig{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMKMap_KEY generalDelegate:self];
    
    NSString *isSuccess = ret?@"成功":@"失败";
    TYLog(@"百度地图启动%@!",isSuccess);
    
    _locService = [[BMKLocationService alloc]init];
}

- (void)startLocation
{
    TYLog(@"进入普通定位态");
    [_locService startUserLocationService];
    if (!_locService.delegate) {
        _locService.delegate = self;
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationDegrees latitude  = userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = userLocation.location.coordinate.longitude;
    TYLog(@"didUpdateUserLocation \nlat %f,\nlong %f",latitude,longitude);
}

- (void)didStopLocatingUser
{
    TYLog(@"停止定位");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    TYLog(@"定位失败 错误号:%@",error);
    [self goToSettingsByType:SettingFailLocation];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 != iError) {
        TYLog(@"联网失败:onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 != iError) {
        TYLog(@"授权失败:onGetPermissionState %d",iError);
    }
}

#pragma mark - 判断是否开启系统服务
- (void)SettingsConfig{
    //是否开启定位
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [self goToSettingsByType:SettingFailLocation];
    }
    
    //是否开启推送
    BOOL isRemoteNotType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (isRemoteNotType == UIRemoteNotificationTypeNone) {
        TYLog(@"没有开启推送");
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
             case AFNetworkReachabilityStatusNotReachable:
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
    if (iOS8Later) {
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

@end