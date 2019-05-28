//
//  JGJLogHeaderView.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogHeaderView.h"

@implementation JGJLogHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.allButton];
        [self addSubview:self.meButton];
//        [self addSubview:self.filtrateButton];
        self.allButton.selected = YES;
        self.meButton.selected = NO;
        self.filtrateButton.selected = NO;
        [self addSubview:self.departLable];
        [self addSubview:self.bottomLine];
        
        [self addSubview:self.SecondDepartLable];
        
        
    }
    return self;
}
-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/4 - 25, CGRectGetHeight(self.frame) - 3, 50, 3)];
        _bottomLine.backgroundColor = AppFontEB4E4EColor;
    }
    return _bottomLine;
}
-(UIView *)departLable
{
    if (!_departLable) {
        _departLable = [[UIView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2, 0, 0.5, CGRectGetHeight(self.frame))];
        _departLable.backgroundColor = AppFontdbdbdbColor;
        
    }
    return _departLable;
}
-(UIView *)SecondDepartLable
{
    if (!_SecondDepartLable) {
        _SecondDepartLable = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, TYGetUIScreenWidth, 0.5)];
        _SecondDepartLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _SecondDepartLable;
}

-(UIButton *)allButton
{
    if (!_allButton) {
        _allButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth/2, CGRectGetHeight(self.frame))];
        
        [_allButton setTitle:@"全部日志" forState:UIControlStateNormal];
        [_allButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
        [_allButton setTitleColor:AppFont999999Color  forState:UIControlStateNormal];
        [_allButton addTarget:self action:@selector(ClickAllButton:) forControlEvents:UIControlEventTouchUpInside];
        _allButton.tag = 1;
        _allButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _allButton.backgroundColor = AppFontfafafaColor;

    }
    return _allButton;
}
-(UIButton *)meButton
{
    if (!_meButton) {
        _meButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/2 +1, 0, TYGetUIScreenWidth/2 - 2, CGRectGetHeight(self.frame))];
        
        [_meButton setTitle:@"我的日志" forState:UIControlStateNormal];
        [_meButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
        [_meButton setTitleColor:AppFont999999Color  forState:UIControlStateNormal];
        [_meButton addTarget:self action:@selector(ClickAllButton:) forControlEvents:UIControlEventTouchUpInside];
        _meButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _meButton.tag = 2;
        _meButton.backgroundColor = AppFontfafafaColor;

    }
    return _meButton;
}
-(UIButton *)filtrateButton
{
    if (!_filtrateButton) {
        _filtrateButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/5*4 +2, 0, TYGetUIScreenWidth/5, CGRectGetHeight(self.frame))];
        [_filtrateButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_filtrateButton setImage:[UIImage imageNamed:@"quality_filter_icon"] forState:UIControlStateNormal];
        [_filtrateButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
        [_filtrateButton setTitleColor:AppFont999999Color  forState:UIControlStateNormal];
        [_filtrateButton addTarget:self action:@selector(ClickAllButton:) forControlEvents:UIControlEventTouchUpInside];
        _filtrateButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _filtrateButton.tag = 3;
        _filtrateButton.backgroundColor = AppFontfafafaColor;

    }
    return _filtrateButton;
}
-(void)ClickAllButton:(UIButton*)sender
{
    sender.selected = YES;
    if (sender.tag == 1) {
        _meButton.selected = NO;
        _filtrateButton.selected = NO;
        _logClickTypes = allLogtype;
        
        CGRect rect = self.bottomLine.frame;
        rect.origin.x = TYGetUIScreenWidth/4 - 25;
        [UIView animateWithDuration:.1 animations:^{
           [self.bottomLine setFrame:rect];
        }];
       
    }else if (sender.tag == 2)
    {
        _allButton.selected = NO;
        _filtrateButton.selected = NO;
        _logClickTypes = meLogTYpe;
        
        
        CGRect rect = self.bottomLine.frame;
        rect.origin.x = TYGetUIScreenWidth/4*3 - 25;
        [UIView animateWithDuration:.1 animations:^{
            [self.bottomLine setFrame:rect];
        }];

    }else{
        _allButton.selected = NO;
        _meButton.selected = NO;
        _logClickTypes = otherType;

    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickLogTopButtonWithType:)]) {

        [self.delegate clickLogTopButtonWithType:_logClickTypes];
    }

}
-(void)ClickMeButton:(UIButton *)sender
{
    sender.selected = YES;
    
    
//    sender.selected = !sender.selected;
}
-(void)ClickfiltrateButton:(UIButton *)sender
{
    sender.selected = YES;
//    sender.selected = !sender.selected;

}

-(void)setDefultModel:(JGJNodataDefultModel *)defultModel
{
    [_allButton setTitle:defultModel.helpTitle forState:UIControlStateNormal];
    [_meButton setTitle:defultModel.pubTitle forState:UIControlStateNormal];

}
-(void)setMeLOgNumWithStr:(NSString *)num
{
    NSString *numStr;
    
    if ([num?:@"0" intValue] <= 0 ) {
        
       numStr = @"我的日志";
        
    }else{
        
       numStr = [NSString stringWithFormat:@"我的日志(%@)",num];

    }
    [_meButton setTitle:numStr forState:UIControlStateNormal];


}
@end
