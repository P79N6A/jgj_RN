//
//  JGJCheckContentFooterView.m
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckContentFooterView.h"

@implementation JGJCheckContentFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initview];
    }
    return self;
}

- (void)initview{
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJCheckContentFooterView" owner:self options:nil]firstObject];
    
    [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
    
    [self addSubview:view];
   

        CAShapeLayer *shaplayer = [[CAShapeLayer alloc]init];
        shaplayer.strokeColor = AppFontdbdbdbColor.CGColor;
        shaplayer.fillColor = nil;
        shaplayer.path = [UIBezierPath bezierPathWithRect:self.button.bounds].CGPath;
//        UIBezierPath *triangle = [UIBezierPath bezierPath];
//        [triangle moveToPoint:CGPointMake(0, 0)];
//        [triangle addLineToPoint:CGPointMake(TYGetUIScreenWidth - 54, 0)];
//        shaplayer.path = triangle.CGPath;
        shaplayer.frame = self.button.bounds;
        shaplayer.lineWidth = 1.0f;
    
        shaplayer.lineCap = @"square";
        //    shaplayer.masksToBounds = YES;
        //    shaplayer.cornerRadius = 5;
    
        shaplayer.lineDashPattern = @[@4, @2];
    
//        [self.button.layer addSublayer:shaplayer];
//       self.button.layer.masksToBounds = YES;
//       self.button.layer.cornerRadius = 5;
    self.button.adjustsImageWhenHighlighted = NO;


}
- (IBAction)clickBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCheckContentClickBtn)]) {
        [self.delegate JGJCheckContentClickBtn];
    }
}
-(void)buttonTitle:(NSString *)title
{
    [self.button setTitle:title?:@"" forState:UIControlStateNormal];

}
@end
