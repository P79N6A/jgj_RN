//
//  JGJYJLable.m
//  mix
//
//  Created by yj on 17/2/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJYJLable.h"
@interface JGJYJLable ()

@end

@implementation JGJYJLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];//重绘一下
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect=[super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch(self.verticalAlignment)
    {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y+(bounds.size.height - textRect.size.height) / 2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y+bounds.size.height - textRect.size.height;
            break;
        default:
            textRect.origin.y = bounds.origin.y+(bounds.size.height - textRect.size.height) / 2.0;
            break;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];//重新计算位置
    [super drawTextInRect:actualRect];
}

@end
