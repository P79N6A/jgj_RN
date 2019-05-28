//
//  JGJJGSSuggestion.m
//  mix
//
//  Created by Tony on 2017/1/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJJGSSuggestion.h"

@implementation JGJJGSSuggestion
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = AppFontF18215;
        [self addSubview:self.TitleLable];
        [self addSubview:self.QuitButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpScoreWork)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
      
    }
    return self;
}
-(UILabel *)TitleLable
{
    if (!_TitleLable) {
        _TitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];

        _TitleLable.backgroundColor = [UIColor clearColor];
        _TitleLable.textColor       = AppFonttITLEF18215;
        _TitleLable.font = [UIFont systemFontOfSize:15];
        _TitleLable.text = @"   你今天记工了吗？去检查一下>";
          }

    return _TitleLable;

}
-(void)jumpScoreWork
{
    if ([self.jumpDelegate respondsToSelector:@selector(jumpScoreWorkViewControllerthing)]) {
        [self.jumpDelegate jumpScoreWorkViewControllerthing];
    }
 

}
-(UIButton *)QuitButton
{
    if (!_QuitButton) {
        _QuitButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 5, 40, 30)];
        [_QuitButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//        _QuitButton.titleLabel.textColor = [UIColor grayColor];
//        [_QuitButton setTitle:@"X" forState:UIControlStateNormal];
//        _QuitButton.backgroundColor = [UIColor whiteColor];
        [_QuitButton addTarget:self action:@selector(removeThisView) forControlEvents:UIControlEventTouchUpInside];
    }

    return _QuitButton;

}
-(void)removeThisView
{
    if (self) {
        [self removeFromSuperview];
    }
}
@end
