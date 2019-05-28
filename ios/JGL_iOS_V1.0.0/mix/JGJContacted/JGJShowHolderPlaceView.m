//
//  JGJShowHolderPlaceView.m
//  mix
//
//  Created by Tony on 2017/2/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJShowHolderPlaceView.h"

@implementation JGJShowHolderPlaceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        [self addSubview:self.firstView];
        [[[UIApplication sharedApplication]keyWindow]addSubview:self.firstView];

        
    }
    return self;
}
-(instancetype)init
{
    if (self = [super init]) {
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.firstView];
    }
    return self;
}
-(UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight-250)];
        _firstView.backgroundColor = [UIColor darkGrayColor];
        _firstView.alpha = .6;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
        [_firstView addGestureRecognizer:tap];
        _firstView.userInteractionEnabled = YES;
    }

    return _firstView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_firstView removeFromSuperview];
    _firstView = nil;

}
-(void)remove
{
    [_firstView removeFromSuperview];
    _firstView = nil;



}
@end
