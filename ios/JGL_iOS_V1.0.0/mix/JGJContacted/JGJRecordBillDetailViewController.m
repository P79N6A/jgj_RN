//
//  JGJRecordBillDetailViewController.m
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRecordBillDetailViewController.h"
#import "JGJTableviewHeaderView.h"
#import "JGJLIneRecordDetailTableViewCell.h"
#import "JGJRecordBillDetailTableViewCell.h"
#import "JGJRecrodDetailNoteTableViewCell.h"
#import "UILabel+GNUtil.h"
#import "YZGGetBillModel.h"
#import "YZGMateShowpoor.h"
#import "JGJCheckPhotoTool.h"
#import "JGJRecordDetailmageLinTableViewCell.h"
#import "JGJModifyBillListViewController.h"
#import "JGJLeaderAndWorkerTableViewCell.h"
#import "JGJWorkTplNormalTableViewCell.h"
#import "JGJLableSize.h"
#import "JGJContrctRemarkTableViewCell.h"
#import "JGJRecordBillDetailBottomView.h"
#import "JGJLeaderRecordsViewController.h"
#import "JGJWorkMatesRecordsViewController.h"
#import "JGJRecordWorkpointsVc.h"
#import "JGJMarkBillViewController.h"
#import "FDAlertView.h"
#import "JGJAgentMonitorRecordInfoTableViewCell.h"
#import "JGJCurrentSureBillListViewController.h"
@interface JGJRecordBillDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YZGMateShowpoorDelegate,
tapCollectionDelegate,
FDAlertViewDelegate
>
{
    JGJAgentMonitorRecordInfoTableViewCell *_recordInfoCell;
}

@property (strong , nonatomic)JGJTableviewHeaderView *headerView;
@property (strong , nonatomic)NSMutableArray *imageArr;
@property (strong , nonatomic)NSArray *titleArr;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) JGJRecordBillDetailBottomView *bottomView;

@end

@implementation JGJRecordBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = AppFont3A3F4EColor;
    
    self.bottomView = [[JGJRecordBillDetailBottomView alloc] init];
    if (!self.is_currentSureBill_come_in) {
        
        [self.view addSubview:self.bottomView];
        _bottomView.sd_layout.leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 15).bottomSpaceToView(self.view, 25 + JGJ_IphoneX_BarHeight).heightIs(85);
        self.bottomConstance.constant = 110;
        
    }else {
        
        self.bottomConstance.constant = 25;
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    // 删除该记账
    _bottomView.deleteBill = ^{
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"数据一经删除将无法恢复。\n请谨慎操作哦！" delegate:weakSelf buttonTitles:@"取消",@"确认删除", nil];
        
        alert.isHiddenDeleteBtn = YES;
        [alert setMessageColor:AppFont000000Color fontSize:16];
        
        [alert show];
        
    };
    
    // 进入修改记账页面
    _bottomView.modifyBill = ^{
        
        JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
        ModifyBillListVC.billModify = NO;
        ModifyBillListVC.mateWorkitemsItems = weakSelf.mateWorkitemsItems;
        ModifyBillListVC.delshowViewBool = weakSelf.showViewBool;
        [weakSelf.navigationController pushViewController:ModifyBillListVC animated:YES];
    };
}

- (void)setIs_currentSureBill_come_in:(BOOL)is_currentSureBill_come_in {
    
    _is_currentSureBill_come_in = is_currentSureBill_come_in;
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(self.mateWorkitemsItems.id) forKey:@"id"];
        if (![NSString isEmpty:_mateWorkitemsItems.group_id]) {
            
            [dic setObject:_mateWorkitemsItems.agency_uid?:@"" forKey:@"agency_uid"];
            [dic setObject:_mateWorkitemsItems.group_id forKey:@"group_id"];
        }
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:dic success:^(id responseObject) {
           
            [TYLoadingHub hideLoadingView];
            
            //如果是从记工统计进入，发通知刷新数据
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
             
                if ([vc isKindOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordBillChangeSuccess" object:nil];
                    
                    break;
                    
                }
                
            }
            
            NSString *sourceType = @"0";
    
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *sources = (NSArray *)responseObject;
                NSDictionary *sourceDic = sources.firstObject;
                if ([sourceDic isKindOfClass:[NSDictionary class]]) {
                    sourceType = sourceDic[@"source"];
                }
            }
    
            NSInteger source = [sourceType integerValue];
    
            if (source == 1) {
    
                [TYShowMessage showSuccess:@"记账删除成功\n和他工账有差异,请及时核对"];
    
            }else {
    
                [TYShowMessage showSuccess:@"删除成功"];
            }

            [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
            if (self.showViewBool) {
    
                for (UIViewController *vc in self.navigationController.viewControllers) {
    
                    if ([vc isKindOfClass:[JGJLeaderRecordsViewController class]]) {
    
                        JGJLeaderRecordsViewController *lederVC = (JGJLeaderRecordsViewController*)vc;
                        [self JGJModifyOrDelMarkBill];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [TYShowMessage hideHUD];
                            [self.navigationController popToViewController:lederVC animated:YES];
                        });
                        
                        break;
                        
                    }else if ([vc isKindOfClass:[JGJWorkMatesRecordsViewController class]]){
    
                        JGJWorkMatesRecordsViewController *workVC = (JGJWorkMatesRecordsViewController*)vc;
                        [self JGJModifyOrDelMarkBill];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [TYShowMessage hideHUD];
                            [self.navigationController popToViewController:workVC animated:YES];
                        });
                        
                        break;
                    }
                }
            }else{
    
                [self JGJModifyOrDelMarkBill];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [TYShowMessage hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
    
        }failure:^(NSError *error) {
    
            [TYLoadingHub hideLoadingView];
    
        }];
    }

}
#pragma mark - 修改和删除后都要走这里
- (void)JGJModifyOrDelMarkBill
{
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJRecordWorkpointsVc")]) {
            
            JGJRecordWorkpointsVc *pointVc = (JGJRecordWorkpointsVc *)curVc;
            
            pointVc.isFresh = YES;
            
            break;
        }
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJMarkBillViewController")]) {
            
            JGJMarkBillViewController *pointVc = (JGJMarkBillViewController *)curVc;
            
            [pointVc startRefresh];
            
            break;
        }
        
        
    }
    
}

-(UIView *)footView
{
    if (!_footView) {
        
        float height = TYGetUIScreenHeight - 64 - iphoneXheightscreen - self.tableView.contentSize.height;
        height = height<=0 ?0:height;
        if (self.yzgGetBillModel.notes_img.count && height > (TYGetUIScreenWidth/375*(TYGetUIScreenWidth-80)/4) ) {
            height = height - (TYGetUIScreenWidth/375*(TYGetUIScreenWidth-80)/4 );

        }
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 30, height)];
        _footView.backgroundColor = AppFontffffffColor;
    }
    return  _footView;
}
-(void)initRightItem
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"我要修改" style:UIBarButtonItemStylePlain target:self action:@selector(editeBill)];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:AppFontffffffColor];    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)frashLineImageCell {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//        [self.tableView setTableFooterView:self.footView];
        
    });
    
}

- (void)editeBill {
    
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    ModifyBillListVC.billModify = NO;
    ModifyBillListVC.mateWorkitemsItems = self.mateWorkitemsItems;
    ModifyBillListVC.delshowViewBool = self.showViewBool;
//    [ModifyBillListVC setOriginalWorkTime:self.yzgGetBillModel.manhour overTime:self.yzgGetBillModel.overtime];
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
    
}

- (JGJTableviewHeaderView *)headerView {
    
    if (!_headerView ) {
        
        _headerView = [[JGJTableviewHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 30, 165)];
        _headerView.contractorHeader.hidden = YES;
        if (self.mateWorkitemsItems.accounts_type.code == 1 || self.mateWorkitemsItems.accounts_type.code == 2) {
            
            self.headerView.amountLable.textColor = AppFontEB4E4EColor;
            
        }else{
            
            self.headerView.amountLable.textColor = AppFont83C76EColor;
        }
    }
    
    return _headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (_mateWorkitemsItems.accounts_type.code == 1 || _mateWorkitemsItems.accounts_type.code == 5) {//点工 包工记工天
        
        cell = [self TinyMarkBillFromIndexpath:indexPath];
        
    }else if (_mateWorkitemsItems.accounts_type.code == 2){//包工
        
    
        cell = [self ContractMarkBillFromIndexpath:indexPath];
        
    }else if (_mateWorkitemsItems.accounts_type.code == 3){//借支
        
      
        cell =  [self BrrowMarkBillFromIndexpath:indexPath];
        
    }else{//结算
        
      
        cell =  [self CloseAccountMarkBillFromIndexpath:indexPath];
        
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _titleArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if (self.mateWorkitemsItems.accounts_type.code == 2) {
                
                return [JGJLableSize RowHeight:self.yzgGetBillModel.notes_txt?:@"无" andFont:[UIFont systemFontOfSize:14] totalDepart:60] + 15;
            }
           
            return [JGJLableSize RowHeight:self.yzgGetBillModel.notes_txt?:@"无" andFont:[UIFont systemFontOfSize:14] totalDepart:60] + 53;

        }else{
            
            if (self.imageArr.count <= 0) {
               
                return 0;
            }
            return TYGetUIScreenWidth/375*(TYGetUIScreenWidth-80)/4;

        }
        
    }else if ((indexPath.section == 2)) {
     
        return 30;
        
    }else {
        
      if (_mateWorkitemsItems.accounts_type.code == 1 || _mateWorkitemsItems.accounts_type.code == 5) {

          if (indexPath.row == 3) {
              
              if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
                  
                  if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
                      
                      return 72;
                  }else {
                      
                      return 122;
                  }
              }else {
                  
                  return 97;
                  
              }
              
          }else{
              
              return 45;
              
          }
      }else if (_mateWorkitemsItems.accounts_type.code == 2){
          //没有开始时间的时候不显示
          if (indexPath.row == 6 && [NSString isEmpty: self.yzgGetBillModel.p_s_time ]) {
              return 0;
          }
          //没有完成时间的时候不显示
          if (indexPath.row == 7 && [NSString isEmpty: self.yzgGetBillModel.p_e_time ]) {
              
              return 0;
          }
          return 45;
          
      }else if (_mateWorkitemsItems.accounts_type.code == 3){
          
          return 45;
          
      }else{
          
          return 45;
      }
        
    }
    
}


-(float)RowMoreLineHeight:(NSString *)Str andDepart_W:(NSInteger )width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 50,3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1;
    
    
}
-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (void)setMateWorkitemsItems:(MateWorkitemsItems *)mateWorkitemsItems
{

    if (!_mateWorkitemsItems) {
        _mateWorkitemsItems = [MateWorkitemsItems new];
    }
    //因为要接受推送的角色，所有这个界面不使用本地角色，而使用传入角色
    _JGJisMateBool = self.mateWorkitemsItems.role == 1?1:0;
    _mateWorkitemsItems = mateWorkitemsItems;
    [self JLGHttpRequest];
   
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:AppFont3A3F4EColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFontffffffColor}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateHighlighted];
    
    
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    if (_mateWorkitemsItems) {
        [self JLGHttpRequest];
    }
}
-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:AppFontffffffColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppFont333333Color}];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    
}
- (YZGGetBillModel *)yzgGetBillModel
{
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc] init];
    }
    return _yzgGetBillModel;
}
- (YZGMateShowpoor *)yzgMateShowpoor
{
    if (!_yzgMateShowpoor) {
        _yzgMateShowpoor = [[YZGMateShowpoor alloc] initWithFrame:TYGetUIScreenRect];
        _yzgMateShowpoor.delegate = self;
    }
    return _yzgMateShowpoor;
}

#pragma mark - 获取正常账单
- (void)JLGHttpRequest{
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(self.mateWorkitemsItems.id) forKey:@"record_id"];
    
    [parameters setObject:@(self.mateWorkitemsItems.accounts_type.code) forKey:@"accounts_type"];
    
    // 是否是代班人 记得工
    if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {

        [parameters setObject:self.mateWorkitemsItems.agency_uid forKey:@"agency_uid"];
    }

    if (![NSString isEmpty:self.mateWorkitemsItems.group_id]) {
        
        [parameters setObject:self.mateWorkitemsItems.group_id forKey:@"group_id"];
    }
    
    TYWeakSelf(self);
    [JLGHttpRequest_AFN PostWithNapi:@"workday/work-detail" parameters:parameters success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if (dic.allKeys.count == 0) {// 代表改记账已删除，无数据
            
            [TYShowMessage showPlaint:@"该记账已经被删除"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
        
        [yzgGetBillModel mj_setKeyValues:responseObject];
        
        self.yzgGetBillModel = yzgGetBillModel;
        
        //1是点工 2是包工记账 3 借支 4 结算 5包工记考勤
        switch (_mateWorkitemsItems.accounts_type.code) {
            case 1:
                
                self.title = @"点工";
                _tableView.tableHeaderView = self.headerView;
                self.headerView.titleLable.text = @"点工工钱";
                
                if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
                    
                    _titleArr = @[@[@"",@"上班时长：",@"加班时长：",@"工资标准：",@"所在项目："],@[@"",@""],@[@""]];
                }else {
                    
                    _titleArr = @[@[@"",@"上班时长：",@"加班时长：",@"工资标准：",@"所在项目："],@[@"",@""]];
                }
                break;
            case 2:
                self.title = @"包工记账";
                self.headerView.frame = CGRectMake(0, 0, TYGetUIScreenWidth - 30, 165 + 45);
                _headerView.contractorHeader.hidden = NO;
                _headerView.contractorHeader.contractorType = self.yzgGetBillModel.contractor_type;
                
                _headerView.contractorType = self.yzgGetBillModel.contractor_type;
                [_headerView addHeaderView];
                _tableView.tableHeaderView = self.headerView;
                self.headerView.titleLable.text = @"包工工钱";
                
                if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
                    
                    _titleArr = @[@[@"",@"分项名称：",@"单价：",@"数量：",@"所在项目：",@"",@"开工时间：",@"完工时间："],@[@"",@""],@[@""]];
                }else {
                    
                    _titleArr = @[@[@"",@"分项名称：",@"单价：",@"数量：",@"所在项目：",@"",@"开工时间：",@"完工时间："],@[@"",@""]];
                }
                break;
            case 3:
                self.title = @"借支";
                _tableView.tableHeaderView = self.headerView;
                self.headerView.titleLable.text = @"借支金额";
                
                if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
                    
                    _titleArr = @[@[@"",@"所在项目："],@[@"",@""],@[@""]];
                }else {
                    
                    _titleArr = @[@[@"",@"所在项目："],@[@"",@""]];
                }
                
                break;
            case 4:
                self.title = @"结算";
                _tableView.tableHeaderView = self.headerView;
                self.headerView.titleLable.text = @"本次结算金额";
                _headerView.titleTopLable.text = @"这是一笔 工资结算";
                
                if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
                    
                    _titleArr = @[@[@"",JLGisLeaderBool?@"本次实付金额：":@"本次实收金额：",@"补贴金额：",@"奖励金额：",@"罚款金额：",@"抹零金额：",@"所在项目："],@[@"",@""],@[@""]];
                }else {
                    
                    _titleArr = @[@[@"",JLGisLeaderBool?@"本次实付金额：":@"本次实收金额：",@"补贴金额：",@"奖励金额：",@"罚款金额：",@"抹零金额：",@"所在项目："],@[@"",@""]];
                }
                
                break;
            case 5:
                self.title = @"包工记工天";
                _headerView = [[JGJTableviewHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 30, 50)];
                
                if (self.mateWorkitemsItems.accounts_type.code == 1 || self.mateWorkitemsItems.accounts_type.code == 2) {
                    self.headerView.amountLable.textColor = AppFontEB4E4EColor;
                }else{
                    self.headerView.amountLable.textColor = AppFont83C76EColor;
                    
                }
                _headerView.titleLable.hidden = YES;
                _headerView.amountLable.hidden = YES;
                self.tableView.tableHeaderView = _headerView;
                
                if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
                    
                    _titleArr = @[@[@"",@"上班时长：",@"加班时长：",@"考勤模板：",@"所在项目："],@[@"",@""],@[@""]];
                }else {
                    
                    _titleArr = @[@[@"",@"上班时长：",@"加班时长：",@"考勤模板：",@"所在项目："],@[@"",@""]];
                }
                break;
            default:
                break;
        }
        self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        self.mateWorkitemsItems.record_id = self.yzgGetBillModel.record_id;
        self.imageArr = [self.yzgGetBillModel.notes_img mutableCopy];
        
        //推送弹框
        if ([_yzgGetBillModel.modify_marking intValue] >0 && _sendMsgType){
            
            self.yzgMateShowpoor.mateWorkitemsItem = _mateWorkitemsItems;
            
            [self.yzgMateShowpoor showpoorView];
            
        }
        self.headerView.dateLable.text = self.yzgGetBillModel.date?:@"";
        if (self.yzgGetBillModel.set_tpl.s_tpl <= 0 && self.mateWorkitemsItems.accounts_type.code == 1) {
            
            self.headerView.amountLable.text = @"未设置工资标准";
            
            [self.headerView.amountLable markText:@"未设置工资标准" withFont:[UIFont systemFontOfSize:AppFont32Size] color:[UIColor lightGrayColor]];
            
        }else{
            
            self.headerView.amountLable.text = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.amounts];
        }
        
        if (![NSString isEmpty:self.yzgGetBillModel.recorder_info.real_name]) {
            
            self.bottomView.topLine.hidden = YES;
            
        }else {
            
            self.bottomView.topLine.hidden = NO;
        }
        
        [self.tableView reloadData];
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

-(void)tapCollectionViewSectionAndTag:(NSInteger)currentIndex imagArrs:(NSMutableArray *)imageArrs
{
    
    [JGJCheckPhotoTool browsePhotoImageView:self.imageArr selImageViews:imageArrs didSelPhotoIndex:currentIndex];
}
#pragma mark - 初始化点工
- (UITableViewCell *)TinyMarkBillFromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
       
            JGJLeaderAndWorkerTableViewCell *cell = [JGJLeaderAndWorkerTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text = [NSString stringWithFormat:@"班组长：%@", self.yzgGetBillModel.foreman_name?:@""];
            cell.contentLable.text = [NSString stringWithFormat:@"工人：%@", self.yzgGetBillModel.worker_name?:@""];
            return cell;
            
        }else if (indexPath.row == 3){
        
            JGJWorkTplNormalTableViewCell *cell = [JGJWorkTplNormalTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
            
            if (self.yzgGetBillModel.set_tpl.hour_type == 0) {
                
                //上班标准
                NSString *w_h_tplStr = [[NSString stringWithFormat:@"上班 %.1f小时算1个工",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                cell.workHourLable.text = w_h_tplStr;
                
                //加班标准
                NSString *o_h_tplStr = [[NSString stringWithFormat:@"加班 %.1f小时算1个工",self.yzgGetBillModel.set_tpl.o_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                cell.overLable.text = o_h_tplStr;
                
                //工资标准
                if (self.yzgGetBillModel.set_tpl.s_tpl <= 0) {
                    
                    cell.salaryLable.hidden = YES;
                    cell.oneHourSalaryLabel.hidden = YES;
                }else{
                    
                    cell.salaryLable.hidden = NO;
                    cell.oneHourSalaryLabel.hidden = NO;
                    NSString *oneHourMoney = [NSString stringWithFormat:@"%.2f",[NSString roundFloat:self.yzgGetBillModel.set_tpl.s_tpl / self.yzgGetBillModel.set_tpl.o_h_tpl]];

                    cell.salaryLable.text = [NSString stringWithFormat:@"%.2f元/个工(上班)",self.yzgGetBillModel.set_tpl.s_tpl];
                    cell.oneHourSalaryLabel.text = [NSString stringWithFormat:@"%@元/小时(加班)",oneHourMoney];
                    
                }
                
                
                return cell;
                
            }else {
                
                cell.oneHourSalaryLabel.hidden = YES;
                cell.salaryLable.hidden = NO;
                //上班标准
                NSString *w_h_tplStr = [[NSString stringWithFormat:@"上班 %.1f小时算1个工",self.yzgGetBillModel.set_tpl.w_h_tpl] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                
                cell.workHourLable.text = w_h_tplStr;
                
                //工资标准
                NSString *o_h_tplStr = [NSString stringWithFormat:@"%.2f元/个工(上班)",self.yzgGetBillModel.set_tpl.s_tpl];;
                cell.overLable.text = o_h_tplStr;
                
                // 每小时加班工资
                cell.salaryLable.text = [NSString stringWithFormat:@"%.2f元/小时(加班)",self.yzgGetBillModel.set_tpl.o_s_tpl];
                return cell;
            }
            
            
        }else{
            
            JGJRecordBillDetailTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJRecordBillDetailTableViewCell" owner:nil options:nil]firstObject];
            cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 1) {
                if (self.yzgGetBillModel.manhour <= 0) {
                    cell.subDetailLable.text = @"休息";
                }else{
                    NSString *workStr;
                    NSString *workCStr;
                    workStr = [[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.manhour] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    if (self.yzgGetBillModel.set_tpl.w_h_tpl) {
                        
                        float overF = self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl;

                        workCStr = [NSString stringWithFormat:@"(%@个工)",self.yzgGetBillModel.working_hours];

                    }
                    

                    cell.subDetailLable.text = [NSString stringWithFormat:@"%@小时%@",workStr,workCStr];
                    [cell.subDetailLable markText:workCStr withColor:AppFont999999Color];
                    
                }
            }else if (indexPath.row == 2){
                
                if (self.yzgGetBillModel.overtime<=0) {
                   
                    cell.subDetailLable.text = @"无加班";
                    
                }else{
                    
                    NSString *overStr;
                    NSString *overCStr = @"";
                    
                    overStr = [[NSString stringWithFormat:@"%.1f",self.yzgGetBillModel.overtime] stringByReplacingOccurrencesOfString:@".0" withString:@""];
                    
                    if (self.yzgGetBillModel.set_tpl.o_h_tpl) {
                        
                        overCStr = [NSString stringWithFormat:@"(%@个工)",self.yzgGetBillModel.overtime_hours];
                        
                    }
                    cell.subDetailLable.text = [NSString stringWithFormat:@"%@小时%@",overStr,overCStr];

                    [cell.subDetailLable markText:overCStr withColor:AppFont999999Color];
                    
                }
                
            }else if (indexPath.row == 4){
                
                cell.subDetailLable.text =  self.yzgGetBillModel.proname?:@"";

            }
            return cell;
        }
    }else if(indexPath.section == 1){
        
        //备注
        if (indexPath.row == 0) {
            JGJRecrodDetailNoteTableViewCell * RecrodDetailNote = [JGJRecrodDetailNoteTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.yzgGetBillModel = self.yzgGetBillModel;
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            return RecrodDetailNote;
        }else{
            JGJRecordDetailmageLinTableViewCell * cell = [JGJRecordDetailmageLinTableViewCell cellWithTableView:self.tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.imageArr =self.imageArr;
            if (!self.imageArr.count) {
                cell.contentView.hidden = YES;
            }else{
                cell.contentView.hidden = NO;

            }
            return cell;
        }
        
    }else {
        
        NSString *MyIdentifierID = NSStringFromClass([JGJAgentMonitorRecordInfoTableViewCell class]);
        
        //从缓存池中取出cell
        _recordInfoCell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
        
        if (!_recordInfoCell) {
            
            _recordInfoCell = [[JGJAgentMonitorRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MyIdentifierID];
        }
        
        [_recordInfoCell setRecordName:self.yzgGetBillModel.recorder_info.real_name recordTime:self.yzgGetBillModel.recorder_info.record_time];
        _recordInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _recordInfoCell;
    }
    
}
#pragma mark - 初始化包工

- (UITableViewCell *)ContractMarkBillFromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGJLeaderAndWorkerTableViewCell *cell = [JGJLeaderAndWorkerTableViewCell cellWithTableView:self.tableView];
            if (self.yzgGetBillModel.contractor_type == 1 && JLGisLeaderBool) {
                
                cell.titleLable.text = [NSString stringWithFormat:@"承包对象：%@", self.yzgGetBillModel.foreman_name?:@""];
                
            }else {
                
                cell.titleLable.text = [NSString stringWithFormat:@"班组长：%@", self.yzgGetBillModel.foreman_name?:@""];
                
            }
            
            cell.contentLable.text = [NSString stringWithFormat:@"工人：%@", self.yzgGetBillModel.worker_name?:@""];
            return cell;
        }else if (indexPath.row == 5){
            
            JGJContrctRemarkTableViewCell *cell = [JGJContrctRemarkTableViewCell cellWithTableView:self.tableView];
            
            return cell;
        }else{
            
            JGJRecordBillDetailTableViewCell * cell = [JGJRecordBillDetailTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
            
            if (indexPath.row == 1) {
                
            cell.subDetailLable.text = self.yzgGetBillModel.sub_proname?:@"";
                
            }else if (indexPath.row == 2){
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];

            cell.subDetailLable.text =[NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.unitprice?:0.00];

            }else if (indexPath.row == 3){
                cell.subDetailLable.text = [NSString stringWithFormat:@"%.2f%@",self.yzgGetBillModel.quantities,self.yzgGetBillModel.units?:@""];

            }else if (indexPath.row == 4){
                
            cell.subDetailLable.text = self.yzgGetBillModel.proname?:@"";
                
                
            cell.subDetailLable.numberOfLines = 2;
            cell.leftLineConstance.constant = 0;
            cell.rightLineConstance.constant = 0;

            }else if (indexPath.row == 6){
                if ([NSString isEmpty:self.yzgGetBillModel.p_s_time]) {
                cell.contentView.hidden = YES;
                }else{
                cell.contentView.hidden = NO;
                cell.subDetailLable.text = [NSString stringDateFrom:self.yzgGetBillModel.p_s_time];
                }
            }else if (indexPath.row == 7){
                
                if ([NSString isEmpty: self.yzgGetBillModel.p_e_time ]) {
                    cell.contentView.hidden = YES;

                }else{
                    cell.subDetailLable.text = [NSString stringDateFrom:self.yzgGetBillModel.p_e_time];
                    cell.contentView.hidden = NO;

                }

            }
            return cell;
        }
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            JGJRecrodDetailNoteTableViewCell * cell = [JGJRecrodDetailNoteTableViewCell cellWithTableView:self.tableView];
            cell.yzgGetBillModel =self.yzgGetBillModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLable.hidden = YES;
//            cell.topConstance.constant = -18;
            cell.topConstance.constant = -30;

            return cell;
        }else{
            JGJRecordDetailmageLinTableViewCell * RecrodDetailNote = [JGJRecordDetailmageLinTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.origionX = YES;
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            RecrodDetailNote.delegate = self;
            RecrodDetailNote.imageArr =self.imageArr;
            if (!self.imageArr.count) {
                RecrodDetailNote.contentView.hidden = YES;
            }else{
                RecrodDetailNote.contentView.hidden = NO;
                
            }
            return RecrodDetailNote;
        }
        
        
    }else {
        
        NSString *MyIdentifierID = NSStringFromClass([JGJAgentMonitorRecordInfoTableViewCell class]);
        
        //从缓存池中取出cell
        _recordInfoCell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
        
        if (!_recordInfoCell) {
            
            _recordInfoCell = [[JGJAgentMonitorRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MyIdentifierID];
        }
        [_recordInfoCell setRecordName:self.yzgGetBillModel.recorder_info.real_name recordTime:self.yzgGetBillModel.recorder_info.record_time];
        _recordInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _recordInfoCell;
    }
    
}
#pragma mark - 初始化借支
- (UITableViewCell *)BrrowMarkBillFromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            JGJLeaderAndWorkerTableViewCell *cell = [JGJLeaderAndWorkerTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text =[NSString stringWithFormat:@"班组长：%@", self.yzgGetBillModel.foreman_name?:@""];
            cell.contentLable.text =[NSString stringWithFormat:@"工人：%@", self.yzgGetBillModel.worker_name?:@""];
            return cell;
        }
        else{
            JGJRecordBillDetailTableViewCell * cell = [JGJRecordBillDetailTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
            cell.subDetailLable.text = self.yzgGetBillModel.proname?:@"";
            return cell;
        }
    }else if(indexPath.section == 1){
        
        
        if (indexPath.row == 0) {
            JGJRecrodDetailNoteTableViewCell * RecrodDetailNote = [JGJRecrodDetailNoteTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.yzgGetBillModel =self.yzgGetBillModel;
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            return RecrodDetailNote;
        }else{
            JGJRecordDetailmageLinTableViewCell * RecrodDetailNote = [JGJRecordDetailmageLinTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            RecrodDetailNote.delegate = self;
            RecrodDetailNote.imageArr =self.imageArr;
            if (!self.imageArr.count) {
                RecrodDetailNote.contentView.hidden = YES;
            }else{
                RecrodDetailNote.contentView.hidden = NO;
                
            }
            return RecrodDetailNote;
        }
        
        
    }else {
        
        NSString *MyIdentifierID = NSStringFromClass([JGJAgentMonitorRecordInfoTableViewCell class]);
        
        //从缓存池中取出cell
        _recordInfoCell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
        
        if (!_recordInfoCell) {
            
            _recordInfoCell = [[JGJAgentMonitorRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MyIdentifierID];
        }
        [_recordInfoCell setRecordName:self.yzgGetBillModel.recorder_info.real_name recordTime:self.yzgGetBillModel.recorder_info.record_time];
        _recordInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _recordInfoCell;
    }
}
#pragma mark - 初始化结算
- (UITableViewCell *)CloseAccountMarkBillFromIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            JGJLeaderAndWorkerTableViewCell *cell = [JGJLeaderAndWorkerTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text =[NSString stringWithFormat:@"班组长：%@", self.yzgGetBillModel.foreman_name?:@""];
            cell.contentLable.text =[NSString stringWithFormat:@"工人：%@", self.yzgGetBillModel.worker_name?:@""];
            return cell;
            
        }else{
            
            JGJRecordBillDetailTableViewCell * cell = [JGJRecordBillDetailTableViewCell cellWithTableView:self.tableView];
            cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 1) {
                
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];
                cell.subDetailLable.text = [NSString stringWithFormat:@"%.2f", self.yzgGetBillModel.pay_amount?:0.00 ];
                cell.titleLableconstance.constant = 100;
                
            }else if (indexPath.row == 2){
                
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];
            
                cell.subDetailLable.text =  self.yzgGetBillModel.subsidy_amount?:@"0.00";

            }else if (indexPath.row == 3){
                
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];
                cell.subDetailLable.text =  self.yzgGetBillModel.reward_amount?:@"0.00";

            }else if (indexPath.row == 4){
                
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];
                cell.subDetailLable.text =  self.yzgGetBillModel.penalty_amount?:@"0.00";

            }else if (indexPath.row == 5){
                
                cell.subDetailLable.font = [UIFont boldSystemFontOfSize:14];
                cell.subDetailLable.text =  self.yzgGetBillModel.deduct_amount?:@"0.00";

            }else{
                
                cell.subDetailLable.text = self.yzgGetBillModel.proname?:@"";

            }
            return cell;
        }
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            JGJRecrodDetailNoteTableViewCell * RecrodDetailNote = [JGJRecrodDetailNoteTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.yzgGetBillModel =self.yzgGetBillModel;
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            return RecrodDetailNote;
        }else{
            JGJRecordDetailmageLinTableViewCell * RecrodDetailNote = [JGJRecordDetailmageLinTableViewCell cellWithTableView:self.tableView];
            RecrodDetailNote.selectionStyle = UITableViewCellSelectionStyleNone;
            RecrodDetailNote.delegate = self;
            RecrodDetailNote.imageArr =self.imageArr;
            if (!self.imageArr.count) {
                RecrodDetailNote.contentView.hidden = YES;
            }else{
                RecrodDetailNote.contentView.hidden = NO;

            }
            return RecrodDetailNote;
        }
        
    }else {
        
        NSString *MyIdentifierID = NSStringFromClass([JGJAgentMonitorRecordInfoTableViewCell class]);
        
        //从缓存池中取出cell
        _recordInfoCell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
        
        if (!_recordInfoCell) {
            
            _recordInfoCell = [[JGJAgentMonitorRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MyIdentifierID];
        }
        [_recordInfoCell setRecordName:self.yzgGetBillModel.recorder_info.real_name recordTime:self.yzgGetBillModel.recorder_info.record_time];
        _recordInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _recordInfoCell;
    }
}


@end
