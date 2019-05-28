//
//  JGJDownLoadProGressView.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDownLoadProGressView.h"

@interface JGJDownLoadProGressView (){

    UIView *viewTop;
    
    UIView *viewBottom;
}

@end

@implementation JGJDownLoadProGressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self buildUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    
    viewBottom = [[UIView alloc]initWithFrame:self.bounds];
    viewBottom.backgroundColor = AppFontf1f1f1Color;
    viewBottom.layer.cornerRadius = 3;
    viewBottom.layer.masksToBounds = YES;
    [self addSubview:viewBottom];
    
    
    viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, viewBottom.frame.size.height)];
    viewTop.backgroundColor = AppFontEB4E4EColor;
    viewTop.layer.cornerRadius = 3;
    viewTop.layer.masksToBounds = YES;
    [viewBottom addSubview:viewTop];
    
}


-(void)setTime:(float)time
{
    _time = time;
}
-(void)setProgressValue:(NSString *)progressValue
{
    if (!_time) {
        _time = 1.5;
    }
    _progressValue = progressValue;
    
    [UIView animateWithDuration:_time animations:^{
        viewTop.frame = CGRectMake(viewTop.frame.origin.x, viewTop.frame.origin.y, viewBottom.frame.size.width*[progressValue floatValue], viewTop.frame.size.height);
    }];
}


-(void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    viewBottom.backgroundColor = bottomColor;
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    viewTop.backgroundColor = progressColor;
}


@end
