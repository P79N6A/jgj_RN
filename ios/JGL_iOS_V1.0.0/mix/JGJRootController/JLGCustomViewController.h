//
//  JLGCustomViewController.h
//  mix
//
//  Created by Tony on 16/1/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RxWebViewNavigationViewController.h"

typedef void(^JLGCustomVcBlock)(id);

typedef void(^JLGCustomVcCancelBlock)(id);

@interface JLGCustomViewController : RxWebViewNavigationViewController

@property (copy, nonatomic) JLGCustomVcBlock customVcBlock;

//点击取消按钮回调
@property (copy, nonatomic) JLGCustomVcCancelBlock customVcCancelButtonBlock;

/**
 *  登录以后是否需要返回rootVc
 */
@property (nonatomic,assign) BOOL loginBackGoToRootVc;

/**
 *  获取一般情况下的返回按键
 *
 *  @return 一般情况刚下的返回按键
 */
- (UIButton *)getLeftButton;

- (UIButton *)getLeftNoTargetButton;
/**
 *  获取白色下的返回按键
 *
 *  @return 一般情况刚下的返回按键
 */
- (UIButton *)getWhiteLeftButton;

- (UIButton *)getWhiteLeftNoTargetButton;

- (UIBarButtonItem *)getLeftBarButton;

- (UIBarButtonItem *)getWhiteLeftBarButton;

/**
 *  检查是否登录，没有登录就弹出提示框
 *
 *  @return NO:没登录,YES:有登录
 *  
 
 SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
 if (![self.navigationController performSelector:checkIsLogin]) {
 return ;
 }
 
 SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
 IMP imp = [self.navigationController methodForSelector:checkIsLogin];
 BOOL (*func)(id, SEL) = (void *)imp;
 if (!func(self.navigationController, checkIsLogin)) {
 return ;
 }
 
 sel,imp传参数的时候的使用示例
 SEL selector = NSSelectorFromString(@"processRegion:ofView:");
 IMP imp = [_controller methodForSelector:selector];
 CGRect (*func)(id, SEL, CGRect, UIView *) = (void *)imp;
 CGRect result = func(_controller, selector, someRect, someView);
 */
-(BOOL )checkIsLogin;
    
/**
 *  检查是否有权限，没有权限就弹出提示框
 *
 *  @return NO:没权限,YES:有权限
 *
 SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
 if (![self.navigationController performSelector:checkIsInfo]) {
 return ;
 }
 */
- (BOOL )checkIsInfo;

- (BOOL )checkIsRealName;
@end
