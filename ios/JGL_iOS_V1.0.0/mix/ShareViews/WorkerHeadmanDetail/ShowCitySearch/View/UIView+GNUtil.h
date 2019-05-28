//
//  UIView+GNHelper.h
//  citytime
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GNUtil)

//以tree形式输出view的层级关系
+ (NSString *) displayViews: (UIView *) aView;

- (void)replaceConstraint:(NSLayoutAttribute)attribute1
              onFirstItem:(id)view1
            andConstraint:(NSLayoutAttribute)attribute2
             onSecondItem:(id)view2
             withConstant:(float)constant;

- (void)resetHeightConstraint:(CGFloat)height;
- (void)resetWdithConstraint:(CGFloat)width;

@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, readonly)CGFloat right;
@property(nonatomic, readonly)CGFloat bottom;
@property (nonatomic, assign) CGSize size;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

/**
 *  切任意角
 *
 *  @param target       currentView
 *  @param roundCorners roundCorners
 *  @param cornerSize   cornerSize
 */
+ (void)maskLayerTarget:(UIView *)target roundCorners:(UIRectCorner )roundCorners cornerRad:(CGSize)cornerSize;

/** 获取当前View的控制器对象 */
+(UIViewController *)getCurrentViewControllerWithCurView:(UIView *)curView;
@end
