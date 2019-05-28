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
//#import "UMSocialSnsService.h"

#import "AppDelegate+JLGThirdLib.h"
#import "UIImageView+WebCache.h"
#import "TYShowMessage.h"
//城市列表
#import "TLCityPickerController.h"
#import "JLGCustomViewController.h"

#import "JGJHelpCenterVC.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
#import "JGJClearCache.h"
#import "JGJMyInfoVc.h"

#import "UIButton+JGJUIButton.h"

#define MineRowHeight 40
@interface LeftMenuVC ()<UITableViewDataSource, UITableViewDelegate,JLGPickerViewDelegate, TLCityPickerDelegate,UIAlertViewDelegate>
{
    UIAlertView *_alter;
}
//@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topbgImageView;
@property (weak, nonatomic) IBOutlet UILabel *notLoginLabel;

@property (nonatomic,strong) JLGPickerView *dataPicker;
@property (nonatomic,strong) NSMutableArray *workStateArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *locationCityButton;
@property (weak, nonatomic) IBOutlet UIButton *unLoginCityButton;
@property (weak, nonatomic) IBOutlet UIView *whiteLineView;
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@property (weak, nonatomic) IBOutlet UIButton *myInfoButton;
@property (weak, nonatomic) IBOutlet UIView *containTopView;
@property (weak, nonatomic) IBOutlet UIView *containUnLoginView;
@property (nonatomic,strong) NSIndexPath *workStatusIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

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
    self.containUnLoginView.hidden = JLGisLoginBool;
    self.locationCityButton.hidden = !JLGisLoginBool;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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

- (void )loadNetWorkData{
    if (JLGisLoginBool) {//登录的时候获取信息
        self.emailBtn.hidden = NO;
        self.whiteLineView.hidden = NO;
        self.notLoginLabel.text = nil;
        [JLGHttpRequest_AFN PostWithApi:@"jlwork/myzone" parameters:nil success:^(NSDictionary *responseObject) {
            if (responseObject) {
                NSString *head_pic = @"";
                self.myWorkZone  = [MyWorkZone mj_objectWithKeyValues:responseObject];
                self.name.text = self.myWorkZone.realname;
                self.telephone.text = self.myWorkZone.telph;
                head_pic = self.myWorkZone.headpic;
                
                if (![NSString isEmpty:head_pic]) {
                    [TYUserDefaults setObject:head_pic forKey:JLGHeadPic];
                }else {
                    [TYUserDefaults removeObjectForKey:JLGHeadPic];
                }
                [TYUserDefaults synchronize];
                [self handleMyHeadShowWithMyWorkZone:self.myWorkZone];
                [self.tableView reloadData];
            }
            
            if ([NSString isEmpty:self.name.text]) { //没有姓名时图片左移和电话号码对齐
                self.emailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
            }
            
        }];
    }else{
        self.name.text = nil;
        self.telephone.text = nil;
        self.emailBtn.hidden = YES;
        self.notLoginLabel.text = @"未登录";
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"icon_mine_normal"] forState:UIControlStateNormal];
        [self.tableView reloadData];
        self.whiteLineView.hidden = YES;
    }
}

#pragma mark - 处理我的头像显示
- (void)handleMyHeadShowWithMyWorkZone:(MyWorkZone *)myWorkZone {
    UIColor *headBackColor = [NSString modelBackGroundColor:myWorkZone.realname];
    
    if (!JLGisLoginBool) {
        
        [self.headButton setTitle:@"" forState:UIControlStateNormal];
        [self.headButton setBackgroundImage:nil forState:UIControlStateNormal];
        
    } else if (!JLGIsRealNameBool ) {
        if (myWorkZone.telph.length >= 4) {
            NSString *telph = [myWorkZone.telph substringWithRange:NSMakeRange(myWorkZone.telph.length - 4, 4)];
            [self.headButton setTitle:telph forState:UIControlStateNormal];
            [self.headButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }else {
        [self.headButton setMemberPicButtonWithHeadPicStr:myWorkZone.headpic memberName:myWorkZone.realname memberPicBackColor:headBackColor];
    }
}

- (void)commonSet {
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMineInfo:)];
    [self.containTopView addGestureRecognizer:tapGesture];
    [self.myInfoButton setEnlargeEdgeWithTop:50 right:0 bottom:0 left:50];
    NSString *locationCity = [TYUserDefaults objectForKey:JLGCityName];
    if ([NSString isEmpty:locationCity]) {
        [self.locationCityButton setTitle:@"未定位" forState:UIControlStateNormal];
        [self.unLoginCityButton setTitle:@"未定位" forState:UIControlStateNormal];
    }else {
        [self.locationCityButton setTitle:locationCity forState:UIControlStateNormal];
        [self.unLoginCityButton setTitle:locationCity forState:UIControlStateNormal];
    }
    self.topbgImageView.image = [UIImage imageNamed: self.imageName];
    self.name.font = [UIFont systemFontOfSize:AppFont36Size];
    self.name.textColor = TYColorHex(0xFFFFFF);
    [self.telephone setFont:[UIFont systemFontOfSize:AppFont30Size]];
    self.telephone.textColor = TYColorHex(0xFFFFFF);
    [self.emailBtn setImage:[UIImage imageNamed:@"信封"] forState:UIControlStateNormal];
    [self.notLoginLabel setFont:[UIFont boldSystemFontOfSize:AppFont36Size]];
    self.notLoginLabel.textColor = TYColorHex(0xFFFFFF);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.headButton.layer setLayerCornerRadius:JGJCornerRadius];
    if (JLGisLoginBool) {
        if (![NSString isEmpty:[TYUserDefaults objectForKey:JLGRealName]]) {
            self.name.text = [TYUserDefaults objectForKey:JLGRealName]?:@"";
        }
        
        self.telephone.text = [TYUserDefaults objectForKey:JLGPhone]?:@"";
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
    NSInteger count = minInfoSecModel.mineInfos.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoCell" forIndexPath:indexPath];
    cell.mineInfoFirstModel = self.mineInfoFirstModel;
    [cell cellWithType:self.workType indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
    UIViewController *nextVc;//进入原生界面
//    //意见反馈需要验证
//    if (indexPath.section == 2 && indexPath.row == 1) {
//        if (![self checkIsInfo]) {
//            return;
//        }
//    }
    
    //我的故事/收藏要登录
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 1)) {
        if (![self checkIsLogin]) {
            return ;
        }
        if (![self checkIsRealName]) {
            return;
        }
    }

    JGJWebAllSubViewController *webViewController;//进入网页界面
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) { //我的动态
                NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
                NSString *url = [NSString stringWithFormat:@"dynamic/user?uid=%@",  myUid];
                webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeDynamic URL:url];
            }else if (indexPath.row == 1) { //我的收藏
                webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMyCollection];
            }
            
        }
            break;
        case 1:{
            webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypePersonScore];
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                nextVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJHelpCenterVC"];
            }else if (indexPath.row == 1) {
                if (![self checkIsLogin]) {
                    return ;
                }
                webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeComments];
            }

        }
            break;
        case 3:{
            [self showShare];
        }
            break;
        case 4:{
            JGJMineSettingVc *settingVc = [[JGJMineSettingVc alloc] init];
            settingVc.myWorkZone = self.myWorkZone;
            nextVc = settingVc;
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
        //[self.frostedViewController hideMenuViewController];
        [rootNavVc pushViewController:nextVc animated:YES];
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50.0;
    BOOL isVerified = NO;
    switch (self.workType) {
        case workCellType:{
            isVerified = self.myWorkZone.verified == 0;
        }
            break;
        case workLeaderCellType:{
            isVerified = self.myWorkLeaderZone.verified == 0;
        }
            break;
        default:
            break;
    }
    if (indexPath.section == 1) {
        return [self myScoreRowHeight]; //未登录我的积分不显示
    }

//    if (isVerified && indexPath.section == 2) {
//        height = 70.0;
//    }else if(!isVerified && indexPath.section == 2){
//        height = indexPath.row == 0 && JLGisLoginBool? 50 : 70;
//    }
    return height;
}

- (CGFloat)myScoreRowHeight {
   return JLGisLoginBool ? 50 : 0; //未登录我的积分不显示
//    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 10.0;
    if (section == 1) {
        height = [self myScoreHeaderHeight]; //未登录我的积分不显示
    }
    return height;
}

#pragma mark - 我的积分headerViewHeight
- (CGFloat)myScoreHeaderHeight {
    return JLGisLoginBool ? 10 : CGFLOAT_MIN; //未登录我的积分不显示
//    return CGFLOAT_MIN;
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

- (IBAction)helpCenterButtonPressed:(UIButton *)sender {
    UINavigationController *rootNavVc = (UINavigationController *)self.navigationController;
    JGJHelpCenterVC *helpCenterVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJHelpCenterVC"];
    //[self.frostedViewController hideMenuViewController];
    [rootNavVc pushViewController:helpCenterVC animated:YES];
}

- (IBAction)showCityListButtonPressed:(UIButton *)sender {
    [self showCityList];
}


#pragma Mark - 显示城市列表
- (void)showCityList {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.locationCityID = [TYUserDefaults objectForKey:JLGSelectCityNo];
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
    [self.navigationController pushViewController:cityPickerVC animated:YES];
    //    [self presentViewController:cityPickerVC animated:YES completion:nil];
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

#pragma Mark - 身份选择
- (UIViewController * )goToSelectedRole {
    UIViewController *yzgSelectedRoleViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    yzgSelectedRoleViewController.view.tag = 1;//如果为1，说明是从首页present的
    
    return yzgSelectedRoleViewController;
}

- (UIViewController *)goToWebMsgsVc{
    JGJWebMsgsViewController *webMsgsVc = [[JGJWebMsgsViewController alloc] init];
    return webMsgsVc;
}

#pragma mark - 我的资料按钮按下
- (IBAction)handleMyInfoButtonAction:(UIButton *)sender {
//    if (![self checkIsLogin]) {
//        return;
//    }
    
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

- (IBAction)handleHeadButtonAction:(UIButton *)sender {
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
    
    if ([finishArray lastObject]) {
        self.workStatusIndexPath = [finishArray lastObject];
    }

    [JLGHttpRequest_AFN PostWithApi:@"jlwork/workstatus" parameters:workStatusDic success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        self.myWorkZone.work_staus = [finishDic[@"id"]integerValue];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
//        [TYShowMessage showError:@"更改工作状态失败"];
    }];
}

#pragma mark - TLCityPickerDelegate 选中城市
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [self.locationCityButton setTitle:city.cityName forState:UIControlStateNormal];
    [self.unLoginCityButton setTitle:city.cityName forState:UIControlStateNormal];
    [TYUserDefaults setObject:city.cityID forKey:JLGSelectCityNo];
    [TYUserDefaults setObject:city.cityName forKey:JLGSelectCityName];
    [TYUserDefaults synchronize];
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController{
    //    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
    //    }];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
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
            [self.unLoginCityButton setTitle:[TYUserDefaults objectForKey:JLGCityName] forState:UIControlStateNormal];
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
    if (alertView.tag == 110) {
        if (buttonIndex == 1) {
            [JGJClearCache clearTmpPicsData];
        }
        
    }else{
    if (buttonIndex == 1) {
        NSString *cityNo   = [TYUserDefaults objectForKey:JLGCityNo];
        NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
        
        //显示切换城市
        [self.locationCityButton setTitle:cityName forState:UIControlStateNormal];
        [self.unLoginCityButton setTitle:cityName forState:UIControlStateNormal];
        //切换城市
        [TYUserDefaults setObject:cityNo forKey:JLGSelectCityNo];
        [TYUserDefaults setObject:cityName forKey:JLGSelectCityName];
        [TYUserDefaults synchronize];
    }
    
    _alter.delegate = nil;
    _alter = nil;
    }
}

- (void)handleTapMineInfo:(UITapGestureRecognizer *)tap {
    [self skipWebTypeMineInfo];
}

#pragma mark - 懒加载
- (JLGPickerView *)dataPicker
{
    if (!_dataPicker) {
        _dataPicker = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _dataPicker.delegate = self;
        _dataPicker.enterType = EnterPickerViewTypeLeftMenu;
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

#pragma mark - 分享
- (void )showShare{
//    NSString *content = @"这里有全国各地的工作机会。能快速找到好工作，随时随地记工天，千万工友都在用";
//
//    NSString *picUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,@"media/default_imgs/logo.jpg"];
//    NSString *title = @"【吉工家】我正在用招工找活、记工记账神器！快来看看";
//    NSString *url = @"http://m.yzgong.com/download";
//    NSString *shareText = [NSString stringWithFormat:@"%@ %@ \n%@",title,content,url];
//
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    //分享的图片
//    __block UIImage *shareImage;
//    NSURL *shareImageURL = [NSURL URLWithString:picUrl];
//
//    [manager downloadImageWithURL:shareImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        //取图片
//        if (image) {
//            shareImage = image;
//        }else{
//            shareImage = [UIImage imageNamed:@"Logo"];
//        }
//
//        //调用快速分享接口
//        [UMSocialSnsService presentSnsIconSheetView:self.navigationController appKey:UmengApp_KEY shareText:nil shareImage:shareImage shareToSnsNames:nil delegate:self];
//
//        //微信
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = content;
//
//        //朋友圈
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//        NSString *wechatdes = [NSString stringWithFormat:@"%@%@",title,content];
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = wechatdes;
//        //        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = desc;
//
//        //QQ
//        [UMSocialData defaultData].extConfig.qqData.url = url;
//        [UMSocialData defaultData].extConfig.qqData.title = title;
//        [UMSocialData defaultData].extConfig.qqData.shareText = content;
//
//        //分享到Qzone内容
//        [UMSocialData defaultData].extConfig.qzoneData.url = url;
//        [UMSocialData defaultData].extConfig.qzoneData.title = title;
//        [UMSocialData defaultData].extConfig.qzoneData.shareText = content;
//    }];
}


@end
