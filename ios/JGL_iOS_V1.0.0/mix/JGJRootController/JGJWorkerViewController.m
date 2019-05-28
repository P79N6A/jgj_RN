//
//  JGJWorkerViewController.m
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerViewController.h"
#import "JGJUnLoginAddNameHUBView.h"
//工人内容
#define TabBarWorkerTitleArray @[@"记工",@"消息",@"找活招工",@"发现",@"我"]

#define TabBarWorkerImagesArray @[@"tab-work-record",@"tab-message",@"tab-recruitment",@"tab-discovery",@"tab-mine"]
#define TabBarWorkerSelectedImagesArray @[@"tab-work-record-selected",@"tab-message-selected",@"tab-recruitment-selected",@"tab-discovery-selected",@"tab-mine-selected"]


@interface JGJWorkerViewController ()
@property (nonatomic, strong) JGJBaseWebViewController *findHelperWebVc;
@end

@implementation JGJWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workType = workCellType;
}

- (void)subVcSetDic{
//    [self.vcsArr replaceObjectAtIndex:2 withObject:self.findHelperWebVc];
    self.viewControllersDic = @{
                                @"vcTitles":TabBarWorkerTitleArray,
                                @"vcImages":TabBarWorkerImagesArray,
                                @"vcSelectedImages":TabBarWorkerSelectedImagesArray,
                                }.mutableCopy;
}

- (JGJBaseWebViewController *)findHelperWebVc
{    //找帮手
    if (!_findHelperWebVc) {
        _findHelperWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeRecruitJob];
    }
    return _findHelperWebVc;
}

#pragma mark - 点击下面的按钮
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
}

@end
