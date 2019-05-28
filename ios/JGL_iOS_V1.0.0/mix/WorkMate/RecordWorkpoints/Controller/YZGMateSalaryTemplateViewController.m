//
//  YZGMateSalaryTemplateViewController.m
//  mix
//
//  Created by Tony on 16/3/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateSalaryTemplateViewController.h"
#import "TYFMDB.h"
//#import "JLGPickerView.h"
#import "JGJMarkBillBaseVc.h"
#import "JGJWorkTypeCollectionView.h"
#import "YZGRecordWorkNextVcTableViewCell.h"
#import "YZGRecordWorkInputInfoTableViewCell.h"
#import "YZGMateReleaseBillViewController.h"//父Vc
#import "JGJMorePeopleViewController.h"
#import "JGJQRecordViewController.h"
#import "JGJMarkDayBillVc.h"
#import "JGJModifyBillListViewController.h"
#import "JGJMarkBillViewController.h"
static const CGFloat kNormalCellHeight = 50.f;

@interface YZGMateSalaryTemplateViewController ()
<
//    JLGPickerViewDelegate,
    YZGRecordWorkBaseInfoTableViewCellDelegate
>

@property (nonatomic,copy) NSString *recordIDStr;
@property (nonatomic,strong) GetBillSet_Tpl *getBillSetTpl;
@property (nonatomic,copy) NSArray *workTimeDataArray;//上班时间
@property (nonatomic,copy) NSArray *workOverTimeDataArray;//上班时间
@property (nonatomic,copy) JGJMoneyListModel *moneyModel;//上班时间

@property (nonatomic,copy)   NSArray *cellDataArray;
//@property (nonatomic,strong) JLGPickerView *jlgPickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveDataButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomLayoutB;
@end

@implementation YZGMateSalaryTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.saveDataButton.layer setLayerCornerRadius:5];
    [self initGetBillSetTpl];
    self.recordIDStr = self.yzgGetBillModel.role == 1?@"班组长/工头":@"工人";
    
    self.title = [NSString stringWithFormat:@"%@(%@)",@"设置工资标准",self.yzgGetBillModel.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

//    self.jlgPickerView = nil;
    self.workTimeDataArray = nil;
    self.workOverTimeDataArray = nil;
}

#pragma mark - tableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.yzgGetBillModel) {
        return 0;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.yzgGetBillModel) {
        return 0;
    }
    
    UITableViewCell *cell;
    
    if (indexPath.row == 2) {
        return [self configureInputInfoCell:cell atIndexPath:indexPath];
    }else{
        return [self configureNextVcCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return;
    }
    
    YZGRecordWorkInputInfoTableViewCell *inputInfoCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [inputInfoCell endEditing:YES];
    
//    self.jlgPickerView.subTitleLabel.text = [NSString stringWithFormat:@"(与%@协商的几个小时算一个工)",self.recordIDStr];
    
    JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
    timeModel.isIntHour = YES;
    timeModel.isShowWorkTime = NO;
    SelectedTimeType selectedTimeType = WageLevelNormalWorkTimeType;
    if (indexPath.row == 0) {
        selectedTimeType = WageLevelNormalWorkTimeType;
        timeModel.startTime = 4;
        timeModel.limitTime = 12;
        timeModel.titleStr = @"选择上班时长";
        if (self.yzgGetBillModel.manhour == 0) {
            timeModel.currentTime = 8;
        }else {
            timeModel.currentTime = self.yzgGetBillModel.manhour; //传入当前的时间作为选中标记
        }
    }else if(indexPath.row == 1){
        selectedTimeType = WageLevelOverWorkTimeType;
        timeModel.startTime = 1;
        timeModel.limitTime = 12;
        timeModel.titleStr = @"选择加班时长";
        if (self.yzgGetBillModel.overtime == -1 || self.yzgGetBillModel.overtime == 0) {
            timeModel.currentTime = 6;
        }else {
            timeModel.currentTime = self.yzgGetBillModel.overtime; //传入当前的时间作为选中标记
        }
    }
    
    __weak typeof(self) weakSelf = self;
    JGJWorkTypeCollectionView *timeCollectionView = [[JGJWorkTypeCollectionView alloc] initWithFrame:TYGetUIScreenRect timeModel:timeModel SelectedTimeType:selectedTimeType isOnlyShowHeaderView:YES blockSelectedTime:^(JGJShowTimeModel *timeModel) {
        
        [weakSelf modifyTime:timeModel indexPath:indexPath];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:timeCollectionView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.yzgGetBillModel) {
        return 0;
    }

    return kNormalCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat hegitHeader = 15;
    
    return hegitHeader;
}

#pragma mark - cell的配置
- (YZGRecordWorkInputInfoTableViewCell *)configureInputInfoCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell = [YZGRecordWorkInputInfoTableViewCell cellWithTableView:self.tableView];
    
    YZGRecordWorkInputInfoTableViewCell *inpufInfoCell= (YZGRecordWorkInputInfoTableViewCell *)cell;
    
    inpufInfoCell.delegate = self;
    inpufInfoCell.indexPath = indexPath;
    [inpufInfoCell setDetailTFEnable:YES];
    [inpufInfoCell setDetailIsOnlyNum:YES];//设置只能输入的是数字
    [inpufInfoCell.detailTF becomeFirstResponder];
    [inpufInfoCell setTitle:self.cellDataArray[indexPath.row][0] setDetail:self.getBillSetTpl.s_tpl > 0?[NSString stringWithFormat:@"%.2f",(CGFloat )self.getBillSetTpl.s_tpl]:nil];
    [inpufInfoCell setUnitLabel:@"元" color:nil];
    [inpufInfoCell setDetailTFPlaceholder:self.cellDataArray[indexPath.row][1]];

    //设置数字输入带有小数点
    [inpufInfoCell setDetailIsOnlyDecimalPad];

    return inpufInfoCell;
}

- (YZGRecordWorkNextVcTableViewCell *)configureNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell = [YZGRecordWorkNextVcTableViewCell cellWithTableView:self.tableView];
    
    YZGRecordWorkNextVcTableViewCell *nextVcCell= (YZGRecordWorkNextVcTableViewCell *)cell;
    
    NSString *titleString = self.cellDataArray[indexPath.row][0];
    NSString *detailString;
    if (indexPath.row == 0) {
        detailString = self.getBillSetTpl.w_h_tpl > 0?[NSString stringWithFormat:@"%@小时算1个工",@(self.getBillSetTpl.w_h_tpl)]:self.cellDataArray[indexPath.row][1];

    }else if(indexPath.row == 1){
        detailString = self.getBillSetTpl.o_h_tpl > 0?[NSString stringWithFormat:@"%@小时算1个工",@(self.getBillSetTpl.o_h_tpl)]:self.cellDataArray[indexPath.row][1];
    }

    [nextVcCell setTitle:titleString setDetail:detailString];
    [nextVcCell setTitleColor:nil setDetailColor:JGJMainColor];
    
    return nextVcCell;
}

- (IBAction)saveDataBtnClick:(id)sender {
    YZGRecordWorkInputInfoTableViewCell *inputInfoCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    self.getBillSetTpl.s_tpl = [[inputInfoCell getDetail] floatValue];
    
    //修改了以后，上班时间和模板一致，加班时间为0
    if (self.yzgGetBillModel.set_tpl.w_h_tpl != self.getBillSetTpl.w_h_tpl) {
        self.yzgGetBillModel.manhour = self.getBillSetTpl.w_h_tpl;
    }
    
    if (self.yzgGetBillModel.set_tpl.o_h_tpl != self.getBillSetTpl.o_h_tpl) {
        self.yzgGetBillModel.overtime = 0;
    }else if(self.yzgGetBillModel.overtime == -1){
        self.yzgGetBillModel.overtime = 0;//保存以后就直接为0了
    }
    
    self.yzgGetBillModel.set_tpl = self.getBillSetTpl;
    
    JGJMarkBillBaseVc *getBillVc;
    if (self.superViewIsGroup) {
        YZGMateReleaseBillViewController *releaseBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        
        getBillVc = (JGJMarkBillBaseVc * )[releaseBillVc getSubViewController];
    }else{
        getBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    }
    
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (_morepeple) {
            if ([vc isKindOfClass:[JGJMorePeopleViewController class]]) {
            JGJMorePeopleViewController *more = (JGJMorePeopleViewController *)vc;
            more.yzgGetBillModel = self.yzgGetBillModel;
                break;

            }
        }else if ([vc isKindOfClass:[JGJMarkBillViewController class]]){
            JGJMarkBillViewController *recordVc = (JGJMarkBillViewController *)vc;
            recordVc.yzgGetBillModel = self.yzgGetBillModel;
            break;
      }else if ([vc isKindOfClass:[JGJModifyBillListViewController class]]){
          JGJModifyBillListViewController *modifyBill = (JGJModifyBillListViewController *)vc;
          modifyBill.yzgGetBillModel = self.yzgGetBillModel;
          break;

      }
    }
    
#pragma mark - 源代码
    /*
    [getBillVc ModifySalaryTemplateData];
    [self.navigationController popViewControllerAnimated:YES];

    */
//    [getBillVc ModifySalaryTemplateData];

//    if (self.superViewIsGroup) {
//    [getBillVc ModifySalaryTemplateData];

//}
    if ([getBillVc isKindOfClass:[JGJMarkDayBillVc class]]) {
        [getBillVc ModifySalaryTemplateData];

    }

    NSDictionary *dic = @{@"s_tpl":[NSString stringWithFormat:@"%d",(int)self.yzgGetBillModel.set_tpl.s_tpl],
                          @"w_h_tpl":[NSString stringWithFormat:@"%d",(int)self.yzgGetBillModel.set_tpl.w_h_tpl],
                          @"o_h_tpl":[NSString stringWithFormat:@"%d",(int)self.yzgGetBillModel.set_tpl.o_h_tpl]};
    [TYUserDefaults setObject:dic forKey:@"bill"];
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - pickerView选中以后
//- (void)JLGPickerViewSelect:(NSArray *)finishArray{
//    if (finishArray.count == 3) {//取消
//        return;
//    }
//    
//    __block NSIndexPath *indexPath;
//    [finishArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSIndexPath class]]) {
//            indexPath = obj;
//        }
//    }];
//    
//    YZGRecordWorkNextVcTableViewCell *nextVcCell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//    NSString *dataName = [[finishArray firstObject][@"name"] stringByAppendingString:@"算一个工"];
//    NSString *dataCode = [finishArray firstObject][@"id"];
//
//    [nextVcCell setDetail:dataName];
//    if(indexPath.row == 0){//正常上班
//        self.getBillSetTpl.w_h_tpl = [dataCode floatValue];
//    }else if(indexPath.row == 1){//加班时间
//        self.getBillSetTpl.o_h_tpl = [dataCode floatValue];
//    }
//}

- (void)modifyTime:(JGJShowTimeModel *)timeModel indexPath:(NSIndexPath *)indexPath{

    YZGRecordWorkNextVcTableViewCell *nextVcCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *dataName = [NSString string];
    NSString *dataCode = [NSString string];

    if(indexPath.row == 0){//正常上班
        self.yzgGetBillModel.manhour = timeModel.time;
        self.yzgGetBillModel.manhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (timeModel.time == 0) {
            dataName = timeModel.timeStr;
        }else {
            dataName = [self.yzgGetBillModel.manhourTimeStr stringByAppendingString:@"算1个工"];
        }
        dataCode = [NSString stringWithFormat:@"%@",@(self.yzgGetBillModel.manhour)];
        
        self.getBillSetTpl.w_h_tpl = [dataCode floatValue];
    }else if(indexPath.row == 1){//加班时间
        self.yzgGetBillModel.overtime = timeModel.time;
        self.yzgGetBillModel.overhourTimeStr = [timeModel.timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (timeModel.time == 0) {
            dataName = timeModel.timeStr;
        }else {
             dataName = [self.yzgGetBillModel.overhourTimeStr stringByAppendingString:@"算1个工"];
        }
        dataCode = [NSString stringWithFormat:@"%@",@(self.yzgGetBillModel.overtime)];
        
        self.getBillSetTpl.o_h_tpl = [dataCode floatValue];
    }
    [nextVcCell setDetail:dataName];
}


- (NSArray *)cellDataArray
{
    if (!_cellDataArray) {
        _cellDataArray = @[
                               @[@"上班时长",@"请选择"],
                               @[@"加班时长",@"请选择"],
                               @[@"每天工资标准(或预估)",[NSString stringWithFormat:@"与%@协商的金额(可不填)",self.recordIDStr]]
                           ];
    }
    return _cellDataArray;
}

- (void )initGetBillSetTpl
{
    if (!_getBillSetTpl) {
        _getBillSetTpl = [[GetBillSet_Tpl alloc] init];
        _getBillSetTpl.s_tpl = self.yzgGetBillModel.set_tpl.s_tpl > 0?self.yzgGetBillModel.set_tpl.s_tpl:0;
        _getBillSetTpl.w_h_tpl = self.yzgGetBillModel.set_tpl.w_h_tpl > 0?self.yzgGetBillModel.set_tpl.w_h_tpl:8;
        _getBillSetTpl.o_h_tpl = self.yzgGetBillModel.set_tpl.o_h_tpl > 0?self.yzgGetBillModel.set_tpl.o_h_tpl:6;
    }
}

//-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
//{
////    self.yzgGetBillModel = [YZGGetBillModel new];
////    self.yzgGetBillModel = yzgGetBillModel;
//
//}
//#pragma mark - 懒加载
//- (JLGPickerView *)jlgPickerView
//{
//    if (!_jlgPickerView) {
//        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
//        _jlgPickerView.delegate = self;
//    }
//    return _jlgPickerView;
//}

- (NSArray *)workTimeDataArray
{
    if (!_workTimeDataArray) {
        //从4个小时开始算
        NSArray *workTimeArray = [TYFMDB searchTable:TYFMDBWorkTimeName];
        _workTimeDataArray = [workTimeArray subarrayWithRange:NSMakeRange(4, workTimeArray.count - 4)];
    }
    return _workTimeDataArray;
}

- (NSArray *)workOverTimeDataArray
{
    if (!_workOverTimeDataArray) {
        NSArray *workOverTimeArray = [TYFMDB searchTable:TYFMDBWorkOverTimeName];
        _workOverTimeDataArray = [workOverTimeArray subarrayWithRange:NSMakeRange(1, workOverTimeArray.count - 1)];
    }
    return _workOverTimeDataArray;
}
@end
