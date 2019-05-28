//
//  SMCustomSegment.h
//  分段直接实现
//
//  Created by 志恒李-ly on 16/9/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCustomSegmentDelegate <NSObject>
@required
- (void)customSegmentSelectIndex:(NSInteger)selectIndex;

@end

@interface SMCustomSegment : UIView
/**
 *  圆角 默认 4
 */
@property (nonatomic, assign) CGFloat cornerRadius;
/**
 *  边框宽度 默认 1
 */
@property (nonatomic, assign) CGFloat borderWidth;
/**
 *  未点击状态及高亮状态下item背景颜色 默认 [UIColor whiteColor]
 */
@property (nonatomic, copy) UIColor * normalBackgroundColor;
/**
 *  选中状态下item颜色 默认 [UIColor redColor]
 */
@property (nonatomic, copy) UIColor * selectBackgroundColor;
/**
 *  未选中状态下item字体颜色 默认 [UIColor lightGrayColor]
 */
@property (nonatomic, copy) UIColor * titleNormalColor;
/**
 *  选中状态下item字体颜色 默认 [UIColor blueColor]
 */
@property (nonatomic, copy) UIColor * titleSelectColor;
/**
 *  选中第几个item 默认 0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 *  正常状态下item字体大小
 */
@property (nonatomic, assign) CGFloat normalTitleFont;
/**
 *  选中状态下item字体大小
 */
@property (nonatomic, assign) CGFloat selectTitleFont;

@property (nonatomic, assign) id <SMCustomSegmentDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end
