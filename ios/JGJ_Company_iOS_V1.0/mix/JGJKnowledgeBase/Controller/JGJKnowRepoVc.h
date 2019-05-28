//
//  JGJKnowRepoVc.h
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZDisplayViewController.h"

@interface JGJKnowRepoVc : UIViewController

@property (nonatomic, strong) NSMutableArray *childVcRequestModels;

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel;//首页进入当前页面对比模型

@end
