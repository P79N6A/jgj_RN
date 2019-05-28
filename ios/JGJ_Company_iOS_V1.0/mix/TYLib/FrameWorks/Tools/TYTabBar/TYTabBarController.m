//
//  TYTabBarController.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "TYTabBarController.h"

@implementation TYTabBarController

- (void)tabBarItemImageColorH:(UIColor *)colorH ColorL:(UIColor *)colorL
{
    self.colorH = colorH;
    self.colorL = colorL;
    //如果是7.0以下就不用设置
    if (iOSVersion < 7.0) {
        return ;
    }

    //设置tabBar的图片和文字的状态
    for (UIViewController *childVc in self.childViewControllers) {
            //使用原始图片
            childVc.tabBarItem.selectedImage = [childVc.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
            // 设置文字的样式
            //普通状态
            NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
            textAttrs[NSForegroundColorAttributeName] = self.colorL;
        
            //选中状态
            NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
            selectTextAttrs[NSForegroundColorAttributeName] = self.colorH;

            [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
            [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
        }

}
@end
