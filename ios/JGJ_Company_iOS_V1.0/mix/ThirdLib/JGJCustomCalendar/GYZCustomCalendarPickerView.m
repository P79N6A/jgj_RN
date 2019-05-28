//
//  GYZCustomCalendarPickerView.m
//  GYZCalendarPicker
//
//  Created by GYZ on 16/6/22.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZCustomCalendarPickerView.h"
#define IsMaxYear (([cal.year isEqualToString:@"2020"] && [cal.month isEqualToString:@"12"]) || [cal.des_year isEqualToString:@"2021"])
#define IsMinYear ([cal.year isEqualToString:@"2012"] && [cal.month isEqualToString:@"1"])
@interface GYZCustomCalendarPickerView (Private)
//- (void)_setYears;
//- (void)_setMonthsInYear:(NSUInteger)_year;
//- (void)_setDaysInMonth:(NSString *)_month year:(NSUInteger)_year;
- (void)changeMonths;
- (void)changeDays;
@end

@implementation GYZCustomCalendarPickerView{
    UIPickerView    *_pickerView;
    UILabel         *_titleLabel;
    UIView *_datePickerView;//datePicker背景
    UIButton *_calendarBtn;
    
    NSMutableArray *years;//第一列的数据容器
    NSMutableArray *months;//第二列的数据容器
    NSMutableArray *days;//第三列的数据容器
    IDJCalendar *cal;//日期类
}

- (instancetype)initWithCalendarTitle:(NSString *)calendarTitle IDJCalendar:(IDJCalendar *)calendar
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = kColor(0, 0, 0, 0.5);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tapGesture];
        cal = calendar;
        [self createView:calendarTitle];
        
    }
    
    return self;
}
-(void)createView:(NSString *)title{
    //生成日期选择器
    _datePickerView=[[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT(self),WIDTH(self),305)];
    _datePickerView.backgroundColor = [UIColor whiteColor];
    _datePickerView.userInteractionEnabled = YES;
    [self addSubview:_datePickerView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 44)];
    headerView.backgroundColor = AppFontd7252cColor;
    [_datePickerView addSubview:headerView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewClick)];
    [_datePickerView addGestureRecognizer:tapGesture];
    
    UIButton *dateCancleButton=[[UIButton alloc] initWithFrame:CGRectMake(PADDING,0,44,44)];
    [dateCancleButton addTarget:self action:@selector(dateCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [dateCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [dateCancleButton.titleLabel setFont:k15Font];
    [dateCancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [dateCancleButton setImage:IMAGE(@"icon_x_cancle") forState:UIControlStateNormal];
    //    [dateCancleButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12,12)];
    [headerView addSubview:dateCancleButton];
    
    UIButton *dateConfirmButton=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-44 - PADDING,Y(dateCancleButton),WIDTH(dateCancleButton),HEIGHT(dateCancleButton))];
    [dateConfirmButton addTarget:self action:@selector(dateConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [dateConfirmButton.titleLabel setFont:k15Font];
    [dateConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [headerView addSubview:dateConfirmButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(dateCancleButton), Y(dateCancleButton), kScreenWidth - MaxX(dateCancleButton)*2, HEIGHT(dateCancleButton))];
    _titleLabel.font = k15Font;
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(dateCancleButton), WIDTH(self), kLineHeight)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [_datePickerView addSubview:lineView];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MaxY(lineView) , WIDTH(lineView), 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_datePickerView addSubview:_pickerView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(_pickerView), WIDTH(lineView), kLineHeight)];
    lineView1.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [_datePickerView addSubview:lineView1];
    
    _calendarBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)*0.75, MaxY(lineView1), WIDTH(self)*0.25, HEIGHT(dateCancleButton))];
    _calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [_calendarBtn setTitle:@"农历" forState:UIControlStateNormal];
    [_calendarBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [_calendarBtn setImage:IMAGE(@"RecordWorkpoints_not_selected") forState:UIControlStateNormal];
    [_calendarBtn setImage:IMAGE(@"RecordWorkpoints_selected") forState:UIControlStateSelected];
    [_calendarBtn.titleLabel setFont:k15Font];
    [_datePickerView addSubview:_calendarBtn];
    
    [_calendarBtn addTarget:self action:@selector(selectCalendarClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setCalendarType:(CalendarType)calendarType{
    _calendarType = calendarType;
    
    if (calendarType == GregorianCalendar) {
//        农历转换为阳历
        if ([cal.month containsString:@"-"]) {
            NSDateComponents *components = [IDJCalendarUtil toSolarDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
            cal.year = [NSString stringWithFormat:@"%@", @(components.year)];
            cal.month = [NSString stringWithFormat:@"%@", @(components.month)];
            cal.day = [NSString stringWithFormat:@"%@", @(components.day)];
        }
        cal=[[IDJCalendar alloc]initWithYearStart:YEAR_START end:YEAR_END IDJCalendar:cal];

    } else if (calendarType == ChineseCalendar){
//        当前是阳历转换为农历
//        if (![cal.month containsString:@"-"]) {
//            NSDateComponents *components = [IDJCalendarUtil toChineseDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
//            cal.year = [NSString stringWithFormat:@"%@", @(components.year)];
//            cal.month = [NSString stringWithFormat:@"%@", @(components.month)];
//            cal.day = [NSString stringWithFormat:@"%@", @(components.day)];
//        }
        cal=[[IDJChineseCalendar alloc]initWithYearStart:YEAR_START end:YEAR_END IDJCalendar:cal];
    }
    [self _setYears];
    [self _setMonthsInYear:[cal.year intValue]];
    [self _setDaysInMonth:cal.month year:[cal.year intValue]];
    
    [_pickerView reloadAllComponents];
    
    if (calendarType == GregorianCalendar) {
        [_pickerView selectRow:[years indexOfObject:cal.year] inComponent:0 animated:YES];
    } else if (calendarType == ChineseCalendar) {
        
//        [_pickerView selectRow:[years indexOfObject:[NSString stringWithFormat:@"%@-%@-%@", cal.era, ((IDJChineseCalendar *)cal).jiazi, cal.year]] inComponent:0 animated:YES];
        [_pickerView selectRow:[years indexOfObject:[NSString stringWithFormat:@"%@", cal.year]] inComponent:0 animated:YES];

    }
    [_pickerView selectRow:[months indexOfObject:cal.month] inComponent:1 animated:YES];
    [_pickerView selectRow:[days indexOfObject:cal.day] inComponent:2 animated:YES];

    
    TYLog(@"---%@ -- %@ --- %@", cal.year, cal.month, cal.day);
}
#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return years.count;
            break;
        case 1:
            return months.count;
            break;
        case 2:
            return days.count;
            break;
        default:
            return 0;
            break;
    }
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    //    mycom1.frame = CGRectMake(0, 0, 90, 50);
    [mycom1 setFont:[UIFont boldSystemFontOfSize:18]];
    switch (component) {
        case 0:{
            NSString *str=[years objectAtIndex:row];
            if (self.calendarType == ChineseCalendar) {
                NSArray *array=[str componentsSeparatedByString:@"-"];
//                str=[NSString stringWithFormat:@"%@/%@", [((IDJChineseCalendar *)cal).chineseYears objectAtIndex:[[array objectAtIndex:1]intValue]-1], [array objectAtIndex:2]];
                str=[NSString stringWithFormat:@"%@",  [array objectAtIndex:0]];
            }
            mycom1.text=[NSString stringWithFormat:@"%@年", str];
            break;
        }
        case 1:{
            NSString *str=[NSString stringWithFormat:@"%@", [months objectAtIndex:row]];
            if (self.calendarType == ChineseCalendar) {
                NSArray *array=[str componentsSeparatedByString:@"-"];
                if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
                    mycom1.text=[((IDJChineseCalendar *)cal).chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1];
                } else {
                    mycom1.text=[NSString stringWithFormat:@"%@%@", @"闰", [((IDJChineseCalendar *)cal).chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
                }
            } else {
                mycom1.text=[NSString stringWithFormat:@"%@%@", str, @"月"];
            }
            break;
        }
        case 2:{
            if (self.calendarType == GregorianCalendar) {
                int day=[[days objectAtIndex:row]intValue];
                int weekday=[IDJCalendarUtil weekDayWithSolarYear:[cal.year intValue] month:cal.month day:day];
                mycom1.text=[NSString stringWithFormat:@"%d日 %@", day, [cal.weekdays objectAtIndex:weekday]];

            } else {
                 NSString *jieqi=[[IDJCalendarUtil jieqiWithYear:[cal.year intValue]]objectForKey:[NSString stringWithFormat:@"%@-%d", cal.month, [[days objectAtIndex:row]intValue]]];
               int chineseWeekday = [IDJCalendarUtil weekDayWithChineseYear:[cal.year intValue] month:cal.month day:[[days objectAtIndex:row]intValue]];
                TYLog(@"农历年----%@  农历月 ---- %@ 日---- %@", cal.year, cal.month, days);
                if (!jieqi) {
                    mycom1.text=[NSString stringWithFormat:@"%@ %@", [((IDJChineseCalendar *)cal).chineseDays objectAtIndex:[[days objectAtIndex:row]intValue]-1], [cal.weekdays objectAtIndex:chineseWeekday]];
                } else {
                    //NSLog(@"%@-%d-%@", cal.month, [[days objectAtIndex:cell]intValue], jieqi);
                    mycom1.text=[NSString stringWithFormat:@"%@ %@", jieqi, [cal.weekdays objectAtIndex:chineseWeekday]];
                }

            }
            break;
        }
        default:
            break;
    }
    
    if (self.calendarType == GregorianCalendar) {
//        阳历日转换成农历日
         NSDateComponents *components = [IDJCalendarUtil toChineseDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
        NSString *monthString = [IDJCalendarUtil monthFromCppToMineWithYear:components.year month:components.month];
        cal.des_year = [NSString stringWithFormat:@"%@", @(components.year)];
        cal.des_month = monthString;
        cal.des_day = [NSString stringWithFormat:@"%@", @(components.day)];
    }else {
//        农历转阳历
        NSDateComponents *components = [IDJCalendarUtil toSolarDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
        cal.des_year = [NSString stringWithFormat:@"%@", @(components.year)];
        cal.des_month = [NSString stringWithFormat:@"%@", @(components.month)];
        cal.des_day = [NSString stringWithFormat:@"%@", @(components.day)];
    }
    
    return mycom1;
}
//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return 90;
//            break;
//        case 1:
//            return 50;
//            break;
//        case 2:
//            return 70;
//            break;
//            
//        default:
//            return 150;
//            break;
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSString *str=[years objectAtIndex:row];
            if (self.calendarType == ChineseCalendar) {
//                NSArray *array=[str componentsSeparatedByString:@"-"];
//                str=[array objectAtIndex:2];
                NSString *pYear=[cal.year copy];
//                cal.era=[array objectAtIndex:0];
//                ((IDJChineseCalendar *)cal).jiazi=[array objectAtIndex:1];
                cal.year=str;
                //因为用户可能从2011年滚动，最后放手的时候，滚回了2011年，所以需要判断与上一次选中的年份是否不同，再联动月份的滚轮
                if (![pYear isEqualToString:cal.year]) {
                    [self changeMonths];
                }
            } else {
                cal.year=str;
                //因为公历的每年都是12个月，所以当年份变化的时候，只需要后面的天数联动
                [self changeDays];
            }
            break;
        }
        case 1:{
            NSString *pMonth=[cal.month copy];
            NSString *str=[months objectAtIndex:row];
            cal.month=str;
            if (![pMonth isEqualToString:cal.month]) {
                //联动天数的滚轮
                [self changeDays];
            }
            break;
        }
        case 2:{
            cal.day=[days objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    
    if (self.calendarType == GregorianCalendar) {
        cal.weekday=[NSString stringWithFormat:@"%d", [IDJCalendarUtil weekDayWithSolarYear:[cal.year intValue] month:cal.month day:[cal.day intValue]]];
    } else {
        cal.weekday=[NSString stringWithFormat:@"%d", [IDJCalendarUtil weekDayWithChineseYear:[cal.year intValue] month:cal.month day:[cal.day intValue]]];
        ((IDJChineseCalendar *)cal).animal=[IDJCalendarUtil animalWithJiazi:[((IDJChineseCalendar *)cal).jiazi intValue]];
    }
}

#pragma mark -Calendar Data Handle-
//动态改变农历月份列表，因为公历的月份只有12个月，不需要跟随年份滚轮联动
- (void)changeMonths{
    if (self.calendarType == ChineseCalendar) {
        [self _setMonthsInYear:[cal.year intValue]];
        [_pickerView reloadComponent:1];
        NSUInteger cell=[months indexOfObject:cal.month];
        if (cell==NSNotFound) {
            cell=0;
            cal.month=[months objectAtIndex:0];
        }
        [_pickerView selectRow:cell inComponent:1 animated:YES];
        //月份改变之后，天数进行联动
        [self changeDays];
    }
}

//动态改变日期列表
- (void)changeDays{
    [self _setDaysInMonth:cal.month year:[cal.year intValue]];
    [_pickerView reloadComponent:2];
    NSUInteger cell=[days indexOfObject:cal.day];
    //假如用户上次选择的是1月31日，当月份变为2月的时候，第三列的滚轮不可能再选中31日，我们设置默认的值为第一个。
    if (cell==NSNotFound) {
        cell=0;
        cal.day=[days objectAtIndex:0];
    }
    [_pickerView selectRow:cell inComponent:2 animated:YES];
}


#pragma mark -Fill init Data-
//填充年份
- (void)_setYears {
    years = [[NSMutableArray alloc]init];
    years=[cal yearsInRange];
}

//填充月份
- (void)_setMonthsInYear:(NSUInteger)_year {
    months = [[NSMutableArray alloc]init];
    months=[cal monthsInYear:_year];
}

//填充天数
- (void)_setDaysInMonth:(NSString *)_month year:(NSUInteger)_year {
    days = [[NSMutableArray alloc]init];
    days=[cal daysInMonth:_month year:_year];
}

- (void)selectCalendarClick:(UIButton *)sender {
    if (IsMinYear) {
        [TYShowMessage showPlaint:@"当前时间为最低年限"];
        return;
    }
    if (IsMaxYear) {
        [TYShowMessage showPlaint:@"当前时间为最高年限"];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.calendarType = ChineseCalendar;
    } else {
        self.calendarType = GregorianCalendar;
    }
}


- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide {
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

//确定选择
-(void)dateConfirmClick{
    if (IsMinYear) {
        [TYShowMessage showPlaint:@"当前时间为最低年限"];
        return;
    }
    if (IsMaxYear) {
        [TYShowMessage showPlaint:@"当前时间为最高年限"];
        return;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(notifyNewCalendar:)] == YES) {
            [self.delegate notifyNewCalendar:cal];
        }
    }
    
    [self removeAnimation];
}
//取消选择
-(void)dateCancleClick{
    [self removeAnimation];
}

-(void)pickerViewClick{
    
}

@end
