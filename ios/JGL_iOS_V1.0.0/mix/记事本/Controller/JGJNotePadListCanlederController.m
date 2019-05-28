//
//  JGJNotePadListCanlederController.m
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNotePadListCanlederController.h"
#import "MyCalendarObject.h"
#import "JGJCalenderDateView.h"
#import "FSCalendar.h"
#import "NSDate+Extend.h"
#import "JGJNotePadCanledarModel.h"
#import "JGJNoteListCanledarBottomView.h"
#import "JGJNotePadCanledarOneDayController.h"
#import "YZGDatePickerView.h"
#import "JGJAddNewNotepadViewController.h"
@interface JGJNotePadListCanlederController ()<JGJCalenderDateViewDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarHeaderDelegate,UINavigationControllerDelegate,YZGDatePickerViewDelegate>

@property(nonatomic ,strong) FSCalendar *calendar;
@property (strong, nonatomic) UIButton *backUpButton;
@property (nonatomic, strong) NSCalendar *holidayLunarCalendar;
@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (strong, nonatomic) JGJCalenderDateView *CalenderDateView;
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
@property (nonatomic, strong) JGJNoteListCanledarBottomView *bottomView;

// 记录push标志
@property (nonatomic, assign) BOOL pushing;

@property (nonatomic, copy) NSArray *listArray;
@end

@implementation JGJNotePadListCanlederController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
    
    [self getCalendarNoteBookData];
}

- (void)getCalendarNoteBookData {
    
    NSString *date;
    if ([NSString isEmpty:[self.calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"]] ||[self.calendar stringFromDate:self.calendar.currentPage format:@"yyyyMM"] == nil) {
        
        date = [self.calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
        
    }else{
        
        date = [self.calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"];
    }
    
    NSDictionary *paramc = @{@"month":date};
    [JLGHttpRequest_AFN PostWithNapi:@"notebook/calendar" parameters:paramc success:^(id responseObject) {
        
        self.listArray = [JGJNotePadCanledarModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.calendar reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
}

 - (void)initializeAppearance {
 
     [self.view addSubview:self.calendar];
     [self.view addSubview:self.CalenderDateView];
     [self.view addSubview:self.bottomView];
}

- (void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FSCalendarDataSource
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
//        color = AppFont666666Color;
        color = AppFont333333Color;
    }else{
        color = AppFont333333Color;
    }
//    color = AppFont000000Color;
    return color;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [calendar dateWithYear:2014 month:1 day:1];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    // 获取当前年份
    NSDateComponents *com = [NSDate getYearAndMonthWithDate:[NSDate date]];
    NSInteger noewYear = com.year;
    
    return [calendar dateWithYear:noewYear + 2 month:12 day:31];
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    
    NSDateComponents *holidayComponents = [self.holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    //判断是否是节日
    NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    
    if (![holiday isEqualToString:@""]) {
        
        for (int i = 0; i < self.listArray.count; i++) {
            
            JGJNotePadCanledarModel *recordMonthModel = (JGJNotePadCanledarModel *)self.listArray[i];
            
            if ([recordMonthModel.date intValue] == index) {
                
                NSString *holidayStr = [NSString stringWithFormat:@"%@-%@-%@-%@",holiday,recordMonthModel.date,recordMonthModel.is_import,recordMonthModel.note_num];
                
                return holidayStr;
            }
        }
        
        return holiday;
        
    }else{
        
        NSDateComponents *lunarComponents = [self.lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
        NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
        if (![holidayDic[@"holiday"] isEqualToString:@""]) {
            
            for (int i = 0; i < self.listArray.count; i++) {
                
                JGJNotePadCanledarModel *recordMonthModel = (JGJNotePadCanledarModel *)self.listArray[i];
                
                if ([recordMonthModel.date intValue] == index) {
                    
                    NSString *holidayStr = [NSString stringWithFormat:@"%@-%@-%@-%@",holidayDic[@"holiday"],recordMonthModel.date,recordMonthModel.is_import,recordMonthModel.note_num];
                    
                    return holidayStr;
                }
            }
            
            return holidayDic[@"holiday"];
            
        }else{
            
            for (int i = 0; i < self.listArray.count; i++) {
                
                JGJNotePadCanledarModel *recordMonthModel = (JGJNotePadCanledarModel *)self.listArray[i];
                
                if ([recordMonthModel.date intValue] == index) {
                    
                    NSString *holidayStr = [NSString stringWithFormat:@"%@-%@-%@-%@",holidayDic[@"day"],recordMonthModel.date,recordMonthModel.is_import,recordMonthModel.note_num];
                    
                    return holidayStr;
                }
            }
            
            return holidayDic[@"day"];
        }
    }
}

#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    [self getCalendarNoteBookData];
    
    if ([NSDate calculateCalendarRows:calendar.currentPage] == 5) {
        
        _calendar.frame = CGRectMake(0, CGRectGetMaxY(self.CalenderDateView.frame) - 35, TYGetUIScreenWidth, 70 + 68.00/375 * TYGetUIScreenWidth * 5);
        
    }else {
        
        _calendar.frame = CGRectMake(0, CGRectGetMaxY(self.CalenderDateView.frame) - 35, TYGetUIScreenWidth, 70 + 68.00/375 * TYGetUIScreenWidth * 6);
        
    }
    
    _bottomView = [[JGJNoteListCanledarBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendar.frame) + 90, TYGetUIScreenWidth, 45)];
    
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage ? : [NSDate date]];
    
    _CalenderDateView.rightDateButton.hidden = _calendar.currentPage.components.month == 12 && _calendar.currentPage.components.year == ([NSDate date].components.year + 2);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    
//    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
    return YES;
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    
    // 是否当前点击日期有记事
    BOOL isHaveRecord = NO;
    for (int i = 0; i < self.listArray.count; i++) {
        
        JGJNotePadCanledarModel *recordMonthModel = (JGJNotePadCanledarModel *)self.listArray[i];
        
        if ([recordMonthModel.date intValue] == index) {
         
            isHaveRecord = YES;
            
            break;
        }else {
            
            isHaveRecord = NO;
        }
    }
    
    if (isHaveRecord) {
        
        JGJNotePadCanledarOneDayController * oneDayVC = [[JGJNotePadCanledarOneDayController alloc] init];
        oneDayVC.oneDayDate = date;
        [self.navigationController pushViewController:oneDayVC animated:YES];
        
    }else {
        
        JGJAddNewNotepadViewController *addController = [[JGJAddNewNotepadViewController alloc] init];
        
        JGJNotepadListModel *noteModel = [[JGJNotepadListModel alloc] init];
        noteModel.weekday = [NSDate weekdayWithDate:date];
        noteModel.publish_time = [NSDate stringFromDate:date format:@"yyyy-MM-dd"];
        addController.noteModel = noteModel;
        
        addController.tagVC = self;
        addController.orignalImgArr = [[NSMutableArray alloc] init];
        [self presentViewController:addController animated:YES completion:nil];
        
    }
    

}
#pragma mark - JGJCalenderDateViewDelegate
- (void)JGJCalenderDateViewClickrightButton {
    
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *nextMonth = [_calendar dateByAddingMonths:1 toDate:currentMonth];
    [_calendar setCurrentPage:nextMonth animated:YES];

    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self getCalendarNoteBookData];
    
}

- (void)JGJCalenderDateViewClickLeftButton {
    
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *previousMonth = [_calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [_calendar setCurrentPage:previousMonth animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self getCalendarNoteBookData];
    
}


- (void)JGJCalenderDateViewtapdateLable {
    
    [self.yzgDatePickerView setDate:_calendar.currentPage?:[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
    
}
- (void)YZGDataPickerSelect:(NSDate *)date {
    
    [_calendar setCurrentPage:date?:[NSDate date] animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self getCalendarNoteBookData];
    
}


//顶部选择时间的
- (JGJCalenderDateView *)CalenderDateView {
    
    if (!_CalenderDateView) {
        
        _CalenderDateView = [[JGJCalenderDateView alloc]initWithFrame:CGRectMake(0, 0 + iphoneXheightnav, TYGetUIScreenWidth, 64)];
        _CalenderDateView.backgroundColor = [UIColor whiteColor];
        _CalenderDateView.delegate = self;
        [_CalenderDateView addSubview:self.backUpButton];
        self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:self.calendar.currentPage?:[NSDate date]];
        
    }
    return _CalenderDateView;
}

- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
        NSDateComponents *com = [NSDate getYearAndMonthWithDate:[NSDate date]];
        [self.yzgDatePickerView setDatePickerMinDate:@"2014-1-1" maxDate:[NSString stringWithFormat:@"%ld-12-31",com.year + 2]];
        
    }
    return _yzgDatePickerView;
}

#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.pushing == YES) {

        return;
        
    } else {
        
        self.pushing = YES;
    }

    [self.navigationController pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    self.pushing = NO;
}


- (UIButton *)backUpButton {
    
    if (!_backUpButton) {
        
        _backUpButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, JGJ_IphoneX_Or_Later ? 17 : 24, 80, 30)];
        _backUpButton.titleLabel.font = FONT(AppFont32Size);
        [_backUpButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [_backUpButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backUpButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
        [_backUpButton setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
        [_backUpButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _backUpButton;
}

- (FSCalendar *)calendar {
    
    if (!_calendar) {
        

        _calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.CalenderDateView.frame) - 35, TYGetUIScreenWidth, 70 + 68.00/375 * TYGetUIScreenWidth * [NSDate calculateCalendarRows:[NSDate date]])];
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.titleDefaultColor = AppFontccccccColor;
        _calendar.appearance.titleSelectionColor = AppFont333333Color;
        _calendar.appearance.selectionColor = AppFontfdf0f0Color;
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.appearance.titleTodayColor = AppFontd7252cColor;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase | FSCalendarCaseOptionsWeekdayUsesUpperCase;
        _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.notepadListCalendar = YES;
        _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
        _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
        _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
        _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
        _calendar.appearance.todayColor = AppFontfafafaColor;
        _calendar.appearance.titleTodayColor = AppFontd7252cColor;
        _calendar.header.delegate = self;
        _calendar.header.bigfont = YES;
        _calendar.headerHeight = 70;
        _calendar.header.needSelectedTime = YES;
        _calendar.header.leftAndRightShow = YES;
        _calendar.header.hiddenHeaderTitle = YES;
        _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
        _calendar.headerNeedOffset = YES;
        _calendar.header.hidden = YES;
        _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:17];
    }
    return _calendar;
}

- (NSCalendar *)holidayLunarCalendar {
    
    if (!_holidayLunarCalendar) {
        
        _holidayLunarCalendar = [NSCalendar currentCalendar];
        _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _holidayLunarCalendar;
}

- (NSCalendar *)lunarCalendar {
    
    if (!_lunarCalendar) {
        
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _lunarCalendar;
}

- (NSArray *)listArray {
    
    if (!_listArray) {
        
        _listArray = [[NSArray alloc] init];
    }
    return _listArray;
}

- (JGJNoteListCanledarBottomView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[JGJNoteListCanledarBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendar.frame) + 90, TYGetUIScreenWidth, 45)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
@end
