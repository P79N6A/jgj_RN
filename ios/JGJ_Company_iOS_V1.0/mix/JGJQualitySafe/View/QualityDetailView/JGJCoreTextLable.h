//
//  JGJCoreTextLable.h
//  mix
//
//  Created by YJ on 2017/10/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZLinkLabel.h"

#import "YYText.h"

@interface JGJCoreTextModel : NSObject

@property (nonatomic, strong) UIColor *contentColor;

@property (nonatomic, strong) UIFont *contentFont;

@property (nonatomic, strong) UIColor *changeColor;

//改变颜色的字体
@property (nonatomic, copy) NSString *changeStr;

//改变颜色的字体
@property (nonatomic, strong) UIFont *changeStrFont;

@end

typedef void(^JGJCoreTextCopyActionBlock)();

@interface JGJCoreTextLable : YYLabel

//是否能够复制
@property (nonatomic, assign) BOOL isCanCopy;

@property (nonatomic, copy) JGJCoreTextCopyActionBlock copyBlock;

//默认设置颜色15 颜色 333333
- (void)setContentTextlinkAttCoreTextModel:(JGJCoreTextModel *)coreTextModel contentText:(NSString *)contentText;

/**
 *传入宽度内容字体获得高度
 */
- (CGFloat)stringWithContentWidth:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace changeStr:(NSString *)changeStr changeColor:(UIColor *)changeColor;

//行高
@property (nonatomic, assign) CGFloat lineSpace;
@end
