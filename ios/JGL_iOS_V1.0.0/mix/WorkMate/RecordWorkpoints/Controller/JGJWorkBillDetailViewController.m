//
//  JGJWorkBillDetailViewController.m
//  mix
//
//  Created by Tony on 2017/4/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkBillDetailViewController.h"
#import "JGJPersonLastWageListView.h"
#import "JGJBillWorkTopView.h"
#import "JGJPersonDetailWageListModel.h"
#import "YZGWageBestDetailTableViewCell.h"
#import "JGJTotalTimeView.h"
#import "JGJChatBootomButton.h"
#import "NSDate+Extend.h"
#import "YZGMateShowpoor.h"
#import "JGJMarkBillBaseVc.h"
#import "YZGNoWorkitemsView.h"
#import "JGJTitleContentView.h"
#import "JGJWebAllSubViewController.h"
#import "JGJQRecordViewController.h"
#import "JGJRecordBillDetailViewController.h"
#import "JGJSurePoorBillShowView.h"
#import "JGJModifyBillListViewController.h"
#import "JGJMarkBillViewController.h"
@interface JGJWorkBillDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
JGJPersonLastWageListViewDelegate,
YZGMateShowpoorDelegate,
JGJSurePoorBillShowViewDelegate
>
{

    UIBarButtonItem *rightBarItem;
}

@property (strong, nonatomic) IBOutlet JGJBillWorkTopView *contentViewLable;

@property (strong, nonatomic) IBOutlet JGJPersonLastWageListView *topView;

@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;

@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@property (nonatomic, strong) JGJTitleContentView *TitleContentView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIView *placeView;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet JGJTotalTimeView *totalWorkView;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong) JGJPersonDetailWageListModel *jgjPersonDetailWageListModels;

@property (nonatomic,strong) JGJeRecordFourBillDetailModel *recordFourBillDetailModel;

@end

@implementation JGJWorkBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)loadviewJ{
    
    self.view.backgroundColor = AppFontf1f1f1Color;

    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = AppFontf1f1f1Color;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topView.delegate = self;
    
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.title = _dataDicD[@"name"]?:@"";
//    self.title = @"工资账单";

    [TYNotificationCenter addObserver:self selector:@selector(JLGHttpRequest) name:JGJModifyBillSuccess object:nil];
    rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下载账单" style:UIBarButtonItemStylePlain target:self action:@selector(singerRecod)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem.tintColor = JGJMainColor;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = JGJCornerRadius;
    _nextButton.backgroundColor = JGJMainColor;
    [_nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.totalWorkView addSubview:self.placeView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadviewJ];

    [self JLGHttpRequest];


}
- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
    NSDictionary *paramDic = @{
                               @"uid":self.dataDicD[@"uid"],
                               @"month":self.dataDicD[@"month"],
                               @"pid":self.dataDicD[@"pid"]
                               };
    [JLGHttpRequest_AFN PostWithApi:@"v2/workdaystream/streamDetailStandardInfo" parameters:paramDic success:^(NSDictionary *responseObject) {
        self.recordFourBillDetailModel = [JGJeRecordFourBillDetailModel mj_objectWithKeyValues:responseObject];
        if ([self.dataDicD[@"class_type"] isEqualToString:@"person"]) {
            [_contentViewLable setContentLabletext:self.recordFourBillDetailModel.pro_name];//设置项目明
//            self.title =self.recordFourBillDetailModel.name;
        }else{
           [_contentViewLable setContentLabletext:self.recordFourBillDetailModel.name];//设置项目明
//            self.title =self.recordFourBillDetailModel.pro_name;
        }
        if (self.recordFourBillDetailModel.workday.count) {
            _placeView.hidden = YES;
//            _topView.transform = CGAffineTransformMakeTranslation(0, 0);
//            _totalWorkView.transform = CGAffineTransformMakeTranslation(0, 0);
//            _tableview.transform = CGAffineTransformMakeTranslation(0, 0);
//            
//            _topView.transform = CGAffineTransformMakeTranslation(0, -30);
//            _totalWorkView.transform = CGAffineTransformMakeTranslation(0, -30);
//            _tableview.transform = CGAffineTransformMakeTranslation(0, -30);
            self.navigationItem.rightBarButtonItem = rightBarItem;
            _tableview.bounces = YES;
        }else{
            _placeView.hidden = NO;
//            _topView.transform = CGAffineTransformMakeTranslation(0, -30);
//            _totalWorkView.transform = CGAffineTransformMakeTranslation(0, -30);
//            _tableview.transform = CGAffineTransformMakeTranslation(0, -30);
            self.navigationItem.rightBarButtonItem = nil;
            _tableview.bounces = NO;

        }
        //给顶部View赋值
        NSDictionary *dataDic = @{
                                  @"total":@([self.recordFourBillDetailModel.total_month floatValue]?:0),
                                  @"titleMonthStr":self.recordFourBillDetailModel.total_month_txt?:@"",
                                  @"monthNum":[self.dataDicD[@"month"] substringWithRange:NSMakeRange(4, 2)]?:@""
                                  };
            [_totalWorkView setTotallableTextworkTime:self.recordFourBillDetailModel.total_manhour totalOvertime:self.recordFourBillDetailModel.total_over];

        self.topView.dataDic = [dataDic mutableCopy];
        [self.tableview reloadData];
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recordFourBillDetailModel.workday.count <= 0) {
        static NSString *cellID = @"JGJPersonDetailWageListVcCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.yzgNoWorkitemsView];
        }
        return cell;
    }
    YZGWageBestDetailTableViewCell *yzgWageBestDetailTableViewCell = [YZGWageBestDetailTableViewCell cellWithTableView:tableView];
    
    JGJeRecordFourBillDetailArrModel *personDetailWageListList = self.recordFourBillDetailModel.workday[indexPath.row];
    
    
//    PersonDetailWageListWorkday *personDetailWageListWorkday = personDetailWageListList.workday[indexPath.row];
    yzgWageBestDetailTableViewCell.personDetailWageListWorkday = personDetailWageListList;
    yzgWageBestDetailTableViewCell.contentView.backgroundColor = [UIColor whiteColor];
    yzgWageBestDetailTableViewCell.isLastCell = indexPath.row== self.recordFourBillDetailModel.workday.count;
    yzgWageBestDetailTableViewCell.dateLabelLeft = 20;
    if (indexPath.row + 1 == self.recordFourBillDetailModel.workday.count) {
        
    yzgWageBestDetailTableViewCell.lineDepart.backgroundColor = self.tableview.backgroundColor;
    }else{
    yzgWageBestDetailTableViewCell.lineDepart.backgroundColor = AppFontf1f1f1Color;
    }
    return yzgWageBestDetailTableViewCell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = self.TitleContentView;
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_recordFourBillDetailModel.workday.count <= 0) {
        return 1;
    }
    return self.recordFourBillDetailModel.workday.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recordFourBillDetailModel.workday.count <= 0) {
        return self.tableview.frame.size.height;
    }
    return 130;
}
- (void)PersonLastWageListLeftBtnClick:(JGJPersonLastWageListView *)lastWageListView{
    [self changeMonth:-1];
}

#pragma mark 按右键
- (void)PersonLastWageListRightBtnClick:(JGJPersonLastWageListView *)lastWageListView{
    [self changeMonth:1];
}
#pragma mark 正数是以后n个月，负数是前n个月,切换时间以后重新获取数据
- (void)changeMonth:(NSInteger )monthNum{
    NSDate *oldDate = [NSDate dateFromString:self.dataDicD[@"month"] withDateFormat:@"yyyyMM"];
    
    if (monthNum > 0 && [self isNewDate:[NSDate date] LessThanOlddate:oldDate]) {
        [TYShowMessage showPlaint:@"所选时间不能大于当前时间"];
        return;
    }
    
    NSDate *newDate = [NSDate getPriousorLaterDateFromDate:oldDate withMonth:monthNum];
    self.dataDicD[@"month"] = [NSDate stringFromDate:newDate format:@"yyyyMM"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recordFourBillDetailModel.workday.count <= 0) {
        
        return ;
    }
    
    _indexPath = indexPath;

    JGJeRecordFourBillDetailArrModel *personDetailWageListList = self.recordFourBillDetailModel.workday[indexPath.row];
//    PersonDetailWageListWorkday *personDetailWageListWorkday = personDetailWageListList.workday[indexPath.row - 1];
    
    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:personDetailWageListList];
    
    if (personDetailWageListList.amounts_diff ){
//        self.yzgMateShowpoor.mateWorkitemsItem = mateWorkitemsItem;
        JGJPoorBillListDetailModel *poorModel = [JGJPoorBillListDetailModel new];
        poorModel.accounts_type = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.accounts_type.code];
        poorModel.id = [NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.id];
        poorModel.manhour =mateWorkitemsItem.manhour;
        poorModel.overtime =mateWorkitemsItem.overtime;
        poorModel.proname =mateWorkitemsItem.pro_name;
        poorModel.worker_name =mateWorkitemsItem.worker_name;
        poorModel.foreman_name =mateWorkitemsItem.foreman_name;
        poorModel.amounts =mateWorkitemsItem.amounts;
        if ([mateWorkitemsItem.date isKindOfClass:[NSDate class]]) {
            poorModel.date =[JGJTime yearAppend_Monthand_dayfromstamp:(NSDate *)mateWorkitemsItem.date];
            
        }else{
            poorModel.date =mateWorkitemsItem.date;
        }
        poorModel.is_del =[NSString stringWithFormat:@"%ld",(long)mateWorkitemsItem.is_del];
        poorModel.pid =mateWorkitemsItem.pid;
        poorModel.sub_proname =mateWorkitemsItem.sub_pro_name;
        poorModel.units =mateWorkitemsItem.unit;
        
        [JGJSurePoorBillShowView showPoorBillAndModel:poorModel AndDelegate:self andindexPath:indexPath andHidenismine:NO];
//        _selectedIndexPath = indexPath;
        return;
    }
//        JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
//    
//        workerGetBillVc.markBillType = MarkBillTypeEdit;
//        workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
//        [self.navigationController pushViewController:workerGetBillVc animated:YES];
    
    JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
    recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
    [self.navigationController pushViewController:recordBillVC animated:YES];

}
- (YZGMateShowpoor *)yzgMateShowpoor
{
    if (!_yzgMateShowpoor) {
        _yzgMateShowpoor = [[YZGMateShowpoor alloc] initWithFrame:TYGetUIScreenRect];
        _yzgMateShowpoor.delegate = self;
    }
    return _yzgMateShowpoor;
}

- (MateWorkitemsItems *)TransformModel:(JGJeRecordFourBillDetailArrModel *)wageBestDetailWorkday{
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.overtime = wageBestDetailWorkday.total_overtime_txt;
    mateWorkitemsItem.uid = [self.dataDicD[@"uid"] integerValue];
    mateWorkitemsItem.amounts = [wageBestDetailWorkday.amounts floatValue];
    
    mateWorkitemsItem.amounts_diff = [wageBestDetailWorkday.modify_marking floatValue];
    
    mateWorkitemsItem.modify_marking = [wageBestDetailWorkday.modify_marking floatValue];
    mateWorkitemsItem.manhour = wageBestDetailWorkday.total_manhour_txt;
    mateWorkitemsItem.name = self.dataDicD[@"name"];
//    mateWorkitemsItem.accounts_type.txt = wageBestDetailWorkday.accounts_type.txt;
    mateWorkitemsItem.accounts_type.code = wageBestDetailWorkday.accounts_type;
    mateWorkitemsItem.overtime = wageBestDetailWorkday.total_overtime_txt;
    mateWorkitemsItem.id = [wageBestDetailWorkday.id intValue];
    mateWorkitemsItem.role = JLGisLeaderBool?1:2;
    mateWorkitemsItem.worker_name = wageBestDetailWorkday.worker_name;
    mateWorkitemsItem.foreman_name = wageBestDetailWorkday.foreman_name;
    mateWorkitemsItem.quantities = wageBestDetailWorkday.quantities;
    mateWorkitemsItem.unitprice = wageBestDetailWorkday.unitprice;
    mateWorkitemsItem.unit = wageBestDetailWorkday.unit;
    
    return mateWorkitemsItem;
}
- (void)MateShowpoorCopyBillBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    [self JLGHttpRequest];
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:self.tableview.bounds];
        _yzgNoWorkitemsView.departLable.hidden = YES;
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
//下载账单
- (void)singerRecod
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSString *yearStr = [self.dataDicD[@"month"] substringWithRange:NSMakeRange(0, 4)];
    NSInteger monthNum = [[self.dataDicD[@"month"] substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger dayNum = 0;
    NSString *str;
    if (monthNum < 10) {
       str = [NSString stringWithFormat:@"%@-0%ld-%ld",yearStr,(long)monthNum,(long)dayNum];
    }else{
   str = [NSString stringWithFormat:@"%@-%ld-%ld",yearStr,(long)monthNum,(long)dayNum];
    }
    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[[JGJWebDiscoverURL stringByAppendingString:DownLoadBillURL] stringByAppendingString:[NSString stringWithFormat:@"role=%@&uid=%@&class_type=%@&date=%@&target_id=%@&week=%@",@(JLGisMateBool?1:2),self.recordFourBillDetailModel.uid?:@"",self.dataDicD[@"class_type"],str,self.recordFourBillDetailModel.pid?:@"",@(0)]]];
    [self.navigationController pushViewController:webViewController animated:YES];

}
- (JGJTitleContentView *)TitleContentView
{
    if (!_TitleContentView) {
        _TitleContentView = [[JGJTitleContentView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 35)];
        
    }
    return _TitleContentView;
}
//差账提示框的修改跳转页面
- (void)MateShowpoorModifyBtnClick:(YZGMateShowpoor *)yzgMateShowpoor{
    
    JGJeRecordFourBillDetailArrModel *personDetailWageListList = self.recordFourBillDetailModel.workday[_indexPath.row];

    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:personDetailWageListList];
    
//    NSArray *workDayArr = self.getIndexRecordModel.workday[_indexPath.section - 1];
//    MateWorkitemsItems *mateWorkitemsItems = workDayArr[_indexPath.row];
    
    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
    
    workerGetBillVc.markBillType = MarkBillTypeEdit;
    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
    [self.navigationController pushViewController:workerGetBillVc animated:YES];
    _indexPath = nil;
}
- (IBAction)clickNextButton:(id)sender {
    JGJMarkBillViewController *recordContr = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
    recordContr.selectedDate = [NSDate date];
    [self.navigationController pushViewController:recordContr animated:YES];
    
    
}
- (UIView *)placeView
{
    if (!_placeView) {
        _placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 65)];
        _placeView.backgroundColor = [UIColor whiteColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 8)];
        lable.backgroundColor = AppFontdbdbdbColor;
        [_placeView addSubview:lable];
    }
    return _placeView;
}
#pragma mark - 修改记账
-(void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    JGJeRecordFourBillDetailArrModel *personDetailWageListList = self.recordFourBillDetailModel.workday[indexpath.row];
    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:personDetailWageListList];
    ModifyBillListVC.billModify = YES;

    ModifyBillListVC.mateWorkitemsItems = mateWorkitemsItem;
//    ModifyBillListVC.yzgGetBillModel = model;
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
    [JGJSurePoorBillShowView removeView];


}
#pragma mark - 同一记账
-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [TYLoadingHub showLoadingWithMessage:nil];
    
    JGJeRecordFourBillDetailArrModel *personDetailWageListList = self.recordFourBillDetailModel.workday[indexpath.row];
    
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:@{@"id":personDetailWageListList.id} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [JGJSurePoorBillShowView removeView];
        
        [self JLGHttpRequest];

        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [JGJSurePoorBillShowView removeView];
        
    }];
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
    getBillModel.units =  model.main_set_unitprice ;
    getBillModel.unitprice = [model.main_set_unitprice?:@"0" floatValue];
    
    return getBillModel;
}

@end
