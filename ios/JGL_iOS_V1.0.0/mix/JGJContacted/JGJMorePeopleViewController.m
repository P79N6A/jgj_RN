//
//  JGJMorePeopleViewController.m
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMorePeopleViewController.h"

#import "JGJNORecordTableViewCell.h"

#import "JGJecordTitleTableViewCell.h"

#import "JGJNormalTableViewCell.h"

#import "JGJworkteamTableViewCell.h"

#import "JGJGetViewFrame.h"

#import "FSCalendar.h"
#import "FDAlertView.h"
#import "NSDate+Extend.h"
#import "YZGGetBillModel.h"
#import "MyCalendarObject.h"

#import "JGJNavView.h"

#import "JGJTeamWorkListViewController.h"

#import "JGJTime.h"

#import "JGrecordWorkTimePickerview.h"

#import "JGJRecordModepickview.h"

#import "YZGMateSalaryTemplateViewController.h"

#import "NSString+Extend.h"

#import "YZGDatePickerView.h"

#import "JGJShowHolderPlaceView.h"

#import "JGJQRecordViewController.h"

#import "JGJChatRootVc.h"

#import "JGJMoreSelectPeopleTableViewCell.h"

#import "JGJMemberSelTypeVc.h"

#import "JGJMorePeopleView.h"

#import "YZGGetIndexRecordViewController.h"

#import "JGJTeamWorkListViewController.h"

#import "JGJMarkBillViewController.h"

#import "JGJWageLevelViewController.h"

#import "JGJContractorTypeChoiceHeaderView.h"
#import "JGJContractorListAttendanceTemplateController.h"
#import "JGJCustomPopView.h"
#import "JGJCustomAlertView.h"

#import "JGJMarkBillRemarkViewController.h"
#import "JGJAddTeamMemberVC.h"
#import "UILabel+GNUtil.h"
#import "JGJMorePeopleRecordTopTimeView.h"
#import "NSDate+Extend.h"

#import "JYSlideSegmentController.h"
static NSString *workTeamID = @"workTeamIndentfer";

static NSString *EditeTimeID = @"EditeTimeIDIndentfer";

static NSString *NoRecordID = @"NorecordIndentfer";

static NSString *RecordID = @"recordIndentfer";

static NSString *const calendarFormat = @"yyyy/MM/dd";

@interface JGJMorePeopleViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

FSCalendarDelegate,

FSCalendarDataSource,

CancelButton,

CancelButtondelegate,

YZGDatePickerViewDelegate,

FSCalendarHeaderDelegate,

JGJAddNameHUBViewDelegate,

FSCalendarDelegateAppearance,

JLGDatePickerViewDelegate,

didselectItemAndpeople,

FDAlertViewDelegate,

JGJMorePeopleViewDelegate,
JGJMarkBillRemarkViewControllerDelegate,
SWTableViewCellDelegate,
JGJAddTeamMemberDelegate,
JGJMorePeopleRecordTopTimeViewDelegate,
JGJContractorTypeChoiceHeaderViewDelegate
>
{
    NSString *now_work_hour_tpl;
    
    NSString *now_overtime_hour_tpl;
    
    NSString *work_hour_tpl;
    
    NSString *overtime_hour_tpl;
    
    NSIndexPath *indexpaths;
    
    NSString *pework_hour_tpl;
    
    NSString *peovertime_hour_tpl;
    
    NSString *pemoneywork_hour_tpl;
    
    JgjRecordMorePeoplelistModel *peoplelistModel;
    
    JGJFirstMorePeoplelistModel *listModel;  //未记工
    
    JGJFirstMorePeoplelistModel *listModelAcount;//已记工
    
    JGJFirstMorePeoplelistModel *Datamodel;//过滤
    
    NSString *_deleteRecordId;
    NSString *_workTime;
    
    NSString *_overTime;
    
    NSString *_MworkTime;
    
    NSString *_MoverTime;
    
    BOOL _canEidte;
    
    BOOL _hadRecord;
    
    JGJMoreSelectPeopleTableViewCell *MoreSelectPeoplecell;
    
    BOOL _contractorAccountType;// 一天几记多人记账类型,NO(包工记考勤)  默认为YES(点工)
    
    JGJMorePeopleMakeType _markType;
    NSString *_remarkTxt;
    NSMutableArray *_remarkImages;
    
    NSString *_isClickJGJRecordModepickviewOrJGrecordWorkTimePickerview;// 当前弹出的时间选择器是JGJRecordModepickview还是JGrecordWorkTimePickerview，用于填写完备注后，区分继续弹出那个pickerView,1表示JGJRecordModepickview,2表示JGrecordWorkTimePickerview
    
    NSString *_currentRecordeTime;// 用于和is_double配合弹窗显示时间问题
    
    BOOL _isScrollDateTimeCell;// 滑动日历 执行滚动计算7天时间差值逻辑
    
    
    NSString *_worker_detailStr;
}
@property (nonatomic ,strong)UIButton *SaveButton;

@property (nonatomic ,strong)NSArray *NorecordArray;

@property (nonatomic ,strong)NSArray *recodArr;

@property (strong, nonatomic) FSCalendar *Weekcalendar;

@property (strong, nonatomic) UIView *Animalcalendar;

@property (strong, nonatomic) UIView *bottomView;

@property (assign, nonatomic) BOOL HadEdite;//用于区别是不是修改

@property (nonatomic, strong) NSCalendar *lunarCalendar;

@property (nonatomic, strong) NSCalendar *holidayLunarCalendar;

@property (nonatomic, strong) JGJNavView * NavView;

@property (nonatomic, strong) JGrecordWorkTimePickerview * workPicker;

@property (nonatomic, strong) JGJRecordModepickview * recordModelPicker;

@property (nonatomic, strong) UIView * PlaceHolderView;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) NSMutableArray * didrecord;

@property (nonatomic, strong) NSMutableArray * money_tpl_array;

@property (nonatomic, strong) NSMutableArray * RerecodArr;//重新选择记账

@property (nonatomic, strong) NSMutableArray * HadRerecodArr;//重新选择记账

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) UIView *TitleView;

@property (nonatomic, strong) UIView *holdView;

@property (nonatomic ,strong) UIButton *ShowButton;

@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;

@property (nonatomic, strong) FSCalendar *currentCalendar;

@property (nonatomic, strong) JGJMorePeopleView *NaviTitleView;

@property (nonatomic, strong) JGJContractorTypeChoiceHeaderView *headerView;// JGJSynBillingModel

@property (nonatomic, strong) NSMutableArray<JGJSynBillingModel *> *synBillModelArray;// 用于删除成员界面 需要把获取到的成员转成 JGJSynBillingModel
@property (strong, nonatomic) NSMutableArray *removeMembers;//移除的成员
@property (nonatomic, strong) JGJRemoveGroupMemberRequestModel *removeGroupMemberRequestModel;
@property (nonatomic, strong) JGJMorePeopleRecordTopTimeView *recordTopTimeSelected;
@end

@implementation JGJMorePeopleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSelfView];
    
}
- (void)loadSelfView
{
    
    _remarkTxt = @"";
    _isClickJGJRecordModepickviewOrJGrecordWorkTimePickerview = @"";
    _remarkImages = [NSMutableArray new];
    [self.view addSubview:self.recordTopTimeSelected];
    [self.view addSubview:self.Weekcalendar];
    [self.view addSubview:self.tableview];
    
    [self.view addSubview:self.bottomView];
    
    [self addoberserve];
    
    [self.view addSubview:self.workPicker];
    
    self.workPicker.delegate = self;
    
    // 工头身份显示记单笔按钮
    if (JLGisLeaderBool || self.isAgentMonitor) {
        
        [self setRecordSinger];
    }
    
    [self.NaviTitleView setproTitle:_isMinGroup?self.recordSelectPro.pro_name?:@"":self.recordSelectPro.pro_name?:@""];
    self.navigationItem.titleView = self.NaviTitleView;
}
- (JGJMorePeopleView *)NaviTitleView
{
    if (!_NaviTitleView) {
        _NaviTitleView = [[JGJMorePeopleView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 170, 45)];
        _NaviTitleView.delegate = self;
    }
    return _NaviTitleView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.AddJump) {
        
        [self getteamaboutOfday:_Weekcalendar.selectedDate?:[NSDate date]];
        
    }
    
    if (self.edietTpl) {
        
        [self editeRecordedBillTpl];
        self.edietTpl = NO;
    }else{
        
        [self dismiss];
        
    }
    
    self.AddJump = NO;
    _hadRecord = NO;
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    
    UIButton* (*func)(id, SEL) = (void *)imp;
    
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(callModalList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}

-(void)addoberserve
{
    _repeatSaveArr =  [NSMutableArray array];
    _didrecord =      [NSMutableArray array];
    _recodArr =       [NSMutableArray array];
    _repeatSaveArr =  [NSMutableArray array];
    _HadRerecodArr =  [NSMutableArray array];
    
}
-(NSMutableArray<JgjRecordMorePeoplelistModel *> *)moreSelectArr
{
    if (!_moreSelectArr) {
        
        _moreSelectArr = [NSMutableArray array];
        
    }
    return _moreSelectArr;
}

-(NSMutableArray *)setTplArr
{
    if (!_setTplArr) {
        _setTplArr = [[NSMutableArray alloc]init];
    }
    return _setTplArr;
}

- (NSMutableArray<JGJSynBillingModel *> *)synBillModelArray {
    
    if (!_synBillModelArray) {
        
        _synBillModelArray = [[NSMutableArray alloc] init];
    }
    return _synBillModelArray;
}

- (NSMutableArray *)removeMembers {
    
    if (!_removeMembers) {
        
        _removeMembers = [[NSMutableArray alloc] init];
    }
    return _removeMembers;
}
- (JGJNavView *)NavView
{
    if (!_NavView) {
        _NavView = [[JGJNavView alloc]initWithFrame:CGRectMake(0, 20, 150, 45)];
        _NavView.timeDate = [NSDate date];
        
    }
    return _NavView;
}

-(UIView *)TitleView
{
    if (!_TitleView) {
        _TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        _TitleView.backgroundColor = [UIColor clearColor];
        [_TitleView addSubview:self.NavView];
    }
    return _TitleView;
}

- (void)setAgency_uid:(NSString *)agency_uid {
    
    _agency_uid = agency_uid;
}

#pragma mark - 记多人界面进来走的第一个接口
-(void)setRecordSelectPro:(JgjRecordlistModel *)recordSelectPro
{
    _recordSelectPro = [[JgjRecordlistModel alloc]init];
    _recordSelectPro = recordSelectPro;
    
    [self updateSelectDate:_Weekcalendar.selectedDate?:[NSDate date]];
    [self.NaviTitleView setproTitle:self.recordSelectPro.pro_name?:@""];
    
}
- (void)getteamaboutOfday:(NSDate *)time{
    
    NSDictionary *prams;
    if (self.isAgentMonitor) {
        
        prams = @{
                  @"group_id":_recordSelectPro.group_id,
                  @"pid":_recordSelectPro.pro_id,
                  @"date":[JGJTime yearAppendMonthanddayfromstamp:time],
                  @"agency_uid":self.agency_uid
                  };
    }else {
        
        prams = @{
                  @"group_id":_recordSelectPro.group_id,
                  @"pid":_recordSelectPro.pro_id,
                  @"date":[JGJTime yearAppendMonthanddayfromstamp:time],
                  };
    }
    
    _currentRecordeTime = [JGJTime newYearAppend_Monthand_dayfromstamp:time];
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/group-members-tpl" parameters:prams success:^(id responseObject) {
        
        NSArray *listModels = [JGJFirstMorePeoplelistModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.synBillModelArray removeAllObjects];
        // 处理 self.synBillModelArray 用于删除成员列表时
        [self.synBillModelArray addObjectsFromArray:[JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject[0][@"list"]]];
        [self.synBillModelArray addObjectsFromArray:[JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject[1][@"list"]]];
        //未记工
        listModel = listModels[0];
        // 处理选中状态
        if (self.moreSelectArr.count != 0) {
            
            for (int i = 0; i < self.moreSelectArr.count; i ++) {
                
                JgjRecordMorePeoplelistModel *selecRecordModel = self.moreSelectArr[i];
                for (int j = 0; j < listModel.list.count; j ++) {
                    
                    JgjRecordMorePeoplelistModel *recordModel = listModel.list[j];
                    if ([selecRecordModel.uid isEqualToString:recordModel.uid]) {
                        
                        [listModel.list replaceObjectAtIndex:j withObject:selecRecordModel];
                    }
                }
                
            }
        }
        
        _HadEdite = NO;
        //已记工
        listModelAcount = listModels[1];
        
        
        // 设置默认类型
        NSInteger defaultSelectedType = [TYUserDefaults integerForKey:JGJRecoredMorePeopleSelectedType];
        // 选择点工考勤
        if (defaultSelectedType == 0) {
            
            if (listModel.last_accounts_type == 1) {
                
                _markType = JGJMorePeopleMakeLittleWorkType;
                
            }else if (listModel.last_accounts_type == 5) {
                
                _markType = JGJMorePeopleMakeAttendanceType;
            }
            
            
        }else {
            
            if (defaultSelectedType == 1) {
                
                _markType = JGJMorePeopleMakeLittleWorkType;
                
            }else if (defaultSelectedType == 5) {
                
                _markType = JGJMorePeopleMakeAttendanceType;
            }
            
        }
        [self.tableview reloadData];
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (JGrecordWorkTimePickerview *)workPicker
{
    if (!_workPicker) {
        
        _workPicker = [[JGrecordWorkTimePickerview alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 340)];
        _workPicker.shouldBoard = YES;
        //        _workPicker.isAddRemarkView = NO;
        _workPicker.workTimeArr = @[@"休息",@"0.5小时",@"1小时",@"1.5小时",@"2小时",@"2.5小时",@"3小时",@"3.5小时",@"4小时",@"4.5小时",@"5小时",@"5.5小时",@"6小时",@"6.5小时",@"7小时",@"7.5小时",@"8小时",@"8.5小时",@"9小时",@"9.5小时",@"10小时",@"10.5小时",@"11小时",@"11.5小时",@"12小时"];
        _workPicker.overTimeArr = @[@"无加班",@"0.5小时",@"1小时",@"1.5小时",@"2小时",@"2.5小时",@"3小时",@"3.5小时",@"4小时",@"4.5小时",@"5小时",@"5.5小时",@"6小时",@"6.5小时",@"7小时",@"7.5小时",@"8小时",@"8.5小时",@"9小时",@"9.5小时",@"10小时",@"10.5小时",@"11小时",@"11.5小时",@"12小时"];
        
        [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%.1f",_jlgGetBillModel.manhour] andover_tpl:[NSString stringWithFormat:@"%.1f",_jlgGetBillModel.overtime] andManTPL:[NSString stringWithFormat:@"%.1f",_jlgGetBillModel.set_tpl.w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%.1f",_jlgGetBillModel.set_tpl.o_h_tpl]];
        
        _workPicker.delegate = self;
    }
    return _workPicker;
}
//取消按钮
-(void)ClickLeftButton
{
    [self dissmissBootmPickerView];
}
-(void)dissmissBootmPickerView
{
    if (self.holdView) {
        [self.holdView removeFromSuperview];
    }
    [UIView animateWithDuration:.3 animations:^{
        self.tableview.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    self.workPicker.transform = CGAffineTransformMakeTranslation(0, 340);
    [UIView animateWithDuration:.5 animations:^{
        [_workPicker setFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 340)];
    }];
    
    
}

#pragma mark - 单个人删除该笔记账
- (void)deleteRecordWorkingModelWithjgjrecordselectedModel:(jgjrecordselectedModel *)recordModel {
    
    _deleteRecordId = recordModel.record_id;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"数据一经删除将无法恢复。\n请谨慎操作哦！" delegate:self buttonTitles:@"取消",@"确认删除", nil];
    alert.isHiddenDeleteBtn = YES;
    [alert setMessageColor:AppFont000000Color fontSize:16];
    
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 ) {
        
        [self batchDelRequestWithRecordId:_deleteRecordId];
    }
    
    alertView.delegate = nil;
    
    alertView = nil;
}

- (void)batchDelRequestWithRecordId:(NSString *)recordId {
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:recordId ? : @"" forKey:@"id"];
    if (self.isAgentMonitor) {
        
        [dic setObject:_recordSelectPro.group_id forKey:@"group_id"];
    }
    
    [TYShowMessage showHUDWithMessage:@""];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"删除成功"];
        [self dissmissBootmPickerView];
        [self getteamaboutOfday:self.Weekcalendar.selectedDate];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}
#pragma mark - 单个人修改确定按钮
- (void)clickrightbutton:(jgjrecordselectedModel *)selectedModel
{
    
    JgjRecordMorePeoplelistModel *recordModel = listModelAcount.list[indexpaths.row - 1];
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    NSString *TimeStamp;
    if (_Weekcalendar.selectedDate) {
        
        TimeStamp = [JGJTime yearAppendMonthanddayfromstamp:_Weekcalendar.selectedDate];
        
    }else{
        
        TimeStamp = [JGJTime yearAppendMonthanddayfromstamp:[NSDate date]];
    }
    NSDictionary *body;
    
    if ([selectedModel.accounts_type isEqualToString:@"1"]) {
        
        NSString *salary = [NSString stringWithFormat:@"%.2f",[selectedModel.normal_work floatValue]/[selectedModel.work_hour_tpl floatValue]*[selectedModel.salary_tpl floatValue] + [selectedModel.overtime floatValue]/[selectedModel.overtime_hour_tpl floatValue]*[selectedModel.salary_tpl floatValue]];
        // 是否是自己创建的班组
        if (!_isMinGroup) {
            
            body = @{
                     @"accounts_type": @"1",
                     @"name": selectedModel.name,
                     @"uid" : selectedModel.uid,
                     @"record_id":selectedModel.record_id,
                     @"date": TimeStamp,
                     @"salary": salary,
                     @"work_time": _workTime?:@"0",
                     @"over_time": _overTime?:@"0",
                     @"pid": _recordSelectPro.pro_id?:@"",
                     @"pro_name":_recordSelectPro.pro_name?:@"",
                     @"salary_tpl":recordModel.tpl.s_tpl?:@"",
                     @"work_hour_tpl":recordModel.tpl.w_h_tpl?:@"",
                     @"overtime_hour_tpl":recordModel.tpl.o_h_tpl?:@"",
                     @"overtime_salary_tpl":@(recordModel.tpl.o_s_tpl),
                     @"hour_type":@(recordModel.tpl.hour_type)
                     };
            
        }else {
            
            body = @{
                     @"accounts_type": @"1",
                     @"name": selectedModel.name,
                     @"uid" : selectedModel.uid,
                     @"record_id":selectedModel.record_id,
                     @"date": TimeStamp,
                     @"salary": salary,
                     @"work_time": _workTime?:@"0",
                     @"over_time": _overTime?:@"0",
                     @"pid": _recordSelectPro.pro_id?:@"",
                     @"pro_name":_recordSelectPro.pro_name?:@"",
                     @"salary_tpl":recordModel.tpl.s_tpl?:@"",
                     @"work_hour_tpl":recordModel.tpl.w_h_tpl?:@"",
                     @"overtime_hour_tpl":recordModel.tpl.o_h_tpl?:@"",
                     @"overtime_salary_tpl":@(recordModel.tpl.o_s_tpl),
                     @"hour_type":@(recordModel.tpl.hour_type)
                     };
            
        }
        
    }else if ([selectedModel.accounts_type isEqualToString:@"5"]) {// 包工考勤记账对象
        
        if (!_isMinGroup) {
            
            body = @{
                     @"accounts_type":@"5",
                     @"date": TimeStamp,
                     @"uid":selectedModel.uid,
                     @"name":selectedModel.name,
                     @"record_id":selectedModel.record_id,
                     @"work_time": _workTime?:@"0",
                     @"over_time": _overTime?:@"0",
                     @"pid":_recordSelectPro.pro_id?:@"",
                     @"pro_name":_recordSelectPro.pro_name?:@"",
                     @"work_hour_tpl":recordModel.unit_quan_tpl.w_h_tpl,
                     @"overtime_hour_tpl":recordModel.unit_quan_tpl.o_h_tpl,
                     @"salary_tpl":@"0"
                     };
        }else {
            
            body = @{
                     @"accounts_type":@"5",
                     @"date": TimeStamp,
                     @"uid":selectedModel.uid,
                     @"name":selectedModel.name,
                     @"record_id":selectedModel.record_id,
                     @"work_time": _workTime?:@"0",
                     @"over_time": _overTime?:@"0",
                     @"pid":_recordSelectPro.pro_id?:@"",
                     @"pro_name":_recordSelectPro.pro_name?:@"",
                     @"work_hour_tpl":recordModel.unit_quan_tpl.w_h_tpl,
                     @"overtime_hour_tpl":recordModel.unit_quan_tpl.o_h_tpl,
                     @"salary_tpl":@"0",
                     };
        }
        
    }
    
    [selectedArr addObject:body];
    NSDictionary *parames;
    
    // 是否为代班长
    if (self.isAgentMonitor) {
        
        parames = @{
                    @"info":[selectedArr mj_JSONString],
                    @"group_id": _recordSelectPro.group_id,
                    @"agency_uid":self.agency_uid,
                    };
    }else {
        
        parames = @{
                    @"info":[selectedArr mj_JSONString],
                    @"group_id": _recordSelectPro.group_id,
                    };
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/relase" parameters:parames success:^(id responseObject) {
        
        _canEidte = NO;
        indexpaths = nil;
        [TYLoadingHub hideLoadingView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [TYShowMessage showSuccess:@"修改记账成功\n及时对账，避免纠纷！"];
            [self dissmissBootmPickerView];
        });
        _hadRecord = YES;
        
        if (self.moreSelectArr.count) {
            
            [self.moreSelectArr removeAllObjects];
        }
        
        [self getteamaboutOfday:self.Weekcalendar.selectedDate];
        
        // 记账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (JGJMorePeopleRecordTopTimeView *)recordTopTimeSelected {
    
    if (!_recordTopTimeSelected) {
        
        _recordTopTimeSelected = [[JGJMorePeopleRecordTopTimeView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
        _recordTopTimeSelected.topTimeViewDelegate = self;
        _recordTopTimeSelected.backgroundColor = [UIColor whiteColor];
    }
    return _recordTopTimeSelected;
}

- (FSCalendar *)Weekcalendar
{
    if (!_Weekcalendar) {
        
        _lunarCalendar = [[NSCalendar alloc]
                          initWithCalendarIdentifier:
                          NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale
                                 localeWithLocaleIdentifier:@"zh-CN"];
        _holidayLunarCalendar = [NSCalendar currentCalendar];
        _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
        
        _Weekcalendar = [[FSCalendar alloc] initWithFrame: CGRectMake(0, 30, CGRectGetWidth(self.view.frame), height)];
        _Weekcalendar.scope = FSCalendarScopeWeek;
        _Weekcalendar.dataSource = self;
        _Weekcalendar.delegate = self;
        _Weekcalendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
        _Weekcalendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
        _Weekcalendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
        _Weekcalendar.appearance.todayColor = [UIColor redColor];
        _Weekcalendar.appearance.todaySelectionColor = JGJMainColor;
        _Weekcalendar.appearance.selectionColor = TYColorHex(0xf9a00f);
        _Weekcalendar.appearance.titleSelectionColor = JGJMainColor;
        _Weekcalendar.appearance.subtitleSelectionColor = JGJMainColor;
        _Weekcalendar.appearance.selectionColor = AppFontf1f1f1Color;
        _Weekcalendar.appearance.cellShape = FSCalendarCellShapeRectangle;
        _Weekcalendar.appearance.selectionColor = AppFontfdf0f0Color;
        _Weekcalendar.appearance.todaySelectionColor = AppFontfdf0f0Color;
        _Weekcalendar.appearance.todayColor = [UIColor whiteColor];
        _Weekcalendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
        _Weekcalendar.showHeader = NO;
        _Weekcalendar.showTodayNotShowSubImage = YES;
        _Weekcalendar.cc_selectedDate = [NSDate date];
        [_Weekcalendar selectDate:[NSDate date]];
        
        self.recordTopTimeSelected.topShowTime = [NSDate stringFromDate:[NSDate date] format:@"yyyy年MM月"];
        
    }
    return _Weekcalendar;
}



- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    CGSize size = [calendar sizeThatFits:_Weekcalendar.frame.size];
    [self.Weekcalendar setFrame:CGRectMake(0, 30, size.width, size.height)];
    self.tableview.frame = CGRectMake(0, CGRectGetMaxY(_Weekcalendar.frame) + 8, TYGetUIScreenWidth, CGRectGetMinY(_bottomView.frame) - CGRectGetMaxY(_Weekcalendar.frame) - 8);
    [self.view layoutIfNeeded];
}


-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_Weekcalendar.frame) + 8, TYGetUIScreenWidth, CGRectGetMinY(_bottomView.frame) - CGRectGetMaxY(_Weekcalendar.frame) - 8)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.allowsMultipleSelectionDuringEditing = YES;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        
    }
    
    return _tableview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [self loadMarkBillOneDayMorePeopleFromIndexpath:indexPath];
        
    }else if (indexPath.section == 1){
        
        MoreSelectPeoplecell = [self loadSectionTwoMarkBillOneDayMorePeopleFromIndexpath:indexPath];
        
        return MoreSelectPeoplecell;
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            cell = [self loadJGJecordTitleTableViewCellFromIndexpath:indexPath];
            
        }else{
            
            cell = [self loadJGJNORecordTableViewCellFromIndexpath:indexPath];
        }
    }else{
        
        if (indexPath.row ==0) {
            
            cell = [self loadJGJecordTitleTableViewCellFromIndexpath:indexPath];
            
        }else{
            
            cell = [self loadJGJNormalTableViewCellFromIndexpath:indexPath];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (JGJworkteamTableViewCell *)loadMarkBillOneDayMorePeopleFromIndexpath:(NSIndexPath *)indexpath
{
    JGJworkteamTableViewCell *cell = [JGJworkteamTableViewCell cellWithTableView:self.tableview];
    cell.proname = self.recordSelectPro.all_pro_name?:@"";
    cell.manNum = [NSString stringWithFormat:@"%lu",(unsigned long)listModel.list.count];
    
    if (self.isMinGroup) {
        
        cell.rightArrowImage.hidden = YES;
    }
    
    return cell;
}
- (JGJMoreSelectPeopleTableViewCell *)loadSectionTwoMarkBillOneDayMorePeopleFromIndexpath:(NSIndexPath *)indexpath
{
    
    MoreSelectPeoplecell = [[[NSBundle mainBundle]loadNibNamed:@"JGJMoreSelectPeopleTableViewCell" owner:nil options:nil]firstObject];
    MoreSelectPeoplecell.delegate = self;
    MoreSelectPeoplecell.listModel = listModel;
    if (_markType == JGJMorePeopleMakeLittleWorkType) {
        
        MoreSelectPeoplecell.isLittleWorkOrContractorAttendance = YES;
    }else {
        
        MoreSelectPeoplecell.isLittleWorkOrContractorAttendance = NO;
    }
    
    MoreSelectPeoplecell.manNum = [NSString stringWithFormat:@"%lu",(unsigned long)listModel.list.count];
    MoreSelectPeoplecell.selectionStyle = UITableViewCellSelectionStyleNone;
    MoreSelectPeoplecell.currentRecordeTimeStr = _currentRecordeTime;
    return MoreSelectPeoplecell;
    
}

- (JGJecordTitleTableViewCell *)loadJGJecordTitleTableViewCellFromIndexpath:(NSIndexPath *)indexPath
{
    JGJecordTitleTableViewCell *cell = [JGJecordTitleTableViewCell cellWithTableView:self.tableview];
    
    return cell;
}

- (JGJNORecordTableViewCell *)loadJGJNORecordTableViewCellFromIndexpath:(NSIndexPath *)indexpath
{
    JGJNORecordTableViewCell *cell = [JGJNORecordTableViewCell cellWithTableView:self.tableview];
    
    if (listModel.list.count) {
        cell.modelList  = listModel.list[indexpath.row-1];
        cell.newdepartlable.hidden = YES;
    }else{
        
        cell.newdepartlable.hidden = NO;
    }
    
    return cell;
}

-(JGJNormalTableViewCell *)loadJGJNormalTableViewCellFromIndexpath:(NSIndexPath *)indexPath
{
    JGJNormalTableViewCell *cell = [JGJNormalTableViewCell cellWithTableView:self.tableview];
    
    cell.listModel = listModelAcount.list[indexPath.row - 1];
    cell.delegate = self;
    cell.tag = indexPath.row + 100;
    
    JgjRecordMorePeoplelistModel *listModel = [[JgjRecordMorePeoplelistModel alloc] init];
    listModel = listModelAcount.list[indexPath.row - 1];
    if (listModel.msg.msg_text.length != 0) {
        
        
        cell.rightUtilityButtons = @[];
        
    }else {
        
        cell.rightUtilityButtons = [self handleStickBtnArray];
    }
    
    return cell;
}

- (NSArray *)handleStickBtnArray {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:AppFontd7252cColor title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewCellDelegate
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(JGJNormalTableViewCell *)cell {
    
    return YES;
}


#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}


- (void)swipeableTableViewCell:(JGJNormalTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    if (index == 0) {
        
        JgjRecordMorePeoplelistModel *listModel = listModelAcount.list[cell.tag - 101];
        _deleteRecordId = listModel.record_id;
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"数据一经删除将无法恢复。\n请谨慎操作哦！" delegate:self buttonTitles:@"取消",@"确认删除", nil];
        alert.isHiddenDeleteBtn = YES;
        [alert setMessageColor:AppFont000000Color fontSize:16];
        
        [alert show];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
        
    }else if (section == 1){
        
        return 1;
        
    }else if(section == 2){
        
        return 0;
    }else if (section == 3){
        if (listModelAcount.list.count<=0) {
            
            return 0;
        }
        
        return listModelAcount.list.count + 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2&&indexPath.row == 0) {
        return 30;
    }
    else if (indexPath.section == 0){
        
        // 调整未记工的工人view高度，3.0v版本 cc加
        return 0;
    }else if (indexPath.section == 1)
    {
        if (listModel.list.count<=0) {
            
            return 90 + 45;
            
        }else{
            
            //每行的个数
            int rowNum = TYGetUIScreenWidth / 60;
            
            NSInteger lineNumber = (listModel.list.count + 2) / rowNum;
            NSInteger leftNum = (listModel.list.count + 2) % rowNum;
            
            if (leftNum > 0) {
                
                lineNumber  = lineNumber + 1;
            }
            return lineNumber * 80.5 + 45 + 10;
            
        }
        
    }
    return 50;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    indexpaths = indexPath;
    if (indexPath.section == 1&&indexPath.row == 0) {
        
    }else if (indexPath.section == 0){
        
    }else if ((indexPath.section == 2&&indexPath.row != 0)){
        //跳转设置工资模板界面
        if([[listModel.list[indexPath.row - 1] is_salary] intValue] != 1) {
            
            [self editeMoneylable];
            
        }else{
            
            [self showPicker];
            JgjRecordMorePeoplelistModel *jgjRecordMorePeoplelistModel = listModel.list[indexPath.row - 1];
            if ([jgjRecordMorePeoplelistModel.tpl.s_tpl intValue] <= 0) {
                
                _workPicker.detailStr = [NSString stringWithFormat:@"%@小时(上班)/%@小时(加班)",jgjRecordMorePeoplelistModel.tpl.w_h_tpl,jgjRecordMorePeoplelistModel.tpl.o_h_tpl];
                
            }else{
                
                _workPicker.detailStr = [NSString stringWithFormat:@"工资标准%@元/%@小时(上班)/%@小时(加班)",jgjRecordMorePeoplelistModel.tpl.s_tpl,jgjRecordMorePeoplelistModel.tpl.w_h_tpl,jgjRecordMorePeoplelistModel.tpl.o_h_tpl];
            }
            //设置姓名和电话号码
            _workPicker.nameAndPhone = [NSString stringWithFormat:@"%@(%@)",jgjRecordMorePeoplelistModel.name,jgjRecordMorePeoplelistModel.telph];
            //设置显示样式
            [self reloadPickerView];
            
            [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%@",jgjRecordMorePeoplelistModel.choose_tpl.choose_w_h_tpl] andover_tpl:[NSString stringWithFormat:@"%@",jgjRecordMorePeoplelistModel.choose_tpl.choose_o_h_tpl] andManTPL:[NSString stringWithFormat:@"%@",jgjRecordMorePeoplelistModel.tpl.w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%@",jgjRecordMorePeoplelistModel.tpl.o_h_tpl]];
            
        }
        [_didrecord addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.section == 3 && indexPath.row != 0){
        
        //这样写是为了让记过帐的不能操作
        JgjRecordMorePeoplelistModel *recorderModel = listModelAcount.list[indexPath.row - 1];
        
        _workTime = recorderModel.choose_tpl.choose_w_h_tpl?:@"0";
        _overTime = recorderModel.choose_tpl.choose_o_h_tpl?:@"0";
        if (recorderModel.msg.msg_text.length != 0) {
            
            return;
        }
        
        if (recorderModel.notes_text.length != 0) {
            
            _workPicker.remarkView.remarkedTxt = recorderModel.notes_text;
        }
        
        NSString *manTplStr;
        NSString *overTplStr;
        
        // 点工记账
        if ([recorderModel.msg.accounts_type isEqualToString:@"1"]) {
            
            
            manTplStr = [NSString stringWithFormat:@"%@小时(上班)",recorderModel.tpl.w_h_tpl];
            overTplStr = [NSString stringWithFormat:@"%@小时(加班)",recorderModel.tpl.o_h_tpl];
            _workPicker.detailType.text = @"工资标准";
            
            // 工资标准显示方式 0 - 按工天算加班显示b方式 1 - 按小时算加班显示方式
            if (recorderModel.tpl.hour_type == 0) {
                
                if ([recorderModel.tpl.w_h_tpl floatValue] > 0) {
                    
                    if ([recorderModel.tpl.s_tpl floatValue] <= 0) {
                        
                        NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.w_h_tpl floatValue]];
                        
                        w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                        
                        NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.o_h_tpl floatValue]];
                        o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                        
                        _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                        _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                        
                    }else{
                        
                        NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f",[recorderModel.tpl.w_h_tpl floatValue]];
                        
                        w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                        
                        NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.o_h_tpl floatValue]];
                        
                        o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                        
                        NSString *o_s_tpl = @"";
                        if ([recorderModel.tpl.o_h_tpl floatValue] > 0) {
                            
                            o_s_tpl = [NSString stringWithFormat:@"%.2f",[NSString roundFloat:[recorderModel.tpl.s_tpl floatValue] / [recorderModel.tpl.o_h_tpl floatValue]]];
                            
                        }
                        
                        _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                        _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                    }
                }
                
                
            }else {
                
                if ([recorderModel.tpl.w_h_tpl floatValue] > 0) {
                    
                    NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.w_h_tpl floatValue]];
                    
                    w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_s_tpl = [NSString stringWithFormat:@"%.2f",recorderModel.tpl.o_s_tpl];
                    
                    _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                    
                    _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                    
                }
                
            }
            
            [self showPickerWithRecordModel:recorderModel];
            
            _workPicker.theDetailLableTexTAlignmentNeedLeft = NO;
            _workPicker.detailType.attributedText = [NSString setLabelImageWithLabel:_workPicker.detailType type:@"1"];
            
        }else if ([recorderModel.msg.accounts_type isEqualToString:@"5"]) {// 包工考勤
            
            [self showPicker];
            
            manTplStr = [NSString stringWithFormat:@"%@小时(上班)",recorderModel.unit_quan_tpl.w_h_tpl];
            overTplStr = [NSString stringWithFormat:@"%@小时(加班)",recorderModel.unit_quan_tpl.o_h_tpl];
            _workPicker.detailType.text = @"考勤模板";
            _workPicker.detailStr = [NSString stringWithFormat:@"%@/%@",manTplStr?:@"",overTplStr?:@""];
            _workPicker.theDetailLableTexTAlignmentNeedLeft = NO;
            _workPicker.detailType.attributedText = [NSString setLabelImageWithLabel:_workPicker.detailType type:@"5"];
            
            
        }
        
        [self reloadPickerView];
        
        _workPicker.recorderPeopleModel = recorderModel;
        _workPicker.nameAndPhone = [NSString stringWithFormat:@"%@(%@)",recorderModel.name, recorderModel.telph];
        
        if ([recorderModel.msg.accounts_type isEqualToString:@"1"]) {
            
            //设置日期显示样式
            [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_w_h_tpl] andover_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_o_h_tpl] andManTPL:[NSString stringWithFormat:@"%@",recorderModel.tpl.w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%@",recorderModel.tpl. o_h_tpl]];
            
        }else if ([recorderModel.msg.accounts_type isEqualToString:@"5"]) {
            
            //设置日期显示样式
            [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_w_h_tpl] andover_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_o_h_tpl] andManTPL:[NSString stringWithFormat:@"%@",recorderModel.unit_quan_tpl.w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%@",recorderModel.unit_quan_tpl.o_h_tpl]];
        }
        
        [_repeatSaveArr addObject:indexPath];
    }
}


- (void)reloadPickerView {
    
    NSMutableArray *workArr = [[NSMutableArray alloc]init];
    NSMutableArray *overArr = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 48; i++) {
        NSString *workStr;
        NSString *overStr;
        if (i == 0) {
            workStr = @"休息";
            overStr = @"无加班";
        }else{
            if ((i*0.5) == (int)(i *0.5)) {
                workStr = [NSString stringWithFormat:@"%.0f小时", (i * 0.5 )];
                overStr = [NSString stringWithFormat:@"%.0f小时", (i * 0.5 )];
            }else{
                workStr = [NSString stringWithFormat:@"%.1f小时", (i * 0.5 )];
                overStr = [NSString stringWithFormat:@"%.1f小时", (i * 0.5 )];
            }
            
        }
        [workArr addObject:workStr];
        [overArr addObject:overStr];
        
    }
    _workPicker.workTimeArr = [[NSMutableArray alloc]initWithArray:workArr];
    _workPicker.overTimeArr = [[NSMutableArray alloc]initWithArray:overArr];
}
#pragma mark - 上面没记账的人记账
- (void)showworkTimePicker{
    
    _recordModelPicker = [[JGJRecordModepickview alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    _recordModelPicker.delegate = self;
    
    
    if (![NSString isEmpty:_remarkTxt]) {
        
        if (_remarkImages.count) {
            
            if (_remarkTxt.length > 10) {
                
                _recordModelPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@... [图片]",[_remarkTxt substringToIndex:10]];
            }else {
                
                _recordModelPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@ [图片]",_remarkTxt];
            }
            
            
        }else {
            
            _recordModelPicker.remarkView.remarkedTxt = _remarkTxt;
        }
    }else if([NSString isEmpty:_remarkTxt] && _remarkImages.count != 0) {
        
        _recordModelPicker.remarkView.remarkedTxt = @"[图片]";
    }
    
    
    [_recordModelPicker showPicker];
    
    [_recordModelPicker SetTitleAndTitleText:[JGJTime yearAppend_Monthand_dayfromstamp:self.Weekcalendar.selectedDate?:[NSDate date] ]];
    
    [_recordModelPicker setReminLableAndNum:[NSString stringWithFormat:@"%lu",(unsigned long)_moreSelectArr.count?:0]];
    
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView *contractorType = [[UIView alloc] init];
        contractorType.backgroundColor = [UIColor whiteColor];
        
        contractorType.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = AppFontdbdbdbColor;
        [contractorType addSubview:topLine];
        topLine.sd_layout.leftSpaceToView(contractorType, 0).topSpaceToView(contractorType, 0).rightSpaceToView(contractorType, 0).heightIs(0.5);
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = AppFontdbdbdbColor;
        [contractorType addSubview:bottomLine];
        bottomLine.sd_layout.leftSpaceToView(contractorType, 0).rightSpaceToView(contractorType, 0).bottomSpaceToView(contractorType, 0).heightIs(0.5);
        
        // 加header
        [contractorType addSubview:self.headerView];
        _headerView.sd_layout.leftSpaceToView(contractorType, 50).topSpaceToView(contractorType, 15).rightSpaceToView(contractorType, 50).heightIs(35);
        
        // 加提示
        UILabel *remindLabel = [[UILabel alloc] init];
        remindLabel.text = @"如果是小工等，需要确定每天的固定工资，请去点工为他记工";
        remindLabel.textColor = AppFontEB4E4EColor;
        remindLabel.font = FONT(11);
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [contractorType addSubview:remindLabel];
        remindLabel.sd_layout.leftSpaceToView(contractorType, 15).rightSpaceToView(contractorType,15).topSpaceToView(_headerView, 10).heightIs(10);
        
        // 点工考勤
        if (_markType == JGJMorePeopleMakeLittleWorkType) {
            
            remindLabel.hidden = YES;
            _headerView.selType = JGJRecordSelLeftBtnType;
            
        }else {
            
            _headerView.selType = JGJRecordSelRightBtnType;
            remindLabel.hidden = NO;
        }
        return contractorType;
        
        
    }else if (section == 3) {
        
        UIView *custumView = [UIView new];
        custumView = [[UIView alloc] init];
        
        custumView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        UILabel *labelTitle = [[UILabel alloc] init];
        
        custumView.backgroundColor = AppFontf1f1f1Color;
        
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.font = [UIFont systemFontOfSize:15];
        labelTitle.textColor = AppFont999999Color;
        labelTitle.numberOfLines = 0;
        if (listModelAcount.list.count == 0) {
            
            labelTitle.text = [NSString stringWithFormat:@"已记工工人(%lu人)",(unsigned long)listModelAcount.list.count]?:@"0";
            labelTitle.frame = CGRectMake(15,5,300,20);
            
        }else {
            
            labelTitle.text = [NSString stringWithFormat:@"已记工工人(%lu人)\n如需对工人记第2笔，请点击右上角“记单笔”为他记工",(unsigned long)listModelAcount.list.count]?:@"0";
            labelTitle.frame = CGRectMake(15,5,300,40);
        }
        
        labelTitle.textColor = AppFont333333Color;
        [labelTitle markLineTextWithLeftTextAlignment:@"如需对工人记第2笔，请点击右上角“记单笔”为他记工" withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:AppFontEB4E4EColor lineSpace:5];
        [custumView addSubview:labelTitle];
        
        
        return custumView;
    }
    return 0;
}

#pragma mark - JGJContractorTypeChoiceHeaderViewDelegate
- (void)contractorHeaderSelectedWithType:(NSInteger)tag {
    
    // 选择点工
    if (tag == 0) {
        
        _markType = JGJMorePeopleMakeLittleWorkType;
        [TYUserDefaults setInteger:1 forKey:JGJRecoredMorePeopleSelectedType];
        
    }else {// 选择包工考勤
        
        _markType = JGJMorePeopleMakeAttendanceType;
        [TYUserDefaults setInteger:5 forKey:JGJRecoredMorePeopleSelectedType];
        
    }
    
    [self.tableview reloadData];
}

- (JGJContractorTypeChoiceHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[JGJContractorTypeChoiceHeaderView alloc] init];
        _headerView.btTileArr = @[@"点工",@"包工记工天"];
        _headerView.selType = JGJRecordSelRightBtnType;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIButton *)ShowButton {
    
    if (!_ShowButton) {
        _ShowButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth-70, 10, 60, 20)];
        [_ShowButton setTitle:@"收拢" forState:UIControlStateNormal];
        [_ShowButton setTitle:@"展开" forState:UIControlStateSelected];
        _ShowButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ShowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_ShowButton addTarget:self action:@selector(showRecordPeople:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ShowButton;
}

- (void)showRecordPeople:(UIButton *)sender {
    
    if ([(UIButton *)sender.currentTitle isEqual:@"收拢"]) {
        [(UIButton *)sender setTitle:@"展开" forState:UIControlStateNormal];
        
    }
    else {
        [(UIButton *)sender setTitle:@"收拢" forState:UIControlStateNormal];
        
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<_recodArr.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:3];
        [arr addObject:indexPath];
    }
    [_tableview reloadData];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 0;
    }else if (section == 1) {
        
        // 点工考勤
        if (_markType == JGJMorePeopleMakeLittleWorkType) {
            
            return 60;
        }else {
            
            return 80;
        }
    }
    else if (section == 3){
        
        if (listModelAcount.list.count == 0) {
            
            return 30.0;
        }else {
            
            return 50.0;
        }
        
    }
    return 30.0;
}

-(UIButton *)SaveButton
{
    if (!_SaveButton) {
        _SaveButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, TYGetUIScreenWidth-20, 45)];
        
        _SaveButton.backgroundColor = AppFontEB4E4EColor;
        
        [_SaveButton setTitle:@"记工时" forState:UIControlStateNormal];
        
        [_SaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _SaveButton.layer.masksToBounds = YES;
        
        _SaveButton.layer.cornerRadius = JGJCornerRadius;
        
        
        [_SaveButton addTarget:self action:@selector(showNormalworkTimePicker) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _SaveButton;
    
}
- (void)saveButtonCloseUserInterface
{
    _SaveButton.backgroundColor = AppFontf18215Color;
    
    
    [_SaveButton setTitle:@"请选择要记工的工人" forState:UIControlStateNormal];
    
    [_SaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _SaveButton.userInteractionEnabled = NO;
    
}

- (void)saveButtonOpenInterface
{
    _SaveButton.backgroundColor = AppFontEB4E4EColor;
    
    [_SaveButton setTitle:@"记工时" forState:UIControlStateNormal];
    
    _SaveButton.userInteractionEnabled = YES;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        
        
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 129 + iphoneXheightbar, TYGetUIScreenWidth, 65)];
        
        _bottomView.backgroundColor = AppFontfafafaColor;
        
        [_bottomView addSubview:self.SaveButton];
        
        [_bottomView addSubview:lable];
    }
    
    return _bottomView;
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([[NSDate stringFromDate:calendar.today format:calendarFormat] isEqualToString:[NSDate stringFromDate:date format:calendarFormat]]) {//今天
        
        color = AppFontEB4E4EColor;
        
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){//范围内
        
        color = TYColorHex(0xafafaf);
        
    }else{
        
        color = AppFont333333Color;
    }
    
    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    
    UIColor *color;
    
    if ([[NSDate stringFromDate:calendar.today format:calendarFormat] isEqualToString:[NSDate stringFromDate:date format:calendarFormat]]) {//今天
        
        color = AppFontEB4E4EColor;
        
    }
    else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        
        color = TYColorHex(0xc7c7c7);
        
    }
    else{
        
        color = AppFontccccccColor;
        
    }
    
    return color;
}


- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSDateComponents *holidayComponents = [_holidayLunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    //判断是否是节日
    NSString *holiday = [MyCalendarObject getGregorianHolidayWith:holidayComponents];
    
    if (![holiday isEqualToString:@""]) {
        return holiday;
    }else{
        NSDateComponents *lunarComponents = [_lunarCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
        NSDictionary *holidayDic = [MyCalendarObject getChineseCalendarWith:lunarComponents];
        if (![holidayDic[@"holiday"] isEqualToString:@""]) {
            return holidayDic[@"holiday"];
        }else{
            return holidayDic[@"day"];
        }
    }
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [calendar dateWithYear:2014 month:1 day:1];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    
    // 3.3.3 是否是代班长记账，选择时间
    if (self.isAgentMonitor) {
        
        // 判断有无起始时间
        if (![NSString isEmpty:self.WorkCircleProListModel.agency_group_user.start_time]) {
            
            // 判断选择的时间是否小于起始时间
            NSDate *startDate = [NSDate dateFromString:self.WorkCircleProListModel.agency_group_user.start_time withDateFormat:@"yyyy-MM-dd"];
            NSComparisonResult result = [date compare:startDate];
            // 表示选择的时间 date小于 代班长起始的代班时间
            if (result == NSOrderedAscending) {
                
                NSString *startTime = [self.WorkCircleProListModel.agency_group_user.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                // 如果end_time不为空 则提示 区间短时间
                if (![NSString isEmpty:self.WorkCircleProListModel.agency_group_user.end_time]) {
                    
                    NSString *endTime = [self.WorkCircleProListModel.agency_group_user.end_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长只能在%@~%@时间段内记账",startTime,endTime]];
                }else {
                    
                    [TYShowMessage showPlaint:[NSString stringWithFormat:@"代班长不能记录%@以前的账",startTime]];
                    
                }
                
                return NO;
            }
        }
    }
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    [_remarkImages removeAllObjects];
    if (self.moreSelectArr.count) {
        
        [self.moreSelectArr removeAllObjects];
    }
    
    if (!listModel.list.count) {
        
        indexpaths = nil;
    }
    self.currentCalendar = calendar;
    _NavView.timeDate = calendar.selectedDate;
    [self updateSelectDate:date];
}

- (void)calendarCurrentPageWillChange:(FSCalendar *)calendar {
    
    _isScrollDateTimeCell = YES;
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    // v3.4.1需求 往前翻日历 时间自动选择到一周前的今天对应的数据 往后翻 如果加7天时间大于今天时间 则显示今天时间 否则显示加7天后的时间
    if ([calendar.currentPage.timestamp doubleValue] < [calendar.selectedDate.timestamp doubleValue]) {// 往前翻
        
        NSString *timeIntervalStr = calendar.selectedDate.timestamp;// 获取日历选择时间的时间戳
        NSTimeInterval selectedTimeInterval = [timeIntervalStr doubleValue];
        selectedTimeInterval = selectedTimeInterval - 24 * 60 * 60 * 7;
        if (_isScrollDateTimeCell) {
            
            [self updateSelectDate:[NSDate timeSpStringToNSDate:[NSString stringWithFormat:@"%lf",selectedTimeInterval]]];
        }
        
        
    }else {
        
        NSTimeInterval sevenDayAfterTime = [calendar.selectedDate.timestamp doubleValue] + 24 * 60 * 60 * 7;
        NSString *nowDateStr = [NSDate date].timestamp;
        
        NSInteger differenceTimeIntervalPage = sevenDayAfterTime - [nowDateStr doubleValue];// 把7天后的时间与今天时间相减 大于0 则选择今天 小于0 则选择7天后的时间
        if (differenceTimeIntervalPage > 0) {
            
            [self updateSelectDate:[NSDate date]];
            
        }else {
            
            NSTimeInterval selectedTimeInterval = [calendar.selectedDate.timestamp doubleValue] + 24 * 60 * 60 * 7;
            if (_isScrollDateTimeCell) {
                
                [self updateSelectDate:[NSDate timeSpStringToNSDate:[NSString stringWithFormat:@"%lf",selectedTimeInterval]]];
            }
            
        }
        
    }
    
    _isScrollDateTimeCell = NO;
}

//选择个人期选择的时间
- (void)pickerViewleft:(NSString *)norTime overTime:(NSString *)overtime
{
    _canEidte = YES;
    _HadRerecodArr = [NSMutableArray array];
    if ([norTime containsString:@"个工"]) {
        norTime = [norTime substringToIndex:norTime.length - 5];
    }
    if ([overtime containsString:@"个工"]) {
        overtime = [overtime substringToIndex:overtime.length - 5];
        
    }
    if (!norTime ||[norTime isEqualToString:@"休息"]) {
        norTime = @"0小时";
    }
    if (!overtime || [overtime isEqualToString:@"无加班"]) {
        overtime = @"0小时";
    }
    if (indexpaths.section == 1) {
        
        JgjRecordMorePeoplelistModel *model = [[JgjRecordMorePeoplelistModel alloc]init];
        model = listModel.list[indexpaths.row];
        model.work_time = norTime;
        model.over_time = overtime;
        listModel.list[indexpaths.row] = model;
        
        
    }else if(indexpaths.section == 3){
        
        JgjRecordMorePeoplelistModel *model = [[JgjRecordMorePeoplelistModel alloc]init];
        model = listModelAcount.list[indexpaths.row -1];
        model.work_time = norTime;
        model.over_time = overtime;
        listModelAcount.list[indexpaths.row -1] = model;
        
        if (norTime.length > 2) {
            
            _workTime = [norTime substringToIndex:norTime.length - 2];
        }else {
            
            _workTime = norTime;
        }
        
        if (overtime.length > 2) {
            
            _overTime = [overtime substringToIndex:overtime.length - 2];
        }else {
            
            _overTime = overtime;
        }
        
        _HadEdite = YES;
        
        
    }
    
}
//批量时间模板选择返回 section == 1
-(void)selectpickerViewleft:(NSString *)norTime overTime:(NSString *)overtime
{
    _canEidte = YES;
    _workTime = norTime;
    _overTime  = overtime;
    if(indexpaths.section != 3) {
        
        for (int i = 0; i < listModel.list.count; i ++) {
            JgjRecordMorePeoplelistModel *model = [[JgjRecordMorePeoplelistModel alloc]init];
            model = listModel.list[i];
            model.work_time = norTime;
            model.over_time = overtime;
            listModel.list[i] = model;
        }
    }else if(indexpaths.section == 3){
        
        for (int i = 0; i < listModelAcount.list.count; i ++) {
            JgjRecordMorePeoplelistModel *model = [[JgjRecordMorePeoplelistModel alloc]init];
            model = listModelAcount.list[i];
            model.work_time = norTime;
            model.over_time = overtime;
            listModelAcount.list[i] = model;
        }
    }
}

-(void)clickrightbuttontoModel:(jgjrecordselectedModel *)selectedModel
{
    //批量修改
    if (selectedModel.ClickBtn) {
        
        [self saveRequestAPI];
        
    }
    
    if (!_workTime&&!_overTime) {
        for (int i = 0; i < listModel.list.count; i ++) {
            JgjRecordMorePeoplelistModel *model = [[JgjRecordMorePeoplelistModel alloc]init];
            model = listModel.list[i];
            model.work_time = @"8小时";
            model.over_time = @"0小时";
            listModel.list[i] = model;
        }
        
    }
    if (indexpaths.section == 1 && listModel.list.count) {
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
        [_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - 添加记工备注
- (void)clickRecordRemark {
    
    [self.recordModelPicker dismissview];
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    
    YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
    yzgGetBillModel.notes_txt = _remarkTxt;
    otherInfoVc.yzgGetBillModel = yzgGetBillModel;
    otherInfoVc.imagesArray = _remarkImages;
    
    otherInfoVc.markBillRemarkDelegate = self;
    [self.navigationController pushViewController:otherInfoVc animated:YES];
}

#pragma mark - 记多人选择备注回调，JGJMarkBillRemarkViewControllerDelegate
- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    NSLog(@"images = %@\nremarkText = %@",images,remarkText);
    _remarkImages = images;
    _remarkTxt = remarkText;
    [_recordModelPicker setWorkTimeselected:_workTime ? :@"" andOverTime:_overTime ? :@""];
    
    if (![NSString isEmpty:_remarkTxt]) {
        
        if (_remarkImages.count) {
            
            if (_remarkTxt.length > 10) {
                
                _recordModelPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@... [图片]",[_remarkTxt substringToIndex:10]];
            }else {
                
                _recordModelPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@ [图片]",_remarkTxt];
            }
            
            
        }else {
            
            if (_remarkTxt.length > 10) {
                
                _recordModelPicker.remarkView.remarkedTxt = [NSString stringWithFormat:@"%@...",[_remarkTxt substringToIndex:10]];
                
            }else {
                
                _recordModelPicker.remarkView.remarkedTxt = _remarkTxt;
            }
        }
    }else if([NSString isEmpty:_remarkTxt] && _remarkImages.count != 0) {
        
        _recordModelPicker.remarkView.remarkedTxt = @"[图片]";
    }
    
    [_recordModelPicker showPicker];
    
}

-(UIView *)PlaceHolderView {
    if (!_PlaceHolderView) {
        _PlaceHolderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _PlaceHolderView.backgroundColor = [UIColor grayColor];
        
    }
    return _PlaceHolderView;
}

//点击单人修改工资模板
-(void)editeMoneylable
{
    if (_holdView) {
        
        [_holdView removeFromSuperview];
        _holdView = nil;
    }
    
    JgjRecordMorePeoplelistModel *recordModel = listModelAcount.list[indexpaths.row - 1];
    if (!_jlgGetBillModel) {
        
        _jlgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    
    _jlgGetBillModel.role = JLGisLeaderBool?2:1;
    
    // 点工薪资模板修改
    if ([recordModel.msg.accounts_type isEqualToString:@"1"]) {
        
        //新增
        _jlgGetBillModel.set_tpl.s_tpl = [recordModel.tpl.s_tpl floatValue];
        _jlgGetBillModel.set_tpl.w_h_tpl = [recordModel.tpl.w_h_tpl floatValue];
        _jlgGetBillModel.set_tpl.o_h_tpl = [recordModel.tpl.o_h_tpl floatValue];
        _jlgGetBillModel.set_tpl.o_s_tpl = recordModel.tpl.hour_type == 0 ? 0.0 : recordModel.tpl.o_s_tpl;;
        _jlgGetBillModel.set_tpl.hour_type = recordModel.tpl.hour_type;
        _jlgGetBillModel.name = recordModel.name;
        _jlgGetBillModel.phone_num = recordModel.telph;
        _jlgGetBillModel.uid = [recordModel.uid integerValue];
        
        
        JGJWageLevelViewController *WageLevelVc = [[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
        WageLevelVc.isAgentMonitor = self.isAgentMonitor;
        WageLevelVc.yzgGetBillModel = _jlgGetBillModel;
        [self.navigationController pushViewController:WageLevelVc animated:YES];
        
    }else if ([recordModel.msg.accounts_type isEqualToString:@"5"]) {// 包工考勤模板修改
        
        JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
        _jlgGetBillModel = [[YZGGetBillModel alloc] init];
        GetBill_UnitQuanTpl *unitTpl = [[GetBill_UnitQuanTpl alloc] init];
        unitTpl.w_h_tpl = [recordModel.unit_quan_tpl.w_h_tpl floatValue];
        unitTpl.o_h_tpl = [recordModel.unit_quan_tpl.o_h_tpl floatValue];
        
        _jlgGetBillModel.unit_quan_tpl = unitTpl;
        _jlgGetBillModel.name = recordModel.name;
        _jlgGetBillModel.uid = [recordModel.uid integerValue];
        templateVC.yzgGetBillModel = _jlgGetBillModel;
        templateVC.targVC = self;
        [self.navigationController pushViewController:templateVC animated:YES];
        
        // 设置考勤模板回调
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
            
            
            recordModel.unit_quan_tpl.w_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
            recordModel.unit_quan_tpl.o_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            [strongSelf -> listModelAcount.list replaceObjectAtIndex:indexpaths.row - 1 withObject:recordModel];
            
            [weakSelf.tableview reloadData];
            
            
        };
    }
    
}

#pragma mark - 已记列表，点击cell弹出的时间选择器 CancelButton
- (void)clickWorkTimePickerviewRemarkTxtWithJgjRecordMorePeoplelistModel:(JgjRecordMorePeoplelistModel *)recorderPeopleModel {
    
    
}

-(void)dismiss{
    if (_workPicker.frame.origin.y != 0) {
        
        [UIView animateWithDuration:0 animations:^{
            self.tableview.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        self.workPicker.transform = CGAffineTransformMakeTranslation(0, 340);
        [UIView animateWithDuration:0 animations:^{
            [_workPicker setFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 340)];
        }];
    }
}
-(void)callModalList
{
    
    if (_hadRecord ) {
        
        //                [self.navigationController popViewControllerAnimated:YES];
        if (self.navigationController.viewControllers.count < 5  || _isMinGroup ||
            [self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[JGJChatRootVc class]]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            UIViewController *viewCtrol = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 5];
            [self.navigationController popToViewController:viewCtrol animated:YES];
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)showNormalworkTimePicker
{
    if (_moreSelectArr.count == 0) {
        
        [TYShowMessage showPlaint:@"请点击工人头像选择要记工的工人"];
        return;
    }
    
    
    [self showworkTimePicker];
    
    _workTime = @"8";
    _overTime = @"0";
    
    
    [_recordModelPicker setWorkTimeselected:_workTime andOverTime:@"0"];
}


#pragma mark - 批量保存
- (void)saveRequestAPI{
    
    // 已选择的工人
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    NSDictionary *body;
    NSString *TimeStamp;
    if (_Weekcalendar.selectedDate) {
        
        TimeStamp = [JGJTime yearAppendMonthanddayfromstamp:_Weekcalendar.selectedDate];
        
    }else{
        
        TimeStamp = [JGJTime yearAppendMonthanddayfromstamp:[NSDate date]];
    }
    // 遍历所有选择的对象
    for (int i = 0; i < _moreSelectArr.count; i ++) {
        
        JgjRecordMorePeoplelistModel *recordModel = _moreSelectArr[i];
        
        // 点工记账对象
        if (recordModel.makeType == JGJMorePeopleMakeLittleWorkType) {
            
            NSString *salary = [NSString stringWithFormat:@"%.2f",[_workTime floatValue]/[recordModel.tpl.w_h_tpl floatValue]*[recordModel.tpl.s_tpl floatValue] + [_overTime floatValue]/[recordModel.tpl.o_h_tpl floatValue]*[recordModel.tpl.s_tpl floatValue]];
            // 是否是自己创建的班组
            if (!_isMinGroup) {
                
                body = @{
                         @"accounts_type": @"1",
                         @"name": recordModel.name,
                         @"uid" : recordModel.uid,
                         @"date": TimeStamp,
                         @"salary": salary,
                         @"work_time": _workTime?:@"0",
                         @"over_time": _overTime?:@"0",
                         @"pid": _recordSelectPro.pro_id?:@"",
                         @"pro_name":_recordSelectPro.pro_name?:@"",
                         @"salary_tpl":recordModel.tpl.s_tpl,
                         @"work_hour_tpl":recordModel.tpl.w_h_tpl,
                         @"overtime_hour_tpl":recordModel.tpl.o_h_tpl,
                         @"overtime_salary_tpl":@(recordModel.tpl.o_s_tpl),
                         @"hour_type":@(recordModel.tpl.hour_type)
                         };
                
            }else {
                
                body = @{
                         @"accounts_type": @"1",
                         @"name": recordModel.name,
                         @"uid" : recordModel.uid,
                         @"date": TimeStamp,
                         @"salary": salary,
                         @"work_time": _workTime?:@"0",
                         @"over_time": _overTime?:@"0",
                         @"pid": _recordSelectPro.pro_id?:@"",
                         @"pro_name":_recordSelectPro.pro_name?:@"",
                         @"salary_tpl":recordModel.tpl.s_tpl,
                         @"work_hour_tpl":recordModel.tpl.w_h_tpl,
                         @"overtime_hour_tpl":recordModel.tpl.o_h_tpl,
                         @"overtime_salary_tpl":@(recordModel.tpl.o_s_tpl),
                         @"hour_type":@(recordModel.tpl.hour_type)
                         };
                
            }
            
            [selectedArr addObject:body];
        }else if (recordModel.makeType == JGJMorePeopleMakeAttendanceType) {// 包工考勤记账对象
            
            if (!_isMinGroup) {
                
                body = @{
                         @"accounts_type":@"5",
                         @"date": TimeStamp,
                         @"uid":recordModel.uid,
                         @"name":recordModel.name,
                         @"work_time":_workTime?:@"0",
                         @"over_time":_overTime?:@"0",
                         @"pid":_recordSelectPro.pro_id?:@"",
                         @"pro_name":_recordSelectPro.pro_name?:@"",
                         @"work_hour_tpl":recordModel.unit_quan_tpl.w_h_tpl,
                         @"overtime_hour_tpl":recordModel.unit_quan_tpl.o_h_tpl,
                         @"salary_tpl":@(0)
                         };
            }else {
                
                body = @{
                         @"accounts_type":@"5",
                         @"date": TimeStamp,
                         @"uid":recordModel.uid,
                         @"name":recordModel.name,
                         @"work_time":_workTime?:@"0",
                         @"over_time":_overTime?:@"0",
                         @"pid":_recordSelectPro.pro_id?:@"",
                         @"pro_name":_recordSelectPro.pro_name?:@"",
                         @"work_hour_tpl":recordModel.unit_quan_tpl.w_h_tpl,
                         @"overtime_hour_tpl":recordModel.unit_quan_tpl.o_h_tpl,
                         @"salary_tpl":@(0),
                         };
            }
            [selectedArr addObject:body];
            
        }
    }
    
    NSDictionary *parames;
    // 是否为代班长
    if (self.isAgentMonitor) {
        
        parames = @{
                    @"info":[selectedArr mj_JSONString],
                    @"group_id": _recordSelectPro.group_id,
                    @"agency_uid":self.agency_uid,
                    @"text": _remarkTxt
                    };
    }else {
        
        parames = @{
                    @"info":[selectedArr mj_JSONString],
                    @"group_id": _recordSelectPro.group_id,
                    @"text": _remarkTxt
                    };
    }
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parames imagearray:_remarkImages otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        _canEidte = NO;
        indexpaths = nil;
        [TYLoadingHub hideLoadingView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [TYShowMessage showSuccess:@"记账成功\n永不丢失，随时查看!"];
            _remarkTxt = @"";
            [_remarkImages removeAllObjects];
        });
        _hadRecord = YES;
        
        if (self.moreSelectArr.count) {
            
            [self.moreSelectArr removeAllObjects];
        }
        
        [self getteamaboutOfday:self.Weekcalendar.selectedDate];
        
        // 记账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}
//name
- (NSString *)appendPamrametersFromArray:(NSArray *)array withKey:(NSString *)key
{
    NSString *KeyValue = [NSString string];
    if ([key isEqualToString:@"name"]) {
        for (int index = 0 ;index < array.count; index ++) {
            if (KeyValue.length) {
                
                if ([[(JgjRecordMorePeoplelistModel *)array[index] name] length]) {
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[(JgjRecordMorePeoplelistModel *)array[index] name]?:@""];
                }else{
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @""];
                }
            }else{
                
                KeyValue = [(JgjRecordMorePeoplelistModel *)array[index] name];
                if (KeyValue == nil ||KeyValue == NULL) {
                    [TYShowMessage showError:@"有成员信息不完整"];
                    KeyValue = @"";
                }
            }
        }
    }else if ([key isEqualToString:@"uid"]){
        
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                
                
                if ([[(JgjRecordMorePeoplelistModel *)array[index] uid] length]) {
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[(JgjRecordMorePeoplelistModel *)array[index] uid]?:@""];
                    
                }else{
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @""];
                }
                
            }else{
                
                
                KeyValue = [(JgjRecordMorePeoplelistModel *)array[index] uid];
                
            }
            
        }
        
    }else if ([key isEqualToString:@"salary"]){
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                if ([[[(JgjRecordMorePeoplelistModel *)array[index] tpl] s_tpl] length]) {
                    JgjRecordMorePeoplelistModel *model = (JgjRecordMorePeoplelistModel *)array[index];
                    //添加这两行是为了修改已记工是的记账
                    if (!model.work_time && model.choose_tpl.choose_w_h_tpl) {
                        
                        model.work_time = model.choose_tpl.choose_w_h_tpl;
                    }
                    
                    if (!model.over_time && model.choose_tpl.choose_o_h_tpl) {
                        
                        model.over_time = model.choose_tpl.choose_o_h_tpl;
                        
                    }
                    
                    if ([model.tpl.w_h_tpl isEqualToString:@"0"] &&![model.tpl.o_h_tpl isEqualToString:@"0"] ) {
                        KeyValue = [NSString stringWithFormat:@"%@,%.2f",KeyValue,
                                    [model.over_time floatValue]/[model.tpl.o_h_tpl floatValue]*[model.tpl.s_tpl floatValue]];
                    }else if ([model.tpl.o_h_tpl isEqualToString:@"0"] && ![model.tpl.w_h_tpl isEqualToString:@"0"]){
                        
                        KeyValue = [NSString stringWithFormat:@"%@,%.2f",KeyValue,
                                    [model.work_time floatValue]/[model.tpl.w_h_tpl floatValue]*[model.tpl.s_tpl floatValue]];
                    }else if([model.tpl.o_h_tpl isEqualToString:@"0"] && [model.tpl.w_h_tpl isEqualToString:@"0"])
                    {
                        KeyValue = [NSString stringWithFormat:@"%@,%.2f",KeyValue,
                                    0.00];
                    }else{
                        KeyValue = [NSString stringWithFormat:@"%@,%.2f",KeyValue,
                                    [model.work_time floatValue]/[model.tpl.w_h_tpl floatValue]*[model.tpl.s_tpl floatValue] +
                                    [model.over_time floatValue]/[model.tpl.o_h_tpl floatValue]*[model.tpl.s_tpl floatValue]];
                    }
                }else{
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @""];
                }
            }else{
                
                JgjRecordMorePeoplelistModel *model = (JgjRecordMorePeoplelistModel *)array[index];
                if (!model.work_time && model.choose_tpl.choose_w_h_tpl) {
                    model.work_time = model.choose_tpl.choose_w_h_tpl;
                }
                if (!model.over_time && model.choose_tpl.choose_o_h_tpl) {
                    model.over_time = model.choose_tpl.choose_o_h_tpl;
                }
                
                if ([model.tpl.w_h_tpl isEqualToString:@"0"] &&![model.tpl.o_h_tpl isEqualToString:@"0"] ) {
                    
                    KeyValue = [NSString stringWithFormat:@"%.2f",
                                [model.over_time floatValue]/[model.tpl.o_h_tpl floatValue]*[model.tpl.s_tpl floatValue] ];;
                }else
                    if ([model.tpl.o_h_tpl isEqualToString:@"0"] && ![model.tpl.w_h_tpl isEqualToString:@"0"]) {
                        
                        KeyValue = [NSString stringWithFormat:@"%.2f",
                                    [model.work_time floatValue]/[model.tpl.w_h_tpl floatValue]*[model.tpl.s_tpl floatValue]];
                    }else if([model.tpl.o_h_tpl isEqualToString:@"0"] && [model.tpl.w_h_tpl isEqualToString:@"0"])
                    {
                        KeyValue = [NSString stringWithFormat:@"%.2f",
                                    0.00];;
                    }else{
                        
                        KeyValue = [NSString stringWithFormat:@"%.2f",
                                    [model.work_time floatValue]/[model.tpl.w_h_tpl floatValue]*[model.tpl.s_tpl floatValue] +  [model.over_time floatValue]/[model.tpl.o_h_tpl floatValue]*[model.tpl.s_tpl floatValue] ];;
                    }
            }
            
        }
        
    }else if ([key isEqualToString:@"work_time"]){
        
        
        for (int index = 0 ;index < array.count; index ++) {
            if (KeyValue.length) {
                
                if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time ]length]) {
                    
                    if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"小时"]&&[[(JgjRecordMorePeoplelistModel *)array[index]work_time] containsString:@"个工"]) {
                        
                        
                        NSString *workTime = [[(JgjRecordMorePeoplelistModel *)array[index] work_time] substringWithRange:NSMakeRange(0, [[(JgjRecordMorePeoplelistModel *)array[index] work_time]length]-7)];
                        
                        KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,workTime];
                        
                    }else if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"小时"] &&![[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"个工"]) {
                        
                        if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"休息"]) {
                            
                            KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,@"0"];
                            
                        }else{
                            
                            if ([KeyValue containsString:@"小时"]) {
                                
                                KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[[(JgjRecordMorePeoplelistModel *)array[index] work_time] substringToIndex:[[(JgjRecordMorePeoplelistModel *)array[index] work_time] length] - 2]];
                                
                            }else{
                                
                                KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[(JgjRecordMorePeoplelistModel *)array[index] work_time]];
                                
                            }
                            
                        }
                        
                    }else{
                        
                        if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"休息"]) {
                            
                            KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,@"0"];
                            
                        }else{
                            
                            KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[(JgjRecordMorePeoplelistModel *)array[index] work_time]];
                        }
                        
                    }
                    
                }else{
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,@"0"];
                    
                }
                
            }else{
                
                if ([[(JgjRecordMorePeoplelistModel *)array[index] work_time] containsString:@"休息"]) {
                    
                    KeyValue = @"0";
                    
                }else{
                    if ([KeyValue containsString:@"小时"] ) {
                        KeyValue = [[(JgjRecordMorePeoplelistModel *)array[index] work_time] substringFromIndex:[[(JgjRecordMorePeoplelistModel *)array[index] work_time] length]-2];
                    }else{
                        KeyValue = [(JgjRecordMorePeoplelistModel *)array[index] work_time];
                    }
                }
                
                
            }
        }
    }else if ([key isEqualToString:@"over_time"]){
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                
                if ([[(JgjRecordMorePeoplelistModel *)array[index] over_time] length]) {
                    if ([[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"无加班"]) {
                        KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,@"0"];
                        
                    }else{
                        if ([[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"小时"]&&[[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"个工"]) {
                            NSString *workTime = [[(JgjRecordMorePeoplelistModel *)array[index] over_time] substringWithRange:NSMakeRange(0, [[(JgjRecordMorePeoplelistModel *)array[index] over_time]length]-7)];
                            KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,workTime];
                            
                        }else
                            
                            if ([[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"无加班"]) {
                                KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,@"0"];
                                
                            }else{
                                KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[[(JgjRecordMorePeoplelistModel *)array[index] over_time] substringToIndex:[[(JgjRecordMorePeoplelistModel *)array[index] over_time] length]-2]];
                            }
                        
                    }
                    
                }else{
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @"0"];
                }
                
            }else{
                if ([[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"无加班"]) {
                    KeyValue =@"0";
                    
                }else{
                    
                    if ([KeyValue containsString:@"小时"]||[[(JgjRecordMorePeoplelistModel *)array[index] over_time] containsString:@"小时"]) {
                        KeyValue = [[(JgjRecordMorePeoplelistModel *)array[index] over_time] substringFromIndex:[[(JgjRecordMorePeoplelistModel *)array[index] over_time] length]-2];
                    }else{
                        KeyValue = [(JgjRecordMorePeoplelistModel *)array[index] over_time];
                    }
                }
            }
        }
    }else if ([key isEqualToString:@"salary_tpl"]){
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                if ([[[(JgjRecordMorePeoplelistModel *)array[index] tpl] s_tpl] length]) {
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[[(JgjRecordMorePeoplelistModel *)array[index] tpl] s_tpl]];
                }else{
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @"0"];
                }
                
            }else{
                
                
                
                KeyValue = [[(JgjRecordMorePeoplelistModel *)array[index] tpl]s_tpl];
                
                if ([[[(JgjRecordMorePeoplelistModel *)array[index] tpl] s_tpl] intValue] == 0) {
                    KeyValue = @"0";
                }
                
            }
        }
    }else if ([key isEqualToString:@"work_hour_tpl"]){
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                if ([[[(JgjRecordMorePeoplelistModel *)array[index] tpl] w_h_tpl] length]) {
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[[(JgjRecordMorePeoplelistModel *)array[index] tpl] w_h_tpl]];
                }else{
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @""];
                }
                
            }else{
                
                KeyValue = [[(JgjRecordMorePeoplelistModel *)array[index] tpl] w_h_tpl];
                
            }
        }
    }else if ([key isEqualToString:@"overtime_hour_tpl"]){
        for (int index = 0 ;index < array.count; index ++) {
            
            if (KeyValue.length) {
                if ([[[(JgjRecordMorePeoplelistModel *)array[index] tpl] o_h_tpl] length]) {
                    
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,[[(JgjRecordMorePeoplelistModel *)array[index] tpl] o_h_tpl]];
                }else{
                    KeyValue = [NSString stringWithFormat:@"%@,%@",KeyValue,
                                @""];
                }
            }else{
                
                KeyValue = [[(JgjRecordMorePeoplelistModel *)array[index] tpl] o_h_tpl];
                if ([KeyValue isEqualToString:@"无加班"]) {
                    KeyValue = @"0";
                }
            }
        }
    }
    return KeyValue;
}


-(NSString *)listModelArray:(NSArray *)arr andkey:(NSString *)key
{
    
    NSString *keyvale;
    
    for (int index = 0; index < arr.count; index++) {
        
        JgjRecordMorePeoplelistModel *model = (JgjRecordMorePeoplelistModel *)arr[index];
        NSString *time;
        if ([key isEqualToString:@"work_time"]) {
            
            if ([NSString isEmpty: model.work_time ]) {
                
                time = @"8";
                
            }else{
                
                if ([model.work_time floatValue] <= 0) {
                    
                    time = @"0";
                    
                }else{
                    
                    time = model.work_time;
                    
                }
            }
            //            time = model.work_time?:@"8";
            
        }else{
            
            time = model.over_time?:@"0";
            
        }
        
        if (!time) {
            
            if (model.tpl) {
                
                if ([key isEqualToString:@"work_time"]) {
                    
                    if (model.choose_tpl.choose_w_h_tpl) {
                        
                        time = model.choose_tpl.choose_w_h_tpl;
                        
                    }else{
                        
                        time = model.tpl.w_h_tpl;
                    }
                    
                }else{
                    
                    if (model.choose_tpl.choose_o_h_tpl) {
                        
                        time = model.choose_tpl.choose_o_h_tpl;
                        
                    }else{
                        
                        time = model.tpl.o_h_tpl;
                        
                    }
                    
                }
                
            }
            
            
        }else{
            
            
            if ([time containsString:@"小时"]) {
                
                if ([key isEqualToString:@"work_time"]) {
                    
                    time = [model.work_time substringToIndex:model.work_time.length - 2];
                    
                }else{
                    
                    time = [model.over_time substringToIndex:model.over_time.length - 2];
                }
                
                
            }else{
                
                if ([key isEqualToString:@"work_time"]) {
                    
                    if ([model.work_time isEqualToString:@"休息"]) {
                        
                        time = @"0";
                        
                    }else{
                        
                        if ([NSString isEmpty:time]) {
                            time = model.work_time;
                        }
                    }
                    
                }else{
                    
                    time = model.over_time;
                }
            }
        }
        
        
        if (keyvale.length) {
            
            keyvale = [NSString stringWithFormat:@"%@,%@",keyvale,time];
            
        }else{
            
            keyvale = time;
        }
    }
    return keyvale;
}


#pragma mark - 选择完时间以后
- (void)YZGDataPickerSelect:(NSDate *)date{
    
    [_Weekcalendar disChangeMonthDyDate:date];
    
}
- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}
- (void)showPicker {
    
    if (self.holdView) {
        
        [self.holdView removeFromSuperview];
        self.holdView = nil;
    }
    
    CGFloat iPhoneXY = (TYIST_IPHONE_X || IS_IPHONE_X_Later) ?  34 : 0;
    [UIView animateWithDuration:.3 animations:^{
        
        [_workPicker setFrame:CGRectMake(0, TYGetUIScreenHeight - 340 - iPhoneXY, TYGetUIScreenWidth, 340)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:.5 animations:^{
        
        self.tableview.transform = CGAffineTransformMakeTranslation(0, -200);
        
    } completion:^(BOOL finished) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.holdView];
        
    }];
    
    
}

- (void)showPickerWithRecordModel:(JgjRecordMorePeoplelistModel *)recordModel {
    
    CGFloat textHeight = [NSString stringWithContentSize:CGSizeMake(CGRectGetWidth(_workPicker.detailInfoView.frame) - 15 - 100 - 10 - 9, CGFLOAT_MAX) content:_worker_detailStr font:12].height + 15;
    
    textHeight = textHeight > 30 ? textHeight : 0;
    
    if (self.holdView) {
        
        [self.holdView removeFromSuperview];
        self.holdView = nil;
    }
    
    _holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 276 - ((TYIST_IPHONE_X || IS_IPHONE_X_Later) ?  10 : 0) - textHeight)];
    _holdView.backgroundColor = [UIColor darkGrayColor];
    _holdView.alpha = 0.5;
    UITapGestureRecognizer *guestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissHoldView)];
    [_holdView addGestureRecognizer:guestrue];
    
    CGFloat iPhoneXY = (TYIST_IPHONE_X || IS_IPHONE_X_Later) ?  34 : 0;
    [UIView animateWithDuration:.3 animations:^{
        
        [_workPicker setFrame:CGRectMake(0, TYGetUIScreenHeight - 340 - iPhoneXY - textHeight, TYGetUIScreenWidth, 340 + textHeight)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:.5 animations:^{
        
        self.tableview.transform = CGAffineTransformMakeTranslation(0, -200);
        
    } completion:^(BOOL finished) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.holdView];
        
    }];
    
}

- (UIView *)holdView {
    
    if (!_holdView) {
        
        CGFloat iPhoneXY = (TYIST_IPHONE_X || IS_IPHONE_X_Later) ?  10 : 0;
        _holdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 276 - iPhoneXY)];
        _holdView.backgroundColor = [UIColor darkGrayColor];
        _holdView.alpha = 0.5;
        UITapGestureRecognizer *guestrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissHoldView)];
        [_holdView addGestureRecognizer:guestrue];
        
    }
    return _holdView;
    
}
-(void)dismissHoldView
{
    
    [self dissmissBootmPickerView];
    
    
}

#pragma mark - 记单笔
-(void)setRecordSinger
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"记单笔" style:UIBarButtonItemStylePlain target:self action:@selector(singerRecod)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
-(void)singerRecod
{
    //没有名字
    UIView *jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    if (jgjAddNameHUBView) {
        return;
    }
    
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.selectedDate = self.Weekcalendar.selectedDate;
    slideSegmentVC.markBillMore = YES;
    
    // 当前身份是否为代班长
    if (self.isAgentMonitor) {
        
        slideSegmentVC.isAgentMonitor = YES;
        slideSegmentVC.agency_uid = self.agency_uid;
        slideSegmentVC.workProListModel = self.WorkCircleProListModel;
        
    }else {
        
        JGJMyWorkCircleProListModel *model = [JGJMyWorkCircleProListModel new];
        model.pro_id = self.recordSelectPro.pro_id;
        model.pro_name = self.recordSelectPro.pro_name;
        model.group_name = self.recordSelectPro.group_name;
        model.all_pro_name = self.recordSelectPro.all_pro_name;
        model.group_id = self.recordSelectPro.group_id;
        slideSegmentVC.workProListModel = model;
        
    }
    
    slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
    slideSegmentVC.title = @"记工记账";
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
    
    JGJMarkBillViewController *markBillVC = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
    
    markBillVC.selectedDate = self.Weekcalendar.selectedDate;
    markBillVC.roleType = 2;
    markBillVC.markBillMore = YES;
    
    // 当前身份是否为代班长
    if (self.isAgentMonitor) {
        
        markBillVC.isAgentMonitor = YES;
        markBillVC.agency_uid = self.agency_uid;
        markBillVC.workProListModel = self.WorkCircleProListModel;
        
    }else {
        
        JGJMyWorkCircleProListModel *model = [JGJMyWorkCircleProListModel new];
        model.pro_id = self.recordSelectPro.pro_id;
        model.pro_name = self.recordSelectPro.pro_name;
        model.group_name = self.recordSelectPro.group_name;
        model.all_pro_name = self.recordSelectPro.all_pro_name;
        model.group_id = self.recordSelectPro.group_id;
        markBillVC.workProListModel = model;
        
    }
    
    //    [self.navigationController pushViewController:markBillVC animated:YES];
}


#pragma mark - 薪资模板的回调
-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
    
    if (!_yzgGetBillModel) {
        
        _yzgGetBillModel = [YZGGetBillModel new];
        
    }
    _yzgGetBillModel = yzgGetBillModel;
    
    if (indexpaths.section == 1) {
        
        JgjRecordMorePeoplelistModel *tpl_listmodel = [JgjRecordMorePeoplelistModel new];
        tpl_listmodel = listModel.list[indexpaths.row];
        tpl_listmodel.tpl.w_h_tpl = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.w_h_tpl ];
        tpl_listmodel.tpl.o_h_tpl = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.o_h_tpl ];
        tpl_listmodel.tpl.s_tpl = [NSString stringWithFormat:@"%.2f",yzgGetBillModel.set_tpl.s_tpl ];
        tpl_listmodel.tpl.hour_type = yzgGetBillModel.set_tpl.hour_type;
        tpl_listmodel.tpl.o_s_tpl = yzgGetBillModel.set_tpl.o_s_tpl;
        tpl_listmodel.is_salary = @"1";//这个表示有无薪资模板
        //添加此处是为了修改薪资模板后跟心时间
        if (_workTime) {
            tpl_listmodel.work_time = [NSString stringWithFormat:@"%@",_workTime];
        }else{
            tpl_listmodel.work_time = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.w_h_tpl];
        }
        tpl_listmodel.over_time = _overTime?:@"0小时";
        
        tpl_listmodel.isSelected = YES;
        tpl_listmodel.makeType = _markType;
        
        tpl_listmodel.tpl.w_h_tpl = [tpl_listmodel.tpl.w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        tpl_listmodel.tpl.o_h_tpl = [tpl_listmodel.tpl.o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        tpl_listmodel.work_time = [tpl_listmodel.work_time stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        listModel.list[indexpaths.row] = tpl_listmodel;
        
        if (_markType == JGJMorePeopleMakeLittleWorkType) {
            
            tpl_listmodel.msg.accounts_type = @"1";
            
        }else {
            
            tpl_listmodel.msg.accounts_type = @"5";
        }
        
        [self.moreSelectArr addObject:tpl_listmodel];
        MoreSelectPeoplecell.moreSelectedArr = self.moreSelectArr;
        [self.tableview reloadData];
        
        //这里添加一个本地的对比数据  为了解决设置了薪资模板 但是没有记账  重新掉接口后任然会有感叹号
        [self.setTplArr addObject:tpl_listmodel];
        
        [self saveButtonOpenInterface];
        
    }else if (indexpaths.section == 3){
        
        JgjRecordMorePeoplelistModel *tpl_listmodel = [JgjRecordMorePeoplelistModel new];
        self.edietTpl = YES;
        
        tpl_listmodel = listModelAcount.list[indexpaths.row -1];
        
        tpl_listmodel.tpl.w_h_tpl = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.w_h_tpl];
        tpl_listmodel.tpl.o_h_tpl = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.o_h_tpl];
        tpl_listmodel.tpl.s_tpl = [NSString stringWithFormat:@"%.2f",yzgGetBillModel.set_tpl.s_tpl];
        tpl_listmodel.tpl.hour_type = yzgGetBillModel.set_tpl.hour_type;
        tpl_listmodel.tpl.o_s_tpl = yzgGetBillModel.set_tpl.o_s_tpl;
        tpl_listmodel.is_salary = @"1";
        
        //添加此处是为了修改薪资模板后更新时间
        if (_workTime) {
            
            tpl_listmodel.work_time = [NSString stringWithFormat:@"%@",_workTime ];
            
        }else{
            
            tpl_listmodel.work_time = [NSString stringWithFormat:@"%.1f",yzgGetBillModel.set_tpl.w_h_tpl];
        }
        
        tpl_listmodel.over_time = _overTime?:@"0小时";
        
        tpl_listmodel.tpl.w_h_tpl = [tpl_listmodel.tpl.w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        tpl_listmodel.tpl.o_h_tpl = [tpl_listmodel.tpl.o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
        tpl_listmodel.work_time = [tpl_listmodel.work_time stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        listModelAcount.list[indexpaths.row - 1] = tpl_listmodel;
        
    }
    
}


- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        //显示记更多天按钮
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
        _jlgDatePickerView.isShowMoreDayButton = NO;
    }
    return _jlgDatePickerView;
}


#pragma mark - JLGDatePickerViewDelegate
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath {
    
    [_remarkImages removeAllObjects];
    [self updateSelectDate:date];
    self.currentCalendar = _Weekcalendar;
}

#pragma mark - JGJMorePeopleRecordTopTimeViewDelegate
- (void)recordTopTimeDidSelected {
    
    [self.jlgDatePickerView showDatePicker];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self showDatePickerByIndexPath:indexPath];
}


- (void)updateSelectDate:(NSDate *)selectedDate {
    if (self.moreSelectArr.count != 0) {
        
        [self.moreSelectArr removeAllObjects];
    }
    [self getteamaboutOfday:selectedDate];
    _Weekcalendar.cc_selectedDate = selectedDate;
    [_Weekcalendar selectDate:selectedDate];
    _recordTopTimeSelected.topShowTime = [NSDate stringFromDate:selectedDate format:@"yyyy年MM月"];
}

#pragma mark 选择时间控件弹出
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    //选择的时间，进入pickView处于当前状态
    NSString *selectedDateStr = [NSString stringFromDate:self.currentCalendar.selectedDate?:[NSDate date] withDateFormat:@"yyyyMMdd"];
    NSString *dateFormat = [NSString getNumOlnyByString:selectedDateStr];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    
    self.jlgDatePickerView.datePicker.date = date;
    self.jlgDatePickerView.delegate = self;
    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
    [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
}
//更新选中时间
-(void)reloadSelectedTime
{
    [_Weekcalendar selectDate:[NSDate date]];
}

#pragma mark - 移除
- (void)desSelectWorker:(JgjRecordMorePeoplelistModel *)Model
{
    
    for (int i = 0; i < listModel.list.count; i ++) {
        
        JgjRecordMorePeoplelistModel * peopleModel = listModel.list[i];
        if ([peopleModel.uid isEqualToString:Model.uid]) {
            
            Model.isSelected = NO;
            Model.makeType = _markType;
            if (_markType == JGJMorePeopleMakeLittleWorkType) {
                
                Model.msg.accounts_type = @"1";
            }else {
                
                Model.msg.accounts_type = @"5";
            }
            [listModel.list replaceObjectAtIndex:i withObject:Model];
        }
        
    }
    
    if (self.moreSelectArr.count) {
        
        if ([self.moreSelectArr containsObject:Model]) {
            
            [self.moreSelectArr removeObject:Model];
        }
    }
    
    [self saveButtonOpenInterface];
    
}
#pragma mark - 新版的修改 点击选人或取消选人
- (void)didselectItemAndPeople:(NSMutableArray *)peopleArr {
    
    if (self.moreSelectArr.count) {
        
        for (int index = 0; index < peopleArr.count; index ++) {
            
            JgjRecordMorePeoplelistModel * model = peopleArr[index];
            
            for (int i = 0; i < listModel.list.count; i ++) {
                
                JgjRecordMorePeoplelistModel * peopleModel = listModel.list[i];
                if ([peopleModel.uid isEqualToString:model.uid]) {
                    
                    if (model.isSelected) {
                        
                        model.isSelected = NO;
                        if ([self.moreSelectArr containsObject:model]) {
                            
                            
                            [self.moreSelectArr removeObject:model];
                            
                        }
                    }else {
                        
                        model.isSelected = YES;
                        if (![self.moreSelectArr containsObject:model]) {
                            
                            [self.moreSelectArr addObject:model];
                            
                        }
                    }
                    model.makeType = _markType;
                    if (_markType == JGJMorePeopleMakeLittleWorkType) {
                        
                        model.msg.accounts_type = @"1";
                    }else {
                        
                        model.msg.accounts_type = @"5";
                    }
                    [listModel.list replaceObjectAtIndex:i withObject:model];
                }
            }
            
            [_tableview beginUpdates];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            //            [_tableview reloadData];
            [_tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationNone)];
            [_tableview endUpdates];
        }
    }else{
        
        JgjRecordMorePeoplelistModel * model = peopleArr[0];
        
        for (int i = 0; i < listModel.list.count; i ++) {
            
            JgjRecordMorePeoplelistModel * peopleModel = listModel.list[i];
            if ([peopleModel.uid isEqualToString:model.uid]) {
                
                model.isSelected = YES;
                model.makeType = _markType;
                if (_markType == JGJMorePeopleMakeLittleWorkType) {
                    
                    model.msg.accounts_type = @"1";
                }else {
                    
                    model.msg.accounts_type = @"5";
                }
                [listModel.list replaceObjectAtIndex:i withObject:model];
            }
        }
        _moreSelectArr = [[NSMutableArray alloc] initWithArray:peopleArr];
        
        [_tableview beginUpdates];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
        //            [_tableview reloadData];
        [_tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationNone)];
        [_tableview endUpdates];
        
    }
    
    [self saveButtonOpenInterface];
    
}

#pragma mark - 全选/取消全选
- (void)didSelectedAllWokerWithIsHaveChoiceAllSelected:(BOOL)isSelectedAll {
    
    if (isSelectedAll) {
        
        [self.moreSelectArr removeAllObjects];
        for (int i = 0; i < listModel.list.count; i ++) {
            
            JgjRecordMorePeoplelistModel * peopleModel = listModel.list[i];
            
            if (!peopleModel.is_double) {
                
                if (!peopleModel.isSelected) {
                    
                    peopleModel.isSelected = YES;
                    peopleModel.makeType = _markType;
                }
                if (_markType == JGJMorePeopleMakeLittleWorkType) {
                    
                    peopleModel.msg.accounts_type = @"1";
                }else {
                    
                    peopleModel.msg.accounts_type = @"5";
                }
                
                [listModel.list replaceObjectAtIndex:i withObject:peopleModel];
                [self.moreSelectArr addObject:peopleModel];
            }
            
        }
        
        [_tableview reloadData];
        
    }else {
        
        for (int i = 0; i < listModel.list.count; i ++) {
            
            JgjRecordMorePeoplelistModel * peopleModel = listModel.list[i];
            peopleModel.isSelected = NO;
            peopleModel.makeType = _markType;
            if (_markType == JGJMorePeopleMakeLittleWorkType) {
                
                peopleModel.msg.accounts_type = @"1";
            }else {
                
                peopleModel.msg.accounts_type = @"5";
            }
            [listModel.list replaceObjectAtIndex:i withObject:peopleModel];
            
        }
        [_moreSelectArr removeAllObjects];
        [_tableview reloadData];
    }
}
#pragma mark - 点击从班组删除工人按钮
- (void)didSelectDelWorker {
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *removeMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    removeMemberVC.delegate = self;
    synBillingCommonModel.synBillingTitle = @"删除成员";
    removeMemberVC.groupMemberMangeType = JGJGroupMemberMangeRemoveMemberType;
    removeMemberVC.currentTeamMembers = [self handleGetMembers];
    removeMemberVC.synBillingCommonModel = synBillingCommonModel;
    [self.navigationController pushViewController:removeMemberVC animated:YES];
    
}

- (NSArray *)handleGetMembers{
    
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone != %@",myTel];
    NSArray *contacts = [self.synBillModelArray filteredArrayUsingPredicate:predicate];
    return contacts;
}

- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangePushNotifyType:
        case JGJGroupMemberMangeAddMemberType:
            break;
        case JGJGroupMemberMangeRemoveMemberType:
            [self upLoadRemoveGroupMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeRemoveMemberType];
            break;
        default:
            break;
    }
}

#pragma mark - 移除班组成员
- (void)upLoadRemoveGroupMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    
    self.removeMembers = teamMembers;
    
    NSMutableArray *moreSelectCopyArr = [[NSMutableArray alloc] initWithArray:self.moreSelectArr];
    
    NSMutableArray *uidArr = [NSMutableArray array];
    
    for (JGJSynBillingModel *teamMemberModel in teamMembers) {
        
        teamMemberModel.isSelected = NO;
        
        teamMemberModel.isAddedSyn = NO; //清楚返回的选择和添加状态
        
        if (![NSString isEmpty:teamMemberModel.uid]) {
            
            [uidArr addObject:teamMemberModel.uid];
        }
        
        // 排除已选中的人员中的被移除的账号
        for (int j = 0; j < self.moreSelectArr.count; j ++) {
            
            JgjRecordMorePeoplelistModel *recordModel = self.moreSelectArr[j];
            if ([recordModel.uid isEqualToString:teamMemberModel.uid]) {
                
                [moreSelectCopyArr removeObject:recordModel];
            }
        }
        
    }
    
    self.moreSelectArr = moreSelectCopyArr;
    NSString *uids = [uidArr componentsJoinedByString:@","];
    
    __weak typeof(self) weakSelf = self;
    
    self.removeGroupMemberRequestModel.uid = uids;
    
    NSDictionary *parameters = [self.removeGroupMemberRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelMembersURL parameters:parameters success:^(id responseObject) {
        
        [self getteamaboutOfday:_Weekcalendar.selectedDate?:[NSDate date]];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (JGJRemoveGroupMemberRequestModel *)removeGroupMemberRequestModel {
    
    if (!_removeGroupMemberRequestModel) {
        _removeGroupMemberRequestModel = [[JGJRemoveGroupMemberRequestModel alloc] init];
        _removeGroupMemberRequestModel.ctrl = @"group";
        _removeGroupMemberRequestModel.group_id = self.recordSelectPro.group_id;
        _removeGroupMemberRequestModel.action = @"delMembers";
        _removeGroupMemberRequestModel.class_type = @"group";
    }
    return _removeGroupMemberRequestModel;
}

#pragma mark - 点击添加人到班组
- (void)didSelectAddWorkerToTeam:(NSIndexPath *)selectIndexpath
{
    //传入当前班组id加人使用
    JGJMyWorkCircleProListModel *proListModel = [JGJMyWorkCircleProListModel new];
    
    proListModel.group_id = self.recordSelectPro.group_id;
    
    proListModel.group_name = self.recordSelectPro.pro_name;
    
    proListModel.class_type = @"group";
    
    [self addMemberSelTypeVcWithProListModel:proListModel];
    
}

#pragma mark - 添加成员
- (void)addMemberSelTypeVcWithProListModel: (JGJMyWorkCircleProListModel *)proListModel{
    
    JGJTeamInfoModel *teamInfo = [JGJTeamInfoModel new];
    
    teamInfo.group_id = proListModel.group_id;
    
    teamInfo.class_type = proListModel.class_type;
    
    teamInfo.member_list = [self handleGetMembers].mutableCopy;
    
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    
    commonModel.classType = proListModel.class_type;
    
    commonModel.memberType = JGJProMemberType;
    
    commonModel.teamControllerType = JGJGroupMangerControllerType;
    
    JGJMemberSelTypeVc *selTypeVc = [JGJMemberSelTypeVc new];
    
    selTypeVc.workProListModel = proListModel;
    
    selTypeVc.teamInfo = teamInfo;
    
    selTypeVc.commonModel = commonModel;
    
    selTypeVc.targetVc = self;
    
    //班组添加，项目添加需要
    selTypeVc.contactedAddressBookVcType = JGJGroupMangerAddMembersVcType;
    
    self.AddJump =  YES;
    
    [self.navigationController pushViewController:selTypeVc animated:YES];
    
}

//新版的修改 跳转到薪资模板设置界面
- (void)jumpTplAndIndexpath:(NSIndexPath *)indexpathss {
    
#pragma mark - 后期添加
    __block JgjRecordMorePeoplelistModel *recordModel = (JgjRecordMorePeoplelistModel *)listModel.list[indexpathss.row];
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = self;
    // 工人已选中
    if (recordModel.isSelected) {
        
        if (recordModel.makeType == JGJMorePeopleMakeLittleWorkType) {// 记点工考勤类型
            
            if (indexpathss) {
                NSIndexPath *indexset = [NSIndexPath indexPathForRow:indexpathss.row  inSection:1];
                indexpaths = indexset;
            }
            
            JGJWageLevelViewController *WageLevelVc =[[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
            _jlgGetBillModel = [[YZGGetBillModel alloc] init];
            _jlgGetBillModel.set_tpl.s_tpl   = [recordModel.tpl.s_tpl floatValue];
            _jlgGetBillModel.set_tpl.w_h_tpl = [recordModel.tpl.w_h_tpl floatValue];
            _jlgGetBillModel.set_tpl.o_h_tpl = [recordModel.tpl.o_h_tpl floatValue];
            _jlgGetBillModel.set_tpl.o_s_tpl = recordModel.tpl.hour_type == 0 ? 0.0 : recordModel.tpl.o_s_tpl;;
            _jlgGetBillModel.set_tpl.hour_type = recordModel.tpl.hour_type;
            _jlgGetBillModel.name            = recordModel.name;
            _jlgGetBillModel.phone_num       = recordModel.telph;
            _jlgGetBillModel.uid             = [recordModel.uid integerValue] ;
            WageLevelVc.yzgGetBillModel = _jlgGetBillModel;
            [self.navigationController pushViewController:WageLevelVc animated:YES];
            
        }else if (recordModel.makeType == JGJMorePeopleMakeAttendanceType) {// 记包工考勤类型
            
            JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
            _jlgGetBillModel = [[YZGGetBillModel alloc] init];
            GetBill_UnitQuanTpl *unitTpl = [[GetBill_UnitQuanTpl alloc] init];
            unitTpl.w_h_tpl = [recordModel.unit_quan_tpl.w_h_tpl floatValue];
            unitTpl.o_h_tpl = [recordModel.unit_quan_tpl.o_h_tpl floatValue];
            
            _jlgGetBillModel.unit_quan_tpl = unitTpl;
            _jlgGetBillModel.name = recordModel.name;
            templateVC.yzgGetBillModel = _jlgGetBillModel;
            [self.navigationController pushViewController:templateVC animated:YES];
            
            // 设置考勤模板回调
            templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
                
                recordModel.unit_quan_tpl.w_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                recordModel.unit_quan_tpl.o_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                
                recordModel.makeType = strongSelf -> _markType;
                recordModel.isSelected = YES;
                if (strongSelf -> _markType == JGJMorePeopleMakeLittleWorkType) {
                    
                    recordModel.msg.accounts_type = @"1";
                    
                }else {
                    
                    recordModel.msg.accounts_type = @"5";
                }
                [weakSelf.moreSelectArr addObject:recordModel];
                [strongSelf -> listModel.list replaceObjectAtIndex:indexpathss.row withObject:recordModel];
                
                [weakSelf.tableview reloadData];
            };
        }
        
    }else {// 工人未选中
        
        // 点工类型长按修改薪资模块
        if (_markType == JGJMorePeopleMakeLittleWorkType) {
            
            if (indexpathss) {
                NSIndexPath *indexset = [NSIndexPath indexPathForRow:indexpathss.row  inSection:1];
                indexpaths = indexset;
            }
            
            JGJWageLevelViewController *WageLevelVc =[[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
            _jlgGetBillModel = [[YZGGetBillModel alloc] init];
            _jlgGetBillModel.set_tpl.s_tpl   = [recordModel.tpl.s_tpl floatValue];
            _jlgGetBillModel.set_tpl.w_h_tpl = [recordModel.tpl.w_h_tpl floatValue];
            _jlgGetBillModel.set_tpl.o_h_tpl = [recordModel.tpl.o_h_tpl floatValue];
            _jlgGetBillModel.set_tpl.o_s_tpl = recordModel.tpl.hour_type == 0 ? 0.0 : recordModel.tpl.o_s_tpl;
            _jlgGetBillModel.set_tpl.hour_type = recordModel.tpl.hour_type;
            _jlgGetBillModel.name            = recordModel.name;
            _jlgGetBillModel.phone_num       = recordModel.telph;
            _jlgGetBillModel.uid             = [recordModel.uid integerValue] ;
            WageLevelVc.yzgGetBillModel = _jlgGetBillModel;
            [self.navigationController pushViewController:WageLevelVc animated:YES];
        }
        // 包工类型长按修改包工考勤模块
        else if (_markType == JGJMorePeopleMakeAttendanceType) {
            
            JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
            _jlgGetBillModel = [[YZGGetBillModel alloc] init];
            GetBill_UnitQuanTpl *unitTpl = [[GetBill_UnitQuanTpl alloc] init];
            unitTpl.w_h_tpl = [recordModel.unit_quan_tpl.w_h_tpl floatValue];
            unitTpl.o_h_tpl = [recordModel.unit_quan_tpl.o_h_tpl floatValue];
            
            _jlgGetBillModel.unit_quan_tpl = unitTpl;
            _jlgGetBillModel.name = recordModel.name;
            _jlgGetBillModel.uid = [recordModel.uid integerValue];
            templateVC.yzgGetBillModel = _jlgGetBillModel;
            [self.navigationController pushViewController:templateVC animated:YES];
            
            // 设置考勤模板回调
            templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
                
                recordModel.unit_quan_tpl.w_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                recordModel.unit_quan_tpl.o_h_tpl = [[NSString stringWithFormat:@"%.1f",yzgGetBillModel.unit_quan_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                
                recordModel.makeType = strongSelf -> _markType;
                recordModel.isSelected = YES;
                if (strongSelf -> _markType == JGJMorePeopleMakeLittleWorkType) {
                    
                    recordModel.msg.accounts_type = @"1";
                    
                }else {
                    
                    recordModel.msg.accounts_type = @"5";
                }
                [weakSelf.moreSelectArr addObject:recordModel];
                [strongSelf -> listModel.list replaceObjectAtIndex:indexpathss.row withObject:recordModel];
                
                [weakSelf.tableview reloadData];
            };
        }
    }
    
    
}

- (void)didSelectIndexpath:(NSIndexPath *)selectIndexpath {
    
    NSIndexPath *indexset = [NSIndexPath indexPathForRow:selectIndexpath.row  inSection:1];
    indexpaths = indexset;
}

- (void)editeRecordedBillTpl {
    
    JgjRecordMorePeoplelistModel *recorderModel = listModelAcount.list[indexpaths.row - 1];
    
    NSString *desStr;
    if ([recorderModel.msg.accounts_type isEqualToString:@"1"]) {
        
        NSString *manTplStr = [NSString stringWithFormat:@"%@小时(上班)",recorderModel.tpl.w_h_tpl];
        NSString *overTplStr = [NSString stringWithFormat:@"%@小时(加班)",recorderModel.tpl.o_h_tpl];
        // 工资标准显示方式 0 - 按工天算加班显示b方式 1 - 按小时算加班显示方式
        if (recorderModel.tpl.hour_type == 0) {
            
            if ([recorderModel.tpl.w_h_tpl floatValue] > 0) {
                
                if ([recorderModel.tpl.s_tpl floatValue] <= 0) {
                    
                    NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.w_h_tpl floatValue]];
                    
                    w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.o_h_tpl floatValue]];
                    o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                    _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工", w_h_tpl,o_h_tpl];
                    
                }else{
                    
                    NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f",[recorderModel.tpl.w_h_tpl floatValue]];
                    
                    w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.o_h_tpl floatValue]];
                    
                    o_h_tpl = [o_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    NSString *o_s_tpl = @"";
                    if ([recorderModel.tpl.o_h_tpl floatValue] > 0) {
                        
                        o_s_tpl = [NSString stringWithFormat:@"%.2f",[NSString roundFloat:[recorderModel.tpl.s_tpl floatValue] / [recorderModel.tpl.o_h_tpl floatValue]]];
                        
                    }
                    
                    _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                    _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n加班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,o_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                }
            }
            
            
        }else {
            
            if ([recorderModel.tpl.w_h_tpl floatValue] > 0) {
                
                NSString *w_h_tpl = [NSString stringWithFormat:@"%.1f", [recorderModel.tpl.w_h_tpl floatValue]];
                
                w_h_tpl = [w_h_tpl stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                NSString *o_s_tpl = [NSString stringWithFormat:@"%.2f",recorderModel.tpl.o_s_tpl];
                
                _workPicker.detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                
                _worker_detailStr = [NSString stringWithFormat:@"上班%@小时算一个工\n%.2f元/个工(上班)\n%@元/小时(加班)", w_h_tpl,[recorderModel.tpl.s_tpl floatValue],o_s_tpl];
                
            }
            
        }
        
        [self showPickerWithRecordModel:recorderModel];
        
        _workPicker.theDetailLableTexTAlignmentNeedLeft = NO;
        
        [self reloadPickerView];
        
        _workPicker.nameAndPhone = [NSString stringWithFormat:@"%@(%@)",recorderModel.name,recorderModel.telph];
        
        //设置日期显示样式telph
        [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_w_h_tpl] andover_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_o_h_tpl] andManTPL:[NSString stringWithFormat:@"%@",recorderModel.tpl. w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%@",recorderModel.tpl.o_h_tpl]];
        
        
    }else if ([recorderModel.msg.accounts_type isEqualToString:@"5"]) {// 包工考勤
        
        
        NSString *manTplStr = [NSString stringWithFormat:@"%@小时(上班)",recorderModel.unit_quan_tpl.w_h_tpl];
        NSString *overTplStr = [NSString stringWithFormat:@"%@小时(加班)",recorderModel.unit_quan_tpl.o_h_tpl];
        _workPicker.detailStr = [NSString stringWithFormat:@"%@/%@",manTplStr?:@"",overTplStr?:@""];
        
        _workPicker.theDetailLableTexTAlignmentNeedLeft = NO;
        
        [self reloadPickerView];
        
        _workPicker.nameAndPhone = [NSString stringWithFormat:@"%@(%@)",recorderModel.name,recorderModel.telph];
        
        //设置日期显示样式telph
        [_workPicker SetdefaultTimeW_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_w_h_tpl] andover_tpl:[NSString stringWithFormat:@"%@",recorderModel.choose_tpl.choose_o_h_tpl] andManTPL:[NSString stringWithFormat:@"%@",recorderModel.unit_quan_tpl. w_h_tpl] andOverTimeTPL:[NSString stringWithFormat:@"%@",recorderModel.unit_quan_tpl.o_h_tpl]];
        
    }
    
    [_repeatSaveArr addObject:indexpaths];
    
}

#pragma mark - 保存数据后用于存储第二次进来要默认选中
- (void)saveDataFromRequestHttp
{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.moreSelectArr.count; i ++) {
        
        JgjRecordMorePeoplelistModel *model = self.moreSelectArr[i];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [dataArr addObject:data];
    }
    
    NSData * data  = [NSKeyedArchiver archivedDataWithRootObject:dataArr];
    
    [TYUserDefaults setObject:data forKey:JGJMarkBillMoreMan];
    
    [TYUserDefaults synchronize];
    
}
@end
