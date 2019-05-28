//
//  TYSkipToAppStoreModel.m
//  TYSamples
//
//  Created by Tony on 2016/11/10.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYSkipToAppStoreModel.h"

@implementation TYSkipToAppStoreModel

- (instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //用户上次的选项
        self.oldChoose = [[userDefaults objectForKey:KToAppStore_OldChoose] intValue];
        
        //当前的Build版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        self.shortBuildVer = [[infoDic objectForKey:KToAppStore_ShortBuildVer] floatValue];
        
        //上次保存的Build版本号
        self.oldshortBuildVer = [[userDefaults objectForKey:KToAppStore_LocalBuildVer] intValue];
        
        //上次跳转到AppStore的天数
        self.oldToAppStoreDays = [[userDefaults objectForKey:KToAppStore_OldDays] intValue];
        
        //当前的天数
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        int oneDayTimeInterval = 24*60*60;
        self.nowDays = timeInterval / oneDayTimeInterval;
        
        //当前时间和上次跳转时间相差的天数
        if (self.oldToAppStoreDays) {
            self.dValueDays = self.nowDays - self.oldToAppStoreDays;
        }else{//不存在之前的跳转时间，就为0
            self.dValueDays = 0;
            [userDefaults setValue:@(self.nowDays) forKey:KToAppStore_OldDays];
            [userDefaults synchronize];
        }

        //打开app的次数
        self.openAppCount = [[userDefaults objectForKey:KToAppStore_OpenAppCount] intValue]?:1;
        
    }
    return self;
}

@end
