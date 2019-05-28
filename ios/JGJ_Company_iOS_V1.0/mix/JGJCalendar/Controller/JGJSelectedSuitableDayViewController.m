//
//  JGJSelectedSuitableDayViewController.m
//  mix
//
//  Created by yj on 16/6/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSelectedSuitableDayViewController.h"
#import "JGJSelectedSuitDayResultCell.h"
#import "JGJSelectedSuitDayConditionCell.h"
#import "UILabel+GNUtil.h"
#import "GYZCustomCalendarPickerView.h"
#import "JGJCalendarCheckCategoryView.h"
#import "TYFMDB.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "JGJCalendarTool.h"
#import "JGJCalendarViewController.h"
#import "TYShowMessage.h"
#import "JLGDefaultTableViewCell.h"
@interface JGJSelectedSuitableDayViewController () <UITableViewDelegate, UITableViewDataSource, GYZCustomCalendarPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *headerTitle;
@property (copy, nonatomic)   NSString *dateStr;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *titles;
@property (nonatomic, strong) JGJCalendarCheckCategoryView *categoryView;
@property (strong, nonatomic) NSArray *categoryDataSource;
@property (nonatomic, strong) JGJCalendarModel *calendarModel;//搜索结果模型
@property (strong, nonatomic) NSArray *luckDates;//根据条件查询的日子
@property (strong, nonatomic) NSMutableArray *conditions;//存储条件数据 查询类别 开始时间 结束时间
@property (strong, nonatomic) GYZCustomCalendarPickerView *calendarPickerView;
@property (strong, nonatomic) NSArray *weekDays;
@end

@implementation JGJSelectedSuitableDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self showCurrentDateCheckData];//默认显示当前数据查询
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 3;
            break;
        case 1: {
            count = self.luckDates.count > 0 ? self.luckDates.count : 1;
        }
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            JGJSelectedSuitDayConditionCell *conditionCell = [tableView dequeueReusableCellWithIdentifier:@"JGJSelectedSuitDayConditionCell" forIndexPath:indexPath];
            conditionCell.dateStrLable.text = self.titles[indexPath.row];
            JGJCalendarModel *calendarModel = self.conditions[indexPath.row];
            if (indexPath.row == 0) {
                conditionCell.dateDetailLable.text = calendarModel.favAvoidContent;
            } else {
               conditionCell.dateDetailLable.text = calendarModel.calendarDate;
            }
            conditionCell.lineView.hidden = indexPath.row == 2;
            cell = conditionCell;
        }
            break;
        case 1: {
          
            if (self.luckDates.count > 0) {
                JGJSelectedSuitDayResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"JGJSelectedSuitDayResultCell" forIndexPath:indexPath];
                resultCell.calendar = self.luckDates[indexPath.row];
                return  resultCell;
            } else {
                JLGDefaultTableViewCell *defaultCell = [JLGDefaultTableViewCell cellWithTableView:tableView];
                defaultCell.tileLayoutCenterY.constant = -40;
                [defaultCell setDefaultImage:nil defautTitle:@"你选择的时间内暂无合适的日子" defaultDetailTitle:nil];
                return defaultCell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case 0:
            height = 50.0;
            break;
        case 1:
            height = self.luckDates.count == 0 ? TYGetUIScreenHeight - 150.0 :45.0;
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    switch (section) {
        case 0:
            height = 0.01;
            break;
        case 1:
            height = 37.0;
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        JGJCalendarModel *calendarModel = self.conditions[0];;
        JGJCalendarCheckCategoryView *categoryView = [JGJCalendarCheckCategoryView calendarCheckWithCalendarModel:calendarModel];
        __weak typeof(self) weakSelf = self;
        categoryView.blockCalendar = ^(JGJCalendarModel *calendar){
            calendarModel.jixiong = calendar.jixiong; //宜忌内容
            calendarModel.category = calendar.category; //宜 或者 忌
            calendarModel.favAvoidContent = calendar.favAvoidContent;
            calendarModel.favAvoidRow = calendar.favAvoidRow;
            calendarModel.favAvoidDetailRow = calendar.favAvoidDetailRow;
            JGJCalendarModel *calStModel = weakSelf.conditions[1];
            JGJCalendarModel *calEndModel = weakSelf.conditions[2];
            [weakSelf selectedDateWithStartTime:calStModel.startTime endTime:calEndModel.endTime  calendarModel:calendarModel];
        };
    }
    if (indexPath.section == 0 && indexPath.row > 0) {
        self.indexPath = indexPath;
        [self showCalendar];
    }
    
    if (indexPath.section == 1) {
        JGJCalendarViewController *calendarVC = [[UIStoryboard storyboardWithName:@"YZGHomeStorBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCalendarViewController"];
        calendarVC.calendarModel = self.luckDates[indexPath.row];
        [self.navigationController pushViewController:calendarVC animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        JGJCalendarModel *calendarModel = self.conditions[0];
        NSString *favAvoidContent = calendarModel.favAvoidContent;
        UIColor *headerTitleColor = ![calendarModel.category isEqualToString:@"宜"] ?AppFontd7252cColor:TYColorHex(0X288a48);
        self.headerTitle.text = [NSString stringWithFormat:@"%@的日子%@天",favAvoidContent, @(self.luckDates.count)];
        [self.headerTitle markText:favAvoidContent withColor:headerTitleColor];;
    }
    return self.headerView;
}

-(void)showCalendar{    
    //日期实现
    IDJCalendar *calendar = [[IDJCalendar alloc] init];
    JGJCalendarModel *calendarStartTimeModel = self.conditions[1];
    if (self.indexPath.row == 1) { //开始时间
        NSDate *startDate = [NSDate dateFromString:calendarStartTimeModel.startTime withDateFormat:@"yyyy-MM-dd"];
        calendar.year = [NSString stringWithFormat:@"%@", @(startDate.components.year)];
        calendar.month = [NSString stringWithFormat:@"%@", @(startDate.components.month)];
        calendar.day = [NSString stringWithFormat:@"%@", @(startDate.components.day)];
    }
    JGJCalendarModel *calendarEndModel = self.conditions[2];
    if (self.indexPath.row == 2) { //结束时间
        NSDate *endTime = [NSDate dateFromString:calendarEndModel.endTime withDateFormat:@"yyyy-MM-dd"];
        calendar.year = [NSString stringWithFormat:@"%@", @(endTime.components.year)];
        calendar.month = [NSString stringWithFormat:@"%@", @(endTime.components.month)];
        calendar.day = [NSString stringWithFormat:@"%@", @(endTime.components.day)];
    }
    
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithCalendarTitle:@"选择时间" IDJCalendar:calendar];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    self.calendarPickerView = pickerView;
    [pickerView show];
}

#pragma mark - 私有方法
#pragma mark - 根据条件查询
- (void)selectedDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime calendarModel:(JGJCalendarModel *)calendarModel {
    
    if ([NSString isEmpty:startTime] || [NSString isEmpty:endTime] || calendarModel == nil) {
        [self.tableView reloadData];
        return;
    }
    
    NSString *favAvoidString = nil;
    favAvoidString = [calendarModel.category isEqualToString:@"宜"] ? @"yi" : @"ji";
    NSString *sqlite = [NSString stringWithFormat:@"select all_date,zh_month,zh_day,weekday from jgj_huangli where (all_date between '%@' and '%@') and %@ like '%%%@%%'", startTime, endTime, favAvoidString,calendarModel.jixiong];
    self.luckDates = [TYFMDB searchCalendarTable:@"jgj_huangli" sqlite:sqlite];
    self.luckDates = [JGJCalendarModel mj_objectArrayWithKeyValuesArray:self.luckDates];
    [self.tableView reloadData];
}

#pragma Mark - 通知使用这个控件的类，用户选取的日期
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *lunarMonthDay = nil;
    NSString *solarDate = nil;
    NSString *calYear = nil; //阳历年
    NSString *calMonth = nil;//阳历月
    NSString *calDay = nil;//阳历日
    NSInteger weekDay = [cal.weekday integerValue];
    switch (self.calendarPickerView.calendarType) {
        case GregorianCalendar: {
//            再次转换将阳历转换为农历
            NSDateComponents *lunarComponent = [IDJCalendarUtil toChineseDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
            cal.des_month = [IDJCalendarUtil monthFromCppToMineWithYear:lunarComponent.year month:lunarComponent.month];
            cal.des_day = [NSString stringWithFormat:@"%@", @(lunarComponent.day)];
            lunarMonthDay = [NSString stringWithFormat:@"%@", [JGJCalendarTool chineseDateYear:cal.year month:cal.des_month day:cal.des_day isConvert:NO]];
            self.dateStr = [NSString stringWithFormat:@"%@-%@-%@", cal.year,cal.month, cal.day];
            self.dateStr = [self stringWithDateString:self.dateStr];
//            复制给查询条件
            solarDate = self.dateStr;
            self.dateStr = [NSString stringWithFormat:@"%@ %@%@", self.dateStr, lunarMonthDay, self.weekDays[weekDay]];
            calYear = cal.year;
            calMonth = cal.month;
            calDay = cal.day;
        }
            break;
        case ChineseCalendar: {
//            将农历转换为阳历
            NSDateComponents *solarComponent = [IDJCalendarUtil toSolarDateWithYear:[cal.year integerValue] month:cal.month day:[cal.day integerValue]];
            cal.des_month = [NSString stringWithFormat:@"%@", @(solarComponent.month)];
            cal.des_day = [NSString stringWithFormat:@"%@", @(solarComponent.day)];
            lunarMonthDay = [NSString stringWithFormat:@"%@", [JGJCalendarTool chineseDateYear:cal.year month:cal.month day:cal.day isConvert:NO]];
            self.dateStr = [NSString stringWithFormat:@"%@-%@-%@", cal.des_year,cal.des_month, cal.des_day];
            self.dateStr = [self stringWithDateString:self.dateStr];
            self.dateStr = [NSString stringWithFormat:@"%@ %@%@", self.dateStr, lunarMonthDay, self.weekDays[weekDay]];
            calYear = cal.des_year;
            calMonth = cal.des_month;
            calDay = cal.des_day;
//            复制给查询条件
            solarDate = [self stringWithDateString:[NSString stringWithFormat:@"%@-%@-%@", cal.des_year, cal.des_month,cal.des_day]];

        }
            break;
        default:
            break;
    }
    
//    判断开始时间和结束时间逻辑结束
    JGJCalendarModel *calendarModel = [self checkCurrentDateTimeIntervalWithCurrentDate:solarDate calyear:calYear calMonth:calMonth calDay:calDay];
    if (calendarModel == nil) {
        return;
    }
    [self selectedDateWithStartTime:calendarModel.startTime endTime:calendarModel.endTime  calendarModel:calendarModel];
}

#pragma mark - 转换成固定格式的日期

- (NSString *)stringWithDateString:(NSString *)dateString {
    NSString *date = [NSDate stringFromDate:[NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"] format:@"yyyy-MM-dd" ];
    return date;
}

#pragma mark - 判断开始时间和结束时间是否相差一个月

- (JGJCalendarModel *)checkCurrentDateTimeIntervalWithCurrentDate:(NSString *)solarDate calyear:(NSString *)calYear calMonth:(NSString *)calMonth calDay:(NSString *)calDay {
    NSString *lunarMonthDay = nil;
    JGJCalendarModel *calendarStartTimeModel = self.conditions[1];
    JGJCalendarModel *calendarEndModel = self.conditions[2];
    if (self.indexPath.row == 1) { //开始时间
        calendarStartTimeModel.startTime = solarDate;
        calendarStartTimeModel.calendarDate = self.dateStr;
        calendarStartTimeModel.year = calYear;
        calendarStartTimeModel.month = calMonth;
        calendarStartTimeModel.day = calDay;
    }
    if (self.indexPath.row == 2) { //结束时间
        calendarEndModel.endTime = solarDate;
        calendarEndModel.calendarDate = self.dateStr;
        calendarEndModel.year = calYear;
        calendarEndModel.month = calMonth;
        calendarEndModel.day = calDay;
    }
    //    判断开始时间和结束时间逻辑开始
    
    NSDate *startDate = [NSDate dateFromString:calendarStartTimeModel.startTime withDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [NSDate dateFromString:calendarEndModel.endTime withDateFormat:@"yyyy-MM-dd"];
    NSInteger monthInterVal = [NSDate getMonthsFrom:startDate withToDate:endDate];
    
    if (self.indexPath.row == 1 && monthInterVal < 1) { //判断当点击开始时间时,和结束时间是否相差一个月，否则大于一个月
        NSUInteger month = [calMonth integerValue];
        month ++;
        //      阳历转换为农历
        if (month == 13) {
            month = 1;
            calYear = [NSString stringWithFormat:@"%ld", [calYear integerValue] + 1];
            calDay = [NSString stringWithFormat:@"%@", @(28)];
        }
        calMonth = [NSString stringWithFormat:@"%@", @(month)]; //加一个月赋值
        calendarEndModel.endTime = [self stringWithDateString:[NSString stringWithFormat:@"%@-%@-%@", calYear,calMonth, calDay]]; //年份已增加
//        转换为农历
        NSDateComponents *component = [IDJCalendarUtil toChineseDateWithYear:[calYear integerValue] month:calMonth day:[calDay integerValue]];
//        转换农历月判断是否闰月
        NSString *luarYear = [NSString stringWithFormat:@"%ld", component.year];
        NSString *lunarMonth = [IDJCalendarUtil monthFromCppToMineWithYear:component.year  month:component.month];
        NSString *luarDay = [NSString stringWithFormat:@"%ld", component.day];
        lunarMonthDay = [NSString stringWithFormat:@"%@", [JGJCalendarTool chineseDateYear:luarYear month:lunarMonth day:luarDay isConvert:NO]];
        NSUInteger weekDay = [IDJCalendarUtil weekDayWithChineseYear:component.year month:lunarMonth day:component.day];
        
        self.dateStr = [self stringWithDateString:calendarEndModel.endTime];
        self.dateStr = [NSString stringWithFormat:@"%@ %@%@", self.dateStr, lunarMonthDay, self.weekDays[weekDay]];
        calendarEndModel.calendarDate = self.dateStr;
        endDate = [NSDate dateFromString:calendarEndModel.endTime withDateFormat:@"yyyy-MM-dd"]; //再次赋值结束时间
    }
    
    NSInteger dayInterVal = [NSDate getDaysFrom:startDate withToDate:endDate]; //计算时间差
    if (dayInterVal < 0) { //结束时间要大于开始时间
        
        [TYShowMessage showError:@"结束时间不能小于开始时间"];
        return nil;
    }
    JGJCalendarModel *calendarCategoryModel = self.conditions[0]; //设置查询条件
    calendarCategoryModel.startTime = calendarStartTimeModel.startTime;
    calendarCategoryModel.endTime = calendarEndModel.endTime;
    return calendarCategoryModel;
}

#pragma mark - 显示默认当前时间的查询的数据
- (void)showCurrentDateCheckData {

    NSDateComponents *component = [NSDate date].components;
    NSString *calYear = [NSString stringWithFormat:@"%@", @(component.year)];
    NSString *calMonth = [NSString stringWithFormat:@"%@", @(component.month)];
    NSString *calDay = [NSString stringWithFormat:@"%@", @(component.day)];
    NSString *solarDate = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    IDJCalendar *calendar = [[IDJCalendar alloc] init];
    self.calendarPickerView = [[GYZCustomCalendarPickerView alloc] init];
    self.calendarPickerView.calendarType = GregorianCalendar;
    self.indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    calendar.year = calYear;
    calendar.month = calMonth;
    calendar.day = calDay;
    JGJCalendarModel *calendarCalendarModel = self.conditions[0];
    calendarCalendarModel.category = @"宜";
    calendarCalendarModel.jixiong = @"结婚";
    calendarCalendarModel.favAvoidContent = @"宜(结婚)";
    NSDateComponents *luarComponent = [IDJCalendarUtil toChineseDateWithYear:component.year month:calMonth day:component.day];
    NSString *luarMonth = [IDJCalendarUtil monthFromCppToMineWithYear:component.year month:component.month];
    calendar.des_year = [NSString stringWithFormat:@"%@", @(luarComponent.year)];;
    calendar.des_month = luarMonth;
    calendar.des_day = [NSString stringWithFormat:@"%@", @(luarComponent.day)];
    NSUInteger weekDay = [IDJCalendarUtil weekDayWithSolarYear:component.year month:calMonth day:component.day];
    calendar.weekday = [NSString stringWithFormat:@"%@", @(weekDay)];
    JGJCalendarModel *calendarStartTimeModel = self.conditions[1];
    JGJCalendarModel *calendarEndModel = self.conditions[2];
    calendarStartTimeModel.startTime = solarDate;
    calendarEndModel.endTime = solarDate;
    [self notifyNewCalendar:calendar];

}

#pragma Mark - LazyMethod

- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = AppFontf1f1f1Color;
        [_headerView addSubview:self.headerTitle];
    }
    return _headerView;
}

- (UILabel *)headerTitle {
    
    if (!_headerTitle) {
        
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.font = [UIFont systemFontOfSize:AppFont24Size];
        _headerTitle.textColor = AppFont999999Color;
        [self.headerView addSubview:_headerTitle];
        [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(_headerView);
            make.left.equalTo(@10);
        }];
    }
    return _headerTitle;
}

- (NSArray *)categoryDataSource {
    
    if (!_categoryDataSource) {
        NSString *sqliteAlldate = [NSString stringWithFormat:@"select jixiong,jixiong_desc from  jgj_jixiong"];
        _categoryDataSource = [TYFMDB searchCalendarTable:@"jgj_jixiong" sqlite:sqliteAlldate];
        _categoryDataSource = [JGJCalendarModel mj_objectArrayWithKeyValuesArray:_categoryDataSource];
    }
    return _categoryDataSource;
}

- (NSMutableArray *)conditions {
    
    if (!_conditions) {
        _conditions = [NSMutableArray array];
        for ( int i = 0; i < 3; i ++) {
            JGJCalendarModel *calendarModel = [[JGJCalendarModel alloc] init];
            [_conditions addObject:calendarModel];
        }
    }
    return _conditions;
}

- (NSArray *)weekDays {
    
    if (!_weekDays) {
        _weekDays = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    }
    return _weekDays;
}

#pragma mark - commonset
- (void)commonSet {
    self.navigationItem.title = @"选吉日";
    NSMutableDictionary *dictAtt = [NSMutableDictionary dictionary];
    dictAtt[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictAtt[NSFontAttributeName] = [UIFont systemFontOfSize:JGJNavBarFont];
    [self.navigationController.navigationBar setTitleTextAttributes:dictAtt];
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
    self.titles = @[@"查询类别", @"开始时间", @"结束时间"];
}

- (void)popCurrentViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
