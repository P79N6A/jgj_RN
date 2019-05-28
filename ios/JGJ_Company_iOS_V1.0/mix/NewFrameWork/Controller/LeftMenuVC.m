//
//  LeftMenuVC.m
//  mix
//
//  Created by celion on 16/3/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "LeftMenuVC.h"
//#import "REFrostedViewController.h"

#import "TYFMDB.h"
#import "JLGPickerView.h"
#import "JGJMineSettingVc.h"
#import "SDWebImageManager.h"
#import "JGJWebMsgsViewController.h"
#import "JLGAuthenticationViewController.h"

//Web
#import "JGJAllWebView.h"

//友盟
#import "AppDelegate+JLGThirdLib.h"
#import "UIImageView+WebCache.h"
#import "TYShowMessage.h"
//城市列表
#import "TLCityPickerController.h"
#import "JLGCustomViewController.h"
#import "JGJHelpCenterVC.h"
#import "NSString+Extend.h"
#import "JLGSendProjectTableViewCell.h"
#import "UIButton+JGJUIButton.h"
#import "HomeVC.h"
#import "TYPhone.h"
#import "JGJClearCache.h"
#import "JGJMyInfoVc.h"
#import "UIButton+JGJUIButton.h"
#define MineRowHeight 55
@interface LeftMenuVC ()<UITableViewDataSource, UITableViewDelegate,JLGPickerViewDelegate, TLCityPickerDelegate,UIAlertViewDelegate,JLGSendProjectTableViewCellDelegate>
{
    UIAlertView *_alter;
}
//@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topbgImageView;
@property (weak, nonatomic) IBOutlet UILabel *notLoginLabel;

@property (nonatomic,strong) JLGPickerView *dataPicker;
@property (nonatomic,strong) NSMutableArray *workStateArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *locationCityButton;
@property (weak, nonatomic) IBOutlet UIView *contentCallView;

@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@property (weak, nonatomic) IBOutlet UIButton *myInfoButton;
@property (weak, nonatomic) IBOutlet UIView *containTopView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *headButton;

@end

@implementation LeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    
    [TYNotificationCenter addObserver:self selector:@selector(cityNoUp) name:JLGCityNoUp object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myInfoButton.hidden = !JLGisLoginBool;
    [self.tableView reloadData];
    [self loadNetWorkData];
    if (!JLGisLoginBool) {
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"icon_mine_normal"] forState:UIControlStateNormal];
    }
}
- (void)setWorkType:(SelectedWorkType)workType{
    _workType = workType;
    [self.tableView reloadData];
}
- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.name.text = _userName;
}
- (void )loadNetWorkData{
    if (JLGisLoginBool) {//登录的时候获取信息
        self.emailBtn.hidden = NO;
        self.contentCallView.hidden = NO;
        self.notLoginLabel.text = nil;
        [JLGHttpRequest_AFN PostWithApi:@"jlwork/myzone" parameters:nil success:^(NSDictionary *responseObject) {
            if (responseObject) {
                self.myWorkZone  = [MyWorkZone mj_objectWithKeyValues:responseObject];;
                self.name.text = self.myWorkZone.realname;
                [self.telButton setTitle:self.myWorkZone.telph forState:UIControlStateNormal];
                [self.tableView reloadData];
                
                if (![NSString isEmpty:self.myWorkZone.headpic]) {
                    [TYUserDefaults setObject:self.myWorkZone.headpic forKey:JLGHeadPic];
                }else {
                    [TYUserDefaults removeObjectForKey:JLGHeadPic];
                }
                if (![NSString isEmpty:self.myWorkZone.realname]) {
                    [TYUserDefaults setObject:self.myWorkZone.realname forKey:JLGRealName];
                    [TYUserDefaults setObject:@YES forKey:JLGIsRealName];
                }
                 [self handleMyHeadShowWithMyWorkZone:self.myWorkZone];
                [TYUserDefaults synchronize];
            }
        }];
    }else{
        self.name.text = nil;
        self.contentCallView.hidden = YES;
        self.emailBtn.hidden = YES;
        self.notLoginLabel.text = @"未登录";
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"icon_mine_normal"] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}
#pragma mark - 处理我的头像显示
- (void)handleMyHeadShowWithMyWorkZone:(MyWorkZone *)myWorkZone {
    UIColor *headBackColor = [NSString modelBackGroundColor:myWorkZone.realname];
    
    if (!JLGisLoginBool) {

        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        [self.headButton setBackgroundImage:nil forState:UIControlStateNormal];
        
    } else if (!JLGIsRealNameBool && myWorkZone.telph.length > 4) {
        NSString *telph = [myWorkZone.telph substringWithRange:NSMakeRange(myWorkZone.telph.length - 4, 4)];
        headBackColor = [NSString modelBackGroundColor:telph];
        
        [self.headButton setTitle:telph forState:UIControlStateNormal];
        [self.headButton setBackgroundImage:nil forState:UIControlStateNormal];
        
    }else {
        [self.headButton setMemberPicButtonWithHeadPicStr:myWorkZone.headpic memberName:myWorkZone.realname memberPicBackColor:headBackColor];
    }
}


- (void)commonSet {
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMineInfo:)];
    [self.containTopView addGestureRecognizer:tapGesture];

     [self.myInfoButton setEnlargeEdgeWithTop:50 right:0 bottom:0 left:50];
    [self.contentCallView.layer setLayerCornerRadius:TYGetViewH(self.contentCallView) / 2.0];
    self.topbgImageView.image = [UIImage imageNamed: @"nav_image_icon"];
    self.name.font = [UIFont systemFontOfSize:AppFont36Size];
    self.name.textColor = TYColorHex(0xFFFFFF);
    
    [self.notLoginLabel setFont:[UIFont boldSystemFontOfSize:AppFont36Size]];
    self.notLoginLabel.textColor = TYColorHex(0xFFFFFF);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    [self loadNetWorkData];
    

    if (JLGisLoginBool) {
        if (![NSString isEmpty:[TYUserDefaults objectForKey:JLGRealName]]) {
            self.name.text = [TYUserDefaults objectForKey:JLGRealName]?:@"";
        }
        
        [self.telButton setTitle:[TYUserDefaults objectForKey:JLGPhone]?:@"123" forState:UIControlStateNormal];
    }else{
        self.notLoginLabel.userInteractionEnabled = YES;
        //添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipToLogin)];
        [self.notLoginLabel addGestureRecognizer:singleTap];
    }
}

#pragma Mark - buttonAction
- (void)didClickedHeadImage:(UITapGestureRecognizer *)tapGesture {
    if (![self checkIsInfo]) {
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mineInfoFirstModel.mineInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[section];
    return minInfoSecModel.mineInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell" forIndexPath:indexPath];
    infoCell.mineInfoFirstModel = self.mineInfoFirstModel;
    [infoCell cellMyWorkZone:self.myWorkZone indexPath:indexPath];
    return infoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *nextVc;//进入原生界面
    
    //我的故事/收藏要登录
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0)) {
        if (![self checkIsLogin]) {
            return ;
        }
        if (![self checkIsRealName]) {
            return;
        }
    }
    
    JGJWebAllSubViewController *webViewController;//进入网页界面
    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
    switch (indexPath.section) {
        case 0:{
            NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
            NSString *url = [NSString stringWithFormat:@"dynamic/user?uid=%@",  myUid];
            webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeDynamic URL:url];
        }
            break;
        case 1:{
            webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMyCollection];
        }
            break;
        case 2:{
            nextVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJHelpCenterVC"];
            
        }
            break;
        case 3:{
            if (![self checkIsLogin]) {
                return ;
            }
            webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeComments];
        }
            break;
        case 4:{
            [self showShare];
        }
            break;
        case 5:{
            nextVc = [[JGJMineSettingVc alloc] init];
        }
            break;
        default:
            break;
    }
    if (webViewController) {
        //[self.frostedViewController hideMenuViewController];
        [rootNavVc pushViewController:webViewController animated:YES];
    }
    
    if (nextVc) {
        [rootNavVc pushViewController:nextVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = (self.myWorkZone.verified == 0 && indexPath.section == 0) ? 70 : 50;
//    if (!JLGisLoginBool && indexPath.section == 0) {
//        height = 70.0;
//    }
    return 50;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark - buttonAction

#pragma mark - 消息
- (IBAction)emailBtnClick:(UIButton *)sender {
    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeSysMsgList];//进入网页界面

    if (webViewController) {
        //[self.frostedViewController hideMenuViewController];
        UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
        [rootNavVc pushViewController:webViewController animated:YES];
    }
}

- (IBAction)showCityListButtonPressed:(UIButton *)sender {
    [self showCityList];
}

#pragma Mark - 显示城市列表
- (void)showCityList {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = [TYUserDefaults objectForKey:JLGCityNo];
    
    JLGCustomViewController *customVc = (JLGCustomViewController *)self.navigationController;
    cityPickerVC.leftButton = [customVc getLeftButton];
    
    //热门城市
    NSArray *hotCitysArray = [TYFMDB searchTable:TYFMDBHotCityName];
    NSMutableArray *hotCitysCodeArray = [NSMutableArray array];
    [hotCitysArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [hotCitysCodeArray addObject:[NSString stringWithFormat:@"%@",obj[@"city_code"]]];
    }];
    cityPickerVC.hotCitys = hotCitysCodeArray;
//    UINavigationController *rootNavVc = (UINavigationController *)self.frostedViewController.contentViewController;
//    [rootNavVc pushViewController:cityPickerVC animated:YES];
    [self presentViewController:cityPickerVC animated:YES completion:nil];
}



#pragma mark - 实名认证
- (UIViewController *)goToAuthenticationWith:(UIViewController *)Vc{
    
    JLGAuthenticationViewController *authenticationVc= [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"authentication"];
    
    NSMutableDictionary *responseObject = [NSMutableDictionary dictionary];
    responseObject[@"verified"] = @(self.myWorkZone.verified);
    responseObject[@"realname"] = self.myWorkZone.realname;
    responseObject[@"icno"] = self.myWorkZone.icno;
    authenticationVc.responseObject = responseObject;

    return authenticationVc;
}

- (UIViewController *)goToWebMsgsVc{
    JGJWebMsgsViewController *webMsgsVc = [[JGJWebMsgsViewController alloc] init];
    return webMsgsVc;
}

-(void)sendProjectCellBtnClick{
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/logout" parameters:nil success:^(id responseObject) {
        
        [self changeLoginStatus]; //退出状态调用一下webView
    }];
    JLGExitLogin;//一键清楚
    [self handleLogoutClearUnReadNum];//退出清楚未读数
    //不管失败还是成功都直接退出javascript:;
    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    
    UIViewController *backVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1];
    [changeToVc setValue:backVc forKey:@"backVc"];
    [self.navigationController pushViewController:changeToVc animated:YES];
//    JLGCustomViewController *cusNav = (JLGCustomViewController *)self.navigationController;
//    UITabBarController *tabBarVc = (UITabBarController * )cusNav.viewControllers[0];
//    HomeVC *homeVC = tabBarVc.viewControllers[0];
//    [tabBarVc setSelectedViewController:homeVC];
}

#pragma mark - 退出清楚未读数
- (void)handleLogoutClearUnReadNum {
    UITabBarItem * workItem=[self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem * chatItem=[self.tabBarController.tabBar.items objectAtIndex:1];
    workItem.badgeValue = nil;
    chatItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - 改变登录状态刷新webView
- (void)changeLoginStatus {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"JGJTabBarViewController")]) {
            UITabBarController *tabBarVc = (UITabBarController *)obj;
            [tabBarVc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
                    JGJWebAllSubViewController *webView = (JGJWebAllSubViewController *)obj;
                    [webView loadWebView];
                }
            }];
            *stop = YES;
        }
    }];
}

#pragma mark - 分享
- (void )showShare{

}

- (void)dealloc{
    [_dataPicker removeFromSuperview];
    [TYNotificationCenter removeObserver:self];
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

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)handleClickedHeadButtonAction:(UIButton *)sender {
    [self skipToLogin];
}

- (void)skipToLogin{
    if (JLGLoginBool) {
        JGJMyInfoVc *myBaseInfoVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMyInfoVc"];
        myBaseInfoVc.myWorkZone = self.myWorkZone;
        [self.navigationController pushViewController:myBaseInfoVc animated:YES];
        return;
    }
    
    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    
    [changeToVc setValue:@NO forKey:@"goToRootVc"];
    [self.navigationController pushViewController:changeToVc animated:YES];
}

#pragma Mark - JLGPickerViewDelegate
- (void)JLGPickerViewSelect:(NSArray *)finishArray {
    NSDictionary *finishDic = [finishArray firstObject];
    NSString *workStatus = [NSString stringWithFormat:@"%zd", [finishDic[@"id"]integerValue]];
    NSDictionary *workStatusDic = @{@"op" : @"m",
                                    @"work_status" : workStatus ?: [NSNull null]};
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/workstatus" parameters:workStatusDic success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        self.myWorkZone.work_staus = [finishDic[@"id"]integerValue];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [TYShowMessage showError:@"更改工作状态失败"];
    }];
}

#pragma mark - TLCityPickerDelegate 选中城市
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [self.locationCityButton setTitle:city.cityName forState:UIControlStateNormal];
    
    [TYUserDefaults setObject:city.cityID forKey:JLGSelectCityNo];
    [TYUserDefaults setObject:city.cityName forKey:JLGSelectCityName];
    [TYUserDefaults synchronize];
//    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController{
//    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 切换城市
- (void)cityNoUp{
    static dispatch_once_t cityNoUpToken;
    dispatch_once(&cityNoUpToken, ^{
        NSString *cityNo   = [TYUserDefaults objectForKey:JLGCityNo];
        NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
        NSString *selectCityNo   = [TYUserDefaults objectForKey:JLGSelectCityNo];
        
        if (!selectCityNo) {//没有选择过地址的情况
            [self.locationCityButton setTitle:[TYUserDefaults objectForKey:JLGCityName] forState:UIControlStateNormal];
            [TYUserDefaults setObject:cityNo forKey:JLGSelectCityNo];
            [TYUserDefaults setObject:cityName forKey:JLGSelectCityName];
            [TYUserDefaults synchronize];
            return;
        }else{
            TYLog(@"cityNo = %@ , selectCityNo = %@",cityNo,selectCityNo);
            if (![cityNo isEqualToString:selectCityNo]) {
                NSString *message = [NSString stringWithFormat:@"系统定位你现在在%@,是否切换到%@?",cityName,cityName];
                _alter = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换",nil];
                [_alter show];
            }
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [TYLoadingHub showLoadingWithMessage:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [JGJClearCache clearTmpPicsData];
                [self.tableView reloadData];
                [TYLoadingHub hideLoadingView];
            });

        }
    }else{
    if (buttonIndex == 1) {
        NSString *cityNo   = [TYUserDefaults objectForKey:JLGCityNo];
        NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
        
        //显示切换城市
        [self.locationCityButton setTitle:cityName forState:UIControlStateNormal];
        
        //切换城市
        [TYUserDefaults setObject:cityNo forKey:JLGSelectCityNo];
        [TYUserDefaults setObject:cityName forKey:JLGSelectCityName];
        [TYUserDefaults synchronize];
    }
    
    _alter.delegate = nil;
    _alter = nil;
    }
}
- (IBAction)handleMyInfoButtonPressed:(UIButton *)sender {
//   [self skipWebTypeMineInfo];
    JGJMyInfoVc *myBaseInfoVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMyInfoVc"];
    myBaseInfoVc.myWorkZone = self.myWorkZone;
    [self.navigationController pushViewController:myBaseInfoVc animated:YES];
}

#pragma mark - 进入我的页面
- (void)skipWebTypeMineInfo {
//    if (![self checkIsInfo]) {
//        return;
//    }
//    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
//    JGJWebAllSubViewController *webViewController;//进入网页界面
//    webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMineInfo];
//    if (webViewController) {
//        [rootNavVc pushViewController:webViewController animated:YES];
//    }
}

- (void)handleTapMineInfo:(UITapGestureRecognizer *)tap {
//    [self skipWebTypeMineInfo];
    if (![self checkIsLogin]) {
        return;
    }
    JGJMyInfoVc *myBaseInfoVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMyInfoVc"];
    myBaseInfoVc.myWorkZone = self.myWorkZone;
    [self.navigationController pushViewController:myBaseInfoVc animated:YES];
}

#pragma mark - 打电话按钮按下
- (IBAction)handleCallButtonPressed:(UIButton *)sender {
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return ;
    }
    
    SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
    imp = [self.navigationController methodForSelector:checkIsInfo];
    if (!func(self.navigationController, checkIsInfo)) {
        return ;
    }
    [TYPhone callPhoneByNum:self.myWorkZone.telph view:self.view];
}


#pragma mark - 懒加载
- (JLGPickerView *)dataPicker
{
    if (!_dataPicker) {
        _dataPicker = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _dataPicker.delegate = self;
    }
    return _dataPicker;
}

- (NSMutableArray *)workStateArray
{
    if (!_workStateArray) {
        _workStateArray = [[TYFMDB searchTable:TYFMDBWorkStatusName] mutableCopy];
    }
    return _workStateArray;
}

- (MyWorkZone *)myWorkZone
{
    if (!_myWorkZone) {
        _myWorkZone = [[MyWorkZone alloc] init];
    }
    return _myWorkZone;
}

- (MyWorkLeaderZone *)myWorkLeaderZone
{
    if (!_myWorkLeaderZone) {
        _myWorkLeaderZone = [[MyWorkLeaderZone alloc] init];
    }
    return _myWorkLeaderZone;
}

- (JGJMineInfoFirstModel *)mineInfoFirstModel {
    if (!_mineInfoFirstModel) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"jgjMineInfo" ofType:@"plist"];
        NSDictionary *mineInfoDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _mineInfoFirstModel = [JGJMineInfoFirstModel mj_objectWithKeyValues:mineInfoDic];
    }
    return _mineInfoFirstModel;
}
-(void)AlerView{

    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"确定要清除缓存吗？" message:@"请确认" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    aler.tag = 100;
    [aler show];


}

@end
