//
//  TYButton.m
//  mix
//
//  Created by Tony on 16/6/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYButton.h"

@implementation TYButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    //    NSLog(@"%@", NSStringFromCGRect(self.frame));
    //尺寸
    //    CGRect frame = self.frame;
    // 图片
    UIImageView *imageView = self.imageView;
    // label
    UILabel *titleLabel = self.titleLabel;
    
    CGFloat imageViewYScale = 31 / 82.0;
    CGFloat titleLabelYScale = (82 - 22) / 82.0;
    
    CGPoint center = imageView.center;
    center.x = self.frame.size.width / 2;
    center.y = self.frame.size.height * imageViewYScale;
    imageView.center = center;
    //    NSLog(@"image%@", NSStringFromCGPoint(center));
    
    center = titleLabel.center;
    center.x = self.frame.size.width / 2;
    center.y = self.frame.size.height * titleLabelYScale;
    titleLabel.center = center;
    //    NSLog(@"title%@", NSStringFromCGPoint(center));
    
    CGRect frame = titleLabel.frame;
    frame.size.height = self.frame.size.width;
    // titleLabel的尺寸
    titleLabel.frame = frame;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
@end
