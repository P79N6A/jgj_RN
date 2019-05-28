//
//  JGJQuaSafeCheckPlanVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckPlanVc.h"

#import "JGJCusActiveSheetView.h"

#import "JGJQuaSafeCheckPlanCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "JGJCustomPopView.h"

#import "JGJQuaSafeCheckRecordVc.h"

#import "JGJQuaSafeCheckVc.h"

#import "JGJChatListQualityVc.h"

@interface JGJQuaSafeCheckPlanVc ()<

    UITableViewDelegate,

    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JGJQuaSafeCheckPlanVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查计划";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJQuaSafeCheckPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JGJQuaSafeCheckPlanCell"];
    
    [TYLoadingHub showLoadingWithMessage:nil];
//    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self loadNetData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQuaSafeCheckPlanModel  *planModel = self.dataSource[indexPath.row];
                       
    JGJQuaSafeCheckPlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:@"JGJQuaSafeCheckPlanCell" forIndexPath:indexPath];
    
    planCell.planModel = planModel;
    
    return planCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = 85.0;
    
    height = [tableView fd_heightForCellWithIdentifier:@"JGJQuaSafeCheckPlanCell" configuration:^(JGJQuaSafeCheckPlanCell *planCell) {
        
        JGJQuaSafeCheckPlanModel  *planModel = self.dataSource[indexPath.row];
        
        planCell.planModel = planModel;

    }];

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 85.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQuaSafeCheckRecordVc *recordVc = [JGJQuaSafeCheckRecordVc new];
    
    JGJQuaSafeCheckPlanModel  *planModel = self.dataSource[indexPath.row];
    
    recordVc.proListModel = self.proListModel;
    
    recordVc.commonModel = self.commonModel;
    
    //负责人id
    planModel.principal_uid = self.listModel.user_info.uid;
    
    recordVc.planModel = planModel;
    
    [self.navigationController pushViewController:recordVc animated:YES];
}

- (IBAction)rightItemPressed:(UIBarButtonItem *)sender {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:@[@"删除", @"取消"] buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            [weakSelf handleDelCheckPlan];
        }
        
    }];
    
    [sheetView showView];
}

- (void)loadNetData {

    NSDictionary *parameters = @{@"pu_inpsid" : self.listModel.pu_inpsid?:@"",
                                 
                                 @"group_id" : self.proListModel.group_id?:@"",
                                 
                                 @"class_type" : self.proListModel.class_type?:@"",
                                 
                                 @"msg_type" : self.commonModel.msg_type ?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getInspectQualityInfo" parameters:parameters success:^(id responseObject) {
        
        self.dataSource = [JGJQuaSafeCheckPlanModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)handleDelCheckPlan {

    __weak typeof(self) weakSelf = self;
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"你确定要删除该检查计划吗？";
    desModel.popTextAlignment = NSTextAlignmentCenter;
    desModel.lineSapcing = 3.0;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.onOkBlock = ^{
        
        NSDictionary *parameters = @{@"pu_inpsid" : self.listModel.pu_inpsid?:@""
                                     };
        
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delInspectQualityList" parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            [weakSelf freshTableView];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [TYShowMessage showSuccess:@"删除成功"];
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        
    };

}

- (void)freshTableView {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListQualityVc class]]) {
            
            JGJChatListQualityVc *parentVc = (JGJChatListQualityVc *)vc;
            
            for (JGJQuaSafeCheckVc *childVc in parentVc.childViewControllers) {
                
                if ([childVc isKindOfClass:[JGJQuaSafeCheckVc class]]) {
                    
                    JGJQuaSafeCheckVc *checkVc = (JGJQuaSafeCheckVc *)childVc;

                    [checkVc freshTableView];
                    
                    break;
                }
                
            }
            
        }
    }
    
}

- (void)setDataSource:(NSArray *)dataSource {

    _dataSource = dataSource;
    
    //添加删除权限
    if (_dataSource.count > 0) {
        
        JGJQuaSafeCheckPlanModel *planModel = [_dataSource firstObject];
        
        if ([planModel.is_privilege isEqualToString:@"1"]) {
                        
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
            
        }
    }

    [self.tableView reloadData];
}

@end
