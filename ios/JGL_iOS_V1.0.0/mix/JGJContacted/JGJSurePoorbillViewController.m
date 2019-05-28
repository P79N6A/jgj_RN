//
//  JGJSurePoorbillViewController.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSurePoorbillViewController.h"

#import "JGJSurePoorBillDateTableViewCell.h"

#import "JGJSurePoorBillDepartTableViewCell.h"

#import "JGJPoorBillTableViewCell.h"

#import "JGJSurePoorBillShowView.h"

#import "JGJModifyBillListViewController.h"

#import "YZGNoWorkitemsView.h"

#import "JGJCusActiveSheetView.h"
#import "JGJAccountShowTypeVc.h"
#import "NSDate+Extend.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
#import "NSArray+JGJDateSort.h"

#import "UITableView+JGJLoadCategory.h"
#import "JGJSurePoorBillConfirmOffView.h"
#import "JGJRecordWorkpointsSettingController.h"
#import "RKNotificationHub.h"
#import "JLGAppDelegate.h"
#import "JGJCurrentSureBillListViewController.h"
#import "SJButton.h"
#import "JGJWebAllSubViewController.h"
@interface JGJSurePoorbillViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJPoorBillTableViewCellDelegate,

JGJSurePoorBillShowViewDelegate,

YZGNoWorkitemsViewDelegate,
CAAnimationDelegate,
JGJRecordWorkpointsSettingControllerDelegate

>
{
    NSInteger _page;
    
    BOOL _isNotHaveAnymoreData;// 标识没有任何可加载的数据了
    
}
@property (nonatomic, strong)JGJSurePoorBillModel *PoorBillModel;

@property (nonatomic, strong)NSMutableArray <JGJSurePoorBillModel *>*dataSourceArr;

@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@property (nonatomic, strong)JGJSurePoorBillShowView *surePoorBillView;

@property (nonatomic, strong)NSTimer *Timer;


@property (nonatomic, strong)NSIndexPath *indexpaths;

@property (nonatomic, strong)NSMutableArray <JGJSurePoorBillModel *>*reloadDataArr;

@property (nonatomic, assign)BOOL isShowWork;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;

@property (nonatomic, strong) JGJSurePoorBillConfirmOffView *confirmOffView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;

@property (nonatomic,strong) UIView *redDotAnimation;//购物车动画图片

@property (nonatomic, strong) SJButton *titleBtn;
@property (nonatomic, strong) UIButton *rightBtmBtn;


@end

@implementation JGJSurePoorbillViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleBtn;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = self;
    _page = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        strongSelf -> _page = 1;
        [weakSelf getDataWithPageSize:_page];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        strongSelf -> _page ++;
        [weakSelf getDataWithPageSize:_page];
    }];
    
    self.isShowWork = YES;
    
    self.topLable.text = @"点击\"确认\"即表示认可对方的记工\n去记工流水界面可查看对账完成的记工";
    self.topLable.textColor = AppFontFF6600Color;
    //默认显示工
    self.isShowWork = JGJIsShowWorkBool;
    [self.tableView.mj_header beginRefreshing];
    [self getConfirmOffStaus];

}

// 我要对账帮助中心
- (void)howToSurePoorBill {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,@"242"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)getConfirmOffStaus {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-record-confirm-off-status" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
      
        if ([responseObject[@"status"] integerValue] == 1) {
            
            [self.view addSubview:self.confirmOffView];
            [self.view bringSubviewToFront:self.confirmOffView];
            [self.confirmOffView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.top.right.bottom.mas_equalTo(0);
                
            }];
            
            self.navigationItem.rightBarButtonItem = nil;
            
        }else {
            
            _rightBtmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightBtmBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
            [_rightBtmBtn addTarget:self action:@selector(modifyWorkTime) forControlEvents:(UIControlEventTouchUpInside)];
            _rightBtmBtn.titleLabel.font = FONT(AppFont34Size);

            self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
            
            [self.confirmOffView removeFromSuperview];
            
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)beginRefreshSureBillListWithIndexPath:(NSIndexPath *)indexPath {
    
    //确认之后删除数据
    [self delDataAnimatonWithIndexPath:indexPath];
}

- (JGJSurePoorBillConfirmOffView *)confirmOffView {
    
    if (!_confirmOffView) {
        
        _confirmOffView = [[JGJSurePoorBillConfirmOffView alloc] init];
        TYWeakSelf(self);
        _confirmOffView.startConfirmBlock = ^{
          
            JGJRecordWorkpointsSettingController *recordSettingVC = [[JGJRecordWorkpointsSettingController alloc] init];
            recordSettingVC.delegate = weakself;
            [weakself.navigationController pushViewController:recordSettingVC animated:YES];
        };
    }
    return _confirmOffView;
}

#pragma mark - JGJRecordWorkpointsSettingControllerDelegate
- (void)recordWorkpointsSettingOpenOrClose:(BOOL)isOpen {
    
    if (isOpen) {
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    [self getConfirmOffStaus];
}

- (void)removeTimer {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            self.topView.transform = CGAffineTransformMakeTranslation(0, -50);
            
            self.topLable.transform = CGAffineTransformMakeTranslation(0, -50);
            
            CGRect rect = self.tableView.frame;
            
            rect.size.height += 35;
            
            [self.tableView setFrame:rect];
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -50);
            
            _yzgNoWorkitemsView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
            
        }completion:^(BOOL finished) {
            
            self.topView.hidden = YES;
            
            self.topLable.hidden = YES;
            
            self.topConstance.constant = 0;
            self.tableBottom.constant = -50;
        }];
    });
}
-(void)dealloc
{
    [_Timer invalidate];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftButtonItem];
    //查看了记账工人管理，回调请求刷新数据

    //默认显示方式
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
}

- (void)setNavigationLeftButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    leftButton.titleLabel.font = FONT(AppFont34Size);
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    NSArray *sureBillArr = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
    sureBillArr = [[NSArray alloc] init];
    [TYUserDefaults setObject:sureBillArr forKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
}

- (void)modifyWorkTime {

    JGJCurrentSureBillListViewController *sureBillList = [[JGJCurrentSureBillListViewController alloc] init];
    sureBillList.agency_uid = self.agency_uid;
    sureBillList.group_id = self.group_id;
    [self.navigationController pushViewController:sureBillList animated:YES];
}
- (void)showSheetView{
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel,@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
    [sheetView showView];
}
- (NSMutableArray<JGJSurePoorBillModel *> *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
-(NSMutableArray<JGJSurePoorBillModel *> *)reloadDataArr
{
    if (!_reloadDataArr) {
        _reloadDataArr = [[NSMutableArray alloc]init];
    }
    return _reloadDataArr;
}

- (void)getDataWithPageSize:(NSInteger)page
{

    typeof(self) weakSelf = self;
    if (![NSString isEmpty:self.currectTime]) {
        if ([self.currectTime containsString:@"(今天)"]) {
         self.currectTime = [self.currectTime stringByReplacingOccurrencesOfString:@"(今天)" withString:@""];
        }
    }
    
    if ([NSString isEmpty:self.accounts_type]) {
        
        self.accounts_type = @"";
    }
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    [parames setObject:self.currectTime?:@"" forKey:@"date"];
    [parames setObject:self.uid?:@"" forKey:@"uid"];
    [parames setObject:self.accounts_type?:@"" forKey:@"accounts_type"];
    
    if (![NSString isEmpty:self.group_id]) {
        
        [parames setObject:self.group_id forKey:@"group_id"];
    }
    
    //出勤公示进入加入项目id,和角色
    if (![NSString isEmpty:self.pro_id]) {
        
        [parames setObject:self.pro_id forKey:@"pid"];
        
        [parames setObject:JLGisLeaderBool ? @"2" : @"1" forKey:@"role"];
        
    }
    
    [parames setObject:@(page) forKey:@"pg"];
    [parames setObject:@(20) forKey:@"pagesize"];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/wait-confirm-list" parameters:parames success:^(id responseObject) {
        
        NSArray *groupByArr = [responseObject groupByDataSourceWithGropKey:@"format_create_time" dicHeaderKeys:@[@"format_create_time",@"date_desc",@"date"]];
        
        if (page == 1) {
            
            [self.dataSourceArr removeAllObjects];
            [self.dataSourceArr addObjectsFromArray:[JGJSurePoorBillModel mj_objectArrayWithKeyValuesArray:groupByArr]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        }else {
            
            [self.dataSourceArr addObjectsFromArray:[JGJSurePoorBillModel mj_objectArrayWithKeyValuesArray:groupByArr]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (self.dataSourceArr.count == 0) {
            
            NSArray *sureBillArray = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
            if (sureBillArray.count == 0) {
                
                self.navigationItem.rightBarButtonItem = nil;
                
            }else {
             
                [_rightBtmBtn setTitle:[NSString stringWithFormat:@"本次确认的(%ld)",sureBillArray.count] forState:(UIControlStateNormal)];
                _rightBtmBtn.frame = CGRectMake(0, 0, 90, 16);
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtmBtn];
                
            }
            
            [self.view addSubview:self.yzgNoWorkitemsView];
            [self.view bringSubviewToFront:self.confirmOffView];
            if (self.successBlock) {
                
                self.successBlock();
                
            }
        }else {
            
            [self.yzgNoWorkitemsView removeFromSuperview];
            
            NSArray *sureBillArray = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
            if (sureBillArray.count > 0) {
                
                [_rightBtmBtn setTitle:[NSString stringWithFormat:@"本次确认的(%ld)",sureBillArray.count] forState:(UIControlStateNormal)];
                _rightBtmBtn.frame = CGRectMake(0, 0, 90, 16);
            }else {
                
                [_rightBtmBtn setTitle:@"本次确认的" forState:(UIControlStateNormal)];
                _rightBtmBtn.frame = CGRectMake(0, 0, 80, 16);
            }
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtmBtn];
            
        }
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray *list = (NSArray *)responseObject;
            
            if (list.count < 20) {
                
                _isNotHaveAnymoreData = YES;
                UIView *footerView = [self.tableView setFooterViewInfoModel:self.footerInfoModel];
                
                self.tableView.tableFooterView = footerView;
                
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
                
                footer.stateLabel.hidden = YES;
                
                [footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                _isNotHaveAnymoreData = NO;
                self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;

                footer.stateLabel.hidden = NO;

                [footer resetNoMoreData];
            }
        }
        
        [self removeTimer];
        
    }failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceArr.count <=0) {
            static NSString *cellID = @"YZGGetIndexRecordViewControllerCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:self.yzgNoWorkitemsView];
            }
            
            return cell;
        
    }else{
    
    
        JGJPoorBillTableViewCell *PoorBillCell = [[[NSBundle mainBundle]loadNibNamed:@"JGJPoorBillTableViewCell" owner:nil options:nil]firstObject];
        
        PoorBillCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PoorBillCell.showType = self.selTypeModel.type;

        PoorBillCell.PoorBillModel = [self.dataSourceArr[indexPath.section] list][indexPath.row];
        
        if (indexPath.row == 0) {
            
            PoorBillCell.topLineViewConstain.constant = 0;
            PoorBillCell.topLineView.hidden = YES;
        }else {
            
            PoorBillCell.topLineViewConstain.constant = 5;
            PoorBillCell.topLineView.hidden = NO;
        }
        PoorBillCell.indexPath  = indexPath;
        
        PoorBillCell.delegate = self;
        
        typeof(self) weakSelf = self;
        
        PoorBillCell.poorBillTableViewCellBlock = ^(JGJPoorBillTableViewCell *cell) {
            
            NSIndexPath *curIndexpath = [tableView indexPathForCell:cell];
            
            NSMutableArray *list = weakSelf.dataSourceArr[cell.indexPath.section].list;
            
            if (list.count > 1) {
                
                [list removeObjectAtIndex:curIndexpath.row];
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.tableView deleteRowsAtIndexPaths:@[curIndexpath] withRowAnimation:UITableViewRowAnimationRight];
                
                [weakSelf.tableView endUpdates];
                
                
            }else{
                
                [weakSelf.dataSourceArr removeObjectAtIndex:curIndexpath.section];
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:curIndexpath.section] withRowAnimation:UITableViewRowAnimationRight];

                [weakSelf.tableView endUpdates];
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
                
                
            });
            
        };
        
        return PoorBillCell;
    }
        
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSourceArr.count == 0) {
       
        if (section == 0) {
            
            return 1;
        }
    }
    
    return [[self.dataSourceArr[section] list] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSourceArr.count <= 0) {
        return TYGetUIScreenHeight;
    }

    if ([[[self.dataSourceArr[indexPath.section] list][indexPath.row] accounts_type]?:@"" intValue] >1) {
        return 140 + 5;
    }
    return 166 + 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSourceArr.count;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//   [JGJSurePoorBillShowView showPoorBillAndModel:[self.dataSourceArr[indexPath.section] list][indexPath.row] AndDelegate:self andindexPath:indexPath andHidenismine:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    JGJSurePoorBillModel *model = self.dataSourceArr[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 60)];
    view.backgroundColor = AppFontEBEBEBColor;
    
    UIImageView *leftLine = [[UIImageView alloc] init];
    leftLine.image = IMAGE(@"poorBillTopLine_left");
    [view addSubview:leftLine];
    
    UIImageView *rightLine = [[UIImageView alloc] init];
    rightLine.image = IMAGE(@"poorBillTopLine_right");
    [view addSubview:rightLine];
    
    
    
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = AppFont666666Color;
    
    if (self.dataSourceArr.count) {
        
        lable.text = model.format_create_time;
        if ([model.date_desc isEqualToString:@"今天"]) {
            
            lable.text = [NSString stringWithFormat:@"%@(今天)",model.format_create_time];
            
        }else if ([model.date_desc isEqualToString:@"昨天"]) {
            
            lable.text = [NSString stringWithFormat:@"%@(昨天)",model.format_create_time];
        }
        
        
    }else{
        
        view.backgroundColor = [UIColor whiteColor];
    }
    
    lable.font = [UIFont boldSystemFontOfSize:14];
    [view addSubview:lable];
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 20) content:lable.text font:14];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(30);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.centerY.equalTo(lable.mas_centerY);
        make.right.equalTo(lable.mas_left).offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lable.mas_right).offset(5);
        make.centerY.equalTo(lable.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

#pragma mark - 查看按钮  和确定按钮
- (void)ClickPoorBillLookForBtnAndIndex:(NSIndexPath *)indexpath
{
    JGJPoorBillListDetailModel *model = [self.dataSourceArr[indexpath.section] list][indexpath.row];
    if (![NSString isEmpty:self.agency_uid]) {
        model.agency_uid = self.agency_uid;
        model.group_id = self.group_id;
    }
    [JGJSurePoorBillShowView showPoorBillAndModel:model AndDelegate:self andindexPath:indexpath andHidenismine:YES];
}


- (void)ClickPoorBillSureBtnAndIndex:(NSIndexPath *)indexpath cell:(JGJPoorBillTableViewCell *)cell
{
    self.reloadDataArr = [[NSMutableArray alloc] initWithArray:self.dataSourceArr];

    _indexpaths = [self.tableView indexPathForCell:cell];
    [self surePoorBillWithIndexpath:_indexpaths cell:cell];
    
}

- (void)startRedDotAnimationCell:(JGJPoorBillTableViewCell *)cell {
    
    
    // 本地储存 确认过的账
    NSArray *sureBillArray = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
    TYLog(@"JGJSureBillArray = %@",JGJSureBillArray);
    NSMutableArray *sureBillMuArr = [NSMutableArray array];
    if (sureBillArray) {
        
        sureBillMuArr = [[NSMutableArray alloc] initWithArray:sureBillArray];
    }
    
    [sureBillMuArr addObject:[cell.PoorBillModel mj_keyValues]];
    [TYUserDefaults setObject:sureBillMuArr forKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
    
    // 执行动画
    self.redDotAnimation.hidden = NO;
    CGPoint startPoint = [cell.sureButton convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    CGPoint endPoint = [_rightBtmBtn convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.delegate = self;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x + 10, startPoint.y);//移动到起始点
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, endPoint.y, endPoint.x + 85, endPoint.y);
    keyframeAnimation.path = path;
    CGPathRelease(path);
    keyframeAnimation.duration = 0.7;
    keyframeAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.redDotAnimation.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
}

// 动画结束隐藏 红点
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        
        self.redDotAnimation.hidden = YES;
        NSArray *sureBillArray = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
        if (sureBillArray.count > 0) {
            
            [_rightBtmBtn setTitle:[NSString stringWithFormat:@"本次确认的(%ld)",sureBillArray.count] forState:(UIControlStateNormal)];
            _rightBtmBtn.frame = CGRectMake(0, 0, 90, 16);
        }else {
            
            [_rightBtmBtn setTitle:@"本次确认的" forState:(UIControlStateNormal)];
            
            _rightBtmBtn.frame = CGRectMake(0, 0, 80, 16);
        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JGJSurePoorBillShowView removeView];
    
}
#pragma mark - 确认差账
- (void)surePoorBillWithIndexpath:(NSIndexPath *)indexpath cell:(JGJPoorBillTableViewCell *)cell
{
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[[self.dataSourceArr[indexpath.section] list][indexpath.row] id] forKey:@"id"];
    if (![NSString isEmpty:self.agency_uid]) {
        
        [dic setObject:self.group_id forKey:@"group_id"];
    }
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        // 执行红点抛物线动画效果
        [self startRedDotAnimationCell:cell];
        //确认之后删除数据
        [self delDataAnimatonWithIndexPath:indexpath];
        
        // 对账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)delDataAnimatonWithIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *curIndexpath = indexPath;
    
    NSMutableArray *list = self.dataSourceArr[curIndexpath.section].list;

    
    if (list.count > 1) {
        
        [list removeObjectAtIndex:curIndexpath.row];
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[curIndexpath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
        
        NSInteger totalCount = 0;
        for (int i = 0; i < self.dataSourceArr.count; i ++) {
            
            NSArray *sectionArr = self.dataSourceArr[i].list;
            totalCount = totalCount + sectionArr.count;
        }
        
        
        if (totalCount < 5) {
            
            if (!_isNotHaveAnymoreData) {
                
                _page = 1;
                [self getDataWithPageSize:_page];
                
            }
        }
        
    }else{
        
        [self.dataSourceArr removeObjectAtIndex:curIndexpath.section];
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:curIndexpath.section] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
        
    }
    
    if (self.dataSourceArr.count == 0) {
        
        [_tableView.mj_header beginRefreshing];
        if (self.successBlock) {
            
            self.successBlock();
            
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
}

#pragma mark - 同意他人的差账
- (void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    JGJPoorBillTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    [dic setObject:[[self.dataSourceArr[indexpath.section] list][indexpath.row] id] forKey:@"id"];
    if (![NSString isEmpty:self.agency_uid]) {
        
        [dic setObject:self.group_id forKey:@"group_id"];
    }
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:dic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self startRedDotAnimationCell:cell];
        //确认之后删除数据
        [self delDataAnimatonWithIndexPath:indexpath];
        [JGJSurePoorBillShowView removeView];
        
        // 记账成功刷新首页数据
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [JGJSurePoorBillShowView removeView];

    }];
}

#pragma mark - 修改他人的差账
- (void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    
    ModifyBillListVC.is_surePoorBill_ComeIn = YES;
    ModifyBillListVC.billModify = YES;
    ModifyBillListVC.isNeedRoleType = YES;
    ModifyBillListVC.indexPath = indexpath;
    MateWorkitemsItems *mateWorkitemsItems = [self getMateWorkItemModelAnd:[self.dataSourceArr[indexpath.section] list][indexpath.row]];
    if (![NSString isEmpty:self.agency_uid]) {
        
        mateWorkitemsItems.agency_uid = self.agency_uid;
        mateWorkitemsItems.group_id = self.group_id;
    }
    ModifyBillListVC.mateWorkitemsItems = mateWorkitemsItems;
    ModifyBillListVC.isNotNeedJudgeHaveChangedParameters = YES;
    
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];


}
#pragma mark - 组装数据
- (MateWorkitemsItems *)getMateWorkItemModelAnd:(JGJPoorBillListDetailModel *)detailModel
{
    MateWorkitemsItems *mateWorkItemModel = [MateWorkitemsItems new];
    mateWorkItemModel.accounts_type.code = [detailModel.accounts_type intValue];
    mateWorkItemModel.manhour = detailModel.manhour;
    mateWorkItemModel.id = [detailModel.id longLongValue];
    mateWorkItemModel.worker_name =detailModel.worker_name;
    mateWorkItemModel.overtime = detailModel.overtime;
    mateWorkItemModel.amounts = [detailModel.salary floatValue];
    mateWorkItemModel.pro_name = detailModel.proname ;
    mateWorkItemModel.foreman_name = detailModel.foreman_name ;
    mateWorkItemModel.pid = detailModel.pid;
    mateWorkItemModel.date = detailModel.date;
    mateWorkItemModel.amounts = detailModel.amounts;
    mateWorkItemModel.record_id = detailModel.id;
    return mateWorkItemModel;
}

- (YZGGetBillModel *)getYzgGetBillModel:(JGJPoorBillListDetailModel *)detailModel
{
    YZGGetBillModel *getBillModel = [YZGGetBillModel new];
    getBillModel.accounts_type.code = [detailModel.accounts_type intValue];
    //getBillModel.set_tpl = detailModel.set_tpl;
    getBillModel.set_tpl.s_tpl = detailModel.set_tpl.s_tpl;
    getBillModel.set_tpl.o_h_tpl = detailModel.set_tpl.o_h_tpl;
    getBillModel.set_tpl.w_h_tpl = detailModel.set_tpl.w_h_tpl;
    getBillModel.manhour = [detailModel.manhour floatValue];
    getBillModel.overtime = [detailModel.overtime floatValue];
    getBillModel.amounts = detailModel.amounts;
    getBillModel.proname = detailModel.proname;
    getBillModel.salary = detailModel.amounts ;
    getBillModel.worker_name = detailModel.worker_name;
    getBillModel.foreman_name = detailModel.foreman_name;
    getBillModel.quantities = detailModel.quantities;
    getBillModel.pid = detailModel.pid;
    getBillModel.units = detailModel.units;
    getBillModel.date = detailModel.date;
    getBillModel.unitprice = detailModel.unitprice;
    getBillModel.sub_proname = detailModel.sub_proname;

    return getBillModel;
}
- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:CGRectMake(0, 50, TYGetUIScreenWidth, TYGetUIScreenHeight - 50)];
        _yzgNoWorkitemsView.departLable.hidden = YES;
        // 暂无需要你对账的记工 对账完成的记工可去记工流水查看详情
        NSString *firstString = [NSString stringWithFormat:@"暂无需要你对账的记工\n对账完成的记工可去记工流水查看详情"];
        
        if (![NSString isEmpty:self.agency_uid]) {
            
            firstString = [NSString stringWithFormat:@"暂无需要你对账的记工\n对账完成的记工可去本班组代班流水页面查看详情"];
        }

        _yzgNoWorkitemsView.contentView.backgroundColor = [UIColor whiteColor];

        [_yzgNoWorkitemsView setContentStr:firstString];
        [_yzgNoWorkitemsView setButtonShow:YES];
        _yzgNoWorkitemsView.noRecordButton.hidden = YES;
        _yzgNoWorkitemsView.delegate = self;
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}

- (JGJFooterViewInfoModel *)footerInfoModel {
    
    if (!_footerInfoModel) {
        
        _footerInfoModel = [JGJFooterViewInfoModel new];
        
        _footerInfoModel.backColor = self.tableView.backgroundColor;
        
        _footerInfoModel.textColor = AppFont999999Color;
        
        _footerInfoModel.desType = UITableViewSureBillTableFooterType;
        
    }
    
    return _footerInfoModel;
    
}

- (UIView *)redDotAnimation {
    
    if (!_redDotAnimation) {
        
        _redDotAnimation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _redDotAnimation.backgroundColor = AppFontEB4E4EColor;
        _redDotAnimation.clipsToBounds = YES;
        _redDotAnimation.layer.cornerRadius = 6;
        JLGAppDelegate *delegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:_redDotAnimation];
    }
    return _redDotAnimation;
}

- (SJButton *)titleBtn {
    
    if (!_titleBtn) {
        
        _titleBtn = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        [_titleBtn setBackgroundColor:[UIColor whiteColor]];
        [_titleBtn setTitle:@"我要对账" forState:(SJControlStateNormal)];
        [_titleBtn setImage:IMAGE(@"help_title_center_icon") forState:SJControlStateNormal];
        [_titleBtn setTitleColor:AppFont000000Color forState:SJControlStateNormal];
        [_titleBtn setTitleColor:AppFont000000Color forState:SJControlStateHighlighted];
        [_titleBtn setBackgroundColor:[UIColor clearColor] forState:SJControlStateNormal];
        _titleBtn.titleLabel.font = FONT(AppFont34Size);
        _titleBtn.frame = CGRectMake(0, 0, 60, 35);
        _titleBtn.notNeedTheTrackingEffect = YES;
        
        [_titleBtn addTarget:self action:@selector(howToSurePoorBill) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}
@end
