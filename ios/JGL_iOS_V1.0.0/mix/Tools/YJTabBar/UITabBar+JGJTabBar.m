//
//  UITabBar+JGJTabBar.m
//  mix
//
//  Created by yj on 17/2/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "UITabBar+JGJTabBar.h"
#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0
#define TabbarBadgeWH 8.0
@implementation UITabBar (JGJTabBar)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = TabbarBadgeWH / 2.0;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, TabbarBadgeWH, TabbarBadgeWH);//圆形大小为8
    [self addSubview:badgeView];
}


//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}


//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
