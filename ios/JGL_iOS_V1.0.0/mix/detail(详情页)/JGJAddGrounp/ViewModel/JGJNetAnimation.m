//
//  JGJNetAnimation.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNetAnimation.h"

@implementation JGJNetAnimation
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.Animalview];
    }
    return self;


}

-(UIActivityIndicatorView *)Animalview
{
    if (!_Animalview) {
        _Animalview = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _Animalview.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_Animalview startAnimating];
   }

    return _Animalview;

}

-(void)stopAnimation
{
    if (_Animalview) {
        [_Animalview stopAnimating];
        [_Animalview removeFromSuperview];
        _Animalview = nil;
    }
   

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
