//
//  YZGMateRecordWorkpointsViewController.m
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateRecordWorkpointsViewController.h"

#import "TYBaseTool.h"
#import "NSDate+Extend.h"
#import "MyCalendarObject.h"
#import "YZGDatePickerView.h"
#import "JGJAddNameHUBView.h"
#import "RecordWorkHomeNoteView.h"
#import "RecordWorkHomeMoneyView.h"
#import "UINavigationBar+Awesome.h"
#import "YZGMateReleaseBillViewController.h"
#import "JGJSelectView.h"
#import "JGJTime.h"
static NSString *const calendarFormat = @"yyyy/MM/dd";

@interface YZGMateRecordWorkpointsViewController ()
<
    FSCalendarDelegate,
    FSCalendarDataSource,
    FSCalendarHeaderDelegate,
    JGJAddNameHUBViewDelegate,
    YZGDatePickerViewDelegate,
    FSCalendarDelegateAppearance,
    RecordWorkHomeNoteViewDelegate,
    ClickcalenderButtondelegate
>
{
    BOOL _isRecordedBill;//记录今天是否有流水，如果有流水，则"记工流水"需要显示红点
    RecordWorkHomeNoteModel *_recordWorkNoteModel;//马上记一笔使用的Model
}

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
@property (weak, nonatomic) IBOutlet RecordWorkHomeNoteView *recordNoteMoney;//马上记一笔的View
@property (weak, nonatomic) IBOutlet RecordWorkHomeMoneyView *recordWorkHomeMoneyView;//显示收入的view
@property (weak, nonatomic) IBOutlet YZGMateBillRecordWorkpointsView *billRecordWorkpointsView;
@property(nonatomic ,strong)JGJSelectView *titleView;
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *datesWithSubImage;

@property (strong, nonatomic) NSMutableArray *recordArray;

@end

@implementation YZGMateRecordWorkpointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setInitData];
    
    self.recordNoteMoney.delegate = self;
    
    //初始化记工流水的View
    [self setUpRecordWorkView];
    
    //设置日历
    [self setUpCalendar];
    
    self.postApiString = @"jlworkday/main";
    [self GetworkerMonth];
}
//获取本月记账
-(void)GetworkerMonth
{

    NSDictionary *body = @{
                           @"uid" : [TYUserDefaults objectForKey:JLGUserUid],
                           @"date": @"201701"
                           };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/workerMonthTotal" parameters:body success:^(id responseObject) {
        
//        jgjrecordMonthModel *model  = [jgjrecordMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        _recordArray = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
         }failure:^(NSError *error) {
             [TYLoadingHub hideLoadingView];
             
    }];



}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self JLGHttpRequest];
    //默认都是显示今天被选中
    [self.calendar selectDate:[NSDate date]];
    [self setNavBarImage:[UIImage imageNamed:@"barButtonItem_transparent"]];//去掉那条线

    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, JGJMainColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getWhiteLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *whiteLeftBarButton = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = whiteLeftBarButton;
        }

//        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainColor tintColor:JGJMainColor titleColor:[UIColor whiteColor]];
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainWhiteColor tintColor:JGJMainWhiteColor titleColor:[UIColor blackColor]];

    }
    
//添加
//       self.navigationItem.titleView = self.titleView;

}
-(JGJSelectView *)titleView
{
    if (!_titleView) {
        _titleView = [[JGJSelectView alloc]initWithFrame:CGRectMake(0, 0, 180, 40)];
        _titleView.calenderDelegate = self;

          }
    return _titleView;
}
-(void)ClickLeftButtonTocalender
{

}
-(void)ClickRightButtonTocalender
{



}
//记账以后返回颜色不正确，需要重新设置    
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜色
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, AppFontfafafaColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *leftBarButtonItem = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:AppFontfafafaColor tintColor:JGJMainRedColor titleColor:AppFont333333Color];
    }
//    [self setNavBarImage:[UIImage imageNamed:@"barButtonItem_lineBackImage"]];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"barButtonItem_lineBackImage"]];
    
    //恢复那条线
//        [self.navigationController.navigationBar setShadowImage:image];
}

- (void)setNavBarImage:(UIImage *)image{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.yzgDatePickerView = nil;
}

- (void)setInitData{
    if (!_recordWorkNoteModel) {
        _recordWorkNoteModel = [[RecordWorkHomeNoteModel alloc] init];
    }
    
    if (!self.datesWithEvent) {
        self.datesWithEvent = [NSMutableArray array];
    }
    
    if (!self.datesWithSubImage) {
        self.datesWithSubImage = [NSMutableArray array];
    }
}

#pragma mark - 获取收入数据
- (void)JLGHttpRequest{
//    [TYLoadingHub showLoadingWithMessage:@""];
    [self.datesWithEvent removeAllObjects];
    [self.datesWithSubImage removeAllObjects];
    
    //用于日历显示时间和subImage的日期格式
    NSString *calendarDateFormat = [_calendar stringFromDate:_calendar.currentPage format:calendarFormat];
    __block NSString *subcCalendarDateFormat = [calendarDateFormat substringWithRange:NSMakeRange(0, calendarDateFormat.length - 2)];
    
    __block typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithApi:self.postApiString parameters:@{@"date":[_calendar stringFromDate:self.calendar.currentPage format:@"yyMM"]} success:^(id responseObject) {
        YZGWorkDayModel *yzgWorkDayModel = [[YZGWorkDayModel alloc] init];

        [yzgWorkDayModel setValuesForKeysWithDictionary:responseObject];
        self.yzgWorkDayModel = yzgWorkDayModel;
        
        //转换收入
        NSString *monthMoney = [NSString stringWithFormat:@"%.2f",yzgWorkDayModel.m_total];
        NSString *yearMoney = [NSString stringWithFormat:@"%.2f",yzgWorkDayModel.y_total];
        [self.recordWorkHomeMoneyView setMoneyWithMonth:monthMoney WithYear:yearMoney];

        //判断今天是否有流水
        _isRecordedBill = yzgWorkDayModel.recorded;
        _recordWorkNoteModel.btn_dest = yzgWorkDayModel.btn_dest;
        
        //转换events
        [yzgWorkDayModel.normal enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger integerObj = [obj integerValue];
            NSString *datesWithString = [subcCalendarDateFormat stringByAppendingString:[NSString stringWithFormat:@"%.2ld",(long)integerObj]];
            if (![datesWithString isEqualToString:[NSDate stringFromDate:[NSDate date] format:calendarFormat]]) {//今天不需要显示记账信息
                [weakSelf.datesWithEvent addObject:datesWithString];
            }
        }];
        
        //转换差账的数据
        [yzgWorkDayModel.abnormal enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger integerObj = [obj integerValue];
            NSString *datesWithString = [subcCalendarDateFormat stringByAppendingString:[NSString stringWithFormat:@"%.2ld",(long)integerObj]];
            
            if (![datesWithString isEqualToString:[NSDate stringFromDate:[NSDate date] format:calendarFormat]]) {//今天不需要显示差账信息
                [weakSelf.datesWithSubImage addObject:datesWithString];
            }
        }];
        

        [self RecordNoteMoneyReloadData];
        [self RecordWorkViewReloadData];
        [self.calendar reloadData];
//        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
//        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 设置记工流水的view
- (void)setUpRecordWorkView{
    YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
    YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
    
    firstRecordWorkModel.titleString = @"记工流水";
    firstRecordWorkModel.detailString = @"工钱/借支明细";
    firstRecordWorkModel.backgroundColor = TYColorHex(0xf75a23);
    firstRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
    
    secondRecordWorkModel.titleString = @"工资清单";
    secondRecordWorkModel.detailString = @"收入明细";
    secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
    secondRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
    
    self.billRecordWorkpointsView.firstRecordWorkModel = firstRecordWorkModel;
    self.billRecordWorkpointsView.secondRecordWorkModel = secondRecordWorkModel;
    self.billRecordWorkpointsView.delegate = self;
}

#pragma mark - 设置日历
- (void)setUpCalendar{
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _holidayLunarCalendar = [NSCalendar currentCalendar];
    _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    
    [self setCalendarTheme];
}
#pragma mark - 刷新记一笔
- (void)RecordNoteMoneyReloadData{
    self.recordNoteMoney.recordWorkModel = _recordWorkNoteModel;
}
#pragma mark - 刷新红点
- (void)RecordWorkViewReloadData{
    YZGRecordWorkModel *firstRecordWorkModel = self.billRecordWorkpointsView.firstRecordWorkModel;

    firstRecordWorkModel.redPointType = _isRecordedBill?YZGRecordWorkRedPointRedPoint:YZGRecordWorkRedPointDefault;
    self.billRecordWorkpointsView.firstRecordWorkModel = firstRecordWorkModel;
}

#pragma mark - YZGMateBillRecordWorkDelegate 点击记工流水的view
- (void )YZGMateBillRecordWorkBtnClick:(YZGMateBillRecordWorkpointsView *)yzgMateBillRecordView index:(NSInteger )index{
    if (![self CheckIsLogin]) {
        return ;
    }
    
    [self RecordWorkViewBtnClick:yzgMateBillRecordView.tag index:index];
}

- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index{
    if (section == 1) {
        if (index == 0)//记工流水
        {
            YZGGetIndexRecordViewController *getIndexRecordVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"getIndexRecord"];
            getIndexRecordVc.date = self.calendar.currentPage;
            [self.navigationController pushViewController:getIndexRecordVc animated:YES];
        }else if (index == 1)//工资清单
        {
            UIViewController *wageDetailVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints_WageList" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageListVc"];
            [self.navigationController pushViewController:wageDetailVc animated:YES];
        }
    }
}

#pragma mark - 点击了马上记一笔
- (void)RecordWorkHomeNoteViewRecordNoteBtnClick{
    if (![self CheckIsLogin]) {
        return ;
    }
    
    //没有名字
    UIView *jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    
    if (jgjAddNameHUBView) {
        return;
    }
    
    {//没有记账
        YZGMateReleaseBillViewController *mateReleaseBillVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"mateReleaseBillVc"];

        mateReleaseBillVc.selectedDate = [NSDate date];
        
        [self.navigationController pushViewController:mateReleaseBillVc animated:YES];
    }
}

#pragma mark - FSCalendarDataSource
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = [UIColor whiteColor];
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = TYColorHex(0xafafaf);
    }else{
        color = TYColorHex(0x2e2e2e);
    }

    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = [UIColor whiteColor];
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = TYColorHex(0xc7c7c7);
    }else{
        color = TYColorHex(0x7b7b7b);
    }
    
    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = [UIColor whiteColor];
    }else{
        color = [UIColor blackColor];
    }
    
    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = [UIColor whiteColor];
    }else{
        color = [UIColor blackColor];
    }
    
    return color;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
//    NSDateComponents *holidayComponents = [_holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
//    //判断是否是节日
//    NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
//
//    if (![holiday isEqualToString:@""]) {
//        return holiday;
//    }else{
//       NSDateComponents *lunarComponents = [_lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
//       NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
//        if (![holidayDic[@"holiday"] isEqualToString:@""]) {
//            return holidayDic[@"holiday"];
//        }else if([holidayDic[@"day"] isEqualToString:@"初一"]){//如果是初一就显示多少月
//            return holidayDic[@"month"];
//        }else{
//            return holidayDic[@"day"];
//        }
//    }
//    NSInteger index = [[[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(8, 2)] intValue];
    
    
    
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordArray.count; i++) {
        if ([_recordArray[i][@"date"] intValue] ==  index) {
            return [NSString stringWithFormat:@"%@-%@h",_recordArray[i][@"manhour"],_recordArray[i][@"overtime"]];
 
        }
    }
    return @"0";
    
    
}
//- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
//    
//    NSInteger index = [[[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(8, 2)] intValue];
//    
//    if (index == 1||index == 5||index == 8||index == 18) {
//        return YES;
//    }
//    return NO;
//}
- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
    return [_datesWithSubImage containsObject:[calendar stringFromDate:date format:calendarFormat]];
}
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return [_datesWithEvent containsObject:[calendar stringFromDate:date format:calendarFormat]];
}



- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [calendar dateWithYear:2014 month:1 day:1];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate getLastDayOfThisMonth];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{
    TYLog(@"Did deselect date %@",[calendar stringFromDate:date]);
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    TYLog(@"选中的时间 date %@",[calendar stringFromDate:date format:calendarFormat]);
    [self pushToWorkitemsVc:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    TYLog(@"切换到了 %@",[calendar stringFromDate:calendar.currentPage format:@"yyMM"]);
    [self JLGHttpRequest];
}
- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    [self.view layoutIfNeeded];
}

#pragma mark - 选择几月
- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader{
    [self.yzgDatePickerView showDatePicker];
}

#pragma mark - 选择完时间以后
- (void)YZGDataPickerSelect:(NSDate *)date{
    [self.calendar disChangeMonthDyDate:date];
}

- (void)pushToWorkitemsVc:(NSDate *)date{
    if (![self CheckIsLogin]) {
        return ;
    }
    
    YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
    
    yzgMateWorkitemsVc.searchDate = date;

    [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
}

- (void)setCalendarTheme
{
    _calendar.appearance.headerDateFormat = @"YYYY年MM月";
    _calendar.appearance.cellShape = FSCalendarCellShapeCircle;
    
    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
    _calendar.appearance.todayColor = JGJMainColor;
    _calendar.appearance.todaySelectionColor = JGJMainColor;
    _calendar.appearance.selectionColor = [UIColor whiteColor];
    
    _calendar.header.delegate = self;
    _calendar.header.needSelectedTime = YES;
}

- (BOOL )CheckIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    if (![self.navigationController performSelector:checkIsLogin]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 懒加载
- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}

@end


