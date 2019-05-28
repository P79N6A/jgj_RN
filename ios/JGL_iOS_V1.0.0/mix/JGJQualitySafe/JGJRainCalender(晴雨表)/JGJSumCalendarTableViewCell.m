//
//  JGJSumCalendarTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSumCalendarTableViewCell.h"
#import "NSDate+Extend.h"
#import "YZGDatePickerView.h"
#import "JGJTime.h"
#define leftArrow 110
#define rightArrow 100

@interface JGJSumCalendarTableViewCell()
<
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarHeaderDelegate,
FSCalendarDelegateAppearance,
YZGDatePickerViewDelegate
>
{
    NSMutableArray *dataArr;

}
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@end
@implementation JGJSumCalendarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _calendar.delegate   = self;
    _calendar.dataSource = self;
    _calendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _calendar.allowsMultipleSelection = NO;
    _calendar.appearance.borderSelectionColor = AppFontd7252cColor;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;//取消圆角显示
    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    _calendar.appearance.titleDefaultColor = AppFont333333Color;
    _calendar.selectShow = YES;
    _calendar.header.delegate = self;
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _calendar.appearance.titleFont = [UIFont systemFontOfSize:AppFont32Size];
    _calendar.appearance.weekdayTextColor = AppFont999999Color;
    _calendar.appearance.weekdayFont = [UIFont systemFontOfSize:AppFont20Size];
    _calendar.appearance.headerTitleColor = AppFont333333Color;
    _calendar.header.leftAndRightShow = YES;
    _calendar.appearance.todayColor = [UIColor whiteColor];
    _calendar.appearance.titleTodayColor = AppFontd7252cColor;
    _calendar.appearance.todaySelectionColor = AppFontf1f1f1Color;
    _calendar.appearance.borderSelectionColor = AppFontccccccColor;
    _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:AppFont30Size];
    _calendar.header.needSelectedTime = YES;
    _calendar.headerHeight = 60;
    _calendar.rainCalendar = YES;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];
    
    if (!_closePro) {
        [self.contentView addSubview:self.closeView];
    }
    [self.calendar selectDate:[NSDate date]];
    _closeView.hidden = YES;
}
-(void)setClosePro:(BOOL)closePro
{
    if (closePro) {
        [self.contentView addSubview:self.closeView];
    }

}
-(UIImageView *)closeView
{
    if (!_closeView) {
        _closeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 126, 71)];
        _closeView.image = [UIImage imageNamed:@"weather_item-turnoff"];
        _closeView.center =   CGPointMake(TYGetUIScreenWidth/2, CGRectGetMidY(self.contentView.frame) +30);

    }
    return _closeView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
//此处设置天气信息
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期

    for (int i = 0; i<dataArr.count; i++) {
        JGJRainCalenderDetailModel *model =(JGJRainCalenderDetailModel *)dataArr[i];
    if ([[model create_time] intValue] ==  index) {
        return [NSString stringWithFormat:@"%@-%@-%@-%@",model.weat_one?:@"0",model.weat_two?:@"0",model.weat_three?:@"0",model.weat_four?:@"0"];
        }
    }
return @"";
}

#pragma mark - FSCalendarDataSource
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [calendar dateWithYear:2014 month:1 day:1];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    //    return [NSDate date];
    return [NSDate getLastDayOfThisMonth];
}
- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    [self layoutIfNeeded];
}
- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader{

//    self.yzgDatePickerView.defultTime = YES;
    [self.yzgDatePickerView setSelectedDate:_calendar.currentPage?:[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
    
}
#pragma mark - 选择完了时间 更新日历
- (void)YZGDataPickerSelect:(NSDate *)date{
    
    [self.calendar disChangeMonthDyDate:date];
    
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = TYColorHex(0xafafaf);
    }else{
        //      color = TYColorHex(0x2e2e2e);
        //      color = AppFont333333Color;/
        color = AppFont333333Color;
    }
    
    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = JGJMainColor;
    }else{
        color = JGJMainColor;
    }
    
    return color;
}

//- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
//    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
//}

-(void)reciveNotification:(NSNotification *)obj
{
    if ([obj.object intValue] == leftArrow) {
        NSDate *currentMonth = _calendar.currentPage;
        NSDate *previousMonth = [_calendar dateBySubstractingMonths:1 fromDate:currentMonth];
        
        [_calendar setCurrentPage:previousMonth animated:NO];
        
    }else{
        NSDate *currentMonth = _calendar.currentPage;
        NSDate *nextMonth = [_calendar dateByAddingMonths:1 toDate:currentMonth];
        [_calendar setCurrentPage:nextMonth animated:NO];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{

     dataArr = [[NSMutableArray alloc]init];
//    [_calendar reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sumerCalenderdidScorllpagewithDate:)]) {
        
        [self.delegate sumerCalenderdidScorllpagewithDate:calendar.currentPage];
        
    }
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:_calendar.currentPage]];

}
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    BOOL hadContent = NO;
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    
    for (int i = 0; i<dataArr.count; i++) {
        JGJRainCalenderDetailModel *model =(JGJRainCalenderDetailModel *)dataArr[i];
        if ([[model create_time] intValue] ==  index) {
            hadContent = YES;
        }
    }
    if (!hadContent) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sumerCalenderdidSelectdWithDate:)]) {
        [self.delegate sumerCalenderdidSelectdWithDate:date];
    }
    }else{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sumerCalenderdidSelectdWithDateAndGetContent:)]) {
            [self.delegate sumerCalenderdidSelectdWithDateAndGetContent:date];
        }
    }

}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    
    
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}
- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}
-(void)setRainCalenderDetailModel:(JGJRainCalenderDetailModel *)rainCalenderDetailModel
{
    if (!_rainCalenderDetailModel) {
        _rainCalenderDetailModel = [JGJRainCalenderDetailModel new];
    }
    _rainCalenderDetailModel = rainCalenderDetailModel;

//    [_calendar reloadData];
}
-(void)setWorkCicleProListModel:(JGJMyWorkCircleProListModel *)WorkCicleProListModel
{
    if (!_WorkCicleProListModel) {
        _WorkCicleProListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkCicleProListModel = WorkCicleProListModel;
    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:_calendar.currentPage]];

}
-(void)getdetailCalenderwithmonth:(NSString *)month
{
    dataArr = [[NSMutableArray alloc]init];
//    [_calendar reloadData];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"weather" forKey:@"ctrl"];
    [parmDic setObject:@"getWeatherList" forKey:@"action"];
//    [parmDic setObject:JGJSHA1Sign forKey:@"sign"];
    [parmDic setObject:_WorkCicleProListModel.class_type?:@"" forKey:@"class_type"];
    
    
    [parmDic setObject:[TYUserDefaults objectForKey:JLGUserUid] forKey:@"uid"];
    
    if (_WorkCicleProListModel.class_type) {
        
    
    if ([_WorkCicleProListModel.class_type isEqualToString:@"team"]) {
        [parmDic setObject:_WorkCicleProListModel.team_id?:@"" forKey:@"group_id"];
    }else{
        [parmDic setObject:_WorkCicleProListModel.group_id?:@"" forKey:@"group_id"];
    }
    }
    [parmDic setObject:month forKey:@"month"];
//    [parmDic setObject:@"1" forKey:@"pg"];
//    [parmDic setObject:@"10" forKey:@"pagesize"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [parmDic setObject:app_Version forKey:@"ver"];    
    [JLGHttpRequest_AFN PostWithApi:@"v2/weather/getWeatherList" parameters:parmDic success:^(id responseObject) {
        dataArr = [[NSMutableArray alloc]init];
        dataArr = [JGJRainCalenderDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        [UIView animateWithDuration:0 animations:^{
            [_calendar reloadData];

        }];
        if (dataArr.count) {
        _closeView.hidden = ![[(JGJRainCalenderDetailModel *)dataArr[0] is_close] intValue];
        _YONclosePro = [[(JGJRainCalenderDetailModel *)dataArr[0] is_close] intValue];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)reloadDataAccordingDate
{

    [self getdetailCalenderwithmonth:[JGJTime yearAppendMonthfromstamp:_calendar.currentPage]];

}
@end
