//
//  HomeVC.m
//  mix
//
//  Created by celion on 16/3/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "HomeVC.h"
#import "NSDate+Extend.h"
#import "UINavigationBar+Awesome.h"
#import "UIView+GNUtil.h"

//2.0
#import "JGJWorkCircleMiddleTableViewCell.h"
#import "JGJWorkCircleBottomCell.h"
#import "UIImageView+WebCache.h"
#import "JGJClosedGroupVC.h"
#import "JGJSynBillingManageVC.h"
#import "JGJWorkCircleDefaultProGroupCell.h"
#import "JGJQRCodeVc.h"
#import "JGJWebAllSubViewController.h"

#import "UIImage+Color.h"
#import "JGJChatRootVc.h"
#import "JGJChatRootCommonVc.h"
#import "JGJNewNotifyVC.h" //新通知
#import "JGJJoinGroupVc.h" //扫码加入
#import "JGJNewNotifyTool.h"
#import "NSString+Extend.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJSummerViewController.h"
#import "JGJWeatherDetailViewController.h"
//企业端1.0添加
#import "SDCycleScrollView.h"
#import "TYBaseTool.h"
#import "TYSkipToAppStore.h"
#import "JGJAddressBookTool.h"
#import "JGJNoneNetWorkReminderVc.h"

//1.0.3添加
#import "JGJUpdateVerPopView.h"

#import "JGJWebAllSubViewController.h"

#import "JGJChatMsgListModel.h"

//2.2.0添加
#import "JGJCusNavView.h"
#import "JGJKnowRepoVc.h"
#import "JGJWorkCircleMiddleTableViewCell.h"

#import "JGJWorkCircleDefaultProGroupCell.h"

//日志
#import "JGJChatListLogVc.h"

//通知
#import "JGJChatListNoticeVc.h"

//质量
#import "JGJChatListQualityVc.h"

//安全
#import "JGJChatListSafeVc.h"

//签到
#import "JGJChatListSignVc.h"

//导入聊天模型

#import "JGJChatRootVc.h"

#import "JGJChatListBaseVc.h"

#import "JGJCheckProListVc.h"

#import "PopoverView.h"
#import "JGJWorkReportViewController.h"
#import "JGJBuilderDiaryViewController.h"

#import "JGJTaskRootVc.h"

//测试

#import "JGJSureOrderListViewController.h"



#import "JGJQualityMsgListVc.h"
#import "JGJAdvertisementShowView.h"
#import "JLGAppDelegate.h"

#import <UMAnalytics/MobClick.h>

#import "JGJOrderDetailViewController.h"
#import "JGJChoicePeoViewController.h"
#import "JGJServiceStroeViewController.h"
#import "JGJWebLoginViewController.h"

#import "JGJProicloudRootVc.h"

#import "JGJGroupMangerTool.h"

#import "JGJWebUnSeniorPayVc.h"
#import "JGJPaySuccesViewController.h"

#import "JGJBuyCallPhone.h"

#import "JGJMyWebviewViewController.h"
#define JGJWorkCircleDefaultProGroupCellHeight 95
#define WorkCircleFirstCellHeight 285.0

//缓存最后一次项目数据用于网络差时没有闪烁
#define LastProListModel @"LastProListModel"

#import "JGJContactedListVc.h"


#import "JGJChatMsgDBManger+JGJIndexDB.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJCheckTheItemViewController.h"

#import "JGJQuaSafeCheckHomeVc.h"

#import "JGJQuaSafeHomeVc.h"


#import "JGJWorkReplyViewController.h"

#import "JLGCustomViewController.h"

#import "JGJCustomAlertView.h"
#import "UIImage+Cut.h"
#import "JGJHomePageMaskingView.h"

#import "JGJChatOffLineMsgTool.h"

#import "JGJTabBarViewController.h"

#import "JGJCheckGroupChatAllMemberVc.h"

#import "HomeVC+ServiceApiRequest.h"
#import "JGJCCToolObject.h"
#import "JGJDataManager.h"


typedef enum : NSUInteger {
    JGJWorkCircleMiddleCellType,
    JGJWorkCircleProGroupCellType
} JGJWorkCircleCellType;

static NSString *const calendarFormat = @"yyyy/MM/dd";

typedef void(^FreshMsgBlock)(void);

@interface HomeVC ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIAlertViewDelegate,
    JGJWorkCircleBottomCellDelegate,
    SDCycleScrollViewDelegate,
    JGJWorkCircleMiddleTableViewCellDelegate,
    JGJCusNavViewDelegate
>
{
    UIAlertView *_alter;
    BOOL _isHaveNewVersion;
}
@property (strong, nonatomic) MyWorkZone *myWorkZone;
@property (strong, nonatomic) MyWorkLeaderZone *myWorkLeaderZone;
@property (copy,   nonatomic) NSString *typeUrl;
@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, copy) NSArray <JGJADModel *>*adArr;
@property (nonatomic, strong) JGJWorkCircleBottomCell *bottomCell;
@property (nonatomic, assign) BOOL isUnRead;//是否有未读标记、单独加标记。YZGWorkDayModel经常被刷新
//@property (nonatomic, strong) JGJActiveGroupModel *activeGroupModel;//未关闭班组模型
@property (strong, nonatomic) JGJWorkCircleMiddleInfoModel *infoModel; //用于传入未读数

//广告图的比例
@property (nonatomic, assign) CGFloat ADImageRatio;

@property (nonatomic, strong) JGJWebAllSubViewController *tempWebVc;

@property (nonatomic, strong) JGJCusNavView *cusNavView;
@property (nonatomic, strong) JGJADModel *adBannerModel ;// banner弹窗广告

//是否告知服务器运行到前台
@property (nonatomic, assign) BOOL isForeground;

//刷新消息回调
@property (nonatomic, copy) FreshMsgBlock freshMsgBlock;

//是否需要刷新
@property (nonatomic, assign) BOOL isFresh;

@property (nonatomic, assign) UIStatusBarStyle lastStatusBarStyle;

//用于清除webView
@property (nonatomic, weak) JGJWebAllSubViewController *handleWebVc;

//当前页面接收到的reveive消息
@property (nonatomic, strong) JGJChatMsgListModel *receChatMsgModel;

@property (nonatomic, strong) JGJHomePageMaskingView *maskingView;

@end

@implementation HomeVC
//@synthesize activeGroupModel = _activeGroupModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JGJChatGetOffLineMsgInfo shareManager].vc = self;
    [self commonSet];
//    [self handleCheckUpdate];
//    [self JLGHttpRequestAlerShowBanner];
    [self setTableViewFooterView];

    
    //添加通知的监控
    [TYNotificationCenter addObserver:self selector:@selector(loginFail) name:JLGLoginFail object:nil];
    [TYNotificationCenter addObserver:self selector:@selector(clickUrl:) name:JLGcontentOpenUrl object:nil];

    [TYSkipToAppStore skipToAppStore:self appID:@"1163666807"];
    [self setNavBarImage:[UIImage imageNamed:@"barButtonItem_transparent"]];

    [self hanldeLoadH5Data];
    
    NSData *proListModelData = [TYUserDefaults objectForKey:LastProListModel];
    
    if (proListModelData) {
        
        self.proListModel = [NSKeyedUnarchiver unarchiveObjectWithData:proListModelData];;
    }
    
    self.lastStatusBarStyle = UIStatusBarStyleLightContent;
    
    
//    [self openLcoalAuthor];
    //连接socket,启动和进入首页
    [JGJSocketRequest shareSocketConnect];
    
//    [JGJChatOffLineMsgTool getOfflineMessageListCallBack:^(NSArray *msglist) {
//       
//        if (msglist.count > 0) {
//            
//            [JGJChatOffLineMsgTool getOfflineMessageListCallBack:nil];
//        }
//        
//    }];
    
    //注册通知
    
    [self registerNotifyCenter];
    
    TYWeakSelf(self);
    
    [self serviceTimestampSuccessBlock:^(id responseObject) {
        
        [weakself JLGHttpRequestBanner];
       
        [weakself getDynamicMsgNum:NO];
        
        [weakself handleCheckUpdate];
        
        [weakself JLGHttpRequestAlerShowBanner];
    }];
    
}



-(void)clickUrl:(NSNotification *)notification
{
    NSDictionary *urlDic = notification.object;
    JGJMyWebviewViewController *webVc = [[JGJMyWebviewViewController alloc]init];
    webVc.url = urlDic[@"url"];
    [self.navigationController pushViewController:webVc animated:YES];
    
}
- (void)setNavBarImage:(UIImage *)image{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置好友来源为项目添加
    [JGJDataManager sharedManager].addFromType = JGJFriendAddFromProject;
    
    __weak typeof(self) weakSelf = self;
    [JGJChatGetOffLineMsgInfo shareManager].getIndexListSuccess = ^(JGJMyWorkCircleProListModel *proListModel) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.proListModel = proListModel;
        });
        
    };
    [self networkingConfig];
    // 刷新首页消息
    [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
    
    [self setNavBarStyle];
    
    [self socketRequestReciveMessage]; //获取接受信息
    
//    if (self.cycleScrollView.imageURLStringsGroup.count == 0) {
//
//        [self JLGHttpRequestBanner];
//
//    }
    
    
//    未登录清除首页数据
    if (!JLGisLoginBool) {
        self.proListModel = nil;
        self.proListModel.unread_notice_count = @"0";
        self.proListModel.work_unread_msg_count = @"0";
        self.proListModel.chat_unread_msg_count = @"0";
    }
    
    if (!JLGisLoginBool) {
        
        self.proListModel = [JGJMyWorkCircleProListModel new];
        
        [self.tableView reloadData];
        return;
    }
    
    //主要取消知识库下载通知
    
    [TYNotificationCenter postNotificationName:@"DelDownFileNotification" object:nil];
    
    [self.view endEditing:YES];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜
}

- (void)viewDidAppear:(BOOL)animated {
 
    [super viewDidAppear:animated];
    
    if (self.handleWebVc) {
        
        [self.handleWebVc.webView removeFromSuperview];
        
        self.handleWebVc.webView = nil;
        
    }
    
}

- (void)hanldeLoadH5Data {
    
    //预加载H5 js、css
    NSURL *oriUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@404", JGJWebDiscoverURL]];
    JGJWebAllSubViewController *tempWebVc = [[JGJWebAllSubViewController alloc] initWithUrl:oriUrl];
    tempWebVc.view.frame = CGRectMake(0, 0, 5, 5);
    tempWebVc.view.hidden = YES;
    [self.view addSubview:tempWebVc.view];
    self.tempWebVc = tempWebVc;
    [self.tempWebVc loadWebView];
    
}

- (void)loginFail{//登录失效的情况
    if (JLGisLoginBool) {
        [TYUserDefaults setBool:NO forKey:JLGLogin];
        [TYUserDefaults synchronize];

        JLGAppDelegate *app = (JLGAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [app setRootViewController];
        
    }
}

- (JGJHomePageMaskingView *)maskingView {
    
    if (!_maskingView) {
        
        _maskingView = [[JGJHomePageMaskingView alloc] init];
    }
    return _maskingView;
}

#pragma mark - 切换城市
- (void)cityNoUp{
    static dispatch_once_t cityNoUpToken;
    dispatch_once(&cityNoUpToken, ^{
        NSString *cityNo   = [TYUserDefaults objectForKey:JLGCityNo];
        NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
        NSString *selectCityNo   = [TYUserDefaults objectForKey:JLGSelectCityNo];
        
        if (!selectCityNo) {//没有选择过地址的情况
            [self.titleButton setTitle:[TYUserDefaults objectForKey:JLGCityName] forState:UIControlStateNormal];
            [TYUserDefaults setObject:cityNo forKey:JLGSelectCityNo];
            [TYUserDefaults setObject:cityName forKey:JLGSelectCityName];
            [TYUserDefaults synchronize];
            return;
        }else{
            if (![cityNo isEqualToString:selectCityNo]) {
                NSString *message = [NSString stringWithFormat:@"系统定位你现在在%@,是否切换到%@?",cityName,cityName];
                _alter = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换",nil];
                [_alter show];
            }
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *cityNo   = [TYUserDefaults objectForKey:JLGCityNo];
        NSString *cityName = [TYUserDefaults objectForKey:JLGCityName];
        
        //显示切换城市
        [self.titleButton setTitle:cityName forState:UIControlStateNormal];
        
        //切换城市
        [TYUserDefaults setObject:cityNo forKey:JLGSelectCityNo];
        [TYUserDefaults setObject:cityName forKey:JLGSelectCityName];
        [TYUserDefaults synchronize];
    }
    
    _alter.delegate = nil;
    _alter = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    JGJWorkCircleBottomCell *bottomCell = [JGJWorkCircleBottomCell cellWithTableView:tableView];
    self.bottomCell = bottomCell;
    bottomCell.delegate = self;
    bottomCell.proListModel = self.proListModel;
    bottomCell.workCircleHeaderFooterViewBlock = ^(WorkCircleHeaderFooterViewButtonType buttonType){

        [weakSelf handleBottomCellButtonPressed:buttonType];
    };
    
    if (![self.bottomCell.bannerView.subviews containsObject:self.cycleScrollView]) {
        
        [self.bottomCell.bannerView addSubview:self.cycleScrollView];
    }
    
    bottomCell.bannerViewH.constant = TYGetViewH(self.cycleScrollView);
    
    return bottomCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return JGJHomeProHeight + TYGetViewH(self.cycleScrollView);
}


#pragma mark - 导航栏按钮设置
- (void)commonSet {
    
    self.ADImageRatio = 0.4514;
    CGRect scrollViewRect = CGRectMake(0, TYGetMinX(self.view), TYGetUIScreenWidth, TYGetUIScreenWidth * self.ADImageRatio);

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:scrollViewRect delegate:self placeholderImage:[UIImage imageNamed:@"banner_default_icon"]];
    self.cycleScrollView = cycleScrollView;
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    cycleScrollView.pageControlBottomOffset = 8;
    
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner_page_default_icon"];
    
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner_page_cur_icon"];
    
    [self.tableView reloadData];
    
    [self customTopNavView];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
//    //去掉回弹效果，因顶部毛玻璃效果
//    self.tableView.bounces = NO;
        
    if (TYIST_IPHONE_X) {
        
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        
        CGFloat rectStatusH = rectStatus.size.height;
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-rectStatusH);
        }];
    }

}

- (void)customTopNavView {
    
    JGJCusNavView *cusNavView = [[JGJCusNavView alloc] init];
    cusNavView.userInteractionEnabled = NO;
    self.cusNavView = cusNavView;
    cusNavView.delegate = self;
    [self.view addSubview:cusNavView];
    [cusNavView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    
    //回调布局顶部按钮
    if (cusNavView.cusNavViewBlock && cusNavView.superview) {
        
        cusNavView.cusNavViewBlock();
    }
}

#pragma mark - 获取收入数据
- (void)JLGHttpRequestBanner{

    NSString *clientID = [TYBaseTool getKeychainIdentifier];
    if ([NSString isEmpty:clientID]) {
        clientID = @"";
    }
    
    //获取今日记账数据
    [JLGHttpRequest_AFN PostWithApi:@"v2/index/banner"  parameters:@{@"ad_id":@"7",@"os":@"I", @"client" : clientID?:@""} success:^(id responseObject) {
        
        self.adArr = [JGJADModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        NSArray *ADImageSize = responseObject[@"ad_size"];
        
        if ([ADImageSize isKindOfClass:[NSArray class]] && ADImageSize.count > 0) {
        
            self.ADImageRatio = [[ADImageSize lastObject] floatValue]/[[ADImageSize firstObject] floatValue];
            
            if ([[ADImageSize firstObject] floatValue] == 0) {
                
                self.ADImageRatio = 0.4514;
            }
            
            //转换成服务器url
            __block NSMutableArray *imgsUrlArr = [NSMutableArray array];
            [self.adArr enumerateObjectsUsingBlock:^(JGJADModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [imgsUrlArr addObject:[JLGHttpRequest_Public stringByAppendingString:obj.img_path]];
            }];
            self.cycleScrollView.imageURLStringsGroup = imgsUrlArr.copy;
            
            [self updateTableHeaderView];
        
        }
        
#pragma mark - 弹窗广告
//        [self getAdvertisementAPI:responseObject];
          }failure:nil];
}
#pragma mark - 弹窗广告
- (void)JLGHttpRequestAlerShowBanner{
    
    NSString *clientID = [TYBaseTool getKeychainIdentifier];
    if ([NSString isEmpty:clientID]) {
        clientID = @"";
    }
    
    //获取今日记账数据
    [JLGHttpRequest_AFN PostWithApi:@"v2/index/banner"  parameters:@{@"ad_id":@"8",@"os":@"I", @"client" : clientID?:@""} success:^(id responseObject) {
        NSArray *bannerArr = [JGJADModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        if (bannerArr.count > 0) {
            self.adBannerModel = (JGJADModel *)bannerArr.lastObject;
            
            [self getAdvertisementAPI:responseObject];
            
        }
#pragma mark - 弹窗广告
    }failure:nil];
}

-(void)getAdvertisementAPI:(NSDictionary *)res
{
    JGJadverTisenmentType type;
    if ([NSString isEmpty:res[@"ad_type"]] || !JLGLoginBool) {
        return;
    }
    if ([res[@"ad_type"] isEqualToString:@"img"] ) {
       type = JGJadverTisenmentType_URL;
    }else{
       type = JGJadverTisenmentType_video;

    }
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:res[@"list"]];
    NSMutableDictionary *DataDic = [arr lastObject];
    if (arr.count <=0) {
        return;
    }
    if (arr.count > 0) {
        if (![self checkIsLogin]) {
            return;
        }
    [JGJAdvertisementShowView showadverTiseMentWithImageUrl:[JLGHttpRequest_Public stringByAppendingString:DataDic[@"img_path"]] withImage:nil forType:type andtapImageBlock:^(NSString *selectString) {
        
        
        JGJADModel *adModel = self.adBannerModel;
        
        //app内部
        
        if ([adModel.link_type isEqualToString:@"app"]) {
            
            if ([adModel.link_key isEqualToString:@"find_helper"]) {
                if (![self checkIsLogin]) {
                    return;
                }
                self.tabBarController.selectedIndex = 1;
            }else if([adModel.link_key isEqualToString:@"creat_group"]){
                
                [self handleBottomCellButtonPressed:WorkCircleHeaderViewCreatGroupButtonType];
            }else if([adModel.link_key isEqualToString:@"example"]){
                
                JGJWorkCircleBottomCell *bottomCell = [JGJWorkCircleBottomCell cellWithTableView:self.tableView];
                [self handleChatAction:bottomCell.defaultProListModel];
            }
            
            //app外部
            
        } else if([adModel.link_type isEqualToString:@"html"] && ![NSString isEmpty:adModel.link_key]){
            
            JGJWebAllSubViewController *webVc = [JGJWebAllSubViewController new];
            //        NSURL *url = [NSURL URLWithString:adModel.link_key];
            
            //                topdisplay=1  2.3.0加一个条件
            if ([adModel.link_key rangeOfString:JGJWebDomainURL].location != NSNotFound && [adModel.link_key rangeOfString:@"topdisplay=1"].location != NSNotFound) {
                
                webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:adModel.link_key];
                
            }else if ([adModel.link_key rangeOfString:JGJWebDomainURL].location != NSNotFound) {
                
                webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:adModel.link_key];
            }else {
                
                webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:adModel.link_key];
            }
            [self.navigationController pushViewController:webVc animated:YES];
        }
        
        }];
    }
    
}

- (void)updateTableHeaderView {
    
    CGRect cycleScrollFrame = self.cycleScrollView.frame;

    self.cycleScrollView.height = self.ADImageRatio*cycleScrollFrame.size.width;
    
    
    [self.tableView reloadData];
}

#pragma mark - 判断是否要跳转
- (BOOL )checkIsRight{
    if (![self checkIsLogin]) {
        return NO;
    }
    
    if (![self checkIsRealName]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)checkIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
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

- (void)workCircleMiddleTableViewCell:(JGJWorkCircleMiddleTableViewCell *)cell didSelectedNetNotReachabeTapAction:(UITapGestureRecognizer *)tapAction {
    UIViewController *noneNetWorkReminderVc= [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNoneNetWorkReminderVc"];
    [self.navigationController pushViewController:noneNetWorkReminderVc animated:YES];
}
#pragma mark - 处理 创建项目，扫码加入
- (void)handleBottomCellButtonPressed:(WorkCircleHeaderFooterViewButtonType) type {
    if (type == WorkCircleDefaultCellLoginButtonType) {
        UIViewController *loginVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        [self.navigationController pushViewController:loginVc animated:YES];
        return;
    }
    if (![self checkIsLogin]) {
        return ;
    }
    
    UIViewController *nextVc = nil;
    
    switch (type) {
        case WorkCircleHeaderViewCreatGroupButtonType: {
            
            UIViewController *creatProVC = [[UIStoryboard storyboardWithName:@"JGJCreatPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatProCompanyVC"];
            nextVc = creatProVC;
        }
            break;
        case WorkCircleHeaderViewCreatSweepQrCodeButtonType:{

            JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];
            
            nextVc = jgjQRCodeVc;
        }
            break;
        case WorkCircleDefaultCellCheckProButtonType:{
            
            JGJCheckProListVc *proListVc = [JGJCheckProListVc new];
            
            proListVc.proListModel = self.proListModel.group_info;
            
            nextVc = proListVc;
            
        }
            break;
        default:
            break;
    }
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:nextVc animated:YES];
                
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:nextVc animated:YES];
    }
}

#pragma mark - 处理记工报表
-(UIViewController *)handleRecordWorkpoints {
    
    __weak typeof(self) weakSelf = self;
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeProjectList];
    
    
    
    webVc.skipToNextVc = ^(UIViewController *nextVc){
        [weakSelf.navigationController pushViewController:nextVc animated:YES];
    };
    
    return webVc;
}

#pragma mark - 处理同步管理
-(UIViewController *)handleSynMangerType {
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJSynBillingManageVC *synBillingManageVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynBillingManageVC"];
    synBillingCommonModel.synBillingTitle = @"同步项目管理";
    synBillingCommonModel.isWageBillingSyn = NO;
    synBillingManageVC.synBillingCommonModel = synBillingCommonModel;
    
    return synBillingManageVC;
    
}

#pragma mark - 工作消息
-(UIViewController *)handleWorkInfo {
    JGJNewNotifyVC *newNotifyVC = [[UIStoryboard storyboardWithName:@"JGJNewNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewNotifyVC"];
    newNotifyVC.proListModel = self.proListModel;
    return newNotifyVC;
}

#pragma mark - 创建项目
-(UIViewController *)handleCreatPro {
    UIViewController *creatProCompanyVC = [[UIStoryboard storyboardWithName:@"JGJCreatPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatProCompanyVC"];
    return creatProCompanyVC;

}


#pragma mark - 聊天界面
- (UIViewController *)handleChatAction:(JGJMyWorkCircleProListModel *)worlCircleModel {
    
    JGJChatRootVc *chatRootVc;
    if ([worlCircleModel.class_type isEqualToString:@"team"]) {
        chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootVc"];
    }
    /*//2.1.0添加修改
     //进入私聊，和群聊
     else{
     chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
     }*/
    
    chatRootVc.workProListModel = worlCircleModel;
    
    return chatRootVc;
    
}

#pragma mark - 处理工作回复、聊天、其他项目按钮按下
- (void)handleButtonPressedWithButtonType:(ProTypeHeaderButtonType)buttonType {
    
//    ProTypeHeaderSwitchButtonType,
//    ProTypeHeaderChatButtonType,
//    ProTypeHeaderWorkReplyButtonType,
    
    UIViewController *nextVc = nil;
    
    switch (buttonType) {

    //聊天
        case ProTypeHeaderChatButtonType:{
            
           nextVc = [self handleChatAction:self.proListModel.group_info];
            
    
        }
            
            break;
        //切换项目
        case ProTypeHeaderSwitchProButtonType:{
            
            [self handleBottomCellButtonPressed:WorkCircleDefaultCellCheckProButtonType];
            
            //切换项目不需要完善姓名
            return;
        }
            
            break;
        //工作回复
        case ProTypeHeaderWorkReplyButtonType:{
            
           
            nextVc =  [self workReplyButtonPressed];
            
          
            self.proListModel.work_message_num = @"0";
            // 清空工作回复数
            [JGJChatMsgDBManger updateIndexWorkReplyUnreadToIndexTableWithGroup_id:self.proListModel.group_info.group_id class_type:self.proListModel.group_info.class_type work_message_num:@"0"];
        }
            
            break;
            
        default:
            break;
    }
    
    //刷新未读数
    [self.tableView reloadData];
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:nextVc animated:YES];
                
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:nextVc animated:YES];
    }
    
}

#pragma mark - 工作回复
- (UIViewController *)workReplyButtonPressed {
    
    JGJMyWorkCircleProListModel *proListModel = self.proListModel.group_info;
    
    JGJWorkReplyViewController *workNoticeVC = [[UIStoryboard storyboardWithName:@"JGJWorkReplyViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJWorkReplyVC"];
    
    workNoticeVC.WorkproListModel = proListModel;
    
    return workNoticeVC;
    
}

#pragma mark - JGJWorkCircleBottomCellDelegate 点击项目项目列表
- (void)handleJGJJGJWorkCircleBottomCellDidSelected:(JGJMyWorkCircleProListModel *)worlCircleModel {
    
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用 "];
        
        return;
    }
    
    if (![self checkIsRealName]) {
        return;
    }
    
    if (worlCircleModel) {
        [self handleChatAction:worlCircleModel];
    };
    
    //点击之后清零
    self.proListModel.group_info.unread_msg_count = @"0";
    
    [self.tableView reloadData];
    
}

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedWorlCircleModel:(JGJMyWorkCircleProListModel *)worlCircleModel {
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    JGJADModel *adModel = self.adArr[index];
    
    NSString *clientID = [TYBaseTool getKeychainIdentifier];
    
    if ([NSString isEmpty:clientID]) {
        clientID = @"";
    }
    adModel.client = clientID;
    
    NSDictionary *parameters = [adModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/index/bannerstatistics" parameters:parameters success:^(id responseObject) {
        
        
    }];
    
//app内部
    
    if ([adModel.link_type isEqualToString:@"app"]) {
        
        if ([adModel.link_key isEqualToString:@"find_helper"]) {
            if (![self checkIsLogin]) {
                return;
            }
            
            self.tabBarController.selectedIndex = 1;
            
        }else if([adModel.link_key isEqualToString:@"creat_group"]){
            
            [self handleBottomCellButtonPressed:WorkCircleHeaderViewCreatGroupButtonType];
        }else if([adModel.link_key isEqualToString:@"example"]){
            
            JGJWorkCircleBottomCell *bottomCell = [JGJWorkCircleBottomCell cellWithTableView:self.tableView];
            [self handleChatAction:bottomCell.defaultProListModel];
        }
        
//app外部
        
    } else if([adModel.link_type isEqualToString:@"html"] && ![NSString isEmpty:adModel.link_key]){
        
        JGJWebAllSubViewController *webVc = [JGJWebAllSubViewController new];
//        NSURL *url = [NSURL URLWithString:adModel.link_key];
        
        //2.3.0添加 topdisplay=1是外部链接有头子
        if ([adModel.link_key rangeOfString:JGJWebDomainURL].location != NSNotFound && [adModel.link_key rangeOfString:@"topdisplay=1"].location != NSNotFound) {
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:adModel.link_key];
            
        }else
        
        if ([adModel.link_key rangeOfString:JGJWebDomainURL].location != NSNotFound) {
          
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:adModel.link_key];
        }else {
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:adModel.link_key];
        }

         webVc.isHiddenTabbar = YES;
        
        [webVc addTopCusNav];
        
        [self.navigationController pushViewController:webVc animated:YES];
        
        self.handleWebVc = webVc;
        
    }
    
}

#pragma mark - App运行到前台告知服务器不要推送消息
- (void)appForeground {

    //App运行到前台,告知服务器不要推消息
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;

    [jlgAppDelegate appDidisEnterBackground:@"0" responseBlock:^(id response) {
        
        TYLog(@"%@", response);
        
    }];
    
}

#pragma mark - 设置导航栏风格
- (void)setNavBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:self.lastStatusBarStyle animated:NO];//设置颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_image_icon"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:JGJNavBarFont];
    [self.navigationController.navigationBar setTitleTextAttributes:dictAtt];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    [self showUnReadNumWithActiveGroupModel:proListModel];
    
    [self.tableView reloadData];
    
//    [self loadGetTemporaryFriendListWithActiveGroupModel:proListModel]; //获取是否有新朋友申请
    
    if (_proListModel) {
        NSData *proListModelData = [NSKeyedArchiver archivedDataWithRootObject:_proListModel];
        [TYUserDefaults setObject:proListModelData forKey:LastProListModel];
    }
    
    self.cusNavView.proListModel = proListModel;
    
    if (_isCanScroBottom) {
        
        [self scroBottom];
        
        _isCanScroBottom = NO;
    }
    
  
    
    JGJContactedListVc *vc = [self contactListvc];
    
}

#pragma mark - 显示未读数
- (void)showUnReadNumWithActiveGroupModel:(JGJMyWorkCircleProListModel *)activeGroupModel {
    
    //这里返0时候服务器的数据有问题。0的时候不处理
    if ([JGJChatMsgDBManger getAllUnreadMsgCount] == 0) {
        
        return;
    }
    UITabBarItem * chatItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    NSUInteger chat_unread_msg_count = [JGJChatMsgDBManger getAllUnreadMsgCount];
    
    NSString *chat_msg_count = [NSString stringWithFormat:@"%@", @(chat_unread_msg_count)];
    
    [self saveUserDefaults:chat_msg_count];
    
    if (chat_unread_msg_count > 0) {
        
        chatItem.badgeValue = chat_unread_msg_count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",[JGJChatMsgDBManger getAllUnreadMsgCount]];
    }else {
        chatItem.badgeValue = nil;
    }
    
    if (JGJAppIsDidisEnterBackgroundBool) {
        
        return;
    }
    
    NSUInteger total_unread_msg_count = chat_unread_msg_count;
    if (total_unread_msg_count > 0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = total_unread_msg_count;
        
    }else {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

#pragma mark - 得到更新通知信息更新数据库
- (void)handleGetNotifyInfo:(id)responseObject {
    JGJNewNotifyModel *notifyModel = [JGJNewNotifyModel mj_objectWithKeyValues:responseObject];
    [self updateActiveGroupList:notifyModel];
    
    BOOL isExist = [JGJNewNotifyTool isExistNotifyModel:notifyModel];
//同步自动创建的项目组推送，刷新用不需要存储
    NSArray *unSaveNotifyTypes = @[@"syncedSyncProject", @"delSyncProject", @"createSyncTeam", @"joinGroup"];
    if (!isExist && [unSaveNotifyTypes indexOfObject:notifyModel.class_type] == NSNotFound) {
        [JGJNewNotifyTool addCollectNotifies:notifyModel];
    }
    [self handleSpecialNotifyModel:notifyModel];
    [self refreshUnReadCount];
   [self refreshIndexPathRow:0 indexPathSection:0];
}

#pragma mark - 处理特殊的通知类型 delSyncProject syncedSyncProject
- (void)handleSpecialNotifyModel:(JGJNewNotifyModel *)notifyModel {
    if (notifyModel.notifyType == DelSyncProjectType) {
        notifyModel.notice_id = notifyModel.del_notice_id;
        [JGJNewNotifyTool removeCollectNotify:notifyModel];
    }else if (notifyModel.notifyType == SyncProjectType) {
        notifyModel.notice_id = notifyModel.del_notice_id;
        notifyModel.isSuccessSyn = YES;
        [JGJNewNotifyTool updateNotifyModel:notifyModel];
    }
}

#pragma mark - 根据通知类型是否刷新列表
- (void)updateActiveGroupList:(JGJNewNotifyModel *)notifyModel {
    
}

#pragma mark - 接收消息的监控
- (void)socketRequestReciveMessage{
    
    TYWeakSelf(self);
    
    [JGJSocketRequest WebSocketAddMonitor:@{@"ctrl":@"message",@"action":@"reddotMessage"} success:^(id responseObject) {
        
        NSLog(@"红点推送 responseObject = %@",responseObject);
        
        JGJChatMsgListModel *receiveMsg = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        
        if ([receiveMsg.msg_type isEqualToString:@"findred"]) {
            
            [self showDynamicMsgRed];
        }
        
        else {
            
//            [weakself handleAddFriendShowRedFlagWithChatMsgListModel:receiveMsg chatUnreadMsgCount:0];
            
        }
        
    } failure:nil];
    
}

- (void)showDynamicMsgRed {
    
    [self getDynamicMsgNum:YES];
}

#pragma mark - 2.5.0去掉小红点

- (void)handleAddFriendShowRedFlagWithChatMsgListModel:(JGJChatMsgListModel *)chatMsgListModel chatUnreadMsgCount:(NSInteger)chatUnreadMsgCount {
    
//    if (chatUnreadMsgCount == 0 && [chatMsgListModel.msg_type isEqualToString:@"add_friends"]) {
//        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
//    }
//
//    if ([chatMsgListModel.msg_type isEqualToString:@"add_friends"]) {
//
//        JGJContactedListVc *contactListVc = [self contactListvc];
//
//        contactListVc.isCheckFreshFriend = YES;
//    }
    
}

#pragma mark - 刷新页面
- (void)refreshIndexPathRow:(NSUInteger)row indexPathSection:(NSUInteger)section {
    [self.tableView reloadData];
}

#pragma mark - 刷新未读数据
- (void)refreshUnReadCount {
//    存在真实姓名显示未读数
    self.infoModel.unread_msg_count = JLGIsRealNameBool ? [JGJNewNotifyTool allUnReadedNofies] : @"0";
    [self refreshIndexPathRow:0 indexPathSection:0];
}

#pragma mark - 更新网络数据通知信息
- (void)updateNetWorkNotify {
   JGJNewNotifyTool *notifyTool = [JGJNewNotifyTool shareNotifyTool];
    __weak typeof(self) weakSelf = self;
    notifyTool.notifyToolBlock = ^{
        [weakSelf refreshUnReadCount];
    };
}

#pragma mark - 检测更新
- (void)handleCheckUpdate {
    NSString *keyChainIdentifierStr = [TYBaseTool getKeychainIdentifier];
    NSDictionary *parameters = @{@"os" : @"I",
                                 @"client_type" : @"manage",
                                 @"device_id" : keyChainIdentifierStr?:@""};
    [JLGHttpRequest_AFN PostWithApi:@"jlsys/version" parameters:parameters success:^(id responseObject) {
        JGJUpdateVerInfoModel *infoModel = [JGJUpdateVerInfoModel mj_objectWithKeyValues:responseObject];
        [self showUpdateView:infoModel];
        if (infoModel.forceUpdate != 0 && ![NSString isEmpty:infoModel.upinfo]) {
            
            _isHaveNewVersion = YES;
            
        }else {
            
            _isHaveNewVersion = NO;
            
            [self showCustomAdvi];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showCustomAdvi {
    
    if (!_isHaveNewVersion) {
        
        if (JLGisLoginBool) {
            
            TYWeakSelf(self);
            [JGJCCToolObject judgeCountToAlertPopViewWithVC:self dismissBlock:^{
                
            }];
        }
        
    }
    
}


- (void)showUpdateView:(JGJUpdateVerInfoModel *)infoModel {
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
//    desModel.popDetail  = @"1、项目组中可以直接发送图片\n2、项目组中可以@成员和复制消息\n3、可以修改我在项目组中的名字";
    if (infoModel.forceUpdate != 0 && ![NSString isEmpty:infoModel.upinfo]) {
         [JGJUpdateVerPopView updateDesViewWithDesModel:desModel updateVerInfoModel:infoModel];
    }
}

#pragma mark - getter 
#pragma mark - 主要用于工作消息显示未读数
- (JGJWorkCircleMiddleInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[JGJWorkCircleMiddleInfoModel alloc] init];
//        _infoModel.unread_msg_count = [JGJNewNotifyTool allUnReadedNofies];
    }
    return _infoModel;
}

#pragma mark -JGJCusNavViewDelegate

- (void)customNavViewWithNavView:(JGJCusNavView *)navView didSelectedButtonType:(JGJCusNavViewButtonType)buttonType {
    
    switch (buttonType) {
        case JGJCusNavViewMoreButtonType:{
            
            PopoverView *popoverView = [PopoverView popoverView];
            popoverView.style = PopoverViewStyleDark;
            [popoverView showToView:navView.topMoreButton withActions:[self JGJChatActions]];
        }
            
            break;
        case JGJCusNavViewWorkInfoButtonType:{
            
            [self handleCusNavActionWithButtonType:JGJHomeWorkInfoButtonType];
        }
            
            break;
        default:
            break;
    }
    
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    // 扫一扫 action
    
    __weak typeof(self) weakSelf = self;
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"RichScan"] title:@"扫一扫" handler:^(PopoverAction *action) {
        
        [weakSelf handleCusNavActionWithButtonType:JGJHomeQrcodeButtonType];
    }];
    
    PopoverAction *creatProAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_home_New project"] title:@"新建项目" handler:^(PopoverAction *action) {
        [weakSelf handleCusNavActionWithButtonType:JGJHomeCreatProButtonType];
    }];
    
    PopoverAction *synProAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"syn_pro_icon"] title:@"同步项目" handler:^(PopoverAction *action) {
        
        [weakSelf handleCusNavActionWithButtonType:JGJHomeSynProButtonType];
    }];
    
    return @[creatProAction, synProAction,sweepAction];
}

- (void)handleCusNavActionWithButtonType:(JGJHomeButtonType)buttonType {
    
    if (![self checkIsLogin]) {
        return ;
    }

    UIViewController *nextVc = nil;
    
    switch (buttonType) {
        case JGJHomeQrcodeButtonType: {
            
            JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];
            
            nextVc = jgjQRCodeVc;
            
        }
            break;
        case JGJHomeSynProButtonType:{
            
            nextVc = [self handleSynMangerType];
            
            [self.navigationController pushViewController:nextVc animated:YES];
            
            return;
        
        }
            break;
        case JGJHomeCreatProButtonType:{
            
            nextVc = [self handleCreatPro];
        
        }
            break;
            
        case JGJHomeWorkInfoButtonType:{
            
            nextVc = [self handleWorkInfo];
        
        }
            break;
        case JGJHomeRecordWorkpointsButtonType:{
            
            nextVc = [self handleRecordWorkpoints];
            
        }
            break;
        default:
            break;
    }
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:nextVc animated:YES];
                
            };
            
        }
        
    }else {
        
         [self.navigationController pushViewController:nextVc animated:YES];
    }
    
}

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedListType:(JGJWorkCircleMiddleInfoModel *)proTypeModel {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    JGJMyWorkCircleProListModel *workProListModel = self.proListModel.group_info;
    
    JGJChatRootRequestModel *chatRootRequestModel = [JGJChatRootRequestModel new];
    chatRootRequestModel.group_id = workProListModel.group_id;
    chatRootRequestModel.action = @"groupMessageList";
    chatRootRequestModel.class_type = workProListModel.class_type;
    
    chatRootRequestModel.ctrl = @"message";
    
    chatRootRequestModel.pageturn = @"next";
    
    
    UIViewController *nextVc = [UIViewController new];
    
    //项目设置、云盘和知识库不弹过期框
    
    if (!(proTypeModel.cellType == 15 || proTypeModel.cellType == 11 || proTypeModel.cellType == 10)) {
        
        if ([self overTimeTip]) {
            
            return;
        }
    }
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    switch (proTypeModel.cellType) {
            
        case 0: {
            
            JGJQuaSafeHomeVc *qualityVc = [JGJQuaSafeHomeVc new];
            
            chatRootRequestModel.msg_type = @"quality";
            
            JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
            
            commonModel.type = JGJChatListQuality;
            
            commonModel.msg_type = @"quality";
            
            qualityVc.commonModel = commonModel;
            
            //区分质量安全任务存草稿
            commonModel.quaSafeCheckType = @"qualityType";
            
            qualityVc.workProListModel = self.proListModel.group_info;
            
            nextVc = qualityVc;
            
        }
            
            break;
            
        case 1: {
            
            JGJQuaSafeHomeVc *quaSafeHomeVc = [JGJQuaSafeHomeVc new];
            
            JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
            
            commonModel.type = JGJChatListSafe;
            
            commonModel.msg_type = @"safe";
            
            chatRootRequestModel.msg_type = @"safe";
            
            //区分质量安全任务存草稿
            commonModel.quaSafeCheckType = @"safeType";
            
            quaSafeHomeVc.commonModel = commonModel;
            
            quaSafeHomeVc.workProListModel = self.proListModel.group_info;
            
            nextVc = quaSafeHomeVc;
            
        }
            
            break;
            
        case 2:{
            
            JGJQuaSafeCheckHomeVc *quaSafeCheckHomeVc = [JGJQuaSafeCheckHomeVc new];
            
            quaSafeCheckHomeVc.proListModel = self.proListModel.group_info;
            
            nextVc = quaSafeCheckHomeVc;
            
        }
            
            break;
            
        case 3:{
            
            JGJTaskRootVc *taskRootVc = [[JGJTaskRootVc alloc] init];
            
            taskRootVc.proListModel = self.proListModel.group_info;
            
            commonModel.msg_type = @"task";
            
            taskRootVc.commonModel = commonModel;

            nextVc = taskRootVc;
        }
            
            break;
            
        case 4:{
//
            JGJChatListNoticeVc *noticeVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListNoticeVc"];
            chatRootRequestModel.msg_type = @"notice";
            nextVc = noticeVc;
        }
            
            break;
            
        case 5:{
            
            JGJChatListSignVc *signVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListSignVc"];
            chatRootRequestModel.msg_type = @"signIn";
            nextVc = signVc;
            
        }
            
            break;
            
        case 6:{
            
            NSString *meetingStr = [NSString stringWithFormat:@"%@conference?group_id=%@&class_type=%@&close=%@&group_name=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc), workProListModel.pro_name];
            
            JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
            indexModel.unread_meeting_count = @"0";
            [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:meetingStr];
            
            webVc.isHiddenTabbar = YES;
            
            nextVc = webVc;

            TYLog(@"会议 -----");
            
        }
            
            break;
            
            
        case 7:{
            
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
            
            NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
            
            NSString *applyStr = [NSString stringWithFormat:@"%@applyfor?group_id=%@&class_type=%@&close=%@&%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc),timeID];
            
            JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
            indexModel.unread_approval_count = @"0";
            [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:applyStr];
            nextVc = webVc;
            
//            [TYShowMessage showSuccess:applyStr];
            TYLog(@"--------审批");

        }
            
            break;
            
        case 8:{
            
            JGJChatListLogVc *logVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListLogVc"];
            logVc.cur_name = self.proListModel.group_info.cur_name;
            chatRootRequestModel.msg_type = @"log";
            nextVc = logVc;
            
        }
            
            break;
            
        case 9:{
         
            JGJSummerViewController *weatherVC = [JGJSummerViewController new];
            
            //创建者和记录员is_report都是1
            
            if ([self.proListModel.group_info.myself_group isEqualToString:@"1"]) {
                
                self.proListModel.group_info.is_report = @"1";
            }
            
            weatherVC.WorkCicleProListModel = self.proListModel.group_info;
            
            nextVc = weatherVC;
          
            TYLog(@"--------晴雨表");
            
        }
            
            break;
        
        case 10:{
            
            JGJKnowRepoVc *knowBaseVc = [[UIStoryboard storyboardWithName:@"JGJKnowRepo" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJKnowRepoVc"];
            
            nextVc = knowBaseVc;
            
            //统计模块点击事件
            [MobClick event:@"click_repository_module"];
            
            [self closeGroupFlag:knowBaseVc];
            
        }
            
            break;
        
        case 11:{
            
            JGJProicloudRootVc *cloudRootVc = [[UIStoryboard storyboardWithName:@"JGJProicloud" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJProicloudRootVc"];
            
            cloudRootVc.proListModel = self.proListModel.group_info;
            
            nextVc = cloudRootVc;
            
            [self closeGroupFlag:cloudRootVc];
            
        }
            
            break;
        
        case 12:{
            
            //项目微官网
            NSString *websiteStr = [NSString stringWithFormat:@"%@website?group_id=%@&class_type=%@&close=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc)];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:websiteStr];
            nextVc = webVc;
            
        }
            
            break;
            
        case 13:{
            
            //设备管理
            NSString *equipmentStr = [NSString stringWithFormat:@"%@equipment?group_id=%@&class_type=%@&close=%@",JGJWebDiscoverURL, workProListModel.group_id, workProListModel.class_type, @(workProListModel.isClosedTeamVc)];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:equipmentStr];
            
            webVc.isHiddenTabbar = YES;
            
            [webVc addTopCusNav];
            
            nextVc = webVc;
            
        }
            
            break;
        
        case 14:{
            
            NSString *statisticsStr = [NSString stringWithFormat:@"%@statistical/charts?is_demo=%@&talk_view=1&team_id=%@",JGJWebDiscoverURL, workProListModel.is_not_source, workProListModel.group_id];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
            
            webVc.isHiddenTabbar = YES;
            
            JGJTabBarViewController *tabarVc = (JGJTabBarViewController *)self.tabBarController;
            
            if ([tabarVc isKindOfClass:NSClassFromString(@"JGJTabBarViewController")]) {
                
                tabarVc.is_HiddenNav = YES;
                
            }
            
            [webVc addTopCusNav];
            
            nextVc = webVc;

        }
            
            break;
            
        case 15:{
            
            nextVc = [self handleCheckAllMember];
        }
            
            break;
            
        case 16:{
            
            UIViewController *mangerVC = [[UIStoryboard storyboardWithName:@"JGJTeamManger" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupMangerVC"];
            
            [mangerVC setValue:workProListModel forKey:@"workProListModel"];
            
            nextVc = mangerVC;
            
        }
            break;
            
            
        default:
            break;
    }
    
    if ([nextVc isKindOfClass:[JGJChatListBaseVc class]]) {
        JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)nextVc;
        //            baseVc.delegate = self;
        baseVc.workProListModel = workProListModel;

                baseVc.chatListRequestModel = chatRootRequestModel;
        //                        baseVc.parentVc = strongSelf;
        
        //进入下一个界面
        baseVc.skipToNextVc = ^(UIViewController *nextVc){
            [weakSelf.navigationController pushViewController:nextVc animated:YES];
        };
    }else if([nextVc isKindOfClass:[JGJWebAllSubViewController class]]){
        
        JGJWebAllSubViewController *webVc = (JGJWebAllSubViewController *)nextVc;
        
        //进入下一个界面
        webVc.skipToNextVc = ^(UIViewController *nextVc){
            [weakSelf.navigationController pushViewController:nextVc animated:YES];
        };
        
    }
    
    //是项目情况,不是知识库都需要完成姓名
    if (proTypeModel.cellType != 10) {
        
        if (![self checkIsRealName]) {
            
            TYWeakSelf(self);
            if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
                
                JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
                
                customVc.customVcBlock = ^(id response) {
                    
                    if ((proTypeModel.cellType != 13 && proTypeModel.cellType != 2)) {
                        
                        [weakself.navigationController pushViewController:nextVc animated:YES];
                    }
                    
                };
                
            }
            
            return;
        }else {
            
            [self.navigationController pushViewController:nextVc animated:YES];
        }
        
    }else {
     
        [self.navigationController pushViewController:nextVc animated:YES];
        
    }
}

- (void)closeGroupFlag:(UIViewController *)targetVc {

    if (self.proListModel.group_info.isClosedTeamVc) {

        UIImageView *clocedImageView = [[UIImageView alloc] init];
        clocedImageView.image = [UIImage imageNamed:@"Chat_closedGroup"];
        [targetVc.view addSubview:clocedImageView];

        [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.center.mas_equalTo(targetVc.view);
            make.width.mas_equalTo(126);
            make.height.mas_equalTo(70);
        }];
        
    }

}

#pragma mark - 过期提示

#pragma mark - 全局取消黄金服务版(4个位置修改了，搜索这句话)

-(BOOL)overTimeTip {
    
    JGJGroupMangerTool *groupMangerTool = [[JGJGroupMangerTool alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    groupMangerTool.groupMangerToolBlock = ^(id response) {
      
        
        
        [TYShowMessage showPlaint:@"操作成功"];
    };
    
    //升级类型
    groupMangerTool.buyGoodType = VIPServiceType;
    
    groupMangerTool.targetVc = self.navigationController;
        
    groupMangerTool.workProListModel = self.proListModel.group_info;
    
//    return [groupMangerTool overTimeTip];
    
    return NO;
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;

    CGFloat alpha = offset / 64.0;

    UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
    
    if (alpha >= 1) {
        
        alpha = 1;
    
        statusBarStyle = UIStatusBarStyleDefault;
    }
    
    self.lastStatusBarStyle = statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:NO];//设置颜
    
    self.cusNavView.cusNavAlpha = alpha;

}

- (void)setTableViewFooterView {
    
    CGFloat height = 14;
    
    if (TYIS_IPHONE_6) {
        
        height = 30;
        
    }else if (TYIS_IPHONE_6P) {
        
        height = 50;
        
    }else {
        
        height = 14;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];

    footerView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.tableFooterView = footerView;
}


- (JGJContactedListVc *)contactListvc {
    
    for (UIViewController *curVc in self.tabBarController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *navVc = (JLGCustomViewController *)curVc;
            
            for (JGJContactedListVc *vc in navVc.viewControllers) {
                
                if ([vc isKindOfClass:NSClassFromString(@"JGJContactedListVc")]) {
                    
                    JGJContactedListVc *contactedListVc = (JGJContactedListVc *)vc;
                    
                    return contactedListVc;
                    
                    break;
                }
                
            }
            
        }
        
    }
    
    return nil;
}

#pragma mark - 打开定位权限
- (void)openLcoalAuthor {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status ==  kCLAuthorizationStatusNotDetermined) {
        
        JLGAppDelegate *appDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate unOpenLocalTilte:@"打开定位" message:@"项目管理的“签到”功能需要你的同意，才能在使用期间访问位置信息"];
        
    }
}

- (void)setIsCanScroBottom:(BOOL)isCanScroBottom {
    
    _isCanScroBottom = isCanScroBottom;
    
    if (_isCanScroBottom) {
        
        [self scroBottom];
    }
    
}

#pragma mark - 滚动到底部

- (void)scroBottom {
    
    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
    
    [self.tableView setContentOffset:offset animated:YES];
}


//网络状态的判断
- (void)networkingConfig
{
    
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 连接状态回调处理
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
                 
             case AFNetworkReachabilityStatusUnknown:
                 TYLog(@"网络状态:未知网络状态或者无网络连接");
                 
                 self.cusNavView.netWorkStatus = AFNetworkReachabilityStatusUnknown;
                 [self.cusNavView mas_updateConstraints:^(MASConstraintMaker *make) {
                     
                     make.height.mas_equalTo(64 + 40);
                 }];
                 [self.cusNavView.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusUnknown];
                 
                 break;
                 
             case AFNetworkReachabilityStatusNotReachable:
                 TYLog(@"网络不可用");
                 self.cusNavView.netWorkStatus = AFNetworkReachabilityStatusNotReachable;
                 [self.cusNavView mas_updateConstraints:^(MASConstraintMaker *make) {
                     
                     make.height.mas_equalTo(64 + 40);
                 }];
                 [self.cusNavView.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusNotReachable];
                 
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 TYLog(@"网络状态:移动网络");
                 self.cusNavView.netWorkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                 [self.cusNavView mas_updateConstraints:^(MASConstraintMaker *make) {
                     
                     make.height.mas_equalTo(64);
                 }];
                 [self.cusNavView.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusReachableViaWWAN];
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 TYLog(@"网络状态:Wifi");
                 self.cusNavView.netWorkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                 [self.cusNavView mas_updateConstraints:^(MASConstraintMaker *make) {
                     
                     make.height.mas_equalTo(64);
                 }];
                 [self.cusNavView.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusReachableViaWiFi];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - 查看全部成员
- (UIViewController *)handleCheckAllMember {
    JGJCheckGroupChatAllMemberVc *allMemberVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckGroupChatAllMemberVc"];
    
    JGJTeamInfoModel *teamInfo = [[JGJTeamInfoModel alloc] init];
    
    JGJMyWorkCircleProListModel *group_info = self.proListModel.group_info;
    
    teamInfo.class_type = group_info.class_type;
    
    teamInfo.group_id = group_info.group_id;
    
    teamInfo.is_admin = group_info.can_at_all;
    
    allMemberVc.teamInfo = teamInfo;
    
    allMemberVc.allMemberVcType = CheckAllMemberVcGroupMangerType;
    
    allMemberVc.workProListModel = group_info;
    
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    
    commonModel.memberType = JGJProMemberType;
    
    allMemberVc.commonModel = commonModel;
    
    allMemberVc.successBlock = ^(NSDictionary * response) {
        
        [JGJChatGetOffLineMsgInfo http_getChatIndexList];
        
        __weak typeof(self) weakSelf = self;
        
        [JGJChatGetOffLineMsgInfo shareManager].getIndexListSuccess = ^(JGJMyWorkCircleProListModel *proListModel) {
            
            TYLog(@"members_head_pic-----%@", proListModel.group_info.members_head_pic);
            
            TYLog(@"members_num-----%@", proListModel.group_info.members_num);
            
            JGJChatGroupListModel *chatGroupModel = [[JGJChatGroupListModel alloc] init];
            
            chatGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:proListModel.group_info.group_id classType:proListModel.group_info.class_type];
            
            JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
            
            chatGroupModel.members_num = indexModel.group_info.members_num;
            
            //这里没更新到
            
            chatGroupModel.local_head_pic = [indexModel.group_info.members_head_pic mj_JSONString];
            
            chatGroupModel.group_name = weakSelf.proListModel.group_info.group_name;
            
            [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:chatGroupModel];
            
            TYLog(@"11local_head_pic-----%@", chatGroupModel.local_head_pic);
            
            TYLog(@"22members_num-----%@", chatGroupModel.members_num);
            
        };
        
    };
    
    return allMemberVc;
}

- (void)saveUserDefaults:(NSString *)badge
{
    NSString *version= [UIDevice currentDevice].systemVersion;
    
    if(version.doubleValue < 10.0) {
        
        return;
        
    }
    
    if ([NSString isEmpty:badge]) {
        
        badge = @"0";
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:JGJShareSuiteName];
    
    [shared setObject:badge forKey:JGJShareSuiteNameKey];
    
    [shared synchronize];
}

@end
