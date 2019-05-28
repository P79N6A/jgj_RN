//
//  JGJBaseWebViewController.m
//  mix
//
//  Created by Tony on 16/4/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBaseWebViewController.h"
#import "Masonry.h"
#import "JLGLoadWebViewFailure.h"//网页加载失败
#import "JLGCustomViewController.h"
#import "AFNetworking.h"


//#define WebViewDebugLog //打开这个宏就可以查看调试的信息

//#define DefineNJKWebViewProgress YES//是否使用进度条

#import "NJKWebViewProgress.h"

#ifdef DefineNJKWebViewProgress
//进度条
//#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#endif

static const CGFloat maxTimeoutInterval = 10.0f;//网页加载超时时间

@interface JGJBaseWebViewController ()
<

    NJKWebViewProgressDelegate,

#ifdef DefineNJKWebViewProgress
//    NJKWebViewProgressDelegate,
#endif
    JLGLoadWebViewFailureDelegate,

    UIScrollViewDelegate
>

@property (strong,nonatomic) NJKWebViewProgress *progressProxy;

#ifdef DefineNJKWebViewProgress
//@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
#endif

@end

@implementation JGJBaseWebViewController

#pragma mark - init
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        self.baseWebURL = url;

        [self setWebTitle:self.baseWebURL.absoluteString];
    }
    return self;
}

- (void )viewDidLoad {
    [super viewDidLoad];
//    [self.webView addSubview: self.statusBarImageView];
    [self.view addSubview:self.webView];
    
    CGFloat bottom = self.isHiddenTabbar ? 0 : -49;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        
        make.left.right.mas_equalTo(self.view);
        
        make.bottom.mas_offset(bottom);
        
    }];
    [self loadWebView];

    self.navigationItem.leftBarButtonItem = [self getLeftBarButton];
}

- (UIBarButtonItem *)getLeftBarButton{
    JLGCustomViewController *navVc = (JLGCustomViewController *)self.navigationController;
    UIButton *leftButton = [navVc getLeftNoTargetButton];
    [leftButton addTarget:self action:@selector(WebVcGoBack) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc ] initWithCustomView:leftButton];
}

- (UIBarButtonItem *)getWhiteLeftBarButton{
    JLGCustomViewController *navVc = (JLGCustomViewController *)self.navigationController;
    UIButton *whiteLeftButton = [navVc getWhiteLeftNoTargetButton];
    [whiteLeftButton addTarget:self action:@selector(WebVcGoBack) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc ] initWithCustomView:whiteLeftButton];
}

- (void)WebVcGoBack{
    JLGCustomViewController *navVc = (JLGCustomViewController *)self.navigationController;
    BOOL isGoBack =[navVc WebVcGoBackNoAlpha:self.webView];
    TYLog(@"网页是否返回:%@",(isGoBack?@"返回":@"直接到首页"));
}
          
#pragma mark - 加载网页
- (void)loadWebView{
    
#ifdef DefineNJKWebViewProgress
    self.webView.delegate = self.progressProxy;
    [self.navigationController.navigationBar addSubview:self.progressView];
#endif
    [self loadRequest];
}

- (void)loadRequest{
    //延迟显示出加载动画
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
//        [TYShowMessage showHUBWithMessage:@"加载中,请稍候" WithView:self.webView];
//    });
    
#if 0 //打印cookie
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:self.baseWebURL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;

    while (cookie = [enumerator nextObject]) {
#if 0
        if ([cookie.name isEqualToString:@"Authorization"]) {
            [cookie setValue:[NSString stringWithFormat:@"I+%@",[TYUserDefaults objectForKey:JLGToken]] forKey:cookie.name];
        }
        continue;
#endif
        TYLog(@"cookie = %@",cookie);
    }
#endif
    NSURLRequest *request = [NSURLRequest requestWithURL:self.baseWebURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:maxTimeoutInterval];//超时时间5秒
    
    //个人设置的时候延迟0.4秒，免得出现头部裂开的问题
    if ([[self.baseWebURL absoluteString] rangeOfString:MineInfoURL].location !=NSNotFound){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //加载地址数据
            [self.webView loadRequest:request];
        });
    }else{
        //加载地址数据
        [self.webView loadRequest:request];
    }
}

- (void )viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setBaseWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setBaseWillDisappear];
    
#ifdef DefineNJKWebViewProgress
    [self removeProgressView];
#endif
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setBaseDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self setBaseDidDisappear];
}

//设置需要显示的操作
- (void )setBaseWillAppear{

}

//设置需要不显示的操作
- (void )setBaseWillDisappear{

}

//设置需要显示的操作
- (void )setBaseDidAppear{
    
}

//设置不需要显示的操作
- (void )setBaseDidDisappear{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //状态栏的高度即可
    [scrollView setContentOffset:CGPointMake(0, -JGJ_StatusBar_Height) animated:NO];
    
}

- (void)dealloc{
    if (self.webView.delegate) {
        self.webView.delegate = nil;
    }
}

//子类的操作
- (void)baseWebViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    TYLog(@"开始加载");
    [self baseWebViewDidStartLoad:webView];
}

#pragma mark - 网页加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.navigationController.navigationBar setShadowImage:nil];//恢复原始的线

//    [TYShowMessage hideHUBWithView:self.webView];
    
    if (self.jlgLoadWebViewFailure) {
        [self.jlgLoadWebViewFailure removeFromSuperview];
        self.jlgLoadWebViewFailure.delegate = nil;
        self.jlgLoadWebViewFailure = nil;
    }
    
    //获取当前的JS环境
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //当前的URL
    self.currentURL = webView.request.URL.absoluteString;
    [self setWebTitle:self.currentURL];
    [self registerCallBack];
    
    [self subWebViewDidFinishLoad:webView];
    
    TYLog(@"当前的URL:%@",self.currentURL);
#ifdef WebViewDebugLog
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    TYLog(@"%@",HTMLSource);
#endif
}

- (void)subWebViewDidFinishLoad:(UIWebView *)webView {
    
    
}

#pragma mark - 设置标题
- (void)setWebTitle:(NSString *)url{
    //标题
//    self.navigationController.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    
//
//    if ([url containsString:WebProject.absoluteString]) {
//        self.navigationController.title = @"找帮手";
//    }else if([url containsString:WebNewLifeStr]){
//        self.navigationController.title = @"发现";
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    TYLog(@"加载失败:%@",self.currentURL);
//    [TYShowMessage hideHUD]; //1.1.0-yj注释掉因为会拦截加载
//    [self LoadWebViewFailure];
}

#pragma mark - 加载失败的操作，给子类重写
- (void)LoadWebViewFailure{

}

#pragma mark - 加载webView时候后，点击重新刷新
- (void)LoadWebViewFailureRefresh{
    TYLog(@"刷新试试");
    [self loadRequest];
}

- (void)registerCallBack{
    //不同页面的CallBack
}

#pragma mark - 后退
- (void )backButtonPush {
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

- (void)removeProgressView{
#ifdef DefineNJKWebViewProgress
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
#endif
}

#ifdef DefineNJKWebViewProgress
#pragma mark - NJKWebViewProgressDelegate 进度条的代理
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.jlgLoadWebViewFailure) {
        [self.jlgLoadWebViewFailure removeFromSuperview];
        self.jlgLoadWebViewFailure.delegate = nil;
        self.jlgLoadWebViewFailure = nil;
    }
    
#ifdef DefineNJKWebViewProgress
    self.progressView = nil;
#endif
}

#pragma mark - 懒加载
-(UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];

        _webView.delegate = (id)self;
        _webView.scalesPageToFit = YES;
//        _webView.scrollView.bounces = NO;
        
        //         H5控制(去掉这个方法 scrollViewDidScroll:,_webView.scrollView.bounces = NO)
        _webView.scrollView.delegate = self;
        
        _webView.backgroundColor = TYColorHex(0xfafafa);
    }
    return _webView;
}

- (JLGLoadWebViewFailure *)jlgLoadWebViewFailure
{
    if (!_jlgLoadWebViewFailure) {
        _jlgLoadWebViewFailure = [[JLGLoadWebViewFailure alloc] initWithFrame:self.view.bounds];
        _jlgLoadWebViewFailure.delegate = self;
        _jlgLoadWebViewFailure.backgroundColor = JGJMainBackColor;
    }
    return _jlgLoadWebViewFailure;
}

#ifdef DefineNJKWebViewProgress
-(NJKWebViewProgress*)progressProxy{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = (id)self;
        _progressProxy.progressDelegate = (id)self;
    }
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView
{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}
#endif


- (UIImageView *)statusBarImageView {
    
    if (!_statusBarImageView) {
        
        _statusBarImageView = [UIImageView new];
        _statusBarImageView.hidden = YES;
        _statusBarImageView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 21);
        _statusBarImageView.image = [UIImage imageNamed:@"statusbar_icon"];
//        [self.webView addSubview:_statusBarImageView];
        //       [self.view insertSubview:_statusBarImageView belowSubview:self.navigationController.navigationBar];
        
    }
    
    return _statusBarImageView;
}

@end
