//
//  CAGradientLayer+Mask.m
//  JGJCompany
//
//  Created by Tony on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "CAGradientLayer+Mask.h"

@implementation CAGradientLayer (Mask)

- (instancetype )initWithFrame:(CGRect )frame{
    self = [super init];
    if (self) {
        self.frame = frame;
    }

    return self;
}

- (void)horizontalLeftToRightWithColors:(NSArray *)colors locations:(NSArray *)locations{
    // 设置渐变层的颜色
    self.colors = colors;
    
    //水平渐变添加下面两行即可
    self.startPoint = CGPointMake(0, .5);
    self.endPoint = CGPointMake(1, .5);
    self.locations = locations;
}

- (void)horizontalRightToLeftWithColors:(NSArray *)colors locations:(NSArray *)locations{
    // 设置渐变层的颜色
    self.colors = colors;
    
    //水平渐变添加下面两行即可
    self.startPoint = CGPointMake(1, .5);
    self.endPoint = CGPointMake(0, .5);
    self.locations = locations;
}

- (void)verticalTopToBottomWithColors:(NSArray *)colors locations:(NSArray *)locations{
    // 设置渐变层的颜色
    self.colors = colors;
    
    self.locations = locations;
}

- (void)verticalBottomToTopWithColors:(NSArray *)colors locations:(NSArray *)locations{
    // 设置渐变层的颜色
    self.colors = colors;
    
    //水平渐变添加下面两行即可
    self.startPoint = CGPointMake(1, 0);
    self.endPoint = CGPointMake(0, 0);
    self.locations = locations;
}
@end
