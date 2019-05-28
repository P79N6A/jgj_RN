//
//  JGJCalendarViewController.m
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCalendarViewController.h"
#import "JGJCalendarFirstCell.h"
#import "JGJCalendarSecCell.h"
#import "JGJCalendarThirdCell.h"
#import "JGJCalendarFourthCell.h"
#import "JGJSelectedSuitableDayViewController.h"
#import "GYZCustomCalendarPickerView.h"
#import "NSDate+Extend.h"
#import "MyCalendarObject.h"
#import "TYFMDB.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JGJCalendarTool.h"
#import "JGJWebAllSubViewController.h"
#import "HomeVC.h"
#import "UIButton+JGJUIButton.h"
#define YearStart 2011
#define YearEnd 2020
@interface JGJCalendarViewController () <
UITableViewDataSource,
UITableViewDelegate,
GYZCustomCalendarPickerViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GYZCustomCalendarPickerView *calendarPickerView;
@property (strong, nonatomic) IDJCalendar *calendar;
@property (strong, nonatomic) NSArray *totalDays;//上个月总天数 用于时间的增减
@property (strong, nonatomic) NSArray *weekDays;
@property (strong, nonatomic) NSArray *todayRecms;//今日推荐模型
@end

@implementation JGJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBackButton];//返回按钮按下
    [self setCurrentDefaultDate];//当calendarModel.all_date没有值时设置默认当前时间
    [self navigationItemItem];//设置导航栏按钮
    [self getCalendarDatabaseWithDate:self.calendarModel.all_date]; //根据all_date查询数据
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (TYiOS8Later) {
        self.navigationController.navigationBar.translucent = YES;
    }
    
    if (!self.navigationController.navigationBar.shadowImage) {
        //导航栏透明
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
    }
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    if (TYiOS8Later) {
        self.navigationController.navigationBar.translucent = NO;
    }
    if (self.navigationController.navigationBar.shadowImage) {
        //导航栏透明
        [self.navigationController.navigationBar setShadowImage:nil];//显示那条线
    }
}

#pragma mark - 设置默认时间

- (void)setCurrentDefaultDate {
    if ( self.calendarModel.all_date == nil || self.calendarModel.all_date.length == 0) {
        NSString *currentDateString = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
        JGJCalendarModel *calendarModel = [[JGJCalendarModel alloc] init];
        calendarModel.all_date = currentDateString;
        self.calendarModel = calendarModel;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
           JGJCalendarFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"JGJCalendarFirstCell" forIndexPath:indexPath];
            firstCell.calendarModel = self.calendarModel;
            cell = firstCell;
        }
            break;
        case 1: {
            JGJCalendarSecCell *secCell = [tableView dequeueReusableCellWithIdentifier:@"JGJCalendarSecCell" forIndexPath:indexPath];
            secCell.calendarModel = self.calendarModel;
            cell = secCell;
        }
            break;
        case 2: {
            JGJCalendarThirdCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"JGJCalendarThirdCell" forIndexPath:indexPath];
            thirdCell.calendarModel = self.calendarModel;
            cell = thirdCell;
        }
            break;
//        case 3: {
//            JGJCalendarFourthCell *fourthCell = [tableView dequeueReusableCellWithIdentifier:@"JGJCalendarFourthCell" forIndexPath:indexPath];
//            fourthCell.todayRecoms = self.todayRecms;
//            __weak typeof(self) weakSelf = self;
//            fourthCell.todayRecomBlcok = ^(JGJTodayRecomModel *todayRecomModel){
//            
//                [weakSelf showTodayRecommon:todayRecomModel];
//            };
//            cell = fourthCell;
//        }
//            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case 0:
            height = 250.0;
            break;
        case 1: {
           height = [tableView fd_heightForCellWithIdentifier:@"JGJCalendarSecCell" configuration:^(JGJCalendarSecCell *secCell) {
               secCell.calendarModel = self.calendarModel;
            }];
        }
            break;
        case 2:
            height = 134.0;
            break;
//        case 3:
//            height = 175.0;
//            break;
        default:
            break;
    }
    
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)navigationItemItem {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//设置颜色
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 20)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    rightButton.backgroundColor = AppFontd7252cColor;
    [rightButton.layer setLayerCornerRadius:3];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIColor *rightButtonBackcolor = [UIColor colorWithRed:222.0 green:11.0 blue:52.0 alpha:0.5];
    [rightButton setBackgroundColor:rightButtonBackcolor forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(selectedAppropriateDay:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"选吉日" forState:UIControlStateNormal];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = titleItem;
    rightButton.hidden = [self showRightButton];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, JGJLeftButtonHeight)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    [leftButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    UIBarButtonItem *leftTitleItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftTitleItem;
}

- (BOOL)showRightButton {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJSelectedSuitableDayViewController class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)popCurrentViewController {
    
    if (self.calendarVcBlock) {
        
        self.calendarVcBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buttonAction

#pragma mark - 选择吉日
- (void) selectedAppropriateDay:(UIButton *)sender {
    JGJSelectedSuitableDayViewController *suitableDayVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSelectedSuitableDayViewController"];
    [self.navigationController pushViewController:suitableDayVC animated:YES];
}
#pragma mark - 选择时间
- (IBAction)selectedDateButtonPressed:(UIButton *)sender {
    [self showCalendar];
}

#pragma mark - 时间减少
- (IBAction)leftButtonPressedCutDown:(UIButton *)sender {
    NSInteger day = [self.calendarModel.day integerValue];
    NSInteger year = [self.calendarModel.year integerValue];
    day--;
    self.calendarModel.day = [NSString stringWithFormat:@"%@",@(day)];
    if (day == 0) {
        NSUInteger month = [self.calendarModel.month integerValue];
        month --;
        if (month == 0) {
            year --;
            if (year == YearStart) {
                [TYShowMessage showPlaint:@"当前时间为最低年限"]; //最高年限赋值最后一天
                self.calendarModel.year = [NSString stringWithFormat:@"%@", @(YearStart + 1)];
                self.calendarModel.month = [NSString stringWithFormat:@"%@", @(1)];
                self.calendarModel.day = [NSString stringWithFormat:@"%@", @(1)];
                return;
            }
            month = 12;
        }
        self.totalDays = [self.calendar daysInMonth:[NSString stringWithFormat:@"%@", @(month)] year:[self.calendarModel.year integerValue]];
        self.calendarModel.year = [NSString stringWithFormat:@"%@", @(year)];
        self.calendarModel.month = [NSString stringWithFormat:@"%@", @(month)];
        self.calendarModel.day = [NSString stringWithFormat:@"%@", @(self.totalDays.count)];
    } else {
        self.calendarModel.day = [NSString stringWithFormat:@"%@", @(day)];
    }
    [self gregorianDateCoverConvertChineseDate:self.calendarModel.year month:self.calendarModel.month day:self.calendarModel.day weekDay:self.calendarModel.weekday];
}

- (IBAction)callBackTodayButtonPressed:(UIButton *)sender {
    NSString *currentDate = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    [self getCalendarDatabaseWithDate:currentDate];
}

#pragma mark - 时间增加
- (IBAction)rightButtonPressedDateUp:(UIButton *)sender {
    NSInteger day = [self.calendarModel.day integerValue];
    NSInteger year = [self.calendarModel.year integerValue];
    day ++;
    self.calendarModel.day = [NSString stringWithFormat:@"%@",@(day)];
    if (day == self.totalDays.count + 1) {
        NSUInteger month = [self.calendarModel.month integerValue];
        month ++;
        if (month == 13) {
            year ++;
            month = 1;
            if (year == YearEnd + 1) {
                [TYShowMessage showPlaint:@"当前时间为最高年限"]; //最高年限赋值最后一天
                self.calendarModel.year = [NSString stringWithFormat:@"%@", @(YearEnd)];
                self.calendarModel.month = [NSString stringWithFormat:@"%@", @(12)];
                self.calendarModel.day = [NSString stringWithFormat:@"%@", @(31)];
                return;
            }
        }
        self.totalDays = [self.calendar daysInMonth:[NSString stringWithFormat:@"%@", @(month)] year:[self.calendarModel.year integerValue]];
        self.calendarModel.year = [NSString stringWithFormat:@"%@", @(year)];
        self.calendarModel.month = [NSString stringWithFormat:@"%@", @(month)];
        self.calendarModel.day = [NSString stringWithFormat:@"%@", @(1)];
    } else {
        self.calendarModel.day = [NSString stringWithFormat:@"%@", @(day)];
    }
    [self gregorianDateCoverConvertChineseDate:self.calendarModel.year month:self.calendarModel.month day:self.calendarModel.day weekDay:self.calendarModel.weekday];
}

-(void)showCalendar{
    //日期实现
    IDJCalendar *calendar = [[IDJCalendar alloc] init];
    calendar.year = self.calendarModel.year;
    calendar.month = self.calendarModel.month;
    calendar.day = self.calendarModel.day;
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithCalendarTitle:@"选择时间" IDJCalendar:calendar];
    self.calendarPickerView = pickerView;
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HomeVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - private
#pragma mark - 阳历转农历
- (void)gregorianDateCoverConvertChineseDate:(NSString *)year month:(NSString *)month day:(NSString *)day weekDay:(NSString *)weekDay {
    //            阳历
    NSDate *currentDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-%@",year, month, day] withDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [NSDate stringFromDate:currentDate format:@"yyyy-MM-dd"];
    //            阳历转农历
    NSDateComponents *component = [IDJCalendarUtil toChineseDateWithYear:[year integerValue] month:month day:[day integerValue]];
    NSString *lunarYear = [NSString stringWithFormat:@"%@", @(component.year)];
    NSString *lunarMonth = [IDJCalendarUtil monthFromCppToMineWithYear:component.year month:component.month];
    NSString *lunarDay = [NSString stringWithFormat:@"%@", @(component.day)];
    self.calendarModel.zh_calendarDate = [JGJCalendarTool chineseDateYear:lunarYear month:lunarMonth day:lunarDay isConvert:YES];
    [self getCalendarDatabaseWithDate:dateString];
}

#pragma mark - 根据时间查询数据
- (void)getCalendarDatabaseWithDate:(NSString *)date {

    NSString *sqliteAlldate = [NSString stringWithFormat:@"select zh_year,zh_month,zh_day, yi ,ji,xishen,fushen,caishen,jishi,jieqi,weekday,all_date from  jgj_huangli where all_date='%@'", date];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *calendars = [TYFMDB searchCalendarTable:@"jgj_huangli" sqlite:sqliteAlldate];
        if (calendars.count > 0) {
            self.calendarModel = [JGJCalendarModel mj_objectWithKeyValues:calendars[0]];
        }
        NSDate *currentDate = [NSDate dateFromString:date withDateFormat:@"yyyy-MM-dd"];
        NSDateComponents *component = [currentDate components];
        self.calendarModel.year = [NSString stringWithFormat:@"%@", @(component.year)];
        self.calendarModel.month = [NSString stringWithFormat:@"%@", @(component.month)];
        self.calendarModel.day = [NSString stringWithFormat:@"%@", @(component.day)];
        self.calendarModel.weekday = [NSString stringWithFormat:@"%@", self.weekDays[component.weekday - 1]];
        NSString *monthString = [NSString stringWithFormat:@"%@", @(component.month)];
//        用于时间的增减
        NSArray *days = [self.calendar daysInMonth:monthString year:component.year];
        self.totalDays = days;
        
//            阳历转农历有闰月的情况
        NSDateComponents *lunarcomponent = [IDJCalendarUtil toChineseDateWithYear:component.year month:self.calendarModel.month day:component.day];
        NSString *lunarYear = [NSString stringWithFormat:@"%@", @(lunarcomponent.year)];
        NSString *lunarMonth = [IDJCalendarUtil monthFromCppToMineWithYear:lunarcomponent.year month:lunarcomponent.month];
        NSString *lunarDay = [NSString stringWithFormat:@"%@", @(lunarcomponent.day)];
        self.calendarModel.zh_calendarDate = [JGJCalendarTool chineseDateYear:lunarYear month:lunarMonth day:lunarDay isConvert:YES];
        [self.tableView reloadData];
    });
}

#pragma mark -GYZCustomCalendarPickerViewDelegate
//通知使用这个控件的类，用户选取的日期
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    switch (self.calendarPickerView.calendarType) {
        case GregorianCalendar: {
            
//            阳历
            self.calendarModel.year = cal.year;
            self.calendarModel.month = cal.month;
            self.calendarModel.day = cal.day;
            if (cal.weekday.integerValue == 7) {
                cal.weekday = @"6";
            }
            self.calendarModel.weekday = [NSString stringWithFormat:@"%@", cal.weekdays[cal.weekday.integerValue]];
        }
            break;
        case ChineseCalendar: {
//            农历转阳历
            NSDateComponents *component = [IDJCalendarUtil toSolarDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
            self.calendarModel.year = [NSString stringWithFormat:@"%@", @(component.year)];
            self.calendarModel.month = [NSString stringWithFormat:@"%@", @(component.month)];
            self.calendarModel.day = [NSString stringWithFormat:@"%@", @(component.day)];
        }
            break;
        default:
            break;
    }
    //            转换格式查询数据
    NSDate *currentDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-%@",self.calendarModel.year, self.calendarModel.month, self.calendarModel.day] withDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [NSDate stringFromDate:currentDate format:@"yyyy-MM-dd"];
    [self getCalendarDatabaseWithDate:dateString];
    TYLog(@"   %@ --- %@---- %@", cal.des_year, cal.des_month, cal.des_day);
}

#pragma mark - 显示今日推荐

- (void)showTodayRecommon:(JGJTodayRecomModel *)recommonModel {
//    JGJWebAllSubViewController *webVC = nil;
//    if ([recommonModel.address containsString:MakeFriendWantToSayURL]) {
//        webVC = [[JGJWebAllSubViewController alloc]initWithWebType:JGJWebTypeMakeFriend];
//    } else {
//        webVC = [[JGJWebAllSubViewController alloc]initWithUrl:[NSURL URLWithString:recommonModel.address]];
//    }
//    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - LazyMethod

- (JGJCalendarModel *)calendarModel {

    if (!_calendarModel) {
        
        _calendarModel = [[JGJCalendarModel alloc] init];
    }
    return _calendarModel;
}

- (IDJCalendar *)calendar {

    if (!_calendar) {
//        传入当前时间模型
        IDJCalendar *calendar = [[IDJCalendar alloc] init];
        calendar.year = self.calendarModel.year;
        calendar.month = self.calendarModel.month;
        calendar.day = self.calendarModel.day;
        _calendar = [[IDJCalendar alloc] initWithYearStart:YearStart end:YearEnd IDJCalendar:calendar];
    }
    return _calendar;
}

- (NSArray *)weekDays {

    if (!_weekDays) {
        _weekDays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    }
    return _weekDays;
}

#pragma mark -获取随机产生今日推荐信息
- (NSArray *)todayRecms {

    if (!_todayRecms) {
        _todayRecms = [JGJCalendarTool randomGenerationAddress];//随机产生今日推荐信息
    }
    return _todayRecms;
}
@end
