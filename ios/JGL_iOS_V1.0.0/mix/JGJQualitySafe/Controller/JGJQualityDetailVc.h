//
//  JGJQualityDetailVc.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPhotoViewController.h"

@interface JGJQualityDetailVc : UIPhotoViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) JGJQualitySafeListModel *listModel;

//区分质量和安全
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@property (nonatomic, strong) NSArray *principalModels;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, assign) BOOL isWorkListCommonIn;
//获取数据
- (void)loadNetData;
@end
