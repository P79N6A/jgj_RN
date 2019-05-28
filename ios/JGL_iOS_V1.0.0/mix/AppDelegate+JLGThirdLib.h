//
//  AppDelegate+JLGThirdLib.h
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  该类只配置第三方的平台

#import "JLGAppDelegate.h"
//分享代码注释
//#import "UMSocial.h"
#import "WXApi.h"

////友盟Key
////564408fee0f55ae7e1001b95,这个key暂时不知道是哪个帐号的
//#ifdef DEBUG
//#define UmengApp_KEY    @"5746636ae0f55ab3e1001d54"//测试用的
//#else
//#define UmengApp_KEY    @"573038ca67e58e4f51001ff0"//正式用的
//#endif

#define UmengApp_KEY    @"573038ca67e58e4f51001ff0"//正式用的

//Bugly
#define Bugly_APP_ID    @"900011887"
#define Bugly_APP_KEY   @"WKeirSefR3bOo6Qu"

//微信
#define WX_APP_ID       @"wx0d7055be43182b5e"
#define WX_APP_SECRET   @"d4624c36b6795d1d99dcf0547af5443d"

//百度统计key
#define BaiduStaApp_key @"31eee025e6"

//QQ
#define QQ_APP_ID       @"1105083100"//需要将这个ID转换成16进制设置url schemes,转换完以后为：QQ41DE3ADC
#define QQ_APP_KEY      @"b6BNP02I29aY42ew"

//JSPatch
#define JSPatchKey @"8ff2fca6f95e64a1"

//是否是本地测试
#define JSPatchLocalTest NO

//JSPatch
//#import <JSPatch/JSPatch.h>
//#import <JSPatch/JPEngine.h>

@interface JLGAppDelegate (JLGThirdLib)

+ (void)checkPatch;





@end
