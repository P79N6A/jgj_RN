//
//  HWEmotionKeyboard.h
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//  表情键盘（整体）: HWEmotionListView + HWEmotionTabBar

#import <UIKit/UIKit.h>

#import "HWEmotionTabBar.h"

typedef void(^HWEmotionKeyboardSendBlock)(id);

@interface HWEmotionKeyboard : UIView

@property (nonatomic, copy) HWEmotionKeyboardSendBlock emotionKeyboardSendBlock;

/** tabbar */
@property (nonatomic, weak) HWEmotionTabBar *tabBar;

@end
