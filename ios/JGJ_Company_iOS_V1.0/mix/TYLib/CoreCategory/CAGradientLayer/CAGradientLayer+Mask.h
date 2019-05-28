//
//  CAGradientLayer+Mask.h
//  JGJCompany
//
//  Created by Tony on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (Mask)

- (instancetype )initWithFrame:(CGRect )frame;

/**
 *  添加从左到右的水平渐变
 */
- (void)horizontalLeftToRightWithColors:(NSArray *)colors locations:(NSArray *)locations;

/**
 *  添加从右到左的水平渐变
 */
- (void)horizontalRightToLeftWithColors:(NSArray *)colors locations:(NSArray *)locations;

/**
 *  添加从上到下的垂直渐变
 */
- (void)verticalTopToBottomWithColors:(NSArray *)colors locations:(NSArray *)locations;

/**
 *  添加从下到上的垂直渐变
 */
- (void)verticalBottomToTopWithColors:(NSArray *)colors locations:(NSArray *)locations;
@end
