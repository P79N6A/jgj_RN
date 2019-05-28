//
//  JGJTitleContentView.m
//  mix
//
//  Created by Tony on 2017/4/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTitleContentView.h"

@implementation JGJTitleContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
- (void)loadView{

    self.backgroundColor = [UIColor whiteColor];
//    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
//    
//    CGRect rect = self.bounds;
//    rect.size.width = TYGetUIScreenWidth;
//    self.contentView.frame = rect;
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.contentView];
    [self addSubview:self.dateLbale];
    [self addSubview:self.contentLable];
    [self addSubview:self.salaryLable];
    [self addSubview:self.departLable];
}
-(UILabel *)departLable
{
    if (!_departLable) {
        _departLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 34, TYGetUIScreenWidth - 20, 1)];
        _departLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _departLable;
}
- (UILabel *)dateLbale
{
    if (!_dateLbale) {
        _dateLbale = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 80, 15)];
        _dateLbale.textColor = AppFont999999Color;
        _dateLbale.text = @"日期";
        _dateLbale.textAlignment = NSTextAlignmentLeft;
        _dateLbale.font = [UIFont systemFontOfSize: AppFont26Size];
        
    }
    return _dateLbale;
}
- (UILabel *)contentLable
{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
        _contentLable.center = CGPointMake(CGRectGetMidX(self.frame) -47 , CGRectGetMidY(self.frame));
        _contentLable.textColor = AppFont999999Color;
        _contentLable.text = @"内容";
        _contentLable.font = [UIFont systemFontOfSize: AppFont26Size];
        _contentLable.textAlignment = NSTextAlignmentCenter;

    }
    return _contentLable;
}
- (UILabel *)salaryLable
{
    if (!_salaryLable) {
        _salaryLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 105, 10, 65, 15)];
        _salaryLable.textColor = AppFont999999Color;
        _salaryLable.text = @"金额";
        _salaryLable.font = [UIFont systemFontOfSize: AppFont26Size];
        _salaryLable.textAlignment = NSTextAlignmentCenter;

    }
    return _salaryLable;
}
@end
