//
//  JGJMarkBillViewController.m
//  mix
//
//  Created by Tony on 2017/12/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMarkBillViewController.h"

#import "JGJTinyAmountCollectionViewCell.h"

#import "JGJContractorCollectionViewCell.h"
#import "JGJContractorMakeAttendanceViewCell.h"

#import "JGJBrrowCollectionViewCell.h"

#import "JGJCloseAccountCollectionViewCell.h"

#import "NSDate+Extend.h"

#import "IDJCalendar.h"

#import "JGJPackNumViewController.h"

#import "JLGDatePickerView.h"

#import "YZGOnlyAddProjectViewController.h"

#import "JLGPickerView.h"

#import "JGJBillEditProNameViewController.h"

#import "JGJOtherInfoViewController.h"

#import "JGJManHourPickerView.h"

#import "JGJCusAlertView.h"

#import "JGJRecordBillDetailViewController.h"

#import "FDAlertView.h"

#import "JGJWageLevelViewController.h"

#import "JGJQustionShowView.h"

#import "JGJLeaderRecordsViewController.h"

#import "JGJWorkMatesRecordsViewController.h"

#import "JGJMoreDayViewController.h"

#import "JGJUnWagesShortWorkVc.h"

#import "JGJSurePoorbillViewController.h"

#import "JLGCustomViewController.h"

#import "JGJMarkBillRemarkViewController.h"

#import "JGJContractorListAttendanceTemplateController.h"
#import "JGJCloseAnAccountInfoAlertView.h"
#import "JGJWorkTplHaveDiffAlertView.h"
#import "JGJNewSelectedDataPickerView.h"
#import "JGJTeamWorkListViewController.h"

#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "YZGMateWorkitemsViewController.h"
#import "JGJRecordWorkpointsVc.h"

#import "JGJCustomPopView.h"
#import "JGJCustomAlertView.h"
#import "UILabel+GNUtil.h"
#import "JGJCusSeniorPopView.h"
#import "JGJCreatTeamVC.h"
static NSString *JGJMarkBillTinyID = @"JGJMarkBillTinyIndentifer";

static NSString *JGJMarkBillContractorID = @"JGJMarkBillContractIndentifer";

static NSString *JGJMarkBillBrrowID = @"JGJMarkBillbrrowIndentifer";

static NSString *JGJMarkBillCloseAccountID = @"JGJMarkBillCloseAcountIndentifer";

@interface JGJMarkBillViewController ()
<
UICollectionViewDelegate,

UICollectionViewDataSource,

JGJBottomBtnViewDelegate,

UIScrollViewDelegate,

JGJMarkBillCommonHeaderViewDelegate,

JGJTinyAmountCollectionViewCellDelegate,

JLGDatePickerViewDelegate,

JLGPickerViewDelegate,

JGJManHourPickerViewDelegate,

FDAlertViewDelegate,

JGJContractorCollectionViewCellDelegate,

JGJBrrowCollectionViewCellDelegate,

JGJCloseAccountCollectionViewCellDelegate,

YZGOnlyAddProjectViewControllerDelegate,

JGJContractorMakeAttendanceViewCellDelegate,
JGJNewSelectedDataPickerViewDelegate,
JGJNewMarkBillChoiceProjectViewControllerDelgate,
JGJMarkBillRemarkViewControllerDelegate
>{
    
    YZGAddForemanModel *_selectedForemanModel;
    
    BOOL _isMainGoinGetTPL;
    BOOL _isChoicePerson;
    
    BOOL _isSaveToServerSuccess;
    JGJContractorMakeType _contractorMakeType;
    
    CGFloat _markEditeMoney;
    
    BOOL _isChoiceManHourOrOverHour;

}
@property (nonatomic, strong) IDJCalendar *calendar;

@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;
@property (nonatomic, strong) JGJNewSelectedDataPickerView *theNewSelectedDataPickerView;
@property (nonatomic ,strong)JLGPickerView *jlgPickerView;

@property (nonatomic, strong) NSMutableArray *saveProArr;

@property (nonatomic,strong) NSMutableArray *proNameArray;
@property (nonatomic, strong) NSMutableDictionary *theLastToServerPramedic;

@property (nonatomic,strong)  NSString *treadid;
@property (nonatomic, strong) NSString *is_next_act;
@property (nonatomic, strong) NSString *accounts_type;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) BOOL isClearEditMoney;// 是否清空本次实收金额

@end

@implementation JGJMarkBillViewController
@synthesize yzgGetBillModel = _yzgGetBillModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadSelfView];
    [self justRealName];
}


- (void)startRefresh {
    
    [self reqeustAccountInfoWithAddForemanModel:_selectedForemanModel];
}

- (void)markBillMoreDaySuccessComeBack {
    
    [self manegerCleanCurrentPageData];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)loadSelfView{
    
    _mainCollectionview.delegate = self;
    
    _mainCollectionview.dataSource = self;
    
    [_mainCollectionview registerNib:[UINib nibWithNibName:@"JGJTinyAmountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JGJMarkBillTinyID];
 
    [_mainCollectionview registerClass:[JGJContractorMakeAttendanceViewCell class] forCellWithReuseIdentifier:JGJMarkBillContractorID];
    
    [_mainCollectionview registerNib:[UINib nibWithNibName:@"JGJBrrowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JGJMarkBillBrrowID];
    
    [_mainCollectionview registerNib:[UINib nibWithNibName:@"JGJCloseAccountCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JGJMarkBillCloseAccountID];
    
    _mainCollectionview.pagingEnabled = YES;
    
    [self.bottomView setClickBtnTitle:@"保存"];
    
    self.bottomView.delegate = self;
    
    self.MarkBillCommonView.delegate = self;
    
    //获取最近一次记账人
    if (!_markBillMore && !_ChatType && JLGisMateBool && self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        [self initLastRecordNews];
    }
    
    if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
        
        YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
        
        addForemanModel.uid = [self.closeUserInfo.uid integerValue];
        
        addForemanModel.telph = self.closeUserInfo.telph;
        
        addForemanModel.name = self.closeUserInfo.name;
        
        [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
        
        [self.MarkBillCommonView setBtnStateFromBtnTag:self.markSlectBtnType];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barTintColor = AppFontffffffColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color,NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont]}];
    [JGJQustionShowView removeQustionView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [TYNotificationCenter removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"记工记账";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBarTintColor:AppFont3A3F4EColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFontffffffColor}];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateHighlighted];
    
    leftButton.frame = CGRectMake(0, 0, 45, JGJLeftButtonHeight);
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)backButtonPressed
{
    [JGJQustionShowView removeQustionView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    
//    self.tinyYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
    _selectedDate = selectedDate;
    [self.mainCollectionview reloadData];
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    _workProListModel = workProListModel;
    if (_selectedDate) {
        self.tinyYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        self.contractYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        self.brrowYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        self.closeAccountyzgGetBillModel.date = [self getWeekDaysString:_selectedDate];

    }else{
        self.tinyYzgGetBillModel.date =  [self getWeekDaysString:[NSDate date]];
        self.contractYzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
        self.brrowYzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
        self.closeAccountyzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];

    }
    if (self.markBillMore) {//几多人进来
        if (!_workProListModel) {
            _workProListModel = [[JGJMyWorkCircleProListModel alloc]init];
        }
        _workProListModel = workProListModel;
        self.tinyYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        if (self.isAgentMonitor || self.markBillMore) {
            
            self.contractYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
            self.contractYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
            
            self.brrowYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
            self.brrowYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
            
            self.closeAccountyzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
            self.closeAccountyzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        }

    }
    
    if (self.ChatType) {
        
        if (!_workProListModel) {
            _workProListModel = [[JGJMyWorkCircleProListModel alloc]init];
        }
        _workProListModel = workProListModel;
        self.tinyYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.contractYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.contractYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.brrowYzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.brrowYzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
        
        self.closeAccountyzgGetBillModel.proname = workProListModel.all_pro_name?:@"";
        self.closeAccountyzgGetBillModel.pid = [workProListModel.pro_id?:@"0"  longLongValue];
    }
    
    if (_getTpl) {
        
        self.tinyYzgGetBillModel.name = workProListModel.creater_name?:@"";
        self.tinyYzgGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
        
        self.contractYzgGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
        
        self.brrowYzgGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];
        
        self.closeAccountyzgGetBillModel.uid = [workProListModel.creater_uid?:@"0"  longLongValue];

        id workUid = [TYUserDefaults objectForKey:JLGUserUid];
#pragma mark - 班组进来也要获取最近一i记账项目 2017-6-24
        [self JLGHttpRequest_LastproWithUid:[workUid integerValue]];
       
        [self mainGoinGetTPL];
    }
    
    self.yzgGetBillModel.role = self.roleType;
}
#pragma mark - 首页进入记账获取薪资模板
- (void)mainGoinGetTPL {
    
    _isMainGoinGetTPL = YES;
    
    NSString *postApi = @"workday/fm-list";

    NSDictionary *parameters = @{@"uid":self.workProListModel.creater_uid?:@"",
                                 @"group_id":self.workProListModel.group_id?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:postApi parameters:parameters success:^(NSArray *responseObject) {
        
        GetBillSet_Tpl *bill_Tpl = [GetBillSet_Tpl mj_objectWithKeyValues:responseObject[0][@"tpl"]];
        bill_Tpl.s_tpl = bill_Tpl.s_tpl;
        bill_Tpl.o_h_tpl = bill_Tpl.o_h_tpl;
        bill_Tpl.w_h_tpl = bill_Tpl.w_h_tpl;
       
        GetBill_UnitQuanTpl *unitTpl = [GetBill_UnitQuanTpl mj_objectWithKeyValues:responseObject[0][@"unit_quan_tpl"]];
        unitTpl.s_tpl = unitTpl.s_tpl;
        unitTpl.o_h_tpl = unitTpl.o_h_tpl;
        unitTpl.w_h_tpl = unitTpl.w_h_tpl;
        
        self.tinyYzgGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.tinyYzgGetBillModel.set_tpl = bill_Tpl;
        self.tinyYzgGetBillModel.manhour = self.tinyYzgGetBillModel.set_tpl.w_h_tpl;
        self.tinyYzgGetBillModel.overtime = 0;
        
        //yj添加
        self.tinyYzgGetBillModel.phone_num = responseObject[0][@"telph"];
        
        self.contractYzgGetBillModel.name = responseObject[0][@"name"]?:@"";
        self.contractYzgGetBillModel.unit_quan_tpl = unitTpl;
        self.contractYzgGetBillModel.manhour = self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl;
        self.contractYzgGetBillModel.overtime = 0;
        
        self.brrowYzgGetBillModel.name = responseObject[0][@"name"]?:@"";

        self.closeAccountyzgGetBillModel.name = responseObject[0][@"name"]?:@"";

        [self getSalary];
        [self.mainCollectionview reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == JGJMarkSelectTinyBtnType) {
        
        JGJTinyAmountCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJMarkBillTinyID forIndexPath:indexPath];
        cell.isAgentMonitor = self.isAgentMonitor;
        cell.markBillMore = self.markBillMore;
        cell.mainGo = self.ChatType;
        if (_selectedDate) {
            
            self.tinyYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        }
        
        cell.yzgGetBillModel = self.tinyYzgGetBillModel;
        
        self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
        self.yzgGetBillModel.proname = self.tinyYzgGetBillModel.proname;
        self.yzgGetBillModel.pid = self.tinyYzgGetBillModel.pid;
        
        cell.delegate = self;
        cell.proListModel = self.workProListModel;
        return cell;
        
    }else if (indexPath.section == JGJMarkSelectContractBtnType){
        
        JGJContractorMakeAttendanceViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJMarkBillContractorID forIndexPath:indexPath];
        cell.isAgentMonitor = self.isAgentMonitor;
        cell.markBillMore = self.markBillMore;
        cell.mainGo = self.ChatType;
        cell.proListModel = self.workProListModel;
        if (_selectedDate) {

            self.contractYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        }
        
        cell.yzgGetBillModel = self.contractYzgGetBillModel;

        self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
        self.yzgGetBillModel.proname = self.contractYzgGetBillModel.proname;
        self.yzgGetBillModel.pid = self.contractYzgGetBillModel.pid;

        cell.delegate = self;
        
        return cell;

    }else if (indexPath.section == JGJMarkSelectBrrowBtnType){
        
   
        JGJBrrowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJMarkBillBrrowID forIndexPath:indexPath];
   
        cell.isAgentMonitor = self.isAgentMonitor;
        cell.markBillMore = self.markBillMore;
        cell.mainGo = self.ChatType;
   
        cell.delegate = self;
   
        cell.proListModel = self.workProListModel;
   
        if (_selectedDate) {
            
            self.brrowYzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        }
        
        cell.yzgGetBillModel = self.brrowYzgGetBillModel;
        
        self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
        self.yzgGetBillModel.proname = self.brrowYzgGetBillModel.proname;
        self.yzgGetBillModel.pid = self.brrowYzgGetBillModel.pid;
        
        return cell;

    }else{
        
    
        JGJCloseAccountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJMarkBillCloseAccountID forIndexPath:indexPath];
    
        cell.isAgentMonitor = self.isAgentMonitor;
        cell.markBillMore = self.markBillMore;
        cell.mainGo = self.ChatType;

        if (_selectedDate) {
            
            self.closeAccountyzgGetBillModel.date = [self getWeekDaysString:_selectedDate];
        }
        
        cell.yzgGetBillModel = self.closeAccountyzgGetBillModel;
        
        self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
        self.yzgGetBillModel.proname = self.closeAccountyzgGetBillModel.proname;
        self.yzgGetBillModel.pid = self.closeAccountyzgGetBillModel.pid;
        
        if (_isSaveToServerSuccess) {
            
            cell.editeMoney = 0;
        }
        cell.proListModel = self.workProListModel;
   
        cell.delegete = self;
        
        if (self.isClearEditMoney) {
            
            cell.editeMoney = 0;
            self.closeAccountyzgGetBillModel.salary = 0.0;
        }
        return cell;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //这里设置的原因是从未结算工资进入结算页面，不会闪烁。
    if (_isScroCloseType) {
        
        CGPoint contentOffset = CGPointMake(TYGetUIScreenWidth * 3, collectionView.height);
        
        [collectionView setContentOffset:contentOffset animated:NO];
        
        _isScroCloseType = NO;
        
    }

    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    return CGSizeMake(TYGetUIScreenWidth, self.mainCollectionview.frame.size.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.imagesArray = [NSMutableArray new];
        self.tinyYzgGetBillModel.notes_img = [NSMutableArray new];
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType)
    {
        self.imagesArray = [NSMutableArray new];
        self.contractYzgGetBillModel.notes_img = [NSMutableArray new];
        
    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){

        self.imagesArray = [NSMutableArray new];
        self.brrowYzgGetBillModel.notes_img = [NSMutableArray new];

    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
        
        self.imagesArray = [NSMutableArray new];
        self.closeAccountyzgGetBillModel.notes_img = [NSMutableArray new];
    }
    NSInteger page = (int)scrollView.contentOffset.x / scrollView.width + 0.5;
    
    if (scrollView.width == 0 || scrollView.height == 0) {
        
        return;
    }
    
    int index = 0;
    
    index = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width;
    
    if (scrollView.dragging) {
        
        [self.MarkBillCommonView setBtnStateFromBtnTag:index];
    }
}

#pragma mark - 点击顶部按钮
-(void)clickMarkBillTopBtnWithType:(JGJMarkSelectBtnType )MarkSelectBtnType
{
    if (self.markSlectBtnType != MarkSelectBtnType) {
        
        if (MarkSelectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.imagesArray = [NSMutableArray new];
            self.tinyYzgGetBillModel.notes_img = [NSMutableArray new];
            
        }else if (MarkSelectBtnType == JGJMarkSelectContractBtnType)
        {
            self.imagesArray = [NSMutableArray new];
            self.contractYzgGetBillModel.notes_img = [NSMutableArray new];
            
        }else if (MarkSelectBtnType == JGJMarkSelectBrrowBtnType){
            
            self.imagesArray = [NSMutableArray new];
            self.brrowYzgGetBillModel.notes_img = [NSMutableArray new];
            
            
        }else if (MarkSelectBtnType == JGJMarkSelectCloseAccountBtnType){
            
            self.imagesArray = [NSMutableArray new];
            self.closeAccountyzgGetBillModel.notes_img = [NSMutableArray new];
            
        }
    }
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:MarkSelectBtnType];
    
    [self.mainCollectionview scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    
    self.markSlectBtnType = MarkSelectBtnType;
    
    if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType && self.ChatType) {
        
        [self getOutstandingAmount];
    }
    [self.MarkBillCommonView setBtnStateFromBtnTag:indexpath.section];

}

//这里很烦  UI为了屏蔽动画效果就只有这种方法来做了
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
      
    int index = 0;
    
    index = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width;
    switch (index) {
        case 0:
            self.markSlectBtnType = JGJMarkSelectTinyBtnType;

            break;
        case 1:
            self.markSlectBtnType = JGJMarkSelectContractBtnType;

            break;
        case 2:
            self.markSlectBtnType = JGJMarkSelectBrrowBtnType;

            break;
        case 3:
            self.markSlectBtnType = JGJMarkSelectCloseAccountBtnType;

            break;
        default:
            break;
    }


}

-(YZGGetBillModel *)tinyYzgGetBillModel
{
    if (!_tinyYzgGetBillModel) {
        _tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _tinyYzgGetBillModel;
}
-(YZGGetBillModel *)contractYzgGetBillModel
{
    if (!_contractYzgGetBillModel) {
        _contractYzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _contractYzgGetBillModel;
    
}
-(YZGGetBillModel *)brrowYzgGetBillModel
{
    if (!_brrowYzgGetBillModel) {
        _brrowYzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _brrowYzgGetBillModel;
    
}
-(YZGGetBillModel *)closeAccountyzgGetBillModel
{
    if (!_closeAccountyzgGetBillModel) {
        _closeAccountyzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    return _closeAccountyzgGetBillModel;
    
}

- (void)handleAddForemanAdnMateVcWithModel:(YZGGetBillModel *)billModel{
    
    self.addForemanModel.name = billModel.name;
    
    self.addForemanModel.telph = billModel.phone_num;
    
    self.addForemanModel.uid = billModel.uid;
    
    JGJAccountingMemberVC *accountingMemberVC = [JGJAccountingMemberVC new];
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];

    if (self.isAgentMonitor) {
        
        accountingMemberVC.agency_title = @"工人";
        accountingMemberVC.isAgentMonitor = self.isAgentMonitor;
    }
    
    seledAccountMember.name = billModel.name;
    
    seledAccountMember.telph = billModel.phone_num;
    
    seledAccountMember.uid = [NSString stringWithFormat:@"%@", @(billModel.uid)];
    
    accountingMemberVC.seledAccountMember = seledAccountMember;
    
    //返回的时候用
    accountingMemberVC.targetVc = self;
    
    accountingMemberVC.isGroupMember = self.markSlectBtnType == JGJMarkSelectTinyBtnType;
    
    accountingMemberVC.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:accountingMemberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //选中的回调人员,如果删除之后accoumtMember为nil
    accountingMemberVC.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *accoumtMember) {
        
        if (accoumtMember.isDelMember) {
            
            if (JLGisMateBool) {
                
                //删除最后一次记账的数据(工人记工头，删除同一个)
                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
                parmDic = [TYUserDefaults objectForKey:JLGLastRecordBillPeople];
                self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
                
                NSString *uid = [NSString stringWithFormat:@"%@", @(self.addForemanModel.uid)];
                
                if ([uid isEqualToString:accoumtMember.uid]) {
                    
                    [TYUserDefaults removeObjectForKey:JLGLastRecordBillPeople];
                }
                
            }
            
            if (!weakSelf.markBillMore) {
                
                weakSelf.tinyYzgGetBillModel = nil;
                
                
                //结算
                weakSelf.closeAccountyzgGetBillModel = nil;
                
//                借支
                weakSelf.brrowYzgGetBillModel = nil;
                
//                包工
                weakSelf.contractYzgGetBillModel = nil;
                
                [weakSelf.mainCollectionview reloadData];
            }

        
        }else{

            // v3.4.2现在这里 选中人后 通过接口获取新的工资模板
            if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {// 点工记账选中人
                
                [self getWorkTplByUidWithUid:accoumtMember.uid accounts_type:@"1" accoumtMember:accoumtMember];
                
            }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
                
                if (_contractorMakeType == JGJContractorMakeAttendanceType) {// 包工记考勤选中人
                    
                    [self getWorkTplByUidWithUid:accoumtMember.uid accounts_type:@"5" accoumtMember:accoumtMember];
                }else {
                    
                    [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
                }
            }else {
                
                [self getMarkBillPersonInfoWithAccountMember:accoumtMember];
            }
        }
    };
}

- (void)getMarkBillPersonInfoWithAccountMember:(JGJSynBillingModel *)accoumtMember {
    
    if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
        
        self.isClearEditMoney = YES;
    }else {
        
        self.isClearEditMoney = NO;
    }
    
    YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
    
    addForemanModel.uid = [accoumtMember.uid integerValue];
    
    addForemanModel.telph = accoumtMember.telph;
    
    addForemanModel.name = accoumtMember.name;
    
    addForemanModel.head_pic = accoumtMember.head_pic;
    _selectedForemanModel = addForemanModel;
    [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
}

- (void)getWorkTplByUidWithUid:(NSString *)uid accounts_type:(NSString *)accounts_type accoumtMember:(JGJSynBillingModel *)accoumtMember{
    
    NSDictionary *param = @{@"accounts_type":accounts_type,
                            @"uid":uid
                            };
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
        
        addForemanModel.uid = [accoumtMember.uid integerValue];
        
        addForemanModel.telph = accoumtMember.telph;
        
        addForemanModel.name = accoumtMember.name;
        
        addForemanModel.head_pic = accoumtMember.head_pic;
        addForemanModel.is_not_telph = accoumtMember.is_not_telph;
        JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
        getWorkTplByUidModel.user_name = accoumtMember.real_name;
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {// 点工记账
            
            // 先判断 自己设置考勤模板会对方设置的是否相同
            if (getWorkTplByUidModel.is_diff == 0) {// 表示无差异
                
                GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                
                set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                
                addForemanModel.tpl = set_tpl;
                
            }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                
                JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                [diffTplAlertView show];
                
                diffTplAlertView.difTplBill = getWorkTplByUidModel;
                diffTplAlertView.markSlectBtnType = self.markSlectBtnType;
                
                TYWeakSelf(self);
                // 取消
                diffTplAlertView.cancle = ^{// 用自己的工资模板
                    
                    GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                    
                    set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                    set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    addForemanModel.tpl = set_tpl;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
                
                // 同意
                diffTplAlertView.agree = ^{// 用对方的工资模板
                    
                    GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
                    
                    set_tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                    set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
                    set_tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                    addForemanModel.tpl = set_tpl;
                    _selectedForemanModel = addForemanModel;
                    [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                };
            }
            
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
            
            if (_contractorMakeType == JGJContractorMakeAttendanceType) {// 包工记考勤
                
                // 先判断 自己设置考勤模板会对方设置的是否相同
                if (getWorkTplByUidModel.is_diff == 0) {// 表示无差异
                    
                    GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                    quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                    
                    self.contractYzgGetBillModel.unit_quan_tpl = quan_Tpl;
                    self.contractYzgGetBillModel.manhour = getWorkTplByUidModel.my_tpl.w_h_tpl;
                    self.contractYzgGetBillModel.overtime = 0;
                    
                    [self.mainCollectionview reloadData];
                    
                }else if (getWorkTplByUidModel.is_diff == 1) {// 表示有差异
                    
                    JGJWorkTplHaveDiffAlertView *diffTplAlertView = [[JGJWorkTplHaveDiffAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
                    [diffTplAlertView show];
                    diffTplAlertView.difTplBill = getWorkTplByUidModel;
                    diffTplAlertView.markSlectBtnType = self.markSlectBtnType;
                    
                    TYWeakSelf(self);
                    // 取消
                    diffTplAlertView.cancle = ^{// 用自己的考勤模板
                        
                        GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                        quan_Tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
                        quan_Tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
                        
                        weakself.contractYzgGetBillModel.unit_quan_tpl = quan_Tpl;
                        weakself.contractYzgGetBillModel.manhour = getWorkTplByUidModel.my_tpl.w_h_tpl;
                        weakself.contractYzgGetBillModel.overtime = 0;
                        
                        [weakself.mainCollectionview reloadData];
                        _selectedForemanModel = addForemanModel;
                        [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                    };
                    
                    // 同意
                    diffTplAlertView.agree = ^{// 用对方的考勤模板
                        
                        GetBill_UnitQuanTpl *quan_Tpl = [[GetBill_UnitQuanTpl alloc] init];
                        quan_Tpl.w_h_tpl = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                        quan_Tpl.o_h_tpl = getWorkTplByUidModel.oth_tpl.o_h_tpl;
                        
                        weakself.contractYzgGetBillModel.unit_quan_tpl = quan_Tpl;
                        weakself.contractYzgGetBillModel.manhour = getWorkTplByUidModel.oth_tpl.w_h_tpl;
                        weakself.contractYzgGetBillModel.overtime = 0;
                        
                        [weakself.mainCollectionview reloadData];
                        _selectedForemanModel = addForemanModel;
                        [weakself reqeustAccountInfoWithAddForemanModel:addForemanModel];
                    };
                }
            }
        }
        
        _selectedForemanModel = addForemanModel;
        [self reqeustAccountInfoWithAddForemanModel:addForemanModel];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)reqeustAccountInfoWithAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    self.addForemanModel = addForemanModel;
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.tinyYzgGetBillModel.set_tpl = addForemanModel.tpl;
        self.tinyYzgGetBillModel.manhour = addForemanModel.tpl.w_h_tpl;//默认的情况下，工作时长就是模板的时间
        self.tinyYzgGetBillModel.overtime = 0;//移除账单，默认情况下是不加班
        self.tinyYzgGetBillModel.is_not_telph = addForemanModel.is_not_telph;
        [self getSalary];
        
    }
    if (self.markSlectBtnType != JGJMarkSelectTinyBtnType) {
        
        [self getOutstandingAmount];
        
    }
}

#pragma mark - 获取人数
- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel {
    
    _isChoicePerson = YES;
    _addForemanModel = addForemanModel;
    if ([NSString isEmpty: self.tinyYzgGetBillModel.date]) {
        self.tinyYzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
    }
    if ([NSString isEmpty: self.contractYzgGetBillModel.date]) {
        self.contractYzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
    }
    if ([NSString isEmpty: self.brrowYzgGetBillModel.date]) {
        self.brrowYzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
    }
    if ([NSString isEmpty: self.closeAccountyzgGetBillModel.date]) {
        self.closeAccountyzgGetBillModel.date = [self getWeekDaysString:_selectedDate?:[NSDate date]];
    }
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
         self.tinyYzgGetBillModel.set_tpl = self.addForemanModel.tpl;
         self.tinyYzgGetBillModel.name = self.addForemanModel.name;
         self.tinyYzgGetBillModel.uid = self.addForemanModel.uid;

         self.tinyYzgGetBillModel.phone_num = addForemanModel.telph;
         self.tinyYzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
         self.tinyYzgGetBillModel.salary  = self.addForemanModel.tpl.s_tpl;
         self.tinyYzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        
        if (_markBillMore) {
             self.tinyYzgGetBillModel.proname = _workProListModel.all_pro_name;
             self.tinyYzgGetBillModel.pid     = [_workProListModel.pro_id integerValue];
        }else{
            if (self.tinyYzgGetBillModel.uid) {
                [self JLGHttpRequest_LastproWithUid: self.tinyYzgGetBillModel.uid];
            }
            
        }
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
        
        self.contractYzgGetBillModel.set_tpl = self.addForemanModel.tpl;
        
        self.contractYzgGetBillModel.name = self.addForemanModel.name;
        
        self.contractYzgGetBillModel.uid = self.addForemanModel.uid;
        
        self.contractYzgGetBillModel.phone_num = addForemanModel.telph;
        
        self.contractYzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        

        if (_markBillMore) {
            self.contractYzgGetBillModel.proname = _workProListModel.all_pro_name;
            self.contractYzgGetBillModel.pid     = [_workProListModel.pro_id integerValue];
        }else{
            if (self.contractYzgGetBillModel.uid) {
                [self JLGHttpRequest_LastproWithUid: self.contractYzgGetBillModel.uid];
            }
        }
    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
        
        
        self.brrowYzgGetBillModel.set_tpl = self.addForemanModel.tpl;
        
        self.brrowYzgGetBillModel.name = self.addForemanModel.name;
        
        self.brrowYzgGetBillModel.uid = self.addForemanModel.uid;
        
        self.brrowYzgGetBillModel.phone_num = addForemanModel.telph;
        self.brrowYzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
        self.brrowYzgGetBillModel.salary  = self.addForemanModel.tpl.s_tpl;
        self.brrowYzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        if (_markBillMore) {
            self.brrowYzgGetBillModel.proname = _workProListModel.all_pro_name;
            self.brrowYzgGetBillModel.pid     = [_workProListModel.pro_id integerValue];
        }else{
            if ( self.brrowYzgGetBillModel.uid) {
                [self JLGHttpRequest_LastproWithUid: self.brrowYzgGetBillModel.uid];
            }
            
        }
        
    }else{
        
        
        self.closeAccountyzgGetBillModel.set_tpl = self.addForemanModel.tpl;
        
        self.closeAccountyzgGetBillModel.name = self.addForemanModel.name;
        
        self.closeAccountyzgGetBillModel.uid = self.addForemanModel.uid;
        
        self.closeAccountyzgGetBillModel.phone_num = addForemanModel.telph;
        self.closeAccountyzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
        self.closeAccountyzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        if (_markBillMore) {
            
            self.closeAccountyzgGetBillModel.proname = _workProListModel.all_pro_name;
            self.closeAccountyzgGetBillModel.pid     = [_workProListModel.pro_id integerValue];
            
        }else{
            
            if ( self.closeAccountyzgGetBillModel.uid) {
                
                [self JLGHttpRequest_LastproWithUid: self.closeAccountyzgGetBillModel.uid];
            }
            
        }
    }

}
- (void)initLastRecordNews
{
    if (!_tinyYzgGetBillModel) {
        
        _tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
    }
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    parmDic = [TYUserDefaults objectForKey:JLGLastRecordBillPeople];
    if (parmDic) {
        
        self.tinyMarkBill = YES;
        self.addForemanModel = [YZGAddForemanModel mj_objectWithKeyValues:parmDic];
        self.tinyYzgGetBillModel.name = self.addForemanModel.name;
        self.tinyYzgGetBillModel.head_pic = self.addForemanModel.head_pic;
        self.tinyYzgGetBillModel.uid = self.addForemanModel.uid;
        self.tinyYzgGetBillModel.phone_num = self.addForemanModel.telph;
        
        if (self.tinyYzgGetBillModel.uid == 0) {
            
            return;
        }
        NSDictionary *param = @{@"accounts_type":@"1",
                                @"uid":@(self.tinyYzgGetBillModel.uid)
                                };
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            JGJGetWorkTplByUidModel *getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
            self.tinyYzgGetBillModel.set_tpl.s_tpl = getWorkTplByUidModel.my_tpl.s_tpl;
            self.tinyYzgGetBillModel.set_tpl.w_h_tpl = getWorkTplByUidModel.my_tpl.w_h_tpl;
            self.tinyYzgGetBillModel.set_tpl.o_h_tpl = getWorkTplByUidModel.my_tpl.o_h_tpl;
            [self.mainCollectionview reloadData];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        

    }
}
#pragma mark - 获取薪资模板
- (void)JLGHttpRequest_QueryTpl{
    
    [TYLoadingHub showLoadingWithMessage:@""];
   
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querytpl" parameters:@{@"uid":@(self.addForemanModel.uid)} success:^(id responseObject)
    {
        
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        [bill_Tpl mj_setKeyValues:responseObject];
        
        self.tinyYzgGetBillModel.set_tpl = bill_Tpl;
        self.tinyYzgGetBillModel.manhour = bill_Tpl.w_h_tpl;//默认的情况下，工作是长就是模板的时间
        self.tinyYzgGetBillModel.overtime = 0;//移除账单，默认情况下是不加班
        
        [self getSalary];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (CGFloat)getSalary{
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {//点工
        
        if (!_isChoiceManHourOrOverHour) {
            
            self.tinyYzgGetBillModel.manhour = self.tinyYzgGetBillModel.set_tpl.w_h_tpl;
            self.tinyYzgGetBillModel.overtime = 0.0;
        }
        self.tinyYzgGetBillModel.salary = (CGFloat )self.tinyYzgGetBillModel.set_tpl.s_tpl*self.tinyYzgGetBillModel.manhour/self.tinyYzgGetBillModel.set_tpl.w_h_tpl + (CGFloat )self.tinyYzgGetBillModel.set_tpl.s_tpl*self.tinyYzgGetBillModel.overtime/self.tinyYzgGetBillModel.set_tpl.o_h_tpl;
        
        self.tinyYzgGetBillModel.salary = [[NSString decimalwithFormat:@"0.00" doubleV:self.tinyYzgGetBillModel.salary] doubleValue];
        
        if (isnan(self.tinyYzgGetBillModel.salary)) {
            
            self.tinyYzgGetBillModel.salary = 0.f;
        }

    }else if(self.markSlectBtnType == JGJMarkSelectContractBtnType){//包工
        
        if (!_isChoiceManHourOrOverHour) {
            
            self.contractYzgGetBillModel.manhour = self.tinyYzgGetBillModel.set_tpl.w_h_tpl;
            self.contractYzgGetBillModel.overtime = 0.0;
        }
        self.contractYzgGetBillModel.salary = self.contractYzgGetBillModel.unitprice * self.tinyYzgGetBillModel.quantities;
        self.contractYzgGetBillModel.salary = [[NSString decimalwithFormat:@"0.00" doubleV:self.contractYzgGetBillModel.salary] doubleValue];

    }
    [self.mainCollectionview reloadData];
    return self.tinyYzgGetBillModel.salary;
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
#pragma mark - 获取最后记账的项目
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    
    NSString *accountType;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        accountType = @"1";
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){

        accountType = @"2";
    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
        
        accountType = @"3";
    }else {
        
        accountType = @"4";
    }
    
    TYLog(@"group_id =====%@", self.workProListModel.group_info.group_id);
    
    //首页进来点工带上项目名字，包工、借支、结算取最后一次记账信息3.0.0yj添加
    NSDictionary *paramDic;
    paramDic = @{
                 @"uid":@(uid),
                 @"accounts_type":accountType,
                 @"group_id":self.ChatType && self.markSlectBtnType == JGJMarkSelectTinyBtnType?self.workProListModel.group_id?:@"":@""
                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:paramDic success:^(id responseObject) {
       
        if ([NSString isEmpty: responseObject[@"pro_name"]]) {
            
            if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {

                self.tinyYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                self.tinyYzgGetBillModel.pid = 0;
            }
            else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
                
                self.contractYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                self.contractYzgGetBillModel.pid = 0;
            }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
                
                self.brrowYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                self.brrowYzgGetBillModel.pid = 0;
            }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
                
                self.closeAccountyzgGetBillModel.proname = self.workProListModel.all_pro_name;
                self.closeAccountyzgGetBillModel.pid = 0;
            }

        }else{
           
            if ([responseObject[@"pro_name"] length] < 2 && _ChatType) {
               
                if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {

                    self.tinyYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                    self.tinyYzgGetBillModel.pid = 0;
                    
                }
                
                else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
                
                    self.contractYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                    self.contractYzgGetBillModel.pid = 0;
                }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){

                    self.brrowYzgGetBillModel.proname = self.workProListModel.all_pro_name;
                    self.brrowYzgGetBillModel.pid = 0;
            
                }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
                
                    self.closeAccountyzgGetBillModel.proname = self.workProListModel.all_pro_name;
                    self.closeAccountyzgGetBillModel.pid = 0;
              
                }
                
           
            }else{
                
                if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
                    
                    self.tinyYzgGetBillModel.proname = responseObject[@"pro_name"]?:@"";
                    self.tinyYzgGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
                    
                }else {
                
                    if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {

                        self.contractYzgGetBillModel.proname = responseObject[@"pro_name"];
                        self.contractYzgGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];

                    }else {
               
                        if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType) {

    
                            self.brrowYzgGetBillModel.proname = responseObject[@"pro_name"];
                            
                            self.brrowYzgGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];
               
                        }else {
                
                            if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {

                                self.closeAccountyzgGetBillModel.proname = responseObject[@"pro_name"];
                                self.closeAccountyzgGetBillModel.pid = [responseObject[@"pid"]?:@"0" integerValue];

                            }
                        }
                    }
                }
            }
        
        }

        [self.mainCollectionview reloadData];

    }failure:^(NSError *error) {
        
    }];
}

#pragma mark -设置显示数据
- (void)setYzgModelChange
{
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.yzgGetBillModel = self.tinyYzgGetBillModel;
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
        
        self.yzgGetBillModel = self.contractYzgGetBillModel;

    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
       
        self.yzgGetBillModel = self.brrowYzgGetBillModel;

    }else{
       
        self.yzgGetBillModel = self.closeAccountyzgGetBillModel;

    }
    
}

- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}

- (JGJNewSelectedDataPickerView *)theNewSelectedDataPickerView {
    
    if (!_theNewSelectedDataPickerView) {
        
        _theNewSelectedDataPickerView = [[JGJNewSelectedDataPickerView alloc] init];
        _theNewSelectedDataPickerView.pickerDelegate = self;
        _theNewSelectedDataPickerView.isNeedShowToday = YES;
        if (self.isAgentMonitor) {
            
            _theNewSelectedDataPickerView.isAgentMonitor  = self.isAgentMonitor;
            _theNewSelectedDataPickerView.start_time = self.workProListModel.agency_group_user.start_time;
            _theNewSelectedDataPickerView.end_Time = self.workProListModel.agency_group_user.end_time;
        }
        
    }
    return _theNewSelectedDataPickerView;
}

- (NSMutableDictionary *)theLastToServerPramedic {
    
    if (!_theLastToServerPramedic) {
        
        _theLastToServerPramedic = [[NSMutableDictionary alloc] init];
    }
    return _theLastToServerPramedic;
}
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    

    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.theNewSelectedDataPickerView.isNeddShowMoreDayChoiceBtn = YES;
        
    }else {
        
        self.theNewSelectedDataPickerView.isNeddShowMoreDayChoiceBtn = NO;
    }
    

    _theNewSelectedDataPickerView.selectedDate = _selectedDate?:[NSDate date];
    
    [_theNewSelectedDataPickerView show];
    
    _theNewSelectedDataPickerView.choiceData = ^(NSArray *dataArray, NSString *timeStr) {
        
    };
    
    
}

#pragma mark - JGJNewSelectedDataPickerViewDelegate
- (void)JGJNewSelectedDataPickerViewSelectedDate:(NSDate *)date {
    
    
    self.yzgGetBillModel.date = [self getWeekDaysString:date];
    _selectedDate = date;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.tinyYzgGetBillModel.date =  [self getWeekDaysString:date];
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
        
        self.contractYzgGetBillModel.date =  [self getWeekDaysString:date];
        [self getOutstandingAmount];
        
    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
        
        self.brrowYzgGetBillModel.date =  [self getWeekDaysString:date];
        [self getOutstandingAmount];
        
    }else{
        
        self.closeAccountyzgGetBillModel.date =  [self getWeekDaysString:date];
        [self getOutstandingAmount];
        
    }
    [_mainCollectionview reloadData];
}

- (void)JGJNewSelectedDataPickerViewClickMoreDayBtn {
    
    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
    [self.theNewSelectedDataPickerView hiddenPicker];
    
    if (self.isAgentMonitor) {
        
        moreDay.isAgentMonitor = self.isAgentMonitor;
        moreDay.agency_uid = self.agency_uid;
        
    }
    
    // 首页直接进入记单笔或者代班长进入记单笔页面
    if (self.isAgentMonitor || self.ChatType || self.markBillMore) {
        
        moreDay.WorkCircleProListModel = self.workProListModel;
    }
    moreDay.chatType = self.ChatType;
    moreDay.isMarkMoreBill = self.markBillMore;
    moreDay.Mainrecod = self.Mainrecord;
    YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
    JlgGetBillModel = self.tinyYzgGetBillModel;
    JlgGetBillModel.proname = self.tinyYzgGetBillModel.proname;
    JlgGetBillModel.pid = self.tinyYzgGetBillModel.pid;
    moreDay.JlgGetBillModel = JlgGetBillModel;
    
    [self.navigationController pushViewController:moreDay animated:YES];
}


- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    
    //聊天并且自己是创建者的时候，不能选择项目
    if ([self.workProListModel.myself_group boolValue]) {
        
        return;
    }
    
    [self querypro:^{
        
        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[JGJMarkBillViewController class]]) {
            
            JGJNewMarkBillChoiceProjectViewController *projectVC = [[JGJNewMarkBillChoiceProjectViewController alloc] init];
            projectVC.isMarkSingleBillComeIn = YES;
            projectVC.projectListVCDelegate = self;

            if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
                
                projectVC.billModel = self.tinyYzgGetBillModel;
                
            }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
                
                projectVC.billModel = self.contractYzgGetBillModel;
                
            }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType) {
                
                projectVC.billModel = self.brrowYzgGetBillModel;
                
            }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
                
                projectVC.billModel = self.closeAccountyzgGetBillModel;
            }
            
            [self.navigationController pushViewController:projectVC animated:YES];
        }
    }];
}

#pragma mark - JGJNewMarkBillChoiceProjectViewControllerDelagate
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.isClearEditMoney = NO;
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    
    if (projectModel) {
        
        self.yzgGetBillModel.proname = projectModel.pro_name;
        self.yzgGetBillModel.pid     = [projectModel.pro_id intValue];
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.tinyYzgGetBillModel.proname = projectModel.pro_name;
            self.tinyYzgGetBillModel.pid     = [projectModel.pro_id intValue];
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
            
            self.contractYzgGetBillModel.proname = projectModel.pro_name;
            self.contractYzgGetBillModel.pid     = [projectModel.pro_id intValue];
            
        }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
            
            self.brrowYzgGetBillModel.proname = projectModel.pro_name;
            self.brrowYzgGetBillModel.pid     = [projectModel.pro_id intValue];
        }else{
            
            self.closeAccountyzgGetBillModel.proname = projectModel.pro_name;
            self.closeAccountyzgGetBillModel.pid     = [projectModel.pro_id intValue];
            
        }
        [self.mainCollectionview reloadData];
    }
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    
    if (projectModel) {
        
        self.yzgGetBillModel.proname = @"";
        self.yzgGetBillModel.pid     = 0;
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.tinyYzgGetBillModel.proname = @"";
            self.tinyYzgGetBillModel.pid     = 0;
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
            
            self.contractYzgGetBillModel.proname = @"";
            self.contractYzgGetBillModel.pid     = 0;
            
        }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
            
            self.brrowYzgGetBillModel.proname = @"";
            self.brrowYzgGetBillModel.pid     = 0;
        }else{
            
            self.closeAccountyzgGetBillModel.proname = @"";
            self.closeAccountyzgGetBillModel.pid     = 0;
            
        }
        [self.mainCollectionview reloadData];
    }
}

- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}
- (void)showJLGPickerView:(NSIndexPath *)indexPath{
    
    [self.jlgPickerView.leftButton setTitle:@"新增" forState:UIControlStateNormal];
    [self.jlgPickerView.leftButton setImage:[UIImage imageNamed:@"RecordWorkpoints_BtnAdd"] forState:UIControlStateNormal];
    self.jlgPickerView.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.jlgPickerView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
    [self.jlgPickerView setAllSelectedComponents:nil];
    self.jlgPickerView.isShowEditButton = YES;//显示编辑按钮

    NSDictionary *dic;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {

        dic = @{
                @"name":self.yzgGetBillModel.proname?:@"",
                @"id":[NSString stringWithFormat:@"%ld",(long)self.yzgGetBillModel.pid]?:@"0"
                };
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {

        dic = @{
                @"name":self.contractYzgGetBillModel.proname?:@"",
                @"id":[NSString stringWithFormat:@"%ld",(long)self.contractYzgGetBillModel.pid]?:@"0"
                };
    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType) {

        dic = @{
                @"name":self.brrowYzgGetBillModel.proname?:@"",
                @"id":[NSString stringWithFormat:@"%ld",(long)self.brrowYzgGetBillModel.pid]?:@"0"
                };
    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {

        dic = @{
                @"name":self.closeAccountyzgGetBillModel.proname?:@"",
                @"id":[NSString stringWithFormat:@"%ld",(long)self.closeAccountyzgGetBillModel.pid]?:@"0"
                };
    }

    _saveProArr = [[NSMutableArray alloc]init];
    [_saveProArr addObject:dic];
    [self.jlgPickerView showPickerByrow:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO andArr:_saveProArr];
    
}
- (NSMutableArray *)proNameArray
{
    if (!_proNameArray) {
        
        _proNameArray = [[NSMutableArray alloc] init];
        
    }
    return _proNameArray;
}

-(void)querypro:(JGJMarkBillQueryproBlock)queryproBlock{
    
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        if (responseObject.count == 0) {
            [TYLoadingHub hideLoadingView];

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
            
            if (queryproBlock) {
                queryproBlock();
            }
        }
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}
#pragma mark -点击项目编辑按钮跳转页面
-(void)JGJPickViewEditButtonPressed:(NSArray *)dataArray
{
    JGJBillEditProNameViewController *editProNameVC = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillEditProNameViewController"];
    editProNameVC.dataArray = dataArray;
    __block NSArray *projectListArr = [[NSArray alloc] initWithArray:dataArray];
    [self.navigationController pushViewController:editProNameVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    editProNameVC.modifyThePorjectNameSuccess = ^(NSIndexPath *indexPath,NSString *changedName) {
      
        NSDictionary *projectDic = projectListArr[indexPath.row];
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            weakSelf.tinyYzgGetBillModel.proname = changedName;
            weakSelf.tinyYzgGetBillModel.pid     = [projectDic[@"id"] intValue];
            
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
            
            weakSelf.contractYzgGetBillModel.proname = changedName;
            weakSelf.contractYzgGetBillModel.pid     = [projectDic[@"id"] intValue];
            
        }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType) {
            
            weakSelf.brrowYzgGetBillModel.proname = changedName;
            weakSelf.brrowYzgGetBillModel.pid     = [projectDic[@"id"] intValue];
            
        }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
            
            weakSelf.closeAccountyzgGetBillModel.proname = changedName;
            weakSelf.closeAccountyzgGetBillModel.pid     = [projectDic[@"id"] intValue];
        }
        

        [weakSelf.mainCollectionview reloadData];
        [weakSelf showProjectPickerByIndexPath:indexPath];
    };
}
#pragma mark - 选择项目
-(void)JLGPickerViewSelect:(NSArray *)finishArray
{
//    _saveProArr = [[NSMutableArray alloc] initWithArray:finishArray];
    
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    if (finishArray.count) {
        self.yzgGetBillModel.proname = finishArray[0][@"name"];
        self.yzgGetBillModel.pid     = [finishArray[0][@"id"] intValue];
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.tinyYzgGetBillModel.proname =  finishArray[0][@"name"];;
            self.tinyYzgGetBillModel.pid     = [finishArray[0][@"id"]?:@"0" intValue];
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
            
            self.contractYzgGetBillModel.proname =  finishArray[0][@"name"];;
            self.contractYzgGetBillModel.pid     = [finishArray[0][@"id"]?:@"0" intValue];
            
        }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
            
            self.brrowYzgGetBillModel.proname =  finishArray[0][@"name"];;
            self.brrowYzgGetBillModel.pid     = [finishArray[0][@"id"]?:@"0" intValue];
        }else{
            
            self.closeAccountyzgGetBillModel.proname =  finishArray[0][@"name"];;
            self.closeAccountyzgGetBillModel.pid     = [finishArray[0][@"id"]?:@"0" intValue];
            
        }
        [self.mainCollectionview reloadData];
    }
    
    if (finishArray.count) {
        if ([finishArray.lastObject isEqual:@"取消"]) {
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];

            onlyAddProVc.superViewIsGroup = YES;
            onlyAddProVc.isCreatTeamEditProName = YES;
            onlyAddProVc.isPopUpVc = YES;
            onlyAddProVc.delegate = self;
            
            [self.navigationController pushViewController:onlyAddProVc animated:YES];
            
        }
    }
}

#pragma mark - 新建项目成功回调
- (void)addMemberSuccessWithResponse:(NSMutableDictionary *)proDic {
    
    NSString *changedName = proDic[@"pro_name"];
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.tinyYzgGetBillModel.proname = changedName;
        self.tinyYzgGetBillModel.pid     = [proDic[@"pid"] intValue];
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
        
        self.contractYzgGetBillModel.proname = changedName;
        self.contractYzgGetBillModel.pid     = [proDic[@"pid"] intValue];
        
    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType) {
        
        self.brrowYzgGetBillModel.proname = changedName;
        self.brrowYzgGetBillModel.pid     = [proDic[@"pid"] intValue];
        
    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
        
        self.closeAccountyzgGetBillModel.proname = changedName;
        self.closeAccountyzgGetBillModel.pid     = [proDic[@"pid"] intValue];
    }
    
    NSIndexPath *indexPach = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.mainCollectionview reloadData];
    [self showProjectPickerByIndexPath:indexPach];
}
#pragma mark - 备注
- (void)markBillRemark{
    
    self.isClearEditMoney = NO;
    JGJMarkBillRemarkViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillRemarkVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJMarkBillRemarkVC"];
    otherInfoVc.markBillRemarkDelegate = self;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
      
        self.tinyYzgGetBillModel.accounts_type.code = 1;
   
        otherInfoVc.yzgGetBillModel = self.tinyYzgGetBillModel;

    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType)
    {
        self.contractYzgGetBillModel.accounts_type.code = 2;
        otherInfoVc.yzgGetBillModel = self.contractYzgGetBillModel;

    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
        
        self.brrowYzgGetBillModel.accounts_type.code = 3;
        otherInfoVc.yzgGetBillModel = self.brrowYzgGetBillModel;

    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
        
        self.closeAccountyzgGetBillModel.accounts_type.code = 4;
        otherInfoVc.yzgGetBillModel = self.closeAccountyzgGetBillModel;

    }
    
    if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
        
        if (_contractorMakeType == JGJContractorMakeAttendanceType) {
            
            // 包工记考勤,去掉开工时间和结束时间
            otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
            
        }else {
            
            otherInfoVc.remarkBillType = JGJRemarkBillContractType;
        }
        
        
    }else{
        
        otherInfoVc.remarkBillType = JGJRemarkBillOtherType;
    }
    otherInfoVc.yzgGetBillModel.role = _roleType == 1?1:2;
    otherInfoVc.imagesArray = self.imagesArray;
    
    [self.navigationController pushViewController:otherInfoVc animated:YES];
    
}

- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText {
    
    self.imagesArray = images;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {

        self.tinyYzgGetBillModel.notes_img = images.copy;

    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
        
        self.contractYzgGetBillModel.notes_img = images.copy;

    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){

        self.brrowYzgGetBillModel.notes_img = images.copy;

    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){

        self.closeAccountyzgGetBillModel.notes_img = images.copy;
    }
    [self.mainCollectionview reloadData];
}

- (void)setRemarkYzgGetBillModel:(YZGGetBillModel *)remarkYzgGetBillModel
{
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {

        self.tinyYzgGetBillModel = remarkYzgGetBillModel;

    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType)
    {
        self.contractYzgGetBillModel = remarkYzgGetBillModel;
        
    }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){

        self.brrowYzgGetBillModel = remarkYzgGetBillModel;

    }else{

        self.closeAccountyzgGetBillModel = remarkYzgGetBillModel;
    }
    [self.mainCollectionview reloadData];
}
#pragma mark - 选择上班时间和加班时间
-(void)selectManHourTime:(NSString *)Manhour andOverHour:(NSString *)overTime
{
    self.tinyYzgGetBillModel.manhour = [Manhour floatValue];
    
    self.tinyYzgGetBillModel.overtime = [overTime floatValue];
    
    [self getSalary];
    
}
#pragma mark - 选择上班时间
-(void)selectManHourTime:(NSString *)Manhour
{

    _isChoiceManHourOrOverHour = YES;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.tinyYzgGetBillModel.manhour = [Manhour floatValue];
        if ([Manhour floatValue] == 0) {
            self.tinyYzgGetBillModel.isRest = YES;
        }
        [self getSalary];
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
        
        self.contractYzgGetBillModel.manhour = [Manhour floatValue];
        if ([Manhour floatValue] == 0) {
            
            self.contractYzgGetBillModel.isRest = YES;
        }
        
        [self.mainCollectionview reloadData];
    }
    

}
#pragma mark - 选择加班时间
-(void)selectOverHour:(NSString *)overTime
{
    
    _isChoiceManHourOrOverHour = YES;
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        self.tinyYzgGetBillModel.overtime = [overTime floatValue];
        if ([overTime floatValue] == 0) {
            self.tinyYzgGetBillModel.isOverWork = YES;
        }
        [self getSalary];
        
    }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
        
        self.contractYzgGetBillModel.overtime = [overTime floatValue];
        if ([overTime floatValue] == 0) {
            
            self.contractYzgGetBillModel.isOverWork = YES;
        }
        
        [self.mainCollectionview reloadData];
    }
    
}

#pragma mark - 快捷选择上班 加班时长
- (void)manHourViewSelectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime {
    
    _isChoiceManHourOrOverHour = YES;
    if (isManHourTime) {// 上班时间选择
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.tinyYzgGetBillModel.manhour = [timeSelected floatValue];
            if ([timeSelected floatValue] == 0) {
                self.tinyYzgGetBillModel.isRest = YES;
            }
            [self getSalary];
            
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
            
            self.contractYzgGetBillModel.manhour = [timeSelected floatValue];
            if ([timeSelected floatValue] == 0) {
                
                self.contractYzgGetBillModel.isRest = YES;
            }
            
            [self.mainCollectionview reloadData];
        }
    }else {
        
        if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {
            
            self.tinyYzgGetBillModel.overtime = [timeSelected floatValue];
            if ([timeSelected floatValue] == 0) {
                self.tinyYzgGetBillModel.isOverWork = YES;
            }
            [self getSalary];
            
        }else if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
            
            self.contractYzgGetBillModel.overtime = [timeSelected floatValue];
            if ([timeSelected floatValue] == 0) {
                
                self.contractYzgGetBillModel.isOverWork = YES;
            }
            
            [self.mainCollectionview reloadData];
        }
    }
}

#pragma mark - 处理包工
- (void)textFiledContractEditing:(NSString *)content andTag:(NSInteger)tag {
    
    if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
    
        if (tag == 10) {//分项名称
        
            self.contractYzgGetBillModel.sub_proname = content?:@"";
    
        }else if (tag == 11){//单价
   
            self.contractYzgGetBillModel.unitprice = [content?:@"0" doubleValue];
            
        }else if (tag == 12){//数量
       
            self.contractYzgGetBillModel.quantities = [content?:@"0" doubleValue];

        }
    }
}

- (void)JGJTextFieldEndEditing {
    
    if (self.markSlectBtnType == JGJMarkSelectContractBtnType){
        
        self.fillOutModel = _fillOutModel;
    }
    
}


- (void)textFiledBrrowEditing:(NSString *)content andTag:(NSInteger)tag
{
    if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
        if (tag == 10) {
            
            self.brrowYzgGetBillModel.browNum = content?:@"0";
        }
    }
}

- (void)CalculationAmount {
    
    double totalCalculation = [self.closeAccountyzgGetBillModel.subsidy_amount doubleValue] + [self.closeAccountyzgGetBillModel.reward_amount doubleValue] - [self.closeAccountyzgGetBillModel.penalty_amount doubleValue];
    self.closeAccountyzgGetBillModel.totalCalculation = [NSString stringWithFormat:@"%.2f",totalCalculation];
    
    
    self.closeAccountyzgGetBillModel.settlementAmount =  [NSString stringWithFormat:@"%.2f",self.closeAccountyzgGetBillModel.salary + [self.closeAccountyzgGetBillModel.deduct_amount doubleValue] + [self.closeAccountyzgGetBillModel.penalty_amount doubleValue] - [self.closeAccountyzgGetBillModel.subsidy_amount doubleValue] - [self.closeAccountyzgGetBillModel.reward_amount doubleValue]];
    
    self.closeAccountyzgGetBillModel.remainingAmount = [NSString stringWithFormat:@"%.2f",[self.closeAccountyzgGetBillModel.balance_amount doubleValue] + [self.closeAccountyzgGetBillModel.subsidy_amount doubleValue] + [self.closeAccountyzgGetBillModel.reward_amount doubleValue] - [self.closeAccountyzgGetBillModel.penalty_amount doubleValue] - self.closeAccountyzgGetBillModel.salary - [self.closeAccountyzgGetBillModel.deduct_amount                                                                                                                                                                                                                                                                        doubleValue]];
    
}
#pragma mark - 编辑金额
-(void)closeAccountTextfiledEditing:(NSString *)content andtag:(NSInteger)tag
{
    if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
        if (tag == 21) {//补贴金额
            if ([NSString isEmpty:content]) {
                
            self.closeAccountyzgGetBillModel.subsidy_amount =@"0.00";

            }else{
            self.closeAccountyzgGetBillModel.subsidy_amount = content;
            }
        }else if (tag == 22){//奖励金额
            if ([NSString isEmpty:content]) {
                
                self.closeAccountyzgGetBillModel.reward_amount = @"0.00";

            }else{
                self.closeAccountyzgGetBillModel.reward_amount = content;

            }
        }else if (tag == 23){//罚款金额
            if ([NSString isEmpty:content]) {
                
                self.closeAccountyzgGetBillModel.penalty_amount = @"0.00";

            }else{
                self.closeAccountyzgGetBillModel.penalty_amount = content;

            }
        }else if (tag == 40){//本次实收/付金额
          
            if ([NSString isEmpty:content]) {
        
                self.closeAccountyzgGetBillModel.salary = 0.00;
                _isClearEditMoney = YES;
          
            }else{
            
                self.closeAccountyzgGetBillModel.salary = [content doubleValue];
            }
            _markEditeMoney = self.closeAccountyzgGetBillModel.salary;
        }else if (tag == 41){//抹零金额
            if ([NSString isEmpty:content]) {
                self.closeAccountyzgGetBillModel.deduct_amount = @"0.00";
            }else{
                self.closeAccountyzgGetBillModel.deduct_amount = content;
            }
        }
    }
    
    [self CalculationAmount];
}
#pragma mark - 工资结算获取未结算金额
- (void)getOutstandingAmount
{
    NSString *markBillType;
    YZGGetBillModel *model = [[YZGGetBillModel alloc]init];

    switch (self.markSlectBtnType) {
        case JGJMarkSelectTinyBtnType:
            markBillType = @"1";
            model = self.tinyYzgGetBillModel;
            break;
        case JGJMarkSelectContractBtnType:
            
            markBillType = @"2";

            model = self.contractYzgGetBillModel;
            break;
        case JGJMarkSelectBrrowBtnType:
            markBillType = @"3";
            model = self.brrowYzgGetBillModel;
            break;
        case JGJMarkSelectCloseAccountBtnType:
            markBillType = @"4";
            model = self.closeAccountyzgGetBillModel;
            break;
        default:
            break;
    }
    NSString *dateStr;
    if (![NSString isEmpty:model.date]) {
        if ([model.date containsString:@"(今天)"]) {
            dateStr = [model.date stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
        }else if ([model.date containsString:@"-"]){
            dateStr = [model.date stringByReplacingOccurrencesOfString:@"-" withString:@""];

        }
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(model.uid)?:@"" forKey:@"uid"];
    [dic setObject:markBillType?:@"" forKey:@"accounts_type"];
    [dic setObject:dateStr?:@"" forKey:@"date"];
    if (self.isAgentMonitor || self.getTpl) {

        [dic setObject:self.workProListModel.group_id forKey:@"group_id"];

    }
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/getUnbalanceAndSalaryTpl" parameters:dic success:^(id responseObject) {
        JGJNoPayAmount *payModel = [JGJNoPayAmount mj_objectWithKeyValues:responseObject];
        
        if (self.markSlectBtnType == JGJMarkSelectContractBtnType) {
            
            self.contractYzgGetBillModel.bill_num = payModel.bill_num;
            self.contractYzgGetBillModel.bill_desc = payModel.bill_desc;

        }else if (self.markSlectBtnType == JGJMarkSelectBrrowBtnType){
           
            self.brrowYzgGetBillModel.bill_num = payModel.bill_num;
            self.brrowYzgGetBillModel.bill_desc = payModel.bill_desc;
        

        }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){
            
            self.closeAccountyzgGetBillModel.balance_amount = payModel.balance_amount;
            self.closeAccountyzgGetBillModel.salary = _markEditeMoney;
            self.closeAccountyzgGetBillModel.un_salary_tpl = payModel.un_salary_tpl;
            self.closeAccountyzgGetBillModel.salary_desc = payModel.salary_desc;
            self.closeAccountyzgGetBillModel.bill_num = payModel.bill_num;
            self.closeAccountyzgGetBillModel.bill_desc = payModel.bill_desc;
            
            [self CalculationAmount];
        }
        
        [self.mainCollectionview reloadData];
        
    }failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - 获取先写的单位
-(void)setFillOutModel:(JGJFilloutNumModel *)fillOutModel
{
    if (fillOutModel.Num && fillOutModel.priceNum) {
        _fillOutModel = [JGJFilloutNumModel new];
        _fillOutModel = fillOutModel;
        self.contractYzgGetBillModel.quantities = [[NSString stringWithFormat:@"%@",fillOutModel.Num] doubleValue];
        self.contractYzgGetBillModel.units = fillOutModel.priceNum;
        self.contractYzgGetBillModel.salary = _contractYzgGetBillModel.quantities * _contractYzgGetBillModel.unitprice;
        [self.mainCollectionview reloadData];
        
    }
}
#pragma mark -保存最近一次非班组项目组的记账人信息
-(void)saveLastRecordBill
{
    if (!_markBillMore && JLGisMateBool) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSDictionary *tpl = @{
                              @"s_tpl":@(self.tinyYzgGetBillModel.set_tpl.s_tpl),
                              @"w_h_tpl":@(self.tinyYzgGetBillModel.set_tpl.w_h_tpl),
                              @"o_h_tpl":@(self.tinyYzgGetBillModel.set_tpl.o_h_tpl)
                              };
        [dic setObject:self.tinyYzgGetBillModel.name?:@"" forKey:@"name"];
        [dic setObject:@(self.tinyYzgGetBillModel.uid)?:@"" forKey:@"uid"];
        [dic setObject:self.tinyYzgGetBillModel.phone_num?:@"" forKey:@"telph"];
        [dic setObject:tpl?:@"" forKey:@"tpl"];
        [dic setObject:@(self.tinyYzgGetBillModel.set_tpl.s_tpl)?:@"" forKey:@"s_tpl"];
        [dic setObject:self.tinyYzgGetBillModel.head_pic?:@"" forKey:@"head_pic"];
        [dic setObject:@(self.tinyYzgGetBillModel.set_tpl.w_h_tpl)?:@"" forKey:@"w_h_tpl"];
        [dic setObject:@(self.tinyYzgGetBillModel.set_tpl.o_h_tpl)?:@"" forKey:@"o_h_tpl"];
        [TYUserDefaults setObject:dic forKey:JLGLastRecordBillPeople];
    }
}
- (void)saveDataToServer{
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {//点工
        if (!self.tinyYzgGetBillModel.name) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.tinyYzgGetBillModel.date) {
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }else  if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl || !self.tinyYzgGetBillModel.set_tpl.o_h_tpl || self.tinyYzgGetBillModel.set_tpl.w_h_tpl < 0) {
            [TYShowMessage showPlaint:@"请设置工资标准"];
            return;
        }
        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = self.tinyYzgGetBillModel;
        
    }else if(self.markSlectBtnType == JGJMarkSelectContractBtnType){//包工
        
        if ([NSString isEmpty: self.contractYzgGetBillModel.name ]) {
            
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            
            return;
        }
        else if (!self.contractYzgGetBillModel.quantities||!self.contractYzgGetBillModel.unitprice) {
            
            if (_contractorMakeType == JGJContractorMakeAccountType) {
                
                [TYShowMessage showPlaint:@"请设置单价和数量"];
                return;
            }
            
        }

        
        if (_contractorMakeType == JGJContractorMakeAttendanceType) {
            
            if (self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl == 0 || self.contractYzgGetBillModel.unit_quan_tpl.o_h_tpl == 0) {
                
                [TYShowMessage showPlaint:@"请设置考勤模板"];
                return;
            }
        }

        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = self.contractYzgGetBillModel;
        
    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){//借支
        
        if ([NSString isEmpty:self.brrowYzgGetBillModel.name ]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
       else if (!self.brrowYzgGetBillModel.browNum ||[self.brrowYzgGetBillModel.browNum doubleValue] == 0) {
            [TYShowMessage showPlaint:@"请输入借支金额"];
            return;
        }
        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = self.brrowYzgGetBillModel;
        
    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType){// 结算
        
        if ([NSString isEmpty: self.closeAccountyzgGetBillModel.name]) {
            
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
            
        }else if ([NSString isEmpty:self.closeAccountyzgGetBillModel.date]) {
            
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }else if (!self.closeAccountyzgGetBillModel.subsidy_amount
                  && !self.closeAccountyzgGetBillModel.reward_amount
                  && !self.closeAccountyzgGetBillModel.penalty_amount
                  && !self.closeAccountyzgGetBillModel.salary){
            
            if (JLGisLeaderBool) {
                [TYShowMessage showPlaint:@"补贴、奖励、罚款金额和本次实付金额不能同时为0"];

            }else{
                [TYShowMessage showPlaint:@"补贴、奖励、罚款金额和本次实收金额不能同时为0"];

            }
            
            return;
        }
        self.yzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.yzgGetBillModel = self.closeAccountyzgGetBillModel;
    }
    
    self.parametersDic = [NSMutableDictionary dictionary];
    self.parametersDic[@"id"] = [NSString stringWithFormat:@"%ld",(long)self.addForemanModel.uid];
    self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    if (!self.yzgGetBillModel.voice_length) {
        self.yzgGetBillModel.voice_length = 0;
    }
    
    self.parametersDic[@"voice_length"] = [NSString stringWithFormat:@"%ld",(long)self.yzgGetBillModel.voice_length ];
    self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid)?:@"";
    
    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
    //只获取日期
    if ([NSString isEmpty:self.yzgGetBillModel.date]) {
        self.yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    
    if (self.markSlectBtnType == JGJMarkSelectTinyBtnType) {//点工
        
        self.parametersDic[@"accounts_type"] = @1;
        self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
        self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
        self.parametersDic[@"salary_tpl"] = @(self.yzgGetBillModel.set_tpl.s_tpl);
        self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.w_h_tpl);
        self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.o_h_tpl);
        
    }else if(self.markSlectBtnType == JGJMarkSelectContractBtnType){//包工
        
        // 包工记考勤 accounts_type
        if (_contractorMakeType == JGJContractorMakeAttendanceType) {
            
            self.parametersDic[@"accounts_type"] = @(5);
            self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
            self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
            self.parametersDic[@"pro_name"] = self.yzgGetBillModel.proname ? :@"";
            self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.unit_quan_tpl.w_h_tpl);
            self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.unit_quan_tpl.o_h_tpl);
            self.parametersDic[@"salary_tpl"] = @(0);

        }
        // 包工记账
        else {
            
            self.parametersDic[@"accounts_type"] = @2;
            self.parametersDic[@"quantity"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.quantities];
            self.parametersDic[@"unit_price"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.unitprice];
            self.parametersDic[@"p_s_time"] = self.yzgGetBillModel.p_s_time?:@"0";
            self.parametersDic[@"p_e_time"] = self.yzgGetBillModel.p_e_time?:@"0";
            self.parametersDic[@"sub_pro_name"] = self.yzgGetBillModel.sub_proname?:@"";
            self.parametersDic[@"units"] = self.yzgGetBillModel.units?:@"";
        }
        
    }else if(self.markSlectBtnType == JGJMarkSelectBrrowBtnType){//借支
        
        self.parametersDic[@"accounts_type"] = @3;
        self.parametersDic[@"salary"] = self.yzgGetBillModel.browNum;
        
    }else if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType)
    {
        self.parametersDic[@"accounts_type"] = @4;
        self.parametersDic[@"salary"] = @(self.yzgGetBillModel.salary?:0);
        self.parametersDic[@"balance_amount"] = self.yzgGetBillModel.balance_amount?:@"0";//未结
        self.parametersDic[@"subsidy_amount"] = self.yzgGetBillModel.subsidy_amount?:@"0";//补贴
        self.parametersDic[@"reward_amount"]  = self.yzgGetBillModel.reward_amount?:@"0";//奖金
        self.parametersDic[@"penalty_amount"] = self.yzgGetBillModel.penalty_amount?:@"0";//惩罚
        self.parametersDic[@"deduct_amount"]  = self.yzgGetBillModel.deduct_amount?:@"0";//抹零

    }
    [self ModifyRelase:self.parametersDic dataArray:self.yzgGetBillModel.dataArr dataNameArray:self.yzgGetBillModel.dataNameArr];
}
#pragma mark - 提交数据到服务器，用于子类重写
// 记账接口
- (void)ModifyRelase:(NSDictionary *)parametersDic dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray{
    
    [self.view endEditing:YES];
    NSMutableDictionary *parametersDicRelase = [parametersDic mutableCopy];
    [parametersDicRelase removeObjectForKey:@"id"];
    if (_ChatType) {
        
        [parametersDicRelase setValue:[self.workProListModel.myself_group?:@"" isEqualToString:@"1"]?@"2":@"1" forKey:@"my_role_type"];
        [parametersDicRelase setValue:[NSString stringWithFormat:@"%@",self.workProListModel.pro_id] forKey:@"gpid"];
        [parametersDicRelase setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
    }

    self.theLastToServerPramedic = parametersDicRelase;
    if (self.markSlectBtnType == JGJMarkSelectCloseAccountBtnType) {
        
        __weak typeof(self) weakSelf = self;
        JGJCloseAnAccountInfoAlertView *accountInfoAlertView = [[JGJCloseAnAccountInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        
        [accountInfoAlertView setCurrentCloseAnCountMoney:weakSelf.yzgGetBillModel.settlementAmount leftMoney:weakSelf.yzgGetBillModel.remainingAmount];
        [accountInfoAlertView show];
        
        // 修改
        accountInfoAlertView.modify = ^{
          
            return;
        };
        
        accountInfoAlertView.submit = ^{
            
            [weakSelf saveLastRecordBill];
            [weakSelf submitDateToServerWithParametersDicRelase:parametersDicRelase dataArray:dataArray dataNameArray:dataNameArray];
            
        };
        
        
    }else {
        
        [self saveLastRecordBill];
        [self submitDateToServerWithParametersDicRelase:parametersDicRelase dataArray:dataArray dataNameArray:dataNameArray];
    }
    
}


 - (void)submitDateToServerWithParametersDicRelase:(NSDictionary *)parametersDicRelase dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray {
     
     NSString *jesonPa = [@[parametersDicRelase] mj_JSONString];
     NSMutableDictionary *parameDic = [[NSMutableDictionary alloc] init];
     
     [parameDic setObject:jesonPa forKey:@"info"];
     if ([_is_next_act integerValue] == 1) {
         
         [parameDic setObject:@"1" forKey:@"is_next_act"];
         
         if (![NSString isEmpty:self.workProListModel.group_id]) {
             
             [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];

         }
         
         if (![NSString isEmpty:self.agency_uid]) {
             
             [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
  
         }
         
     }else {
         
         if (![NSString isEmpty:self.workProListModel.group_id]) {
             
             [parameDic setObject:self.workProListModel.group_id forKey:@"group_id"];
         }
         
         if (![NSString isEmpty:self.agency_uid]) {
             
             [parameDic setObject:self.agency_uid forKey:@"agency_uid"];
         }
     }
     [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
     [JLGHttpRequest_AFN newUploadImagesWithApi:@"workday/relase" parameters:parameDic imagearray:self.imagesArray otherDataArray:[dataArray copy] dataNameArray:[dataNameArray copy] success:^(id responseObject) {
         
         [TYLoadingHub hideLoadingView];

         if (self.markSlectBtnType == JGJMarkSelectTinyBtnType || (self.markSlectBtnType == JGJMarkSelectContractBtnType && _contractorMakeType == JGJContractorMakeAttendanceType)) {
             NSDictionary *dic = responseObject;
             if ([dic[@"is_exist"] integerValue] == 1) {
                 
                 _is_next_act = dic[@"is_next_act"];
                 _treadid = dic[@"record_id"];
                 _date = dic[@"date"];
                 _uid = dic[@"uid"];
                 _accounts_type = dic[@"accounts_type"];
                 [self gotoTransfVcAndTitle:dic[@"msg"]];
                 
                 return ;
             }
         }
         
         _isSaveToServerSuccess = YES;
         _isClearEditMoney = YES;
         
         // v3.4.1 cc 添加
         if (JLGisLeaderBool) {// 工头角色 判断当前所选的项目是否有班组,这种判断只会在第一次给工人记工且选择的项目没有班组时出现
             
             // 判断项目没有创建班组提示是否弹出过
             NSString *proIsALert = [TYUserDefaults objectForKey:@"proIsALertKey"];
             NSArray *proArr = [proIsALert componentsSeparatedByString:@","];
             NSString *currentPid = [NSString stringWithFormat:@"%@",self.parametersDic[@"pid"]];
             BOOL isHaveAlert = NO;
             for (NSString *alertPid in proArr) {
                 
                 if ([alertPid isEqualToString:currentPid]) {
                     
                     isHaveAlert = YES;
                     break;
                 }
             }
             //group_id 1:表示有班组，0:表示没有班组 如果是全局是工人角色，不会返回此字段
             NSString *group_id = responseObject[@"group_id"];
             NSDictionary *dic = responseObject;
             if ([group_id integerValue] == 0 && dic.allKeys.count > 0 && !isHaveAlert) { // 这里加个控制 只弹出一次
                 
                 NSString *hasAlertProStr;
                 if ([NSString isEmpty:proIsALert]) {
                     
                     hasAlertProStr = [NSString stringWithFormat:@"%@",self.parametersDic[@"pid"]];
                     
                 }else {
                     
                     hasAlertProStr = [NSString stringWithFormat:@"%@,%@",proIsALert,self.parametersDic[@"pid"]];
                 }
                 
                 [TYUserDefaults setObject:hasAlertProStr forKey:@"proIsALertKey"];
                 
                 JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];

                 desModel.popDetail = [NSString stringWithFormat:@"如果你对[%@]项目新建一个班组，添加成员后，就可以对所有工人批量记工了。\n新建班组吗？",self.yzgGetBillModel.proname];
                 desModel.leftTilte = @"取消";
                 desModel.rightTilte = @"新建班组";
                 JGJCusSeniorPopView *alertView = [JGJCusSeniorPopView showWithMessage:desModel];
                 alertView.isMarkSingleBillComeIn = YES;
                 
                 __weak typeof(self) weakSelf = self;
                 // 新建班组
                 alertView.onOkBlock = ^{
                     
                     JGJCreatTeamVC *creatTeamVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatTeamVC"];
                     
                     JGJProjectListModel *accountProModel = [JGJProjectListModel new];
                     
                     accountProModel.pro_name = weakSelf.yzgGetBillModel.proname;
                     
                     accountProModel.pro_id = [NSString stringWithFormat:@"%ld",weakSelf.yzgGetBillModel.pid];
                     
                     creatTeamVC.accountProModel = accountProModel;
                     
                     [weakSelf manegerCleanCurrentPageData];
                     [self.navigationController pushViewController:creatTeamVC animated:YES];
                 };
                 
                 // 取消
                 alertView.leftButtonBlock = ^{
                     
                     [weakSelf manegerCleanCurrentPageData];
                     
                 };
                 
                 return;
             }
                          
         }
         JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
         desModel.popTextAlignment = NSTextAlignmentCenter;
         desModel.lineSapcing = 4;
         JGJCusAlertView *alerView = [JGJCusAlertView cusAlertViewShowWithDesModel:desModel];
         
         // 工人登陆点击左侧按钮为再记一笔事件/右侧按钮为返回上级事件，班组长登陆则相反 3.1.0v cc修改
         if (JLGisMateBool) {
             
             TYLog(@"工人登陆");
             alerView.customLeftButtonAlertViewBlock = ^{
                 
                 TYLog(@"再记一笔");
                 _selectedDate = nil;
                 YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
                 oldBillModel.proname = self.yzgGetBillModel.proname;
                 oldBillModel.pid = self.yzgGetBillModel.pid;
                 oldBillModel.name = self.yzgGetBillModel.name;
                 oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
                 oldBillModel.unit_quan_tpl = self.yzgGetBillModel.unit_quan_tpl;
                 
                 //如果是从聊天进入  则荏苒要默认工头名字
                 if (_ChatType) {
                     
                     [self mainGoinGetTPL];
                     
                 }else{
                     
                     self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
                     self.contractYzgGetBillModel = [[YZGGetBillModel alloc]init];
                     self.brrowYzgGetBillModel = [[YZGGetBillModel alloc]init];
                     self.closeAccountyzgGetBillModel = [[YZGGetBillModel alloc]init];
                     
                     _fillOutModel = [JGJFilloutNumModel new];
                     if (_markBillMore) {
                         self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
                         self.yzgGetBillModel.pid = oldBillModel.pid;
                     }
                     [self.mainCollectionview reloadData];
                     
                 }
             };
             
             alerView.customRightButtonAlertViewBlock = ^{//返回上级
                 BOOL isHave = NO;
                 if (self.markBillMore) {
                     for (UIViewController *vc in self.navigationController.viewControllers) {
                         
                         if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]) {

                             isHave = YES;
                             break;
                             
                         }else if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]){
                             

                             isHave = YES;
                             break;
                         }else if ([vc isKindOfClass:[JGJMorePeopleViewController class]]){
                             
                             
                             isHave = YES;
                             break;
                         }
                     }
                     if (!isHave) {
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }else {
                         
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }else{
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 
             };
             
             
         }else {
             
             TYLog(@"班组长登陆");
             alerView.customLeftButtonAlertViewBlock = ^{
                 
                 BOOL isHave = NO;
                 TYLog(@"返回上一级");
                 if (self.markBillMore) {
                     for (UIViewController *vc in self.navigationController.viewControllers) {

                         if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]) {

                             isHave = YES;
                             break;
                             
                         }else if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]){
                             

                             isHave = YES;
                             break;
                         }else if ([vc isKindOfClass:[JGJMorePeopleViewController class]]){
                             
                             
                             isHave = YES;
                             break;
                         }
                     }
                     
                     if (!isHave) {
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                         
                     }else {
                         
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }else{
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             };
             
             alerView.customRightButtonAlertViewBlock = ^{//再记一笔
                 
                 [self manegerCleanCurrentPageData];
             };
             
         }
         if (self.imagesArray) {
             
             [self.imagesArray removeAllObjects];
         }
         
     } failure:^(NSError *error) {
         
         [TYLoadingHub hideLoadingView];
     }];
 }

// 班组长清除当前页面数据
- (void)manegerCleanCurrentPageData {
    
    _selectedDate = nil;
    YZGGetBillModel *oldBillModel = [[YZGGetBillModel alloc]init];
    oldBillModel.proname = self.yzgGetBillModel.proname;
    oldBillModel.pid = self.yzgGetBillModel.pid;
    oldBillModel.name = self.yzgGetBillModel.name;
    oldBillModel.set_tpl = self.yzgGetBillModel.set_tpl;
    self.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    _isClearEditMoney = YES;
    //如果是从聊天进入  则荏苒要默认工头名字
    if (_markBillMore) {
        
#pragma mark - 添加
        self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.contractYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.brrowYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.closeAccountyzgGetBillModel = [[YZGGetBillModel alloc]init];
        
        self.tinyYzgGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.tinyYzgGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        self.contractYzgGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.contractYzgGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        self.brrowYzgGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.brrowYzgGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        self.closeAccountyzgGetBillModel.proname = _workProListModel.all_pro_name?:@"";
        self.closeAccountyzgGetBillModel.pid = [_workProListModel.pro_id?:@"0"  longLongValue];
        
        [self.mainCollectionview reloadData];
        
    }else{
        
        self.tinyYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.contractYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.brrowYzgGetBillModel = [[YZGGetBillModel alloc]init];
        self.closeAccountyzgGetBillModel = [[YZGGetBillModel alloc]init];
        
        _fillOutModel = [JGJFilloutNumModel new];
        if (_markBillMore) {
            
            self.yzgGetBillModel.proname = oldBillModel.all_pro_name;
            self.yzgGetBillModel.pid = oldBillModel.pid;
        }
        
        [self.mainCollectionview reloadData];
        
    }
    if (self.imagesArray) {
        
        [self.imagesArray removeAllObjects];
    }
}
- (void)gotoTransfVcAndTitle:(NSString *)title{
    
    // 可以继续走接口
    if ([_is_next_act integerValue] == 1) {

        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"取消",@"继续保存", nil];
        [alert setButtonTitleColor:AppFont000000Color fontSize:AppFont30Size atIndex:0];
        [alert setButtonTitleColor:AppFontEB4E4EColor fontSize:AppFont30Size atIndex:1];
        alert.messageLabel.textAlignment = NSTextAlignmentLeft;
        [alert.messageLabel setAttributedStringText:title lineSapcing:5];
        alert.messageLabel.textColor = AppFont000000Color;
        alert.messageLabel.font = FONT(AppFont32Size);
        alert.messageLabelOffset = 35;
        alert.isHiddenDeleteBtn = YES;
        [alert show];

    }else {

        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:title delegate:self buttonTitles:@"查看该记账", nil];
        alert.messageLabel.textAlignment = NSTextAlignmentLeft;
        alert.messageLabel.font = FONT(AppFont32Size);
        alert.messageLabel.textColor = AppFont000000Color;
        alert.messageLabelOffset = 35;
        [alert show];
    }
    
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([_is_next_act integerValue] == 1) {
        
        if (buttonIndex == 1) {
            
            [self submitDateToServerWithParametersDicRelase:self.theLastToServerPramedic dataArray:self.yzgGetBillModel.dataArr dataNameArray:self.yzgGetBillModel.dataNameArr];
            
        }else {
            
            _is_next_act = nil;
        }
    }else {// 已经记过两笔账了，根据有无uid去判断界面跳转，有uid跳待确认，没有跳每日考勤界面
        
        if (_uid == nil) {

            if (self.isAgentMonitor) {

                JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
                recordWorkpointsVc.proListModel = self.workProListModel;
                [self.navigationController pushViewController:recordWorkpointsVc animated:YES];

            }else {

                YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
                yzgMateWorkitemsVc.searchDate = [NSDate dateFromString:_date withDateFormat:@"yyyyMMdd"];
                [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
            }

        }else {

            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = _date;
            poorBillVC.uid = _uid;
            if (self.isAgentMonitor) {

                poorBillVC.agency_uid = self.agency_uid;
                poorBillVC.group_id = self.workProListModel.group_id;

            }
            [self.navigationController pushViewController:poorBillVC animated:YES];


        }
        
    }
    
    [alertView hide];
    alertView.delegate = nil;
    alertView = nil;
    
}

// alertView消失时
- (void)alertViewHide {
    
    _is_next_act = nil;
}

- (MateWorkitemsItems *)TransformModel:(YZGGetBillModel *)wageBestDetailWorkday{
    
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.overtime = [NSString stringWithFormat:@"%f",wageBestDetailWorkday.overtime];
    mateWorkitemsItem.uid = wageBestDetailWorkday.uid ;
    mateWorkitemsItem.amounts = wageBestDetailWorkday.salary;
    mateWorkitemsItem.manhour = [NSString stringWithFormat:@"%f",wageBestDetailWorkday.manhour ];
    mateWorkitemsItem.name = wageBestDetailWorkday.name;
    mateWorkitemsItem.accounts_type.txt = wageBestDetailWorkday.accounts_type.txt;
    mateWorkitemsItem.accounts_type.code = [_accounts_type integerValue];
    mateWorkitemsItem.overtime = [NSString stringWithFormat:@"%f", wageBestDetailWorkday.overtime];
    mateWorkitemsItem.id =  [_treadid integerValue]?:0;
    mateWorkitemsItem.record_id = _treadid;
    mateWorkitemsItem.role = JLGisLeaderBool?1:2;
    return mateWorkitemsItem;
}
#pragma mark - 点击保存
-(void)clickJGJBottomBtnViewBtn
{

    [self saveDataToServer];
    
}
#pragma mark - 查看无金额点工
-(void)clickNoSalaryTplBtn
{
    JGJUnWagesShortWorkVc *shortWorkVc = [JGJUnWagesShortWorkVc new];
    
    shortWorkVc.uid = [NSString stringWithFormat:@"%ld", (long)self.closeAccountyzgGetBillModel.uid];
    
    [self.navigationController pushViewController:shortWorkVc animated:YES];
}
- (void)JLGDataPickerClickMoredayButton
{
    if (self.tinyYzgGetBillModel.set_tpl.w_h_tpl <= 0 || self.tinyYzgGetBillModel.set_tpl.o_h_tpl <= 0) {
        
        [TYShowMessage showPlaint:@"请设置工资标准"];
        return;
    }
    JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
    [self.jlgDatePickerView hiddenDatePicker];
    moreDay.chatType = self.ChatType;
    moreDay.Mainrecod = self.Mainrecord;
    moreDay.JlgGetBillModel = self.tinyYzgGetBillModel;
    [self.navigationController pushViewController:moreDay animated:YES];
}

#pragma mark - 点工
- (void)didSelectTinyTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model
{

    if (indexpath.section == 0 && indexpath.row == 1) {

        if ([NSString isEmpty:self.tinyYzgGetBillModel.name]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }
 
    else if (indexpath.section == 1){
        
        if ([NSString isEmpty: self.tinyYzgGetBillModel.name ]) {
           
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
        else if ([NSString isEmpty:self.tinyYzgGetBillModel.date]) {
            
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
        else if (indexpath.row > 0) {
            
            if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl || !self.tinyYzgGetBillModel.set_tpl.o_h_tpl || self.tinyYzgGetBillModel.set_tpl.w_h_tpl < 0) {
                [TYShowMessage showPlaint:@"请设置工资标准"];
                return;
            }
        }
        
    }else if (indexpath.section == 2){
        if (!self.tinyYzgGetBillModel.name) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
        else if (!self.tinyYzgGetBillModel.date) {
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
        else  if (!self.tinyYzgGetBillModel.set_tpl.w_h_tpl || !self.tinyYzgGetBillModel.set_tpl.o_h_tpl || self.tinyYzgGetBillModel.set_tpl.w_h_tpl < 0) {
            [TYShowMessage showPlaint:@"请设置工资标准"];
            return;
        }
        
    }
 
    if (indexpath.section == 0) {
        
        if (indexpath.row == 0) {
            
            if (_ChatType) {
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.tinyYzgGetBillModel];
            
        }else if (indexpath.row == 1){
           
            [self showDatePickerByIndexPath:indexpath];
        }
        
    }else if (indexpath.section == 1){
        if (indexpath.row == 0) {
            
            JGJWageLevelViewController *WageLevelVc =[[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
            WageLevelVc.isAgentMonitor = self.isAgentMonitor;
            WageLevelVc.yzgGetBillModel = _tinyYzgGetBillModel;
            [self.navigationController pushViewController:WageLevelVc animated:YES];
            
        }else if (indexpath.row == 1){
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.tinyYzgGetBillModel isShowHalfOrOneSelectedView:YES];
            
        }else if (indexpath.row == 2){
            
            [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.tinyYzgGetBillModel isShowHalfOrOneSelectedView:YES];

            
        }
    }else{
        
        if (indexpath.row == 0) {
            
            [self showProjectPickerByIndexPath:indexpath];
            
        }else if (indexpath.row == 1){
            
            [self markBillRemark];
            
        }
    }
}
#pragma mark - 包工
-(void)didSelectContractTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model
{
    [self.view endEditing:YES];

    if (indexpath.section == 0 && indexpath.row == 1) {
        if ([NSString isEmpty: self.contractYzgGetBillModel.name ]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }else if (indexpath.section == 2){
        if (!self.contractYzgGetBillModel.name) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.contractYzgGetBillModel.date) {
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
    }

    if (indexpath.section == 0) {
        
        if (indexpath.row == 0) {

            if (_ChatType) {
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.contractYzgGetBillModel];
            
        }else if (indexpath.row == 1){
            
            [self showDatePickerByIndexPath:indexpath];
            
        }else{
            
            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = self.contractYzgGetBillModel.date?:@"";
            poorBillVC.uid = [NSString stringWithFormat:@"%ld",(long)self.contractYzgGetBillModel.uid];
            
            //包工类型
            poorBillVC.accounts_type = @"2";
            
            [self.navigationController pushViewController:poorBillVC animated:YES];
        }
    }else if (indexpath.section == 1){
        
        if (indexpath.row == 2) {
            
            JGJPackNumViewController *changeToVc = [[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
            JGJFilloutNumModel *model = [[JGJFilloutNumModel alloc]init];
            
            model.priceNum = self.contractYzgGetBillModel.units?:@"";
            model.Num = [NSString stringWithFormat:@"%.2f", self.contractYzgGetBillModel.quantities];
            
            changeToVc.filloutmodel = model;
            [self.navigationController pushViewController:changeToVc animated:YES];
        }
        
    }else{
        if (indexpath.row == 0) {

            [self showProjectPickerByIndexPath:indexpath];
            
        }else if (indexpath.row == 1){
            [self markBillRemark];
            
        }
        
    }
    
}

#pragma mark - JGJContractorMakeAttendanceViewCellDelegate
- (void)didSelectContractTableViewWithContractorMakeType:(JGJContractorMakeType)contractorType {
    
    _contractorMakeType = contractorType;
}
- (void)didSelectContractTableViewFromIndexpath:(NSIndexPath *)indexpath WithContractorMakeType:(JGJContractorMakeType)contractorType {
    
    
    [self.view endEditing:YES];
    
    if (indexpath.section == 0 && indexpath.row == 1) {
        
        if ([NSString isEmpty: self.contractYzgGetBillModel.name ]) {
            
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }else if ((indexpath.section == 0 && indexpath.row == 3) ){
        
        if (!self.contractYzgGetBillModel.name) {
            
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.contractYzgGetBillModel.date) {
            
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
    }else if ((indexpath.section == 1 && indexpath.row == 1) || (indexpath.section == 1 && indexpath.row == 2)) {
        
        if (contractorType == JGJContractorMakeAttendanceType) {
            
            if (!self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl || !self.contractYzgGetBillModel.unit_quan_tpl.o_h_tpl || self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl < 0) {
                
                [TYShowMessage showPlaint:@"请设置考勤模板"];
                return;
            }
        }
        
    }else if (indexpath.section == 2) {
        
        if (!self.contractYzgGetBillModel.name) {
            
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.contractYzgGetBillModel.date) {
            
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
        
        if (contractorType == JGJContractorMakeAttendanceType) {
            
            if (!self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl || !self.contractYzgGetBillModel.unit_quan_tpl.o_h_tpl || self.contractYzgGetBillModel.unit_quan_tpl.w_h_tpl < 0) {
                [TYShowMessage showPlaint:@"请设置工资考勤模板"];
                return;
            }
        }
        
    }
    // 班组长 选择日期 确认包工账单 选择所在项目事件
    if (indexpath.section == 0) {
        
        if (indexpath.row == 0) {
            
            if (_ChatType) {
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.contractYzgGetBillModel];
            
        }else if (indexpath.row == 1){
            
            [self showDatePickerByIndexPath:indexpath];
            
        }else if (indexpath.row == 2){
            
            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = self.contractYzgGetBillModel.date?:@"";
            poorBillVC.uid = [NSString stringWithFormat:@"%ld",(long)self.contractYzgGetBillModel.uid];
            
            //包工类型
            poorBillVC.accounts_type = @"2";
            
            [self.navigationController pushViewController:poorBillVC animated:YES];
            
        }else if (indexpath.row == 3) {
            
            [self showProjectPickerByIndexPath:indexpath];
        }
        
    }
    // 记工备注
    else if (indexpath.section == 2 && indexpath.row == 0) {
    
        [self markBillRemark];
    }
    
    // 包工记考勤选择模板和加班上班时长
    if (contractorType == JGJContractorMakeAttendanceType) {
        
        if (indexpath.section == 1) {
            
            if (indexpath.row == 0) {
                
                JGJContractorListAttendanceTemplateController *templateVC = [[JGJContractorListAttendanceTemplateController alloc] init];
                
                templateVC.yzgGetBillModel = self.contractYzgGetBillModel;
                [self.navigationController pushViewController:templateVC animated:YES];
                
                __weak typeof(self) weakSelf = self;
                __strong typeof(self) strongSelf = self;
                templateVC.attendanceTemplate = ^(YZGGetBillModel *yzgGetBillModel) {
                  
                    weakSelf.contractYzgGetBillModel = yzgGetBillModel;
                    
                    if (!strongSelf -> _isChoiceManHourOrOverHour) {
                        
                        weakSelf.contractYzgGetBillModel.manhour = yzgGetBillModel.unit_quan_tpl.w_h_tpl;
                        weakSelf.contractYzgGetBillModel.overtime = 0.0;
                    }
                    [weakSelf.mainCollectionview reloadData];
                };
                
            }else if (indexpath.row == 1) {
                
                self.contractYzgGetBillModel.set_tpl.w_h_tpl = 0.0;
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:YES noShowRest:NO andBillModel:self.contractYzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
                
            }else {
                
                self.contractYzgGetBillModel.set_tpl.o_h_tpl = 0.0;
                [JGJManHourPickerView showManhpurViewFrom:JGJManhourOneHalfType withotherType:JGJManhourOnelineType andDelegate:self isManHourTime:NO noShowRest:NO andBillModel:self.contractYzgGetBillModel isContractType:YES isShowHalfOrOneSelectedView:YES];
            }
        }
    }
    // 包工记账
    else {
        
        // 填写数量
        if (indexpath.section == 1) {
            
            if (indexpath.row == 2) {
                
                JGJPackNumViewController *changeToVc = [[UIStoryboard storyboardWithName:@"packStroyBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"PackNumVC"];
                JGJFilloutNumModel *model = [[JGJFilloutNumModel alloc]init];
                
                model.priceNum = self.contractYzgGetBillModel.units?:@"";
                model.Num = [NSString stringWithFormat:@"%.2f", self.contractYzgGetBillModel.quantities];
                
                changeToVc.filloutmodel = model;
                [self.navigationController pushViewController:changeToVc animated:YES];
            }
            
        }
    }
}

#pragma mark - 借支
-(void)didSelectBrrowTableViewFromIndexpath:(NSIndexPath *)indexpath WithModel:(YZGGetBillModel *)model
{
    [self.view endEditing:YES];

    if (indexpath.section == 0 && indexpath.row == 1) {
        if ([NSString isEmpty: self.brrowYzgGetBillModel.name ]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }else if (indexpath.section == 2){
        if (!self.brrowYzgGetBillModel.name) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.brrowYzgGetBillModel.date) {
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
        
    }
    
    if (indexpath.section == 0) {
        if (indexpath.row == 0) {
            
            //注释聊天进来能选择人员(3.0.0yj添加)
            
            if (_ChatType) {
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.brrowYzgGetBillModel];
            
        }else if (indexpath.row == 1){
            
            [self showDatePickerByIndexPath:indexpath];
        }else{
            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = self.brrowYzgGetBillModel.date?:@"";
            poorBillVC.uid = [NSString stringWithFormat:@"%ld",(long)self.brrowYzgGetBillModel.uid];
            //借支
            poorBillVC.accounts_type = @"3";
            
            [self.navigationController pushViewController:poorBillVC animated:YES];
        }
    }else if (indexpath.section == 1){
        
        
    }else{
        if (indexpath.row == 0) {
            [self showProjectPickerByIndexPath:indexpath];
            
        }else if (indexpath.row == 1){
            [self markBillRemark];
        }
    }
}
#pragma mark - 结算
- (void)didSelectCloseAccountFromIndexpath:(NSIndexPath *)indexpath withModel:(YZGGetBillModel *)model
{
    [self.view endEditing:YES];
    if (indexpath.section == 0 && indexpath.row == 1) {
        if ([NSString isEmpty: self.closeAccountyzgGetBillModel.name ]) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }
    }else if (indexpath.section == 5){
        if (!self.closeAccountyzgGetBillModel.name) {
            [TYShowMessage showPlaint:@"请先选择记账对象"];
            return;
        }else if (!self.closeAccountyzgGetBillModel.date) {
            [TYShowMessage showPlaint:@"请先选择记账日期"];
            return;
        }
        
    }
    if (indexpath.section == 0) {
        
        if (indexpath.row == 0) {
            
            if (_ChatType) {
                
                return;
            }
            [self handleAddForemanAdnMateVcWithModel:self.closeAccountyzgGetBillModel];
            
        }else if (indexpath.row == 1){
            
            [self showDatePickerByIndexPath:indexpath];
            
        }else{
            
            JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
            poorBillVC.currectTime = self.closeAccountyzgGetBillModel.date?:@"";
            poorBillVC.uid = [NSString stringWithFormat:@"%ld",(long)self.closeAccountyzgGetBillModel.uid];
            //借支
            poorBillVC.accounts_type = @"4";
            [self.navigationController pushViewController:poorBillVC animated:YES];
        }
        
    }else if (indexpath.section == 5){
        
        if (indexpath.row == 0) {
            
            [self showProjectPickerByIndexPath:indexpath];
            
        }else if (indexpath.row == 1){
            
            [self markBillRemark];
        }
    }
}

- (void)justRealName {
    
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
