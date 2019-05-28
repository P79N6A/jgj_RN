//
//  JGJAccountManageVc.m
//  mix
//
//  Created by yj on 2018/3/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAccountManageVc.h"

#import "JGJClearCacheTableViewCell.h"

#import "JGJCustomPopView.h"

#import "JGJBindTelVc.h"

#import "JLGCustomViewController.h"

#import "JGJDeviceTokenManager.h"

typedef enum : NSUInteger {
    
    AccountManageModifyTelCellType,
    
    AccountManagebindWXCellType
    
} AccountManageCellType;

@interface JGJAccountManageVc () <UITableViewDataSource, UITableViewDelegate, WXApiDelegate>

@property (strong, nonatomic) NSMutableArray *infoModels;

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) JGJLoginUserInfoRequest *request; //登录请求

@property (strong, nonatomic) JGJLoginUserInfoModel *userInfo;

@end

@implementation JGJAccountManageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号管理";
    
    [self.view addSubview:self.tableView];
    
    [self requestBindStatus];
    
//    [TYNotificationCenter addObserver:self selector:@selector(wxBindpostNotification:) name:JGJWXBindpostNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.infoModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMineInfoThirdModel *infoModel = self.infoModels[indexPath.section];
    
    JGJClearCacheTableViewCell *cell = [JGJClearCacheTableViewCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    cell.mineInfoThirdModel = infoModel;
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    
    headerView.backgroundColor = AppFontf1f1f1Color;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] init];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case AccountManageModifyTelCellType:{
            
            [self modifyTel];
        }
            break;
            
        case AccountManagebindWXCellType:{
            
            [self bindWX];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 修改手机号
- (void)modifyTel {
    
    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"modifyphone" bundle:nil] instantiateViewControllerWithIdentifier:@"modifiPhoneVc"];
    
    [self.navigationController pushViewController:changeToVc animated:YES];
}

#pragma mark - 绑定微信
- (void)bindWX {
    
    BOOL isBind = [_userInfo.is_bind isEqualToString:@"1"];
    
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

- (void)requestBindStatus {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    //微信绑定状态
    [JLGHttpRequest_AFN PostWithApi:@"v2/user/getwechatbindInfo" parameters:parameters success:^(NSDictionary *responseObject) {
        [TYLoadingHub hideLoadingView];
        
        JGJLoginUserInfoModel *userInfo = [JGJLoginUserInfoModel mj_objectWithKeyValues:responseObject];
        
        self.userInfo = userInfo;
        
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
        
        [TYShowMessage showSuccess:@"微信绑定解除成功！"];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)wxBindpostNotification:(NSNotification *)notify {
    
    JGJWeiXinuserInfo *wxUserInfo = notify.object;
    
    TYLog(@"-------%@", wxUserInfo.unionid);
    
    [self bindTelVcWithWXUserInfo:wxUserInfo];
}

- (void)bindTelVcWithWXUserInfo:(JGJWeiXinuserInfo *)wxUserInfo{
    
//    //请求用户信息 是否绑定
//    JGJBindTelVc *bindTelVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBindTelVc"];
//
//    bindTelVc.wxUserInfo = wxUserInfo;
//
//    [self.navigationController pushViewController:bindTelVc animated:YES];
    
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

- (void)setUserInfo:(JGJLoginUserInfoModel *)userInfo {
    
    _userInfo = userInfo;
    
    JGJMineInfoThirdModel *secModel = self.infoModels.lastObject;
    
    secModel.detailTitle = [_userInfo.is_bind isEqualToString:@"1"] ? @"已绑定" : @"未绑定";
    
    [self.tableView reloadData];
    
}

- (NSMutableArray *)infoModels {
    
    if (!_infoModels) {
        
        _infoModels = [NSMutableArray new];
        
        NSArray *titles = @[@"修改手机号码", @"绑定微信"];
        
        NSArray *detailTitles = @[@"", @""];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJMineInfoThirdModel *secModel = [JGJMineInfoThirdModel new];
            
            secModel.title = titles[index];
            
            secModel.detailTitle = detailTitles[index];
            
            [_infoModels addObject:secModel];
        }
        
    }
    
    return _infoModels;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (JGJLoginUserInfoRequest *)request {
    
    if (!_request) {
        
        _request = [JGJLoginUserInfoRequest new];
        
        _request.os = @"I";
        
        _request.role = JLGisMateBool?@"1":@"2";
        
        _request.telph = [TYUserDefaults objectForKey:JLGPhone];
        
    }
    
    return _request;
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

@end

