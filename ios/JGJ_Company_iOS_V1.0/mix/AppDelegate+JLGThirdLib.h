//
//  AppDelegate+JLGThirdLib.h
//  mix
//
//  Created by jizhi on 15/11/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  该类只配置第三方的平台

#import "JLGAppDelegate.h"

#import "WXApi.h"

//友盟Key
//564408fee0f55ae7e1001b95,这个key暂时不知道是哪个帐号的
//#ifdef DEBUG
//#define UmengApp_KEY    @"5746636ae0f55ab3e1001d54"//测试用的
//#else
//#define UmengApp_KEY    @"57eccabde0f55a2fc2003b01"//正式企业端用的
//#endif

#define UmengApp_KEY    @"57eccabde0f55a2fc2003b01"//正式企业端用的

//Bugly
#define Bugly_APP_ID    @"900054699"
#define Bugly_APP_KEY   @"H2EfrYsjuSqyCMak"

//微信
#define WX_APP_ID       @"wx4aef8d4d0753d388"
#define WX_APP_SECRET   @"9838e530da645c7fd4c435778160d32f"

//百度统计key
#define BaiduStaApp_key @"eaec4bc66a"
//QQ
//#define QQ_APP_ID       @"1105746648"//需要将这个ID转换成16进制设置url schemes,转换完以后为：QQ41e85ad8
//#define QQ_APP_KEY      @"FpbQydfBMy3ZXxwM"

#define QQ_APP_ID       @"1105764488"//需要将这个ID转换成16进制设置url schemes,转换完以后为：QQ41e8a088 和安卓用一样的
#define QQ_APP_KEY      @"onJIx4w3iHVh96c9"

//JSPatch//个人端:8ff2fca6f95e64a1 管理端:cd73521c449851c5
#define JSPatchKey      @"cd73521c449851c5"

//是否是本地测试
#define JSPatchLocalTest NO

//JSPatch
//#import <JSPatch/JSPatch.h>
//#import <JSPatch/JPEngine.h>

@interface JLGAppDelegate (JLGThirdLib)
+ (void)checkPatch;
@end
