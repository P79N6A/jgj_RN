
//
//  RxWebViewNavigationViewController.h
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RxWebViewNavigationViewController : UINavigationController

/**
 *  由于 popViewController 会触发 shouldPopItems，因此用该布尔值记录是否应该正确 popItems
 */
@property (nonatomic,assign) BOOL shouldPopItemAfterPopViewController;

/**
 *  当webView的根返回到最外层的时候需要调用
 *
 *  @param animated 是否需要动画
 *
 *  @return 返回的viewController
 */
- (UIViewController*)popWebViewControllerToHomeAnimated:(BOOL)animated;


/**
 *  WebView使用的时候，判断是否可以用于返回
 *
 *  @param webView 需要判断的WebView
 *
 *  @return 是否需要返回
 */
- (BOOL )WebVcGoBackNoAlpha:(UIWebView *)webView;
@end
