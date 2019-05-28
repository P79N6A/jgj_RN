//
//  JGJWebAllSubViewController.m
//  mix
//
//  Created by Tony on 16/4/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWebAllSubViewController.h"
//ThirdLib
#import "TYFMDB.h"
#import "Masonry.h"
#import "RxWebViewController.h"
#import "UINavigationBar+Awesome.h"


#import "TYPhone.h"
#import "TYUIImage.h"
#import "NSString+JSON.h"
#import "TYDeviceInfo.h"
#import "TYPermission.h"
#import "JGJSureOrderListViewController.h"
//分享
#import "JGJShareBillView.h"
#import "SDWebImageManager.h"
#import "AppDelegate+JLGThirdLib.h"

#import "TYBaseTool.h"
#import "JGJCommonTool.h"
#import "NSDate+Extend.h"
#import "JLGCityPickerView.h"
#import "UIImage+TYALAssetsLib.h"
#import "JLGCustomViewController.h"
#import "JGJReportViewController.h"
#import "JLGProjectTypeViewController.h"
#import "LeftMenuVC.h" //获取个人信息数据
#import "JGJViewController.h"
#import "JGJSynBillingManageVC.h"
#import "NSString+Extend.h"
#import "JGJGuideImageVc.h"
#import "JGJAddTeamMemberVC.h" //记工统计添加数据来源人
#import "JGJSureOrderListViewController.h"
#import "NSString+JSON.h"
#import "JGJWeiXin_pay.h"
//2.1.2-yj
#import "JGJChatRootVc.h"
#import "JGJAddFriendSendMsgVc.h"
#import "JGJCustomShareMenuView.h"
#import "JGJShareMenuView.h"

#import "JGJMineSettingVc.h"
#import "JGJCashDepositViewController.h"
#import "JGJRemainingSumViewController.h"
#import "JGJServiceStroeViewController.h"

#import "JGJCheckPhotoTool.h"

#import "JGJQRCodeVc.h"

#import "JGJPerInfoVc.h"

#import "JGJCalendarViewController.h"

#import "AFNetworkReachabilityManager.h"

#import "JGJVideoListVc.h"

#import <UMShare/UMShare.h>

#import "JGJKnowRepoVc.h"

#import "UIImage+Cut.h"

#import "JGJmodifiPhoneViewController.h"

#import "JGJCustomPopView.h"

#import "TYPredicate.h"

#import "JGJModifyUserTelVc.h"

#import "JGJWebAllSubViewController+service.h"
#import "JGJDataManager.h"

#define JGJWebUserAgent @"JGJWebUserAgent"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif
@interface JGJWebAllSubViewController ()
<
    JGJShareBillViewDelegate,
    JLGCityPickerViewDelegate,
    JLGProjectTypeViewControllerDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    JGJAddTeamMemberDelegate,
    JGJGuideImageVcDelegate

>
{
    BOOL _isOnlyOnce;//每次进入页面的时候只调用一次
}
@property (nonatomic,strong) UIActionSheet *sheet;
@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic,strong) NSMutableArray *workTypesArray;
@property (nonatomic,strong) NSMutableArray *projectTypesArray;

@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,strong) UIButton *rightButton;

//是否一直保持头部状态
@property (nonatomic,assign) BOOL isAlwaysKeepNarStatus;

@property (nonatomic,assign) JGJWebType webType;

@property (nonatomic,strong) JLGCityPickerView *cityPickerView;

@property (nonatomic,strong) WebViewJavascriptBridge* webJSBridge;
@property (nonatomic,strong) JGJShareBillView *jgjShareBillView;
@property (nonatomic, strong) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel; //添加数据来源人请求模型


@property (nonatomic,copy) NSArray *hiddenURLAddresses;

@property (nonatomic,strong) UIBarButtonItem* closeButtonItem;

// 添加顶部，用于遮挡闪烁
@property (nonatomic, strong) UIView *cusNav;

@end
@implementation JGJWebAllSubViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.webView.backgroundColor = AppFontf1f1f1Color;
    self.isAlwaysKeepNarStatus = NO;
    [self.navigationController setValue:@NO forKey:@"shouldPopItemAfterPopViewController"];
    
    self.webJSBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.webJSBridge setWebViewDelegate:self];
    

    
}

#pragma mark - 添加顶部，用于遮挡闪烁
- (void)addTopCusNav {
    
//    self.cusNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
//
//    self.cusNav.userInteractionEnabled = NO;
//
//    UIImageView *navImageView = [[UIImageView alloc] init];
//
//    navImageView.image = [UIImage imageNamed:@"nav_image_icon"];
//
//    navImageView.frame = self.cusNav.bounds;
//
//    self.cusNav.backgroundColor = [UIColor blackColor];
//
//    [self.cusNav addSubview:navImageView];
//
//    [TYKey_Window addSubview:self.cusNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //根据当前是否登录状态,传值给H5加载数据
    [self handleLoginInfo];
    self.navigationController.navigationBarHidden = YES;
    [self handleCallHandlerNetStatus];
    
}

#pragma mark - 处理网络状态
- (void)handleCallHandlerNetStatus {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         NSString *network = @"unknown";
         
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 //             case AFNetworkReachabilityStatusNotReachable:
                 TYLog(@"网络状态:未知网络状态或者无网络连接");
                 
                 network = @"unknown";
                 
                 break;
                 
             case AFNetworkReachabilityStatusNotReachable:
                 
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 
                 network = @"4g";
                 TYLog(@"网络状态:移动网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 TYLog(@"网络状态:Wifi");
                 
                 network = @"wifi";
                 break;
             default:{
                 
                 
             }
                 break;
         }
         
         NSDictionary *networkStateDic = @{@"network" : network,
                                           };
         
         NSString *networkInfojson = [NSString getJsonByData:networkStateDic];
         
         [weakSelf.webJSBridge callHandler:@"networkState" data:networkInfojson responseCallback:^(id responseData) {
             
             
             
         }];
         
     }];
    
}

#pragma mark - 出初始化头子
- (BOOL)initialNavHidden {
    
    //聊天界面链接大部分是外部所以可以先显示
    
//    BOOL isHidden = YES;
//    for (UIViewController *curVc in self.navigationController.viewControllers) {
//
//        if ([curVc isKindOfClass:NSClassFromString(@"JGJChatRootVc")]) {
//
//            isHidden = NO;
//
//            break;
//        }
//
//    }
    
    return YES;
}
-(void)refreashH5
{
    NSString *userToken = [TYUserDefaults objectForKey:JLGToken];
    NSString *os = @"I";
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    NSDictionary *loginInfoDic = JLGisLoginBool ? @{@"os" : os,
                                                    @"token" : userToken?:@"",
                                                    @"infover" : @(infoVer),
                                                    } : @{};
    
    NSString *loginInfojson = [NSString getJsonByData:loginInfoDic];
    [self.webJSBridge callHandler:@"loginInfo" data:loginInfojson responseCallback:^(id responseData) {
        
        
    }];

}
-(void)viewWillLayoutSubviews{
    if (self.needLayout) {
        self.webView.frame = self.view.bounds;
    }
}

//监听处理中，就可以针对具体的手机方向，来旋转Controller的View了，首先是旋转，然后是frame跟当前屏幕的适应。
- (void)orientChange:(NSNotification *)noti {

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGFloat PIFloat = 0;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            PIFloat = 0;
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            PIFloat = M_PI*0.5;
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            PIFloat = -M_PI*0.5;
        }
            break;
        default:
            break;
    }

    [self changeTransform:PIFloat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.sheet = nil;
    self.workTypesArray = nil;
    self.cityPickerView = nil;
    self.projectTypesArray = nil;
    self.imagePickerController = nil;
    self.jgjShareBillView = nil;
}

- (void)dealloc{
    if (([[self.baseWebURL absoluteString] rangeOfString:GamePlatform1758URL].location !=NSNotFound)) {
        [TYNotificationCenter removeObserver:self];
    }
    
    if (self.webView.delegate) {
        self.webView.delegate = nil;
    }
}

- (void)changeTransform:(CGFloat )PIFloat{
    CGRect changeWebFrame;
    if (PIFloat == 0) {//竖屏,显示
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        changeWebFrame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
    }else{//横屏，隐藏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        changeWebFrame = CGRectMake(0, 0, TYGetUIScreenWidth - 40, TYGetUIScreenHeight);
    }
    
    CGAffineTransform changeTransform  = CGAffineTransformMakeRotation(PIFloat);
    CGAffineTransform changeWebTransform  = CGAffineTransformMakeRotation(-PIFloat);
    CGRect changeFrame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.view.transform = changeTransform;
        self.navigationController.view.frame = changeFrame;
        self.view.transform = changeTransform;
        self.view.frame = changeFrame;
        self.webView.transform = changeWebTransform;
        self.webView.frame = changeWebFrame;
    }];
}

-(instancetype)initWithWebType:(JGJWebType )webType{
    return [self initWithWebType:webType URL:nil];
}

-(instancetype)initWithWebType:(JGJWebType )webType URL:(NSString *)url{
    self = [super init];
    if (self) {
        //通过类型获取url
        NSString *baseWebURLString = [self getBaseWebURLstringWithType:webType URL:url];
        
        //URL使用UTF8编码
//        baseWebURLString = [baseWebURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        baseWebURLString = [baseWebURLString encodeToPercentEscapeString:baseWebURLString];
        
        self.baseWebURL = [NSURL URLWithString:baseWebURLString];
        
//        //更新最新的UserAgent
//
        [self modifyUserAgent];
        
    }
    return self;
}

- (void)modifyUserAgent{
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSString *webOldAgent = [TYUserDefaults objectForKey:JGJWebUserAgent];
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    
    NSString *client_info = [NSString stringWithFormat:@";manage;ver=%@;infover=%@",currentVersion, @(infoVer)];
    
    if (![NSString isEmpty:oldAgent] && [NSString isEmpty:webOldAgent]) {
        
        [TYUserDefaults setObject:oldAgent forKey:JGJWebUserAgent];
        
    }
    
    NSString *existUserAgent = [TYUserDefaults objectForKey:JGJWebUserAgent];;
    
    if (![NSString isEmpty:existUserAgent]) {
        
        NSString *newAgent = [existUserAgent stringByAppendingString:client_info];
        
        NSDictionary *dictionary = @{@"UserAgent": newAgent
                                     };
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
    }
    
}

- (void )changeBarToNewsColor:(BOOL )NewsColor{
    if (![self isCurrentViewControllerVisible]) {//没有显示
        return;
    }
    
    
    
    //显示蓝色
    if (NewsColor) {
        self.navigationItem.leftBarButtonItem = [self getWhiteLeftBarButton];
//        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:TYColorHex(0x466984) tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
        self.navigationItem.leftBarButtonItem = [self getLeftBarButton];
//        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:AppFontfafafaColor tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    
}

- (NSString *)getBaseWebURLstringWithType:(JGJWebType )webType{
    return [self getBaseWebURLstringWithType:webType URL:nil];
}

- (NSString *)getBaseWebURLstringWithType:(JGJWebType )webType URL:(NSString *)url{
    self.webType = webType;
    __block NSString *baseWebURLString = JLGHttpRequest_Public;
    switch (webType) {
        case JGJWebTypeMineInfo:
            baseWebURLString = MineInfoURL;
//            baseWebURLString = [@"http://192.168.1.179:8080/" stringByAppendingString:MineInfoURL];
            break;
        case JGJWebTypeContactUs:
            baseWebURLString = [JGJWebDiscoverURL stringByAppendingString:ContactUsURL];
            break;
        case JGJWebTypeComments:
            baseWebURLString = [JGJWebDiscoverURL stringByAppendingString:CommentsURL];
            break;
        case JGJWebTypeAgreement:
            baseWebURLString = [baseWebURLString stringByAppendingString:AgreementURL];
            break;
        case JGJWebTypeModifyAboutUs:
            baseWebURLString = [JGJWebDiscoverURL stringByAppendingString:AboutUsURL];
            break;
        case JGJWebTypeDownLoadBill:
            baseWebURLString = url;
            break;
        case JGJWebTypeGameError:
            baseWebURLString = url;
            break;
        case JGJWebTypeProjectList:
            baseWebURLString = WebProjectList;
            break;
        case JGJWebTypePersonScore:
            baseWebURLString = ScoreWeb;
            break;
        case JGJWebFindHelperType:
            baseWebURLString = JGJWebFindHelperURL;
            break;
        case JGJWebTypeNewLife:
        {
            baseWebURLString = NewLifeURL;
        }
            break;
        case JGJWebTypeDynamic:{
            baseWebURLString = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,url];
        }
            break;
        case JGJWebTypeMyCollection:{
            baseWebURLString = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,@"dynamic/collection"];
        }
            break;
        
        case JGJWebTypeInnerURLType:{
            
            baseWebURLString = url;
        }
            
            break;
            
        case JGJWebTypeProDetailType: {
            baseWebURLString = url;
        }
            break;
            
        case JGJWebTypeExternalThirdPartBannerType:{
            
            baseWebURLString = url;
        }
            break;
        default:
            break;
    }
    
    return baseWebURLString;
}

#pragma mark 设置需要显示的操作
- (void )setBaseWillAppear{
    [super setBaseWillAppear];
    
    if ([[self.baseWebURL absoluteString] rangeOfString:MineInfoURL].location !=NSNotFound){//个人设置
        [self setNavigationBarTransformProgress:YES];
    }else if([[self.baseWebURL absoluteString] rangeOfString:WebProject.absoluteString].location !=NSNotFound){
        [self setNavigationBarTransformProgress:YES];
    }else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
    }
    
    //监控横屏或者竖屏
    if ([[self.baseWebURL absoluteString] rangeOfString:GamePlatform1758URL].location !=NSNotFound){
        [TYNotificationCenter addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    [self setWebTitle:self.baseWebURL.absoluteString];
    
}

- (void)setBaseDidAppear{
    [self registerCallBack];
    
    self.navigationController.navigationBar.translucent = NO;//不透明
    
    [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
}

- (void)setBaseDidDisappear{
//    if (![self.baseWebURL.absoluteString containsString:WebProject.absoluteString]) {
//        [self changeTransform:0];
//    }
    
    if ([[self.baseWebURL absoluteString] rangeOfString:WebProject.absoluteString].location !=NSNotFound) {
        [self changeTransform:0];
    }
    
}

#pragma mark 设置需要不显示的操作
- (void )setBaseWillDisappear{
    [self changeBarToNewsColor:NO];
    [self setNavigationBarTransformProgress:NO];
    
    [JLGCustomViewController setNavBarStyle:UIStatusBarStyleLightContent target:self statusBarColor:[UIColor clearColor] backImageName:@"nav_image_icon"];
//    self.title = @"返回";//因为首页没有返回键，没有影响，主要是进入下一个网页的时候显示返回
    
}

- (void)setNavigationBarTransformProgress:(BOOL )progress
{//NO,显示头部，YES,隐藏头部
    
    if (![self isCurrentViewControllerVisible]) {//没有显示
        return;
    }
    
    if (self.isAlwaysKeepNarStatus) {//如果一直保持就不用变
        return;
    }
    
    [self navigationBarHidden:progress];
}

- (void)setStatusBarStyle:(UIStatusBarStyle )barStyle{
    
    //错误地址不设置颜色，首页加载的地址状态栏要变为黑色。web页面又是白色
    NSString *containErrorUrl = [NSString stringWithFormat:@"%@404", JGJWebDiscoverURL];
    
    if ([self isCurrentViewControllerVisible] && ![self.currentURL containsString:containErrorUrl]) {
        [[UIApplication sharedApplication] setStatusBarStyle:barStyle animated:NO];//设置颜色
    }
}

- (void)navigationBarHidden:(BOOL )hidden{
    self.navigationItem.hidesBackButton = hidden;
    UIView *topView = [self.view viewWithTag:MAX_CANON];
    
    if ([self.currentURL containsString:WebProject.absoluteString]) {//首页找帮手
        self.navigationController.navigationBarHidden = YES;
        
        CGRect webViewFrame = self.view.bounds;
        webViewFrame.origin.y = 0;
        webViewFrame.size.height -= 49;
        self.webView.frame = webViewFrame;
        
        [topView removeFromSuperview];
    }else if([self.currentURL containsString:WebNewLifeStr]){
        self.navigationController.navigationBarHidden = YES;
        
//        CGRect webViewFrame = self.view.bounds;
//        webViewFrame.origin.y = 0;
//        webViewFrame.size.height -= 29;
//        self.webView.frame = webViewFrame;
        
        [topView removeFromSuperview];
    }else if([self haveThirdWebAddress]){
        NSDictionary *thirdWebDic = [self haveThirdWebAddress];
        
        self.navigationController.navigationBarHidden = NO;
        BOOL isADWebAdress = ([self.currentURL rangeOfString:@"http://www.jiongtoutiao.com/m"].location !=NSNotFound);
        
        CGFloat offsetY = [thirdWebDic[@"offsetY"] integerValue];
        offsetY = 44; //设置44即可
        CGRect webViewFrame = self.view.bounds;
        webViewFrame.origin.y -= offsetY*TYGetUIScreenWidthRatio;
        webViewFrame.size.height += (isADWebAdress?1.8*TYGetUIScreenWidthRatio:1)*offsetY;
        self.webView.frame = webViewFrame;
        
        [topView removeFromSuperview];
    }else{//正常情况下的调用
//        if (hidden) {//隐藏头部
//            CGRect webViewFrame = self.view.bounds;
//            webViewFrame.size.height += 64;
//            self.webView.frame = webViewFrame;
//        }else{//显示头部
//            self.webView.frame = self.view.bounds;
//        }
//        
//        self.navigationController.navigationBarHidden = hidden;
        
        if (self.needCloseButton) {
            
            self.navigationController.navigationBarHidden = NO;
            
            if ([self.currentURL containsString:GamePlatform1758URL]) {
                
                [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.bottom.mas_offset(0);
                }];
            }
            
        }else {
            self.navigationController.navigationBarHidden = hidden;
        }
        
        if (hidden) {
            if (topView) {
                return ;
            }
            
            
            UIColor *topViewBackGroundColor = TYColorHex(0x2c2c32);

            topView = [[UIView alloc] initWithFrame:TYSetRect(0, 0, TYGetUIScreenWidth, 21)];
            topView.tag = MAX_CANON;
            topView.backgroundColor = topViewBackGroundColor;
//            [self.view addSubview:topView];
        }else if (topView) {
            [topView removeFromSuperview];
        }
    }
    
    [self setStatusBarColor];
}


- (void)setWebTitle:(NSString *)url{
    [super setWebTitle:url];

    if ([self.currentURL containsString:AboutUsURL]) {
        self.title = @"关于我们";
    }else if([self.currentURL containsString:ContactUsURL]){//联系我们
        self.title = @"联系我们";
    }else if ([TYPredicate isCheckUrl:self.currentURL] && self.webType == JGJWebTypeExternalThirdPartBannerType) {
        
//        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        
//        self.title = title;
    }
    [self updateNavigationItems];
}

-(void)updateNavigationItems{
    if (!self.needCloseButton) {
        return ;
    }
    
    if (self.webView.canGoBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem,self.closeButtonItem] animated:NO];
    }
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseWebViewDidStartLoad:(UIWebView *)webView{
    [self changeBarToNewsColor:[self.baseWebURL.absoluteString containsString:@"newlife/news"]];
    
}

- (void)subWebViewDidFinishLoad:(UIWebView *)webView {
    
    [UIView animateWithDuration:3 animations:^{
        
        self.cusNav.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self.cusNav removeFromSuperview];
    }];
}

- (BOOL )isNewLifeHome{
    BOOL isHome = NO;
    
    if ([self.baseWebURL.absoluteString containsString:NewLifeNewsURL]){
        isHome = ![self.baseWebURL.absoluteString isEqualToString:self.currentURL];
    }
    return isHome;
}

- (void)registerCallBack{
#if 0
    NSString *webViewHTMLCode = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    TYLog(@"webViewHTMLCode = %@",webViewHTMLCode);
#endif

    [self setNavigationBarTransformProgress:NO];//基本都要显示顶部的返回
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    if(([self.currentURL rangeOfString:MineInfoURL].location !=NSNotFound)){//我的资料
        [self setNavigationBarTransformProgress:YES];
        [self getUserInfoCallBack];
    }else if (([self.currentURL rangeOfString:ContactUsURL].location !=NSNotFound) || ([self.currentURL rangeOfString:AboutUsURL].location !=NSNotFound)) {//联系我们,关于我们修改版本号
        [self getVersionIOSCallBack];
        self.webView.dataDetectorTypes = UIDataDetectorTypeCalendarEvent;
        [self setNavigationBarTransformProgress:YES];//找帮手不用显示返回
    }else if([self.currentURL rangeOfString:DownLoadBillURL].location !=NSNotFound){
        [self downLoadBillCallBack];
        [self removeProgressView];
    }else if([self.currentURL rangeOfString:GameError].location !=NSNotFound){
        [self gameErrorCallBack];
    }else if([self.currentURL containsString:WebProjectList]){
        [self projectListCallBack];
//        [self setNavigationBarTransformProgress:YES];//记工报表不用显示返回
        self.navigationController.navigationBar.hidden = YES;
        self.statusBarImageView.hidden = YES;

        self.webView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
        
    }else if([self.currentURL rangeOfString:WebProject.absoluteString].location !=NSNotFound){
        [self projectCallBack];
        [self setNavigationBarTransformProgress:YES];//找帮手不用显示返回
        self.isAlwaysKeepNarStatus = YES;//保持状态
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }else if([self.currentURL containsString:WebStatistics]){

        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
        }];
        self.statusBarImageView.hidden = YES;
    }else if([self.currentURL rangeOfString:CommentsURL].location !=NSNotFound){//意见反馈
        [self commentsCallBack];
        [self setNavigationBarTransformProgress:YES];//找工作不用显示返回(1.1.0-yj)
    }else if([self.currentURL rangeOfString:ScoreWeb].location !=NSNotFound){//我的积分
        [self registerLogin];
        [self setNavigationBarTransformProgress:YES];//找工作不用显示返回(1.1.0-yj)
        self.isAlwaysKeepNarStatus = YES;//保持状态

        [self registerViewback];
    }else if([self.currentURL rangeOfString:JGJWebFindHelperURL].location !=NSNotFound){
        [self setNavigationBarTransformProgress:YES];//招聘不用显示返回(1.1.0-yj)
        [self projectCallBack];
    }else if(([self.currentURL rangeOfString:NewLifeURL].location !=NSNotFound)){//新生活
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
//        [self findCallBack];
//        [self bottomShowTabBar:YES];
        [self setNavigationBarTransformProgress:YES];
    }else if (self.webType == JGJWebTypeDynamic || self.webType == JGJWebTypeMyCollection) {
        [self projectCallBack];
        [self setNavigationBarTransformProgress:YES];//隐藏头子(2.1.0-yj)，隐藏底部
    }else if (self.webType == JGJWebTypeModifyAboutUs) {
        
        [self setNavigationBarTransformProgress:YES];
    }else if (self.webType == JGJWebTypeInnerURLType) {
        self.statusBarImageView.hidden = YES;
        [self setNavigationBarTransformProgress:YES];
    }else if (self.webType == JGJWebTypeMineInfo) {
    
        [self setNavigationBarTransformProgress:YES];
    }else if([self.currentURL rangeOfString:NewLifeNewsURL].location !=NSNotFound){
        [self setStatusBarStyle:UIStatusBarStyleDefault];
        [self newLifeCallBack];
        [self setNavigationBarTransformProgress:YES]; //2.1.0-yj
    }else if (self.webType == JGJWebTypeProDetailType) {
        
        [self setNavigationBarTransformProgress:YES];
        
        self.navigationController.navigationBarHidden = YES;
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
        }];
    }else if(self.webType == JGJWebTypeExternalThirdPartBannerType) {
        
        self.navigationController.navigationBar.hidden = NO;
        self.webView.frame = self.view.bounds;
    }
    
    

    
    //注册返回调用原生返回上一个app view页面
    [self registerViewback];
    
    //分享
    [self registerShowShareMenu];
    
    //返回首页
    [self registerGotoFirstPageForApp];
    
    
    [self projectCallBack];
    
    //很多界面都是有分享和举报，都开启监控
    [self shareAndReportJsCallBack];
        
    [self handleRegisterWebCreateChat];
    
    //注册登录
    [self registerLogin];
    
//    [self handleLoginInfo];
    
    [self setStatusBarColor];
    
    [self handleRegisterAppSet];
    
    [self handleRegisterupInfoState];
    
    //点击统计报表，同步按钮
    [self statisticsCallBack];
    
    //注册意见反馈
    [self commentsCallBack];
    
    [self findCallBack];
    
    [self registerGotoView];
    
    
#pragma mark - 服务商店
    [self serviceStoryMyOrderList];
    [self serviceStoryCommonBuy];

#pragma mark - 合伙人
    [self remainingSum];
    [self payment];
    
    //注册和H5交互地点
    
    [self regisGetLocation];
    
    //web查看图片
    
    [self registerPreviewImage];
    
    //注册扫二维码
    [self registersweepCode];
    
    //查看个人信息
    [self registerCheckPerson];
    
    //购买套餐
    [self appBuyCombo];

    if (![self.currentURL isEqualToString:[NSString stringWithFormat:@"%@404", JGJWebDiscoverURL]]) {
        
        [self registerFooter];
        
    }else {
        
        TYLog(@"404地址不注册底部");
    }
    
    //精彩小视频
    [self registerCreateDynamicVideo];
    
    //注册h5复制
    [self registerH5Copy];
    
    //注册保存图片
    [self registerH5SavePic];
    
    [self registerEditTelph];
    
    //查看通信录
    
    [self registerAddressBook];
    
    //注册工友圈未读数等0，H5通知原生清掉发现小红点

    [self registerDynamicMsgNum];
}

#pragma mark - 注册工友圈未读数等0，H5通知原生清掉发现小红点

- (void)registerDynamicMsgNum {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"registerDynamicMsgNum" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [TYNotificationCenter postNotificationName:JGJDynamicMsgNumNotify object:nil];
        
    }];
    
}

- (void)registerAddressBook {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"toAddressBook" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakself checkAddressBookBaseVc];
        
    }];
}

- (void)registerEditTelph {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"editTelph" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //点击评论回调
        weakself.responseCallback = responseCallback;
        
        [weakself modifyTel];
        
    }];
}

#pragma mark - 修改手机号
- (void)modifyTel {
    
    JGJModifyUserTelVc *modifyUserTelVc = [[JGJModifyUserTelVc alloc] init];
    
    [self.navigationController pushViewController:modifyUserTelVc animated:YES];
    
//    JGJmodifiPhoneViewController *changeToVc = [[UIStoryboard storyboardWithName:@"modifyphone" bundle:nil] instantiateViewControllerWithIdentifier:@"modifiPhoneVc"];
//    
//    [self.navigationController pushViewController:changeToVc animated:YES];
//    
//    TYWeakSelf(self);
//    
//    changeToVc.successBlock = ^(NSString *tel) {
//        
//        [weakself handleLoginInfo];
//        
//        weakself.responseCallback(tel);
//        
//    };
    
}

#pragma mark - 注册设置
- (void)handleRegisterAppSet {

    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"appSet" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        JGJMineSettingVc *settingVc = [[JGJMineSettingVc alloc] init];
        
        [weakSelf.navigationController pushViewController:settingVc animated:YES];
        
        settingVc.mineSettingVcBlock = ^{
          
            //返回时去掉闪烁
            [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
            
            weakSelf.navigationController.navigationBarHidden = YES;
        };
    }];
    
}

- (void)setStatusBarColor {
    
    if (self.webType == JGJWebTypeExternalThirdPartBannerType) {
        
        self.statusBarImageView.hidden = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
            make.bottom.mas_offset(0);
        }];
        
    }
    
    else if (![self.view.subviews containsObject:self.statusBarImageView]) {
        
        self.statusBarImageView.hidden = NO;
    }
    
}

#pragma mark - 原生登陆交互web刷新数据
- (void)handleLoginInfo {
    
    NSString *userToken = [TYUserDefaults objectForKey:JLGToken];
    NSString *os = @"I";
    NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
    NSDictionary *loginInfoDic = JLGisLoginBool ? @{@"os" : os,
                                                    @"token" : userToken?:@"",
                                                    @"infover" : @(infoVer),
                                                    } : @{};
    
    NSString *loginInfojson = [NSString getJsonByData:loginInfoDic];
    [self.webJSBridge callHandler:@"loginInfo" data:loginInfojson responseCallback:^(id responseData) {
        
        
    }];
    
    TYLog(@"infoVerloginInfojson-----%@", loginInfojson);
    
}

//注册返回
- (void)registerViewback {
    
    __weak typeof(self) weakSelf = self;
    //web调用native
    [self.webJSBridge registerHandler:@"viewBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //扫码设备进入返回首页
        if ([self.currentURL containsString:@"equipment/record"]) {
            
            //先切换在关闭
            
            JGJTabBarViewController *vc = (JGJTabBarViewController *)weakSelf.navigationController.parentViewController;
            
            if ([vc isKindOfClass:[JGJTabBarViewController class]]) {
                
                vc.selectedIndex = 0;
                
            }
            
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            
        } else if ([self.currentURL containsString:@"meeting"]) { //会议扫码返回到会议页面
            
            NSMutableArray *webViews = [NSMutableArray new];
            
            for (NSInteger index=0; index < self.navigationController.viewControllers.count; index++) {
                
                UIViewController *vc =  self.navigationController.viewControllers[index];
                
                if ([vc isKindOfClass:NSClassFromString(@"JGJWebAllSubViewController")]) {
                    
                    [webViews addObject:vc];
                    
                }
                
            }
            
            if (webViews.count > 1) {
                
                UIViewController *webVc = webViews.firstObject;
                
                [self.navigationController popToViewController:webVc animated:YES];
                
            }else if (webViews.count == 1) {
                
                 [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
        
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}

#pragma makr - h5跳转指定页面
- (void)registerGotoView {
    
    [self.webJSBridge registerHandler:@"goToView" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
             if ([data[@"name"] isEqualToString:@"JGJKnowRepoVc"]) {
                
                [self checkKnowRepoVc];
                
             }
        }
    }];
}

- (void)checkAddressBookBaseVc {
    
    UIViewController *addressBookBaseVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedAddressBookBaseVc"];
    
    [self.navigationController pushViewController:addressBookBaseVc animated:YES];
    
}

#pragma mark - 查看资料库
- (void)checkKnowRepoVc {
    
    JGJKnowRepoVc *knowBaseVc = [[UIStoryboard storyboardWithName:@"JGJKnowRepo" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJKnowRepoVc"];
    
    [self.navigationController pushViewController:knowBaseVc animated:YES];
}

- (void)registerCreateDynamicVideo {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"createDynamicVideo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        JGJVideoListModel *listModel = [JGJVideoListModel mj_objectWithKeyValues:(NSDictionary *)data];
        //点击评论回调
        weakself.responseCallback = responseCallback;
        
        [weakself createDynamicVideoWithListModel:listModel callBack:responseCallback];
    }];
    
}

- (void)registerH5Copy {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"copy" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        NSString *num = data[@"copyInfo"]?:@"";
        
        [pasteboard setString:num];
        
        [weakself openWXApp:num];
        
    }];
    
}

- (void)openWXApp:(NSString *)num {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = [NSString stringWithFormat:@"该微信号: %@ 已复制，请在微信中添加朋友时粘贴搜索",num];
    
    desModel.popTextAlignment = NSTextAlignmentCenter;
    
    desModel.contentViewHeight = 150;
    
    desModel.lineSapcing = 3;
    
    desModel.leftTilte = @"我知道了";
    
    desModel.rightTilte = @"打开微信";
    
    desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
    
    desModel.titleFont = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.onOkBlock = ^{
        
        //创建一个url，这个url就是WXApp的url，记得加上：//
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        
        //打开url
        [[UIApplication sharedApplication] openURL:url];
        
    };
    
}

- (void)registerH5SavePic {
    
    [self.webJSBridge registerHandler:@"screenshot" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self handleH5SavePic:responseCallback data:data];
        
    }];
    
}

#pragma mark - 精彩小视频
- (void)createDynamicVideoWithListModel:(JGJVideoListModel *)listModel callBack:(WVJBResponseCallback)callBack {
    
    JGJVideoListVc *videoListVc = [[JGJVideoListVc alloc] init];
    
    TYWeakSelf(self);
    
    videoListVc.navHiddenBlock = ^{
        
        [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
        
        weakself.navigationController.navigationBarHidden = YES;
    };
    
    videoListVc.responseCallback = callBack;
    
    videoListVc.listModel = listModel;
    
    [self.navigationController pushViewController:videoListVc animated:YES];
}

#pragma mark - 用户是否注册完善姓名
- (void)handleRegisterupInfoState {
    //web调用native
    [self.webJSBridge registerHandler:@"upInfoState" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL isRealName = [data[@"is_info"] boolValue];
        NSString *realName = data[@"realname"];
        if (isRealName || ![NSString isEmpty:realName]) {
            [TYUserDefaults setBool:YES forKey:JLGIsRealName];
        }
        
        MyWorkZone *myWorkZone  = [MyWorkZone mj_objectWithKeyValues:data];
        
        if (![NSString isEmpty:myWorkZone.headpic]) {
            [TYUserDefaults setObject:myWorkZone.headpic?:@"" forKey:JLGHeadPic];
        }
        
        if (![NSString isEmpty:myWorkZone.telph]) {
            
            [TYUserDefaults setObject:myWorkZone.telph?:@"" forKey:JLGPhone];
        }
        
        if (![NSString isEmpty:myWorkZone.realname]){
            
            [TYUserDefaults setObject:myWorkZone.realname?:@"" forKey:JGJUserName];
            
        } else if (![NSString isEmpty:myWorkZone.user_name]) {
            
            [TYUserDefaults setObject:myWorkZone.user_name forKey:JGJUserName];
            
        } else if (![NSString isEmpty:myWorkZone.nickname]) {
            
            [TYUserDefaults setObject:myWorkZone.nickname forKey:JGJUserName];
        }
        
        //添加H5使用的版本号，用于H5自己完善资料，告诉H5自己
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        
        [TYUserDefaults synchronize];
        
        TYLog(@"修改了用户信息-----%@", data);
        
    }];
}


#pragma mark - 处理创建单聊 2.1.2-yj
- (void)handleRegisterWebCreateChat {
    
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"createChat" handler:^(id data, WVJBResponseCallback responseCallback) {
        TYLog(@"发起聊天data===%@", data);
        JGJChatFindJobModel *chatModel = [JGJChatFindJobModel mj_objectWithKeyValues:data];
        
        if ([chatModel.page isEqualToString:@"job"]) {
            [JGJDataManager sharedManager].addFromType = JGJFriendAddFromFindJobs;
        } else if ([chatModel.page isEqualToString:@"dynamic"]) {
            [JGJDataManager sharedManager].addFromType = JGJFriendAddFromWorkmateCommunity;
        } else if ([chatModel.page isEqualToString:@"connection"]) {
            [JGJDataManager sharedManager].addFromType = JGJFriendAddFromConnection;
        }

        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        if ([myUid isEqualToString:chatModel.group_id]) {
            [TYShowMessage showSuccess:@"当前不能和自己聊天"];
            return ;
        }
        
        if (chatModel.is_chat) {
//            [weakSelf handleFindHelperChatWithChatFindJobModel:chatModel];
            
            [weakSelf handleH5ChatRecruitWithDic:data];
            
        }else {
            [weakSelf handleAddFriendWithChatModel:chatModel];
        }
    }];
}

#pragma mark - 找工作找项目单聊。满足条件是prodetailactive、searchuser其中一个有值。均没有值的时候不显示带过来的信息。如果is_chat等于0跳转到加朋友页面
- (void)handleFindHelperChatWithChatFindJobModel:(JGJChatFindJobModel *)chatFindJobModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    proListModel.chatfindJobModel = chatFindJobModel;
    proListModel.class_type = @"singleChat";
    //这句是保证group_id唯一性用了setter方法下个版本吧一起改
    proListModel.team_id = nil;
    proListModel.team_name = nil;
    proListModel.group_id = chatFindJobModel.group_id; //个人uid
    proListModel.group_name = chatFindJobModel.group_name;
    
    proListModel.is_find_job = YES;
    
    //能聊天 is_find_job都为YES,发送消息带上
    
    if (!chatFindJobModel.prodetailactive && !chatFindJobModel.searchuser) {
//        proListModel.is_find_job = NO;
        proListModel.isDynamic = YES; //是动态进入聊天，返回聊聊页面
    }
    chatRootVc.workProListModel = proListModel;
    [self.navigationController pushViewController:chatRootVc animated:YES];
    
    TYWeakSelf(self);
    
    chatRootVc.chatRootBackBlock = ^{
        
        weakself.webView.frame = weakself.view.bounds;
        
    };
}

#pragma mark - 跳转到加为朋友页面
- (void)handleAddFriendWithChatModel:(JGJChatFindJobModel *)chatModel {
    JGJAddFriendSendMsgVc *addFriendSendMsgVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendSendMsgVc"];
    JGJChatPerInfoModel *perInfoModel = [JGJChatPerInfoModel new];
    perInfoModel.uid = chatModel.group_id;
    perInfoModel.top_name = chatModel.group_name;
    addFriendSendMsgVc.perInfoModel = perInfoModel;
    [self.navigationController pushViewController:addFriendSendMsgVc animated:YES];
}

#pragma mark - gotoFirstPageForApp 首页
- (void)registerGotoFirstPageForApp {
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"gotoFirstPageForApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *msg = data[@"msg"];
        
        if (![NSString isEmpty:msg]) {
            
            if ([msg isEqualToString:@"已切换到该项目首页"]) {
                
                [TYShowMessage showSuccess:@"已切换到该项目首页，你可以在首页进行各模块的使用"];
                
            }
            
        }
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        weakSelf.tabBarController.selectedIndex = 0;
        
    }];
}

//注册分享
- (void)registerShowShareMenu {
    
    __weak typeof(self) weakSelf = self;
    //
    //隐藏分享成功提示
    //    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionTop];
    //web调用native
    [self.webJSBridge registerHandler:@"showShareMenu" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //type 0 普通分享 1朋友圈 2微信
            NSDictionary *dic = (NSDictionary *)data;
            
            JGJShowShareMenuModel *shareModel = [JGJShowShareMenuModel mj_objectWithKeyValues:dic];
            
            if (shareModel.type == 0) {
                
                TYLog(@"showShareMenu == %@", data);
                
                if (shareModel.topdisplay == 1){
                    JGJShareMenuView *shareMenuView = [[JGJShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                    
                    shareMenuView.Vc = self;
                    
                    [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
                    
                    shareMenuView.shareButtonPressedBlock = ^(JGJShareType type) {
                        
                        //                    [weakSelf handleRegisterMyScoreShare];
                        
                        //回调给H5
                        responseCallback(@{});
                        
                    };
                } else {
                    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                    
                    shareMenuView.Vc = self;
                    
                    [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
                    
                    shareMenuView.shareButtonPressedBlock = ^(JGJShareMenuViewType type) {
                        
                        //回调给H5
                        responseCallback(@{});
                        
                    };
                }
                
                
                
            }else {
                
                if (shareModel.topdisplay == 1) {
                    JGJShareMenuView *shareMenuView = [[JGJShareMenuView alloc] init];
                    
                    shareMenuView.shareMenuModel = shareModel;
                    
                    NSArray *snsNames = @[@"", @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatSession),  @(UMSocialPlatformType_QQ)];
                    
                    NSArray *snsNameTypes = @[@"0", @(JGJShareMenuViewWXType), @(JGJShareMenuViewWXChatType), @(JGJShareMenuViewQQType)];
                    
                    UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
                    
                    if (shareModel.type <= 3 && shareModel.type > 0) {
                        
                        platformType = [snsNames[shareModel.type] integerValue];
                        
                        shareMenuView.shareMenuViewType = [snsNameTypes[shareModel.type] integerValue];
                    }
                    
                    [shareMenuView shareInVc:weakSelf linkUrl:shareModel.url?:@"" platformType:platformType text:shareModel.describe?:@"" imageUrl:shareModel.imgUrl];
                    
                } else {
                    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] init];
                    
                    shareMenuView.shareMenuModel = shareModel;
                    //  weakSelf.shareMenuView = shareMenuView;
                    
                    NSArray *snsNames = @[@"", @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_WechatSession),  @(UMSocialPlatformType_QQ)];
                    
                    NSArray *snsNameTypes = @[@"0", @(JGJShareMenuViewWXType), @(JGJShareMenuViewWXChatType), @(JGJShareMenuViewQQType)];
                    
                    UMSocialPlatformType platformType = UMSocialPlatformType_WechatTimeLine;
                    
                    if (shareModel.type <= 3 && shareModel.type > 0) {
                        
                        platformType = [snsNames[shareModel.type] integerValue];
                        
                        shareMenuView.shareMenuViewType = [snsNameTypes[shareModel.type] integerValue];
                    }
                    
                    [shareMenuView shareInVc:weakSelf linkUrl:shareModel.url?:@"" platformType:platformType text:shareModel.describe?:@"" imageUrl:shareModel.imgUrl];
                }
                
            }
            
        });
    }];
}

#pragma mark - 我的积分

- (void)registerLogin {
    
    __weak typeof(self) weakSelf = self;
    //web调用native
    [self.webJSBridge registerHandler:@"login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
        
        [weakSelf.navigationController pushViewController:loginVC animated:YES];
        
    }];
    
}


- (void)LoadWebViewFailure{
    if (![self.baseWebURL.absoluteString containsString:GamePlatform1758URL]) {
        //如果不是游戏的界面，才需要显示失败
        [self.view addSubview:self.jlgLoadWebViewFailure];
    }
    [self setNavigationBarTransformProgress:NO];
}

- (NSDictionary *)haveThirdWebAddress{
    if (!self.currentURL) {
        return nil;
    }
    
    __block BOOL isHaveThirdWebAddress = NO;
    __block NSMutableDictionary *thirdWebURLDic = [NSMutableDictionary dictionary];
    [self.hiddenURLAddresses enumerateObjectsUsingBlock:^(NSDictionary *hiddenURLDic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.currentURL rangeOfString:hiddenURLDic[@"url"]].location !=NSNotFound) {
            isHaveThirdWebAddress = YES;
            thirdWebURLDic = hiddenURLDic.mutableCopy;
            *stop = YES;
        }
    }];
    
    return thirdWebURLDic.allKeys.count == 0?nil:thirdWebURLDic;
}

#pragma mark - 交朋友
#pragma mark 交朋友界面右边的按钮
- (void)makeFirendMessageBtnClick:(UIButton *)button{
    TYLog(@"交朋友界面右边的按钮");
}

#pragma mark 交朋友界面点击顶部的选项
- (void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    TYLog(@"UISegmentedControl 选中了第%@个",@(index));
}

#pragma mark - 修改资料
- (void)MineInfoCallBack{
    __weak typeof(self) weakSelf = self;

    self.context[@"changeHeadPicture"] = ^() {//更改头像
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.sheet showInView:weakSelf.view];
        });
    };
    
    self.context[@"changeHometown"] = ^() {//点击家乡
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            weakSelf.cityPickerView.onlyShowCitys = NO;
            weakSelf.cityPickerView.selectedAreaType = HometownType;
            [weakSelf.cityPickerView showCityPickerByIndexPath:indexPath];
        });
    };
    
    self.context[@"changeProjectType"] = ^() {//点击项目类型
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
            projectTypeVc.delegate = weakSelf;
            projectTypeVc.selectedSingle = NO;
            projectTypeVc.indexPath = indexPath;
            projectTypeVc.projectTypesArray = weakSelf.projectTypesArray;
            //        添加选择类型
            projectTypeVc.selectedType = ProjectType;
            [weakSelf.navigationController pushViewController:projectTypeVc animated:YES];
        });
    };
    
    self.context[@"changeJobTypeForIOS"] = ^(NSString *multi,NSString *jobs) {//点击工种
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *selectedArray = [jobs componentsSeparatedByString:@","];
            [selectedArray enumerateObjectsUsingBlock:^(NSNumber *selectedNum, NSUInteger idxOut, BOOL * _Nonnull stop) {
                for (NSInteger idxIn = idxOut; idxIn < weakSelf.workTypesArray.count; idxIn++) {
                    NSDictionary *obj = weakSelf.workTypesArray[idxIn];
                    if ([selectedNum integerValue] == [obj[@"id"] integerValue]) {
                        weakSelf.selectedArray[idxIn] = @(YES);
                        break;
                    }else if([weakSelf.selectedArray[idxIn] boolValue] != YES){
                        weakSelf.selectedArray[idxIn] = @(NO);
                    }
                }
            }];

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
            projectTypeVc.delegate = weakSelf;
            projectTypeVc.selectedSingle = NO;//多选
            projectTypeVc.indexPath = indexPath;
            projectTypeVc.projectTypesArray = weakSelf.workTypesArray;
            projectTypeVc.selectedArray = weakSelf.selectedArray;
            //添加选择类型
            projectTypeVc.selectedType = WorkType;
            [weakSelf.navigationController pushViewController:projectTypeVc animated:YES];
        });
    };
    
    self.context[@"changeExpectArea"] = ^() {//点击期望地址
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            weakSelf.cityPickerView.onlyShowCitys = YES;
            weakSelf.cityPickerView.selectedAreaType = ExpectAreaType;
            [weakSelf.cityPickerView showCityPickerByIndexPath:indexPath];
        });
    };
}

#pragma mark - 修改版本号的CallBack
- (void)getVersionIOSCallBack{
    //读取版本号
    NSString *versionNum = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSString stringWithFormat:@"(\'V %@\')",versionNum];
    
    NSString *jsFunctStr= [@"getVersionIOS" stringByAppendingString:currentVersion];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.context evaluateScript:jsFunctStr];
    });
}

#pragma mark - 退出登录的CallBack
- (void)exitLoginCallBack{
    __weak typeof(self) weakSelf = self;
    self.context[@"logout"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JLGHttpRequest_AFN PostWithApi:@"jlsignup/logout" parameters:nil success:^(id responseObject) {
                UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGLoginViewController"];
                [changeToVc setValue:@YES forKey:@"goToRootVc"];
                [weakSelf.navigationController pushViewController:changeToVc animated:YES];
            }];
        });
    };
}

#pragma mark - 个人主页的callBack
- (void )PersonDetailBack{
    __weak typeof(self) weakSelf = self;
    self.context[@"backToHomePage"] = ^() {//返回首页
        dispatch_async(dispatch_get_main_queue(), ^{
            JLGCustomViewController *customNavigationVc = (JLGCustomViewController *)weakSelf.navigationController;
            [customNavigationVc popWebViewControllerToHomeAnimated:YES];
        });
    };
}

#pragma mark - 拍照CallBack
- (void)phoneJsCallBack{
    __weak typeof(self) weakSelf = self;

    TYLog(@"注册");
    //拍照
    self.context[@"callPhonePhoto"] = ^(NSString *msgId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TYLog(@"拍照");
            [weakSelf.view endEditing:YES];
            [weakSelf.sheet showInView:weakSelf.view];
        });
    };
}

#pragma mark - 分享和举报callBack
- (void)shareAndReportJsCallBack{
    __weak typeof(self) weakSelf = self;
    //举报
    self.context[@"reportPersonForIOS"] = ^(NSString *uid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reportBtnClick:uid];
        });
    };
    
    //分享
    self.context[@"forkForIOS"] = ^(NSString *img,NSString *desc, NSString *title, NSString *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showShareBtnClick:img desc:desc title:title url:url];
        });
    };
}

#pragma mark - 下载账单callBack
- (void)downLoadBillCallBack{
    
    __weak typeof(self) weakSelf = self;
    //web调用native
    [self.webJSBridge registerHandler:@"showShareMenu" handler:^(id data, WVJBResponseCallback responseCallback) {
        __strong typeof(weakSelf) weakStrongSelf = weakSelf;
        TYLog(@"showShareMenu data: %@", data);
        responseCallback(@"Response from showShareBill");
        weakStrongSelf.jgjShareBillView = nil;//这里一定要清楚，暂时不明白为什么
        weakStrongSelf.jgjShareBillView.sharelinkUrl  = data[@"url"];
        weakStrongSelf.jgjShareBillView.shareText     = data[@"describe"];
        weakStrongSelf.jgjShareBillView.shareImageUrl = data[@"imgUrl"];
        [weakStrongSelf.jgjShareBillView showShareBillView];
    }];
}

#pragma mark - 游戏错误callBack
- (void)gameErrorCallBack{
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"gotoFirstPageForApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - 注册底部标签栏显示和隐藏
- (void)registerFooter {
    
    [self.webJSBridge registerHandler:@"footerController" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data[@"state"] isEqualToString:@"hide"]) {
            
            if (!self.isUnlogin) {
                
                [self hiddenTabBar:YES];
                self.isUnlogin = NO;
                
            }else {
                
                self.isUnlogin = NO;
            }
            
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_offset(0);
            }];
        }else if([data[@"state"] isEqualToString:@"show"]){
            [self hiddenTabBar:NO];
            self.isUnlogin = NO;
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                CGFloat heigth = self.tabBarController.tabBar.height;
                make.bottom.mas_offset(-heigth);
            }];
        }
        
        
    }];
}

#pragma mark - 找帮手的callBack
- (void)projectCallBack{
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"backToIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
//        weakSelf.isAlwaysKeepNarStatus = NO;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self.webJSBridge registerHandler:@"appCall" handler:^(id data, WVJBResponseCallback responseCallback) {
        [TYPhone callPhoneByNum:data view:self.view];
    }];
    
    [self.webJSBridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSDictionary *callBackData = @{@"provinceName":[TYUserDefaults objectForKey:JLGProvinceName]?:@"",
                                       @"cityName":[TYUserDefaults objectForKey:JLGCityName]?:@"",
                                       @"cityVal":[TYUserDefaults objectForKey:JLGCityWebNo]?:@""
                                       };
        
        NSString *recordJsonStr = [NSString getJsonByData:callBackData];
        responseCallback(recordJsonStr);
    }];
}

#pragma mark - 统计的callBack
- (void)projectListCallBack{
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"createProject" handler:^(id data, WVJBResponseCallback responseCallback) {
        TYLog(@"web创建项目");
        UIViewController *creatProCompanyVC = [[UIStoryboard storyboardWithName:@"JGJCreatPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatProCompanyVC"];
        [weakSelf.navigationController pushViewController:creatProCompanyVC animated:YES];
    }];
    
    [self.webJSBridge registerHandler:@"recordFrom" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        
        GuideImageType guideImageType;
        if ([data[@"type"] isEqualToString:@"record_work"]) {
            guideImageType = GuideImageTypeBill;
        }else if([data[@"type"] isEqualToString:@"use_work"]){
            guideImageType = GuideImageTypeRecord;
        }
        
        JGJGuideImageVc *guideImageVc = [[JGJGuideImageVc alloc] initWithImageType:guideImageType];
        
        if (weakSelf.skipToNextVc) {
            weakSelf.skipToNextVc(guideImageVc);
        }else{
            [weakSelf.navigationController pushViewController:guideImageVc animated:YES];
        }
    }];
    
    
//    添加来源人
    [self.webJSBridge registerHandler:@"addSyncData" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        weakSelf.addGroupMemberRequestModel.group_id = data[@"team_id"];
        
        TYLog(@"---------%@", data);
        
        JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
        JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
        synBillingCommonModel.synBillingTitle = @"添加数据来源人"; //多个地方共用这个模型
        addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
        JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
        commonModel.memberType = JGJProSourceMemberType; //当前人员为数据来源人类型
        addTeamMemberVC.delegate = weakSelf;
        addTeamMemberVC.commonModel = commonModel;
        addTeamMemberVC.groupMemberMangeType = JGJGroupMemberMangePushNotifyType;
        
        weakSelf.navigationController.navigationBar.hidden = NO;
        
        addTeamMemberVC.skipToNextVc = ^(UIViewController *vc){
        
            weakSelf.navigationController.navigationBar.hidden = YES;
            
        };
        
        [weakSelf.navigationController pushViewController:addTeamMemberVC animated:YES];
    }];
}

- (void)statisticsCallBack{
    self.navigationItem.rightBarButtonItem = nil;
    
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"syncBill" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        if ([NSString isEmpty:data[@"pid"]]) {
            [TYShowMessage showPlaint:@"当前项目pid为空!"];
            return;
        }
        if ([NSString isEmpty:data[@"pro_name"]]) {
            [TYShowMessage showPlaint:@"当前项目名不能为空!"];
            return;
        }
        JGJSynBillingManageVC *synBillingManageVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynBillingManageVC"];
         JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
        synBillingCommonModel.synBillingTitle = @"需同步项目的联系人";
        synBillingCommonModel.isWageBillingSyn = YES; //YES是项目同步给人

        WageMoreDetailInitModel *wageMoreDetailInitModel = [[WageMoreDetailInitModel alloc] init];
        wageMoreDetailInitModel.sync_id = data[@"pid"];
        
        wageMoreDetailInitModel.pro_name = data[@"pro_name"];
        synBillingManageVC.synBillingCommonModel = synBillingCommonModel;
        synBillingManageVC.wageMoreDetailInitModel = wageMoreDetailInitModel;
        
        weakSelf.navigationController.navigationBar.hidden = NO;
        synBillingManageVC.skipToNextVc = ^(UIViewController *vc){
        
            weakSelf.navigationController.navigationBar.hidden = YES;
        };
        
        if (weakSelf.skipToNextVc) {
    
            weakSelf.skipToNextVc(synBillingManageVC);
        }else{
            [weakSelf.navigationController pushViewController:synBillingManageVC animated:YES];
        }
        
    }];
    
    [self.webJSBridge registerHandler:@"checkBill" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (data[@"url"]) {
            NSURL *url = [NSURL URLWithString:[data[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:url.absoluteString];
            if (strongSelf.skipToNextVc) {
                strongSelf.skipToNextVc(webVc);
            }else{
                
                [strongSelf.navigationController pushViewController:webVc animated:YES];
            }
        }
    }];
    
    [self.webJSBridge registerHandler:@"recordFrom" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        
        GuideImageType guideImageType;
        BOOL isShowBottomButton = NO;
        if ([data[@"type"] isEqualToString:@"record_work"]) {
            guideImageType = GuideImageTypeBill;
        }else if([data[@"type"] isEqualToString:@"use_work"]){
            guideImageType = GuideImageTypeRecord;
            BOOL isHaveRecordFromData = [data[@"data"] integerValue];
            if (!isHaveRecordFromData) {
                isShowBottomButton = YES;
            }
        }
        
        JGJGuideImageVc *guideImageVc = [[JGJGuideImageVc alloc] initWithImageType:guideImageType];
        guideImageVc.isShowBottomButton = isShowBottomButton;
        guideImageVc.delegate = self;
        if (weakSelf.skipToNextVc) {
            weakSelf.skipToNextVc(guideImageVc);
        }else{
            [weakSelf.navigationController pushViewController:guideImageVc animated:YES];
        }
    }];
    
    
    [self.webJSBridge registerHandler:@"addSource" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(webViewAddSource:)]) {
            [weakSelf.delegate webViewAddSource:weakSelf];
        }
    }];
}

- (void)commentsCallBack{
    NSMutableDictionary *recordDic = [NSMutableDictionary dictionary];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    //应用的版本号和平台已经写入webView
    [recordDic setValue:@"iPhone" forKey:@"brand"];//品牌
    [recordDic setValue:[TYDeviceInfo getDeviceName] forKey:@"model"];//机型
    [recordDic setValue:systemVersion forKey:@"release"];//系统版本
    [recordDic setValue:@(TYGetUIScreenHeight) forKey:@"screenHeight"];//屏幕的高
    [recordDic setValue:@(TYGetUIScreenWidth) forKey:@"screenWidth"];//屏幕的宽
    
    [recordDic setValue:@([TYPermission isCanLocation]) forKey:@"location"];//定位
    [recordDic setValue:@([TYPermission isCanReadAddressBook]) forKey:@"addressbook"];//通讯录
    [recordDic setValue:@([TYPermission isCanCamera]) forKey:@"camera"];//照相
    [recordDic setValue:@([TYPermission isCanPhoto]) forKey:@"photo"];//相册
    [recordDic setValue:@([TYPermission isCanPush]) forKey:@"push"];//推送
    

    NSString *recordJsonStr = [NSString getJsonByData:recordDic];
    
    [self.webJSBridge registerHandler:@"getMobileInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseCallback(recordJsonStr);
        });
    }];
}

#pragma mark - 2.1.2临时添加
- (void)bottomShowTabBar:(BOOL)showTabBar {
    
    self.webView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 49);
}


- (void)hiddenTabBar:(BOOL )hiddenTabbar{
    if (self.tabBarController.tabBar.hidden != hiddenTabbar) {
        UIView *contentView;
        if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
            contentView = [self.tabBarController.view.subviews objectAtIndex:1];
        }else{
            contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        }
        
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
        self.tabBarController.tabBar.hidden = hiddenTabbar;
        
        //禁止显示底部标签
        if ([self forbidShowTabBar]) {
            
            self.tabBarController.tabBar.hidden = YES;
        }
        
#if 1
        //设置webview的frame
//        CGRect webViewFrame = self.view.bounds;
//        webViewFrame.origin.y = 0;
//        webViewFrame.size.height += ((hiddenTabbar?0:-41) - 49);
//        self.webView.frame = webViewFrame;
        
//        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.top.left.bottom.right.mas_equalTo(self.view);
//        }];
#else
        //设置webview的frame
        CGRect webViewFrame = self.webView.frame;
        webViewFrame.size.height += showTabbar?(-49):49;
        self.webView.frame = webViewFrame;
#endif
    }
}

#pragma mark - 发现callBack
- (void)findCallBack{
    __weak typeof(self) weakSelf = self;
    //web调用native
    [self.webJSBridge registerHandler:@"showCalendar" handler:^(id data, WVJBResponseCallback responseCallback) {
        __strong typeof(weakSelf) weakStrongSelf = weakSelf;
        
        JGJCalendarViewController *calendarVc = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCalendarViewController"];
        
        [weakStrongSelf.navigationController pushViewController:calendarVc animated:YES];
    }];
    
    [self.webJSBridge registerHandler:@"appLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        __strong typeof(weakSelf) weakStrongSelf = weakSelf;
        NSString *url = data[@"url"];
        
        JGJWebAllSubViewController *webVc;
        if ([data[@"title"] isEqualToString:@"玩游戏"]) {
            webVc = [[JGJWebAllSubViewController alloc] initWithUrl:[JGJCommonTool getGame1758PlatformURl]];
        }else if([data[@"title"] isEqualToString:@"资讯"]){
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeNewLifeNews];
        }else if([data[@"title"] isEqualToString:@"交朋友"]){
            if(!JLGIsRealName){
                return;
            }
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeMakeFriend];
        }
        
        
        //2.3.0添加外部地址
        
        if ([url rangeOfString:JGJWebDomainURL].location != NSNotFound && [url rangeOfString:@"topdisplay=1"].location != NSNotFound) {
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:url];
            
        }else if ([url rangeOfString:JGJWebDomainURL].location != NSNotFound) {
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
            
        } else{

            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:data[@"url"]];

        }
        
        NSString *title = data[@"title"];
        
        if (![NSString isEmpty:title]) {
            
            webVc.title = title;
        }
        
        self.navigationController.navigationBarHidden = NO;
        webVc.webView.frame = self.view.bounds;
        webVc.needCloseButton = YES;
        [weakStrongSelf.navigationController pushViewController:webVc animated:YES];
    }];
}

#pragma mark - 2.0添加我的资料
- (void)getUserInfoCallBack {
    JGJViewController *tabVC = self.navigationController.viewControllers[0];

    if (![tabVC isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
//    if (!_isOnlyOnce) {
//        LeftMenuVC *leftMenuVc = [tabVC.viewControllers lastObject];
//        
//        MyWorkLeaderZone *myWorkLeaderZone = leftMenuVc.myWorkLeaderZone;
//        myWorkLeaderZone.headpic = [JLGHttpRequest_IP stringByAppendingString:myWorkLeaderZone.headpic?:@""];
//        
//        NSDictionary *userInfoDic = [myWorkLeaderZone mj_keyValues];
//        if (userInfoDic) {
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfoDic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *userInfojsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            
//            [self.webJSBridge callHandler:@"getUserInfo" data:userInfojsonString responseCallback:^(id responseData) {
//            }];
//            _isOnlyOnce = YES;
//        }
//    }

    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"backPrev" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            JLGCustomViewController *customNavigationVc = (JLGCustomViewController *)weakSelf.navigationController;
            [customNavigationVc popWebViewControllerToHomeAnimated:YES];
        });
    }];
    
//    修改头像
    [self getUserHeaderImageCallBack];
}

- (void)getUserHeaderImageCallBack {
    __weak typeof(self) weakSelf = self;
    [self.webJSBridge registerHandler:@"changeHeader" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback) {
            [weakSelf.sheet showInView:weakSelf.view];
        }
    }];
}

- (void)newLifeCallBack{
    if (![self isNewLifeHome]) {
        self.navigationItem.rightBarButtonItem = nil;
        return ;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareArticle)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:JGJNavBarFont], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    //通用的分享
    self.context[@"shareArticle"] = ^(NSString *firstImg,NSString *desc, NSString *title, NSString *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showShareBtnClick:firstImg desc:desc title:title url:url];
        });
    };
}

#pragma mark - delegate
#pragma mark 选择完项目
- (void)JLGProjectTypeVc:(JLGProjectTypeViewController *)workTypeVc SelectedArray:(NSArray *)selectedArray dataDic:(NSDictionary *)dataDic{
    
    NSString *dataCode = dataDic[@"id"];
    NSString *dataName = dataDic[@"name"];
    workTypeVc.delegate = nil;
    
    //返回项目类型
    NSString *dataType = [NSString stringWithFormat:@"(\'%@\',\'%@\')",dataName,dataCode];
    NSString *jsFunctStr;
    if (workTypeVc.indexPath.row == 1) {
        jsFunctStr= [@"getProjectType" stringByAppendingString:dataType];
    }else{
        jsFunctStr= [@"getJobType" stringByAppendingString:dataType];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.context evaluateScript:jsFunctStr];
    });
}

#pragma mark - 选择完城市
- (void)JLGCityPickerSelect:(NSDictionary *)cityDic byIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        //返回的家乡
        NSString *homeTown = [NSString stringWithFormat:@"(\'%@\',\'%@\')",cityDic[@"cityName"],cityDic[@"cityCode"]];
        NSString *jsFunctStr= [@"getHometown" stringByAppendingString:homeTown];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.context evaluateScript:jsFunctStr];
        });
    }else if(indexPath.row == 3){
        //返回的工作地
        NSString *homeTown = [NSString stringWithFormat:@"(\'%@\',\'%@\')",cityDic[@"cityName"],cityDic[@"cityCode"]];
        NSString *jsFunctStr= [@"getExpectArea" stringByAppendingString:homeTown];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.context evaluateScript:jsFunctStr];
        });
    }
}


#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    if(buttonIndex == 0){//照相
//        if (SIMULATOR) {
//            
//        }else if (SIMULATOR){
//        
//        
//        
//        }
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }
    else if(buttonIndex == 1){//相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

    }else{
    
    
    }
    
    //显示图片选择器
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    NSData *imageData = UIImageJPEGRepresentation(image,JLGHttpImageJPEGRepQuality);
    NSString *imagebase64 = [imageData base64EncodedStringWithOptions:0];

    imagebase64 = [NSString stringWithFormat:@"%@%@", @"data:image/jpeg;base64,", imagebase64];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"headpic":imagebase64} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *userInfojsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.webJSBridge callHandler:@"sureChangeHeader" data:userInfojsonString responseCallback:^(id responseData) {
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 举报
- (void )reportBtnClick:(NSString *)msgId{//暂时没有实现
    JGJReportViewController *reportViewController = [[UIStoryboard storyboardWithName:@"FindProject" bundle:nil] instantiateViewControllerWithIdentifier:@"reportVc"];
    reportViewController.pid = msgId;
    [self.navigationController pushViewController:reportViewController animated:YES];
}

#pragma mark - 分享
- (void )showShareBtnClick:(NSString *)img desc:(NSString *)desc title:(NSString *)title url:(NSString *)url
{
//    NSString *shareText = [NSString stringWithFormat:@"%@ %@",title,desc];
//
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    //分享的图片
//    __block UIImage *shareImage;
//    NSURL *shareImageURL = [NSURL URLWithString:img];
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
//        [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengApp_KEY shareText:nil shareImage:shareImage shareToSnsNames:nil delegate:self];
//
//        //微信
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = desc;
//
//        //朋友圈
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareText;
//        //        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = desc;
//
//        //QQ
//        [UMSocialData defaultData].extConfig.qqData.url = url;
//        [UMSocialData defaultData].extConfig.qqData.title = title;
//        [UMSocialData defaultData].extConfig.qqData.shareText = desc;
//
//        //分享到Qzone内容
//        [UMSocialData defaultData].extConfig.qzoneData.url = url;
//        [UMSocialData defaultData].extConfig.qzoneData.title = title;
//        [UMSocialData defaultData].extConfig.qzoneData.shareText = desc;
//    }];
}

#pragma mark 下载账单界面下载账单
- (void )ShareBillDownLoadBtnClick:(JGJShareBillView *)jgjShareBillView{

    //native调用web
    [self.webJSBridge callHandler:@"saveToPicture" data:nil responseCallback:^(id responseData) {
        //可以不调用
        NSString *urlString = (NSString *)responseData;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];// 取得图片
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        
        [image saveToAlbum:appName completionBlock:^{
            [TYShowMessage showSuccess:@"已保存到手机相册"];
        } failureBlock:^(NSError *error) {
            [TYShowMessage showPlaint:@"保存图片失败"];
        }];
    }];
}

#pragma mark - JGJAddTeamMemberDelegate
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    NSMutableArray *sourceMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamsMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        [sourceMembersInfos addObject:membersModel];
    } //获取姓名和电话
     self.addGroupMemberRequestModel.source_members = sourceMembersInfos;
    
    self.addGroupMemberRequestModel.class_type = @"team";
    
     NSString *source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
    
    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"source_members"]];
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupAddSourceMemberURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        self.navigationController.navigationBar.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - JGJGuideImageVcDelegate
- (void)guideImageVcWithguideImageVc:(JGJGuideImageVc *)guideImageVc didSelectedFooterView:(UIView *)footerView {
//    JGJWebAllSubViewController *recordWebViewVc = [[JGJWebAllSubViewController alloc] initWithUrl:[NSURL URLWithString:[StatisticsDemoWebURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    JGJWebAllSubViewController *recordWebViewVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:StatisticsDemoWebURL];
    recordWebViewVc.title = @"示例报表";
    [guideImageVc.navigationController pushViewController:recordWebViewVc animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)workTypesArray
{
    if (!_workTypesArray) {
        _workTypesArray = [[TYFMDB searchTable:TYFMDBWorkTypeName] mutableCopy];
    }
    return _workTypesArray;
}

- (NSMutableArray *)projectTypesArray
{
    if (!_projectTypesArray) {
        _projectTypesArray = [[TYFMDB searchTable:TYFMDBProjectName] mutableCopy];
    }
    return _projectTypesArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
        [self.workTypesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _selectedArray[idx] = @(NO);
        }];
    }
    return _selectedArray;
}

- (JLGCityPickerView *)cityPickerView
{
    if (!_cityPickerView) {
        _cityPickerView = [[JLGCityPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _cityPickerView.delegate = self;
        _cityPickerView.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] delegate].window addSubview:_cityPickerView];
    }
    return _cityPickerView;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"老乡",@"同行",nil];
        //初始化UISegmentedControl
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        CGRect segmentedFrame = _segmentedControl.frame;
        segmentedFrame.size.width = 140;
        _segmentedControl.frame= segmentedFrame;
        
        _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        _segmentedControl.tintColor = JGJMainColor;
        [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 70, 30);
        // 让按钮内部的所有内容左对齐
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_rightButton setImage:[UIImage imageNamed:@"BarButton_makeFirendMessage"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(makeFirendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


- (UIActionSheet *)sheet
{
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    return _sheet;
}
- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (JGJShareBillView *)jgjShareBillView
{
    if (!_jgjShareBillView) {
        _jgjShareBillView = [[JGJShareBillView alloc] initWithFrame:TYGetUIScreenRect];
        _jgjShareBillView.delegate = self;
        _jgjShareBillView.Vc = self;
    }
    return _jgjShareBillView;
}

- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    if (!_addGroupMemberRequestModel) {
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.is_qr_code = @"0";
    }
    return _addGroupMemberRequestModel;
}

- (NSArray *)hiddenURLAddresses {
    
    if (!_hiddenURLAddresses) {
        _hiddenURLAddresses = @[@{@"offsetY":@82,@"url":@"http://m.tv.sohu.com/"},
                                @{@"offsetY":@60,@"url":@"http://m.ireadercity.com/webapp/home/index.html"},
                                @{@"offsetY":@86,@"url":@"http://www.jiongtoutiao.com/m"}];
    }
    return _hiddenURLAddresses;
}

#pragma mark - JGJCustomShareMenuViewDelegate
- (void)customShareMenuViewWithMenuView:(JGJCustomShareMenuView *)menuView shareMenuModel:(JGJShowShareMenuModel *)shareMenuModel {
    
    NSString * dynamicStr = [NSString stringWithFormat:@"dynamic/publish?type=%@&id=%@", shareMenuModel.dynamic.type, shareMenuModel.dynamic.dynamicId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public, dynamicStr]];
    JGJWebAllSubViewController *dynamicWebVc = [[JGJWebAllSubViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:dynamicWebVc animated:YES];
    [menuView hiddenCustomShareMenuView];
}


#pragma mark - 服务商店我的订单
-(void)serviceStoryMyOrderList
{
    typeof(self) __weak weakself = self;

    [self.webJSBridge registerHandler:@"myOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        JGJServiceStroeViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJServiceStroeViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJServiceStroeVC"];
        [weakself.navigationController pushViewController:WorkReportVC animated:YES];
    }];
}
#pragma mark - 购买套餐
-(void)appBuyCombo
{
    //    typeof(self) __weak weakself = self;
    
    JGJWeiXin_pay * weiXin_pay = [JGJWeiXin_pay sharedManager];
    
    [self.webJSBridge registerHandler:@"appPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        JGJAppBuyCombo *ComboModel = [JGJAppBuyCombo mj_objectWithKeyValues:data];
        
        JGJOrderListModel *orderListModel = [[JGJOrderListModel alloc]init];
        
        orderListModel.pay_type = ComboModel.pay_type;
        
        ComboModel.record_id = [ComboModel.record_id stringByReplacingOccurrencesOfString:@";"withString:@"&"];
        
        if ([ComboModel.pay_type isEqualToString:@"2"]) {
            //支付宝支付
            [weiXin_pay doAlipayPaypayCode:ComboModel.record_id andmodel:orderListModel];
        }else{
        
            JGJweiXinPaymodel *payModel = [JGJweiXinPaymodel mj_objectWithKeyValues:ComboModel.record_id];
            //微信支付
            PayReq* req             = [[PayReq alloc] init];
            
            req.partnerId           = payModel.partnerid;//商户id
            
            req.prepayId            = payModel.prepayid;//订单号
            
            req.nonceStr            = payModel.noncestr;//随机字符串
            
            req.timeStamp           = payModel.timestamp;//时间戳
            
            req.package             = payModel.package;
            
            req.sign                = payModel.sign;
            
            weiXin_pay.payId        = payModel.prepayid;
            
            //保存订单号
            payModel.order_sn          = payModel.order_sn;
            if (!weiXin_pay.orderListmodel) {
                weiXin_pay.orderListmodel = [[JGJOrderListModel alloc]init];
            }
            weiXin_pay.orderListmodel = orderListModel;
            [WXApi sendReq:req];
        }
        
        weiXin_pay.paysuccess = ^(JGJOrderListModel * model) {
            
            NSDictionary *callBackDic = @{@"state" :@(1)};
            
            if (!model.paySucees) {
                
                callBackDic = @{@"state" :@(0)};
                
            }
            
            NSString *bugStatusJson = [NSString getJsonByData:callBackDic];
            
            responseCallback(bugStatusJson);
        };
    }];
}
#pragma mark - 服务商店  立即订购
-(void)serviceStoryCommonBuy
{
    typeof(self) __weak weakself = self;
    [self.webJSBridge registerHandler:@"orderNow" handler:^(id data, WVJBResponseCallback responseCallback) {
        JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
        SureOrderListVC.GoodsType = VIPServiceType;
        [weakself.navigationController pushViewController:SureOrderListVC animated:YES];
    }];
    
}

#pragma mark - 余额提现
-(void)remainingSum
{
    [self.webJSBridge registerHandler:@"withdrawal" handler:^(id data, WVJBResponseCallback responseCallback) {
        typeof(self) __weak weakself = self;
        JGJRemainingSumViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJRemainingSumViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJRemainingSumVC"];
        [weakself.navigationController pushViewController:SureOrderListVC animated:YES];
    }];
}
#pragma mark - 保证金
-(void)payment
{
    typeof(self) __weak weakself = self;
    [self.webJSBridge registerHandler:@"deposit" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        JGJCashDepositViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJCashDepositViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCashDepositVC"];
        [weakself.navigationController pushViewController:SureOrderListVC animated:YES];
 
    }];
    
}

#pragma mark - 注册和H5交互位置
- (void)regisGetLocation {

    NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *city = [TYUserDefaults objectForKey:JLGCityName];
    
    NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
    
    NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
    
    NSString *province = [TYUserDefaults objectForKey:JLGProvinceName];
    
    [self.webJSBridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *callBackDic = @{@"adcode" : adcode?:@"",
                                      
                                      @"city" : city?:@"",
                                      
                                      @"lat" : lat?:@"",
                                      
                                      @"lng" : lng ?:@"",
                                      
                                      @"province" : province?:@""
                                      
                                      };
        
        responseCallback(callBackDic);
        
    }];

}

- (void)registersweepCode {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"sweepCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        weakself.responseCallback = responseCallback;
        
        JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];

        jgjQRCodeVc.QRCodeVcBlock = ^{
          
            [JLGCustomViewController setStatusBarBackgroundColor:TYColorHex(0x2e2d33)];
            
            weakself.webView.frame = weakself.view.bounds;
            
            weakself.navigationController.navigationBarHidden = YES;
        };
        
        [weakself.navigationController pushViewController:jgjQRCodeVc animated:YES];
        
    }];
}

#pragma mark - 查看个人信息
- (void)registerCheckPerson {
    
    TYWeakSelf(self);
    
    [self.webJSBridge registerHandler:@"returnPerson" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        
        perInfoVc.jgjChatListModel.uid = data[@"uid"];
        
        perInfoVc.jgjChatListModel.group_id = data[@"uid"];
        
        perInfoVc.jgjChatListModel.class_type = @"singleChat";
        
        [weakself.navigationController pushViewController:perInfoVc animated:YES];
        
    }];
}

#pragma mark - 注册保存图片
- (void)handleH5SavePic:(WVJBResponseCallback)callback data:(id)data{
    
    //type 0 普通分享 1朋友圈 2微信
    NSDictionary *dic = (NSDictionary *)data;
    
    JGJShowShareMenuModel *shareModel = [JGJShowShareMenuModel mj_objectWithKeyValues:dic];
    
    if (!shareModel) {
        
        shareModel = [[JGJShowShareMenuModel alloc] init];
    }
    
    shareModel.is_show_savePhoto = YES;
    
    if (shareModel.type == 0) {
        
        TYLog(@"showShareMenu == %@", data);
        if (shareModel.topdisplay == 1) {
            JGJShareMenuView *shareMenuView = [[JGJShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
            
            shareMenuView.Vc = self;
            
            [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
            
            shareMenuView.shareButtonPressedBlock = ^(JGJShareType type) {
                
                //                    [weakSelf handleRegisterMyScoreShare];
                
                //回调给H5
                callback(@{});
                
            };
        } else {
            
            JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
            
            shareMenuView.Vc = self;
            
            [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
            
            shareMenuView.shareButtonPressedBlock = ^(JGJShareMenuViewType type) {
                
                //                    [weakSelf handleRegisterMyScoreShare];
                
                //回调给H5
                callback(@{});
                
            };
        }
        
        
        
    }
    
    //    UIImage *image = [UIImage viewHightSnapshot:self.view withInRect:CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth,  self.view.height - JGJ_NAV_HEIGHT)];
    //
    //    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //
    //    [image saveToAlbum:appName completionBlock:^{
    //
    //        [TYShowMessage showSuccess:@"保存成功"];
    //
    //        callback(@"");
    //
    //    } failureBlock:^(NSError *error) {
    //
    //        [TYShowMessage showError:@"保存图片失败"];
    //    }];
    
}

#pragma mark - 注册查看web图片
- (void)registerPreviewImage {
    
    [self.webJSBridge registerHandler:@"previewImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSArray *imageUrls = data[@"imgData"];
        
        NSString *imgDiv =  data[@"imgDiv"];
        
        NSString *imgIndexStr = [NSString stringWithFormat:@"%@", data[@"imgIndex"]];
        
        NSInteger imgIndex = [imgIndexStr integerValue];
        
        NSMutableArray *imageArray = [NSMutableArray new];
        
        NSMutableArray *imageMergeUrls = [NSMutableArray new];
        
        for (NSInteger index = 0; index < imageUrls.count; index++) {
            
            UIImageView *imageView = [UIImageView new];
            
            [imageArray addObject:imageView];
            
            NSString *url = [NSString stringWithFormat:@"%@%@", imgDiv,imageUrls[index]];
            
            [imageMergeUrls addObject:url];
            
        }
        
        [JGJCheckPhotoTool webBrowsePhotoImageView:imageMergeUrls selImageViews:imageArray didSelPhotoIndex:imgIndex];
        
    }];
}

#pragma mark - 包含以下控制器禁止显示底部
- (BOOL)forbidShowTabBar {
    
  __block  BOOL isHidden = NO;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:NSClassFromString(@"JGJViewController")]) {
                
                UITabBarController *tabVc = (UITabBarController *)vc;
                
                for (UIViewController *nextVc in tabVc.viewControllers) {
                    
                    if ([nextVc isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
                        
                        JLGCustomViewController *cusVc = (JLGCustomViewController *)nextVc;
                        
                        for (UIViewController *thirdVc in cusVc.viewControllers) {
                            
                            if ([thirdVc isKindOfClass:NSClassFromString(@"JGJChatRootCommonVc")]) {
                                
                                isHidden = YES;
                                
                                TYLog(@"聊天底部不显示标签------- %@", thirdVc);
                                
                                break;
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
//            });
    
    return isHidden;
    
}

@end
