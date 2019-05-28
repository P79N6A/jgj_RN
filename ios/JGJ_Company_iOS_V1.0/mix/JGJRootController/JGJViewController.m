//
//  JGJLeaderViewController.m
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJViewController.h"
#import "JGJUnLoginAddNameHUBView.h"
//班组长内容
#define TabBarLeaderTitleArray @[@"吉工宝",@"消息", @"招劳务", @"发现",@"我"]

#define TabBarLeaderImagesArray @[@"icon_work_default",@"icon_message_default",@"icon_home_recruitment_default", @"icon_found_default",@"icon_me_default",]

#define TabBarLeaderSelectedImagesArray @[@"icon_work_selected",@"icon_message_selected", @"icon_home_recruitment_selected", @"icon_found_selected", @"icon_me_selected"]

@interface JGJViewController ()
@property (nonatomic, strong) JGJBaseWebViewController *findHelperWebVc;
@end

@implementation JGJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workType = workLeaderCellType;
}

- (void)subVcSetDic{
//    [self.vcsArr insertObject:self.findHelperWebVc atIndex:2];
    
    self.viewControllersDic = @{
                                @"vcTitles":TabBarLeaderTitleArray,
                                @"vcImages":TabBarLeaderImagesArray,
                                @"vcSelectedImages":TabBarLeaderSelectedImagesArray,
                                }.mutableCopy;
}

- (JGJBaseWebViewController *)findHelperWebVc
{    //找帮手
    
    if (!_findHelperWebVc) {
        //1.1.0找帮手
        NSURL *findHelperUrl = [NSURL URLWithString:JGJWebFindHelperURL];
        _findHelperWebVc = [[JGJWebAllSubViewController alloc] initWithUrl:findHelperUrl];
    }
    return _findHelperWebVc;
}


#pragma mark - 点击下面的按钮
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

//去掉点击聊聊真实姓名填写
//    if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
//        BOOL isRight = [self checkIsRight];
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
