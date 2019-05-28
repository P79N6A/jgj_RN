//
//  JGJleaderWorkViewController.m
//  mix
//
//  Created by Tony on 2017/2/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJleaderWorkViewController.h"
#import "JGJBillSyncHomeView.h"
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
#import "JGJSynBillingManageVC.h"
#define leftArrow 110
#define rightArrow 100
static NSString *const calendarFormat = @"yyyy/MM/dd";
@interface JGJleaderWorkViewController ()
<
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarHeaderDelegate,
JGJAddNameHUBViewDelegate,
YZGDatePickerViewDelegate,
FSCalendarDelegateAppearance,
RecordWorkHomeNoteViewDelegate,
ClickcalenderButtondelegate
>{

    BOOL _isRecordedBill;//记录今天是否有流水，如果有流水，则"记工流水"需要显示红点
    RecordWorkHomeNoteModel *_recordWorkNoteModel;//马上记一笔使用的Model
}
@property (strong, nonatomic) IBOutlet UILabel *secondLable;
@property (strong, nonatomic) IBOutlet UILabel *threeidLable;
@property (strong, nonatomic) IBOutlet UILabel *foutThlable;
@property (strong, nonatomic) IBOutlet RecordWorkHomeNoteView *recordNoteMoney;
@property (strong, nonatomic) IBOutlet UIView *placeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *distanceConstance;
@property (strong, nonatomic) IBOutlet UIView *newplaceView;
@property (strong, nonatomic) IBOutlet JGJBillSyncHomeView *jgjBillSyncHomeTableView;
//@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
//@property(nonatomic ,strong)JGJSelectView *titleView;
//@property (strong, nonatomic) NSCalendar *lunarCalendar;
//@property (strong, nonatomic) NSCalendar *holidayLunarCalendar;
//@property (strong, nonatomic) NSMutableArray *datesWithEvent;
//@property (strong, nonatomic) NSMutableArray *datesWithSubImage;
@property (strong, nonatomic) UIButton *backUpButtonsNext;
@property (strong, nonatomic) JGJRecordMonthBillModel *recordMonthBillModel;

//
//@property (strong, nonatomic) NSMutableArray *recordArray;
@property (strong, nonatomic) IBOutlet FSCalendar *Lecalender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) NSMutableArray *recordArray;
@property (strong, nonatomic) NSMutableArray *ModelArray;
@end
@implementation JGJleaderWorkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!JLGisLoginBool) {
        [self.recordWorkHomeMoneyView setMoneyWithMonth:@"0.00" WithYear:@"0.00"];
    }
    if ([NSDate calculateCalendarRows:_Lecalender.currentPage] == 6) {
        //六行
        [UIView animateWithDuration:.2 animations:^{
            _newplaceView.transform = CGAffineTransformMakeTranslation(0,24);
            _jgjBillSyncHomeTableView.firstLable.hidden =NO;
            _jgjBillSyncHomeTableView.twolable.hidden =NO;
            _jgjBillSyncHomeTableView.threelable.hidden =NO;
            
            _jgjBillSyncHomeTableView.transform = CGAffineTransformMakeTranslation(0, -10.5);
        }];
    }
    else{
        _jgjBillSyncHomeTableView.firstLable.hidden =NO;
        _jgjBillSyncHomeTableView.twolable.hidden =NO;
        _jgjBillSyncHomeTableView.threelable.hidden =NO;

        _newplaceView.transform = CGAffineTransformMakeTranslation(0,0);
        _jgjBillSyncHomeTableView.transform = CGAffineTransformMakeTranslation(0, -4);
    }
//    _distanceConstance.constant = 0 *TYGetUIScreenHeight/1334;
//    _newplaceView.transform = CGAffineTransformMakeTranslation(0,17);
//    self.postApiString = @"jlworkday/fmain";
    self.postApiString = @"jlworkday/workerMonthTotal";

    self.calendar = _Lecalender;

    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.recordNoteMoney.delegate = self;

    [self setCalendarstyle];
//    [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];
    [self GetworkerMonth];
    [self initLeaderSuberview];
    
    //临时添加

    }


//获取本月记账
-(void)GetworkerMonth
{
    [_ModelArray removeAllObjects];
    [_Lecalender reloadData];
    [TYLoadingHub showLoadingWithMessage:nil];

    NSString *date;
    if ([NSString isEmpty:[TYUserDefaults objectForKey:JLGUserUid]]) {
//        [TYShowMessage showError:@"获取数据出错"];
        return;
    }
    if (!_Lecalender.currentPage) {
        _Lecalender.currentPage = [NSDate date];
    }
    if ( !_Lecalender.currentPage) {
        date = [_Lecalender stringFromDate:[NSDate date] format:@"yyyyMM"];
    }else{
        date = [_Lecalender stringFromDate:_Lecalender.currentPage format:@"yyyyMM"];
    }
    NSDictionary *body = @{
                           @"uid" : [NSString stringWithFormat:@"%@",[TYUserDefaults objectForKey:JLGUserUid]]?:@"",
                           @"date": date?:@""
                           };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/workerMonthTotal" parameters:body success:^(id responseObject) {
        _ModelArray = [[NSMutableArray alloc]init];
//        _ModelArray =[jgjrecordMonthModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        _recordMonthBillModel =[JGJRecordMonthBillModel mj_objectWithKeyValues:responseObject];
 
  [self.recordWorkHomeMoneyView setMoneyWithMonth:_recordMonthBillModel.m_total.total WithYear:_recordMonthBillModel.y_total.total];


        [_Lecalender reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i<_recordMonthBillModel.list.count; i++) {
        
        if ([[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] date] intValue] ==  index) {
            return [NSString stringWithFormat:@"%@-%@",[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] manhour],[(jgjrecordMonthModel *)_recordMonthBillModel.list[i] overtime]];
        }
//        if ([[(jgjrecordMonthModel *)_ModelArray[i] date] intValue] ==  index) {
//            return [NSString stringWithFormat:@"%@-%@",[(jgjrecordMonthModel *)_ModelArray[i]manhour],[(jgjrecordMonthModel *)_ModelArray[i] overtime]];
//        }
    }
    return @"";
}
- (void)setCalendarstyle
{
    _Lecalender.appearance.headerDateFormat = @"YYYY年MM月";
    _Lecalender.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _Lecalender.appearance.headerTitleColor = AppFont2a2a2aColor;
    _Lecalender.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _Lecalender.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);

    _Lecalender.appearance.todayColor = JGJMainColor;
    _Lecalender.appearance.todayColor = AppFontfafafaColor;
    _Lecalender.appearance.titleTodayColor = [UIColor blackColor];
    _Lecalender.header.delegate = self;
    _Lecalender.header.needSelectedTime = YES;
    _Lecalender.mainVC = YES;
    _Lecalender.header.bigfont = YES;
    _Lecalender.header.leftAndRightShow = YES;
    _Lecalender.appearance.cellShape = FSCalendarCellShapeRectangle;
    [_Lecalender addSubview:self.backUpButtonsNext];
}

//3.28关闭键盘
- (void)viewWillAppear:(BOOL)animated {
    _Lecalender.mainVC = YES;
    self.calendar.mainVC = YES;
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
    [self GetworkerMonth];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    _Lecalender.mainVC = NO;
    self.calendar.mainVC = NO;
}

- (void)setUpRecordWorkView{
    {//设置上面的一行
        YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *thirdRecordWorkModel = [YZGRecordWorkModel new];
        
//        firstRecordWorkModel.titleString = @"记工流水";
//        firstRecordWorkModel.detailString = @"工钱/借支明细";
        firstRecordWorkModel.detailString = @"同步账单";

        firstRecordWorkModel.backgroundColor = TYColorHex(0xf75a23);
        firstRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
//        secondRecordWorkModel.titleString = @"工资清单";
//        secondRecordWorkModel.detailString = @"应付明细";
        secondRecordWorkModel.detailString = @"记工流水";

        secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        secondRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
//        thirdRecordWorkModel.titleString = @"同步项目";
//        thirdRecordWorkModel.detailString = @"管理人和项目";
        thirdRecordWorkModel.detailString = @"工资清单";

        thirdRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        thirdRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
        self.jgjBillSyncHomeTableView.firstRecordWorkModel = firstRecordWorkModel;
        self.jgjBillSyncHomeTableView.secondRecordWorkModel = secondRecordWorkModel;
        self.jgjBillSyncHomeTableView.thirdRecordWorkModel = thirdRecordWorkModel;
        self.jgjBillSyncHomeTableView.delegate = self;
    }
    {//设置下面的一行
        YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
        
        firstRecordWorkModel.titleString = @"昨日考勤";
        firstRecordWorkModel.backgroundColor = TYColorHex(0xf9a00f);
        firstRecordWorkModel.redPointType = YZGRecordWorkRedPointLabelNum;
        
        
        secondRecordWorkModel.titleString = @"今日考勤";
        secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        secondRecordWorkModel.redPointType = YZGRecordWorkRedPointLabelNum;
        
        [self updateRecordNumLabelWith:firstRecordWorkModel WithSecondModel:secondRecordWorkModel];
//        self.billRecordWorkpointsSecondView.delegate = self;
    }
}
- (void)RecordWorkViewReloadData{
    [super RecordWorkViewReloadData];
    YZGRecordWorkModel *firstRecordWorkModel = self.jgjBillSyncHomeTableView.firstRecordWorkModel;
    YZGRecordWorkModel *secondRecordWorkModel = self.jgjBillSyncHomeTableView.secondRecordWorkModel;
    
    [self updateRecordNumLabelWith:firstRecordWorkModel WithSecondModel:secondRecordWorkModel];
}

//从父类继承的
- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index{
    
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    if (section == 0) {
        if (index >= 1) {
            //记工流水
            [super RecordWorkViewBtnClick:section index:index];
        }else{//进入同步账单
            JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
            JGJSynBillingManageVC *synBillingManageVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynBillingManageVC"];
            synBillingCommonModel.synBillingTitle = @"同步项目管理";
            synBillingCommonModel.isWageBillingSyn = NO;
            synBillingManageVC.synBillingCommonModel = synBillingCommonModel;
            
            [self.navigationController pushViewController:synBillingManageVC animated:YES];
        }
    }
    if (section == 2) {
        YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
        
        yzgMateWorkitemsVc.searchDate = self.calendar.currentPage;
        if (index == 0)//昨天
        {
            yzgMateWorkitemsVc.searchDate = [self.calendar dateByAddingDays:-1 toDate:[NSDate date]];
        }else if (index == 1)//今天
        {
            yzgMateWorkitemsVc.searchDate = [NSDate date];
        }
        
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
    
//    for (int i = 0; i<_ModelArray.count; i++) {
//        if ([[(jgjrecordMonthModel *)_ModelArray[i] date] intValue] ==  index &&[[(jgjrecordMonthModel *)_ModelArray[i] amounts_diff] intValue] != 0) {
//            return YES;
//        }
//    }
    
    return NO;
}
#pragma mark - 更新昨日考勤
- (void)updateRecordNumLabelWith:(YZGRecordWorkModel *)firstRecordWorkModel WithSecondModel:(YZGRecordWorkModel *)secondRecordWorkModel{
    
    firstRecordWorkModel.labelNum = [NSString stringWithFormat:@"%@",@(self.yzgWorkDayModel.yestodaybill_count)];
//    NSString *firstContentStr = [NSString stringWithFormat:@"还有%@个工人未记账",firstRecordWorkModel.labelNum];
    
     NSString *firstContentStr = @"同步项目";
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:firstContentStr];
//    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, firstContentStr.length)];
//    //数字需要颜色
//    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(2, firstRecordWorkModel.labelNum.length)];
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, 0)];
    //数字需要颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(0, 0)];
    firstRecordWorkModel.detailString = contentStr;
    
    secondRecordWorkModel.labelNum = [NSString stringWithFormat:@"%@",@(self.yzgWorkDayModel.todaybill_count)];
//    NSString *secondContentStr = [NSString stringWithFormat:@"已有%@个工人记账",secondRecordWorkModel.labelNum];
    NSString *secondContentStr = @"记工流水";
    contentStr = [[NSMutableAttributedString alloc] initWithString:secondContentStr];
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, 0)];
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(0, 0)];
//    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, secondContentStr.length)];
//    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(2, secondRecordWorkModel.labelNum.length)];
    secondRecordWorkModel.detailString = contentStr;
    
//    self.billRecordWorkpointsSecondView.firstRecordWorkModel = firstRecordWorkModel;
//    self.billRecordWorkpointsSecondView.secondRecordWorkModel = secondRecordWorkModel;
}
- (UIButton *)backUpButtonsNext
{
    if (!_backUpButtonsNext) {
        _backUpButtonsNext = [[UIButton alloc]initWithFrame:CGRectMake(-10, 6.5, 80, 40)];
//        [self.calendar addSubview:_backUpButtonsNext];
        _backUpButtonsNext.backgroundColor = [UIColor whiteColor];
        [_backUpButtonsNext addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [_backUpButtonsNext setTitle:@"返回" forState:UIControlStateNormal];
        [_backUpButtonsNext setTitleColor:JGJMainColor forState:UIControlStateNormal];
        [_backUpButtonsNext setImage:[UIImage imageNamed:@"barButtonItem_back"] forState:UIControlStateNormal];
        [_backUpButtonsNext setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _backUpButtonsNext;
}
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)FSCalendarHeaderLeftandRIGHTSelected:(NSInteger)TAG
{
    [self loginAler];
    if (!JLGIsRealNameBool) {
        return;
    }
    if (TAG == leftArrow) {
        NSDate *currentMonth = _Lecalender.currentPage;
        NSDate *previousMonth = [_Lecalender dateBySubstractingMonths:1 fromDate:currentMonth];
        [_Lecalender setCurrentPage:previousMonth animated:YES];
    }else{
        
        NSDate *currentMonth = _Lecalender.currentPage;
        NSDate *nextMonth = [_Lecalender dateByAddingMonths:1 toDate:currentMonth];
        [_Lecalender setCurrentPage:nextMonth animated:YES];
    }
    
    
}
-(void)reciveNotification:(NSNotification *)obj
{
    if ([obj.object intValue] == leftArrow) {
        NSDate *currentMonth = _Lecalender.currentPage;
        NSDate *previousMonth = [_Lecalender dateBySubstractingMonths:1 fromDate:currentMonth];
        [_Lecalender setCurrentPage:previousMonth animated:YES];
        
    }else{
        NSDate *currentMonth = _Lecalender.currentPage;
        NSDate *nextMonth = [_Lecalender dateByAddingMonths:1 toDate:currentMonth];
        [_Lecalender setCurrentPage:nextMonth animated:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.calendar.mainVC = NO;
    
}
- (void)initLeaderSuberview
{
    _secondLable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStr = [[NSMutableAttributedString alloc] initWithString:@"1d=1个工 "];
    [centerattrStr addAttribute:NSForegroundColorAttributeName
                          value:AppFontd7252cColor
                          range:NSMakeRange(0,2)];
    _secondLable.attributedText = centerattrStr;
    if (TYGetUIScreenWidth<= 320) {
        _rightdistance.constant = - 14;
        
    }else if(TYGetUIScreenWidth == 375){
        _rightdistance.constant = - 18;
        
    }else{
        
        _rightdistance.constant = -24;
        
    }
    _threeidLable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrs = [[NSMutableAttributedString alloc] initWithString:@"1h=正常上班1小时"];
    
    [centerattrStrs addAttribute:NSForegroundColorAttributeName
                           value:AppFontd7252cColor
                           range:NSMakeRange(0,2)];
    _threeidLable.attributedText = centerattrStrs;
    
    _foutThlable.font = [UIFont systemFontOfSize:AppFont24Size];;
    NSMutableAttributedString *centerattrStrss = [[NSMutableAttributedString alloc] initWithString:@"1h=加班1小时"];
    
    [centerattrStrss addAttribute:NSForegroundColorAttributeName
                            value:AppFont6487e0Color
                            range:NSMakeRange(0,2)];
    _foutThlable.attributedText = centerattrStrss;
}

- (void)loginAler{
    if (![self checkIsLogin]) {
        return ;
    }
    //没有名字
    UIView *jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    if (jgjAddNameHUBView) {
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
-(void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{


}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    
     if ([NSDate calculateCalendarRows:calendar.currentPage] == 6) {
     //六行
     [UIView animateWithDuration:.1 animations:^{
     _newplaceView.transform = CGAffineTransformMakeTranslation(0,26);
         _jgjBillSyncHomeTableView.firstLable.hidden =NO;
         _jgjBillSyncHomeTableView.twolable.hidden =NO;
         _jgjBillSyncHomeTableView.threelable.hidden =NO;

    _jgjBillSyncHomeTableView.transform = CGAffineTransformMakeTranslation(0, -13);
     }];
     }else{
//     //五行
     [UIView animateWithDuration:.1 animations:^{
     _newplaceView.transform = CGAffineTransformMakeTranslation(0, 0 *TYGetUIScreenHeight/1334);
         _jgjBillSyncHomeTableView.transform = CGAffineTransformMakeTranslation(0, 1);
         _jgjBillSyncHomeTableView.firstLable.hidden =YES;
         _jgjBillSyncHomeTableView.twolable.hidden =YES;
         _jgjBillSyncHomeTableView.threelable.hidden =YES;
     }];
     }
//    [self JLGHttpRequest];
    [self GetworkerMonth];
    
}
- (void)RecordNoteMoneyReloadData{
    self.recordNoteMoney.recordWorkModel = _recordWorkNoteModel;
}


@end
