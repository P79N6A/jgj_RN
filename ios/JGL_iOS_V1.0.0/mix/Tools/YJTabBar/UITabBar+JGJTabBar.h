//
//  UITabBar+JGJTabBar.h
//  mix
//
//  Created by yj on 17/2/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (JGJTabBar)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
