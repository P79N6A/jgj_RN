//
//  JGJShowHubView.m
//  mix
//
//  Created by Tony on 2017/2/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJShowHubView.h"

@implementation JGJShowHubView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [self addSubview:self.BaseView];
    [self addSubview:self.ShowView];
    [self.ShowView addSubview:self.TitleLable];
    [self.ShowView addSubview:self.SureBurron];

}
-(UIView *)BaseView
{
    if (!_BaseView) {
        _BaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _BaseView.backgroundColor = [UIColor darkGrayColor];
        _BaseView.alpha = 0.5;
    }
    return _BaseView;

}
-(UIView *)ShowView
{
    if (!_ShowView) {
        _ShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth-40, 200)];
        _ShowView.center = CGPointMake(TYGetUIScreenWidth/2, TYGetUIScreenHeight/2);
        _ShowView.backgroundColor = [UIColor whiteColor];
        _ShowView.layer.masksToBounds = YES;
        _ShowView.layer.cornerRadius = JGJCornerRadius;
        _ShowView.layer.borderWidth = 1;
        _ShowView.layer.borderColor  =  AppFontfafafaColor.CGColor;
        _ShowView.alpha   = 1;
    }
    return _ShowView;
}

-(UILabel *)TitleLable
{
    if (!_TitleLable) {
        _TitleLable = [[UILabel alloc]initWithFrame:CGRectMake(5,60, CGRectGetWidth(self.ShowView.frame) - 10, 30)];
        _TitleLable.textAlignment = NSTextAlignmentCenter;
        _TitleLable.textColor = [UIColor lightGrayColor];
        _TitleLable.text = @"创建班组就可以使用批量记工记账";
        _TitleLable.font = [UIFont systemFontOfSize:AppFont32Size];
    }
    return _TitleLable;
}
-(UIButton *)SureBurron
{
    if (!_SureBurron) {
        _SureBurron = [[UIButton alloc] init];
        _SureBurron.backgroundColor = JGJMainColor;
        _SureBurron.titleLabel.textColor = [UIColor whiteColor];
        [_SureBurron setTitle:@"我知道了" forState:UIControlStateNormal];
//        [_SureBurron.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_SureBurron addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
        [_SureBurron setFrame:CGRectMake(-1, CGRectGetHeight(self.ShowView.frame)- 45, CGRectGetWidth(self.ShowView.frame)+2, 45)];
        _SureBurron.layer.masksToBounds = YES;
        _SureBurron.layer.cornerRadius = JGJCornerRadius;
        _SureBurron.layer.borderWidth = 1;
        _SureBurron.layer.borderColor  =  [UIColor redColor].CGColor;
    }
    return _SureBurron;
}
-(void)dissMiss
{

    [self removeFromSuperview];


}


@end
