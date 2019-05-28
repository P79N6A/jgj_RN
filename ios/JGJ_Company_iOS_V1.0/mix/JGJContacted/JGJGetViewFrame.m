//
//  JGJGetViewFrame.m
//  mix
//
//  Created by Tony on 2016/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGetViewFrame.h"

@implementation JGJGetViewFrame
+(float)GetMaxY:(UIView *)view
{

    return CGRectGetMaxY(view.frame);

}
+(float)GetMaxX:(UIView *)view
{


    return CGRectGetMaxX(view.frame);

}
+(UIImage *)saImageWithSingleColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1.0f, 1.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
