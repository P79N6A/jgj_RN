//
//  YZGLeaderRecordWorkpointsViewController.m
//  mix
//
//  Created by Tony on 16/3/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGLeaderRecordWorkpointsViewController.h"
#import "JGJBillSyncHomeView.h"
#import "JGJSynBillingManageVC.h"

@interface YZGLeaderRecordWorkpointsViewController ()

@property (weak, nonatomic) IBOutlet YZGMateBillRecordWorkpointsView *billRecordWorkpointsSecondView;
@property (weak, nonatomic) IBOutlet JGJBillSyncHomeView *jgjBillSyncHomeTableView;

@end

@implementation YZGLeaderRecordWorkpointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postApiString = @"jlworkday/fmain";
}
//3.28关闭键盘
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
}

- (void)setUpRecordWorkView{
    {//设置上面的一行
        YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *thirdRecordWorkModel = [YZGRecordWorkModel new];
        
        firstRecordWorkModel.titleString = @"记工流水";
        firstRecordWorkModel.detailString = @"工钱/借支明细";
        firstRecordWorkModel.backgroundColor = TYColorHex(0xf75a23);
        firstRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
        secondRecordWorkModel.titleString = @"工资清单";
        secondRecordWorkModel.detailString = @"应付明细";
        secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        secondRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
        thirdRecordWorkModel.titleString = @"同步项目";
        thirdRecordWorkModel.detailString = @"管理人和项目";
        thirdRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        thirdRecordWorkModel.redPointType = YZGRecordWorkRedPointDefault;
        
        self.jgjBillSyncHomeTableView.firstRecordWorkModel = firstRecordWorkModel;
        self.jgjBillSyncHomeTableView.secondRecordWorkModel = secondRecordWorkModel;
        self.jgjBillSyncHomeTableView.thirdRecordWorkModel = thirdRecordWorkModel;
        self.jgjBillSyncHomeTableView.delegate = self;
    }
    
    {//设置下面的一行
        YZGRecordWorkModel *firstRecordWorkModel = [YZGRecordWorkModel new];
        YZGRecordWorkModel *secondRecordWorkModel = [YZGRecordWorkModel new];
        
        firstRecordWorkModel.titleString = @"昨日考勤";
        firstRecordWorkModel.backgroundColor = TYColorHex(0xf9a00f);
        firstRecordWorkModel.redPointType = YZGRecordWorkRedPointLabelNum;
        
        
        secondRecordWorkModel.titleString = @"今日考勤";
        secondRecordWorkModel.backgroundColor = TYColorHex(0xf6a020);
        secondRecordWorkModel.redPointType = YZGRecordWorkRedPointLabelNum;
        
        [self updateRecordNumLabelWith:firstRecordWorkModel WithSecondModel:secondRecordWorkModel];
        self.billRecordWorkpointsSecondView.delegate = self;
    }
}

- (void)RecordWorkViewReloadData{
    [super RecordWorkViewReloadData];
    YZGRecordWorkModel *firstRecordWorkModel = self.billRecordWorkpointsSecondView.firstRecordWorkModel;
    YZGRecordWorkModel *secondRecordWorkModel = self.billRecordWorkpointsSecondView.secondRecordWorkModel;
    
    [self updateRecordNumLabelWith:firstRecordWorkModel WithSecondModel:secondRecordWorkModel];
}

//从父类继承的
- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index{
    if (section == 1) {
        if (index <= 1) {
            [super RecordWorkViewBtnClick:section index:index];
        }else{//进入同步账单
            JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
            JGJSynBillingManageVC *synBillingManageVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynBillingManageVC"];
            synBillingCommonModel.synBillingTitle = @"同步项目管理";
            synBillingCommonModel.isWageBillingSyn = NO;
            synBillingManageVC.synBillingCommonModel = synBillingCommonModel;
            
            [self.navigationController pushViewController:synBillingManageVC animated:YES];
        }
    }
    
    if (section == 2) {
        YZGMateWorkitemsViewController *yzgMateWorkitemsVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"MateWorkitems"];
        
        yzgMateWorkitemsVc.searchDate = self.calendar.currentPage;

        if (index == 0)//昨天
        {
           yzgMateWorkitemsVc.searchDate = [self.calendar dateByAddingDays:-1 toDate:[NSDate date]];
        }else if (index == 1)//今天
        {
            yzgMateWorkitemsVc.searchDate = [NSDate date];
        }
        
        [self.navigationController pushViewController:yzgMateWorkitemsVc animated:YES];
    }
}

#pragma mark - 更新昨日考勤
- (void)updateRecordNumLabelWith:(YZGRecordWorkModel *)firstRecordWorkModel WithSecondModel:(YZGRecordWorkModel *)secondRecordWorkModel{

    firstRecordWorkModel.labelNum = [NSString stringWithFormat:@"%@",@(self.yzgWorkDayModel.yestodaybill_count)];
    NSString *firstContentStr = [NSString stringWithFormat:@"还有%@个工人未记账",firstRecordWorkModel.labelNum];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:firstContentStr];
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, firstContentStr.length)];
    //数字需要颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(2, firstRecordWorkModel.labelNum.length)];
    
    firstRecordWorkModel.detailString = contentStr;
    
    secondRecordWorkModel.labelNum = [NSString stringWithFormat:@"%@",@(self.yzgWorkDayModel.todaybill_count)];
    NSString *secondContentStr = [NSString stringWithFormat:@"已有%@个工人记账",secondRecordWorkModel.labelNum];
    contentStr = [[NSMutableAttributedString alloc] initWithString:secondContentStr];
    
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0x999999) range:NSMakeRange(0, secondContentStr.length)];
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf75a23) range:NSMakeRange(2, secondRecordWorkModel.labelNum.length)];
    secondRecordWorkModel.detailString = contentStr;
    
    self.billRecordWorkpointsSecondView.firstRecordWorkModel = firstRecordWorkModel;
    self.billRecordWorkpointsSecondView.secondRecordWorkModel = secondRecordWorkModel;
}
@end
