//
//  JLGTagLabel.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//


#import "JLGTagLabel.h"
#import "CALayer+SetLayer.h"

#define marginValue 10
@implementation JLGTagLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInit];
    }
    return self;
}

- (void)setInit{
    self.textColor = TYColorHex(0xf8a33f);
    self.textAlignment = NSTextAlignmentCenter;
    [self.layer setLayerBorderWithColor:TYColorHex(0xf8a33f) width:1.0 radius:4.0];
}

- (CGSize)sizeForLabel {
    //宽度加 marginValue 为了两边圆角。
    CGSize labelSize = CGSizeMake([self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + marginValue, 3*marginValue);
    return labelSize;
}
@end
