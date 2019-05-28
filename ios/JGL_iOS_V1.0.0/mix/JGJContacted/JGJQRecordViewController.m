//
//  JGJQRecordViewController.m
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQRecordViewController.h"
#import "RFCollectionViewCell.h"
#import "JGJPackCollectionViewCell.h"
#import "JGJBrowCollectionViewCell.h"
#import "RFLayout.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "YZGMateSalaryTemplateViewController.h"
#import "JGJWorkTypeCollectionView.h"
#import "JGJOtherInfoViewController.h"
#import "JLGPickerView.h"
#import "YZGAddForemanAndMateViewController.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJCusAlertView.h"
#import "JGJMoreDayViewController.h"
#import "JGJCusCalPickerView.h"
#import "JGJBillEditProNameViewController.h"
#import "JGJGetViewFrame.h"
#import "FDAlertView.h"
#import "JGJPackNumViewController.h"
#import "JGJMarkBillBaseVc.h"
#import "JGJWorkbillCollectionViewCell.h"
#import "JLGCustomViewController.h"
#import "JGJRecordBillDetailViewController.h"
#import "JGJAccountingMemberVC.h"

static NSString *RFIdentifier   = @"RFIdentifier";
static NSString *PackIdentifier = @"PackIdentifier";
static NSString *browIdentifier = @"browIdentifier";
static NSString *workBillIdentifier = @"workBillIdentifier";

#define ipone5 10
#define ipone6max 500

@interface JGJQRecordViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate,
didSelectedTableviewdelegate,
didSelectedbrowTableviewdelegate,
didSelectedPackTableviewdelegate,
JLGDatePickerViewDelegate,
JLGPickerViewDelegate,
GYZCustomCalendarPickerViewDelegate,
didSelectedBillTableviewdelegate,
FDAlertViewDelegate
>
{
    RFCollectionViewCell *Timecell;
    JGJPackCollectionViewCell *Packcell;
    JGJBrowCollectionViewCell *browcell;
    JGJWorkbillCollectionViewCell *billCell;
    NSString *_treadid;
}
@property (nonatomic ,strong)UITableView *tablview;
@property (nonatomic ,strong)JLGPickerView *jlgPickerView;
@property (nonatomic,assign) BOOL JGJisMateBool;
@property (nonatomic,strong) NSMutableArray *proNameArray;
@property (nonatomic, strong) JGJCalendarModel *calendarModel;
@property (strong, nonatomic) IBOutlet UIView *NewHoldView;
@property (nonatomic, strong) IDJCalendar *calendar;
@property (nonatomic, strong) UIButton *navButton;
@property (nonatomic, strong) NSMutableArray *saveProArr;

@end
@implementation JGJQRecordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    //获取最近一次记账人
    if (!_recordMore && !_ChatType && JLGisMateBool) {
        [self initLastRecordNews];
    }
    
    if (isiPhoneX) {
    _bottomConstance.constant = 49;
    }
    [self justRealName];
}

- (void)justRealName
{
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                
            };
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            
        }
        
    }
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
  
    
}
- (void)initLastRecordNews
{
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    parmDic = [TYUserDefaults objectForKey:JLGLastRecordBillPeople];
    if (parmDic) {
        self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
        self.yzgGetBillModel.name = self.addForemanModel.name;
        self.yzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        self.yzgGetBillModel.uid = self.addForemanModel.uid;
        self.yzgGetBillModel.phone_num = self.addForemanModel.telph;
        self.yzgGetBillModel.set_tpl.s_tpl = self.addForemanModel.tpl.s_tpl;
        self.yzgGetBillModel.set_tpl.w_h_tpl = self.addForemanModel.tpl.w_h_tpl;
        self.yzgGetBillModel.set_tpl.o_h_tpl = self.addForemanModel.tpl.o_h_tpl;

        [self loadtableview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Packcell.yzgGetBillModel = [[YZGGetBillModel alloc]init];
            browcell.yzgGetBillModel = [[YZGGetBillModel alloc]init];
            billCell.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        });
    }
   }
- (void)initView{

//    if (![[TYUserDefaults objectForKey:@"hadRecord"] isEqualToString:@"firstRecord"]) {
//        [self holdView];
//        [TYUserDefaults setObject:@"firstRecord" forKey:@"hadRecord"];
//    }
    
    self.title = @"记工记账";
    self.navigationItem.titleView = self.navButton;
    [self.RecordCollectionView registerNib:[UINib nibWithNibName:@"RFCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:RFIdentifier];
    [self.RecordCollectionView registerNib:[UINib nibWithNibName:@"JGJPackCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PackIdentifier];
    [self.RecordCollectionView registerNib:[UINib nibWithNibName:@"JGJBrowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:browIdentifier];
    [self.RecordCollectionView registerNib:[UINib nibWithNibName:@"JGJWorkbillCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:workBillIdentifier];
    self.RecordCollectionView.collectionViewLayout = [[RFLayout alloc] init];
    self.RecordCollectionView.dataSource = self;
    self.RecordCollectionView.delegate = self;
    self.RecordCollectionView.backgroundColor = AppFontfafafaColor;
    self.RecordCollectionView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeectionBecomFirstResponser)];
    tap.cancelsTouchesInView = NO;
    [self.RecordCollectionView addGestureRecognizer:tap];
    
    _JGJisMateBool = !JLGisLeaderBool;
    [self initSegment];
    [TYNotificationCenter addObserver:self selector:@selector(reciveAddnewgroup:) name:@"addNewgroup" object:nil];

}
-(UIButton *)navButton
{
    if (!_navButton) {
        _navButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, TYGetUIScreenWidth-200, 60)];
        [_navButton setTitle:@"记工记账" forState:UIControlStateNormal];
//        [_navButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        _navButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_navButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
        [_navButton addTarget:self action:@selector(remoeKeyborad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navButton;
}
-(void)remoeKeyborad
{
    [self.view endEditing:YES];
}
-(void)clickColeectionBecomFirstResponser
{
    [self.view endEditing:YES];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];

}


-(void)reciveAddnewgroup:(NSNotification *)obj
{
    YZGGetBillModel *getbillModel = [YZGGetBillModel new];
    getbillModel = _yzgGetBillModel;
    NSMutableDictionary *dic = obj.object;
    getbillModel.proname = dic[@"pro_name"];
    getbillModel.pid     = [dic[@"pid"] intValue];
    [self loadtableview];
}
- (void)initSegment
{
    _segment.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName: AppFontEB4E4EColor};
    
    [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11],
                                               NSForegroundColorAttributeName: AppFont999999Color};
    [_segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(scrollRecordView:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)red{
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName:AppFontEB4E4EColor};
    [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性

}
-(void)green{

    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName:AppFonte73bf5cColor};
    [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
}
#pragma mark - 点击segment
- (IBAction)scrollRecordCollectionview:(id)sender {
    if (_segment.selectedSegmentIndex >= 2) {
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                 NSForegroundColorAttributeName:AppFonte73bf5cColor};
        [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    }else{
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                 NSForegroundColorAttributeName:AppFontEB4E4EColor};
        [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    }
    [_RecordCollectionView setContentOffset:CGPointMake((TYGetUIScreenWidth-65)*[(UISegmentedControl *)sender selectedSegmentIndex], 0) animated:YES];
}
- (void)scrollRecordView:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex >= 2) {
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                 NSForegroundColorAttributeName:[UIColor greenColor]};
        [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    }
    
    [self.view endEditing:YES];
    switch (segment.selectedSegmentIndex) {
        case 0:
            [_RecordCollectionView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [_RecordCollectionView setContentOffset:CGPointMake(TYGetUIScreenWidth*3/2, 0)];

            break;
        case 2:
            [_RecordCollectionView setContentOffset:CGPointMake(TYGetUIScreenWidth*3-TYGetUIScreenWidth/2+20, 0)];
            break;
        case 3:
            [_RecordCollectionView setContentOffset:CGPointMake(TYGetUIScreenWidth*4-TYGetUIScreenWidth/2+40, 0)];
            break;

        default:
            break;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
#pragma mark -最晚添加 用于初始化借支的项目
    if (_recordMore && !browcell.yzgGetBillModel.name) {
        
        browcell.yzgGetBillModel = Packcell.yzgGetBillModel;
    }
    if (_recordMore && !browcell.yzgGetBillModel.name) {
        billCell.yzgGetBillModel = Packcell.yzgGetBillModel;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    YZGGetBillModel *model = [[YZGGetBillModel alloc]init];
    
    
    _yzgGetBillModel = [[YZGGetBillModel alloc]init];
    if (scrollView.contentOffset.x < ipone5) {
        
        _segment.selectedSegmentIndex = 0;
        _yzgGetBillModel = Timecell.yzgGetBillModel;
        _tablview = Timecell.TimeTableview;
        
        [self red];
    }else if (scrollView.contentOffset.x >= ipone5&& scrollView.contentOffset.x <= TYGetUIScreenWidth*305/375 +20){
        _segment.selectedSegmentIndex = 1;
        _yzgGetBillModel = Packcell.yzgGetBillModel;
        _tablview = Packcell.packTableview;
        [self red];
        
    }else if(scrollView.contentOffset.x > TYGetUIScreenWidth*305/375 +20&& scrollView.contentOffset.x < TYGetUIScreenWidth*305/375*2 +20){
        _segment.selectedSegmentIndex = 2;
        _tablview = browcell.BrowTableview;
        _yzgGetBillModel = browcell.yzgGetBillModel;
        [self green];
        
    }else{
        
        _segment.selectedSegmentIndex = 3;
        _tablview = billCell.BillTableview;
        _yzgGetBillModel = billCell.yzgGetBillModel;
        [self green];
        
    }
    
    //标记选中人员使用
    
    if (_yzgGetBillModel) {
        
        self.addForemanModel.name = _yzgGetBillModel.name?:@"";
        self.addForemanModel.uid = _yzgGetBillModel.uid;
        self.addForemanModel.telph = _yzgGetBillModel.phone_num;
        
    }
}


-(void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel
{
    _tablview = Timecell.TimeTableview;
    _workProListModel = [[JGJMyWorkCircleProListModel alloc]init];
    _workProListModel = workProListModel;
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    if (_selectedDate) {
    self.yzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
    }else{
    self.yzgGetBillModel.date =  [self getWeekDaysString:[NSDate date]];
    }
     self.yzgGetBillModel.name = workProListModel.creater_name;
     self.yzgGetBillModel.uid  = [workProListModel.creater_uid integerValue];
    //几多人进入
    if (_recordMore) {
    self.yzgGetBillModel.proname = workProListModel.all_pro_name;
    self.yzgGetBillModel.pid  = [workProListModel.pro_id integerValue];
//    self.yzgGetBillModel.all_pro_name = workProListModel.all_pro_name;
    }
    if (_getTpl) {
        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
        [self mainGoinGetTPL];
    }
    self.yzgGetBillModel.role = self.roleType;
    
}

-(void)JLGHttpRequest_QueryTplWithUid:(NSString *)uid
{
    [TYLoadingHub showLoadingWithMessage:@""];
    NSMutableDictionary *parmDicdic = [NSMutableDictionary dictionary];
    [parmDicdic setObject:uid forKey:@"uid"];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querytpl" parameters:parmDicdic success:^(id responseObject) {
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        [bill_Tpl mj_setKeyValues:responseObject];
        self.yzgGetBillModel.set_tpl = bill_Tpl;
        self.yzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;//默认的情况下，工作是长就是模板的时间
        self.yzgGetBillModel.overtime = 0;
        //self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        
        [self getSalary];
        
        [self loadtableview];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
   Timecell = [collectionView dequeueReusableCellWithReuseIdentifier:RFIdentifier forIndexPath:indexPath];
        
    Timecell.delegate = self;
        
    _tablview = Timecell.TimeTableview;
        
    if (_workProListModel.creater_name && _ChatType) {
        
    Timecell.CreaterModel = YES;

    Timecell.yzgGetBillModel = self.yzgGetBillModel;
        
    }
        
    if (_recordMore && self.yzgGetBillModel.proname) {
        
    Timecell.morePeople = YES;
        
    }

    return Timecell;
    }else if (indexPath.row == 1){
        
    Packcell = [collectionView dequeueReusableCellWithReuseIdentifier:PackIdentifier forIndexPath:indexPath];
        
    Packcell.delegate = self;
        
        if (_workProListModel.creater_name&&_ChatType) {
            
    Packcell.CreaterModel = YES;
            
    Packcell.yzgGetBillModel = self.yzgGetBillModel;
            
        }
        if (_recordMore && self.yzgGetBillModel.proname) {
    Packcell.morePeople = YES;
        }
        return Packcell;
    }else if(indexPath.row == 2){
     browcell = [collectionView dequeueReusableCellWithReuseIdentifier:browIdentifier forIndexPath:indexPath];
      browcell.delegate = self;
        if (_selectedDate) {
            browcell.selectDate = _selectedDate;
        }
        if (_workProListModel.creater_name&&_ChatType) {
            
         browcell.CreaterModel = YES;

         browcell.yzgGetBillModel = self.yzgGetBillModel;
            
        }
        if (_recordMore && self.yzgGetBillModel.proname) {
            
            browcell.morePeople = YES;
        }

        return browcell;
    }else {
    
        billCell = [collectionView dequeueReusableCellWithReuseIdentifier:workBillIdentifier forIndexPath:indexPath];
        billCell.delegate = self;
        if (_selectedDate) {
            billCell.selectDate = _selectedDate;
        }
        if (_workProListModel.creater_name&&_ChatType) {
            billCell.CreaterModel = YES;
            
            billCell.yzgGetBillModel = self.yzgGetBillModel;
        }
        if (_recordMore && self.yzgGetBillModel.proname) {
            billCell.morePeople = YES;
        }
        

        return billCell;

    
    
    }
}

- (NSMutableArray *)proNameArray
{
    if (!_proNameArray) {
        _proNameArray = [[NSMutableArray alloc] init];
    }
    return _proNameArray;
}

- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
                //显示记更多天按钮
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    if (!self.yzgGetBillModel) {
        self.yzgGetBillModel = [YZGGetBillModel new];
    }
    self.yzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
    NSString *dateFormat = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    self.jlgDatePickerView.datePicker.date = date;
    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
    
    [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];

}

- (JGJCalendarModel *)calendarModel {
    
    if (!_calendarModel) {
        
        _calendarModel = [[JGJCalendarModel alloc] init];
    }
    return _calendarModel;
}

- (IDJCalendar *)calendar {
    if (!_calendar) {
        _calendar = [IDJCalendar new];
    }
    return _calendar;
}

#pragma mark - GYZCustomCalendarPickerViewDelegate
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    self.calendar.year = cal.year;
    self.calendar.month = cal.month;
    self.calendar.day = cal.day;
}

- (void)handleBillButtonPressedAction:(GYZCustomCalendarPickerView *)customCalendarPickerView {

    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc]init];
    moreDay.JlgGetBillModel =  self.yzgGetBillModel;
    moreDay.Mainrecod = _Mainrecord;
    [self.navigationController pushViewController:moreDay animated:YES];
}

-(void)jumpMoneyJPL
{
    YZGMateSalaryTemplateViewController *mateSalaryTemplateVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"mateSalaryTemplate"];
    self.yzgGetBillModel.role = JLGisLeaderBool?2:1;
    mateSalaryTemplateVc.yzgGetBillModel = self.yzgGetBillModel;
     mateSalaryTemplateVc.superViewIsGroup = NO;
    [self.navigationController pushViewController:mateSalaryTemplateVc animated:YES];


}

#pragma mark - 弹出上班时间选择
- (void)showManHourPicker:(NSIndexPath *)indexPath{
    BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl <= 0 && self.yzgGetBillModel.set_tpl.o_h_tpl <= 0;
    if (isNoHour) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    NSInteger workHour = self.yzgGetBillModel.set_tpl.w_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.titleStr = @"选择上班时长";
    
    timeModel.limitTime = workHour;
//    timeModel.isShowZero = YES;
    timeModel.endTime = 12.0;

    timeModel.currentTime = self.yzgGetBillModel.manhour; ////传入当前的时间作为选中标记
    
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:NormalWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.manhour = timeModel.time;
        self.yzgGetBillModel.manhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self getSalary];
        [self loadtableview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}
- (void)showOverHourPicker:(NSIndexPath *)indexPath{
    if (self.yzgGetBillModel.set_tpl.o_h_tpl < 0  || self.yzgGetBillModel.set_tpl.w_h_tpl <= 0) {
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    
      NSInteger overHour = self.yzgGetBillModel.set_tpl.o_h_tpl;
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.titleStr = @"选择加班时长";
    timeModel.limitTime = overHour;
//    timeModel.isShowZero = YES;
    timeModel.endTime = 12.0;//2.0加班时长的选项,增至12小时(与日薪模板里的最大值无关)
    timeModel.currentTime = self.yzgGetBillModel.overtime; //传入当前的时间作为选中标记
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:OverWorkTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        self.yzgGetBillModel.overtime = timeModel.time;
        self.yzgGetBillModel.overhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self getSalary];
        [self loadtableview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    //聊天并且自己是创建者的时候，不能选择项目
    if ([self.workProListModel.myself_group boolValue]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self querypro:^{
        [weakSelf showJLGPickerView:indexPath];
    }];
}
- (void)showJLGPickerView:(NSIndexPath *)indexPath{
        [self.jlgPickerView.leftButton setTitle:@"新增" forState:UIControlStateNormal];
        [self.jlgPickerView.leftButton setImage:[UIImage imageNamed:@"RecordWorkpoints_BtnAdd"] forState:UIControlStateNormal];
        self.jlgPickerView.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.jlgPickerView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
        [self.jlgPickerView setAllSelectedComponents:nil];
        self.jlgPickerView.isShowEditButton = YES;//显示编辑按钮
//    [self.jlgPickerView showPickerByIndexPath:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO ];
//    if (!_saveProArr) {
    
//        _yzgGetBillModel.proname = finishArray[0][@"name"];
//        _yzgGetBillModel.pid     = [finishArray[0][@"id"] intValue];
        NSDictionary *dic = @{
                              @"name":_yzgGetBillModel.proname?:@"",
                              @"id":[NSString stringWithFormat:@"%ld",(long)_yzgGetBillModel.pid]?:@"0"
                              };
        _saveProArr = [[NSMutableArray alloc]init];
        [_saveProArr addObject:dic];
//    }
    [self.jlgPickerView showPickerByrow:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO andArr:_saveProArr];
//    [self.jlgPickerView showPickerByrow:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:isMulti:NO andArr:_saveProArr];
    
}
- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}
-(void)querypro:(JGJMarkBillQueryproBlock)queryproBlock{
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        if (responseObject.count == 0) {
            [TYLoadingHub hideLoadingView];
//            [TYShowMessage showPlaint:@"暂无可用的项目"];
            //聊天的时候，也是编辑
//            if (self.markBillType == MarkBillTypeEdit) {
//                return ;
//            }
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            onlyAddProVc.superViewIsGroup = NO;
            [weakSelf.navigationController pushViewController:onlyAddProVc animated:YES];
            
        }else{
            
            [weakSelf.proNameArray removeAllObjects];
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *proDic = @{@"id":obj[@"pid"],@"name":obj[@"pro_name"]};
                [weakSelf.proNameArray addObject:proDic];
                
                //如果是选中的项目，更新项目名字
                if (weakSelf.yzgGetBillModel.pid == [obj[@"pid"] integerValue]) {
                    weakSelf.yzgGetBillModel.proname = obj[@"pro_name"];
                    weakSelf.yzgGetBillModel.pid     = [obj[@"pid"] integerValue];
                }
            }];
            
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.proNameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            if (queryproBlock) {
                queryproBlock();
            }
        }
//
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}


//备注
-(void)recordbegin
{
    JGJOtherInfoViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"otherInfo"];
    
    if (_tablview == Packcell.packTableview) {
        self.yzgGetBillModel.accounts_type.code = 2;
    }else if (_tablview == Timecell.TimeTableview)
    {
        self.yzgGetBillModel.accounts_type.code = 1;
    }else{
        self.yzgGetBillModel.accounts_type.code = 3;
    }
    if (!self.yzgGetBillModel) {
        self.yzgGetBillModel = [YZGGetBillModel new];
    }

    otherInfoVc.yzgGetBillModel = self.yzgGetBillModel;
//    otherInfoVc.yzgGetBillModel.role = _JGJisMateBool == 1?1:2;
    otherInfoVc.yzgGetBillModel.role = _roleType == 1?1:2;

    if (_tablview == Packcell.packTableview) {
        otherInfoVc.yzgGetBillModel.accounts_type.code = 2;
    }
    otherInfoVc.imagesArray = self.imagesArray;
//    otherInfoVc.deleteImgsArray = self.deleteImgsArray;
    otherInfoVc.parametersDic = self.parametersDic;
    
 
        [self.navigationController pushViewController:otherInfoVc animated:YES];

//    JGJOtherInfoViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"otherInfo"];
//    [self.navigationController pushViewController:otherInfoVc animated:YES];

}
//点击借支的row
- (void)didselectedbrowTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr
{
    [self.view endEditing:YES];
    _tablview = browcell.BrowTableview;
    if (indexpath.section == 0) {
        //选择工头工人
        if (indexpath.row == 1){
            if ([NSString isEmpty: _yzgGetBillModel.name ]) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

            if (self.jlgDatePickerView) {
            self.jlgDatePickerView.isShowMoreDayButton = NO;
            }
            [self showDatePickerByIndexPath:indexpath];
            
            self.jlgDatePickerView.isShowMoreDayButton = NO;
        
        }else if (indexpath.row == 0) {
            if (_ChatType ) {
                return;
            }

            [self handleAddForemanAdnMateVcWithModel:browcell.yzgGetBillModel];
        }}else if (indexpath.section == 1){
        //填写金额
        if (indexpath.row == 0) {
            
        }//做在项目
        else if (indexpath.row == 1){
            if ([NSString isEmpty: _yzgGetBillModel.name ]) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

            if ([NSString isEmpty: _yzgGetBillModel.date ]) {
                [TYShowMessage showError:@"请先选择记账日期"];
                return;
            }
            [self showProjectPickerByIndexPath:indexpath];

        }//记工备注
        else if (indexpath.row == 2){
            if (!_yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

            [self recordbegin];

        }//所在项目
     }
}
//点击包工的row
- (void)didselectedPackTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr
{
    [self.view endEditing:YES];

    _tablview = Packcell.packTableview;
    if (indexpath.section == 0) {
        //选择工头工人

        if (indexpath.row == 1) {
            if ([NSString isEmpty: _yzgGetBillModel.name ]) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

            if (self.jlgDatePickerView) {
                self.jlgDatePickerView.isShowMoreDayButton = NO;
            }
            [self showDatePickerByIndexPath:indexpath];
            
            self.jlgDatePickerView.isShowMoreDayButton = NO;
        }//分享名称
        else if (indexpath.row == 0){
            
            
            if (_ChatType ) {
                return;
            }

            [self handleAddForemanAdnMateVcWithModel:Packcell.yzgGetBillModel];
   
        }
    }else if (indexpath.section == 1){
        
        //选择日期
        if (indexpath.row == 0) {
//            if (!_yzgGetBillModel.name) {
//            [TYShowMessage showError:@"请先选择记账对象"];
//            return;
//            }
//            if (self.jlgDatePickerView) {
//            self.jlgDatePickerView.isShowMoreDayButton = NO;
//            }
//            [self showDatePickerByIndexPath:indexpath];
//            
//            self.jlgDatePickerView.isShowMoreDayButton = NO;
        }//填写单价
        else if (indexpath.row == 1){
            
        }//填写数量
        else if (indexpath.row == 2){
            UIViewController *changeToVc = [[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
            [self.navigationController pushViewController:changeToVc animated:YES];

        }//所在项目
        else if (indexpath.row == 3){
            if (!_yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

        [self showProjectPickerByIndexPath:indexpath];
        }
        
    }else if (indexpath.section == 2){
       //记工备注
        if (indexpath.row == 0) {
            if (!_yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            [self recordbegin];
        }
    }
}
//点击点工的row
- (void)didselectedTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr
{
    [self.view endEditing:YES];

    _tablview = Timecell.TimeTableview;
    if (indexpath.section == 0) {
        
        //选择工头工人
        if (indexpath.row == 1) {
            if ([NSString isEmpty: _yzgGetBillModel.name ]) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }


            if (self.jlgDatePickerView) {
                
                self.jlgDatePickerView.isShowMoreDayButton = YES;
            }
            [self showDatePickerByIndexPath:indexpath];
            self.jlgDatePickerView.isShowMoreDayButton = YES;
        }//选择记账人
        else if (indexpath.row == 0){
            
            if (_ChatType ) {
                
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:Timecell.yzgGetBillModel];
        }
    }else if (indexpath.section == 1){
        //设置薪资模板
        if (indexpath.row == 0) {
            if (!_yzgGetBillModel.date) {
                [TYShowMessage showError:@"请先选择记账日期"];
                return;
            }
        if (!self.yzgGetBillModel.name) {
            [TYShowMessage showError:@"请先选择记账对象"];
            return;
        }
            [self jumpMoneyJPL];
        }//选择上班时长
        else if (indexpath.row == 1){
            if (!self.yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl || self.yzgGetBillModel.set_tpl.w_h_tpl < 0) {
                [TYShowMessage showError:@"请设置工资标准"];
                return;
            }


            [self showManHourPicker:indexpath];
        }//选择加班时长
        else if (indexpath.row == 2){
            if (!self.yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl ) {
                [TYShowMessage showError:@"请设置工资标准"];
                return;
            }

            [self showOverHourPicker:indexpath];
        }
    }else if (indexpath.section == 2){
        //所在项目
        if (indexpath.row == 0) {
            if (!self.yzgGetBillModel.name.length) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl  || self.yzgGetBillModel.set_tpl.w_h_tpl < 0) {
                [TYShowMessage showError:@"请设置工资标准"];
                return;
            }

            [self showProjectPickerByIndexPath:indexpath];
        }//记工备注
        else if (indexpath.row == 1){
            if (!self.yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl || self.yzgGetBillModel.set_tpl.w_h_tpl < 0) {
                [TYShowMessage showError:@"请设置工资标准"];
                return;
            }

//            if (!_yzgGetBillModel.name||!_yzgGetBillModel.set_tpl ||!_yzgGetBillModel.date ||_yzgGetBillModel.manhour) {
//                [TYShowMessage showError:@"请先完善信息"];
//                return;
//            }
            [self recordbegin];
        }

    }

}
//点击工资结算的row
-(void)didselectedBillTableviewforIndexpath:(NSIndexPath *)indexpath withTableviewclass:(NSString *)classStr
{
    [self.view endEditing:YES];
    _tablview = billCell.BillTableview;
    if (indexpath.section == 0) {
        //选择工头工人
        if (indexpath.row == 0) {
            
            if (_ChatType ) {
                
                return;
            }

            [self handleAddForemanAdnMateVcWithModel:browcell.yzgGetBillModel];
        }//选择日期
        else if (indexpath.row == 1){
            if ([NSString isEmpty: _yzgGetBillModel.name ]) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }

            if (self.jlgDatePickerView) {
                
            self.jlgDatePickerView.isShowMoreDayButton = NO;
                
            }
            
            [self showDatePickerByIndexPath:indexpath];
            
            self.jlgDatePickerView.isShowMoreDayButton = NO;
        }
    }else if (indexpath.section == 1){
        //填写金额
        if (indexpath.row == 0) {
            
        }//做在项目
        else if (indexpath.row == 1){
            if (!_yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            
            if (!_yzgGetBillModel.date) {
                [TYShowMessage showError:@"请先选择记账日期"];
                return;
            }
            [self showProjectPickerByIndexPath:indexpath];
            
        }//记工备注
        else if (indexpath.row == 2){
            if (!_yzgGetBillModel.name) {
                [TYShowMessage showError:@"请先选择记账对象"];
                return;
            }
            [self recordbegin];
        }//所在项目
    }
}
//点击点工的保存按钮
- (void)clickSaveDataTimeButtonwithModel:(YZGGetBillModel *)model
{
    if (!_yzgGetBillModel.name) {
        [TYShowMessage showError:@"请先选择记账对象"];

        return;
    }
    if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl ) {
        [TYShowMessage showError:@"请设置工资标准"];
        return;
    }

    [self saveDataToServer];

}
//点击包公的保存按钮
- (void)clickSaveDataPackButtonwithModel:(YZGGetBillModel *)model
{
    if (!_yzgGetBillModel.name) {
        [TYShowMessage showError:@"请先选择记账对象"];
        
        return;
    }
    if (!_yzgGetBillModel.quantities||!_yzgGetBillModel.unitprice) {
        [TYShowMessage showError:@"请设置单价和数量"];
        return;
    }
    if (!_yzgGetBillModel.name ||!_yzgGetBillModel.date||!_yzgGetBillModel.quantities||!_yzgGetBillModel.unitprice) {
        [TYShowMessage showError:@"请先完善信息"];
        return;
    }

    [self saveDataToServer];
 
    
}
//点击借支的保存按钮
-(void)clickSaveDatabrowButtonwithModel:(YZGGetBillModel *)model
{
    if (!_yzgGetBillModel.name) {
        [TYShowMessage showError:@"请先选择记账对象"];
        return;
    }
    if (!_yzgGetBillModel.browNum ||[_yzgGetBillModel.browNum floatValue] == 0) {
        [TYShowMessage showError:@"请输入借支金额"];
        return;
    }
    [self saveDataToServer];


}
//点击工资结算的按钮
- (void)clickSaveDatabillButtonwithModel:(YZGGetBillModel *)model
{
    if (!_yzgGetBillModel.name) {
        [TYShowMessage showError:@"请先选择记账对象"];
        return;
    }
    if (!_yzgGetBillModel.totalNum ||[_yzgGetBillModel.totalNum floatValue] == 0) {
        [TYShowMessage showError:@"请输入结算金额"];
        return;
    }
    
    [self saveDataToServer];
    


}
#pragma mark - 跳转到增加人的界面
- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    self.addForemanModel.telph = billModel.phone_num;
    self.addForemanModel.uid = billModel.uid;
    YZGAddForemanAndMateViewController *addForemanAndMateVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"addForemanAndMate"];
    if (_tablview == Timecell.TimeTableview) {
       addForemanAndMateVc.recordType = @"1";//表示点工
    }else{
     addForemanAndMateVc.recordType = @"0";
    }
    if (![NSString isEmpty:self.addForemanModel.name]) {
    addForemanAndMateVc.addForemanModel = self.addForemanModel;
        //回传数据三个页面全部选中有人时,会有人员丢失
//   addForemanAndMateVc.dataArray = self.addForemandataArray;
    }
    addForemanAndMateVc.workProListModel = self.workProListModel;
    
//    [self.navigationController pushViewController:addForemanAndMateVc animated:YES];
    

//2.3.2yj添加
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
    seledAccountMember.name = billModel.name;
    
    seledAccountMember.telph = billModel.phone_num;
    
    seledAccountMember.uid = [NSString stringWithFormat:@"%@", @(billModel.uid)];
    
    accountingMemberVC.seledAccountMember = seledAccountMember;
    
    //返回的时候用
    accountingMemberVC.targetVc = self;

    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员,如果删除之后accoumtMember为nil
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {
      
        if (accoumtMember.isDelMember) {
            
            if (!_recordMore && JLGisMateBool ) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                [TYUserDefaults setObject:dic forKey:JLGLastRecordBillPeople];
                [self initLastRecordNews];
                self.yzgGetBillModel.proname = @"";
                self.yzgGetBillModel.pid = @"";

            }
   
            
        }else{
        YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
        
        addForemanModel.uid = [accoumtMember.uid integerValue];
        
        addForemanModel.telph = accoumtMember.telph;
        
        addForemanModel.name = accoumtMember.name;
        
        weakSelf.addForemanModel = addForemanModel;
        
        [self JLGHttpRequest_QueryTpl];
        }
    };
}


#pragma mark - 刷新数据
- (void)ModifySalaryTemplateData {

    

}

- (void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel {

    _yzgGetBillModel = yzgGetBillModel;
    [self getSalary];
    [self loadtableview];   

}
#pragma mark -保存最近一次非班组项目组的记账人信息
-(void)saveLastRecordBill
{
    if (!_recordMore && JLGisMateBool ) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSDictionary *tpl = @{
                                     @"s_tpl":@(self.yzgGetBillModel.set_tpl.s_tpl),
                                     @"w_h_tpl":@(self.yzgGetBillModel.set_tpl.w_h_tpl),
                                     @"o_h_tpl":@(self.yzgGetBillModel.set_tpl.o_h_tpl)
                                     };
        [dic setObject:self.yzgGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.yzgGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:self.yzgGetBillModel.phone_num?:@"" forKey:@"telph"];
        [dic setObject:tpl?:@"" forKey:@"tpl"];
        [dic setObject:@(self.yzgGetBillModel.set_tpl.s_tpl)?:@"" forKey:@"s_tpl"];
        [dic setObject:self.yzgGetBillModel.head_pic?:@"" forKey:@"head_pic"];
        [dic setObject:@(self.yzgGetBillModel.set_tpl.w_h_tpl)?:@"" forKey:@"w_h_tpl"];
        [dic setObject:@(self.yzgGetBillModel.set_tpl.o_h_tpl)?:@"" forKey:@"o_h_tpl"];
        [TYUserDefaults setObject:dic forKey:JLGLastRecordBillPeople];
    }
}
#pragma mark - 获取人数
- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    

    _addForemanModel = addForemanModel;
    if (!_yzgGetBillModel) {
    _yzgGetBillModel = [YZGGetBillModel new];
    }
    _yzgGetBillModel.set_tpl = self.addForemanModel.tpl;
    
    _yzgGetBillModel.name = self.addForemanModel.name;
    
    _yzgGetBillModel.uid = self.addForemanModel.uid;
    
    if ([NSString isEmpty:_yzgGetBillModel.date]) {
        
    _yzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
   
    }
    _yzgGetBillModel.phone_num = addForemanModel.telph;
    _yzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
    _yzgGetBillModel.salary  = self.addForemanModel.tpl.s_tpl;
    _yzgGetBillModel.head_pic = self.addForemanModel.head_pic;
    if (_recordMore) {
        
    _yzgGetBillModel.proname = _workProListModel.all_pro_name;
    _yzgGetBillModel.pid     = [_workProListModel.pro_id integerValue];
        
    }else{
        
    if (_yzgGetBillModel.uid) {
    [self JLGHttpRequest_LastproWithUid:_yzgGetBillModel.uid];
     }
        
    }
    [self JLGHttpRequest_QueryTpl];
    [self loadtableview];

}
#pragma mark - 获取薪资模板
- (void)JLGHttpRequest_QueryTpl{
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querytpl" parameters:@{@"uid":@(self.addForemanModel.uid)} success:^(id responseObject) {
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        [bill_Tpl mj_setKeyValues:responseObject];
        
        self.yzgGetBillModel.set_tpl = bill_Tpl;
        self.yzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;//默认的情况下，工作是长就是模板的时间
        self.yzgGetBillModel.overtime = 0;//移除账单，默认情况下是不加班
//        self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        
        [self getSalary];
        
        [self loadtableview];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
- (CGFloat)getSalary{
    if (_tablview == Timecell.TimeTableview) {//点工
        
    self.yzgGetBillModel.salary = (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.overtime/self.yzgGetBillModel.set_tpl.o_h_tpl;
        
    if (isnan(self.yzgGetBillModel.salary)) {
            self.yzgGetBillModel.salary = 0.f;
    }
    }else if(_tablview == Packcell.packTableview){//包工
        self.yzgGetBillModel.salary = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;
    }else if (_tablview == browcell.BrowTableview)
    {
//        self.yzgGetBillModel.salary = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;

    
    }else if (_tablview == billCell.BillTableview)
    {
    
    
    }
    
    return self.yzgGetBillModel.salary;
}

//选择时间
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath{
  
    
   self.yzgGetBillModel.date = [self getWeekDaysString:date];
    [self loadtableview];
   }
-(void)loadtableview{
    
    if (_tablview == Timecell.TimeTableview) {
        Timecell.yzgGetBillModel = self.yzgGetBillModel;
        
    }else if (_tablview == Packcell.packTableview)
    {
        Packcell.yzgGetBillModel = self.yzgGetBillModel;
        
    }else if(_tablview == browcell.BrowTableview){
        
        browcell.yzgGetBillModel = self.yzgGetBillModel;
        
    }else{
    
        billCell.yzgGetBillModel = self.yzgGetBillModel;
    }

}
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy-MM-dd"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    NSDate *curDate = [NSDate dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    self.calendar.year = [NSString stringWithFormat:@"%@", @(curDate.components.year)];
    self.calendar.month = [NSString stringWithFormat:@"%@", @(curDate.components.month)];
    self.calendar.day = [NSString stringWithFormat:@"%@", @(curDate.components.day)];
    //如果是今天要显示
    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    
    return dateString;
}
#pragma mark - 获取正常账单
- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)self.yzgGetBillModel.uid] forKey:@"id"];
    [parameters setObject:[self.workProListModel.myself_group isEqualToString:@"1"]?@"1":@"0" forKey:@"my_role_type"];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/getonebilldetail" parameters:parameters success:^(id responseObject) {
        YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
        [yzgGetBillModel mj_setKeyValues:responseObject];
        self.yzgGetBillModel = yzgGetBillModel;
        if (self.yzgGetBillModel.notes_img.count > 0 ) {
            self.imagesArray = [self.yzgGetBillModel.notes_img mutableCopy];
        }
        NSDictionary *proDic = @{@"id":@(yzgGetBillModel.pid),@"name":yzgGetBillModel.proname};
        [self.proNameArray addObject:proDic];
        [self loadtableview];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
-(void)JLGPickerViewSelect:(NSArray *)finishArray
{
    _saveProArr = [[NSMutableArray alloc]initWithArray:finishArray];;
    
    if (finishArray.count) {
        _yzgGetBillModel.proname = finishArray[0][@"name"];
        _yzgGetBillModel.pid     = [finishArray[0][@"id"] intValue];
        [self loadtableview];
//        [_tablview reloadData];
    }
    
    if (finishArray.count) {
        if ([finishArray.lastObject isEqual:@"取消"]) {
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            
            BOOL superViewIsGroup = YES;//上个界面是不是组合界面，YES:是，NO，不是

//            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            onlyAddProVc.superViewIsGroup = YES;
            onlyAddProVc.isCreatTeamEditProName = YES;
            onlyAddProVc.isPopUpVc = YES;

            [self.navigationController pushViewController:onlyAddProVc animated:YES];
            
        }
    }

}

//点击项目编辑按钮跳转页面
-(void)JGJPickViewEditButtonPressed:(NSArray *)dataArray
{
    JGJBillEditProNameViewController *editProNameVC = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillEditProNameViewController"];
    editProNameVC.dataArray = dataArray;
    [self.navigationController pushViewController:editProNameVC animated:YES];
    editProNameVC.modifyThePorjectNameSuccess = ^(NSIndexPath *indexPath, NSString *changedName) {
        
    };
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{

    NSString *accountType;
    if (_tablview == Timecell.TimeTableview) {
        accountType = @"1";
    }else if (_tablview == Packcell.packTableview){
        accountType = @"2";
    }else if(_tablview == browcell.BrowTableview){
        accountType = @"3";
    }else{
        accountType = @"4";
    }
    NSDictionary *paramDic;
        paramDic = @{
                     @"uid":@(uid),
                     @"accounts_type":accountType,
                     @"group_id":_ChatType?self.workProListModel.group_id?:@"":@""
                     };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
#pragma mark -  此处加了一个空判断
        if ([ NSString isEmpty: responseObject[@"pro_name"] ]) {
        self.yzgGetBillModel.proname = self.workProListModel.all_pro_name;
        self.yzgGetBillModel.pid = 0;
        }else{
        if ([responseObject[@"pro_name"] length] < 2 && _ChatType) {
        self.yzgGetBillModel.proname = self.workProListModel.all_pro_name;
        self.yzgGetBillModel.pid = 0;
        }else{
        self.yzgGetBillModel.pid = [responseObject[@"pid"] integerValue];
        self.yzgGetBillModel.proname = responseObject[@"pro_name"];
        }
        }
        [self loadtableview];
        
    }failure:^(NSError *error) {
    }];
}
- (void)saveDataToServer{

    self.parametersDic = [NSMutableDictionary dictionary];
//    if (self.mateWorkitemsItems.id != 0) {
    self.parametersDic[@"id"] =[NSString stringWithFormat:@"%ld",(long)self.addForemanModel.uid];
//    }
//    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
//    if (_ChatType) {
        self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
//    }else{
//        self.parametersDic[@"uid"] = [TYUserDefaults objectForKey:JLGUserUid]?:@"";
//    }
//    self.parametersDic[@"salary"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.set_tpl.s_tpl];
//    self.parametersDic[@"salary"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary]?:@"0";

    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
//    self.parametersDic[@"pro_name"] = self.yzgGetBillModel.proname?:@"";
    if (!self.yzgGetBillModel.voice_length) {
        self.yzgGetBillModel.voice_length = 0;
    }
     self.parametersDic[@"voice_length"] = [NSString stringWithFormat:@"%ld",(long)self.yzgGetBillModel.voice_length ];

//    if ([self.workProListModel.pro_id isEqualToString:@"0"] ||!self.workProListModel.pro_id) {
//        self.parametersDic[@"pid"] = @"";
//    }else{
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
//    }
    //只获取日期
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    if (_tablview == Timecell.TimeTableview) {//点工
        self.parametersDic[@"accounts_type"] = @1;
        self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
        self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
        self.parametersDic[@"salary_tpl"] = @(self.yzgGetBillModel.set_tpl.s_tpl);
        self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.w_h_tpl);
        self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.o_h_tpl);
    }else if(_tablview == Packcell.packTableview){//包工
        self.parametersDic[@"accounts_type"] = @2;
//        self.parametersDic[@"salary"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.quantities *self.yzgGetBillModel.unitprice]?:@"0";
        self.parametersDic[@"quantity"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.quantities];
        self.parametersDic[@"unit_price"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.unitprice];
        self.parametersDic[@"p_s_time"] = self.yzgGetBillModel.start_time?:@"0";
        self.parametersDic[@"p_e_time"] = self.yzgGetBillModel.end_time?:@"0";
        self.parametersDic[@"sub_pro_name"] = self.yzgGetBillModel.sub_proname?:@"";
        self.parametersDic[@"units"] = self.yzgGetBillModel.units?:@"";
    }else if(_tablview == browcell.BrowTableview){//借支
        self.parametersDic[@"accounts_type"] = @3;
        self.parametersDic[@"salary"] = self.yzgGetBillModel.browNum;
    }else if (_tablview == billCell.BillTableview)
    {
        self.parametersDic[@"accounts_type"] = @4;
        self.parametersDic[@"salary"] = self.yzgGetBillModel.totalNum;
    }
    [self ModifyRelase:self.parametersDic dataArray:self.yzgGetBillModel.dataArr dataNameArray:self.yzgGetBillModel.dataNameArr];
}
#pragma mark - 提交数据到服务器，用于子类重写
- (void)ModifyRelase:(NSDictionary *)parametersDic dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray{
    [self.tablview endEditing:YES];
        NSMutableDictionary *parametersDicRelase = [parametersDic mutableCopy];
        [parametersDicRelase removeObjectForKey:@"id"];
    if (_ChatType) {
    [parametersDicRelase setValue:[self.workProListModel.myself_group isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
    [parametersDicRelase setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
    [parametersDicRelase setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }
    
      [self saveLastRecordBill];
    
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlworkday/relase" parameters:parametersDicRelase imagearray:self.imagesArray otherDataArray:[dataArray copy] dataNameArray:[dataNameArray copy] success:^(NSArray *responseObject) {
            [TYLoadingHub hideLoadingView];
            //此处添加新需求
            if (_tablview == Timecell.TimeTableview) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([[dic allKeys] count] > 0) {
                        if ([dic[@"errno"] isEqual:@"20027"]) {
                            _treadid = dic[@"errfield"];
                            if (dic[@"errmsg"]) {
                                
                                [self gotoTransfVcAndTitle:dic[@"errmsg"]];
                                
                            }else{
                                
                                [self gotoTransfVcAndTitle:@""];
                            }
                            
                            return ;
                            
                        }
                    }
                }else{
                    
                }
            }

            
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popTextAlignment = NSTextAlignmentCenter;
            desModel.lineSapcing = 4;
            JGJCusAlertView *alerView = [JGJCusAlertView cusAlertViewShowWithDesModel:desModel];
            alerView.customLeftButtonAlertViewBlock = ^{
                
                TYLog(@"返回上一级");
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            alerView.customRightButtonAlertViewBlock = ^{
                
                YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
                oldBillModel.proname = self.yzgGetBillModel.proname;
                oldBillModel.pid = self.yzgGetBillModel.pid;
                oldBillModel.name = self.yzgGetBillModel.name;
                oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
                self.yzgGetBillModel = [[YZGGetBillModel alloc]init];;
                [self allreload];
                //如果是从聊天进入  则荏苒要默认工头名字
                if (_ChatType) {
                    if (_selectedDate) {
                        self.yzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
                    }else{
                        self.yzgGetBillModel.date =  [self getWeekDaysString:[NSDate date]];
                    }
                    self.yzgGetBillModel.name = _workProListModel.creater_name;
                    self.yzgGetBillModel.uid  = [_workProListModel.creater_uid integerValue];
                    //几多人进入
                    if (_recordMore) {
                        self.yzgGetBillModel.proname = _workProListModel.pro_name;
                        self.yzgGetBillModel.pid  = [_workProListModel.pro_id integerValue];
                        
                    }
                    self.yzgGetBillModel.proname = oldBillModel.proname;
                    self.yzgGetBillModel.pid = oldBillModel.pid;
                    self.yzgGetBillModel.set_tpl = oldBillModel.set_tpl;
                    self.yzgGetBillModel.manhour = oldBillModel.set_tpl.w_h_tpl;
                    self.yzgGetBillModel.overtime = 0;
                    self.yzgGetBillModel.name = oldBillModel.name;
                    self.yzgGetBillModel.salary = oldBillModel.set_tpl.s_tpl;
                    Timecell.yzgGetBillModel = self.yzgGetBillModel;
                    Packcell.yzgGetBillModel = self.yzgGetBillModel;
                    browcell.yzgGetBillModel = self.yzgGetBillModel;
                    billCell.yzgGetBillModel = self.yzgGetBillModel;
                    
                    [self loadtableview];
                    self.yzgGetBillModel.role = self.roleType;
                }else{
                Timecell.yzgGetBillModel = [[YZGGetBillModel alloc]init];
                Packcell.yzgGetBillModel = [[YZGGetBillModel alloc]init];;
                browcell.yzgGetBillModel = [[YZGGetBillModel alloc]init];;
                billCell.yzgGetBillModel = [[YZGGetBillModel alloc]init];
                _fillOutModel = [JGJFilloutNumModel new];
                    if (_recordMore) {
                        self.yzgGetBillModel.proname = oldBillModel.proname;
                        self.yzgGetBillModel.pid = oldBillModel.pid;
//                        self.yzgGetBillModel.set_tpl = oldBillModel.set_tpl;
//                        self.yzgGetBillModel.manhour = oldBillModel.set_tpl.w_h_tpl;
//                        self.yzgGetBillModel.overtime = 0;
//                        self.yzgGetBillModel.salary = oldBillModel.set_tpl.s_tpl;

                        Timecell.yzgGetBillModel = self.yzgGetBillModel;
                        Packcell.yzgGetBillModel = self.yzgGetBillModel;
                        browcell.yzgGetBillModel = self.yzgGetBillModel;
                        billCell.yzgGetBillModel = self.yzgGetBillModel;

                        [self loadtableview];
                    }

                }
            };
            
    
            

        } failure:^(NSError *error) {
//          [TYShowMessage showError:@"服务器错误"];
            [TYLoadingHub hideLoadingView];
        }];
    }
-(void)allreload
{
    if (self.tablview  == Timecell.TimeTableview) {
        Timecell.yzgGetBillModel = _yzgGetBillModel;
    }
    if (self.tablview  == Packcell.packTableview) {
        Packcell.yzgGetBillModel = _yzgGetBillModel;

    }
    if (self.tablview == browcell.BrowTableview) {
        browcell.yzgGetBillModel = _yzgGetBillModel;

    }
#pragma mark - 添加新的工资结算页面
    if (self.tablview == billCell.BillTableview) {
        
        billCell.yzgGetBillModel = _yzgGetBillModel;
    }


}
- (void)holdView{
    
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"PlaceHolderView" owner:self options:nil]firstObject];
    [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    [[[UIApplication sharedApplication]keyWindow]addSubview:view];
    view.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHoldView:)];
    [view addGestureRecognizer:tap];
    [UIView animateWithDuration:.6 animations:^{
        view.alpha = .7;

    }];
}
- (void)tapHoldView:(UITapGestureRecognizer *)guesstrue
{
    [guesstrue.view removeFromSuperview];
}
- (void)JLGDataPickerClickMoredayButton
{
    
    
    if (!self.yzgGetBillModel.set_tpl.w_h_tpl || !self.yzgGetBillModel.set_tpl.o_h_tpl || self.yzgGetBillModel.set_tpl.w_h_tpl < 0) {
        [TYShowMessage showError:@"请先设置工资标准"];
        return;
    }

    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc]init];
    [self.jlgDatePickerView hiddenDatePicker];
    moreDay.JlgGetBillModel =  self.yzgGetBillModel;
    moreDay.Mainrecod = _Mainrecord;
    [self.navigationController pushViewController:moreDay animated:YES];
}
//设置从其他地方选择的时期
-(void)setSelectedDate:(NSDate *)selectedDate
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (selectedDate) {
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [YZGGetBillModel new];
    }
    _yzgGetBillModel.date = [self getWeekDaysString:selectedDate];
    _selectedDate = selectedDate;
        [self allreload];
    }
         });
}
- (void)gotoTransfVcAndTitle:(NSString *)title{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"查看该记账", nil];
//    alert.tag = 1;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];

    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

//        MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:self.yzgGetBillModel];
//        JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
//        workerGetBillVc.markBillType = MarkBillTypeEdit;
//        workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
//        [self.navigationController pushViewController:workerGetBillVc animated:YES];
    
      MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:self.yzgGetBillModel];
    JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
    recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
    [self.navigationController pushViewController:recordBillVC animated:YES];
    
    alertView.delegate = nil;
    alertView = nil;
}
- (MateWorkitemsItems *)TransformModel:(YZGGetBillModel *)wageBestDetailWorkday{
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.overtime = [NSString stringWithFormat:@"%f",wageBestDetailWorkday.overtime];
    mateWorkitemsItem.uid = wageBestDetailWorkday.uid ;
    mateWorkitemsItem.amounts = wageBestDetailWorkday.salary;
//    mateWorkitemsItem.amounts_diff = [wageBestDetailWorkday.modify_marking floatValue];
//    mateWorkitemsItem.modify_marking = [wageBestDetailWorkday.modify_marking floatValue];
    mateWorkitemsItem.manhour = [NSString stringWithFormat:@"%f",wageBestDetailWorkday.manhour ];
    mateWorkitemsItem.name = wageBestDetailWorkday.name;
    mateWorkitemsItem.accounts_type.txt = wageBestDetailWorkday.accounts_type.txt;
    mateWorkitemsItem.accounts_type.code = 1;
    mateWorkitemsItem.overtime = [NSString stringWithFormat:@"%f", wageBestDetailWorkday.overtime];
    mateWorkitemsItem.id =  [_treadid integerValue]?:0;
    mateWorkitemsItem.role = JLGisLeaderBool?1:2;
    return mateWorkitemsItem;
}
#pragma mark - 获取先写的单位
-(void)setFillOutModel:(JGJFilloutNumModel *)fillOutModel
{
    if (fillOutModel.Num &&fillOutModel.priceNum) {
    _fillOutModel = [JGJFilloutNumModel new];
    _fillOutModel = fillOutModel;
    _yzgGetBillModel.quantities = [[NSString stringWithFormat:@"%@",fillOutModel.Num] floatValue];
    _yzgGetBillModel.units = fillOutModel.priceNum;
    _yzgGetBillModel.salary = _yzgGetBillModel.quantities * _yzgGetBillModel.unitprice;
    [self loadtableview];
    }
}
#pragma mark - 点击选择包工单位
-(void)PacketselectUnite
{
    JGJPackNumViewController *changeToVc = (JGJPackNumViewController *)[[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
    changeToVc.filloutmodel = _fillOutModel;
    [self.navigationController pushViewController:changeToVc animated:YES];
}
#pragma mark - 首页进入记账获取薪资模板
-(void)mainGoinGetTPL
{
    NSString *postApi = @"jlworkday/fmlist";
    NSDictionary *parameters = @{@"uid":@(self.yzgGetBillModel.uid)?:@""};
    [JLGHttpRequest_AFN PostWithApi:postApi parameters:parameters success:^(NSArray *responseObject) {
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        bill_Tpl.s_tpl = [responseObject[0][@"tpl"][@"s_tpl"] floatValue];
        bill_Tpl.o_h_tpl = [responseObject[0][@"tpl"][@"o_h_tpl"] floatValue];
        bill_Tpl.w_h_tpl = [responseObject[0][@"tpl"][@"w_h_tpl"] floatValue];
        self.yzgGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.yzgGetBillModel.set_tpl = bill_Tpl;
        self.yzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;
        self.yzgGetBillModel.overtime = 0;
        [self getSalary];
        [self loadtableview];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}
@end
