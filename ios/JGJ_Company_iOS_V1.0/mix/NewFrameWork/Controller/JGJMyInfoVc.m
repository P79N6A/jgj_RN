//
//  JGJMyInfoVc.m
//  mix
//
//  Created by yj on 17/2/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMyInfoVc.h"
#import "JGJClearCacheTableViewCell.h"
#import "JGJWebAllSubViewController.h"
#import "JLGAuthenticationViewController.h"
#import "JGJCreateGroupVc.h"
#import "NSString+Extend.h"
@interface JGJMyInfoVc ()
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JGJMyInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.title = @"个人资料";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];//设置颜色
    [self loadNetWorkData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mineInfoFirstModel.mineInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[section];
    return minInfoSecModel.mineInfos.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50.0;
    if(self.myWorkZone.verified != 2 && indexPath.section == 1){
        height = 70.0;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJClearCacheTableViewCell *settingCell = [JGJClearCacheTableViewCell cellWithTableView:tableView];
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[indexPath.section];
    JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[indexPath.row];
    settingCell.lineView.hidden = minInfoSecModel.mineInfos.count - 1 == indexPath.row;
    mineInfoThirdModel.isShowQrcode = NO;
    mineInfoThirdModel.isShowRemark = NO;
    mineInfoThirdModel.remark = @"";
    if (indexPath.section == self.mineInfoFirstModel.mineInfos.count - 1) {
        mineInfoThirdModel.isShowQrcode = YES;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        mineInfoThirdModel.detailTitle = JLGisLoginBool ? self.myWorkZone.verifiedString: @"立即认证";
        mineInfoThirdModel.isShowRemark = YES;
        mineInfoThirdModel.remark = self.myWorkZone.verified != 2  ? @"通过实名认证可获得更多人的信任" : @"";
    }
    settingCell.mineInfoThirdModel = mineInfoThirdModel;
    return settingCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //项目经验，实名认证
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (![self checkIsInfo]) {
            return;
        }
    }
    UIViewController *detailVc = nil;
    switch (indexPath.section) {
        case 0:{
            [self skipWebTypeMineInfo];
        }
            break;
        case 1: {
            detailVc = [self goToAuthenticationWithVc:self];

        }
            break;
            
        case 2:{
            [self handelGenerateQrcodeAction];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 10.0;
    return height;
}

- (JGJMineInfoFirstModel *)mineInfoFirstModel {
    if (!_mineInfoFirstModel) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"jgjMyBaseInfo" ofType:@"plist"];
        NSDictionary *mineInfoDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _mineInfoFirstModel = [JGJMineInfoFirstModel mj_objectWithKeyValues:mineInfoDic];
    }
    return _mineInfoFirstModel;
}

- (BOOL)checkIsInfo{
    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
    
    if (![self checkIsLogin]) {
        return NO;
    }
    
    SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
    IMP infoImp = [rootNavVc methodForSelector:checkIsInfo];
    BOOL (*infoFunc)(id, SEL) = (void *)infoImp;
    if (!infoFunc(rootNavVc, checkIsInfo)) {
        return NO;
    }
    
    return YES;
}



-(BOOL)checkIsLogin{
    //先设置返回为NO
    [self.navigationController setValue:@(NO) forKey:@"loginBackGoToRootVc"];
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        //如果登录了，恢复状态
        [self.navigationController setValue:@(YES) forKey:@"loginBackGoToRootVc"];
        return YES;
    }
}



- (void)skipToLogin{
    if (JLGLoginBool) {
        [self skipWebTypeMineInfo]; //登录点击头像进入我的页面
        return;
    }
    
    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    
    [changeToVc setValue:@NO forKey:@"goToRootVc"];
    [self.navigationController pushViewController:changeToVc animated:YES];
}

#pragma mark - 进入我的页面
- (void)skipWebTypeMineInfo {
    if (![self checkIsInfo]) {
        return;
    }
    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
    JGJWebAllSubViewController *webViewController;//进入网页界面
    webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMineInfo];
    if (webViewController) {
        [rootNavVc pushViewController:webViewController animated:YES];
    }
}

#pragma mark - 实名认证
- (UIViewController *)goToAuthenticationWithVc:(UIViewController *)Vc{
    JLGAuthenticationViewController *authenticationVc= [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"authentication"];
    
    NSMutableDictionary *responseObject = [NSMutableDictionary dictionary];
    responseObject[@"verified"] = @(self.myWorkZone.verified);
    responseObject[@"realname"] = self.myWorkZone.realname;
    responseObject[@"icno"] = self.myWorkZone.icno;

    authenticationVc.responseObject = responseObject;
    
    return authenticationVc;
}

- (void)handelGenerateQrcodeAction {
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    NSString *myName = [TYUserDefaults objectForKey:JGJUserName];
    NSString *myHeadPic = [TYUserDefaults objectForKey:JLGHeadPic];
    JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
    JGJMyWorkCircleProListModel *workProListModel = [JGJMyWorkCircleProListModel new];
    workProListModel.team_name = nil;
    workProListModel.group_name = myName;
    workProListModel.group_id = myUid;
    workProListModel.team_id = nil;
    if (![NSString isEmpty:myHeadPic]) {
         workProListModel.members_head_pic = @[myHeadPic];
    }
    workProListModel.class_type = @"addFriend";
    joinGroupVc.workProListModel = workProListModel;
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

- (void )loadNetWorkData{

    [JLGHttpRequest_AFN PostWithApi:@"jlwork/myzone" parameters:nil success:^(id responseObject) {

        self.myWorkZone  = [MyWorkZone mj_objectWithKeyValues:responseObject];
        if (![NSString isEmpty:self.myWorkZone.headpic]) {
            [TYUserDefaults setObject:self.myWorkZone.headpic forKey:JLGHeadPic];
            [TYUserDefaults synchronize];
        }
    } failure:^(NSError *error) {
        self.myWorkZone  = nil;
    }];
}

- (void)setMyWorkZone:(MyWorkZone *)myWorkZone {
    _myWorkZone = myWorkZone;
    [self.tableView reloadData];

}

@end
