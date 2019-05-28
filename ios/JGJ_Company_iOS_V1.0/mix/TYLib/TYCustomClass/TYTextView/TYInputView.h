//
//  TYInputView.h
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChatInputViewH 65

#define ChatTabbarSafeBottomMargin (TYIST_IPHONE_X ? -34 : 0)

@class HWEmotion;

@interface TYInputView : UITextView

/**
 *  textView最大字数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfWords;

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  textView最大文字高度
 */
@property (nonatomic, assign) NSUInteger maxTextLineHeight;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^ty_textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^ty_textReturn)(TYInputView *textView);

/**
 *  文字改变block →
 *  block参数(text) → 文字内容
 */
@property (nonatomic, strong) void(^ty_textChange)(TYInputView *textView,NSString *text,NSString *changeText);

/**
 *  文字删除block →
 *  block参数(text) → 文字内容
 */
@property (nonatomic, strong) void(^ty_textDelete)(TYInputView *textView);

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *  占位文字字体大小
 */
@property (nonatomic, assign) CGFloat placeholderFontSize;

/**
 *  是否可以滑动
 */
@property (nonatomic, assign) BOOL canScorll;

/**
 *  是否可以换行
 */
@property (nonatomic, assign) BOOL canReturn;

/**
 *  触摸事件
 */
@property (nonatomic, weak) UIResponder *inputNextResponder;

/**
 *  当前是否是删除状态
 */
@property (nonatomic, assign) BOOL isDelStatus;

/**
 *  menu菜单用
 */
@property (nonatomic, strong) UITableViewCell *targetCell;

/**
 *  插入表情
 */
- (void)insertEmotion:(HWEmotion *)emotion;

/**
 *  是否显示草稿
 */
@property (nonatomic, assign) BOOL isShowDraft;

@end
