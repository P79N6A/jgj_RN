//
//  JGJRecordsViewController.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordsViewController.h"
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
#import "JGJAddNameHUBView.h"
#import "JGJNavView.h"
#import "JGJQRecordViewController.h"
#import "JGJMarkBillViewController.h"
#define leftArrow 110
#define rightArrow 100
static NSString *const calendarFormat = @"yyyy/MM/dd";
@interface JGJRecordsViewController ()
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
@property (nonatomic ,strong)JGJSelectView *titleView;
@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@property (strong, nonatomic) NSMutableArray *datesWithSubImage;
@property (strong, nonatomic) JGJNavView *NavView;
@property (strong, nonatomic) IBOutlet RecordWorkHomeNoteView *recordNoteMoney;//马上记一笔
//@property (strong, nonatomic) IBOutlet RecordWorkHomeMoneyView *recordWorkHomeMoneyView;//记账收入
@property (strong, nonatomic) IBOutlet YZGMateBillRecordWorkpointsView *billRecordWorkpointsView;//记工流水
@property (strong, nonatomic) NSMutableArray *recordArray;
@property (strong, nonatomic) IBOutlet UIButton *BackButton;
@property (strong, nonatomic) UIButton *backUpButton;
@property (strong, nonatomic) NSMutableArray *ModelArray;
@property (strong, nonatomic) UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendaeHeight;
@property (strong, nonatomic) IBOutlet UIView *placeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeviewdistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recordBillConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recordMoneyDistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recordMoneyBottom;
@property (strong, nonatomic) JGJRecordMonthBillModel *recordMonthBillModel;

@property (strong, nonatomic) IBOutlet UIView *detailview;
@property (strong, nonatomic)  JGJAddNameHUBView *jgjAddNameHUBView;

@end

@implementation JGJRecordsViewController
-(void)initViewAndCalendar
{
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    [self.view addSubview:_scrollview];
    
    CGRect calendarRect = _calendar.frame;
    _calendar = [[FSCalendar alloc]init];
    [_calendar setFrame:calendarRect];
    [_scrollview addSubview:_calendar];
    CGRect baseRect = _baseView.frame;
    _baseView = [UIView new];
    baseRect.origin.y = CGRectGetMaxY(_calendar.frame);
    
    [_baseView setFrame:baseRect];
    [_scrollview addSubview:_baseView];
}
- (void)viewDidLoad {
    if (!JLGisLoginBool) {
        [self.recordWorkHomeMoneyView setMoneyWithMonth:@"0.00" WithYear:@"0.00"];
    }

    [super viewDidLoad];
    if ([NSDate calculateCalendarRows:_calendar.currentPage] == 6) {
        _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,-10);
        _placeviewdistance.constant = -45 *TYGetUIScreenHeight/1334;

    }else{
        _placeviewdistance.constant = -110 *TYGetUIScreenHeight/1334;
    }
    [self setInitData];
    
    self.recordNoteMoney.delegate = self;
    [self.calendar selectDate:[NSDate date]];

    //初始化记工流水的View
    [self setUpRecordWorkView];
    //设置日历
    [self setUpCalendar];

//    self.postApiString = @"jlworkday/main";
    self.postApiString = @"jlworkday/workerMonthTotal";

//    [self GetworkerMonth];
    self.navigationItem.titleView = self.NavView;
    [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];

    [self initMateSubView];
    
    
   }
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    

}
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Back:(id)sender {
    //因为图层遮罩  拖得图无法响应 或者应该拖到日历空间上
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)ClickDownButton{
 
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    [self.yzgDatePickerView showDatePicker];
}

//获取本月记账
-(void)GetworkerMonth
{
    
    NSString *date;
    if ([NSString isEmpty:[TYUserDefaults objectForKey:JLGUserUid]]) {
//        [TYShowMessage showError:@"获取数据出错"];
        return;
    }
    if (!_calendar.currentPage) {
        date = [_calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
    }else{
        date = [_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"];
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    NSDictionary *body = @{
                           @"uid" : [NSString stringWithFormat:@"%@",[TYUserDefaults objectForKey:JLGUserUid]]?:@"",
                           @"date": date?:@""
                           };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/workerMonthTotal" parameters:body success:^(id responseObject) {
        _ModelArray = [[NSMutableArray alloc]init];
        _ModelArray =[jgjrecordMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
       // _recordArray = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
        [self.calendar reloadData];
        [TYLoadingHub hideLoadingView];
        }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.calendar.mainVC = YES;
    self.calendar.header.bigfont = YES;
//    [self GetworkerMonth];
    [self JLGHttpRequest];
    //默认都是显示今天被选中
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
    
    self.navigationController.navigationBarHidden  = YES;
    //添加
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
 
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
}
-(void)ClickRightButtonTocalender
{
  
    [self loginAler];

    if (!JLGIsRealNameBool) {
        return;
    }
    
}
//记账以后返回颜色不正确，需要重新设置
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜色
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
    self.navigationController.navigationBarHidden  = NO;
//   [self.navigationController.navigationBar setShadowImage:image];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.calendar.mainVC = NO;
    self.calendar.header.bigfont = NO;

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
    
 
    
    [self.datesWithEvent removeAllObjects];
    [self.datesWithSubImage removeAllObjects];

    //用于日历显示时间和subImage的日期格式

    __block typeof(self) weakSelf = self;
    if ([NSString isEmpty:self.postApiString]) {
//        if (JLGisLeaderBool) {
//            self.postApiString = @"jlworkday/workerMonthTotal";
//        }else{
        self.postApiString = @"jlworkday/workerMonthTotal";
//        }
    }
    
    if (!_calendar.currentPage) {
        _calendar.currentPage = [NSDate date];
    }
    NSString *date;
    if ([NSString isEmpty:[_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"]] ||[_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"] == nil) {
        date = [_calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
    }else{
        date = [_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"];
    }
//    NSString *calendarDateFormat = [_calendar stringFromDate:_calendar.currentPage format:calendarFormat];
    NSString *calendarDateFormat = date;
    
    __block NSString *subcCalendarDateFormat = [calendarDateFormat substringWithRange:NSMakeRange(0, calendarDateFormat.length - 2)];
    [JLGHttpRequest_AFN PostWithApi:self.postApiString parameters:@{@"date":date} success:^(id responseObject) {
        _recordMonthBillModel = [[JGJRecordMonthBillModel alloc]init];
        _recordMonthBillModel =[JGJRecordMonthBillModel mj_objectWithKeyValues:responseObject];

        YZGWorkDayModel *yzgWorkDayModel = [[YZGWorkDayModel alloc] init];
        
        if ([responseObject isKindOfClass:[NSDictionary class]] ||[responseObject isKindOfClass:[NSMutableDictionary class]]) {
        }else{
            return ;
        }
        [yzgWorkDayModel setValuesForKeysWithDictionary:responseObject];
        self.yzgWorkDayModel = yzgWorkDayModel;

        [self.self.recordWorkHomeMoneyView setMoneyWithMonth:_recordMonthBillModel.m_total.total WithYear:_recordMonthBillModel.y_total.total];

        //button数据
        _recordWorkNoteModel = [[RecordWorkHomeNoteModel alloc]init];
//        WorkDayDtn_desc *btn_des = [[WorkDayDtn_desc alloc]init];
//        btn_des.amount =  [_recordMonthBillModel.btn_desc.amount floatValue];
//        btn_des.accounts_type = [_recordMonthBillModel.btn_desc.accounts_type integerValue];
//        btn_des.name = _recordMonthBillModel.btn_desc.name;
//        btn_des.self_lable = _recordMonthBillModel.btn_desc.self_lable;
        //设置button上的今天已经记过帐了
//        _recordWorkNoteModel.btn_dest = btn_des;
        //判断今天是否有流水
        _isRecordedBill = yzgWorkDayModel.recorded;
 
        [self RecordNoteMoneyReloadData];
//        [self RecordWorkViewReloadData];
        [self.calendar reloadData];
    //  [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
    // [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 设置记工流水的view
- (void)setUpRecordWorkView{
    YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
    YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
    
//    firstRecordWorkModel.titleString = @"记工流水";
//    firstRecordWorkModel.detailString = @"工钱/借支明细";
    firstRecordWorkModel.detailString = @"记工流水";

    firstRecordWorkModel.backgroundColor = TYColorHex(0xf75a23);
    firstRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
    
//    secondRecordWorkModel.titleString = @"工资清单";
//    secondRecordWorkModel.detailString = @"收入明细";
    secondRecordWorkModel.detailString = @"工资清单";

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
//    _calendar.appearance.titleSelectionColor = [UIColor blackColor];
//    _calendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    _calendar.appearance.titleDefaultColor = AppFont333333Color;
    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    _calendar.appearance.selectionColor = AppFontfdf0f0Color;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.appearance.titleTodayColor = AppFontd7252cColor;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    [self.calendar addSubview:self.backUpButton];
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
   
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }

    [self RecordWorkViewBtnClick:yzgMateBillRecordView.tag index:index];
}

- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index{

 
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }

//    if (section == 1) {  //当前因布局改变不需要判断section 2.1.2-yj
//        if (index == 0)//记工流水
//        {
//            YZGGetIndexRecordViewController *getIndexRecordVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"getIndexRecord"];
//            getIndexRecordVc.date = self.calendar.currentPage;
//            [self.navigationController pushViewController:getIndexRecordVc animated:YES];
//        }else if (index == 1)//工资清单
//        {
//            UIViewController *wageDetailVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints_WageList" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageListVc"];
//            [self.navigationController pushViewController:wageDetailVc animated:YES];
//        }
//    }
    if (JLGisLeaderBool) {
        if (index == 1)//记工流水
        {
            YZGGetIndexRecordViewController *getIndexRecordVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"getIndexRecord"];
            getIndexRecordVc.date = self.calendar.currentPage;
            [self.navigationController pushViewController:getIndexRecordVc animated:YES];
        }else if (index == 2)//工资清单
        {
            UIViewController *wageDetailVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints_WageList" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageListVc"];
            [self.navigationController pushViewController:wageDetailVc animated:YES];
        }

    }else{
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
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    JGJMarkBillViewController *markBillVC = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
   markBillVC.selectedDate = [NSDate date];
//    JGJQRecordViewController *record = [[JGJQRecordViewController alloc]init];
    markBillVC.Mainrecord = YES;
    [self.navigationController pushViewController:markBillVC animated:YES];
}

#pragma mark - FSCalendarDataSource
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = AppFontccccccColor;
    }else{
        color = AppFont333333Color;
    }
    
    return color;
}


//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
//    UIColor *color;
//    
//    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
//        color = [UIColor whiteColor];
//    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
//        color = TYColorHex(0xc7c7c7);
//    }else{
//        color = TYColorHex(0x7b7b7b);
//    }
//    
//    return color;
//}
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    UIColor *color;
    
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFont333333Color;
    }else{
        color = AppFont333333Color;
    }
    return color;
}
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date{
//    UIColor *color;
//    
//    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
//        color = [UIColor whiteColor];
//    }else{
//        color = [UIColor blackColor];
//    }
//    
//    return color;
//}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {
        if ([[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] date] intValue] ==  index) {
            return [NSString stringWithFormat:@"%@-%@",[(jgjrecordMonthModel *)_recordMonthBillModel.list[i]manhour],[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] overtime]];
        }
    }

//    for (int i = 0; i<_ModelArray.count; i++) {
//        if ([[(jgjrecordMonthModel *)_ModelArray[i] date] intValue] ==  index) {
//            return [NSString stringWithFormat:@"%@-%@",[(jgjrecordMonthModel *)_ModelArray[i]manhour],[(jgjrecordMonthModel *)_ModelArray[i] overtime]];
//        }
//    }
    return @"";
}
//- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
//    return [_datesWithSubImage containsObject:[calendar stringFromDate:date format:calendarFormat]];
//}

- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
    
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {
        if ([[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] date] intValue] ==  index &&[[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] amounts_diff] intValue] != 0) {
            return YES;
        }
    }
    
    return NO;
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
}
#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
   
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    [self pushToWorkitemsVc:date];
}
-(void)updateViewConstraints
{
    [super updateViewConstraints];

}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    /*
    if ([NSDate calculateCalendarRows:calendar.currentPage] == 6) {
        //六行
        [UIView animateWithDuration:.2 animations:^{
        _placeView.transform = CGAffineTransformMakeTranslation(0,0);
//        [self.view setNeedsUpdateConstraints];
_billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,-10);

            _billRecordWorkpointsView.departfirstlable.hidden = NO;
            _billRecordWorkpointsView.departsecondLable.hidden = NO;

    _billRecordWorkpointsView.departfirstlable.transform = CGAffineTransformMakeTranslation(0,5);
    _billRecordWorkpointsView.departsecondLable.transform = CGAffineTransformMakeTranslation(0,5);

        }];
    }else{
        //五行
        _billRecordWorkpointsView.departfirstlable.hidden = YES;
        _billRecordWorkpointsView.departsecondLable.hidden = YES;

        [UIView animateWithDuration:.2 animations:^{
            _placeView.transform = CGAffineTransformMakeTranslation(0, -60 *TYGetUIScreenHeight/1334);
            _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,0);
        }];
    }*/
    [self rowFiveOrsix];
    [self JLGHttpRequest];
//    [self GetworkerMonth];
 
}


- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    [self.view layoutIfNeeded];
}

#pragma mark - 选择几月
- (void)FSCalendarHeaderSelected:(FSCalendarHeader *)fsCalendarHeader{
 
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    if (![self checkIsLogin]) {
        return;
    }
    self.yzgDatePickerView.defultTime = YES;
    [self.yzgDatePickerView setSelectedDate:_calendar.currentPage?:[NSDate date]];
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
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    
    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
//    _calendar.appearance.todaySelectionColor = JGJMainColor;
//    _calendar.appearance.selectionColor = [UIColor blueColor];
    _calendar.appearance.todayColor = AppFontfafafaColor;
    _calendar.appearance.titleTodayColor =AppFontd7252cColor;
    _calendar.header.delegate = self;
    _calendar.header.bigfont = YES;

    _calendar.header.needSelectedTime = YES;
    _calendar.header.leftAndRightShow = YES;

    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.mainVC = YES;

    _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:17];
    //田家城左右显示剪头
    
}

- (BOOL)CheckIsLogin{
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
-(JGJNavView *)NavView
{
    if (!_NavView) {
        _NavView = [[JGJNavView alloc]initWithFrame:CGRectMake(0, 0, 150, 45)];
    }
    return _NavView;
}
- (UIButton *)backUpButton
{
    if (!_backUpButton) {
        _backUpButton = [[UIButton alloc]initWithFrame:CGRectMake(-10, 5, 80, 40)];
        [self.calendar addSubview:_backUpButton];
        _backUpButton.backgroundColor = [UIColor whiteColor];
        [_backUpButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [_backUpButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backUpButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
        [_backUpButton setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
        [_backUpButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _backUpButton;
}
-(void)reciveNotification:(NSNotification *)obj
{
    if ([obj.object intValue] == leftArrow) {
        NSDate *currentMonth = _calendar.currentPage;
        NSDate *previousMonth = [_calendar dateBySubstractingMonths:1 fromDate:currentMonth];
        [_calendar setCurrentPage:previousMonth animated:YES];
        
    }else{
        NSDate *currentMonth = _calendar.currentPage;
        NSDate *nextMonth = [_calendar dateByAddingMonths:1 toDate:currentMonth];
        [_calendar setCurrentPage:nextMonth animated:YES];
        
        
    }
}
-(void)initMateSubView
{
    
    //CGRect rect = _image.frame;
   // rect.origin.x = 50;
   // [_image setFrame:rect];
    
    _secondlab.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStr = [[NSMutableAttributedString alloc] initWithString:@"1d=1个工"];
    
    [centerattrStr addAttribute:NSForegroundColorAttributeName
                          value:AppFontd7252cColor
                          range:NSMakeRange(0,2)];
    _secondlab.attributedText = centerattrStr;
    
    
    _threelab.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrs = [[NSMutableAttributedString alloc] initWithString:@"1h=正常上班1小时"];
    [centerattrStrs addAttribute:NSForegroundColorAttributeName
                           value:AppFontd7252cColor
                           range:NSMakeRange(0,2)];
    _threelab.attributedText = centerattrStrs;
    
    _fourlab.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrss = [[NSMutableAttributedString alloc] initWithString:@"1h=加班1小时"];
    
    [centerattrStrss addAttribute:NSForegroundColorAttributeName
                            value:AppFont6487e0Color
                            range:NSMakeRange(0,2)];
    _fourlab.attributedText = centerattrStrss;
}
- (void)loginAler{
    if (![self checkIsLogin]) {
        return ;
    }
 
    //没有名字d

  _jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    
    if (_jgjAddNameHUBView) {
        return;
    }
}

-(BOOL)checkIsLogin{
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}
-(void)rowFiveOrsix
{
    if ([NSDate calculateCalendarRows:[NSDate date]] == 5) {
        
        if ([NSDate calculateCalendarRows:_calendar.currentPage] == 6) {
            //六行
            [UIView animateWithDuration:.2 animations:^{
                _placeView.transform = CGAffineTransformMakeTranslation(0,30);
                //        [self.view setNeedsUpdateConstraints];
                _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,-15);
                
                _billRecordWorkpointsView.departfirstlable.hidden = NO;
                _billRecordWorkpointsView.departsecondLable.hidden = NO;
                
                _billRecordWorkpointsView.departfirstlable.transform = CGAffineTransformMakeTranslation(0,3);
                _billRecordWorkpointsView.departsecondLable.transform = CGAffineTransformMakeTranslation(0,3);
                
            }];
        }else{
            //五行
            _billRecordWorkpointsView.departfirstlable.hidden = YES;
            _billRecordWorkpointsView.departsecondLable.hidden = YES;
            [UIView animateWithDuration:.2 animations:^{
                _placeView.transform = CGAffineTransformMakeTranslation(0, 0 *TYGetUIScreenHeight/1334);
                _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,0);
            }];
        }

        
    }else{
    if ([NSDate calculateCalendarRows:_calendar.currentPage] == 6) {
        //六行
        [UIView animateWithDuration:.2 animations:^{
            _placeView.transform = CGAffineTransformMakeTranslation(0,2.5);
            //        [self.view setNeedsUpdateConstraints];
            _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,-10.8);
            
            _billRecordWorkpointsView.departfirstlable.hidden = NO;
            _billRecordWorkpointsView.departsecondLable.hidden = NO;
            
            _billRecordWorkpointsView.departfirstlable.transform = CGAffineTransformMakeTranslation(0,3);
            _billRecordWorkpointsView.departsecondLable.transform = CGAffineTransformMakeTranslation(0,3);
            
        }];
    }else{
        //五行
        _billRecordWorkpointsView.departfirstlable.hidden = YES;
        _billRecordWorkpointsView.departsecondLable.hidden = YES;
        [UIView animateWithDuration:.2 animations:^{
            _placeView.transform = CGAffineTransformMakeTranslation(0, -60 *TYGetUIScreenHeight/1334);
            _billRecordWorkpointsView.transform = CGAffineTransformMakeTranslation(0,0);
        }];
    }
    }
}
@end
