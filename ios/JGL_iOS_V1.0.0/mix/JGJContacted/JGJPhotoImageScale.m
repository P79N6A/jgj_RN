//
//  JGJPhotoImageScale.m
//  mix
//
//  Created by Tony on 2016/12/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//
#define screenW [UIScreen mainScreen].bounds.size
#import "JGJPhotoImageScale.h"
#import "UIImageView+WebCache.h"
@implementation JGJPhotoImageScale
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.imageview];
       
        

    }
    return self;

}
-(UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 10, 10)];
        _imageview.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImage)];
        [self addGestureRecognizer:tap];
    }
    return _imageview;
}
-(void)StartAnimation
{
            [UIView animateWithDuration:.2 animations:^{
                [_imageview setFrame:CGRectMake(0, screenW.height/4, screenW.width, screenW.height/2)];

            } completion:^(BOOL finished) {
                
            }];

}
-(void)removeImage
{

    [UIView animateWithDuration:.4 animations:^{
        _imageview.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

#pragma mark 先获取图片

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
