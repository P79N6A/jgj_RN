//
//  JGJWageListVc.m
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWageListVc.h"
#import "MJRefresh.h"
#import "JGJWageListCell.h"
#import "YZGNoWorkitemsView.h"
#import "JGJWebAllSubViewController.h"
#import "JLGCustomViewController.h"

@interface JGJWageListVc ()
<
    YZGNoWorkitemsViewDelegate
>
@property (nonatomic,   weak) IBOutlet UILabel *titleIDLabel;

@property (nonatomic,   weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *downBillButton;

@property (strong, nonatomic) UIBarButtonItem *backDownBillButton;

@property (nonatomic, assign) NSUInteger pageNum;

@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@property (nonatomic, strong) NSMutableArray <JGJWageListModel *>*dataSourceArr;
#pragma mark - 2.1.6修改清单需求 添加按项目查找
@property (strong, nonatomic) IBOutlet UIView *topBaseView;
@property (strong, nonatomic) IBOutlet UILabel *workLable;
@property (strong, nonatomic) IBOutlet UILabel *overLable;
@property (strong, nonatomic) IBOutlet UILabel *moneyLable;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UILabel *identityLable;
@end

@implementation JGJWageListVc
#pragma mark -暗香查找 修改UI

- (void)editeUI{
    if (_segment.selectedSegmentIndex>0) {
        
    _identityLable.text = @"项目名称";
  
    }else{
    _identityLable.text = JLGisLeaderBool?@"工人":@"班组长";
    }
    CGRect rect = _topBaseView.frame;
    rect.size.height = rect.size.height + 15;
    _topBaseView.frame = rect;
    
    _workLable.textColor = AppFont666666Color;
    _overLable.textColor = AppFont666666Color;
    _moneyLable.textColor = AppFont666666Color;

    _workLable.text = [NSString stringWithFormat:@"记工合计"];
//    [self acoordingViewInitText:_workLable str:_workLable.text andlength:4];
//    _overLable.text = [NSString stringWithFormat:@"加班合计\n 单位:个工"];
//    [self acoordingViewInitText:_overLable str:_overLable.text andlength:4];
    _overLable.hidden = YES;
    _moneyLable.text = [NSString stringWithFormat:@"未结工资"];
//    [self acoordingViewInitText:_moneyLable str:_moneyLable.text andlength:4];
  [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self justRealName];
}

- (void)acoordingViewInitText:(UILabel *)lable str:(NSString *)text andlength:(NSInteger)length
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setLineSpacing:2];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:10.0f]
                    range:NSMakeRange(length, text.length - length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:AppFont999999Color
                    range:NSMakeRange(length, text.length - length)];
//    attrStr =  [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(5.5f)}];//设置字间距
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,text.length)];//设置行间距

    lable.attributedText = attrStr;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self editeUI];
    self.navigationItem.titleView = self.segment;
}

- (void)commonSet{
    self.titleIDLabel.text = JGJRecordIDStr;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(wageListLoadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(wageListLoadMoreData)];
    [self.tableView.mj_header beginRefreshing];
    
    [TYNotificationCenter addObserver:self selector:@selector(wageListLoadNewData) name:JGJModifyBillSuccess object:nil];
    self.backDownBillButton = self.downBillButton;

}

- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

- (void)wageListLoadMoreData {
    [self JLGHttpRequest:NO];
}

- (void)wageListLoadNewData {
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}

- (void)JLGHttpRequest:(BOOL )isLoadNewData {
//时间戳 2.1.6版本需要
    
    [TYLoadingHub showLoadingWithMessage:nil];

    NSInteger  timeStamp =  [[NSDate date] timeIntervalSince1970];
    NSDictionary *parmDic = @{@"pg":@(self.pageNum),
                              @"pagesize":@"60",
                              @"class_type":_segment.selectedSegmentIndex == 0?@"person":@"project",
                              @"sign":@"",
                              @"timestamp":[NSString stringWithFormat:@"%ld",timeStamp]

                              
                              };
//    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/accountobjlist" parameters:parmDic success:^(NSDictionary *responseObject) {


    [JLGHttpRequest_AFN PostWithApi:@"v2/workdaystream/payPolllist" parameters:parmDic success:^(NSDictionary *responseObject) {
        NSArray *dataArray = [JGJWageListModel mj_objectArrayWithKeyValuesArray:responseObject];
        [TYLoadingHub hideLoadingView];
        
        //如果是下拉刷新，清空之前数据
        isLoadNewData?[self.dataSourceArr removeAllObjects]:nil;
        
        if (!(dataArray.count == 0 && self.dataSourceArr.count == 0)) {
            ++self.pageNum;
            [self.dataSourceArr addObjectsFromArray:dataArray];
            self.tableView.hidden = NO;
            
            self.navigationItem.rightBarButtonItem = self.backDownBillButton;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.dataSourceArr.count < 10) {
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];

        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (IBAction)pushToDownBillBtnClick:(id)sender {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    JGJWageListModel *jgjWageListModel;
    if (self.dataSourceArr.count !=0) {
        jgjWageListModel = self.dataSourceArr[0];
    }else{
        return;
    }
    JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:[[JGJWebDiscoverURL stringByAppendingString:DownLoadBillURL] stringByAppendingString:[NSString stringWithFormat:@"role=%@&uid=%@&class_type=%@",@(JLGisMateBool?1:2),@(jgjWageListModel.cur_uid),_segment.selectedSegmentIndex == 0?@"person":@"project"]]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - tableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count?:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceArr.count == 0) {
        static NSString *cellID = @"YZGGetIndexRecordViewControllerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.yzgNoWorkitemsView];
        }
        
        return cell;
    }
    
    JGJWageListCell *cell = [JGJWageListCell cellWithTableView:tableView];
    
    if (self.segment.selectedSegmentIndex == 0) {
        cell.acodingPro = NO;
    }else{
        cell.acodingPro = YES;

    }
    JGJWageListModel *jgjWageListModel = self.dataSourceArr[indexPath.row];
    cell.jgjWageListModel = jgjWageListModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *personWageListVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints_WageList" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPersonWageListVc"];
    
    JGJWageListModel *jgjWageListModel = self.dataSourceArr[indexPath.row];
    
    NSDictionary *dataDic = @{@"uid":@(jgjWageListModel.target_id),@"name":jgjWageListModel.name?:@"",@"cur_uid":@(jgjWageListModel.cur_uid),@"class_type":jgjWageListModel.class_type?:@""};
    [personWageListVc setValue:dataDic forKey:@"dataDic"];
    
    [self.navigationController pushViewController:personWageListVc animated:YES];
}




#pragma mark - getter
- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:self.tableView.frame];
        CGRect rect = self.tableView.frame;
        rect.origin.y -= 1;
//        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:self.tableView.frame];
        [_yzgNoWorkitemsView setFrame:rect];
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
        [_yzgNoWorkitemsView setButtonShow:NO];
        
        _yzgNoWorkitemsView.delegate = self;
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}


- (void)scrollRecordViewreloadData:(UISegmentedControl *)control
{
    if (_segment.selectedSegmentIndex>0) {
        _identityLable.text = @"项目名称";
        
    }else{
        _identityLable.text = JLGisLeaderBool?@"工人":@"班组长";
    }
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
    switch (control.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    _identityLable.text = JLGisLeaderBool?@"工人":@"班组长";
//    [super viewWillAppear:animated];
//    self.pageNum = 1;
//    _segment.selectedSegmentIndex = 0;
//    
//
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}
- (UISegmentedControl *)segment
{
    if (!_segment) {
        
        NSArray *array;
        if (!JLGisLeaderBool) {
           array = [NSArray arrayWithObjects:@"按班组长",@"按项目", nil];

        }else{
           array = [NSArray arrayWithObjects:@"按工人",@"按项目", nil];

        }
        //初始化UISegmentedControl
        _segment = [[UISegmentedControl alloc]initWithItems:array];
        //设置frame
        _segment.frame = CGRectMake(0, 0, TYGetUIScreenWidth/5*2, 29);
        
        _segment.tintColor = JGJMainColor;
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                 NSForegroundColorAttributeName: AppFontffffffColor};
        [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                   NSForegroundColorAttributeName: JGJMainColor};
        [_segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(scrollRecordViewreloadData:) forControlEvents:UIControlEventValueChanged];
        _segment.layer.cornerRadius = 4;
        _segment.layer.masksToBounds = YES;
        _segment.layer.borderColor = JGJMainColor.CGColor;
        _segment.layer.borderWidth = 1;
    }
    return _segment;
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
