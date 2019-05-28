//
//  JGJNewSelectedDataPickerView.m
//  mix
//
//  Created by Tony on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNewSelectedDataPickerView.h"
#import "NSDate+Extend.h"
@interface JGJNewSelectedDataPickerView ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSInteger yearIndex;
    
    NSInteger monthIndex;
    
    NSInteger dayIndex;
    
    
    UIView *topV;
    UIView *_moreDayView;
    
    BOOL _isToday;
    NSInteger _todayIndex;// 今天的位置在dayArray中
    
    UIButton *_moreDayBtn;
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, strong) NSMutableArray *dayArray;


@property (nonatomic, strong) NSDateComponents *comp;


@end


@implementation JGJNewSelectedDataPickerView

- (void)setTimeAfterYear:(NSInteger)timeAfterYear {
    
    _timeAfterYear = timeAfterYear;
    [_yearArray removeAllObjects];
    [self.pickerView reloadAllComponents];
    for (int year = 2014; year < self.comp.year + 1 + _timeAfterYear; year++) {
        
        NSString *str = [NSString stringWithFormat:@"%d年", year];
        
        [_yearArray addObject:str];
    }
}

- (NSMutableArray *)yearArray {
    
    if (_yearArray == nil) {
        
        _yearArray = [NSMutableArray array];
        
        for (int year = 2014; year < self.comp.year + 1; year++) {
            
            NSString *str = [NSString stringWithFormat:@"%d年", year];
            
            [_yearArray addObject:str];
        }
    }
    
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray array];
        
        for (int month = 1; month <= 12; month++) {
            
            NSString *str = [NSString stringWithFormat:@"%02d月", month];
            
            [_monthArray addObject:str];
        }
    }
    
    return _monthArray;
}

- (NSMutableArray *)dayArray {
    
    if (_dayArray == nil) {
        
        _dayArray = [NSMutableArray array];
        
        for (int day = 1; day <= 31; day++) {
            
            NSString *str = [NSString stringWithFormat:@"%02d日", day];
            
            [_dayArray addObject:str];
        }
    }
    return _dayArray;
}


- (NSDateComponents *)comp {
    
    if (!_comp) {
        
        NSCalendar *calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay |
        NSCalendarUnitHour |  NSCalendarUnitMinute |
        NSCalendarUnitSecond | NSCalendarUnitWeekday;
        // 获取不同时间字段的信息
        _comp = [calendar components: unitFlags fromDate:[NSDate date]];
        
    }
    return _comp;
}

- (instancetype)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        _isToday = YES;
        _isNeedLimitTimeChoice = YES;
        topV = [[UIView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 40)];
        topV.backgroundColor = AppFontEB4E4EColor;
        [self addSubview:topV];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 100, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:FONT(AppFont30Size)];
        [cancelBtn addTarget:self action:@selector(removeThePicker) forControlEvents:UIControlEventTouchUpInside];
        [topV addSubview:cancelBtn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"选择时间";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = FONT(AppFont30Size);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topV addSubview:titleLabel];
        
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.frame = CGRectMake(TYGetUIScreenWidth - 100, 0, 100, 40);
        [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
        [yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [yesBtn.titleLabel setFont:FONT(AppFont30Size)];
        [yesBtn addTarget:self action:@selector(sureToChoiceTheData) forControlEvents:UIControlEventTouchUpInside];
        [topV addSubview:yesBtn];
        
        titleLabel.sd_layout.leftSpaceToView(cancelBtn, 10).rightSpaceToView(yesBtn, 10).centerYEqualToView(topV).heightIs(40);
        
        UIView *moreDayView = [[UIView alloc] initWithFrame:CGRectMake(0, topV.bottom, TYGetUIScreenWidth, 0)];
        moreDayView.backgroundColor = [UIColor whiteColor];
        [self addSubview:moreDayView];
        _moreDayView = moreDayView;
        
        
        UIButton *moreDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreDayBtn setImage:IMAGE(@"moreDaydate") forState:UIControlStateNormal];
        [moreDayBtn setImage:IMAGE(@"moreDaydate") forState:UIControlStateHighlighted];
        [moreDayBtn setTitle:@"批量记多天" forState:UIControlStateNormal];
        moreDayBtn.titleLabel.font = FONT(15);
        moreDayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [moreDayBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        [moreDayBtn addTarget:self action:@selector(clickMoreDayBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_moreDayView addSubview:moreDayBtn];
        _moreDayBtn = moreDayBtn;
        [moreDayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(_moreDayView.mas_centerX).mas_offset(0);
            make.centerY.equalTo(_moreDayView.mas_centerY).mas_offset(0);
        }];
        
        [moreDayBtn updateLayout];
        [moreDayBtn.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _moreDayView.bottom, TYGetUIScreenWidth, 207)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
        yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年", self.comp.year]];
        monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月", self.comp.month]];
        dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日", self.comp.day]];
        
        for (int i = 0; i < self.dayArray.count; i ++) {
            
            if (self.comp.day == [[self.dayArray[i] stringByReplacingOccurrencesOfString:@"日" withString:@""] integerValue]) {
                
                _todayIndex = i;
            }
        }
    }
    return self;
}

- (void)clickMoreDayBtn {
    
    if ([self.pickerDelegate respondsToSelector:@selector(JGJNewSelectedDataPickerViewClickMoreDayBtn)]) {
        
        [self.pickerDelegate JGJNewSelectedDataPickerViewClickMoreDayBtn];
    }
}

- (void)setSelectedTimeStr:(NSString *)selectedTimeStr {
    
    _selectedTimeStr = selectedTimeStr;
    NSArray *timeArr = [_selectedTimeStr componentsSeparatedByString:@" "];
    NSArray *yearMDArr = [timeArr[0] componentsSeparatedByString:@"-"];
    
    yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%@年", yearMDArr[0]]];
    monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%@月", yearMDArr[1]]];
    dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%@日", yearMDArr[2]]];    
    [_pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [_pickerView selectRow:monthIndex inComponent:1 animated:YES];
    [_pickerView selectRow:dayIndex inComponent:2 animated:YES];
    
    [self pickerView:_pickerView didSelectRow:yearIndex inComponent:0];
    [self pickerView:_pickerView didSelectRow:monthIndex inComponent:1];
    [self pickerView:_pickerView didSelectRow:dayIndex inComponent:2];
}


- (void)setSelectedDate:(NSDate *)selectedDate {
    
    _selectedDate = selectedDate;
    NSString *selectedStr = [NSDate stringFromDate:_selectedDate format:@"yyyy-MM-dd"];
    NSArray *yearMDArr = [selectedStr componentsSeparatedByString:@"-"];
    
    yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%@年", yearMDArr[0]]];
    monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%@月", yearMDArr[1]]];
    dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%@日", yearMDArr[2]]];
    [_pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [_pickerView selectRow:monthIndex inComponent:1 animated:YES];
    [_pickerView selectRow:dayIndex inComponent:2 animated:YES];
}

- (void)setIsNeedShowToday:(BOOL)isNeedShowToday {
    
    _isNeedShowToday = isNeedShowToday;
  
}

- (void)setIsNeddShowMoreDayChoiceBtn:(BOOL)isNeddShowMoreDayChoiceBtn {
    
    _isNeddShowMoreDayChoiceBtn = isNeddShowMoreDayChoiceBtn;
    if (_isNeddShowMoreDayChoiceBtn) {
        
        _moreDayBtn.hidden = NO;
    }else {
        
        _moreDayBtn.hidden = YES;
    }
}

- (void)setIsNeedLimitTimeChoice:(BOOL)isNeedLimitTimeChoice {
    
    _isNeedLimitTimeChoice = isNeedLimitTimeChoice;
}

- (void)hiddenPicker {
    
    [self removeFromSuperview];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (_isNeddShowMoreDayChoiceBtn) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            topV.frame = CGRectMake(0, TYGetUIScreenHeight - 307, TYGetUIScreenWidth, 40);
            _moreDayView.frame = CGRectMake(0, topV.bottom, TYGetUIScreenWidth, 60);
            _pickerView.frame = CGRectMake(0, _moreDayView.bottom, TYGetUIScreenWidth, 207);
        }];
    }else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            topV.frame = CGRectMake(0, TYGetUIScreenHeight - 247, TYGetUIScreenWidth, 40);
            _moreDayView.frame = CGRectMake(0, topV.bottom, TYGetUIScreenWidth, 0);
            _pickerView.frame = CGRectMake(0, _moreDayView.bottom, TYGetUIScreenWidth, 207);
        }];
    }
    
}

- (void)remove {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (_isNeddShowMoreDayChoiceBtn) {
            
            topV.frame = CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 40);
            _moreDayView.frame = CGRectMake(0, topV.bottom, TYGetUIScreenWidth, 60);
            _pickerView.frame = CGRectMake(0, _moreDayView.bottom, TYGetUIScreenWidth, 207);
        }else {
            
            topV.frame = CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 40);
            _moreDayView.frame = CGRectMake(0, topV.bottom, TYGetUIScreenWidth, 0);
            _pickerView.frame = CGRectMake(0, _moreDayView.bottom, TYGetUIScreenWidth, 207);
        }
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
#pragma mark - method
- (void)removeThePicker {
    
    [self remove];
}

- (void)sureToChoiceTheData {
    
    if ([_pickerView viewForRow:yearIndex forComponent:0] == nil || [_pickerView viewForRow:monthIndex forComponent:1] == nil || [_pickerView viewForRow:dayIndex forComponent:2] == nil) {
        
        return;
    }
    
    // 是否限制时间选择,默认限制
    if (_isNeedLimitTimeChoice) {
        
        // 判断选择日期年是否大于今年
        if ([[self.yearArray[yearIndex] stringByReplacingOccurrencesOfString:@"年" withString:@""] integerValue] == self.comp.year) {
            
            if ([[self.monthArray[monthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""] integerValue] > self.comp.month) {
                
                [TYShowMessage showPlaint:@"不能记录今天之后的日期"];
                return;
            }else if ([[self.monthArray[monthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""] integerValue] == self.comp.month) {
                
                if ([[[self.dayArray[dayIndex] stringByReplacingOccurrencesOfString:@"日" withString:@""] stringByReplacingOccurrencesOfString:@"(今天)" withString:@""] integerValue] > self.comp.day) {
                    
                    [TYShowMessage showPlaint:@"不能记录今天之后的日期"];
                    return;
                }
            }
        }
        
    }
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@%@%@",((UILabel *)[_pickerView viewForRow:yearIndex forComponent:0]).text, ((UILabel *)[_pickerView viewForRow:monthIndex forComponent:1]).text, ((UILabel *)[_pickerView viewForRow:dayIndex forComponent:2]).text];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"日" withString:@""];

    if (_isNeedShowToday) {
        
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
    }
    _choiceData([timeStr componentsSeparatedByString:@"-"],timeStr);
    
    // 是否为代班长记账，如果是，需要判断代班长的有效记录时间
    if (self.isAgentMonitor) {
        
        // 判断有无起始时间
        if (![NSString isEmpty:self.start_time]) {
            
            // 判断选择的时间是否小于起始时间
            NSDate *date = [NSDate dateFromStringWith0GMT:timeStr withDateFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [NSDate dateFromString:self.start_time withDateFormat:@"yyyy-MM-dd"];
            NSComparisonResult result = [date compare:startDate];
            // 表示选择的时间 date小于 代班长起始的代班时间
            if (result == NSOrderedAscending) {
                
                NSString *startTime = [self.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                // 如果end_time不为空 则提示 区间短时间
                if (![NSString isEmpty:self.end_Time]) {
                    
                    NSString *endTime = [self.end_Time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长只能在%@~%@时间段内记账",startTime,endTime]];
                    return;
                }else {
                    
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长不能记录%@以前的账",startTime]];
                    return;
                }
            }
        }
    }
    
    if ([self.pickerDelegate respondsToSelector:@selector(JGJNewSelectedDataPickerViewSelectedDate:)]) {
        
        [self.pickerDelegate JGJNewSelectedDataPickerViewSelectedDate:[NSDate dateFromStringWith0GMT:timeStr withDateFormat:@"yyyy-MM-dd"]];
    }
    [self remove];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self remove];
}


#pragma mark -UIPickerView
#pragma mark UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return self.yearArray.count;
        
    }else if(component == 1) {
        
        return self.monthArray.count;
        
    }else {
        
        switch (monthIndex + 1) {
                
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12: return 31;
                
            case 4:
            case 6:
            case 9:
            case 11: return 30;
                
            default: return 28;
        }
    }
}

#pragma mark -UIPickerView的代理
// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        yearIndex = row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = AppFontEB4E4EColor;
            label.font = FONT(AppFont34Size);
            
        });
        
    }else if (component == 1) {
        
        monthIndex = row;
        
        [pickerView reloadComponent:2];
        
        
        if (monthIndex + 1 == 4 || monthIndex + 1 == 6 || monthIndex + 1 == 9 || monthIndex + 1 == 11) {
            
            if (dayIndex + 1 == 31) {
                
                dayIndex--;
            }
        }else if (monthIndex + 1 == 2) {
            
            if (dayIndex + 1 > 28) {
                dayIndex = 27;
            }
        }
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = AppFontEB4E4EColor;
            label.font = FONT(AppFont34Size);
            

            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:dayIndex forComponent:2];
            label.textColor = AppFontEB4E4EColor;
            label.font = FONT(AppFont34Size);
            
        });
    }else {
        
        dayIndex = row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
            label.textColor = AppFontEB4E4EColor;
            label.font = FONT(AppFont34Size);
            
        });
    }
    
    // 2.如果要求显示今天 判断选择的是否是今年 今月
    if (_isNeedShowToday) {
        
        UILabel *label = (UILabel *)[pickerView viewForRow:_todayIndex forComponent:2];
        // 1.取出选择的年月日
        NSString *selectedYear = [self.yearArray[yearIndex] stringByReplacingOccurrencesOfString:@"年" withString:@""];
        NSString *selectedMonth = [self.monthArray[monthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        if (self.comp.year == [selectedYear integerValue] && self.comp.month == [selectedMonth integerValue]) {
            
            label.text = [NSString stringWithFormat:@"%@(今天)", self.dayArray[_todayIndex]];
            
            
        }else {
            
            label.text = [label.text stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
            
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
        //设置分割线的颜色
        for(UIView *singleLine in pickerView.subviews)
        {
            if (singleLine.frame.size.height < 1)
            {
                singleLine.hidden = YES;
            }
        }
    
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor grayColor];
    genderLabel.font = FONT(AppFont34Size);
    if (component == 0) {
        
        genderLabel.text = self.yearArray[row];
        
    }else if (component == 1) {
        
        genderLabel.text = self.monthArray[row];
        
    }else {
        
        
        genderLabel.text = self.dayArray[row];
    }
    
    
    // 2.如果要求显示今天 判断选择的是否是今年 今月
    if (_isNeedShowToday) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UILabel *label = (UILabel *)[pickerView viewForRow:_todayIndex forComponent:2];
            // 1.取出选择的年月日
            NSString *selectedYear = [self.yearArray[yearIndex] stringByReplacingOccurrencesOfString:@"年" withString:@""];
            NSString *selectedMonth = [self.monthArray[monthIndex] stringByReplacingOccurrencesOfString:@"月" withString:@""];
            if (self.comp.year == [selectedYear integerValue] && self.comp.month == [selectedMonth integerValue]) {
                
                label.text = [NSString stringWithFormat:@"%@(今天)", self.dayArray[_todayIndex]];
                
            }else {
                
                label.text = [label.text stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
                
            }
        });
        
    }
    return genderLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40.0;
}
@end
