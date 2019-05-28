//
//  JGJBaseWebViewController.h
//  mix
//
//  Created by Tony on 16/4/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
//提示信息
#import "TYShowMessage.h"
#import "JGJAllWebURL.h"
#import "UIViewController+isVisible.h"

#define WebNewLifeStr @"find?city="

@class JLGLoadWebViewFailure;
@interface JGJBaseWebViewController : UIViewController
<
    UIWebViewDelegate
>
@property (nonatomic,copy)   NSURL *baseWebURL;
@property (nonatomic,copy)   NSString *currentURL;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) UIButton *leftButton;

//是否到底部
@property (nonatomic, assign) BOOL isBottom;

@property (nonatomic,strong) JLGLoadWebViewFailure *jlgLoadWebViewFailure;

@property (nonatomic, strong) UIImageView *statusBarImageView;

//2.3.4添加用于首页广告点进去底部高度少于标签栏高度问题
@property (nonatomic, assign) BOOL isHiddenTabbar;

-(instancetype)initWithUrl:(NSURL *)url;

- (void)loadWebView;

/**
 *  获取红色的返回按钮
 *
 *  @return 返回的按钮
 */
- (UIBarButtonItem *)getLeftBarButton;

/**
 *  获取白色的返回按钮
 *
 *  @return 返回的按钮
 */
- (UIBarButtonItem *)getWhiteLeftBarButton;

/**
 *  设置标题
 */
- (void)setWebTitle:(NSString *)url;

/**
 *  设置将要显示的状态
 */
- (void)setBaseWillAppear;

/**
 *  设置不要显示的状态
 */
- (void )setBaseWillDisappear;

/**
 *  设置要显示的状态
 */
- (void )setBaseDidAppear;

/**
 *  设置不要显示的状态
 */
- (void )setBaseDidDisappear;

/**
 *  不同页面注册不同的CallBack
 */
- (void)registerCallBack;


/**
 *  加载失败的操作，给子类重写
 */
- (void)LoadWebViewFailure;

/**
 *  删除顶部加载的网络进度条
 */
- (void)removeProgressView;

/**
 *  刚开始加载的操作
 *
 *  @param webView 
 */
- (void)baseWebViewDidStartLoad:(UIWebView *)webView;

/**
 *  返回操作
 */
- (void)WebVcGoBack;

//子控制器使用与现实头部结束
- (void)subWebViewDidFinishLoad:(UIWebView *)webView;

@end
