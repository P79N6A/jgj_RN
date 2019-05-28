//
//  JGJEmotion.h
//  JGJCompany
//
//  Created by yj on 2017/10/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#ifndef JGJEmotion_h
#define JGJEmotion_h

//#define IQKEYBOARDMANAGER_DEBUG (1)

#import "NSString+Emoji.h"

#import "UITextView+Extension.h"

#import "HWEmotion.h"

#import "HWEmotionKeyboard.h"

#define IphoneXOffset (JGJ_IphoneX_Or_Later ? 35 : 0.0)

#define EmotionKeyboardHeight 225

#define EmotionKeyboardY  TYGetUIScreenHeight - EmotionKeyboardHeight - 64 - IphoneXOffset

// 通知中心
#define HWNotificationCenter [NSNotificationCenter defaultCenter]

#ifdef DEBUG // 处于开发阶段
#define HWLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define HWLog(...)
#endif

// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HWRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 通知
// 表情选中的通知
#define HWEmotionDidSelectNotification @"HWEmotionDidSelectNotification"
#define HWSelectEmotionKey @"HWSelectEmotionKey"
// 删除文字的通知
#define HWEmotionDidDeleteNotification @"HWEmotionDidDeleteNotification"

#endif /* JGJEmotion_h */
