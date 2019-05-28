//
//  HWProgressView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWProgressView.h"

#define KProgressBorderWidth 2.0f
#define KProgressPadding 0.0f
#define KProgressColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

#define ProgressW TYGetUIScreenWidth - 160

@interface HWProgressView ()

@property (nonatomic, weak) UIView *tView;

@end

@implementation HWProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;

}

- (void)commonSet {
    
    //边框
    CGRect bounds = CGRectMake(0, 0, ProgressW, 1.5);
    
    UIView *borderView = [[UIView alloc] initWithFrame:bounds];
    
    borderView.backgroundColor = AppFontE3E3E3Color;
    
    [self addSubview:borderView];
    
    //进度
    UIView *tView = [[UIView alloc] init];

    tView.backgroundColor = AppFont9D9D9DColor;
    
    [self addSubview:tView];
    
    self.tView = tView;
}

- (void)setProgressColor:(UIColor *)progressColor {

    _progressColor = progressColor;
    
    _tView.backgroundColor = progressColor;

}

- (void)setProgressBackColor:(UIColor *)progressBackColor {

    _progressBackColor = progressBackColor;
    
    self.backgroundColor = progressBackColor;

}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat maxWidth = ProgressW;
    
    CGFloat heigth = self.bounds.size.height;
    
    if (progress > 1) {
        
        progress = 1;
    }
    
    _tView.frame = CGRectMake(0, 0, maxWidth * progress, heigth);
}

@end

