//
//  JLGLoginViewController.h
//  mix
//
//  Created by jizhi on 15/11/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  登录

#import <UIKit/UIKit.h>

typedef void(^HandleWebViewRefreshBlock)(UIViewController *currentVc, BOOL isRefresh);
@interface JLGLoginViewController : UIViewController
@property (nonatomic,assign) BOOL goToRootVc;
@property (nonatomic,weak) UIViewController *backVc;
@property (nonatomic, copy) HandleWebViewRefreshBlock handleWebViewRefreshBlock; //返回是否需要刷新页面，重新传cook给H5页面
@end
