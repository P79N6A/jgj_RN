//
//  JGJCusCalPickerView.m
//  mix
//
//  Created by YJ on 17/3/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusCalPickerView.h"

@interface JGJCusCalPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource> {

    UIPickerView    *_pickerView;
    UILabel         *_titleLabel;
    UIView *_datePickerView;//datePicker背景
    UIButton *_calendarBtn;
    
    NSMutableArray *years;//第一列的数据容器
    NSMutableArray *months;//第二列的数据容器
    NSMutableArray *days;//第三列的数据容器
    IDJCalendar *cal;//日期类
}

@end

@implementation JGJCusCalPickerView

- (instancetype)initWithCalendarTitle:(NSString *)calendarTitle IDJCalendar:(IDJCalendar *)calendar {

    self = [super initWithCalendarTitle:calendarTitle IDJCalendar:calendar];
    if (self)
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = kColor(0, 0, 0, 0.5);
//        self.userInteractionEnabled = YES;
////        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
////        [self addGestureRecognizer:tapGesture];
//        cal = calendar;
//        [self createOnlyGrePickView:calendarTitle];
    }
    
    return self;
}

//-(void)createOnlyGrePickView:(NSString *)title{
//    CGFloat datePickerViewH = 205;
//    CGFloat headerViewH = 44;
//    CGFloat pickViewY = 100.0;
//    //生成日期选择器
//    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT(self),WIDTH(self),datePickerViewH)];
//    _datePickerView.backgroundColor = [UIColor whiteColor];
//    _datePickerView.userInteractionEnabled = YES;
//    [self addSubview:_datePickerView];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), headerViewH)];
//    headerView.backgroundColor = AppFontd7252cColor;
//    [_datePickerView addSubview:headerView];
//    
//    UIButton *billButton = [[UIButton alloc]initWithFrame:CGRectMake(50, headerViewH + 20, TYGetUIScreenWidth - 100, 30)];
//    [billButton setTitle:@"我要记多天" forState:UIControlStateNormal];
//    [billButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
//    [billButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:JGJCornerRadius];
//    [billButton addTarget:self action:@selector(handleBillButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [_datePickerView addSubview:billButton];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewClick)];
//    [_datePickerView addGestureRecognizer:tapGesture];
//    
//    UIButton *dateCancleButton=[[UIButton alloc] initWithFrame:CGRectMake(PADDING,0,headerViewH,headerViewH)];
//    [dateCancleButton addTarget:self action:@selector(dateCancleClick) forControlEvents:UIControlEventTouchUpInside];
//    [dateCancleButton setTitle:@"取消" forState:UIControlStateNormal];
//    [dateCancleButton.titleLabel setFont:k15Font];
//    [dateCancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [headerView addSubview:dateCancleButton];
//    
//    UIButton *dateConfirmButton=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)- headerViewH - PADDING,Y(dateCancleButton),WIDTH(dateCancleButton),HEIGHT(dateCancleButton))];
//    [dateConfirmButton addTarget:self action:@selector(dateConfirmClick) forControlEvents:UIControlEventTouchUpInside];
//    [dateConfirmButton.titleLabel setFont:k15Font];
//    [dateConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [dateConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
//    [headerView addSubview:dateConfirmButton];
//    
//    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(dateCancleButton), Y(dateCancleButton), kScreenWidth - MaxX(dateCancleButton)*2, HEIGHT(dateCancleButton))];
//    _titleLabel.font = k15Font;
//    _titleLabel.text = title;
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:_titleLabel];
//    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(dateCancleButton), WIDTH(self), kLineHeight)];
//    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
//    [_datePickerView addSubview:lineView];
//    
//    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pickViewY , WIDTH(lineView), datePickerViewH - pickViewY)];
//    _pickerView.backgroundColor = [UIColor whiteColor];
//    [_pickerView setShowsSelectionIndicator:YES];
//    [_pickerView setDelegate:self];
//    [_pickerView setDataSource:self];
//    [_datePickerView addSubview:_pickerView];
//}

//-(void)setCalendarType:(CalendarType)calendarType{
//    [super setCalendarType:calendarType];
////    _calendarType = calendarType;
//    
//    if (calendarType == GregorianCalendar) {
//        cal=[[IDJCalendar alloc]initWithYearStart:YEAR_START end:YEAR_END IDJCalendar:cal];
//        
//    }
//    [self _setYears];
//    [self _setMonthsInYear:[cal.year intValue]];
//    [self _setDaysInMonth:cal.month year:[cal.year intValue]];
//    
//    [_pickerView reloadAllComponents];
//    
//    [_pickerView selectRow:[years indexOfObject:cal.year] inComponent:0 animated:YES];
//    [_pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
//    [_pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];
//    
//    
//    TYLog(@"---%@ -- %@ --- %@", cal.year, cal.month, cal.day);
//}

//- (void)handleBillButtonPressed {
//
//    if (self.delegate) {
//        [self.delegate handleBillButtonPressedAction:self];
//    }
//}

//- (void)show {
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    [window addSubview:self];
//    [self addAnimation];
//}

- (void)dateCancleClick {
    [self hiddenPickView];
}

- (void)hiddenPickView {
    [self removeAnimation];
}

- (void)addAnimation {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_datePickerView setFrame:CGRectMake(0, self.frame.size.height - _datePickerView.frame.size.height, kScreenWidth, _datePickerView.frame.size.height)];
        //        self.alpha = 0.7;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        [_datePickerView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
