//
//  JGJKnowRepoChildVc.h
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJKnowRepoChildVc : UIViewController

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel; //知识库顶部模型，外面主要用id

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseRequestModel; //获取列表模型

@property (nonatomic, assign) BOOL isRepeatClickChildVc; //是否重复点击
//刷新网络数据
- (void)knowRepoChildVcFreshNetData;

@end
