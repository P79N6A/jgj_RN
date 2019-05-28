//
//  JGJLeaderViewController.m
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJLeaderViewController.h"
#import "JGJUnLoginAddNameHUBView.h"
//班组长/工头内容
#define TabBarLeaderTitleArray @[@"吉工家",@"消息",@"招聘",@"发现",@"我"]

#define TabBarLeaderImagesArray @[@"icon_work_default",@"icon_message_default",@"icon_home_recruitment_default",@"icon_found_default",@"icon_me_default"]

#define TabBarLeaderSelectedImagesArray @[@"icon_work_selected",@"icon_message_selected",@"icon_home_recruitment_selected",@"icon_found_selected",@"icon_me_selected"]

@interface JGJLeaderViewController ()
@property (nonatomic, strong) JGJBaseWebViewController *findHelperWebVc;
@end

@implementation JGJLeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workType = workLeaderCellType;
}

- (void)subVcSetDic{
//    [self.vcsArr insertObject:self.findHelperWebVc atIndex:2];
    [self.vcsArr replaceObjectAtIndex:2 withObject:self.findHelperWebVc];
    self.viewControllersDic = @{
                                @"vcTitles":TabBarLeaderTitleArray,
                                @"vcImages":TabBarLeaderImagesArray,
                                @"vcSelectedImages":TabBarLeaderSelectedImagesArray,
                                }.mutableCopy;
}

- (JGJBaseWebViewController *)findHelperWebVc
{    //招聘
    
    if (!_findHelperWebVc) {
        _findHelperWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeRecruitJob];
    }
    return _findHelperWebVc;
}


#pragma mark - 点击下面的按钮
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
////        return [self checkIsRight];//班组长/工头招聘去掉权限
//    }else if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
//        BOOL isRight = [self checkDidSeledtedGroupChatIsRight];
//        [JGJUnLoginAddNameHUBView handleSkipVc:@"JGJContactedListVc"];
//        return isRight;
//    }
    
    //用于首页默认身份点击切换招聘地址  self.tabBarController.selectedIndex = 2首页代码
    if ([viewController isKindOfClass:[JGJWebAllSubViewController class]] && tabBarController.selectedIndex == 2) {
        
        JGJWebAllSubViewController *webVc = (JGJWebAllSubViewController *)viewController;
    
        webVc.isCanChangeRecruURL = YES;
    }
    
    return YES;
}

@end
