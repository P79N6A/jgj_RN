//
//  JLGBlueBorderButton.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBlueBorderButton.h"

#import "CALayer+SetLayer.h"

@implementation JLGBlueBorderButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.layer setLayerBorderWithColor:TYColorHex(0x8b8b8b) width:1.0 radius:2.5];
        [self setTitleColor:TYColorHex(0x8b8b8b) forState:UIControlStateNormal];
        [self setTitleColor:JGJMainColor forState:UIControlStateSelected];
        self.tintColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    UIColor *borderColor = selected?JGJMainColor:TYColorHex(0x8b8b8b);
    [self.layer setLayerBorderWithColor:borderColor width:0.5 radius:2.5];
}

@end
