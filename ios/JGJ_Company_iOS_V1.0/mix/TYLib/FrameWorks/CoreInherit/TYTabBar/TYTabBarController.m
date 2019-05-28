//
//  TYTabBarController.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "TYTabBarController.h"

@implementation TYTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tabBarItemImage];
}

- (void)tabBarItemImage
{
    //如果是7.0以下就不用设置
    if (iOSVersion < 7.0) {
        return ;
    }
    
    TYLog(@"iOS系统版本号 %.2f",iOSVersion);
    //设置tabBar的图片和文字的状态
    for (UIViewController *childVc in self.childViewControllers) {
            childVc.tabBarItem.selectedImage = [childVc.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
            // 设置文字的样式
            //普通状态
            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
            textAttrs[NSForegroundColorAttributeName] = ColorRGB(123, 123, 123);
        
            //选中状态
            NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
            selectTextAttrs[NSForegroundColorAttributeName] = ColorHex(0x080808);

            [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
            [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        }

}
@end
