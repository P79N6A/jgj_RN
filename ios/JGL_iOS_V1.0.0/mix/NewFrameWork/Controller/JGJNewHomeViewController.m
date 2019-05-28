//
//  JGJNewHomeViewController.m
//  mix
//
//  Created by Tony on 2019/3/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewHomeViewController.h"
#import "JGJNewHomeVCTopView.h"
#import "JGJNewHomeMyTeamOrGroupView.h"
#import "FSCalendar.h"
#import "NSDate+Extend.h"
#import "MyCalendarObject.h"
#import "JGJNewLeaderRecordButtonView.h"
#import "JYSlideSegmentController.h"
#import "JGJTeamWorkListViewController.h"
#import "TYBaseTool.h"
#import "JGJNewMarkBillBottomBaseView.h"
#import "JGJRecordWorkpointsVc.h"
#import "JGJRecordStaListVc.h"
#import "JLGCustomViewController.h"
#import "JGJSurePoorbillViewController.h"
#import "JGJUnWagesVc.h"
#import "JGJSynRecordParentVc.h"
#import "JGJMemeberMangerVc.h"
#import "JGJRecordWorkpointsSettingController.h"
#import "JGJWebAllSubViewController.h"
#import "JGJNotepadListViewController.h"
#import "YZGMateWorkitemsViewController.h"
#import "JGJCustomPopView.h"
#import "YZGSelectedRoleViewController.h"
#import "YZGDatePickerView.h"
#import "JGJHomeScrollShowMoreMaskingView.h"
#import "JGJMoreDayViewController.h"
#import "JGJUpdateVerPopView.h"
#import "JGJCCToolObject.h"

#import "JGJMyChatGroupsVc.h"

#import "JLGAppDelegate.h"
#import "JGJShowWorkDayView.h"
#import "JGJChatOffLineMsgTool.h"
#import "JGJHomeMaskView.h"
#import "JGJSocketRequest+GroupService.h"

@interface JGJNewHomeViewController ()
<
FSCalendarDelegate,
FSCalendarDataSource,
FSCalendarHeaderDelegate,
JGJNewLeaderRecordButtonViewDelegate,
YZGDatePickerViewDelegate,
UIScrollViewDelegate
>
{
    
    NSURLSessionDataTask *_sessionTask;
    BOOL _isClickChangeRole;// 是否是选择切换身份按钮
    BOOL _isHaveNewVersion;
    BOOL _isHaveRemoveMoreMaskingView;
    NSInteger _homeCurrentRoleType;// 0 工人  1工头
    NSDate *_canlendarSelectedDate;
}

@property (strong, nonatomic) JGJRecordMonthBillModel *recordMonthBillModel;

@property (nonatomic, strong) JGJNewHomeVCTopView *topView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property(nonatomic ,strong) FSCalendar *calendar;
@property (nonatomic, strong) NSCalendar *holidayLunarCalendar;
@property (nonatomic, strong) NSCalendar *lunarCalendar;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) JGJNewLeaderRecordButtonView *theNewLeaderRecordBtnView;
@property (nonatomic, strong) JGJNewHomeMyTeamOrGroupView *myTeamOrGroupView;
@property (strong, nonatomic) JGJNewMarkBillBottomBaseView *markNewBillBottomBaseView;
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) UIImageView *noteTipsImageView;
@property (nonatomic, strong) JGJHomeScrollShowMoreMaskingView *showMoreMaskingView;
@property (nonatomic, strong) JGJShowWorkDayView *showWorkDayView;

@end

@implementation JGJNewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = AppFontEBEBEBColor;
    
    if (JLGisMateBool) {
        
        _homeCurrentRoleType = 0;
        
    }else {
        
        _homeCurrentRoleType = 1;
    }
    
    // 添加登录失效通知
    [TYNotificationCenter addObserver:self selector:@selector(loginFail) name:JLGLoginFail object:nil];
    [TYNotificationCenter addObserver:self selector:@selector(refreshHomeCalendarData) name:JGJRefreshHomeCalendarBillData object:nil];
    
    [self initializeAppearance];
    
    // 初始化block 操作事件
    [self initialTopViewMethod];
    
    //处理发现小红点
    
    TYWeakSelf(self);
    
    // 检查更新
    [self appLaunchServiceSuccessBlock:^(id  _Nonnull responseObject) {
        
        [weakself handleCheckUpdate];
        
    }];
    
    // 加载预先请求好的本地数据
    NSDictionary *dic = [TYUserDefaults objectForKey:JGJHomeCalendarBillData];
    if (dic.allKeys.count == 0) {
        
        [self JLGHttpRequest];
        
    }else {
        
        [self loadLocalHomeCalendarDataWithKeydate:[NSDate date]];
    }
    
    [JGJChatGetOffLineMsgInfo shareManager].getHomeCalendarDataSuccess = ^{
        
        
        [weakself loadLocalHomeCalendarDataWithKeydate:[NSDate date]];
    };
}

- (void)loadLocalHomeCalendarDataWithKeydate:(NSDate *)keyDate{
    
    NSDictionary *dic = [TYUserDefaults objectForKey:JGJHomeCalendarBillData];
    NSDictionary *dataSouce = [dic objectForKey:[NSDate stringFromDate:keyDate format:@"yyyyMM"]];
    _recordMonthBillModel = [[JGJRecordMonthBillModel alloc] init];
    self.recordMonthBillModel = [JGJRecordMonthBillModel mj_objectWithKeyValues:dataSouce];
    self.markNewBillBottomBaseView.model = _recordMonthBillModel;
    self.markNewBillBottomBaseView.wait_confirm_num = self.recordMonthBillModel.wait_confirm_num;
    
    [self.calendar reloadData];
    
}

- (void)refreshHomeCalendarData {
    
    [self JLGHttpRequest];
}

- (void)initialTopViewMethod {
    
    TYWeakSelf(self);
    
    // 切换身份
    _topView.switIdentityBlock = ^{
        
        [weakself changeRole];
        
    };
    
    // 记事本按钮
    _topView.makeANewNoteBlock = ^{
        
        [TYUserDefaults setBool:YES forKey:JGJHomeVCIsClicKNOtePadBtn];
        [weakself.navigationController pushViewController:[[JGJNotepadListViewController alloc] init] animated:YES];
    };
    
    // 向前翻时间
    _topView.leftChoiceTimeBtnBlock = ^{
        
        NSDate *currentMonth = weakself.calendar.currentPage;
        NSDate *previousMonth = [weakself.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
        [weakself.calendar setCurrentPage:previousMonth animated:YES];
        weakself.topView.dateLabel.text = [JGJTime NowTimeYearAcoordingNsdate:weakself.calendar.currentPage?:[NSDate date]];
        [weakself JLGHttpRequest];
    };
    
    // 向后翻时间
    _topView.rightChoiceTimeBtnBlock = ^{
        
        NSDate *currentMonth = weakself.calendar.currentPage;
        NSDate *nextMonth = [weakself.calendar dateByAddingMonths:1 toDate:currentMonth];
        [weakself.calendar setCurrentPage:nextMonth animated:YES];
        
        weakself.topView.dateLabel.text = [JGJTime NowTimeYearAcoordingNsdate:weakself.calendar.currentPage?:[NSDate date]];
        [weakself JLGHttpRequest];
        
    };
    
    // 时间选择
    _topView.timeLabelChoiceBlock = ^{
        
        [weakself.yzgDatePickerView setDate:weakself.calendar.currentPage?:[NSDate date]];
        [weakself.yzgDatePickerView showDatePicker];
    };
    
    // 进入我的项目班组
    _myTeamOrGroupView.gotoMyTeamOrGroupBlock = ^{
        
        [weakself chatGroupsVc];
        
    };
    
}

#pragma mark - 检测更新
- (void)handleCheckUpdate {
    
    [self requestVersion];
    
}

#pragma mark - 更新版本号、弹出升级提示框
- (void)requestVersion {
    
    NSString *keyChainIdentifierStr = [TYBaseTool getKeychainIdentifier];
    
    NSDictionary *parameters = @{@"os" : @"I",
                                 @"client_type" : @"person",
                                 @"device_id" : keyChainIdentifierStr?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"jlsys/version" parameters:parameters success:^(id responseObject) {
        
        JGJUpdateVerInfoModel *infoModel = [JGJUpdateVerInfoModel mj_objectWithKeyValues:responseObject];
        
        [self showUpdateView:infoModel];
        
        if (infoModel.forceUpdate != 0 && ![NSString isEmpty:infoModel.upinfo]) {
            
            _isHaveNewVersion = YES;
            
        }else {
            
            _isHaveNewVersion = NO;
            
            [self showCustomAdvi];
            
        }
        
    }];
}

- (void)showUpdateView:(JGJUpdateVerInfoModel *)infoModel {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    //desModel.popDetail = @"1、班组里可以直接发图片\n2、班组里可以@成员和复制消息\n3、可以修改我在班组中的名字\n4、正常上班记工可以选择“休息”";
    if (infoModel.forceUpdate != 0 && ![NSString isEmpty:infoModel.upinfo]) {
        
        [JGJUpdateVerPopView updateDesViewWithDesModel:desModel updateVerInfoModel:infoModel];
    }
}

#pragma mark - 判断首页弹窗样式
- (void)showCustomAdvi {
    
    if (!_isHaveNewVersion) {
        
        if (JGJIsSelRoleBool) {
            
            TYWeakSelf(self);
            [JGJCCToolObject judgeCountToAlertPopViewWithVC:self dismissBlock:^{
                
                [weakself controlHomeMaskingHiddenOrShow];
                
            }];
        }
        
    }
    
}

#pragma mark - YZGDatePickerViewDelegate
- (void)YZGDataPickerSelect:(NSDate *)date {
    
    [_calendar setCurrentPage:date?:[NSDate date] animated:YES];
    self.topView.dateLabel.text = [JGJTime NowTimeYearAcoordingNsdate:self.calendar.currentPage?:[NSDate date]];
    
    [self JLGHttpRequest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
    
    _isClickChangeRole = NO;
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    //    [self JLGHttpRequest];
    
    [self.calendar reloadData];
    [self.myTeamOrGroupView isShowRedDot];
    
    //显示底部角标未读数
    [self showItemBadgeUnReadNum];
    
    __weak typeof(self) weakSelf = self;
    [JGJChatGetOffLineMsgInfo shareManager].getIndexListSuccess = ^(JGJMyWorkCircleProListModel *proListModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.myTeamOrGroupView isShowRedDot];
        });
    };
    
    //更新身份信息
    [self updateRoleInfo];
    
    if (!_isHaveRemoveMoreMaskingView) {
        
        [self.showMoreMaskingView startTimer];
    }
    
    //异常处理因h5回来会隐藏底部
    if ([self.tabBarController isKindOfClass:[UITabBarController class]]) {
        
        if (self.tabBarController.tabBar.hidden) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.tabBarController.tabBar.hidden = NO;
                
            });
        }
        
    }
    
    JGJSocketRequest *shareSocket = [JGJSocketRequest shareSocketConnect];
    
    TYWeakSelf(self);
    
    shareSocket.contactListCallBack = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself dealTabbarUnreadMessageCount];
        });
        
    };
    
    
    shareSocket.dealCompleteMsgCallBack = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself dealTabbarUnreadMessageCount];
        });
    };
    
    
    // 获取数据库表中数据
    [self dealTabbarUnreadMessageCount];
}

#pragma mark - 处理tabbar未读数 v3.4 cc添加
- (void)dealTabbarUnreadMessageCount {
    
    UITabBarItem * chatItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    NSUInteger chat_unread_msg_count = [JGJChatMsgDBManger getAllUnreadMsgCount];
    
    if (chat_unread_msg_count > 0) {
        
        chatItem.badgeValue = chat_unread_msg_count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",(long)[JGJChatMsgDBManger getAllUnreadMsgCount]];
        
    }else {
        
        chatItem.badgeValue = nil;
    }
    
    NSUInteger total_unread_msg_count = chat_unread_msg_count;
    
    if (JGJAppIsDidisEnterBackgroundBool) {
        
        return;
    }
    
    if (total_unread_msg_count > 0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = total_unread_msg_count;
        
    }else {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

//更新身份信息
- (void)updateRoleInfo {
    
    //更新顶部信息
    [self.topView updateTopView];
    
    //更新中间按钮信息
    [self.theNewLeaderRecordBtnView updateLeaderRecordButtonWithRoleID];
    
    //更新底部选择信息
    [self.markNewBillBottomBaseView updateAccountSelType];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
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
    
    if (!_isClickChangeRole) {
        
        //恢复那条线
        self.navigationController.navigationBarHidden  = NO;
    }
    
    [self.showMoreMaskingView stopAnimation];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.calendar];
    [self.mainScrollView addSubview:self.theNewLeaderRecordBtnView];
    [self.mainScrollView addSubview:self.myTeamOrGroupView];
    [self.mainScrollView addSubview:self.markNewBillBottomBaseView];
    
    //    [self.view addSubview:self.noteTipsImageView];
    
    [self.view addSubview:self.showMoreMaskingView];
    
    //    [self.view addSubview:self.showWorkDayView];
    
    [self setUpLayout];
    
    __weak typeof(self) weakSelf = self;
    self.markNewBillBottomBaseView.didSelectMarkBillBlock = ^(JGJMainMarkBillType mainMarkBillType) {
        
        [weakSelf didSelectMarkBillListCellFrom:mainMarkBillType];
    };
    
    [_mainScrollView updateLayout];
    [_showMoreMaskingView updateLayout];
    [_mainScrollView setContentSize:CGSizeMake(TYGetUIScreenWidth, CGRectGetMaxY(self.markNewBillBottomBaseView.frame) + 20)];
    
    // 判断app打开次数，满足规则的先不出现首蒙层
    NSInteger appOpenCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"appOpenCount"];
    //判断是否出现首页蒙层
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (_isHaveNewVersion || appOpenCount == 20 || (appOpenCount > 20 && appOpenCount % 20 == 0) || jlgAppDelegate.isOpenNotificationJurisdiction) {
        
        
    }else {
        
        [self controlHomeMaskingHiddenOrShow];
    }
    
    // 需求 #19385 领取红包不需要判断权限
    _showWorkDayView.showWorkDay = ^{
        
        [weakSelf getRedPacket];
    };
}

- (void)controlHomeMaskingHiddenOrShow {
    //    需求 #19373 去掉记事本的所有提示
    //    BOOL isClickNoteBtn = [TYUserDefaults boolForKey:JGJHomeVCIsClicKNOtePadBtn];
    //    if (isClickNoteBtn) {
    //
    //        [self.noteTipsImageView removeFromSuperview];
    //    }else {
    //
    //        self.noteTipsImageView.hidden = NO;
    //    }
    
    _theNewLeaderRecordBtnView.scrollTipsLabel.hidden = [TYUserDefaults objectForKey:JGJHomeVCScrollTipsLabelHaveScroll];
    
    if (JGJIsSelRoleBool) {
        
        NSInteger isShowScrollMore = [TYUserDefaults integerForKey:JGJHomeVCIsShowScrollShowMoreMasking];
        if (isShowScrollMore == 0) {
            
            //判断底部功能栏。遮挡位置是否达到蒙层显示条件,当屏高度无法显示下方功能按钮第一排的1/2以上 下方功能按钮大小为 (TYGetUIScreenWidth/3)
            if (_markNewBillBottomBaseView.frame.origin.y > _mainScrollView.frame.size.height - TYGetUIScreenWidth / 6) {
                
                // 且点击下方功能<=5 次时加入提示“ 滑动页面
                
                NSInteger clickCount = [TYUserDefaults integerForKey:JGJHomeBottomViewClickCount];
                if (clickCount <= 5) {
                    
                    [TYUserDefaults setInteger:1 forKey:JGJHomeVCIsShowScrollShowMoreMasking];
                    _showMoreMaskingView.hidden = NO;
                    [_showMoreMaskingView startAnimation];
                }
            }
        }
    }
    
    if (JGJIsSelRoleBool && !JGJIsAddHomeMaskViewBool) {
        
        [TYUserDefaults setBool:YES forKey:JGJIsAddHomeMaskView];
        JGJHomeMaskView *secMaskView = [[JGJHomeMaskView alloc] initWithFrame:self.view.bounds];
        
        UITabBarController *tabVc = self.tabBarController;
        
        if ([tabVc isKindOfClass:NSClassFromString(@"UITabBarController")]) {
            
            [secMaskView setSecGuideView:nil convertView:tabVc.view];
            
        }
    }
    
    
}

- (void)setUpLayout {
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(64 + (IS_IPHONE_X_Later ? 44 : 20));
    }];
    
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-JGJ_IphoneX_BarHeight);
    }];
    
    [_noteTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(145);
        make.height.mas_equalTo(78);
        make.top.equalTo(_topView.mas_top).offset(36 + (IS_IPHONE_X_Later ? 44 : 20));
    }];
    
    [_showMoreMaskingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.bottom.mas_offset(-JGJ_IphoneX_BarHeight - 10 - 49);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(28);
    }];
    
    //    [_showWorkDayView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.centerY.mas_offset(0);
    //        make.right.mas_equalTo(-5);
    //        make.width.mas_equalTo(60);
    //        make.height.mas_equalTo(86);
    //    }];
    
}


- (void)JLGHttpRequest {
    
    if (!_calendar.currentPage) {
        
        _calendar.currentPage = [NSDate date];
    }
    NSString *date;
    if ([NSString isEmpty:[_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"]] ||[_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"] == nil) {
        
        date = [_calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
        
    }else{
        
        date = [_calendar stringFromDate:_calendar.currentPage format:@"yyyyMM"];
    }
    
    // 这里处理一个逻辑，切换到相同身份时，顶部日期不变，切换到不同身份时，顶部日期回到当前月
    if (JLGisMateBool) {
        
        if (_homeCurrentRoleType == 1) {
            
            _calendar.currentPage = [NSDate date];
            date = [_calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
            _homeCurrentRoleType = 0;
        }
    }else {
        
        if (_homeCurrentRoleType == 0) {
            
            _calendar.currentPage = [NSDate date];
            date = [_calendar stringFromDate:[NSDate date] format:@"yyyyMM"];
            _homeCurrentRoleType = 1;
        }
    }
    
    // 请求当前月
    [JLGHttpRequest_AFN PostWithNApiReturnTask:@"workday/worker-month-total" parameters:@{@"date":date} success:^(id responseObject) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[TYUserDefaults objectForKey:JGJHomeCalendarBillData]];
        [dic setObject:responseObject forKey:date];
        [TYUserDefaults setObject:dic forKey:JGJHomeCalendarBillData];
        
        [self loadLocalHomeCalendarDataWithKeydate:_calendar.currentPage];
        
    }failure:^(NSError *error) {
        
    }];
    
    // 获取到当前时间的前一个月
    NSString *previousMonth = [NSDate stringFromDate:[NSDate getPriousorLaterDateFromDate:_calendar.currentPage withMonth:-1] format:@"yyyyMM"];
    
    [JLGHttpRequest_AFN PostWithNApiReturnTask:@"workday/worker-month-total" parameters:@{@"date":previousMonth} success:^(id responseObject) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[TYUserDefaults objectForKey:JGJHomeCalendarBillData]];
        [dic setObject:responseObject forKey:previousMonth];
        [TYUserDefaults setObject:dic forKey:JGJHomeCalendarBillData];
        
    }failure:^(NSError *error) {
        
    }];
    
    // 获取到当前时间的后一个月
    NSString *afterMonth = [NSDate stringFromDate:[NSDate getPriousorLaterDateFromDate:_calendar.currentPage withMonth:1] format:@"yyyyMM"];
    
    if ([afterMonth integerValue] <= [[_calendar stringFromDate:[NSDate date] format:@"yyyyMM"] integerValue]) {
        
        [JLGHttpRequest_AFN PostWithNApiReturnTask:@"workday/worker-month-total" parameters:@{@"date":afterMonth} success:^(id responseObject) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[TYUserDefaults objectForKey:JGJHomeCalendarBillData]];
            [dic setObject:responseObject forKey:afterMonth];
            [TYUserDefaults setObject:dic forKey:JGJHomeCalendarBillData];
            
            
        }failure:^(NSError *error) {
            
        }];
    }
    
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

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    for (int i = 0; i < _recordMonthBillModel.list.count; i++) {
        jgjrecordMonthModel *recordMonthModel = (jgjrecordMonthModel *)_recordMonthBillModel.list[i];
        
        if ([recordMonthModel.date intValue] == index) {
            
            // rwork_type 1:休息表示。 2:表示包工记账 0:表示记账(点工/包工记工天) 有备注 is_notes == 1   awork_type 3:表示借支； 4:结算 5:is_record_to_me表示是否对我的记账
            return [NSString stringWithFormat:@"%ld-%@-%@-%ld-%ld-%@-%@-%ld-%ld",recordMonthModel.awork_type,recordMonthModel.manhour,recordMonthModel.overtime,recordMonthModel.rwork_type,recordMonthModel.is_notes,recordMonthModel.working_hours, recordMonthModel.overtime_hours,recordMonthModel.is_record_to_me,recordMonthModel.is_record];
        }
    }
    
    NSDateComponents *holidayComponents = [self.holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    //判断是否是节日
    NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
    
    if (![holiday isEqualToString:@""]) {
        
        return holiday;
        
    }else{
        
        NSDateComponents *lunarComponents = [self.lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
        NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
        if (![holidayDic[@"holiday"] isEqualToString:@""]) {
            
            return holidayDic[@"holiday"];
            
        }else{
            
            return holidayDic[@"day"];
        }
    }
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    
    // 判断日期是否有记账
    NSInteger index = [JGJTime GetDayFromStamp:date];//时间日期
    BOOL dateIsRecord = NO;
    NSMutableArray *DateArr = [NSMutableArray array];
    for (int i = 0; i < _recordMonthBillModel.list.count; i++) {
        
        jgjrecordMonthModel *recordMonthModel = (jgjrecordMonthModel *)_recordMonthBillModel.list[i];
        
        [DateArr addObject:recordMonthModel.date];
        if ([recordMonthModel.date intValue] == index) {
            
            dateIsRecord = YES;
            break;
        }
    }
    
    NSString *dayStr = [JGJTime DayStrFromDate:date];
    
    if (_recordMonthBillModel.is_diff_role == 1 && !dateIsRecord) {
        
        BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
        
        if (!isChoiceNotChangeRoleID) {
            
            if (![DateArr containsObject:dayStr]) {
                
                self.selectedControllerType = JYSlideSegmentTinyAndContractControlllerType;
                
            }else{
                
                self.selectedControllerType = YZGMateWorkitemsViewControllerType;
                
            }
            [self is_diff_role];
            return NO;
        }
        
    }
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}

- (jgjrecordMonthModel *)filtrateTheDateWithModel:(NSDate *)date {
    
    NSCalendar *newCalendar = [[NSCalendar alloc]
                               initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents *comp = [newCalendar components:unitFlags fromDate:date];
    jgjrecordMonthModel *monthModel = [[jgjrecordMonthModel alloc] init];
    for (jgjrecordMonthModel *model in _recordMonthBillModel.list) {
        
        if ([model.date integerValue] == comp.day) {
            
            monthModel = model;
        }
    }
    
    return monthModel;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    
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
        
        JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
        slideSegmentVC.selectedDate = date;
        slideSegmentVC.makeBillRecordHomeComeIn = YES;
        slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
        slideSegmentVC.title = @"记工记账";
        [self.navigationController pushViewController:slideSegmentVC animated:YES];
        
    }else{
        
        _canlendarSelectedDate = date;
        YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
        
        yzgMateWorkitemsVc.searchDate = date;
        
        [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
    }
}

- (BOOL)CheckIsLogin{
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    
    if (![self.navigationController performSelector:checkIsLogin]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 是否存在角色差异
- (void)is_diff_role {
    
    [TYUserDefaults setInteger:1 forKey:JGJHomeVCIsShowDifferentAlertView];
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    NSString *cur_role = JLGisLeaderBool ? @"【班组长】" : @"【工人】";
    
    NSString *change_role = JLGisLeaderBool ? @"【工人】" : @"【班组长】";
    desModel.popDetail = [NSString stringWithFormat:@"你当前是%@\n与上一次记工身份不一致，是否切换？", cur_role];
    
    desModel.leftTilte = @"不切换";
    
    desModel.rightTilte = [NSString stringWithFormat:@"切换成%@",change_role];
    
    desModel.changeContents = @[@"【班组长】", @"【工人】"];
    
    desModel.changeContentColor = AppFont000000Color;
    
    desModel.lineSapcing = 5;
    
    desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;
    alertView.contentViewHeight.constant = 140;
    
    alertView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf changeRoleWithType:JLGisLeaderBool ? 1:2];
        
    };
    
    alertView.leftButtonBlock = ^{
        
        [TYUserDefaults setBool:YES forKey:JGJHomeVCIsNotChangeRoleId];
        [weakSelf swithViewControllerWithSelectedControllerType];
    };
}

- (void)swithViewControllerWithSelectedControllerType {
    
    switch (self.selectedControllerType) {
            
        case JYSlideSegmentTinyAndContractControlllerType:// 点工
        {
            JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
            
            slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
            slideSegmentVC.title = @"记工记账";
            [self.navigationController pushViewController:slideSegmentVC animated:YES];
        }
            
            break;
            
        case YZGMateWorkitemsViewControllerType:// 每日考勤
        {
            YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
            
            yzgMateWorkitemsVc.searchDate = _canlendarSelectedDate;
            
            [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
        }
            break;
            
        case JYSlideSegmentBorrowAndCloseCountControlllerType:// 借支 结算
        {
            JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
            slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
            slideSegmentVC.title = @"记工记账";
            [self.navigationController pushViewController:slideSegmentVC animated:YES];
        }
            break;
            
        case JGJTeamWorkListViewControllerType:// 选择项目列表
        {
            JGJTeamWorkListViewController *workList = [[JGJTeamWorkListViewController alloc]init];
            [self.navigationController pushViewController:workList animated:YES];
        }
            break;
            
        case JGJMoreDayViewControllerType:// 记多天
        {
            JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
            moreDay.is_Need_ChoiceType_Cache = YES;
            YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
            moreDay.JlgGetBillModel = JlgGetBillModel;
            moreDay.selBtnType = JGJRecordSelLeftBtnType;
            [self.navigationController pushViewController:moreDay animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 切换身份
- (void)changeRoleWithType:(NSInteger)type {
    
    _isClickChangeRole = YES;
    TYWeakSelf(self);
    [JGJComTool changeRoleWithType:type successBlock:^{
        
        [weakself updateRoleInfo];
        [weakself JLGHttpRequest];
        
    }];
    
}

- (void)changeRole {
    
    _isClickChangeRole = YES;
    YZGSelectedRoleViewController *selRoleVc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"YZGSelectedRoleViewController"];
    
    selRoleVc.isHiddenCancelButton = YES;
    
    selRoleVc.view.tag = 1;
    
    [self presentViewController:selRoleVc animated:YES completion:nil];
    
    TYWeakSelf(self);
    selRoleVc.selRoleSuccessBlock = ^{
        
        [weakself JLGHttpRequest];
    };
}


#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    [TYUserDefaults setBool:YES forKey:JGJHomeVCScrollTipsLabelHaveScroll];
    [self.theNewLeaderRecordBtnView hiddenScrollTipsLabel];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        
        if ([NSDate calculateCalendarRows:calendar.currentPage] == 5) {
            
            _calendar.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 62.00/375 * TYGetUIScreenWidth * 5 + 5 + 1);
            
            
        }else {
            
            _calendar.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 62.00/375 * TYGetUIScreenWidth * 6 + 5 + 1);
            
        }
        
        _theNewLeaderRecordBtnView.frame = CGRectMake(0, CGRectGetMaxY(_calendar.frame), TYGetUIScreenWidth, 81 + 15);
        _myTeamOrGroupView.frame = CGRectMake(0, CGRectGetMaxY(self.theNewLeaderRecordBtnView.frame) + 10, TYGetUIScreenWidth, 50);
        
        _markNewBillBottomBaseView.frame = CGRectMake(0, CGRectGetMaxY(self.myTeamOrGroupView.frame) + 10, TYGetUIScreenWidth, TYGetUIScreenWidth / 3 * 3);
        
        [_mainScrollView setContentSize:CGSizeMake(TYGetUIScreenWidth, CGRectGetMaxY(self.markNewBillBottomBaseView.frame) + 20)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [self JLGHttpRequest];
    
    [self loadLocalHomeCalendarDataWithKeydate:_calendar.currentPage];
    self.topView.dateLabel.text = [JGJTime NowTimeYearAcoordingNsdate:_calendar.currentPage?:[NSDate date]];
    
    _topView.rightChangeBtn.hidden = _calendar.currentPage.components.month == [NSDate date].components.month && _calendar.currentPage.components.year == [NSDate date].components.year;
    
}

#pragma mark - JGJNewLeaderRecordButtonViewDelegate
// 点击借支或者结算
- (void)JGJNewLeaderRecordButtonClickBorrowOrCloseMarkBillBtn {
    
    if (_recordMonthBillModel.is_diff_role == 1) {
        
        BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
        if (!isChoiceNotChangeRoleID) {
            
            self.selectedControllerType = JYSlideSegmentBorrowAndCloseCountControlllerType;
            [self is_diff_role];
            return;
            
            
        }else {
            
            JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
            slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
            slideSegmentVC.title = @"记工记账";
            [self.navigationController pushViewController:slideSegmentVC animated:YES];
        }
        
        
    }else {
        
        JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
        slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
        slideSegmentVC.title = @"记工记账";
        [self.navigationController pushViewController:slideSegmentVC animated:YES];
    }
    
}

// 点击中间按钮
- (void)JGJNewLeaderRecordButtonClickMiddleBtnWithType:(JGJHomeRecordButtonClickType)type {
    
    // 批量记多人
    if (type == JGJHomeRecordButtonMakeMorePeopleBillType) {
        
        if (_recordMonthBillModel.is_diff_role == 1) {
            
            BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
            if (!isChoiceNotChangeRoleID) {
                
                self.selectedControllerType = JGJTeamWorkListViewControllerType;
                [self is_diff_role];
                return;
            }
            else {
                
                JGJTeamWorkListViewController *workList = [[JGJTeamWorkListViewController alloc]init];
                [self.navigationController pushViewController:workList animated:YES];
            }
            
            
        }else {
            
            JGJTeamWorkListViewController *workList = [[JGJTeamWorkListViewController alloc]init];
            [self.navigationController pushViewController:workList animated:YES];
        }
        
        
    }else if (type == JGJHomeRecordButtonMakeSingleBillType) {// 记一笔工
        
        
        if (_recordMonthBillModel.is_diff_role == 1) {
            
            BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
            if (!isChoiceNotChangeRoleID) {
                
                self.selectedControllerType = JYSlideSegmentTinyAndContractControlllerType;
                [self is_diff_role];
                return;
            }
            else {
                
                JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
                
                slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
                slideSegmentVC.title = @"记工记账";
                [self.navigationController pushViewController:slideSegmentVC animated:YES];
            }
            
            
            
        }else {
            
            JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
            slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
            slideSegmentVC.title = @"记工记账";
            [self.navigationController pushViewController:slideSegmentVC animated:YES];
        }
    }
    
}

// 点击最右边按钮
- (void)JGJNewLeaderRecordButtonClickRightBtnWithType:(JGJHomeRecordButtonClickType)type {
    
    // 记一笔工
    if (type == JGJHomeRecordButtonMakeSingleBillType) {
        
        if (_recordMonthBillModel.is_diff_role == 1) {
            
            BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
            if (!isChoiceNotChangeRoleID) {
                
                self.selectedControllerType = JYSlideSegmentTinyAndContractControlllerType;
                [self is_diff_role];
                return;
            }
            else {
                
                JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
                slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
                slideSegmentVC.title = @"记工记账";
                [self.navigationController pushViewController:slideSegmentVC animated:YES];
            }
            
            
        }else {
            
            JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
            slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
            slideSegmentVC.title = @"记工记账";
            [self.navigationController pushViewController:slideSegmentVC animated:YES];
        }
        
        
    }else if (type == JGJHomeRecordButtonMakeMoreDayBillType) {// 批量记多天
        
        if (_recordMonthBillModel.is_diff_role == 1) {
            
            BOOL isChoiceNotChangeRoleID = [TYUserDefaults boolForKey:JGJHomeVCIsNotChangeRoleId];
            if (!isChoiceNotChangeRoleID) {
                
                self.selectedControllerType = JGJMoreDayViewControllerType;
                [self is_diff_role];
                return;
            }
            else {
                
                JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
                moreDay.is_Need_ChoiceType_Cache = YES;
                YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
                moreDay.JlgGetBillModel = JlgGetBillModel;
                moreDay.selBtnType = JGJRecordSelLeftBtnType;
                [self.navigationController pushViewController:moreDay animated:YES];
            }
            
            
        }else {
            
            JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
            moreDay.is_Need_ChoiceType_Cache = YES;
            YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
            moreDay.JlgGetBillModel = JlgGetBillModel;
            moreDay.selBtnType = JGJRecordSelLeftBtnType;
            [self.navigationController pushViewController:moreDay animated:YES];
        }
        
    }
}

#pragma mark - 点击下面的单元格
- (void)didSelectMarkBillListCellFrom:(JGJMainMarkBillType)type{
    
    NSInteger clickCount = [TYUserDefaults integerForKey:JGJHomeBottomViewClickCount];
    clickCount = clickCount + 1;
    
    if (clickCount <= 10) {// 反正只判断 是否大于5次，这里最多就加到10次就行了
        
        [TYUserDefaults setInteger:clickCount forKey:JGJHomeBottomViewClickCount];
    }
    
    if (type == JGJMarkBillWaterType){//记工流水
        
        [self checkRecordPointsVc];
        
    }else if (type == JGJMarkBillTotalType){//记工统计
        
        [self checkRecordStaVc];
        
    }else if (type == JGJMarkBillGoToAccountCheckingType){//我要对账
        
        [self justRealName];
        
    }else if (type == JGJRemaingAmountType) { //未结工资
        
        [self checkUnWageVc];
        
    }else if (type == JGJMarkBillSynchronizationType) {// 同步记工
        
        [self checkSynProVc];
        
    }else if (type == JGJMarkBillWorkerManagement) {// 工人管理
        
        [self skipMemberMangerVc];
        
    }else if (type == JGJMarkBillJobForemanType) {// 班组长
        
        [self skipMemberMangerVc];
        
    }else if (type == JGJMarkBillSettingUpType) {// 记工设置
        
        JGJRecordWorkpointsSettingController *recordSettingVC = [[JGJRecordWorkpointsSettingController alloc] init];
        [self.navigationController pushViewController:recordSettingVC animated:YES];
        
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

#pragma mark - 查看记工流水
- (void)checkRecordPointsVc {
    
    JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
    
    [self.navigationController pushViewController:recordWorkpointsVc animated:YES];
}

#pragma mark - 查看记工统计
- (void)checkRecordStaVc {
    
    JGJRecordStaListVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListVc"];
    
    [self.navigationController pushViewController:staListVc animated:YES];
}

- (void)justRealName {
    
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

- (BOOL)checkIsRealName {
    
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 查看未结工资
- (void)checkUnWageVc {
    
    JGJUnWagesVc *unWagesVc = [JGJUnWagesVc new];
    
    [self.navigationController pushViewController:unWagesVc animated:YES];
}

#pragma mark - 查看同步记工

- (void)checkSynProVc {
    
    TYWeakSelf(self);
    
    if (![self checkIsRealName]) {
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself skipSynProVc];
                
            };
            
        }
        
    }else {
        
        [weakself skipSynProVc];
    }
}
// 工人/班组长管理
- (void)skipMemberMangerVc {
    
    JGJMemeberMangerVc *workerManerVc = [[JGJMemeberMangerVc alloc] init];
    
    [self.navigationController pushViewController:workerManerVc animated:YES];
}

// 同步记工
- (void)skipSynProVc {
    
    JGJSynRecordParentVc *synRecordParentVc = [[JGJSynRecordParentVc alloc] init];
    
    [self.navigationController pushViewController:synRecordParentVc animated:YES];
}

// 晒工天
- (void)showWorkDayEvent {
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,@"workday"]];
    [self.navigationController pushViewController:webVc animated:YES];
}

// 领取红包
- (void)getRedPacket {
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,@"my/3"]];
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _isHaveRemoveMoreMaskingView = YES;
    [self.showMoreMaskingView removeFromSuperview];
    [self.showMoreMaskingView stopAnimation];
    
}

#pragma mark - 进入我的班组页面
- (void)chatGroupsVc {
    
    JGJMyChatGroupsVc *groupVc = [[JGJMyChatGroupsVc alloc] init];
    
    [self.navigationController pushViewController:groupVc animated:YES];
}

- (void)loginFail{//登录失效的情况
    if (JLGisLoginBool) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [TYUserDefaults removeObjectForKey:JLGToken];
            
            [TYUserDefaults setBool:NO forKey:JLGLogin];
            
            [TYUserDefaults synchronize];
            
            JLGAppDelegate *app = (JLGAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [app setRootViewController];
            
        });
        
    }
}

#pragma mark - 更新底部角标
- (void)updateReciveSocketMessage:(JGJChatMsgListModel *)msgModel {
    
    [self showItemBadgeUnReadNum];
    
}

#pragma mark - 消息角标未读数处理

- (void)showItemBadgeUnReadNum {
    
    if (![self.tabBarController isKindOfClass:[UITabBarController class]]) {
        
        return;
    }
    
    UITabBarItem * chatItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    NSUInteger chat_unread_msg_count = [JGJChatMsgDBManger getAllUnreadMsgCount];
    
    NSString *chat_msg_count = [NSString stringWithFormat:@"%@", @(chat_unread_msg_count)];
    
    [self saveUserDefaults:chat_msg_count];
    
    if (chat_unread_msg_count > 0) {
        
        chatItem.badgeValue = chat_unread_msg_count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",chat_unread_msg_count];
        
    }else {
        
        chatItem.badgeValue = nil;
    }
    
    NSUInteger total_unread_msg_count = chat_unread_msg_count;
    
    if (JGJAppIsDidisEnterBackgroundBool) {
        
        return;
    }
    
    if (total_unread_msg_count > 0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = total_unread_msg_count;
        
    }else {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
}

- (void)saveUserDefaults:(NSString *)badge
{
    NSString *version= [UIDevice currentDevice].systemVersion;
    
    if(version.doubleValue < 10.0) {
        
        return;
        
    }
    
    if ([NSString isEmpty:badge]) {
        
        badge = @"0";
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:JGJShareSuiteName];
    
    [shared setObject:badge forKey:JGJShareSuiteNameKey];
    
    [shared synchronize];
}

- (JGJNewHomeVCTopView *)topView {
    
    if (!_topView) {
        
        _topView = [[JGJNewHomeVCTopView alloc] init];
    }
    return _topView;
}

- (UIScrollView *)mainScrollView {
    
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = AppFontEBEBEBColor;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (FSCalendar *)calendar {
    
    if (!_calendar) {
        
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 62.00/375 * TYGetUIScreenWidth * [NSDate calculateCalendarRows:[NSDate date]] + 5 + 1)];
        _calendar.backgroundColor = AppFontffffffColor;
        _calendar.appearance.titleFont = FONT(AppFont36Size);
        _calendar.appearance.titleDefaultColor = AppFontccccccColor;
        _calendar.appearance.titleSelectionColor = AppFont333333Color;
        _calendar.appearance.selectionColor = AppFontfdf0f0Color;
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.homeRecordBillCalendar = YES;
        _calendar.appearance.titleTodayColor = AppFontd7252cColor;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
        _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.notShowWeakDayLabel = YES;
        _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
        _calendar.appearance.headerTitleColor = AppFont2a2a2aColor;
        _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
        _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
        _calendar.appearance.todayColor = AppFontfafafaColor;
        _calendar.appearance.titleTodayColor = AppFontd7252cColor;
        _calendar.headerHeight = 0;
        _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
        _calendar.headerNeedOffset = YES;
        _calendar.header.hidden = YES;
        _calendar.showHeader = NO;
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

- (JGJNewLeaderRecordButtonView *)theNewLeaderRecordBtnView {
    
    if (!_theNewLeaderRecordBtnView) {
        
        _theNewLeaderRecordBtnView = [[JGJNewLeaderRecordButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendar.frame), TYGetUIScreenWidth, 81 + 15)];
        _theNewLeaderRecordBtnView.delegate = self;
        _theNewLeaderRecordBtnView.scrollTipsLabel.hidden = YES;
    }
    return _theNewLeaderRecordBtnView;
}

- (JGJNewHomeMyTeamOrGroupView *)myTeamOrGroupView {
    
    if (!_myTeamOrGroupView) {
        
        _myTeamOrGroupView = [[JGJNewHomeMyTeamOrGroupView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.theNewLeaderRecordBtnView.frame) + 10, TYGetUIScreenWidth, 50)];
    }
    return _myTeamOrGroupView;
}

- (JGJNewMarkBillBottomBaseView *)markNewBillBottomBaseView {
    
    if (!_markNewBillBottomBaseView) {
        
        _markNewBillBottomBaseView = [[JGJNewMarkBillBottomBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTeamOrGroupView.frame) + 10, TYGetUIScreenWidth, TYGetUIScreenWidth / 3 * 3)];
        _markNewBillBottomBaseView.backgroundColor = AppFontf1f1f1Color;
    }
    return _markNewBillBottomBaseView;
}

- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
        
    }
    return _yzgDatePickerView;
}

- (UIImageView *)noteTipsImageView {
    
    if (!_noteTipsImageView) {
        
        _noteTipsImageView = [[UIImageView alloc] init];
        BOOL isHaveNoteRecord = [TYUserDefaults objectForKey:JGJUserHaveMakeANote];
        // 有记事本记录
        if (isHaveNoteRecord) {
            
            _noteTipsImageView.image = IMAGE(@"notePadTips_oldUsers");
            
        }else {
            
            _noteTipsImageView.image = IMAGE(@"notePadTips_newUsers");
        }
        
        _noteTipsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _noteTipsImageView.hidden = YES;
    }
    return _noteTipsImageView;
}

- (JGJHomeScrollShowMoreMaskingView *)showMoreMaskingView {
    
    if (!_showMoreMaskingView) {
        
        _showMoreMaskingView = [[JGJHomeScrollShowMoreMaskingView alloc] init];
        _showMoreMaskingView.hidden = YES;
    }
    return _showMoreMaskingView;
}

- (JGJShowWorkDayView *)showWorkDayView {
    
    if (!_showWorkDayView) {
        
        _showWorkDayView = [[JGJShowWorkDayView alloc] init];
    }
    return _showWorkDayView;
}
@end
