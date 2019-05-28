//
//  HWEmotionTabBar.h
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//  表情键盘底部的选项卡

#import <UIKit/UIKit.h>

typedef enum {
//    HWEmotionTabBarButtonTypeRecent, // 最近
    HWEmotionTabBarButtonTypeDefault, // 默认
    HWEmotionTabBarButtonTypeEmoji, // emoji
//    HWEmotionTabBarButtonTypeLxh, // 浪小花
    HWEmotionTabBarSendButtonType, // 发送
} HWEmotionTabBarButtonType;

@class HWEmotionTabBar;

@protocol HWEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(HWEmotionTabBar *)tabBar didSelectButton:(HWEmotionTabBarButtonType)buttonType;
@end

@interface HWEmotionTabBar : UIView
@property (nonatomic, weak) id<HWEmotionTabBarDelegate> delegate;

//输入框是否有文字,有文字变成红色
@property (nonatomic, assign) BOOL isHaveText;
@end
