//
//  AppDelegate+JLGThirdLib.m
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "AppDelegate+JLGThirdLib.h"
#import "NSDate+Extend.h"

//数据库
#import "TYFMDB.h"
#import "TYSaveFilePath.h"

//友盟
//分享代码注释
//#import "UMSocial.h"

#import <UMShare/UMShare.h>

#import <UMAnalytics/MobClick.h>

#import <UMCommon/UMCommon.h>

#import <UMCommonLog/UMCommonLogHeaders.h>

//分享代码注释
//#import "MobClick.h"


#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

//#import "UMSocialControllerService.h"

#import "NSDate+Extend.h"
#import "IQKeyboardManager.h"

//易找工URL
#define JGLURL @"http://www.yzgong.com"


#define TYBugly NO
#ifdef TYBugly
//TYBugly
#import <Bugly/Bugly.h>
#endif

//百度推送
#import "BPush.h"

//百度推送的Key
#define BPushKey   @"560PSG94ctCiny1cK0Tmav9Q"

//是否写日志文件
//#define TYWriteLog YES

@implementation JLGAppDelegate (JLGThirdLib)
+ (void)load{
    //拷贝数据库文件
    [self copySqlFile];
    
    //友盟的设置
    [self UMSocialConfig];
    
    //友盟统计
    [self umengTrack];
    
    //同步服务器数据
    [self SysServerData];
    
    //设置聊天界面是否需要判断已读
    [self setReadNeed];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
#ifdef TYBugly
    if (TYiOS7Later) {
        //Buyly的设置
        [self TYBuglyConfig];
    }
#endif
    
#ifdef TYWriteLog
    //    指定真机调试保存日志文件
    //    plist字段:Application supports iTunes file sharing
    UIDevice *device =[UIDevice currentDevice];
    
    if (![[device model] isEqualToString:@"iPad Simulator"]) {
        [self redirectNSLogToDocumentFolder];
    }
#endif
}

#ifdef TYWriteLog
+ (void)redirectNSLogToDocumentFolder{
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [TYUserDocumentPaths stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
#endif

#pragma mark - 拷贝数据库文件
+ (void)copySqlFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:TYDesFileNamePath]) { //不存在才拷贝
        [TYSaveFilePath copyFileAtPath:TYDesFileNamePath SrcFileName:TYSaveSrcFileNamePath];
    }
}

#pragma mark - 友盟

//友盟注册修改

+ (void)UMSocialConfig{
    
    // Override point for customization after application launch.
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    
    [UMConfigure setLogEnabled:NO];
    
    [UMConfigure initWithAppkey:UmengApp_KEY channel:@"App Store"];
    
    [MobClick setScenarioType:E_UM_GAME|E_UM_DPLUS];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_ID appSecret:WX_APP_SECRET redirectURL:JGLURL];
    

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APP_ID/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#ifdef TYBugly
#pragma mark - TYBugly配置
+ (void)TYBuglyConfig{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BuglyConfig * config = [[BuglyConfig alloc] init];

#if DEBUG
        config.debugMode = YES;
#endif
        config.reportLogLevel = BuglyLogLevelWarn;

//        卡顿监控
//        config.blockMonitorEnable = YES;
//        config.blockMonitorTimeout = 1.5;
        
        //AppStore
        config.channel = @"AppStore";
        
        [Bugly startWithAppId:Bugly_APP_ID config:config];

        [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [NSProcessInfo processInfo].hostName]];
        
        [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"App"];
    });
}
#endif

//友盟统计

//友盟注册修改

+ (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
////    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:@"573038ca67e58e4f51001ff0" reportPolicy:(ReportPolicy) BATCH channelId:nil];
//    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
//    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick setSecret:UmengApp_KEY];
}

#pragma mark - 同步服务器数据
+ (void)SysServerData{
    NSDate *oldDate = [TYUserDefaults objectForKey:YZGGetSysServerDate];

//    测试代码
//    NSDate *oldDate = [NSDate dateFromString:@"20160731" withDateFormat:@"yyyyMMdd"];
//    NSDate *newDate = [NSDate dateFromString:@"20160801" withDateFormat:@"yyyyMMdd"];
    
    if(!oldDate || [NSDate getDaysFrom:oldDate withToDate:[NSDate date]] > 0)
    {//距离上次执行超过了1天以后才执行
        ;
        [TYUserDefaults setObject:[NSDate date] forKey:YZGGetSysServerDate];
        [TYUserDefaults synchronize];
        
        //获取热门城市
//        [self getHotCiyts];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //获取福利
            [self getWelfares];
            
            //获取工种
            [self getWorkTypes];
            
            //获取项目类型
            [self getProjects];
            
            //获取熟练度
            [self getWorkLevels];
        });
    }
}

+ (void)setReadNeed{
    [TYUserDefaults setBool:NO forKey:JLGReadNeed];
    [TYUserDefaults synchronize];
}

#pragma mark - 获取热门城市
+ (void)getHotCiyts{

//    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/cities" parameters:@{@"lable":@"hotcities"} success:^(NSArray *responseObject) {
//        
//        NSInteger arrayCount = responseObject.count;//获取的数据的数量
//        
//        [TYFMDB deleteAllByTableName:TYFMDBHotCityName];
//        
//        for (NSInteger index = 0;index < arrayCount; index++) {
//            
//            NSDictionary *data = responseObject[index];
//            NSMutableArray *newValueArray = [NSMutableArray array];
//            
//            NSArray *cityIDArray = @[@"id",@(index+1)];
//            NSArray *cityNameArray = @[@"city_name",data[@"city_name"]];
//            NSArray *cityCodeArray = @[@"city_code",data[@"city_code"]];
//            [newValueArray addObject:cityIDArray];
//            [newValueArray addObject:cityNameArray];
//            [newValueArray addObject:cityCodeArray];
//            
//            [TYFMDB addItemByTableName:TYFMDBHotCityName newValueArray:newValueArray];
//        }
//    }];
}

#pragma mark - 获取除了城市以外的所有数据
+ (void)getDataExceptCitys{
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"type":@"all"} success:^(NSArray *responseObject) {
        
        NSInteger arrayCount = responseObject.count;//获取的数据的数量
        
        [TYFMDB deleteAllByTableName:TYFMDBWorkTypeName];
        
        for (NSInteger index = 0;index < arrayCount; index++) {
            
            NSDictionary *data = responseObject[index];
            NSMutableArray *newValueArray = [NSMutableArray array];
            
            NSArray *cityIDArray = @[@"id",data[@"code"]];
            NSArray *cityNameArray = @[@"name",data[@"name"]];
            [newValueArray addObject:cityIDArray];
            [newValueArray addObject:cityNameArray];
            
            [TYFMDB addItemByTableName:TYFMDBWorkTypeName newValueArray:newValueArray];
        }
    }];
}

#pragma mark - 获取工种
+ (void)getWorkTypes{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id":@1} success:^(NSArray *responseObject) {
        
        NSInteger arrayCount = responseObject.count;//获取的数据的数量
        
        [TYFMDB deleteAllByTableName:TYFMDBWorkTypeName];
        
        for (NSInteger index = 0;index < arrayCount; index++) {
            
            NSDictionary *data = responseObject[index];
            NSMutableArray *newValueArray = [NSMutableArray array];
            
            NSArray *cityIDArray = @[@"id",data[@"code"]];
            NSArray *cityNameArray = @[@"name",data[@"name"]];
            [newValueArray addObject:cityIDArray];
            [newValueArray addObject:cityNameArray];
            
            [TYFMDB addItemByTableName:TYFMDBWorkTypeName newValueArray:newValueArray];
        }
    }];
}

#pragma mark - 项目类型
+ (void)getProjects{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id":@2} success:^(NSArray *responseObject) {
        
        NSInteger arrayCount = responseObject.count;//获取的数据的数量
        
        [TYFMDB deleteAllByTableName:TYFMDBProjectName];
        
        for (NSInteger index = 0;index < arrayCount; index++) {
            
            NSDictionary *data = responseObject[index];
            NSMutableArray *newValueArray = [NSMutableArray array];
            
            NSArray *cityIDArray = @[@"id",data[@"code"]];
            NSArray *cityNameArray = @[@"name",data[@"name"]];
            [newValueArray addObject:cityIDArray];
            [newValueArray addObject:cityNameArray];
            
            [TYFMDB addItemByTableName:TYFMDBProjectName newValueArray:newValueArray];
        }
    }];
}

#pragma mark - 获取熟练度
+ (void)getWorkLevels{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id":@3} success:^(NSArray *responseObject) {
        
        NSInteger arrayCount = responseObject.count;//获取的数据的数量
        
        [TYFMDB deleteAllByTableName:TYFMDBWorkLevelName];
        
        for (NSInteger index = 0;index < arrayCount; index++) {
            
            NSDictionary *data = responseObject[index];
            NSMutableArray *newValueArray = [NSMutableArray array];
            
            NSArray *cityIDArray = @[@"id",data[@"code"]];
            NSArray *cityNameArray = @[@"name",data[@"name"]];
            [newValueArray addObject:cityIDArray];
            [newValueArray addObject:cityNameArray];
            
            [TYFMDB addItemByTableName:TYFMDBWorkLevelName newValueArray:newValueArray];
        }
    }];
}

#pragma mark - 获取福利
+ (void)getWelfares{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id":@31} success:^(NSArray *responseObject) {
        
        NSInteger arrayCount = responseObject.count;//获取的数据的数量
        
        [TYFMDB deleteAllByTableName:TYFMDBWelfaresName];
        
        for (NSInteger index = 0;index < arrayCount; index++) {
            
            NSDictionary *data = responseObject[index];
            NSMutableArray *newValueArray = [NSMutableArray array];
            
            NSArray *cityIDArray = @[@"id",data[@"code"]];
            NSArray *cityNameArray = @[@"name",data[@"name"]];
            [newValueArray addObject:cityIDArray];
            [newValueArray addObject:cityNameArray];
            
            [TYFMDB addItemByTableName:TYFMDBWelfaresName newValueArray:newValueArray];
        }
    }];
}



@end
