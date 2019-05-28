//
//  JGJWorkReportTypeView.m
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkReportTypeView.h"

@implementation JGJWorkReportTypeView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.NmoveLable];
    [_daySbutton setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    [_daySbutton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    [_weekSbutton setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    [_weekSbutton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    [_monthSbutton setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
    [_monthSbutton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
//    [self addSubview:self.departLable];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadView];
    }
    return self;

}

- (void)loadView{
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    [view setFrame:self.bounds];
    [self addSubview:view];
//    [self addSubview:self.NmoveLable];
    [self addSubview:self.departLable];
}
-(UILabel *)NmoveLable
{
    if (!_NmoveLable) {
        _NmoveLable = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth/6-12.5, 40-2.5, 25, 2)];
        _NmoveLable.backgroundColor = AppFontd7252cColor;
    }
    return _NmoveLable;
}
-(UILabel *)departLable
{
    if (!_departLable) {
        _departLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, TYGetUIScreenWidth, 0.5)];
        _departLable.backgroundColor = AppFontdbdbdbColor;
    }
    return _departLable;
}

- (IBAction)clickWorkReportButton:(id)sender {
    UIButton * button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapTopButtonWithTag:)]) {
        [self.delegate tapTopButtonWithTag:button.tag];
    }

    switch (button.tag) {
        case 1://日报
            _daySbutton.selected = YES;
            _weekSbutton.selected = NO;
            _monthSbutton.selected = NO;
//            _workReportType = JGJWorkReportTypeDay;
            break;
        case 2://周报
            
            _daySbutton.selected = NO;
            _weekSbutton.selected = YES;
            _monthSbutton.selected = NO;
//            _workReportType = JGJWorkReportTypeWeek;

            break;
        case 3://月报
            _daySbutton.selected = NO;
            _weekSbutton.selected = NO;
            _monthSbutton.selected = YES;
//            _workReportType = JGJWorkReportTypemonth;

            break;
        default:
            break;
    }
    [self moveLableTobuttonBotem:button.tag];

    [TYNotificationCenter postNotificationName:@"clickWorkReportType" object:[NSString stringWithFormat:@"%ld",(long)button.tag]];
 }
-(void)moveLableTobuttonBotem:(NSInteger)tag
{
    [UIView animateWithDuration:.2 animations:^{
    
        [self.NmoveLable setFrame:CGRectMake(TYGetUIScreenWidth/6*(tag *2 -1) - 12.5, CGRectGetHeight(self.frame)-2.5, 25, 2)];
}];

}
@end
