//
//  JGJMineSettingVc.m
//  mix
//
//  Created by jizhi on 16/6/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMineSettingVc.h"
#import "JGJWebAllSubViewController.h"
#import "JLGSendProjectTableViewCell.h"
#import "YZGRecordWorkNextVcTableViewCell.h"
#import "SDWebImageManager.h"
//友盟
//#import "UMSocialSnsService.h"
#import "AppDelegate+JLGThirdLib.h"
#import "UIImageView+WebCache.h"
#import "TYShowMessage.h"
#import "JLGCustomViewController.h"

#import "JGJClearCacheTableViewCell.h"
#import "JGJClearCache.h"

#import "JGJCustomButtonCell.h"

#import "JGJCustomPopView.h"

#import "JLGPickerView.h"

#import "TYFMDB.h"

#import "UITabBar+JGJTabBar.h"

#import "JGJCusActiveSheetView.h"

#import "JGJAccountManageVc.h"

#import "JGJMineSettingVc+WXLoginService.h"

#import "JGJDredgeWeChatServiceViewController.h"


#import "JGJReleAccountVc.h"

#import "JGJModifyUserTelVc.h"

#import <BaiduMobStatCodeless/BaiduMobStat.h>

@interface JGJMineSettingVc ()
<
//UMSocialUIDelegate, //分享代码注释代理
UIAlertViewDelegate,
JGJCustomButtonCellDelegate,
JLGPickerViewDelegate
>
{
    NSInteger _codeString;
}
@property (nonatomic,copy) NSArray *titlesArray;
@property (strong, nonatomic) JGJMineInfoFirstModel *mineInfoFirstModel;
@property (nonatomic,strong) NSMutableArray *workStateArray;
@property (nonatomic,strong) JLGPickerView *dataPicker;

@end

@implementation JGJMineSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
//    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[0];
//
//    JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[0];
//
//    mineInfoThirdModel.detailTitle = @"不再错过重要的信息";
    
    [self setLeftBatButtonItem];
    
}



- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    
    if (self.mineSettingVcBackBlock) {
        
        self.mineSettingVcBackBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self getWXStatus];
    //获取微信登录状态
    [self requestWxLogionStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.title = @"返回";
}

- (void)getWXStatus {
    
    [JLGHttpRequest_AFN PostWithNapi:@"wxchat/get-wx-status" parameters:nil success:^(id responseObject) {
        
        TYLog(@"getWXStatus = %@",responseObject);
        _codeString = [responseObject[@"status"] integerValue];
        JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[0];
        JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[0];
        if (_codeString == 0) {
            
            mineInfoThirdModel.detailTitle = @"不再错过重要的信息";
            
        }else {
            
            mineInfoThirdModel.detailTitle = @"已绑定";
        }
        
    } failure:^(NSError *error) {
        
        
    }];
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
    if (indexPath.section == self.mineInfoFirstModel.mineInfos.count - 1) {
        
        height = JLGisLoginBool ? 120.0 : CGFLOAT_MIN;
        
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[indexPath.section];
    JGJMineInfoThirdModel *mineInfoThirdModel = minInfoSecModel.mineInfos[indexPath.row];
    
    mineInfoThirdModel.is_unshow_detail_Flag = NO;
    
    JGJClearCacheTableViewCell *settingCell = [JGJClearCacheTableViewCell cellWithTableView:tableView];
    
    NSString *cacheSizeStr = [NSString stringWithFormat:@"%.0f",[[[JGJClearCache alloc] init] checkTmpSize]];
    
    mineInfoThirdModel.is_hidden_detail = NO;
    
    UITableViewCell *cell = nil;
    if (self.mineInfoFirstModel.mineInfos.count - 1 == indexPath.section) {
        JGJCustomButtonCell *callButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
        callButtonCell.delegate = self;
        JGJCustomButtonModel *customButtonModel = [[JGJCustomButtonModel alloc] init];
        customButtonModel.buttonTitle = @"退出账号";
        customButtonModel.isHidden = !JLGisLoginBool;
        customButtonModel.buttontype = JGJCustomCallButtonCell;
        customButtonModel.backColor = [UIColor whiteColor];
        customButtonModel.titleColor = AppFont333333Color;
        customButtonModel.layerColor = [UIColor whiteColor];;
        customButtonModel.isDefaulStyle = YES;
        callButtonCell.customButtonModel = customButtonModel;
        cell = callButtonCell;
    }else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            
//            mineInfoThirdModel.detailTitle = @"这里写绑定情况";
            
        }else if (indexPath.section == 4 && indexPath.row == 0) {
            
            if (TYIS_IPHONE_5_OR_LESS) {
                
                mineInfoThirdModel.detailTitle = [NSString stringWithFormat:@"缓存共%@M",cacheSizeStr];
                
            }else{
                
                if (TYIS_IPHONE_6P) {
                    
                    mineInfoThirdModel.detailTitle = [NSString stringWithFormat:@"包括聊聊和工友圈的消息、图片等缓存共%@M",cacheSizeStr];
                    
                }else {
                    
                    mineInfoThirdModel.detailTitle = [NSString stringWithFormat:@"包括消息，图片等缓存共%@M",cacheSizeStr];
                }
                
            }
            
        }else if (indexPath.section == 0 && indexPath.row == 1) {
    
            mineInfoThirdModel.detailTitle = self.myWorkZone.statusString;
            
        }else if (indexPath.section == 2 && indexPath.row == 0) {
            
            BOOL isBind = [self.userInfo.is_bind isEqualToString:@"1"];
            
            mineInfoThirdModel.is_unshow_detail_Flag = isBind;
            
            mineInfoThirdModel.is_hidden_detail = YES;
        }
        
        settingCell.lineView.hidden = minInfoSecModel.mineInfos.count - 1 == indexPath.row;
        
        settingCell.mineInfoThirdModel = mineInfoThirdModel;
        
        cell = settingCell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *detailVc = nil;
    switch (indexPath.section) {
        case 0:{
            
            [self openWXService];
            
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                
                //修改手机号
                [self modifyTel];
                
            }else if (indexPath.row == 1) {
                
                //绑定微信
                [self handleBindWX];
            }
            
        }
            break;
            
        case 2: {
            
            JGJMineInfoThirdModel *infoModel = [JGJMineInfoThirdModel new];
            
            JGJReleAccountVc *releAccountVc = [[JGJReleAccountVc alloc] init];
            
            JGJMineInfoSecModel *minInfoSecModel = self.mineInfoFirstModel.mineInfos[indexPath.section];
            
            JGJMineInfoThirdModel *oldInfoModel = minInfoSecModel.mineInfos[indexPath.row];
            
            infoModel.title = @"微信";
            
            infoModel.detailTitle = oldInfoModel.detailTitle;
            
            releAccountVc.infoModel = infoModel;
            
            detailVc = releAccountVc;
            
        }
            
            break;
            
        case 3: {
            
            if (indexPath.row == 0) {
                
                NSString *helperStr = [NSString stringWithFormat:@"%@help",JGJWebDiscoverURL];
                
                JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:helperStr];
                
                detailVc = webVc;
                
            }else if (indexPath.row == 1) {
//                my/about
                
                NSString *aboutMe = [NSString stringWithFormat:@"%@my/about",JGJWebDiscoverURL];
                
                JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:aboutMe];
                
                detailVc = webVc;
                
            }else if (indexPath.row == 2) {
                
                 NSString *contactMe = [NSString stringWithFormat:@"%@my/contact",JGJWebDiscoverURL];
                
                JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:contactMe];
                
                detailVc = webVc;
                
            }
            
        }

            break;
            
        case 4:{
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self CleanCache];
            
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 开通微信服务
- (void)openWXService {
    
    JGJDredgeWeChatServiceViewController *dreVC = [[JGJDredgeWeChatServiceViewController alloc] init];
    dreVC.status = _codeString;
    [self.navigationController pushViewController:dreVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0;
}

-(void)handleLogout{
    
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/logout" parameters:nil success:^(id responseObject) {
        [weakSelf changeLoginStatus]; //退出登录调用一次webView刷新页面
        [TYUserDefaults setObject:@(0) forKey:JGJInfoVer];
        [weakSelf cleanCacheAndCookie];
        JLGExitLogin
        
        [[BaiduMobStat defaultStat] setUserId:nil];
        
    }];
    
//    [self handleLogoutClearUnReadNum];//退出清楚未读数
    //不管失败还是成功都直接退出
    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
    
    UIViewController *backVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    [changeToVc setValue:backVc forKey:@"backVc"];
    [self.navigationController pushViewController:changeToVc animated:YES];
    
    
    
//    JLGCustomViewController *cusNav = (JLGCustomViewController *)self.navigationController;
//    UITabBarController *tabBarVc = (UITabBarController * )cusNav.viewControllers[0];
//    HomeVC *homeVC = tabBarVc.viewControllers[0];
//    [tabBarVc setSelectedViewController:homeVC];
}

#pragma mark - JGJCustomButtonCellDelegate
-(void)customButtonCell:(JGJCustomButtonCell *)cell ButtonCellType:(JGJCustomButtonCellType)buttonCellType {
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"退出后不会删除任何历史数据，下次登录依然可以使用本账号。";
    desModel.leftTilte = @"取消";
    desModel.rightTilte = @"退出登录";
    desModel.lineSapcing = 5.0;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [weakSelf handleLogout];
        
    };
}

#pragma mark - 退出刷新webView
- (void)changeLoginStatus {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"JGJTabBarViewController")]) {
            UITabBarController *tabBarVc = (UITabBarController *)obj;
            [tabBarVc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
//                    JGJWebAllSubViewController *webView = (JGJWebAllSubViewController *)obj;
//                    [webView loadWebView];
                }
            }];
            *stop = YES;
        }
    }];
}
#pragma mark - 退出清楚未读数
- (void)handleLogoutClearUnReadNum {
    if (self.navigationController.viewControllers.count < 2) {
        return;
    }
    UITabBarController *tabVc= self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    
    if ([tabVc isKindOfClass:NSClassFromString(@"UITabBarController")]) {
    
        UITabBarItem * workItem=[tabVc.tabBar.items objectAtIndex:0];
        
        UITabBarItem * chatItem=[tabVc.tabBar.items objectAtIndex:1];
        
        workItem.badgeValue = nil;
        
        chatItem.badgeValue = nil;
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        [tabVc.tabBar hideBadgeOnItemIndex:0];
        
        [tabVc.tabBar hideBadgeOnItemIndex:1];
        
    }
    
}

- (NSArray *)titlesArray
{
    if (!_titlesArray) {
        _titlesArray = @[@"邀请朋友",@"清除缓存",@"关于我们"];
    }
    return _titlesArray;
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

- (void)CleanCache {

//    NSString *CacheStr = [NSString stringWithFormat:@"%f",[[[JGJClearCache alloc]init] checkTmpSize]];
//    CacheStr = [CacheStr substringToIndex:5];
//    
//    
//    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"已扫描的%@M缓存",CacheStr] message:@"请确认是否清除" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"不了", nil];
//    aler.tag = 110;
//    [aler show];
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"你确定要清除缓存吗?";
    desModel.contentViewHeight = 140;
    desModel.popTextAlignment = NSTextAlignmentCenter;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [JGJClearCache clearTmpPicsData];
        [weakSelf.tableView reloadData];
        [TYShowMessage showSuccess:@"缓存已清除"];
    };

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            [TYLoadingHub showLoadingWithMessage:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                [JGJClearCache clearTmpPicsData];
                [self.tableView reloadData];
                [TYLoadingHub hideLoadingView];
                    

            });
//            [JGJClearCache clearTmpPics];

        }
            break;
        case 1:
            
            break;

        default:
            break;
    }


}

- (JGJMineInfoFirstModel *)mineInfoFirstModel {
    if (!_mineInfoFirstModel) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"jgjMineSettingInfo" ofType:@"plist"];
        NSDictionary *mineInfoDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        _mineInfoFirstModel = [JGJMineInfoFirstModel mj_objectWithKeyValues:mineInfoDic];
    }
    return _mineInfoFirstModel;
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

#pragma Mark - 身份选择
- (UIViewController * )goToSelectedRole {
    UIViewController *yzgSelectedRoleViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    yzgSelectedRoleViewController.view.tag = 1;//如果为1，说明是从首页present的
    
    return yzgSelectedRoleViewController;
}

#pragma mark - 修改手机号
- (void)modifyTel {
    
//    UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"modifyphone" bundle:nil] instantiateViewControllerWithIdentifier:@"modifiPhoneVc"];
//    
//    [self.navigationController pushViewController:changeToVc animated:YES];
    
    JGJModifyUserTelVc *modifyUserTelVc = [[JGJModifyUserTelVc alloc] init];
    
    [self.navigationController pushViewController:modifyUserTelVc animated:YES];
    
}


- (NSMutableArray *)workStateArray
{
    if (!_workStateArray) {
        _workStateArray = [[TYFMDB searchTable:TYFMDBWorkStatusName] mutableCopy];
    }
    return _workStateArray;
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

- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    NSArray *buttons = @[@"申请注销账号\n删除所有数据，恢复未登录状态", @"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            
            UIViewController *logoutVc = [[UIStoryboard storyboardWithName:@"JGJLogout" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJLogoutVc"];
            
            [weakSelf.navigationController pushViewController:logoutVc animated:YES];
           
        }
        
    }];
    
    [sheetView showView];
}

@end
