//
//  JGJBottomVIewAndButton.m
//  mix
//
//  Created by Tony on 2017/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBottomVIewAndButton.h"

@implementation JGJBottomVIewAndButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 63)];
        view.backgroundColor =  AppFontfafafaColor;
        [self addSubview:view];
        
        _button = [[UIButton alloc]initWithFrame:CGRectMake(10, 9, TYGetUIScreenWidth - 20, 45)];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = JGJCornerRadius;
        [_button setTitle:@"保存" forState:UIControlStateNormal];
        _button.backgroundColor = AppFontd7252cColor;
        [_button addTarget:self action:@selector(ClickBottomButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_button];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        [view addSubview:lable];
    }
    return self;
}
-(void)ClickBottomButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBottomButtonevent)]) {
        [self.delegate clickBottomButtonevent];
    }
    
    
}

@end
