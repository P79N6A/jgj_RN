//
//  JGJWorkMatesRecordsViewController.m
//  mix
//
//  Created by Tony on 2017/7/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkMatesRecordsViewController.h"
#import "FSCalendar.h"
#import "NSDate+Extend.h"
#import "YZGMateBillRecordWorkpointsView.h"
#import "YZGDatePickerView.h"
#import "JGJAddNameHUBView.h"
#import "TYBaseTool.h"
#import "YZGGetIndexRecordViewController.h"
#import "JGJQRecordViewController.h"
#import "YZGMateWorkitemsViewController.h"
#import "NSString+Extend.h"
#import "JGJCalenderDateView.h"
#import "JGJRecordTipView.h"
#import "JGJSurePoorbillViewController.h"
#import "JLGCustomViewController.h"
#import "JGJMarkBillViewController.h"
#import "JGJMarkBillBottomBaseView.h"
#import "JGJMarkBillHomePageMaskingView.h"
//未结工资
#import "JGJUnWagesVc.h"

//记工流水
#import "JGJRecordWorkpointsVc.h"

//记工统计
#import "JGJRecordStaListVc.h"
#import "JGJWebAllSubViewController.h"

#import "JGJMemeberMangerVc.h"
#import "JGJNewMarkBillBottomBaseView.h"
#import "JGJMarkBillRecommendAndReconciliationBottomView.h"

#import "JGJCustomShareMenuView.h"


#import "JGJShowWorkDayView.h"
#import "JGJCustomPopView.h"
#import "YZGSelectedRoleViewController.h"
#import "JGJAccountShowTypeVc.h"
#import "JGJNewRecordRemindView.h"
#import "JGJNewWorkHomeNoteBtnView.h"

#import "JYSlideSegmentController.h"
#import "JGJRecordWorkpointsSettingController.h"
#define leftArrow 110
#define rightArrow 100
@interface JGJWorkMatesRecordsViewController ()
<
FSCalendarDelegate,

FSCalendarDataSource,

FSCalendarHeaderDelegate,

JGJAddNameHUBViewDelegate,

YZGDatePickerViewDelegate,

FSCalendarDelegateAppearance,

UIScrollViewDelegate,

JGJCalenderDateViewDelegate,

JGJRecordTipViewDelegate,
JGJMarkBillRecommendAndReconciliationBottomViewDelegate,
JGJNewWorkHomeNoteBtnViewDelegate
>
{
    BOOL _isRecordedBill;//记录今天是否有流水，如果有流水，则"记工流水"需要显示红点
}
@property(nonatomic ,strong)FSCalendar *calendar;

@property (strong, nonatomic)JGJNewWorkHomeNoteBtnView *theNewWorkHomeRecordBtnView;//马上记一笔
@property (strong, nonatomic)  YZGMateBillRecordWorkpointsView *billRecordWorkpointsView;//记工流水

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (strong, nonatomic) JGJRecordMonthBillModel *recordMonthBillModel;

@property (strong, nonatomic)  JGJAddNameHUBView *jgjAddNameHUBView;

@property (strong, nonatomic) UIButton *backUpButton;

@property (strong, nonatomic) NSCalendar *lunarCalendar;

@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;

@property (strong, nonatomic) NSMutableArray *datesWithEvent;

@property (strong, nonatomic) NSMutableArray *datesWithSubImage;

@property (strong, nonatomic) UIView *calenderBaqseView;//日历的背景

@property (strong, nonatomic) UIView *otherBaseView;//下面其他的北京

@property (strong, nonatomic) JGJNewRecordRemindView *theNewRecordRemindView;//提示列表
@property (strong, nonatomic) UIView *departLine;//分割线

@property (strong, nonatomic) UIView *topview;//分割线

@property (strong, nonatomic) UIView *ButtonView;//分割线

@property (strong, nonatomic) JGJCalenderDateView *CalenderDateView;
@property (nonatomic, strong) UIButton *commonProblemBtn;// 常见问题按钮 3.2.0需求新加
@property (strong, nonatomic) JGJRecordTipView *RecordTipView;

@property (strong, nonatomic) UIView *bottomBaseView;

@property (assign, nonatomic) NSInteger defaultHeight;

@property (assign, nonatomic) BOOL secondLoad;//其他页面返回

@property (strong, nonatomic)JGJMarkBillBottomBaseView *markBillBottomBaseView;
@property (strong, nonatomic) JGJNewMarkBillBottomBaseView *markNewBillBottomBaseView;
@property (nonatomic, strong) JGJMarkBillHomePageMaskingView *maskingView;
@property (nonatomic, strong) JGJMarkBillRecommendAndReconciliationBottomView *recommendAndReconciliationBottomView;// 推荐和对账按钮页面
@property (nonatomic, strong) JGJShowWorkDayView *showWorkDayView;
@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@end

@implementation JGJWorkMatesRecordsViewController

- (void)viewDidLoad {
    
    _secondLoad = NO;
    
    _defaultHeight = 60;
    
    [super viewDidLoad];
    
    [self intiView];
    [self.calendar selectDate:[NSDate date]];

}
- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    self.mainscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.mainscrollView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0 );
    self.mainscrollView.contentOffset = CGPointMake(0, -24);


}
- (void)intiView
{
    [self.view addSubview:self.mainscrollView];
    [self.view addSubview:self.CalenderDateView];
    [self.view addSubview:self.showWorkDayView];
    
    [self.mainscrollView addSubview:self.calenderBaqseView];
    [self.mainscrollView addSubview:self.otherBaseView];

    self.maskingView.runningWaterBtnY = CGRectGetMinY(_otherBaseView.frame) + 40 + 100;
    _showWorkDayView.sd_layout.topSpaceToView(self.view, TYGetUIScreenHeight / 2).rightSpaceToView(self.view, 14).widthIs(80).heightIs(95);
    _showWorkDayView.hidden = YES;
    [self initCalender];
    [self setUpRecordWorkView];
    NSInteger rowNum;
    rowNum = [NSDate calculateCalendarRows:[NSDate date]] - 5;
    _mainscrollView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [_mainscrollView setContentSize:CGSizeMake(TYGetUIScreenWidth, CGRectGetMaxY(self.otherBaseView.frame) - 50)];

    BOOL _isHaveOpenMaskinfView = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstOpenBill"];
    if (!_isHaveOpenMaskinfView) {

        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [window addSubview:self.maskingView];

        _maskingView.sd_layout.leftSpaceToView(window, 0).topSpaceToView(window, 0).rightSpaceToView(window, 0).bottomSpaceToView(window, 0);

        __weak typeof(self) weakSelf = self;
        _maskingView.maskingTouch = ^{

            [weakSelf.maskingView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"firstOpenBill"];
        };
    }
    
    __weak typeof(self) weakSelf = self;
    // 晒工天
    _theNewRecordRemindView.showWorkDay = ^{
        
        if (![weakSelf checkIsRealName]) {
            
            if ([weakSelf.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
                
                JLGCustomViewController *customVc = (JLGCustomViewController *) weakSelf.navigationController;
                
                customVc.customVcBlock = ^(id response) {
                    
                };
                
            }
            
        }else {
            
            [weakSelf showWorkDayEvent];
        }
    };
}

- (void)showWorkDayEvent {
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,@"workday"]];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (JGJMarkBillHomePageMaskingView *)maskingView {
    
    if (!_maskingView) {
        
        _maskingView = [[JGJMarkBillHomePageMaskingView alloc] init];
    }
    return _maskingView;
}

-(RecordWorkHomeMoneyView *)recordWorkHomeMoneyView
{
    if (!_recordWorkHomeMoneyView) {
        _recordWorkHomeMoneyView = [[RecordWorkHomeMoneyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ButtonView.frame), TYGetUIScreenWidth, 90)];
        _recordWorkHomeMoneyView.backgroundColor = [UIColor whiteColor];
        
    }
    return _recordWorkHomeMoneyView;
}

- (JGJShowWorkDayView *)showWorkDayView {
    
    if (!_showWorkDayView) {
        
        _showWorkDayView = [[JGJShowWorkDayView alloc] init];
    }
    return _showWorkDayView;
}
- (void)initCalender
{
    [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];

    _calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(_calenderBaqseView.frame))];
    _calendar.appearance.titleDefaultColor = AppFont333333Color;
    _calendar.appearance.titleSelectionColor = AppFont333333Color;
    _calendar.appearance.selectionColor = AppFontfdf0f0Color;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.homeRecordBillCalendar = YES;
    _calendar.appearance.titleTodayColor = AppFontd7252cColor;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    
    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);

    _calendar.appearance.todayColor = AppFontfafafaColor;
    _calendar.appearance.titleTodayColor =AppFontd7252cColor;
    _calendar.header.delegate = self;
    _calendar.header.bigfont = YES;
    
    _calendar.header.hiddenHeaderTitle = YES;
    
    _calendar.header.needSelectedTime = YES;
    _calendar.header.leftAndRightShow = YES;
    _calendar.headerHeight = 70;
    
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.headerNeedOffset = YES;
    _calendar.header.hidden = YES;
    _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:17];
    
    if ([NSDate calculateCalendarRows:_calendar.currentPage] == 5) {
    _otherBaseView.transform = CGAffineTransformMakeTranslation(0, -58.00/375*TYGetUIScreenWidth*([NSDate calculateCalendarRows:_calendar.currentPage] - 5));
    }
    [self.calenderBaqseView addSubview:self.calendar];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
    _calendar.headerNeedOffset = YES;
    _calendar.header.hidden = YES;
    [self.recordWorkHomeMoneyView setMoneyWithMonth:@"0.00" WithYear:@"0.00"];
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    self.markNewBillBottomBaseView.type = self.selTypeModel.type;
    [self JLGHttpRequest];

}

-(UIView *)calenderBaqseView
{
    if (!_calenderBaqseView) {
        
        _calenderBaqseView = [[UIView alloc]initWithFrame:CGRectMake(0, 3, TYGetUIScreenWidth, 70 + 58.00/375*TYGetUIScreenWidth * [NSDate calculateCalendarRows:[NSDate date]] +15.00/375*TYGetUIScreenWidth * ([NSDate calculateCalendarRows:[NSDate date]] - 5)+12.00/375*TYGetUIScreenWidth)];
        _calenderBaqseView.backgroundColor = [UIColor whiteColor];
    }
    return _calenderBaqseView;
}

- (JGJNewMarkBillBottomBaseView *)markNewBillBottomBaseView {
    
    if (!_markNewBillBottomBaseView) {
        
        _markNewBillBottomBaseView = [[JGJNewMarkBillBottomBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ButtonView.frame), TYGetUIScreenWidth, TYGetUIScreenWidth / 3 * 3)];
        _markNewBillBottomBaseView.backgroundColor = AppFontf1f1f1Color;
    }
    return _markNewBillBottomBaseView;
}

- (JGJMarkBillRecommendAndReconciliationBottomView *)recommendAndReconciliationBottomView {
    
    if (!_recommendAndReconciliationBottomView) {
        
        _recommendAndReconciliationBottomView = [[JGJMarkBillRecommendAndReconciliationBottomView alloc] init];
        _recommendAndReconciliationBottomView.recommendAndReconciliationDelegate = self;
    }
    return _recommendAndReconciliationBottomView;
}

-(UIView *)bottomBaseView
{
    if (!_bottomBaseView) {
        _bottomBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.theNewRecordRemindView.frame), TYGetUIScreenWidth, CGRectGetHeight(self.ButtonView.frame) + TYGetUIScreenWidth / 3 * 3 + 10)];

        _bottomBaseView.backgroundColor = AppFontf1f1f1Color;
        
        [_bottomBaseView addSubview:self.ButtonView];
        
        [_bottomBaseView addSubview:self.markNewBillBottomBaseView];
        __weak typeof(self) weakSelf = self;
        self.markNewBillBottomBaseView.didSelectMarkBillBlock = ^(JGJMainMarkBillType mainMarkBillType) {
            
            [weakSelf didSelectMarkBillListCellFrom:mainMarkBillType];
        };

    }
    return _bottomBaseView;
}

-(UIView *)otherBaseView
{
    if (!_otherBaseView) {
        _otherBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calenderBaqseView.frame), TYGetUIScreenWidth, CGRectGetHeight(self.bottomBaseView.frame) + 95)];
        _otherBaseView.backgroundColor = AppFontf1f1f1Color;
        [_otherBaseView addSubview:self.theNewRecordRemindView];
        [_otherBaseView addSubview:self.bottomBaseView];
    }
    return _otherBaseView;
}
//顶部选择时间的
-(JGJCalenderDateView *)CalenderDateView
{
    if (!_CalenderDateView) {
        
        _CalenderDateView = [[JGJCalenderDateView alloc]initWithFrame:CGRectMake(0, JGJ_IphoneX_Or_Later ? 44 : 0, TYGetUIScreenWidth, 64)];
        _CalenderDateView.backgroundColor = [UIColor whiteColor];
        _CalenderDateView.delegate = self;
        [_CalenderDateView addSubview:self.backUpButton];
        [_CalenderDateView addSubview:self.commonProblemBtn];
        self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
        _CalenderDateView.rightDateButton.hidden = YES;
    }
    return _CalenderDateView;
}
-(JGJRecordTipView *)RecordTipView
{
    if (!_RecordTipView) {
        
        _RecordTipView = [[JGJRecordTipView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.theNewRecordRemindView.frame), TYGetUIScreenWidth,50)];
        _RecordTipView.backgroundColor = [UIColor whiteColor];
        _RecordTipView.hidden = YES;
        _RecordTipView.delegate = self;
    }
    return _RecordTipView;
}
-(UIView *)ButtonView
{
    if (!_ButtonView) {
        
        _ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , TYGetUIScreenWidth, 100)];
        _ButtonView.backgroundColor = AppFontf1f1f1Color;
        [_ButtonView addSubview:self.theNewWorkHomeRecordBtnView];
    }
    return _ButtonView;
}
-(UIView *)topview
{
    if (!_topview) {
        _topview = [[UIView alloc]initWithFrame:CGRectMake(0, -25, TYGetUIScreenWidth, 25)];
        _topview.backgroundColor = [UIColor whiteColor];
    }
    return _topview;
}
-(UIView *)departLine
{
    if (!_departLine) {
        _departLine = [[UIView alloc]initWithFrame:CGRectMake(0, 70, TYGetUIScreenWidth, 10)];
        _departLine.backgroundColor = AppFontf1f1f1Color;
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        upLine.backgroundColor = AppFontdbdbdbColor;
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5)];
        downLine.backgroundColor = AppFontdbdbdbColor;
        [_departLine addSubview:upLine];
        [_departLine addSubview:downLine];
    }
    return _departLine;
}

- (JGJNewWorkHomeNoteBtnView *)theNewWorkHomeRecordBtnView {
    
    if (!_theNewWorkHomeRecordBtnView) {
        
        _theNewWorkHomeRecordBtnView = [[JGJNewWorkHomeNoteBtnView alloc] initWithFrame:CGRectMake(0, 10, TYGetUIScreenWidth, 80)];
        _theNewWorkHomeRecordBtnView.delegate = self;
    }
    return _theNewWorkHomeRecordBtnView;
}



- (JGJNewRecordRemindView *)theNewRecordRemindView {
    
    if (!_theNewRecordRemindView) {
        
        _theNewRecordRemindView = [[JGJNewRecordRemindView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
        _theNewRecordRemindView.backgroundColor = AppFontfafafaColor;
        UIView *departLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_theNewRecordRemindView.frame) - 0.5, TYGetUIScreenWidth, 0.5)];
        departLine.backgroundColor = AppFontf1f1f1Color;
        [_theNewRecordRemindView addSubview:departLine];
    }
    return _theNewRecordRemindView;
}
- (YZGMateBillRecordWorkpointsView *)billRecordWorkpointsView
{
    if (!_billRecordWorkpointsView) {
        _billRecordWorkpointsView = [[YZGMateBillRecordWorkpointsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_recordWorkHomeMoneyView.frame), TYGetUIScreenWidth, 80)];
        _billRecordWorkpointsView.delegate = self;
        _billRecordWorkpointsView.backgroundColor = [UIColor whiteColor];
    }

    return _billRecordWorkpointsView;
}

- (UIButton *)backUpButton
{
    if (!_backUpButton) {
        _backUpButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,JGJ_IphoneX_Or_Later ? CGRectGetHeight(self.CalenderDateView.frame) / 2 - 15 : 25, 80, 30)];
//        [self.calendar addSubview:_backUpButton];
        _backUpButton.backgroundColor = [UIColor whiteColor];
        [_backUpButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [_backUpButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backUpButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
        [_backUpButton setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
        [_backUpButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _backUpButton;
}

- (UIButton *)commonProblemBtn {
    
    if (!_commonProblemBtn) {
        
        _commonProblemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commonProblemBtn.frame = CGRectMake(TYGetUIScreenWidth - 80, JGJ_IphoneX_Or_Later ? CGRectGetHeight(self.CalenderDateView.frame) / 2 - 15 : 25, 80, 30);
        [_commonProblemBtn setTitle:@"记工说明" forState:UIControlStateNormal];
        _commonProblemBtn.titleLabel.font = FONT(AppFont34Size);
        [_commonProblemBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        
        [_commonProblemBtn addTarget:self action:@selector(lookTheCommonProblemInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commonProblemBtn;
}
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 记工常见问题
- (void)lookTheCommonProblemInfo {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"208"];
    
    //    [TYShowMessage showSuccess:@"帮助按钮按下"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

- (UIScrollView *)mainscrollView
{
    if (!_mainscrollView) {
        
        _mainscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        if (JGJ_IphoneX_Or_Later) {
        _mainscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, TYGetUIScreenWidth, TYGetUIScreenHeight - 78)];

        }
        _mainscrollView.backgroundColor = [UIColor whiteColor];
        _mainscrollView.showsVerticalScrollIndicator = NO;
        _mainscrollView.bounces = NO;
        _mainscrollView.delegate = self;

    }
    return _mainscrollView;
}
#pragma mark - FSCalendarDataSource
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([NSDate getDaysThisMothFrom:calendar.today withToDate:date] == 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX) {
        color = AppFontd7252cColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = AppFont666666Color;
    }else{
        color = AppFont333333Color;
    }
    
    return color;
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
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"barButtonItem_lineBackImage"]];
    
    //恢复那条线
    self.navigationController.navigationBarHidden  = NO;

}
- (BOOL)CheckIsLogin{
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    
    if (![self.navigationController performSelector:checkIsLogin]) {
        return NO;
    }
    return YES;
}
- (void)loginAler{
    if (![self CheckIsLogin]) {
        return ;
    }
    
    //没有名字d
    
    _jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    
    if (_jgjAddNameHUBView) {
        return;
    }
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
- (void)setUpRecordWorkView{
    YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
    YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
    
    firstRecordWorkModel.detailString = @"记工流水";
    
    firstRecordWorkModel.backgroundColor = TYColorHex(0xf75a23);
    firstRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;

    secondRecordWorkModel.detailString = @"工资清单";
    
    secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
    secondRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
    
    self.billRecordWorkpointsView.firstRecordWorkModel = firstRecordWorkModel;
    self.billRecordWorkpointsView.secondRecordWorkModel = secondRecordWorkModel;
    self.billRecordWorkpointsView.delegate = self;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.yzgDatePickerView = nil;
}

- (void)setInitData{
   
    if (!self.datesWithEvent) {
        self.datesWithEvent = [NSMutableArray array];
    }
    
    if (!self.datesWithSubImage) {
        self.datesWithSubImage = [NSMutableArray array];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.calendar.mainVC = NO;
    self.calendar.header.bigfont = NO;
    
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
- (void)JLGHttpRequest{
    
    [self.datesWithEvent removeAllObjects];
    [self.datesWithSubImage removeAllObjects];
    
    //用于日历显示时间和subImage的日期格式
    
    if ([NSString isEmpty:self.postApiString]) {
        
        self.postApiString = @"workday/worker-month-total";

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
    
    _recordMonthBillModel = [[JGJRecordMonthBillModel alloc] init];
    [self.calendar reloadData];
    
    [JLGHttpRequest_AFN PostWithNApiReturnTask:self.postApiString parameters:@{@"date":date} success:^(id responseObject) {
        
        _recordMonthBillModel = [JGJRecordMonthBillModel mj_objectWithKeyValues:responseObject];
        
        self.markNewBillBottomBaseView.model = _recordMonthBillModel;
        self.markNewBillBottomBaseView.wait_confirm_num = _recordMonthBillModel.wait_confirm_num;
        if (_recordMonthBillModel.is_diff_role == 1) {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            NSString *cur_role = JLGisLeaderBool ? @"【班组长】" : @"【工人】";
            
            NSString *change_role = JLGisLeaderBool ? @"【工人】" : @"【班组长】";
            
            desModel.popDetail = [NSString stringWithFormat:@"当前是%@身份\n你上一次是以%@身份记录的，是否切换身份？", cur_role, change_role];
            
            desModel.leftTilte = @"不切换";
            
            desModel.rightTilte = @"去切换身份";
            
            desModel.changeContents = @[@"【班组长】", @"【工人】"];
            
            desModel.lineSapcing = 10;
            
            desModel.changeContentColor = AppFont000000Color;
            
            if (self.isShowChangeRole) {
                
                JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
                
                alertView.messageLable.textAlignment = NSTextAlignmentLeft;
                
                __weak typeof(self) weakSelf = self;
                
                alertView.onOkBlock = ^{
                    
                    // 切换身份 关闭蒙层
                    [weakSelf.maskingView removeFromSuperview];
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"firstOpenBill"];
                    [weakSelf changeRole];
                };
                
                self.isShowChangeRole = NO;
            }
            
        }
        _secondLoad = YES;
        
        [self.calendar reloadData];
        
    }failure:^(NSError *error) {
    }];
}

- (void)showMaskingView {
    
    
}

#pragma mark - 切换身份
- (void)changeRole {
    
    YZGSelectedRoleViewController *selRoleVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    
    selRoleVc.isHiddenCancelButton = YES;
    
    selRoleVc.view.tag = 1;
    
    [self presentViewController:selRoleVc animated:YES completion:nil];
    
}

#pragma mark - 刷新红点
- (void)RecordWorkViewReloadData{
    YZGRecordWorkModel *firstRecordWorkModel = self.billRecordWorkpointsView.firstRecordWorkModel;
    
    firstRecordWorkModel.redPointType = _isRecordedBill?YZGRecordWorkRedPointRedPoint:YZGRecordWorkRedPointDefault;
    self.billRecordWorkpointsView.firstRecordWorkModel = firstRecordWorkModel;
}

#pragma mark - YZGMateBillRecordWorkDelegate 点击记工流水的view
- (void )YZGMateBillRecordWorkBtnClick:(YZGMateBillRecordWorkpointsView *)yzgMateBillRecordView index:(NSInteger )index{

    [self RecordWorkViewBtnClick:yzgMateBillRecordView.tag index:index];
}

- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index{

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

#pragma mark - 点击了借支 结算
- (void)JGJNewWorkHomeNoteButtonClickBorrowOrCloseMarkBillBtn {
    
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
    slideSegmentVC.title = @"记工记账";
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
}
#pragma mark - 点击了马上记一笔
- (void)JGJNewWorkHomeNoteButtonClickSingleMarkBillBtn{

    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
    slideSegmentVC.title = @"记工记账";
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
//    JGJMarkBillViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
//
//    [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {

        jgjrecordMonthModel *recordMonthModel = (jgjrecordMonthModel *)_recordMonthBillModel.list[i];
        if ([recordMonthModel.date intValue] == index) {
            
            // rwork_type 1:休息表示。 2:表示包工记账 0:表示记账(点工/包工记工天) 有备注 is_notes == 1   awork_type 3:表示借支； 4:结算 5:is_record_to_me表示是否对我的记账
            return [NSString stringWithFormat:@"%ld-%@-%@-%ld-%ld-%@-%@-%ld",recordMonthModel.awork_type,recordMonthModel.manhour,recordMonthModel.overtime,recordMonthModel.rwork_type,recordMonthModel.is_notes,recordMonthModel.working_hours, recordMonthModel.overtime_hours,recordMonthModel.is_record_to_me];
        }
        
    }
    
    return @"";
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    [self pushToWorkitemsVc:date];
}

- (void)pushToWorkitemsVc:(NSDate *)date{
   
    if (![self CheckIsLogin]) {
        
        return ;
    }
    NSMutableArray *DateArr = [NSMutableArray array];
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {
        
        [DateArr addObject:[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] date]];
        
    }
    NSString *dayStr = [JGJTime DayStrFromDate:date];
    if (![DateArr containsObject:dayStr]) {
        
//        JGJMarkBillViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
//
//        yzgMateWorkitemsVc.selectedDate = date;
//
//        [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
        JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
        slideSegmentVC.selectedDate = date;
        slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
        slideSegmentVC.title = @"记工记账";
        [self.navigationController pushViewController:slideSegmentVC animated:YES];
        
    }else{
    
        YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
    
        yzgMateWorkitemsVc.searchDate = date;
   
        [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
    }
}


- (BOOL )calendar:(FSCalendar *)calendar subImageForDate:(NSDate *)date{
    
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {
        if ([[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] date] intValue] ==  index &&[[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] amounts_diff] intValue] != 0) {
            return YES;
        }
    }
    
    return NO;
}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    CGRect rect = _calenderBaqseView.frame;
    
    if ([NSDate calculateCalendarRows:calendar.currentPage] == 5) {
        rect.size.height = 70 + 58.00/375*TYGetUIScreenWidth * 5+10.00/375*TYGetUIScreenWidth;
        [_calenderBaqseView setFrame:rect];
        [_calendar setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(_calenderBaqseView.frame))];
        [UIView animateWithDuration:.1 animations:^{
            CGRect otherBaserect = _otherBaseView.frame;
            otherBaserect.origin.y = rect.size.height;
            [_otherBaseView setFrame:otherBaserect];
            
        }];
    }else{
        rect.size.height = 70 + 58.00/375*TYGetUIScreenWidth * 6 +15.00/375*TYGetUIScreenWidth;
        [_calenderBaqseView setFrame:rect];
        [_calendar setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(_calenderBaqseView.frame))];
        [UIView animateWithDuration:.1 animations:^{
            CGRect otherBaserect = _otherBaseView.frame;
            otherBaserect.origin.y = rect.size.height;
            [_otherBaseView setFrame:otherBaserect];
        }];
    }

    [_mainscrollView setContentSize:CGSizeMake(TYGetUIScreenWidth, CGRectGetMaxY(self.otherBaseView.frame) - 50)];
    
    [self JLGHttpRequest];
    
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    _CalenderDateView.rightDateButton.hidden = _calendar.currentPage.components.month == [NSDate date].components.month && _calendar.currentPage.components.year == [NSDate date].components.year;
}
-(void)JGJCalenderDateViewClickrightButton
{
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *nextMonth = [_calendar dateByAddingMonths:1 toDate:currentMonth];
    [_calendar setCurrentPage:nextMonth animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self JLGHttpRequest];

}
- (void)JGJCalenderDateViewClickLeftButton
{
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *previousMonth = [_calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [_calendar setCurrentPage:previousMonth animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self JLGHttpRequest];
}

- (void)JGJCalenderDateViewtapdateLable
{
    [self.yzgDatePickerView setDate:_calendar.currentPage?:[NSDate date]];
    [self.yzgDatePickerView showDatePicker];
    
}
- (void)YZGDataPickerSelect:(NSDate *)date
{

    [_calendar setCurrentPage:date?:[NSDate date] animated:YES];
    self.CalenderDateView.dateTitle.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    [self JLGHttpRequest];

}
#pragma mark - 点击确认差账
- (void)JGJRecordTipViewTapRecordNosureTiplable
{
  
    [self justRealName];
}

- (void)justRealName
{
    
    if (![self checkIsRealName]) {
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
                [self.navigationController pushViewController:poorBillVC animated:YES];
                
            };
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
            };
            
        }
        
    }else{
        
        JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
        [self.navigationController pushViewController:poorBillVC animated:YES];
        
    }
    
}

- (BOOL)checkIsRealName{
    
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - 点击下面的单元格
- (void)didSelectMarkBillListCellFrom:(JGJMainMarkBillType)type{
    
    
    if (type == JGJMarkBillWaterType){//记工流水
        
        [self checkRecordPointsVc];
        
    }else if (type == JGJMarkBillTotalType){//记工统计
        
        [self checkRecordStaVc];
        
    }else if (type == JGJMarkBillGoToAccountCheckingType){//我要对账
        
        [self justRealName];
        
    }else if (type == JGJRemaingAmountType) { //未结工资
        
        [self checkUnWageVc];
        
    }else if (type == JGJMarkBillRecommendToOtherType) {// 推荐给他人
        
        [self shareAccountInfo];
        
    }else if (type == JGJMarkBillSettingUpType) {// 记工设置
        
        JGJRecordWorkpointsSettingController *recordSettingVC = [[JGJRecordWorkpointsSettingController alloc] init];
        [self.navigationController pushViewController:recordSettingVC animated:YES];
        
    }else if (type == JGJMarkBillJobForemanType) {// 班组长
        
        [self skipMemberMangerVc];
        
    }else if (type == JGJMarkBillExplainType) {// 记工说明
        
        NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"208"];
                
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
        
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else if (type == JGJShowWarkDayType) {// 晒工天
        
        if (![self checkIsRealName]) {
            
            if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
                
                JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
                
                customVc.customVcBlock = ^(id response) {
                    
                };
                
            }
            
        }else {
            
            [self showWorkDayEvent];
        }
    }
    
}

#pragma mark - 点击推荐给他人或者我要对账
- (void)didSelectedRecommendToOthersOrReconciliationWithIndex:(NSInteger)index {
    
    if (index == 0) {
        
        [self shareAccountInfo];
        
    }else if(index == 1){
        
        [self justRealName];
        
    }else {
        
        NSLog(@"设置显示方式");
        JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
        
        typeVc.selTypeModel = self.selTypeModel;
        
        [self.navigationController pushViewController:typeVc animated:YES];
    }
}

#pragma mark - 分享记账信息
- (void)shareAccountInfo {
    
    JGJShowShareMenuModel *shareModel = [[JGJShowShareMenuModel alloc] init];
    
    shareModel.title = @"记工账本怕丢失？吉工家手机记工更安全！用吉工家记工，账本永不丢失！";
    
    shareModel.describe = @"1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！";
    
    JGJWXMiniModel *wxMiniModel = [JGJWXMiniModel new];
    
    wxMiniModel.appId = @"gh_89054fe67201";

    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];

    NSString *path = [NSString stringWithFormat:@"pages/work/index?suid=%@",uid];

    wxMiniModel.path = path;
    
    wxMiniModel.wxMiniImage = [UIImage imageNamed:@"share_wxMini_account_icon"];
    
    shareModel.url = [NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person",JGJWebDiscoverURL, uid];
    
    shareModel.imgUrl = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, @"media/default_imgs/logo.jpg"];
    
    JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];

    shareMenuView.Vc = self;

    shareMenuView.shareMenuModel = shareModel;

    shareModel.wxMini = wxMiniModel;

    [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];
    
}

#pragma mark - 查看未结工资
- (void)checkUnWageVc {
    
    JGJUnWagesVc *unWagesVc = [JGJUnWagesVc new];
    
    [self.navigationController pushViewController:unWagesVc animated:YES];
}

#pragma mark - 查看记工统计
- (void)checkRecordStaVc {
    
    JGJRecordStaListVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListVc"];

    [self.navigationController pushViewController:staListVc animated:YES];
}

#pragma mark - 查看记工流水
- (void)checkRecordPointsVc {
    
    JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
    
    [self.navigationController pushViewController:recordWorkpointsVc animated:YES];
}

- (void)skipMemberMangerVc {
    
    JGJMemeberMangerVc *workerManerVc = [[JGJMemeberMangerVc alloc] init];
    
    [self.navigationController pushViewController:workerManerVc animated:YES];
}

@end
