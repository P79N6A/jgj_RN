//
//  RxWebViewNavigationViewController.m
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import "RxWebViewNavigationViewController.h"
#import "RxWebViewController.h"
#import "JGJBaseWebViewController.h"
#import "JGJWebMsgsViewController.h"

@interface RxWebViewNavigationViewController ()<UINavigationBarDelegate>


@end

@implementation RxWebViewNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPopItemAfterPopViewController = NO;
}

- (void)setShouldPopItemAfterPopViewController:(BOOL)shouldPopItemAfterPopViewController{
    _shouldPopItemAfterPopViewController =shouldPopItemAfterPopViewController;
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popViewControllerAnimated:animated];
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToViewController:viewController animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToRootViewControllerAnimated:animated];
}

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
//    TYLog(@"topViewController = %@,should = %d",self.topViewController,self.shouldPopItemAfterPopViewController);
    //! 如果应该pop，说明是在 popViewController 之后，应该直接 popItems
    if (self.shouldPopItemAfterPopViewController) {
        self.shouldPopItemAfterPopViewController = NO;
        return YES;
    }

    //! 如果不应该 pop，说明是点击了导航栏的返回，这时候则要做出判断区分是不是在 webview 中
    if ([self.topViewController isKindOfClass:[RxWebViewController class]]) {
        RxWebViewController* webVC = (RxWebViewController*)self.viewControllers.lastObject;
        return [self WebVcGoBack:webVC.webView];
    }else if ([self.topViewController isKindOfClass:[JGJBaseWebViewController class]]) {
        JGJBaseWebViewController *webVC= (JGJBaseWebViewController*)self.viewControllers.lastObject;
        return [self WebVcGoBack:webVC.webView];
    }else if ([self.topViewController isKindOfClass:[JGJWebMsgsViewController class]]) {
        JGJWebMsgsViewController *webMsgsVc= (JGJWebMsgsViewController*)self.viewControllers.lastObject;
        JGJBaseWebViewController *webVC= [webMsgsVc getSubWebVc];
        return [self WebVcGoBack:webVC.webView];
    }else{
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

- (BOOL )WebVcGoBack:(UIWebView *)webView{
    if (webView.canGoBack) {
        [webView goBack];
        
        //!make sure the back indicator view alpha back to 1
        self.shouldPopItemAfterPopViewController = NO;
        [[self.navigationBar subviews] lastObject].alpha = 1;
        return NO;
    }else{
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

- (BOOL )WebVcGoBackNoAlpha:(UIWebView *)webView{
    if (webView.canGoBack) {
        [webView goBack];
        
        self.shouldPopItemAfterPopViewController = NO;
        return NO;
    }else{
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

#pragma mark - 当webView的根返回到最外层的时候需要调用
- (UIViewController*)popWebViewControllerToHomeAnimated:(BOOL)animated{
    UIViewController *viewController = [self popViewControllerAnimated:animated];
    self.shouldPopItemAfterPopViewController = NO;
    return viewController;
}

@end
