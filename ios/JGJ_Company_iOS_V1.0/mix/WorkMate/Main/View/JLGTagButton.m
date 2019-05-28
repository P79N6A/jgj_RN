//
//  JLGTagButton.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGTagButton.h"
#import "CALayer+SetLayer.h"

#define marginValue 10

@implementation JLGTagButton


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.layer setLayerBorderWithColor:TYColorHex(0xf8a33f) width:1.0 radius:4.0];
    [self setTitleColor:TYColorHex(0xf8a33f) forState:UIControlStateNormal];
}

- (CGSize)sizeForButton {
    //宽度加 marginValue 为了两边圆角。
    CGSize labelSize = CGSizeMake([self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + marginValue, 3*marginValue);
    return labelSize;
}
@end
