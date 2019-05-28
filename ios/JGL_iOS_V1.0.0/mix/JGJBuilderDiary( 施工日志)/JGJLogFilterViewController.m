//
//  JGJLogFilterViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogFilterViewController.h"
#import "JGJStartAndEndTimeTableViewCell.h"
#import "JGJLoginFilterTypeTableViewCell.h"
#import "NSDate+Extend.h"
#import "JLGDatePickerView.h"
#import "NSString+Extend.h"
#import "JGJMoreLogView.h"
#import "JGJGetPeopleInfosViewController.h"
#import "JGJChatOhterListBaseVc.h"
#import "JGJTime.h"
#import "JGJFilterListsViewController.h"
#import "JGJTaskPrincipalVc.h"
#import "JGJFilterBottomButtonView.h"
@interface JGJLogFilterViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
clickChoiceTimedelegate,
JLGDatePickerViewDelegate,
JGJTaskPrincipalVcDelegate
>
@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) JGJFilterLogModel *filterModel;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@property (weak, nonatomic) IBOutlet JGJFilterBottomButtonView *bottomView;
@end

@implementation JGJLogFilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"筛选记录";
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    
    __weak typeof(self) weakSelf = self;
    self.bottomView.bottomButtonBlock = ^(JGJFilterBottomButtonType buttonType) {
        
        // 重置
        if (buttonType == JGJFilterBottomResetButtonype) {
            
            NSDictionary *dic;
            weakSelf.getLogModel = [JGJGetLogTemplateModel new];
            weakSelf.filterModel = [JGJFilterLogModel new];
            weakSelf.peopleInfoModel = [JGJSetRainWorkerModel new];
            // 是查看自己的日志 则不同选择提交人
            if (_isMeLogType) {
                
                dic = @{
                        @"uid":[TYUserDefaults objectForKey:JLGUserUid],//提交人
                        @"cat_id": weakSelf.getLogModel.cat_id?:@"",//日志类型
                        @"send_stime": weakSelf.filterModel.netstartTime?:@"",//提交开始时间
                        @"send_etime": weakSelf.filterModel.netendTime?:@"",//提交结束
                        };
                
            }else {
                
                dic = @{
                        @"uid":weakSelf.peopleInfoModel.uid?:@"",//提交人
                        @"cat_id": weakSelf.getLogModel.cat_id?:@"",//日志类型
                        @"send_stime": weakSelf.filterModel.netstartTime?:@"",//提交开始时间
                        @"send_etime": weakSelf.filterModel.netendTime?:@"",//提交结束
                        };
            }
            
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[JGJChatOhterListBaseVc class]]) {
                    JGJChatOhterListBaseVc *otherVc = (JGJChatOhterListBaseVc *)vc;
                    JGJFilterLogModel *filter = [[JGJFilterLogModel alloc] init];;
                    filter.logType = weakSelf.getLogModel.log_type;
                    filter.cat_id = weakSelf.getLogModel.cat_id;
                    filter.cat_name = weakSelf.getLogModel.cat_name;
                    filter.netstartTime = weakSelf.filterModel.netstartTime;
                    filter.startTime = weakSelf.filterModel.startTime;
                    filter.netendTime = weakSelf.filterModel.netendTime;
                    filter.endTime = weakSelf.filterModel.endTime;
                    if (weakSelf.isMeLogType) {
                        
                        filter.uid = [TYUserDefaults objectForKey:JLGUserUid];
                        filter.name = _cur_name ? :[TYUserDefaults objectForKey:JGJUserName];
                        
                    }else {
                        
                        filter.uid = weakSelf.peopleInfoModel.uid?:@"";
                        filter.name = weakSelf.peopleInfoModel.real_name ?:@"";
                    }
                    
                    otherVc.filterModel = filter;
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
//                    [otherVc filterLogWithParamDic:dic andtype:otherType andBlock:^(JGJLogTotalListModel *LogTotalListModel) {
//
//                    }];
                    [otherVc filterLogWithParamDic:dic andtype:otherType isFielterIn:YES];
                }
            }
            
        }else if (buttonType == JGJFilterBottomConfirmButtonType) {// 确定
            
            NSDictionary *dic;
            // 是查看自己的日志 则不同选择提交人
            if (_isMeLogType) {
                
                dic = @{
                        @"uid":[TYUserDefaults objectForKey:JLGUserUid],//提交人
                        @"cat_id": weakSelf.getLogModel.cat_id?:@"",//日志类型
                        @"send_stime": weakSelf.filterModel.netstartTime?:@"",//提交开始时间
                        @"send_etime": weakSelf.filterModel.netendTime?:@"",//提交结束
                        };
                
            }else {
                
                dic = @{
                        @"uid":weakSelf.peopleInfoModel.uid?:@"",//提交人
                        @"cat_id": weakSelf.getLogModel.cat_id?:@"",//日志类型
                        @"send_stime": weakSelf.filterModel.netstartTime?:@"",//提交开始时间
                        @"send_etime": weakSelf.filterModel.netendTime?:@"",//提交结束
                        };
            }
            
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[JGJChatOhterListBaseVc class]]) {
                    JGJChatOhterListBaseVc *otherVc = (JGJChatOhterListBaseVc *)vc;
                    JGJFilterLogModel *filter = [[JGJFilterLogModel alloc] init];;
                    filter.logType = weakSelf.getLogModel.log_type;
                    filter.cat_id = weakSelf.getLogModel.cat_id;
                    filter.cat_name = weakSelf.getLogModel.cat_name;
                    filter.netstartTime = weakSelf.filterModel.netstartTime;
                    filter.startTime = weakSelf.filterModel.startTime;
                    filter.netendTime = weakSelf.filterModel.netendTime;
                    filter.endTime = weakSelf.filterModel.endTime;
                    if (weakSelf.isMeLogType) {
                        
                        filter.uid = [TYUserDefaults objectForKey:JLGUserUid];
                        filter.name = [TYUserDefaults objectForKey:JGJUserName];
                        
                    }else {
                        
                        filter.uid = weakSelf.peopleInfoModel.uid?:@"";
                        filter.name = weakSelf.peopleInfoModel.real_name ?:@"";
                    }
                    
                    otherVc.filterModel = filter;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    [otherVc filterLogWithParamDic:dic andtype:otherType andBlock:^(JGJLogTotalListModel *LogTotalListModel) {
                        
                    }];
                }
            }
        }
    };
}

- (void)setCur_name:(NSString *)cur_name {
    
    _cur_name = cur_name;
}

- (void)setOrignalFilterModel:(JGJFilterLogModel *)orignalFilterModel {
    
    _orignalFilterModel = orignalFilterModel;
    self.getLogModel = [JGJGetLogTemplateModel new];
    self.getLogModel.log_type = _orignalFilterModel.logType;
    self.getLogModel.cat_id = _orignalFilterModel.cat_id;
    self.getLogModel.cat_name = _orignalFilterModel.cat_name;
    
    self.filterModel = [JGJFilterLogModel new];
    self.filterModel.netstartTime = _orignalFilterModel.netstartTime;
    self.filterModel.startTime = _orignalFilterModel.startTime;
    self.filterModel.netendTime = _orignalFilterModel.netendTime;
    self.filterModel.endTime = _orignalFilterModel.endTime;
    
    self.peopleInfoModel = [JGJSetRainWorkerModel new];
    if (_isMeLogType) {

        self.peopleInfoModel.uid = [TYUserDefaults objectForKey:JLGUserUid];
        self.peopleInfoModel.real_name = _cur_name ? : [TYUserDefaults objectForKey:JGJUserName];
    }else {

        self.peopleInfoModel.uid = _orignalFilterModel.uid;
        self.peopleInfoModel.real_name = _orignalFilterModel.name;
    }
    
    [self.tableview reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getApproval];

}
- (void)rightItemPressed:(UIButton *)sender {

    NSDictionary *dic;
    // 是查看自己的日志 则不同选择提交人
    if (_isMeLogType) {
        
        dic = @{
                @"uid":[TYUserDefaults objectForKey:JLGUserUid],//提交人
                @"cat_id": _getLogModel.cat_id?:@"",//日志类型
                @"send_stime": self.filterModel.netstartTime?:@"",//提交开始时间
                @"send_etime": self.filterModel.netendTime?:@"",//提交结束
                };
        
    }else {
        
        dic = @{
                @"uid":_peopleInfoModel.uid?:@"",//提交人
                @"cat_id": _getLogModel.cat_id?:@"",//日志类型
                @"send_stime": self.filterModel.netstartTime?:@"",//提交开始时间
                @"send_etime": self.filterModel.netendTime?:@"",//提交结束
                };
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJChatOhterListBaseVc class]]) {
            JGJChatOhterListBaseVc *otherVc = (JGJChatOhterListBaseVc *)vc;
            JGJFilterLogModel *filter = [[JGJFilterLogModel alloc] init];;
            filter.logType = _getLogModel.log_type;
            filter.cat_id = _getLogModel.cat_id;
            filter.cat_name = _getLogModel.cat_name;
            filter.netstartTime = self.filterModel.netstartTime;
            filter.startTime = self.filterModel.startTime;
            filter.netendTime = self.filterModel.netendTime;
            filter.endTime = self.filterModel.endTime;
            if (_isMeLogType) {
                
                filter.uid = [TYUserDefaults objectForKey:JLGUserUid];
                filter.name = [TYUserDefaults objectForKey:JGJUserName];
                
            }else {
                
                filter.uid = _peopleInfoModel.uid?:@"";
                filter.name = _peopleInfoModel.real_name ?:@"";
            }
            
            otherVc.filterModel = filter;
            [self.navigationController popViewControllerAnimated:YES];

            [otherVc filterLogWithParamDic:dic andtype:otherType andBlock:^(JGJLogTotalListModel *LogTotalListModel) {
                
            }];
        }
    }
    
}

- (void)setIsMeLogType:(BOOL)isMeLogType {
    
    _isMeLogType = isMeLogType;
    [self.tableview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        JGJLoginFilterTypeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJLoginFilterTypeTableViewCell" owner:nil options:nil]lastObject];
        cell.titleLable.text = @"日志类型";
        cell.filterLogType.text = _getLogModel.cat_name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.row == 1){
        
        JGJStartAndEndTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJStartAndEndTimeTableViewCell" owner:nil options:nil]lastObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.filterModel = self.filterModel;

        return cell;

    }else{
    
        JGJLoginFilterTypeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJLoginFilterTypeTableViewCell" owner:nil options:nil]lastObject];
        cell.titleLable.text = @" 提交人";
        cell.filterLogType.text = _peopleInfoModel.real_name;
//        if (_isMeLogType) {
//
//            cell.hidden = YES;
//
//        }else {
//
//            cell.hidden = NO;
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    }else if (indexPath.row == 1){
        
        return 110;

    }else{
//        if (_isMeLogType) {
//
//            return 0;
//        }else {
//
//            return 55;
//        }
        return 55;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        JGJFilterListsViewController *listVC = [[UIStoryboard storyboardWithName:@"JGJFilterListsViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJFilterListsVC"];
        listVC.dataArr = _dataArr;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        
        if (_isMeLogType) {
            
            return;
        }
        
        JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
        
        principalVc.delegate = self;
        
        principalVc.proListModel = self.WorkCircleProListModel;;
        
        principalVc.memberSelType = JGJMemberUndertakeMemeberType;
        
        JGJSynBillingModel *selMember = [JGJSynBillingModel new];
        
        selMember.uid = self.peopleInfoModel.uid;
        
        principalVc.principalModel = selMember;
        
        [self.navigationController pushViewController:principalVc animated:YES];
    }

}

- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJSetRainWorkerModel *model = [[JGJSetRainWorkerModel alloc] init];
    model.gender = memberModel.gender;
    model.head_pic = memberModel.head_pic;
    model.telphone = memberModel.telphone;
    model.is_active = memberModel.is_active;
    model.is_admin = memberModel.is_admin?@"1":@"0";
    model.is_creater = memberModel.is_creater;
    model.is_report = memberModel.is_report;
    model.nickname = memberModel.nickname;
    model.real_name = memberModel.real_name;
    model.uid = memberModel.uid;
    self.peopleInfoModel = model;
    [self.tableview reloadData];
    
    [principalVc.navigationController popViewControllerAnimated:YES];
}
- (void)fileterLogType
{
    __weak typeof(self) weakself  = self;
    JGJMoreLogView *moreView = [[JGJMoreLogView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, 320) ishowAddRow:NO  didSelectedIndexPathBlock:^(NSIndexPath *indexpath) {
        if (indexpath.row >= _dataArr.count ) {
            return ;
        }
        _getLogModel = [JGJGetLogTemplateModel new];
        _getLogModel = _dataArr[indexpath.row];
        [weakself.tableview reloadData];
    } initWithArr:_dataArr];
    [self.view addSubview:moreView];


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
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy-MM-dd"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];

    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    
    return dateString;
}


- (void)showDatePicker
{
    NSString *dateFormat = [NSString getNumOlnyByString:[self getWeekDaysString:[NSDate date]]];
    //     NSString *dateFormat = [NSString getNumOlnyByString:[NSDate date]];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    self.jlgDatePickerView.datePicker.date = date;
    //    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
    
    [self.jlgDatePickerView showDatePickerByIndexPath:nil];


}
- (void)clickChoiceStartTime
{
    _timeType = startTimeType;

    [self showDatePicker];
}

- (void)clickChoiceEndTime
{
    _timeType = endTimeType;

    [self showDatePicker];

}
-(JGJFilterLogModel *)filterModel
{
    if (!_filterModel) {
        _filterModel = [[JGJFilterLogModel alloc]init];
    }
    return _filterModel;
}
- (void)JLGDataPickerSelect:(NSDate *)date
{
    
    if (_timeType == startTimeType) {
        _startTime = [self getTimeFromdate:date];
        _filterModel.netstartTime = [self getTimeLogFromdate:date];
        _filterModel.startTime = _startTime;
        
    }else{

        _endTime = [self getTimeFromdate:date];
        _filterModel.endTime = _endTime;
        _filterModel.netendTime = [self getTimeLogFromdate:date];

    }
    [self.tableview reloadData];
}

-(NSString *)getTimeFromdate:(NSDate *)date
{

    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}
-(NSString *)getTimeLogFromdate:(NSDate *)date
{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}
-(void)setGetLogModel:(JGJGetLogTemplateModel *)getLogModel
{
    _getLogModel = [JGJGetLogTemplateModel new];
    _getLogModel = getLogModel;
    [_tableview reloadData];

}

- (void)getApproval {
    
    NSDictionary *paridc = @{@"type":@"log",
                             @"sort":@"",
                             @"group_id":self.WorkCircleProListModel.group_id?:@"",
                             @"class_type":self.WorkCircleProListModel.class_type?:@"",
                             
                             };

    [JLGHttpRequest_AFN PostWithApi:@"/v2/Approval/approvalCatList" parameters:paridc success:^(id responseObject) {
        //    _dataArrs = [NSMutableArray array];
        _dataArr= [JGJGetLogTemplateModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)setWorkCircleProListModel:(JGJMyWorkCircleProListModel *)WorkCircleProListModel
{
    _WorkCircleProListModel = [JGJMyWorkCircleProListModel new];
    _WorkCircleProListModel = WorkCircleProListModel;

}
- (void)setPeopleInfoModel:(JGJSetRainWorkerModel *)peopleInfoModel
{
    _peopleInfoModel = [JGJSetRainWorkerModel new];
    _peopleInfoModel = peopleInfoModel;
    [_tableview reloadData];

}

@end
