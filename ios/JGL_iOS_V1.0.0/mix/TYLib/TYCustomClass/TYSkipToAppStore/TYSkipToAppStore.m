//
//  TYSkipToAppStore.m
//  TYSamples
//
//  Created by Tony on 2016/11/10.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYSkipToAppStore.h"
#import "TYSkipToAppStoreModel.h"


@interface TYSkipToAppStore ()

@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,copy) TYSkipToAppStoreModel *baseInfo;

@end

@implementation TYSkipToAppStore
static TYSkipToAppStore *_skipToAppStore;

+ (void)skipToAppStore:(UIViewController *)Vc appID:(NSString *)appID{
    [self skipToAppStore:Vc type:_skipToAppStore.skipType appID:appID];
}

+ (void)skipToAppStore:(UIViewController *)Vc type:(SkipToAppStoreType )skipType appID:(NSString *)appID{
    _skipToAppStore = [[TYSkipToAppStore alloc] init];
    
    _skipToAppStore.appID = appID;
    [_skipToAppStore skipToAppStore:Vc type:skipType];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //更新是否弹出
        self.showAfterUpdate = NO;
        
        //默认的天书
        self.showAgainAfterDays = 15;
        
        //默认的模式
        self.skipType = ToAppStoreTypeDefault;
        
        //默认的次数
        self.openAppCount = 20;
        
        //设置默认显示的内容
        self.showTitle = nil;
        
        self.showMessage = @"您的支持是我们最大的前进动力，您对我们还满意吗?";
        
        self.showRefuseStr = @"残忍滴拒绝";
        
        self.showAcceptStr = @"马上好评";
    }
    return self;
}

- (TYSkipToAppStoreModel *)baseInfo
{
    if (!_baseInfo) {
        _baseInfo = [[TYSkipToAppStoreModel alloc] init];
    }
    return _baseInfo;
}

- (void)skipToAppStore:(UIViewController *)Vc{
    [self skipToAppStore:Vc type:self.skipType];
}

- (void)skipToAppStore:(UIViewController *)Vc type:(SkipToAppStoreType )skipType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (skipType == ToAppStoreTypeOpenConut) {//通过次数来判断
        if (self.baseInfo.openAppCount >= self.openAppCount) {
            //清零
            [userDefaults setObject:@(0) forKey:KToAppStore_OpenAppCount];
            
            [self alertUserCommentView:Vc];
        }else{
            //增加一次
            [userDefaults setObject:@(self.baseInfo.openAppCount + 1) forKey:KToAppStore_OpenAppCount];
        }
    }else{//如果不是次数，就通过时间来判断
        //版本升级之后的处理,全部规则清空
        if (self.baseInfo.oldshortBuildVer && self.baseInfo.shortBuildVer > self.baseInfo.oldshortBuildVer) {
            [userDefaults removeObjectForKey:KToAppStore_OldDays];
            [userDefaults removeObjectForKey:KToAppStore_LocalBuildVer];
            [userDefaults removeObjectForKey:KToAppStore_OldChoose];
            
            //是否需要弹框
            if (self.showAfterUpdate) {
                [self alertUserCommentView:Vc];
            }
        } else if(self.baseInfo.dValueDays > self.showAgainAfterDays){
            //弹出以后，再经过一段时间弹出
            [self alertUserCommentView:Vc];
        }
    }
}

- (void)alertUserCommentView:(UIViewController *)Vc{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //当前Build版本比本地Build版本高
        if (self.baseInfo.shortBuildVer > self.baseInfo.oldshortBuildVer) {
            [userDefaults setObject:[NSString stringWithFormat:@"%f",self.baseInfo.shortBuildVer] forKey:KToAppStore_LocalBuildVer];
        }
        
        self.alertController = [UIAlertController alertControllerWithTitle:self.showTitle message:self.showMessage preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:self.showRefuseStr style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [userDefaults setObject:@"0" forKey:KToAppStore_OldChoose];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",@(self.baseInfo.nowDays)] forKey:KToAppStore_OldDays];
        }];
        
        UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:self.showAcceptStr style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            [userDefaults setObject:@"1" forKey:KToAppStore_OldChoose];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",@(self.baseInfo.nowDays)] forKey:KToAppStore_OldDays];
            
            NSString *appStoreStr = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",self.appID];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreStr]];
        }];
        
        [self.alertController addAction:refuseAction];
        [self.alertController addAction:acceptAction];
        
        [Vc presentViewController:self.alertController animated:YES completion:nil];
    }
}
@end
