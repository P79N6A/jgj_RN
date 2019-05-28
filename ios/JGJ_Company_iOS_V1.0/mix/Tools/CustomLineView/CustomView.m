//
//  CustomView.m
//  MarketEleven
//
//  Created by bergren on 15/3/3.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//

#import "CustomView.h"

@implementation BaseView

- (void)customInit {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self customInit];
    }
    
    return self;
}

@end


@implementation LineView
- (void)customInit
{
    NSArray *constraints = self.constraints;
    __block NSLayoutConstraint *w;
    __block NSLayoutConstraint *h;
    
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                w = constraint;
            }else if (constraint.firstAttribute == NSLayoutAttributeHeight){
                h = constraint;
            }
        }
    }];
    
    if (w.constant == 1) {
        w.constant = 0.5;
    }
    if (h.constant == 1) {
        h.constant = 0.5;
    }
    
    self.backgroundColor = TYColorHex(0Xdbdbdb);
}
@end


