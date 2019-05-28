//
//  YQShadowLable.m
//  mix
//
//  Created by Tony on 2017/1/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "YQShadowLable.h"

@implementation YQShadowLable

@synthesize redValue = redValue_, greenValue = greenValue_, blueValue = blueValue_, size = size_;

-(void)awakeFromNib{
    [super awakeFromNib];
    //    6 238 238
    redValue_   = 123.0/255.0f;
    greenValue_ = 255.0/255.0f;
    blueValue_  = 255.0/255.0f;
    size_       = 2.0f;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        redValue_   = 123.0/255.0f;
        greenValue_ = 225.0/255.0f;
        blueValue_  = 255.0/255.0f;
        size_       = 2.0f;

    }
    return self;
}

-(void)drawTextInRect: (CGRect)rect{
    
    CGSize textShadowOffest = CGSizeMake(0, 0);
#pragma mark - 此处应注意需用const  不然会无法获取返回值
    const  CGFloat textColorValues[] = {redValue_, greenValue_, blueValue_, 1.0};
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadow(ctx, textShadowOffest, 10);
    CGColorSpaceRef textColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef textColor = CGColorCreate(textColorSpace,textColorValues);
    CGContextSetShadowWithColor(ctx, textShadowOffest,10, textColor);
    
    [super drawTextInRect:rect];
    
    CGColorRelease(textColor);
    CGColorSpaceRelease(textColorSpace);
    
    CGContextRestoreGState(ctx);
}

@end
