//
//  JGJAnimationView.m
//  test
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 test. All rights reserved.
//

#import "JGJAnimationView.h"

@implementation JGJAnimationView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageview];
        
    }

    return self;
}
-(UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [UIImageView new];
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _imageview.image = [UIImage imageNamed:@"icon_received_normal"];
        [_imageview setFrame:rect];
        
    }

    return _imageview;
}
/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
[UIView animateWithDuration:.3 animations:^{
    CGAffineTransform newTransform =
    CGAffineTransformScale(_imageview.transform, 2, 2);
    _imageview.transform = newTransform;
} completion:^(BOOL finished) {
   
    CGAffineTransform newTransform =
    CGAffineTransformScale(_imageview.transform, 0.5, 0.5);
    _imageview.transform = newTransform;
    _imageview.image = [UIImage imageNamed:@"icon_received_selected"];
//    _imageview.transform =  CGAffineTransformScale(_imageview.transform, 1,1);
 
}];

}
 */
-(void)NormalButton
{
    [UIView animateWithDuration:.3 animations:^{
        CGAffineTransform newTransform =
        CGAffineTransformScale(_imageview.transform, 2, 2);
        _imageview.transform = newTransform;
    } completion:^(BOOL finished) {
        
        CGAffineTransform newTransform =
        CGAffineTransformScale(_imageview.transform, 0.5, 0.5);
        _imageview.transform = newTransform;
        _imageview.image = [UIImage imageNamed:@"icon_received_normal"];
        
    }];


}

-(void)selectedButton
{
    [UIView animateWithDuration:.2 animations:^{
        CGAffineTransform newTransform =
        CGAffineTransformScale(_imageview.transform, 2, 2);
        _imageview.transform = newTransform;
    } completion:^(BOOL finished) {
        
        CGAffineTransform newTransform =
        CGAffineTransformScale(_imageview.transform, 0.5, 0.5);
        _imageview.transform = newTransform;
        _imageview.image = [UIImage imageNamed:@"icon_received_selected"];
        
    }];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
