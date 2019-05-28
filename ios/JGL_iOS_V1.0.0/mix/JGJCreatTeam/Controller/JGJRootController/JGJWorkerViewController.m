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
#define TabBarWorkerTitleArray @[@"吉工家",@"消息",@"找工作",@"发现",@"我"]

#define TabBarWorkerImagesArray @[@"icon_work_default",@"icon_message_default",@"icon_fonudjob_default",@"icon_found_default",@"icon_me_default"]

#define TabBarWorkerSelectedImagesArray @[@"icon_work_selected",@"icon_message_selected",@"icon_fonudjob_selected",@"icon_found_selected",@"icon_me_selected"]

@interface JGJWorkerViewController ()
@property (nonatomic, strong) JGJBaseWebViewController *findHelperWebVc;
@end

@implementation JGJWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workType = workCellType;
}

- (void)subVcSetDic{
    [self.vcsArr replaceObjectAtIndex:2 withObject:self.findHelperWebVc];
    self.viewControllersDic = @{
                                @"vcTitles":TabBarWorkerTitleArray,
                                @"vcImages":TabBarWorkerImagesArray,
                                @"vcSelectedImages":TabBarWorkerSelectedImagesArray,
                                }.mutableCopy;
}

- (JGJBaseWebViewController *)findHelperWebVc
{    //找帮手
    if (!_findHelperWebVc) {
        _findHelperWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeFindJob];
    }
    return _findHelperWebVc;
}

#pragma mark - 点击下面的按钮
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
//        BOOL isRight = [self checkDidSeledtedGroupChatIsRight];
//        if (!isRight) {
//            [JGJUnLoginAddNameHUBView handleSkipVc:@"JGJContactedListVc"];
//            [TYUserDefaults setObject:@(self.selectedIndex) forKey:JGJTabBarSelectedIndex];
//            [TYUserDefaults synchronize];
//            return isRight;
//        }
//    }
    return YES;
}

@end
