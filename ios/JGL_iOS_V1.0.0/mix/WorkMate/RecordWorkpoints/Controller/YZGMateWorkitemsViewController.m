//
//  YZGMateWorkitemsViewController.m
//  mix
//
//  Created by Tony on 16/2/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateWorkitemsViewController.h"
#import "TYFMDB.h"
#import "TYBaseTool.h"
#import "FSCalendar.h"
#import "NSDate+Extend.h"
#import "JLGPickerView.h"
#import "YZGMateShowpoor.h"//显示差账的View
#import "MyCalendarObject.h"
#import "JGJMarkBillBaseVc.h"
#import "JGJAddNameHUBView.h"
#import "YZGNoWorkitemsView.h"
#import "YZGMateWorkitemsModel.h"
#import "YZGMateWorkitemsTableViewCell.h"
#import "YZGMateReleaseBillViewController.h"
#import "JGJQRecordViewController.h"
#import "JGJRecordBillDetailViewController.h"
#import "JGJSurePoorBillShowView.h"
#import "JGJModifyBillListViewController.h"
#import "JGJCusActiveSheetView.h"
#import "JGJMarkBillViewController.h"
#import "JLGCustomViewController.h"
#import "CFRefreshStatusView.h"
#import "JGJModifyBillListViewController.h"
#import "JGJCusActiveSheetView.h"
#import "JGJAccountShowTypeVc.h"
#import "FDAlertView.h"

#import "JYSlideSegmentController.h"
#define YZGMateWorkitemsTableSectionHeaderHeight 20

static NSString *const calendarFormat = @"yyyy/MM/dd";

@interface YZGMateWorkitemsViewController ()
<
    FSCalendarDelegate,
    FSCalendarDataSource,
    JLGPickerViewDelegate,
    YZGMateShowpoorDelegate,
    JGJAddNameHUBViewDelegate,
    FSCalendarDelegateAppearance,
    YZGMateWorkitemsTableViewCellDelegate,
    JGJSurePoorBillShowViewDelegate,
    SWTableViewCellDelegate,
    FDAlertViewDelegate
>
{
    NSIndexPath *_indexPath;//选择的cell
    NSInteger _cooperateType;//筛选的类型
    BOOL _isMarkBillHomePageIn;
}

@property (nonatomic, assign) BOOL isLoadData;//是否加载过数据，YES:在没数据的情况下显示缺省页，NO:在没数据的情况下不显示缺省页
@property (nonatomic, copy)   NSString *oldBackTitle;
@property (nonatomic, copy)   NSArray *cooperateTypeArr;
@property (nonatomic, copy)   NSMutableArray <JGJDayCheckingModel *>*fileterArr;

@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (nonatomic, strong) JLGPickerView *jlgPickerView;
@property (nonatomic, strong) NSCalendar *holidayLunarCalendar;
@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;
@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;
@property (nonatomic, strong) YZGMateWorkitemsModel *yzgMateWorkitemsModel;//从服务器获取的数据
@property (nonatomic, strong) YZGMateWorkitemsModel *yzgDisMateWorkitemsModel;//用于显示的数据，因为有筛选
@property (nonatomic, strong) NSMutableArray <JGJDayCheckingModel *>*dataArr;
@property (nonatomic, strong) JGJPoorBillListDetailModel *poorModel;
//手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) JGJDayCheckingModel *DayCheckingModel;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;//日历
@property (weak, nonatomic) IBOutlet UIButton *recordNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *borrowOrCloseButton;// 借支结算

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *containtRecordNoteButtonView;
@property (nonatomic, assign) BOOL isShowWork;
@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) JGJDayCheckingModel *deleteDayCheckingModel;

@property (nonatomic, assign) BOOL isChangeSelType;

@end

@implementation YZGMateWorkitemsViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self addGestureRecognizer];
    
    self.title = [NSDate stringFromDate:_searchDate?:[NSDate date] format:@"yyyy-MM"];
    
    //设置日历,更新数据
    [self setUpCalendar];
    self.isLoadData = NO;
    _isMarkBillHomePageIn = NO;
    [self.recordNoteButton.layer setLayerCornerRadius:5.0];
    [self.borrowOrCloseButton.layer setLayerCornerRadius:5.0];
    
    //#19297修改为记一笔工
    
    [self.recordNoteButton setTitle:@"记一笔工" forState:(UIControlStateNormal)];
    
    self.borrowOrCloseButton.layer.borderWidth = 1;
    self.borrowOrCloseButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    
    self.tableView.backgroundColor = JGJMainBackColor;
    self.containtRecordNoteButtonView.backgroundColor = AppFontfafafaColor;

    self.recordNoteButton.backgroundColor = AppFontEB4E4EColor;
    //默认显示工
    self.isShowWork = JGJIsShowWorkBool;
    [self justRealName];
}

- (void)justRealName
{
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            __weak typeof(self) weakSelf = self;
            customVc.customVcBlock = ^(id response) {
                
                [weakSelf JLGHttpRequest];
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
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.jlgPickerView = nil;
    self.yzgMateShowpoor = nil;
    self.cooperateTypeArr = nil;
    self.yzgNoWorkitemsView = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!_isChangeSelType) {
        
        [self updateSelectDate:self.searchDate];
    }
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    // 结束以后开启手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&!self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [JGJSurePoorBillShowView removeView];
    
}
-(NSMutableArray<JGJDayCheckingModel *> *)dataArr
{

    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (void)JLGHttpRequest{
    
    if (!self.searchDate) {
        TYLog(@"搜索的时间不存在%@",self.searchDate);
        return ;
    }
    _cooperateType = 0;
    [TYLoadingHub showLoadingNoDataDefultWithMessage:@"请稍后..."];
    if (!self.isLoadData) {
        self.isLoadData = YES;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/work-items" parameters:@{@"date":[NSDate stringFromDate:self.searchDate format:@"yyyyMMdd"]} success:^(id responseObject) {
        self.dataArr = [JGJDayCheckingModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        self.fileterArr = self.dataArr;

        [TYLoadingHub hideLoadingView];
        [self showDefaultNodataArray:self.dataArr];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];

    }];
    

}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL countIsZero = (self.dataArr.count == 0);
    tableView.bounces = !countIsZero;//没有数据不能滑动
    
    if (countIsZero) {//没有数据显示的cell
        static NSString *cellID = @"YZGMateWorkitemsViewControllerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.yzgNoWorkitemsView];
        }
        //在没数据的情况下显示缺省页,在没数据的情况下不显示缺省页
        cell.hidden = !self.isLoadData;
        return cell;
    }
    
    YZGMateWorkitemsTableViewCell *yzgMateWorkitemsTableViewCell = [YZGMateWorkitemsTableViewCell cellWithTableView:tableView];
    yzgMateWorkitemsTableViewCell.showType = self.selTypeModel.type;
    yzgMateWorkitemsTableViewCell.rightUtilityButtons = [self handleStickBtnArray];
    yzgMateWorkitemsTableViewCell.delegate = self;
    yzgMateWorkitemsTableViewCell.tag = indexPath.section + 100;
    yzgMateWorkitemsTableViewCell.cellIndexPath = indexPath;
    [self configureCell:yzgMateWorkitemsTableViewCell atIndexPath:indexPath];
    return yzgMateWorkitemsTableViewCell;
}

- (NSArray *)handleStickBtnArray {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:AppFontC7C6CBColor title:@"修改"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:AppFontd7252cColor title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewCellDelegate
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}


#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}


- (void)swipeableTableViewCell:(YZGMateWorkitemsTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{

    if (index == 0) {
        
        _isChangeSelType = NO;
        MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
        mateWorkitemsItem = [self getServerMateDataAndDayModel:self.dataArr[cell.tag - 100]];
        JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
        ModifyBillListVC.billModify = NO;
        ModifyBillListVC.mateWorkitemsItems = mateWorkitemsItem;
        ModifyBillListVC.delshowViewBool = NO;
        [self.navigationController pushViewController:ModifyBillListVC animated:YES];
        [self.tableView reloadData];
        
        
    }else if (index == 1) {
        
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"数据一经删除将无法恢复。\n请谨慎操作哦！" delegate:self buttonTitles:@"取消",@"确认删除", nil];
        
        alert.isHiddenDeleteBtn = YES;
        [alert setMessageColor:AppFont000000Color fontSize:16];
        
        [alert show];
        _deleteDayCheckingModel = [[JGJDayCheckingModel alloc] init];
        _deleteDayCheckingModel = self.dataArr[cell.cellIndexPath.section];
        
        
    }
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        __weak typeof(self) weakSelf = self;
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:@{@"id":_deleteDayCheckingModel.id} success:^(id responseObject) {
            
            [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
            [weakSelf JLGHttpRequest];
            [TYLoadingHub hideLoadingView];
            [TYShowMessage showSuccess:@"删除成功！"];
        }failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
}

#pragma mark - tableViewDelegate
#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem = [self getServerMateDataAndDayModel:self.dataArr[indexPath.section]];

    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/isaccountsdiff" parameters:@{@"id":[self.dataArr[indexPath.section] id]} success:^(id responseObject) {
        BOOL isDiff = [responseObject[@"diff"] boolValue];
        //表示有差账 1
        mateWorkitemsItem.amounts_diff = isDiff;
        [self goToNextVc:mateWorkitemsItem indexPath:indexPath values:nil];
        
    } failure:^(NSError *error) {
        
        [self goToNextVc:mateWorkitemsItem indexPath:indexPath values:nil];
    }];
    
#pragma mark -此处避免快速点击 造成相同的push 
//    _tableView.userInteractionEnabled = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _tableView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar setBarTintColor:AppFontffffffColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color}];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [TYShowMessage hideHUD];
    //默认显示方式
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    [self.tableView reloadData];

}

- (void)goToNextVc:(MateWorkitemsItems *)mateWorkitemsItem indexPath:(NSIndexPath *)indexPath values:(MateWorkitemsValues *)mateWorkitemsValues{
    
    if (mateWorkitemsItem.amounts_diff) {//有差账的情况下，弹出选择框
        
        self.yzgMateShowpoor.mateWorkitemsItem = mateWorkitemsItem;
        JGJPoorBillListDetailModel *poorModel = [JGJPoorBillListDetailModel new];
        poorModel.accounts_type = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.accounts_type.code];
        poorModel.id = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.id];
        poorModel.manhour = mateWorkitemsItem.manhour;
        poorModel.overtime = mateWorkitemsItem.overtime;
        poorModel.proname = mateWorkitemsItem.pro_name;
        poorModel.worker_name = mateWorkitemsItem.worker_name;
        poorModel.foreman_name = mateWorkitemsItem.foreman_name;
        poorModel.amounts = mateWorkitemsItem.amounts;
        if ([mateWorkitemsItem.date isKindOfClass:[NSDate class]]) {
            
            poorModel.date =[JGJTime yearAppend_Monthand_dayfromstamp:(NSDate *)mateWorkitemsItem.date];

        }else{
       
            poorModel.date = mateWorkitemsItem.date;
        }
        poorModel.is_del = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.is_del];
        poorModel.pid = mateWorkitemsItem.pid;
        poorModel.sub_proname = mateWorkitemsItem.sub_pro_name;
        poorModel.units = mateWorkitemsItem.unit;

        [JGJSurePoorBillShowView showPoorBillAndModel:poorModel AndDelegate:self andindexPath:indexPath andHidenismine:NO];

        _indexPath = indexPath;
        
    }else{//没有差账进入编辑界面
        
        _isChangeSelType = NO;
        JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
        recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
        [self.navigationController pushViewController:recordBillVC animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 82;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.dataArr.count == 0?0.01:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == self.dataArr.count - 1) {
        
        return 10;
    }else {
        
        return 0.01;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (self.dataArr.count == 0) {

        return nil;
    }
    

    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([self class])];
    
    if(!myHeader) {
        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass([self class])];
        myHeader.backgroundColor = AppFontf1f1f1Color;
        //添加header的Label
        UILabel * label = [[UILabel alloc] init];
        label.tag = 40;
        label.backgroundColor = AppFontf1f1f1Color;
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
        [myHeader addSubview:label];
    }
   
    return myHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([self class])];

    if(!myHeader) {
        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass([self class])];
        myHeader.backgroundColor = AppFontf1f1f1Color;
        //添加header的Label
        UILabel * label = [[UILabel alloc] init];
        label.tag = 40;
        label.backgroundColor = AppFontf1f1f1Color;
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
        [myHeader addSubview:label];
    }

    if (section == self.dataArr.count - 1) {
        
        return myHeader;
        
    }else {

        return nil;
    }
    
}

- (void)configureCell:(YZGMateWorkitemsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {


    cell.yzdelegate = self;
    cell.DayCheckingModel  = self.dataArr[indexPath.section];
    cell.isLastedCell = (indexPath.section + 1)== self.dataArr.count;
}

#pragma mark - 点击cell的删除键
- (void)MateWorkitemsDeleteBtnClick:(YZGMateWorkitemsTableViewCell *)cell{
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];

    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:@{@"id":@(cell.mateWorkitemsValue.id)} success:^(id responseObject) {
        
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
        [weakSelf JLGHttpRequest];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark 点击移除键
- (void)MateWorkitemsRemoveBtnClick:(YZGMateWorkitemsTableViewCell *)cell{
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];

    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/removepartner" parameters:@{@"uid":@(cell.mateWorkitemsValue.uid),@"date":[NSDate stringFromDate:self.searchDate format:@"yyyyMMdd"]} success:^(id responseObject) {
        [self JLGHttpRequest];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
#pragma mark - YZGMateShowpoor的delegate 主要涉及复制差账和修改按钮
- (void)MateShowpoorModifyBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    
    _isChangeSelType = NO;
    MateWorkitemsValues *mateWorkitemsValues = self.yzgDisMateWorkitemsModel.values[_indexPath.section];
    MateWorkitemsItems *mateWorkitemsItem = mateWorkitemsValues.items[_indexPath.section];
    
    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
    workerGetBillVc.markBillType = MarkBillTypeEdit;
    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
    workerGetBillVc.selectedDate = self.calendar.selectedDate;
    
    [self.navigationController pushViewController:workerGetBillVc animated:YES];
    _indexPath = nil;
}

#pragma mark - 马上记一笔
- (IBAction)goToReleaseBillVc:(id)sender {
    
    UIView *jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    
    if (jgjAddNameHUBView) {
        return;
    }
 
    _isChangeSelType = NO;
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.selectedDate = _calendar.selectedDate?:[NSDate date];
    slideSegmentVC.oneDayAttendanceComeIn = YES;
    slideSegmentVC.segmentType = JYSlideSegmentTinyAndContractType;
    slideSegmentVC.title = @"记工记账";
    
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
    
}

#pragma mark - 借支/结算
- (IBAction)goToBorrowOrCloseVC:(UIButton *)sender {
    
    _isChangeSelType = NO;
    JYSlideSegmentController *slideSegmentVC = [[JYSlideSegmentController alloc] init];
    slideSegmentVC.selectedDate = _calendar.selectedDate?:[NSDate date];
    slideSegmentVC.oneDayAttendanceComeIn = YES;
    slideSegmentVC.segmentType = JYSlideSegmentBorrowAndCloseCountType;
    slideSegmentVC.title = @"记工记账";
    
    [self.navigationController pushViewController:slideSegmentVC animated:YES];
}
- (void)MateShowpoorCopyBillBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    
    [self JLGHttpRequest];
    
}

#pragma mark - FSCalendarDataSource
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;
{
    UIColor *color;
    if ([[NSDate stringFromDate:calendar.today format:calendarFormat] isEqualToString:[NSDate stringFromDate:date format:calendarFormat]]) {//今天
        color = JGJMainColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){//范围内
        color = TYColorHex(0xafafaf);
    }else{
        color = TYColorHex(0x2e2e2e);
    }
    
    return color;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    UIColor *color;
    if ([[NSDate stringFromDate:calendar.today format:calendarFormat] isEqualToString:[NSDate stringFromDate:date format:calendarFormat]]) {//今天
        color = JGJMainColor;
    }else if([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX){
        color = TYColorHex(0xc7c7c7);
    }else{
        color = TYColorHex(0x7b7b7b);
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
        TYLog(@"记事本日历holidayDic = %@",holidayDic);
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
//    return [NSDate getLastWeekOfThisMonth];
    return [NSDate date];
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    return !([NSDate getDaysThisMothFrom:calendar.today withToDate:date] > 0 && [NSDate getDaysThisMothFrom:calendar.today withToDate:date] != INT32_MAX);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    if ([self.searchDate isEqualToDate:calendar.selectedDate]) {
        return;
    }
    
    [self updateSelectDate:date];
}

- (void)calendarCurrentPageWillChange:(FSCalendar *)calendar {
    
    _isMarkBillHomePageIn = NO;
}

- (void)setSearchDate:(NSDate *)searchDate {
    
    _searchDate = searchDate;
    _isMarkBillHomePageIn = YES;
    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    // v3.4.1需求 往前翻日历 时间自动选择到一周前的今天对应的数据 往后翻 如果加7天时间大于今天时间 则显示今天时间 否则显示加7天后的时间
    if ([calendar.currentPage.timestamp doubleValue] < [calendar.selectedDate.timestamp doubleValue]) {// 往前翻
        
        NSString *timeIntervalStr = calendar.selectedDate.timestamp;// 获取日历选择时间的时间戳
        NSTimeInterval selectedTimeInterval = [timeIntervalStr doubleValue];
        selectedTimeInterval = selectedTimeInterval - 24 * 60 * 60 * 7;
        if (!_isMarkBillHomePageIn) {// 用于记账首页今日 每日考勤，选择日期与今天差7天 滑动bug
            
            [self updateSelectDate:[NSDate timeSpStringToNSDate:[NSString stringWithFormat:@"%lf",selectedTimeInterval]]];
        }
        
        
    }else {
        
        NSTimeInterval sevenDayAfterTime = [calendar.selectedDate.timestamp doubleValue] + 24 * 60 * 60 * 7;
        NSString *nowDateStr = [NSDate date].timestamp;
        
        NSInteger differenceTimeIntervalPage = sevenDayAfterTime - [nowDateStr doubleValue];// 把7天后的时间与今天时间相减 大于0 则选择今天 小于0 则选择7天后的时间
        if (differenceTimeIntervalPage > 0 || differenceTimeIntervalPage == 0) {
            
            [self updateSelectDate:[NSDate date]];
            
        }else {
            
            if (!_isMarkBillHomePageIn) {
                
                NSTimeInterval selectedTimeInterval = [calendar.selectedDate.timestamp doubleValue] + 24 * 60 * 60 * 7;
                [self updateSelectDate:[NSDate timeSpStringToNSDate:[NSString stringWithFormat:@"%lf",selectedTimeInterval]]];
            }
            
        }
        
    }

}

- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    CGSize size = [calendar sizeThatFits:_calendar.frame.size];
    _calendarHeightConstraint.constant = size.height;
    [self.view layoutIfNeeded];
}

#pragma mark - 增加手势
- (void)addGestureRecognizer {
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.tableView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.tableView addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    NSInteger isAddDay = 0;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        isAddDay = 1;
        TYLog(@"尼玛左划了");
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        isAddDay =  -1;
        TYLog(@"尼玛右划了");
    }
    
    NSDate *modifyDate = [self.calendar dateByAddingDays:isAddDay toDate:self.calendar.selectedDate];
    NSInteger days = [NSDate getDaysFrom:self.calendar.today withToDate:modifyDate];
    if (days <= 0 && days != INT32_MAX) {
        [self.calendar selectDate:modifyDate];
        [self updateSelectDate:self.calendar.selectedDate];
    }
}


#pragma mark - 设置日历
- (void)setUpCalendar{
    
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];

    _holidayLunarCalendar = [NSCalendar currentCalendar];
    _holidayLunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _calendar.scope = FSCalendarScopeWeek;

    _calendar.appearance.weekdayTextColor = TYColorHex(0x7b7b7b);
    _calendar.appearance.afterTodayTitleColor = TYColorHex(0xafafaf);
    _calendar.appearance.afterTodaySubTitleColor = TYColorHex(0xc7c7c7);
    _calendar.appearance.todayColor = [UIColor redColor];
    _calendar.appearance.todaySelectionColor = JGJMainColor;
    _calendar.appearance.selectionColor = TYColorHex(0xf9a00f);
    _calendar.appearance.titleSelectionColor = JGJMainColor;
    _calendar.appearance.subtitleSelectionColor = JGJMainColor;
    _calendar.appearance.selectionColor = AppFontf1f1f1Color;
    _calendar.appearance.cellShape = FSCalendarCellShapeRectangle;
    _calendar.appearance.selectionColor = AppFontfdf0f0Color;
    _calendar.appearance.todaySelectionColor = AppFontfdf0f0Color;
    _calendar.appearance.todayColor = [UIColor whiteColor];
    _calendar.showHeader = NO;
    _calendar.showTodayNotShowSubImage = YES;
    [_calendar selectDate:_searchDate?:[NSDate date]];

}

#pragma mark - 修改时间
- (void)updateSelectDate:(NSDate *)searchDate{
    
    self.searchDate = searchDate;
    self.calendar.cc_selectedDate = self.searchDate;
    [_calendar selectDate:self.searchDate];
    
    self.title = [NSDate stringFromDate:self.searchDate format:@"yyyy-MM"];
    [self JLGHttpRequest];
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"无记账记录\n数据不丢失,对账有依据!"];
        
        statusView.frame = self.tableView.bounds;
        
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 20)];
        view.backgroundColor = AppFontf1f1f1Color;
        
        [statusView addSubview:view];
        
        self.tableView.tableHeaderView = statusView;
        
        self.tableView.bounces = NO;
        
    }else {
        
        self.tableView.bounces = YES;

        self.tableView.tableHeaderView = nil;
    }
    
//    self.bottomViewH.constant = dataArray.count != 0 ? 64 : 0;
}


#pragma mark - 筛选
- (IBAction)FilterBtnClick:(UIButton *)sender {

    
//    [self showSheetView];
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel,@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            weakSelf.isChangeSelType = YES;
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
    [sheetView showView];

    
}

#pragma mark - 筛选完了
- (void)JLGPickerViewSelect:(NSArray *)finishArray{
    if (finishArray.count == 3) {//取消
        return;
    }
    
    __block NSIndexPath *indexPath;
    [finishArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            indexPath = obj;
        }
    }];
    
    [self updateDisDataByCooperateType:[[finishArray firstObject][@"id"] integerValue]];
}

-(NSArray *)fileterArr
{
    if (!_fileterArr) {
        
        _fileterArr = [[NSMutableArray alloc]init];
    }
    return _fileterArr;
}
#pragma mark 改变筛选类型
- (void)updateDisDataByCooperateType:(NSInteger )cooperateType{
    if (_cooperateType == cooperateType) {//如果类型相同，不进行筛选操作
        return;
    }
    

    _cooperateType = cooperateType;

    self.dataArr = [self.fileterArr copy];

    
    if (_cooperateType == 0) {
//        [self JLGHttpRequest];
        
    }else{
        
        NSMutableArray *dataArr = [[NSMutableArray alloc]init];
  
        
        for (int i = 0; i < self.dataArr.count; i ++) {
            
            JGJDayCheckingModel *model = self.dataArr[i];
            
            if ([model.accounts_type intValue] == _cooperateType) {
                
                [dataArr addObject:model];
                
            }
        }
        self.dataArr = [[NSMutableArray alloc]initWithArray:dataArr];
        

    }
    
    [self.tableView reloadData];
}

#pragma mark - 进入下一个界面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[YZGMateReleaseBillViewController class]]) {
        YZGMateReleaseBillViewController *releaseBillVc = segue.destinationViewController;
        releaseBillVc.selectedDate = self.calendar.selectedDate;
    }

}


#pragma mark - 懒加载
- (YZGMateShowpoor *)yzgMateShowpoor
{
    if (!_yzgMateShowpoor) {
        _yzgMateShowpoor = [[YZGMateShowpoor alloc] initWithFrame:TYGetUIScreenRect];
        _yzgMateShowpoor.delegate = self;
    }
    return _yzgMateShowpoor;
}

#pragma mark - 懒加载
- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}

- (NSArray *)cooperateTypeArr
{
    if (!_cooperateTypeArr) {
        _cooperateTypeArr = [TYFMDB searchTable:TYFMDBYZGCooperateTypeName];
    }
    return _cooperateTypeArr;
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64)];
        [_yzgNoWorkitemsView setTitleString:@"无记账记录\n数据不丢失，对账有依据!"];
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}
#pragma mark - 组装数据
- (MateWorkitemsItems *)getServerMateDataAndDayModel:(JGJDayCheckingModel *)dayModel{

    MateWorkitemsItems *mateWorkItemModel = [MateWorkitemsItems new];
    mateWorkItemModel.id = [dayModel.id longLongValue];
    mateWorkItemModel.overtime = dayModel.overtime;
    mateWorkItemModel.manhour = dayModel.manhour;
    mateWorkItemModel.accounts_type.code = [dayModel.accounts_type intValue];
    mateWorkItemModel.amounts = [dayModel.amounts floatValue];
    mateWorkItemModel.amounts_diff = [dayModel.amounts_diff intValue];
    mateWorkItemModel.pid = [dayModel.pid longLongValue];
    mateWorkItemModel.pro_name = dayModel.proname;
    mateWorkItemModel.name = dayModel.worker_name;
    mateWorkItemModel.date = self.searchDate;
    mateWorkItemModel.record_id = dayModel.id;
    mateWorkItemModel.id =  [mateWorkItemModel.record_id?:@"0" longLongValue];
    return mateWorkItemModel;
    
}

#pragma mark - 查看详情
- (void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    _isChangeSelType = NO;
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    ModifyBillListVC.billModify = YES;
    ModifyBillListVC.isNotNeedJudgeHaveChangedParameters = YES;
    ModifyBillListVC.mateWorkitemsItems = [self getServerMateDataAndDayModel:self.dataArr[indexpath.section]];
    JGJDayCheckingModel *dayModel = self.dataArr[indexpath.section];
//    [ModifyBillListVC setOriginalWorkTime:[dayModel.manhour floatValue] overTime:[dayModel.overtime floatValue]];
    
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
}
#pragma mark - 同意他人的修改
-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:@{@"id":[self.dataArr[indexpath.section] id]} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [JGJSurePoorBillShowView removeView];
        
        [self JLGHttpRequest];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [JGJSurePoorBillShowView removeView];
        
    }];

}
- (YZGGetBillModel *)getYzgGetBillModel:(JGJDayCheckingModel *)detailModel andShowPoor:(YZGMateShowpoorModel *)model
{
    YZGGetBillModel *getBillModel = [YZGGetBillModel new];
    getBillModel.accounts_type.code = [detailModel.accounts_type intValue];
    //getBillModel.set_tpl = detailModel.set_tpl;
    getBillModel.set_tpl.s_tpl = [model.main_s_tpl?:@"0" floatValue];
    getBillModel.set_tpl.o_h_tpl = [model.main_o_h_tpl?:@"0" floatValue];
    getBillModel.set_tpl.w_h_tpl = [model.main_w_h_tpl?:@"0" floatValue];
    getBillModel.manhour = [detailModel.manhour floatValue];
    getBillModel.overtime = [detailModel.overtime floatValue];
    getBillModel.salary = [detailModel.amounts floatValue];
    getBillModel.proname = detailModel.proname;
    getBillModel.amounts = [detailModel.amounts floatValue] ;
    getBillModel.worker_name = detailModel.worker_name;
    getBillModel.foreman_name = detailModel.foreman_name;
    getBillModel.quantities = [model.main_set_quantities floatValue];
    getBillModel.pid = [detailModel.pid intValue];
    getBillModel.units =  model.main_set_unitprice;
//    getBillModel.date = model.date;
    getBillModel.unitprice = [model.main_set_unitprice?:@"0" floatValue];
    
    return getBillModel;
}

@end
