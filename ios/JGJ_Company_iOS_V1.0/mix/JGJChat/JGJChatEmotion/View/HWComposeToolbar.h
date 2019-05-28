//
//  HWComposeToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HWComposeToolbarButtonTypeCamera, // 拍照
    HWComposeToolbarButtonTypePicture, // 相册
    HWComposeToolbarButtonTypeMention, // @
    HWComposeToolbarButtonTypeTrend, // #
    HWComposeToolbarButtonTypeEmotion // 表情
} HWComposeToolbarButtonType;

@class HWComposeToolbar;

@protocol HWComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(HWComposeToolbar *)toolbar didClickButton:(HWComposeToolbarButtonType)buttonType;
@end

@interface HWComposeToolbar : UIView
@property (nonatomic, weak) id<HWComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
