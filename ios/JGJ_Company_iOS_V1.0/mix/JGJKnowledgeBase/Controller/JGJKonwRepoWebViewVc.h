//
//  JGJKonwRepoWebViewVc.h
//  mix
//
//  Created by yj on 17/4/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RxWebViewController.h"
@interface JGJKonwRepoWebViewVc : UIViewController

@property (nonatomic, copy) NSString *webUrlString;

@property (nonatomic, copy) NSString *saveUrl;

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel; //知识库顶部模型，外面主要用id

//是否隐藏收藏按钮
@property (nonatomic, assign) BOOL isHiddenColleclBtn;

//是否隐藏底部按钮
@property (nonatomic, assign) BOOL isHiddenBottomBtn;

@end
