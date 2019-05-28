//
//  JGJDateLogPickerview.m
//  JGJCompany
//
//  Created by Tony on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDateLogPickerview.h"

@implementation JGJDateLogPickerview

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];

    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];

}
-(void)initView
{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJDateLogPickerview" owner:self options:nil]firstObject];
    
    [self.contentView setFrame:self.bounds];
    
    [self addSubview:self.contentView];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), TYGetUIScreenWidth, 40)];
    view.backgroundColor = JGJMainColor;
    [self addSubview:view];
    UIButton *OkButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 100, 0, 100, 40)];
    
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    OkButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [OkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];;

    [view addSubview:OkButton];
    [OkButton addTarget:self action:@selector(okButton:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:cancelButton];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];;
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, TYGetUIScreenWidth - 220, 40)];
    label.text = @"选择时间";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

    [view addSubview:label];
    
//    _datePickerview.transform = CGAffineTransformMakeTranslation(0, 340);
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = _datePickerview.frame;
        rect.origin.y  = rect.origin.y - 280;
        [_datePickerview setFrame:rect];
        CGRect Vrect = view.frame;
        Vrect.origin.y  = Vrect.origin.y - 320;
        [view setFrame:Vrect];
    }];
    
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//     [self.datePicker setLocale:[NSLocale currentLocale]];
    NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    [_datePickerview addSubview:_datePicker];
    [_datePicker addTarget:self action:@selector(dateChange:)
         forControlEvents:UIControlEventValueChanged];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRemoveView)];
        [self.contentView addGestureRecognizer:tap];
 
    });
}
-(void)clickRemoveView
{
    [self removeFromSuperview];

}
-(void)dateChange:(UIDatePicker *)picker
{
    _currentDate = picker.date;
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
}
+ (void)showDatePickerAndSelfview:(UIView *)view anddatePickertype:(datePickerModelType)datetype andblock:(selectTime)date
{
    JGJDateLogPickerview *datePicker = [[JGJDateLogPickerview alloc]initWithFrame:[UIScreen mainScreen].bounds];
    datePicker.selectTimeBlock = date;
    if (datetype == year_month_week_day_hourmodel) {
        [datePicker.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];//年月日星期
        
    }else if (datetype == hour_minitmodel)
    {
        [datePicker.datePicker setDatePickerMode:UIDatePickerModeTime];//小时分钟
    }else if (datetype == year_month_week_dayModel)
    {
        [datePicker.datePicker setDatePickerMode:UIDatePickerModeDate];//年月日

    }else if(datetype == year_model){//只显示年月
//        [datePicker.datePicker setDatePickerMode:UIDatePickerModeTime];//

    }else if (datetype == year_monthmodel)
    {
    
    }
    [view addSubview:datePicker];
}
- (IBAction)cancelButton:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)okButton:(id)sender {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    self.selectTimeBlock(_currentDate);
    [self removeFromSuperview];

    if (self.delegate && [self.delegate respondsToSelector:@selector(JLGDataPickerSelect:)]) {
        [self.delegate JLGDataPickerSelect:_currentDate];
    }
}
@end
