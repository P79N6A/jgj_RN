//
//  YZGGetIndexRecordViewController.m
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetIndexRecordViewController.h"
#import "TYBaseTool.h"
#import "JLGTableView.h"
#import "NSDate+Extend.h"
#import "YZGMateShowpoor.h"//显示差账的View
#import "JGJMarkBillBaseVc.h"
#import "YZGDatePickerView.h"
#import "JGJMarkBillBaseVc.h"
#import "JGJAddNameHUBView.h"
#import "YZGNoWorkitemsView.h"
#import "YZGGetIndexRecordModel.h"
#import "YZGGetIndexRecordTableViewCell.h"
#import "YZGGetIndexRecordFirstTableViewCell.h"
#import "YZGGetIndexRecordHeaderTableViewCell.h"
#import "JGJQRecordViewController.h"
#import "FDAlertView.h"
#import "JGJRecordBillDetailViewController.h"
#import "JGJSurePoorBillShowView.h"
#import "JGJModifyBillListViewController.h"
#import "JGJTabBarViewController.h"
#import "JGJRecordBillWaterHeaderView.h"
#import "JLGCustomViewController.h"
#import "JGJMarkBillViewController.h"
static NSString *kTableViewHeaderViewID = @"YZGWageDetailCellHeaderView";
static const CGFloat kNormalCellHeight = 60.f;
static const CGFloat kCellFirstHeightRation = kNormalCellHeight*0.6;
static const CGFloat kCellHeaderHeightRation = kNormalCellHeight*1.41;
@interface YZGGetIndexRecordViewController ()
<
    JLGTableViewDelegate,
    YZGMateShowpoorDelegate,
    JGJAddNameHUBViewDelegate,
    YZGDatePickerViewDelegate,
    YZGNoWorkitemsViewDelegate,
    FDAlertViewDelegate,
    JGJSurePoorBillShowViewDelegate,
    UIScrollViewDelegate
>
{
    BOOL _isDeleting;//YES:按了删除键，NO:没有按删除键
    BOOL _isAllDeleting;//YES:全选，NO,没有全选
    BOOL _needAnimate;//tableView是否需要动画
    NSIndexPath *_indexPath;//选择的cell
}

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) NSInteger selectedNum;//选中多少个;
@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;
@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;
//@property (nonatomic, strong) YZGGetIndexRecordModel *getIndexRecordModel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *topRightButton;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet JLGTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutH;
@property (strong, nonatomic) IBOutlet UILabel *yearLable;

@property (nonatomic ,strong)JGJRecordWorkpointsModel *recordWorkpointsModel;

@property (nonatomic ,strong)JGJRecordBillWaterHeaderView *recordBillWaterView;

@end

@implementation YZGGetIndexRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iphoneXH) {
        _bottomConstances.constant = 34;
    }
    [self justRealName];
    self.tableView.JLGdelegate = self;
    self.tableView.backgroundColor = JGJMainBackColor;
    [self.topRightButton setTitleColor:JGJMainColor forState:UIControlStateNormal];

    [self.deleteButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    [self.allSelectedButton.layer setLayerBorderWithColor:TYColorHex(0x666666) width:0.5 radius:5];
    
    [self changeEidingStatus:NO];
    self.titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.titleView addGestureRecognizer:singleTap];
    [self.view addSubview:self.recordBillWaterView];

}

-(JGJRecordBillWaterHeaderView *)recordBillWaterView
{
    if (!_recordBillWaterView) {
        _recordBillWaterView = [[JGJRecordBillWaterHeaderView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, kNormalCellHeight*1.41)];
    }
    return  _recordBillWaterView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self JLGHttpRequest];
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)setDate:(NSDate *)date{
    
    _date = date?:[NSDate date];
    self.dateString = [NSDate stringFromDate:self.date format:@"yyyyMM"];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.yzgMateShowpoor = nil;
    self.yzgDatePickerView = nil;
}

#pragma mark - 改变isEiding的状态
- (void)changeEidingStatus:(BOOL )isDeleting{
    
    _needAnimate = _isDeleting == NO && isDeleting == YES;
    
    _isDeleting = isDeleting;
    
    self.bottomViewLayoutH.constant = isDeleting?63:0;
    
    [self.bottomView layoutIfNeeded];
    
    //如果是删除状态，就将所有选中状态修改为没有选中
    if (isDeleting) {
        [self.recordWorkpointsModel.selectedArray enumerateObjectsUsingBlock:^(NSMutableArray *subSelectedArray, NSUInteger idx, BOOL * _Nonnull stop) {
            [subSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                subSelectedArray[idx] = @(!isDeleting);
            }];
        }];
    }else{
        
        self.selectedNum = 0;
        
    }

    [self.tableView reloadData];
    
}
- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/getIndexRecord" parameters:@{@"date":self.dateString} success:^(id responseObject) {
//        YZGGetIndexRecordModel *getIndexRecordModel = [YZGGetIndexRecordModel new];
//        [getIndexRecordModel mj_setKeyValues:responseObject];
//        self.getIndexRecordModel = getIndexRecordModel;
        
        self.recordWorkpointsModel = [JGJRecordWorkpointsModel mj_objectWithKeyValues:responseObject];
        //初始化
        [self.recordWorkpointsModel.selectedArray removeAllObjects];
        
        for (int i = 0; i < self.recordWorkpointsModel.workday.count; i++) {
            NSMutableArray *subSelectedArray = [NSMutableArray array];
            for (int j = 0; j < [[self.recordWorkpointsModel.workday[i] list] count]; j++) {
                [subSelectedArray addObject:@0];//0是未选中，1是选中
 
            }
            [self.recordWorkpointsModel.selectedArray addObject:subSelectedArray];

        }
        
//        [self.recordWorkpointsModel.workday enumerateObjectsUsingBlock:^(NSArray *workDayArr, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSMutableArray *subSelectedArray = [NSMutableArray array];
//            [workDayArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [subSelectedArray addObject:@0];//0是未选中，1是选中
//            }];
//            [self.recordWorkpointsModel.selectedArray addObject:subSelectedArray];
//        }];
        [self.tableView reloadData];
        
        [self.recordBillWaterView setAmount:[self.recordWorkpointsModel.total floatValue] income:[self.recordWorkpointsModel.total_income floatValue] expend:[self.recordWorkpointsModel.total_expend floatValue] andcloseAnAccount:[self.recordWorkpointsModel.total_balance floatValue]];
        
        self.yearLable.text = [NSDate stringFromDate:self.date?:[NSDate date] format:@"yyyy-MM"];


        
        self.topRightButton.hidden = !self.recordWorkpointsModel.selectedArray.count;
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        
        self.yearLable.text = [NSDate stringFromDate:self.date?:[NSDate date] format:@"yyyy-MM"];

        [TYLoadingHub hideLoadingView];
    }];
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recordWorkpointsModel.workday.count == 0 && indexPath.section == 1) {
        return TYGetUIScreenHeight - kCellHeaderHeightRation - kCellFirstHeightRation - 60 ;
    }
    return indexPath.section == 0?0:(kNormalCellHeight+30);

    
//    return indexPath.section == 0?kCellHeaderHeightRation:(kNormalCellHeight+30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    
    
    if (self.recordWorkpointsModel.workday.count <= 0 && section == 1 ) {
        return 36;
    }
    
    
    return 30;
//    return section == 1?kCellFirstHeightRation + 30:30;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = self.recordWorkpointsModel.workday.count + 1;
    return sectionNum>2?sectionNum:2;//还有一个底部的，所以多加了一个,没数据时也要显示2个
}

// 根据状态来判断是否显示该组，隐藏组把组的行数设置为0即可
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.recordWorkpointsModel.workday.count + 1) < section) {
        return 0;
    }
    
    if (section == 0) {
//        return 1;

        return 0;
    }else{
        if (self.recordWorkpointsModel.workday.count == 0) {
            return 1;
        }
        
        NSArray *workDayArr = [self.recordWorkpointsModel.workday[section - 1] list];
        return workDayArr.count;
    }
}

// 添加每行显示的内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.recordWorkpointsModel.workday.count + 1) < indexPath.section) {
        return 0;
    }
    
    if (indexPath.section == 0) {
        YZGGetIndexRecordFirstTableViewCell *firstCell = [YZGGetIndexRecordFirstTableViewCell cellWithTableView:tableView];
        
//        [firstCell setAmount:self.getIndexRecordModel.total income:self.getIndexRecordModel.total_income expend:self.getIndexRecordModel.total_expend];
//        [firstCell setAmount:[self.recordWorkpointsModel.total floatValue] income:[self.recordWorkpointsModel.total_income floatValue] expend:[self.recordWorkpointsModel.total_expend floatValue] andcloseAnAccount:[self.recordWorkpointsModel.total_balance floatValue]];

        return firstCell;
    }else{
        if (self.recordWorkpointsModel.workday.count == 0) {
            static NSString *cellID = @"YZGGetIndexRecordViewControllerCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:self.yzgNoWorkitemsView];
            }

            return cell;
        }
        YZGGetIndexRecordTableViewCell *getIndexRecordCell = [YZGGetIndexRecordTableViewCell cellWithTableView:tableView];
        NSArray *workDayArr = [self.recordWorkpointsModel.workday[indexPath.section - 1] list];
        getIndexRecordCell.isDeleting = _isDeleting;
        getIndexRecordCell.isFirstCell = indexPath.row == 0;
        getIndexRecordCell.isLastCell = indexPath.row == (workDayArr.count - 1);
        
        
        getIndexRecordCell.needAnimate = NO;//_needAnimate;
        NSMutableArray *selectedArr = self.recordWorkpointsModel.selectedArray[indexPath.section - 1];
        [getIndexRecordCell setDeleteImageViewHighlighted:[selectedArr[indexPath.row] boolValue]];
        
        MateWorkitemsItems *mateWorkitemsItems = workDayArr[indexPath.row];
        getIndexRecordCell.mateWorkitemsItems = mateWorkitemsItems;
        return getIndexRecordCell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0 ) {
        
        return [[UIView alloc]initWithFrame:CGRectZero];
        
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    view.backgroundColor = AppFontf1f1f1Color;
    
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ) {
        
        return 0;
    }
    return 10;
}
// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
//    if (section != 1 && section > 1) {
        UIView *dayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
        UILabel *Daylable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
        Daylable.textAlignment = NSTextAlignmentLeft;
    UILabel *departlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 29.5, TYGetUIScreenWidth, 0.5)];
    departlable.backgroundColor = AppFontE6E6E6Color;
//    [dayView addSubview:departlable];

    if (!self.recordWorkpointsModel.workday.count) {
        
        dayView.backgroundColor = [UIColor whiteColor];
        
        departlable.backgroundColor = [UIColor whiteColor];
        
        departlable.hidden = YES;
        
    }else{
        dayView.backgroundColor = AppFontfafafaColor;
        
        departlable.backgroundColor = AppFontfafafaColor;
        departlable.hidden = NO;

    }
    
    if (self.recordWorkpointsModel.workday.count) {

        Daylable.text = [self.recordWorkpointsModel.workday[section - 1] date];
   
    
        if (![NSString isEmpty:Daylable.text]) {
            if (![Daylable.text containsString:@"日"]) {
                Daylable.text = [Daylable.text stringByAppendingString:@"日"];
  
            }
        }
        
         }
        Daylable.font = [UIFont systemFontOfSize:14];
        Daylable.textColor = AppFont999999Color;
        [dayView addSubview:Daylable];
        
//        UILabel *subDaylable = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 30, 20)];
//        subDaylable.backgroundColor = AppFontf1f1f1Color;
//        subDaylable.text = [self.recordWorkpointsModel.workday[section - 1] date_turn];
//        subDaylable.font = [UIFont systemFontOfSize:14];
//        subDaylable.textAlignment = NSTextAlignmentCenter;
//        subDaylable.textColor = AppFont999999Color;
//        [dayView addSubview:subDaylable];
        return dayView;
//    }
//    
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewHeaderViewID];
//    
//    YZGGetIndexRecordHeaderTableViewCell *cellHeaderView;
//    if(!headerView) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTableViewHeaderViewID];
//        headerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, kCellFirstHeightRation +30);
//        cellHeaderView = [YZGGetIndexRecordHeaderTableViewCell cellWithTableView:tableView];
//        cellHeaderView.frame = headerView.bounds;
//        [headerView addSubview:cellHeaderView];
//    }else{
//        cellHeaderView = [headerView.subviews lastObject];
//    }
//    [cellHeaderView setTitleLabelText:[NSDate stringFromDate:self.date format:@"yyyy-MM"]];
//    if (self.recordWorkpointsModel.workday) {
//        if (self.recordWorkpointsModel.workday.count) {
//            [cellHeaderView setDayLableText:[self.recordWorkpointsModel.workday[section - 1] date] andSubDayLableText:[self.recordWorkpointsModel.workday[section - 1] date_turn]];
//  
//        }
//        
//    }
//    //添加单击手势
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [headerView addGestureRecognizer:singleTap];
//
//    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isDeleting) {//正在删除
        _isAllDeleting = NO;//只要点击了，就不是全选
        NSMutableArray *selectedArr = self.recordWorkpointsModel.selectedArray[indexPath.section - 1];
        
        //设置
        BOOL selected = ![selectedArr[indexPath.row] boolValue];
        self.selectedNum += selected?1:-1;
        
        //更新数据源
        selectedArr[indexPath.row] = @(selected);
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSArray *workDayArr = [self.recordWorkpointsModel.workday[indexPath.section - 1] list];
        MateWorkitemsItems *mateWorkitemsItems = workDayArr[indexPath.row];
        
        if (mateWorkitemsItems.amounts_diff) {//有差账的情况下，弹出选择款
            _indexPath = indexPath;
            JGJPoorBillListDetailModel *poorModel = [JGJPoorBillListDetailModel new];
            poorModel.accounts_type = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItems.accounts_type.code];
            poorModel.id = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItems.id];
            poorModel.manhour =mateWorkitemsItems.manhour;
            poorModel.overtime =mateWorkitemsItems.overtime;
            poorModel.proname =mateWorkitemsItems.pro_name;
            poorModel.worker_name =mateWorkitemsItems.worker_name;
            poorModel.foreman_name =mateWorkitemsItems.foreman_name;
            poorModel.amounts =mateWorkitemsItems.amounts;
            if ([mateWorkitemsItems.date isKindOfClass:[NSDate class]]) {
                poorModel.date =[JGJTime yearAppend_Monthand_dayfromstamp:(NSDate *)mateWorkitemsItems.date];
                
            }else{
                poorModel.date =mateWorkitemsItems.date;
            }
            poorModel.is_del =[NSString stringWithFormat:@"%ld",(long)mateWorkitemsItems.is_del];
            poorModel.pid =mateWorkitemsItems.pid;
            poorModel.sub_proname =mateWorkitemsItems.sub_pro_name;
            poorModel.units =mateWorkitemsItems.unit;
            
            [JGJSurePoorBillShowView showPoorBillAndModel:poorModel AndDelegate:self andindexPath:indexPath andHidenismine:NO];

        }else{//没有差账进入编辑界面
            JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
            recordBillVC.mateWorkitemsItems = mateWorkitemsItems;
            [self.navigationController pushViewController:recordBillVC animated:YES];
        }
    }
}

//329根据是否有差账判断某一行是否可以选择
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.recordWorkpointsModel.workday.count < indexPath.section ) || (indexPath.section < 1)) {
        return NO;
    }

    NSArray *workDayArr = [self.recordWorkpointsModel.workday[indexPath.section - 1] list];
    MateWorkitemsItems *mateWorkitemsItems = workDayArr[indexPath.row];
    if (mateWorkitemsItems.modify_marking == 0 || !_isDeleting ) {
        return YES;
    }
    return NO;
    
}

#pragma mark - 点击其他月份
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    
    self.yzgDatePickerView.date = self.date;
    [self.yzgDatePickerView showDatePicker];
}

#pragma mark - 加载完成
- (void)reloadDataCompletion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        _needAnimate = NO;
    });
}

#pragma mark - 按钮的响应
#pragma mark 导航栏的删除按钮
- (IBAction)navBarDeleteBtnClick:(UIButton *)sender {
    _isAllDeleting = NO;
    sender.selected = !sender.selected;
    [self changeEidingStatus:sender.selected];
}

#pragma mark  底部bottomView的"全选"按钮
- (IBAction)bottomViewAllSelectedBtnClick:(UIButton *)sender {
    _isAllDeleting = !_isAllDeleting;
    
    __block NSInteger selectedNum = 0;
    [self.recordWorkpointsModel.selectedArray enumerateObjectsUsingBlock:^(NSMutableArray *subSelectedArray, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //如果是全选才需要读取数据源
        NSArray *workDayArr;
        if (_isAllDeleting) {
            workDayArr = [self.recordWorkpointsModel.workday[idx] list];
        }

        [subSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger subIdx, BOOL * _Nonnull stop) {
            if (_isAllDeleting) {//如果是全选才需要读取数据源
                MateWorkitemsItems *mateWorkitemsItems = workDayArr[subIdx];
                //没有差账
                BOOL selected = !mateWorkitemsItems.modify_marking;
                selectedNum += selected?1:0;
                subSelectedArray[subIdx] = @(selected);
            }else{//取消全选，全部置为NO;
                subSelectedArray[subIdx] = @(NO);
            }
        }];
    }];
    
    self.selectedNum = selectedNum;
    [self.tableView reloadData];
}

-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else{
        
        [self deleteDate];
    }
    
    alertView.delegate = nil;
    alertView = nil;
}
-(void)deleteDate
{
    __block NSMutableArray *selectIdArr = [NSMutableArray array];
    for (int i = 0; i < self.recordWorkpointsModel.selectedArray.count; i ++) {
        NSArray *workDayArr = [self.recordWorkpointsModel.workday[i] list];
        NSArray *workArr = self.recordWorkpointsModel.selectedArray[i];
        [workArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj boolValue] == YES) {
                MateWorkitemsItems *mateWorkitemsItems = workDayArr[idx];
                [selectIdArr addObject:@(mateWorkitemsItems.id)];
            }
        }];
        
    }
    
    NSDictionary *parametersDic = @{@"id":[selectIdArr componentsJoinedByString:@","]};
    if ([NSString isEmpty:parametersDic[@"id"]]) {
        [TYShowMessage showPlaint:@"请先选择需要删除的记录"];
//        [self JLGHttpRequest];
        return;
    }
    [TYLoadingHub showLoadingWithMessage:@""];

    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:parametersDic success:^(id responseObject) {
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"删除成功"];
        self.topRightButton.selected = YES;
        [self navBarDeleteBtnClick:self.topRightButton];
        [self JLGHttpRequest];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];

}
#pragma mark  底部bottomView的"删除"按钮
- (IBAction)bottomViewDeleteBtnClick:(UIButton *)sender {
    
    __block NSMutableArray *selectIdArr = [NSMutableArray array];
    for (int i = 0; i < self.recordWorkpointsModel.selectedArray.count; i ++) {
        NSArray *workDayArr = [self.recordWorkpointsModel.workday[i] list];
        NSArray *workArr = self.recordWorkpointsModel.selectedArray[i];
        [workArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj boolValue] == YES) {
                MateWorkitemsItems *mateWorkitemsItems = workDayArr[idx];
                [selectIdArr addObject:@(mateWorkitemsItems.id)];
            }
        }];
        
    }
    
    NSDictionary *parametersDic = @{@"id":[selectIdArr componentsJoinedByString:@","]};
    if ([NSString isEmpty:parametersDic[@"id"]]) {
        [TYShowMessage showPlaint:@"请先选择需要删除的记录"];
        return;
    }

    
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"确定要删除选中数据吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
        //    alert.tag = 1;
        [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
        
        [alert show];

}

#pragma mark - YZGMateShowpoor的delegate 主要涉及复制差账和修改按钮
- (void)MateShowpoorModifyBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    NSArray *workDayArr = [self.recordWorkpointsModel.workday[_indexPath.section - 1] list];
    MateWorkitemsItems *mateWorkitemsItems = workDayArr[_indexPath.row];
    
    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItems];
    
    workerGetBillVc.markBillType = MarkBillTypeEdit;
    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItems;
    [self.navigationController pushViewController:workerGetBillVc animated:YES];
    _indexPath = nil;
}

- (void)MateShowpoorCopyBillBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    [self JLGHttpRequest];
}

#pragma mark - 选择完时间以后
- (void)YZGDataPickerSelect:(NSDate *)date{
    self.topRightButton.selected = YES;
    [self navBarDeleteBtnClick:self.topRightButton];

    self.date = date;
    [self JLGHttpRequest];
}

#pragma mark - 没有记录的时候点击马上记一笔
- (void)YZGNoWorkitemsViewBtnClick:(YZGNoWorkitemsView *)YZGNoWorkitemsView{
    UIView *jgjAddNameHUBView = [JGJAddNameHUBView hasRealNameByVc:self];
    
    if (jgjAddNameHUBView) {
        return;
    }
    
//    UIViewController *mateReleaseBillVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"mateReleaseBillVc"];
//    
//    [mateReleaseBillVc setValue:self.date forKey:@"selectedDate"];
//    [self.navigationController pushViewController:mateReleaseBillVc animated:YES];
    
    
    JGJMarkBillViewController *recordContr = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
    recordContr.selectedDate = [NSDate date];
    [self.navigationController pushViewController:recordContr animated:YES];}

#pragma mark - setter方法
- (void)setSelectedNum:(NSInteger)selectedNum{
    _selectedNum = selectedNum;
    
//    NSArray *subSelectedArray = [self.getIndexRecordModel.selectedArray firstObject];
    NSString *allSelectTitleString = _isAllDeleting?@"取消全选":@"全选";
    
    NSString *deleteTitleString = _isDeleting && selectedNum!=0 ? [NSString stringWithFormat:@"删除(%@)",@(selectedNum)]:@"删除";
    [self.allSelectedButton setTitle:allSelectTitleString forState:UIControlStateNormal];
    [self.deleteButton setTitle:deleteTitleString forState:UIControlStateNormal];
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

- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _yzgDatePickerView.delegate = self;
    }
    return _yzgDatePickerView;
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 210.6)];
        _yzgNoWorkitemsView.departLable.hidden = YES;
        NSString *firstString = @"暂无记录";
        NSString *secondString = @"无法了解工钱与借支情况!";
        _yzgNoWorkitemsView.contentView.backgroundColor = [UIColor whiteColor];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",firstString,secondString]];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xb9b9b9) range:NSMakeRange(0, firstString.length)];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xcccccc) range:NSMakeRange(firstString.length + 1,secondString.length)];
        
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, firstString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(firstString.length + 1, secondString.length)];
        [_yzgNoWorkitemsView setTitleString:contentStr subString:secondString];
        [_yzgNoWorkitemsView setButtonShow:YES];

        _yzgNoWorkitemsView.delegate = self;
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}
#pragma mark - 同一记账
-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [TYLoadingHub showLoadingWithMessage:nil];
    NSArray *workDayArr = [self.recordWorkpointsModel.workday[indexpath.section - 1] list];
    MateWorkitemsItems *mateWorkitemsItems = workDayArr[indexpath.row];

    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:@{@"id":@(mateWorkitemsItems.id)} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [JGJSurePoorBillShowView removeView];
        [self JLGHttpRequest];

    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [JGJSurePoorBillShowView removeView];
        
    }];
}
#pragma mark - 修改记账
-(void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{

    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    NSArray *workDayArr = [self.recordWorkpointsModel.workday[indexpath.section - 1] list];
    MateWorkitemsItems *mateWorkitemsItems = workDayArr[indexpath.row];
    ModifyBillListVC.billModify = YES;

    ModifyBillListVC.mateWorkitemsItems = mateWorkitemsItems;
//    ModifyBillListVC.yzgGetBillModel = model;
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
    [JGJSurePoorBillShowView removeView];

    

}
- (YZGGetBillModel *)getYzgGetBillModel:(MateWorkitemsItems *)detailModel andTplModel:(YZGMateShowpoorModel *)model
{
    YZGGetBillModel *getBillModel = [YZGGetBillModel new];
    getBillModel.accounts_type.code = detailModel.accounts_type.code;
    //getBillModel.set_tpl = detailModel.set_tpl;
    getBillModel.set_tpl.s_tpl = [model.main_s_tpl?:@"0" floatValue];
    getBillModel.set_tpl.o_h_tpl = [model.main_o_h_tpl?:@"0" floatValue];
    getBillModel.set_tpl.w_h_tpl = [model.main_w_h_tpl?:@"0" floatValue];
    getBillModel.manhour = [detailModel.manhour floatValue];
    getBillModel.overtime = [detailModel.overtime floatValue];
    getBillModel.salary = detailModel.amounts;
    getBillModel.proname = detailModel.pro_name;
    getBillModel.amounts = detailModel.amounts;
    getBillModel.worker_name = detailModel.worker_name;
    getBillModel.foreman_name = detailModel.foreman_name;
    getBillModel.quantities = [model.main_set_quantities?:@"0" floatValue];
    getBillModel.pid = detailModel.pid;
    getBillModel.units = model.main_set_unitprice ;
    //    getBillModel.date = model.date;
    getBillModel.unitprice = [model.main_set_unitprice?:@"0" floatValue];
    
    return getBillModel;
}
#pragma mark 返回上级页面
- (void)backButtonPressed{
    
    if (_backMainVC) {
        
        JGJTabBarViewController *vc = (JGJTabBarViewController *)self.navigationController.parentViewController;
        
        if ([vc isKindOfClass:[JGJTabBarViewController class]]) {
            
            vc.selectedIndex = 0;
            
        }
        
        
        [self.navigationController popToRootViewControllerAnimated:NO];
 
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

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
