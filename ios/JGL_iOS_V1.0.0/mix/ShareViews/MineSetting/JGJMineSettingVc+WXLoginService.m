//
//  JGJMineSettingVc+WXLoginService.m
//  mix
//
//  Created by yj on 2018/9/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMineSettingVc+WXLoginService.h"

#import "JGJCustomPopView.h"

#import "JLGAppDelegate.h"
#import "JGJDeviceTokenManager.h"

@interface JGJMineSettingVc () < WXApiDelegate>

@end

@implementation JGJMineSettingVc (WXLoginService)

- (void)requestWxLogionStatus {
    
    self.request = [JGJLoginUserInfoRequest new];
    
    self.request.os = @"I";
    
    self.request.role = JLGisMateBool?@"1":@"2";
    
    self.request.telph = [TYUserDefaults objectForKey:JLGPhone];
    
    [self requestBindStatus];
    
//    [TYNotificationCenter addObserver:self selector:@selector(wxBindpostNotification:) name:JGJWXBindpostNotification object:nil];
    
    TYWeakSelf(self);
    
    JLGAppDelegate *app = ((JLGAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    app.thirdAuthorLoginSuccessBlock = ^(JGJWeiXinuserInfo *wxUserInfo) {
        
        [weakself wxBindWithwxUserInfo:wxUserInfo];
        
    };
    
}

- (void)requestBindStatus {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    //微信绑定状态
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/getwechatbindInfo" parameters:parameters success:^(NSDictionary *responseObject) {
        [TYLoadingHub hideLoadingView];
        
        JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
        
        self.userInfo = userInfo;
        
        //显示绑定状态
        [self setLogionStatus];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 取消绑定
- (void)cancelBindStatus {
    
    self.request.online = nil;
    
    //正确的手机号处理的结果
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/unbindUnionid" parameters:nil success:^(NSDictionary *responseObject) {
        [TYLoadingHub hideLoadingView];
        
        JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
        
        self.userInfo = userInfo;
        
        [self setLogionStatus];
        
        [TYShowMessage showSuccess:@"微信绑定解除成功！"];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)wxBindWithwxUserInfo:(JGJWeiXinuserInfo *)wxUserInfo{
    
//    JGJWeiXinuserInfo *wxUserInfo = notify.object;
    
    TYLog(@"-------%@", wxUserInfo.unionid);
    
    [self bindTelVcWithWXUserInfo:wxUserInfo];
}

- (void)bindTelVcWithWXUserInfo:(JGJWeiXinuserInfo *)wxUserInfo{
    
    self.request.wechatid = wxUserInfo.unionid;
    
    self.request.online = @"1";
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/login" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
        
        NSDictionary *dic = [NSDictionary dictionary];
        [TYUserDefaults setObject:dic forKey:JLGLastRecordBillPeople];
        //保存状态
        [TYUserDefaults setObject:responseObject[JLGUserUid] forKey:JLGUserUid];
        [TYUserDefaults setBool:YES forKey:JLGLogin];
        
        if (![NSString isEmpty:userInfo.telephone]) {
            
            [TYUserDefaults setObject:userInfo.telephone forKey:JLGPhone];
        }
        
        [TYUserDefaults setObject:responseObject[JLGToken] forKey:JLGToken];
        [TYUserDefaults setObject:responseObject[JLGHeadPic] forKey:JLGHeadPic];
        
        //更新真实姓名的值
        [TYUserDefaults setBool:[responseObject[@"has_realname"] boolValue] forKey:JLGIsRealName];
        if (responseObject[JLGRealName]) {
            [TYUserDefaults setObject:responseObject[JLGRealName] forKey:JLGRealName];
        }else{
            [TYUserDefaults setObject:nil forKey:JLGRealName];
        }
        
        MyWorkZone *workZone = [MyWorkZone mj_objectWithKeyValues:responseObject];
                
        if (![NSString isEmpty:workZone.realname]) {
            
            [TYUserDefaults setObject:workZone.realname forKey:JGJUserName];
            
        }else if (![NSString isEmpty:workZone.user_name]) {
            
            [TYUserDefaults setObject:workZone.user_name forKey:JGJUserName];
        }
        
        //确定当前身份
        
        if (workZone.is_info) {
            
            if (JLGisLeaderBool) {
                
                [TYUserDefaults setBool:NO forKey:JLGMateIsInfo];
                
                [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
                
            }else{
                
                [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
                
                [TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
            }
        }
        
        NSString *channelID = [TYUserDefaults objectForKey:JGJDevicePushToken];
        if (![NSString isEmpty:channelID]) {
            //延迟的原因主要是需要cookie重置
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //上传channelID
                [JGJDeviceTokenManager postDeviceToken:channelID];
            });
        }
        
        //如果有权限，直接赋权限,并且跳转到对应的权限界面
        if ([responseObject[@"is_info"] integerValue] == 1) {
            
            //设置权限
            NSInteger roleNum = [responseObject[@"double_info"] integerValue];
            if (roleNum == 1) {
                [TYUserDefaults setBool:NO forKey:JLGisLeader];
                [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
                [TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
            }else if (roleNum == 2){
                [TYUserDefaults setBool:YES forKey:JLGisLeader];
                [TYUserDefaults setBool:NO forKey:JLGMateIsInfo];
                [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
            }else{//保持当前的状态
                [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
                [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
            }
            
        }else{
            [TYUserDefaults synchronize];
            
        }
        
        [TYUserDefaults synchronize];
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        
        [self requestBindStatus];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark - 绑定微信
- (void)handleBindWX {
    
    BOOL isBind = [self.userInfo.is_bind isEqualToString:@"1"];
    
    if (isBind) {
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = @"确定要解除绑定的微信账号？";
        desModel.leftTilte = @"取消";
        desModel.rightTilte = @"确定";
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.messageLable.textAlignment = NSTextAlignmentCenter;
        
        __weak typeof(self) weakSelf = self;
        
        alertView.onOkBlock = ^{
            
            [weakSelf cancelBindStatus];
            
        };
        
    }else {
        
        //        未绑定 跳转到授权页面
        
        [self weChatLogin];
        
    }
    
}

-(void)weChatLogin {
    
    if ([WXApi isWXAppInstalled]) {
        
        //    方法二：手机没有安装微信也可以使用，推荐使用这个
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        
        req.scope = @"snsapi_userinfo";
        
        req.state = AuthorLogin;
        
        [WXApi sendAuthReq:req viewController:self delegate:self];
        
    } else {
        
        [TYShowMessage showPlaint:@"未检测到“微信”应用，请通过手机号登录"];
        
    }
    
}

- (void)setLogionStatus {
    
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[2];
    
    JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[0];
    
    mineInfoThirdModel.detailTitle = [self.userInfo.is_bind isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
    
    [self.tableView reloadData];
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}


@end
