//
//  JGJPersonDetailWageListVc.m
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPersonDetailWageListVc.h"
#import "NSDate+Extend.h"
#import "YZGMateShowpoor.h"
#import "JGJMarkBillBaseVc.h"
#import "YZGNoWorkitemsView.h"
#import "JGJPersonLastWageListView.h"
#import "JGJWebAllSubViewController.h"
#import "JGJPersonDetailWageListModel.h"
#import "YZGWageBestDetailTableViewCell.h"
#import "YZGWageDetailTitleTableViewCell.h"

static const CGFloat kPDWLTableViewFirstTitleHeight = 30.f;
static const CGFloat kPDWLTableViewHeaderHeight = 28.f;

@interface JGJPersonDetailWageListVc ()
<
    YZGMateShowpoorDelegate,
    JGJPersonLastWageListViewDelegate
>
{
    NSIndexPath *_selectedIndexPath;//选择的cell
}
@property (nonatomic,   weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *recordNoteButton;

@property (weak, nonatomic) IBOutlet JGJPersonLastWageListView *titleView;

@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@property (nonatomic,strong) JGJPersonDetailWageListModel *jgjPersonDetailWageListModel;

@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *downBillButton;

@property (strong, nonatomic) UIBarButtonItem *backDownBillButton;

@property (nonatomic,strong) JGJeRecordBillDetailModel *RecordBillDetailModel;

@end

@implementation JGJPersonDetailWageListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.yzgMateShowpoor = nil;
    self.yzgNoWorkitemsView = nil;
}

- (void)commonSet{
    [self JLGHttpRequest];
    
    self.title = self.dataDic[@"name"];
//    self.title = @"工资账单";

    self.titleView.delegate = self;
    self.tableView.backgroundColor = JGJMainBackColor;
    [self.recordNoteButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    [TYNotificationCenter addObserver:self selector:@selector(JLGHttpRequest) name:JGJModifyBillSuccess object:nil];
    self.backDownBillButton = self.downBillButton;
}

- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
//    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/streamdetailstandard" parameters:@{@"uid":self.dataDic[@"uid"],@"month":self.dataDic[@"month"]} success:^(NSDictionary *responseObject) {
    NSInteger  timeStamp =  [[NSDate date] timeIntervalSince1970];
    NSDictionary *parmDic = @{
                              @"class_type":self.dataDic[@"class_type"],
                              @"sign":@"",
                              @"month":self.dataDic[@"month"],
                              @"target_id":self.dataDic[@"uid"],
                              @"timestamp":[NSString stringWithFormat:@"%ld",(long)timeStamp]
                              };

    [JLGHttpRequest_AFN PostWithApi:@"v2/Workdaystream/perAndProMonthBill" parameters:parmDic success:^(NSDictionary *responseObject) {
        
        self.RecordBillDetailModel = [JGJeRecordBillDetailModel mj_objectWithKeyValues:responseObject];
        

        if (self.RecordBillDetailModel.list.count) {
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        //给顶部View赋值
        NSDictionary *dataDic = @{
                                  @"total":@([self.RecordBillDetailModel.total_month floatValue]?:0),
                                  @"titleMonthStr":self.RecordBillDetailModel.total_month_txt?:@"",
                                  @"monthNum":[self.dataDic[@"month"] substringWithRange:NSMakeRange(4, 2)]?:@""
        };
        
        self.titleView.dataDic = [dataDic mutableCopy];
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.jgjPersonDetailWageListModel.pro_list.count?:1;
//    return self.RecordBillDetailModel.list.count?:1;
    return 1;

}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.RecordBillDetailModel.list.count == 0) {
        return 1;//显示默认的页面
    }
    return self.RecordBillDetailModel.list.count + 1;
//    PersonDetailWageListList *personDetailWageListList = self.jgjPersonDetailWageListModel.pro_list[section];
//    return personDetailWageListList.workday.count + 1;//第一个是日期内容
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.RecordBillDetailModel.list.count == 0) {
        return 0;//显示默认的页面
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kPDWLTableViewFirstTitleHeight*(indexPath.row == 0?1:2) ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    view.backgroundColor = JGJMainBackColor;
    return view;
}
/*
// 定义头标题的视图，添加点击事件
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.RecordBillDetailModel.list.count == 0) {
        return nil;
    }
    
    JGJeRecordBillDetailArrModel *personDetailWageListList = self.RecordBillDetailModel.list[section];
    
    NSString *sectionTitle = personDetailWageListList.name;
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([self class])];
    
    if(!myHeader) {
        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass([self class])];
        
        //添加header的Label
        UILabel * label = [[UILabel alloc] init];
        label.tag = 40;
        label.text = sectionTitle;
        label.textColor = TYColorHex(0x666666);
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(10, 0, TYGetUIScreenWidth, kPDWLTableViewHeaderHeight);
        
        //自定义header
        myHeader.frame = CGRectMake(0, 0, tableView.bounds.size.width, kPDWLTableViewHeaderHeight);
        [myHeader.contentView setBackgroundColor:JGJMainBackColor];
        [myHeader addSubview:label];
        
    }else{
        UILabel * label = [myHeader viewWithTag:40];
        label.text = sectionTitle;
    }
    return myHeader;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL countIsZero = (self.RecordBillDetailModel.list.count == 0);
    tableView.bounces = !countIsZero;//没有数据不能滑动
    
    if (countIsZero) {//没有数据显示的cell
        static NSString *cellID = @"JGJPersonDetailWageListVcCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.yzgNoWorkitemsView];
        }
        
        return cell;
    }
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        YZGWageDetailTitleTableViewCell *yzgWageDetailTitleTableViewCell = [YZGWageDetailTitleTableViewCell cellWithTableView:tableView];

        yzgWageDetailTitleTableViewCell.contentView.backgroundColor = [UIColor whiteColor];
        [yzgWageDetailTitleTableViewCell setLeftConstraint:10 middleConstraint:-10 rightConstraint:34];
        
        if ([self.dataDic[@"class_type"] isEqualToString:@"person"]) {
            [yzgWageDetailTitleTableViewCell setLeftText:@"项目名称" middleText:@"记工合计" rightText:@"合计余额"];
        }else{
            if (JLGisMateBool) {
                [yzgWageDetailTitleTableViewCell setLeftText:@"班组长" middleText:@"记工合计" rightText:@"合计金额"];
   
            }else{
                [yzgWageDetailTitleTableViewCell setLeftText:@"工人" middleText:@"记工合计" rightText:@"合计金额"];
   
            }
            

        }
        
        cell = yzgWageDetailTitleTableViewCell;
    }else{
        
        YZGWageBestDetailTableViewCell *yzgWageBestDetailTableViewCell = [YZGWageBestDetailTableViewCell cellWithTableView:tableView];

        
        
        
        yzgWageBestDetailTableViewCell.recordBillDetailArrmodel = (JGJeRecordBillDetailArrModel *)self.RecordBillDetailModel.list[indexPath.row - 1];
        
        if (indexPath.row  == self.RecordBillDetailModel.list.count) {
          
            yzgWageBestDetailTableViewCell.lineDepart.backgroundColor = self.tableView.backgroundColor;
        }else{
            yzgWageBestDetailTableViewCell.lineDepart.backgroundColor = AppFontf1f1f1Color;

        }
        
        cell = yzgWageBestDetailTableViewCell;
    }
    
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//日期的选项
        return;
    }
    
//    PersonDetailWageListList *personDetailWageListList = self.jgjPersonDetailWageListModel.pro_list[indexPath.section];
//    PersonDetailWageListWorkday *personDetailWageListWorkday = personDetailWageListList.workday[indexPath.row - 1];
    
//    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:personDetailWageListWorkday];
#pragma mark - 弹出查账的提示框
//    if (personDetailWageListWorkday.modify_marking){
//        self.yzgMateShowpoor.mateWorkitemsItem = mateWorkitemsItem;
//        [self.yzgMateShowpoor showpoorView];
//        _selectedIndexPath = indexPath;
//        return;
//    }
#pragma mark - 暂时去掉
   
//    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
//    
//    workerGetBillVc.markBillType = MarkBillTypeEdit;
//    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
//    [self.navigationController pushViewController:workerGetBillVc animated:YES];

    UIViewController *BillWorkToVc = [[UIStoryboard storyboardWithName:@"billAndpro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillWorkVC"];
    [_dataDic setObject:[(JGJeRecordBillDetailArrModel *)self.RecordBillDetailModel.list[indexPath.row - 1] pid] forKey:@"pid"];
    [_dataDic setObject:[(JGJeRecordBillDetailArrModel *)self.RecordBillDetailModel.list[indexPath.row - 1] uid] forKey:@"uid"];

    [BillWorkToVc setValue:[_dataDic mutableCopy] forKey:@"dataDicD"];

    [self.navigationController pushViewController:BillWorkToVc animated:YES];
}

#pragma mark - YZGMateShowpoor的delegate 主要涉及复制差账和修改按钮
- (void)MateShowpoorModifyBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    PersonDetailWageListList *personDetailWageListList = self.jgjPersonDetailWageListModel.pro_list[_selectedIndexPath.section];
    PersonDetailWageListWorkday *personDetailWageListWorkday = personDetailWageListList.workday[_selectedIndexPath.row - 1];
    
    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:personDetailWageListWorkday];
    
    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
    
    workerGetBillVc.markBillType = MarkBillTypeEdit;
    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
    [self.navigationController pushViewController:workerGetBillVc animated:YES];
    _selectedIndexPath = nil;
}

- (void)MateShowpoorCopyBillBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    [self JLGHttpRequest];
}

#pragma mark - 顶部view的delegate
#pragma mark 按左键
- (void)PersonLastWageListLeftBtnClick:(JGJPersonLastWageListView *)lastWageListView{
    [self changeMonth:-1];
}

#pragma mark 按右键
- (void)PersonLastWageListRightBtnClick:(JGJPersonLastWageListView *)lastWageListView{
    [self changeMonth:1];
}

#pragma mark 正数是以后n个月，负数是前n个月,切换时间以后重新获取数据
- (void)changeMonth:(NSInteger )monthNum{
    NSDate *oldDate = [NSDate dateFromString:self.dataDic[@"month"] withDateFormat:@"yyyyMM"];
    
    if (monthNum > 0 && [self isNewDate:[NSDate date] LessThanOlddate:oldDate]) {
        [TYShowMessage showPlaint:@"所选时间不能大于当前时间"];
        return;
    }
    
    NSDate *newDate = [NSDate getPriousorLaterDateFromDate:oldDate withMonth:monthNum];
    self.dataDic[@"month"] = [NSDate stringFromDate:newDate format:@"yyyyMM"];
    [self JLGHttpRequest];
}

- (BOOL)isNewDate:(NSDate *)newDate LessThanOlddate:(NSDate *)oldDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *newComp = [calendar components:unitFlag fromDate:newDate];
    NSDateComponents *oldComp = [calendar components:unitFlag fromDate:oldDate];
    return (([newComp month] <= [oldComp month]) && ([newComp year] == [oldComp year]));
}

#pragma mark - model转换
- (MateWorkitemsItems *)TransformModel:(PersonDetailWageListWorkday *)wageBestDetailWorkday{
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.overtime = wageBestDetailWorkday.overtime;
    mateWorkitemsItem.uid = [self.dataDic[@"uid"] integerValue];
    mateWorkitemsItem.amounts = wageBestDetailWorkday.amounts;
    mateWorkitemsItem.amounts_diff = wageBestDetailWorkday.modify_marking;
    mateWorkitemsItem.modify_marking = wageBestDetailWorkday.modify_marking;
    mateWorkitemsItem.manhour = wageBestDetailWorkday.manhour;
    mateWorkitemsItem.name = self.dataDic[@"name"];
    mateWorkitemsItem.accounts_type.txt = wageBestDetailWorkday.accounts_type.txt;
    mateWorkitemsItem.accounts_type.code = wageBestDetailWorkday.accounts_type.code;
    mateWorkitemsItem.overtime = wageBestDetailWorkday.overtime;
    mateWorkitemsItem.id = wageBestDetailWorkday.id;
    mateWorkitemsItem.role = JLGisLeaderBool?1:2;
    
    
    return mateWorkitemsItem;
}

#pragma mark - 马上记一笔
- (IBAction)recordNoteNow:(id)sender {
    UIViewController *mateReleaseBillVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"mateReleaseBillVc"];
    
    NSDate *selectedDate = [NSDate dateFromString:self.dataDic[@"month"] withDateFormat:@"yyyyMM"];
    [mateReleaseBillVc setValue:selectedDate forKey:@"selectedDate"];
    [self.navigationController pushViewController:mateReleaseBillVc animated:YES];
}

- (IBAction)downBill:(id)sender {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    NSString *yearStr = [self.dataDic[@"month"] substringWithRange:NSMakeRange(0, 4)];
    NSInteger monthNum = [[self.dataDic[@"month"] substringWithRange:NSMakeRange(4, 2)] integerValue];
    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeDownLoadBill URL:[[JLGHttpRequest_WX stringByAppendingString:DownLoadBillURL] stringByAppendingString:[NSString stringWithFormat:@"role=%@&cur_uid=%@&type=%@&target_uid=%@&year=%@&month=%@&ver=%@",@(JLGisMateBool?2:1),self.dataDic[@"cur_uid"],@"other",self.dataDic[@"uid"],yearStr,@(monthNum),currentVersion]]];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - getter
- (YZGMateShowpoor *)yzgMateShowpoor
{
    if (!_yzgMateShowpoor) {
        _yzgMateShowpoor = [[YZGMateShowpoor alloc] initWithFrame:TYGetUIScreenRect];
        _yzgMateShowpoor.delegate = self;
    }
    return _yzgMateShowpoor;
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:self.tableView.bounds];
        NSString *firstString = @"没有记录";
        NSString *secondString = @"无法了解工钱与借支情况!";
        _yzgNoWorkitemsView.contentView.backgroundColor = [UIColor whiteColor];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",firstString,secondString]];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xb9b9b9) range:NSMakeRange(0, firstString.length)];
        [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xcccccc) range:NSMakeRange(firstString.length + 1,secondString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, firstString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(firstString.length + 1, secondString.length)];
        [_yzgNoWorkitemsView setTitleString:contentStr subString:secondString];
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}

@end
