//
//  TYAnimate.h
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TYAnimateBlock)(void);

@interface TYAnimate : UIView
/**
 *  显示view的动画
 *
 *  @param shoView     需要显示的view
 *  @param frame       刚出现的frame
 *  @param hiddenFrame 结束以后的frame
 *  @param animateBlock 动画结束后的block
 */
+ (void)showWithView:(UIView *)showView byStartframe:(CGRect )startframe endFrame:(CGRect )endFrame byBlock:(TYAnimateBlock )animateBlock;
    
/**
 *  显示view的动画
 *
 *  @param shoView     需要显示的view
 *  @param frame       刚出现的frame
 *  @param hiddenFrame 结束以后的frame
 */
+ (void)showWithView:(UIView *)showView byStartframe:(CGRect )startframe endFrame:(CGRect )endFrame;

/**
 *  隐藏view的动画
 *
 *  @param hiddenView  需要隐藏的View
 *  @param hiddenFrame 隐藏的View的frame
 *  @param animateBlock 动画结束后的block
 */
+ (void)hiddenView:(UIView *)hiddenView byHiddenFrame:(CGRect )hiddenFrame byBlock:(TYAnimateBlock )animateBlock;

/**
 *  隐藏view的动画
 *
 *  @param hiddenView  需要隐藏的View
 *  @param hiddenFrame 隐藏的View的frame
 */
+ (void)hiddenView:(UIView *)hiddenView byHiddenFrame:(CGRect )hiddenFrame;
@end
