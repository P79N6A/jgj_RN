//
//  JLGWelfareLabel.m
//  mix
//
//  Created by jizhi on 15/11/27.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGWelfareLabel.h"
#import "CALayer+SetLayer.h"

#define marginValue 10
@implementation JLGWelfareLabel

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
    self.textColor = TYColorHex(0xf5a63d);
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:12.0];
    [self.layer setLayerBorderWithColor:TYColorHex(0xf5a63d) width:0.5 radius:4.0];
}

- (void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
    if (textColor != nil) {
        [self.layer setLayerBorderWithColor:textColor width:0.5 radius:4.0];
    }
}

- (CGSize)sizeForLabel {
    //宽度加 marginValue 为了两边圆角。
    CGSize labelSize = CGSizeMake([self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + marginValue, JLGWelfareLabelH);
    return labelSize;
}
@end
