//
//  JGJBillEditProNameViewController.m
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBillEditProNameViewController.h"
#import "JGJBillEditProNameTableViewCell.h"
#import "JGJBillModifyProNameView.h"
#import "YZGMateReleaseBillViewController.h"
#import "CustomAlertView.h"
#import "JGJCustomPopView.h"
@interface JGJBillEditProNameViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;//存储模型数据
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *editButton;
@end
@implementation JGJBillEditProNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self editButton];//添加编辑按钮
    [self setNavigationLeftButtonItem];//设置导航栏左边按钮
    [self jsonWithModel];
}

- (void)backButtonPressed{
    UIViewController *preVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    if ([preVc isKindOfClass:[YZGMateReleaseBillViewController class]] || [preVc isKindOfClass:[JGJMarkBillBaseVc class]]) {
        SEL querypro = NSSelectorFromString(@"querypro:");
        IMP imp = [preVc methodForSelector:querypro];
        void (*func)(id, SEL, JGJMarkBillQueryproBlock) = (void *)imp;
        func(preVc, querypro, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJBillEditProNameTableViewCell *cell = [JGJBillEditProNameTableViewCell cellWithTableView:tableView];
    JGJBillEditProNameModel *proNameModel = self.dataSource[indexPath.row];
    proNameModel.isDelete = _editButton.selected;
    cell.proNameModel = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.editProNameBlock = ^(JGJBillEditProNameModel *proNameModel){
       
        [weakSelf handleEditProNameButtonPressed:proNameModel indexPath:indexPath];
    };
    return cell;
}
- (void)handleEditProNameButtonPressed:(JGJBillEditProNameModel *)proNameModel indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (proNameModel.isDelete) {
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = [NSString stringWithFormat:@"确认删除 %@ 项目吗?",proNameModel.name];
        desModel.popTextAlignment = NSTextAlignmentLeft;
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        alertView.onOkBlock = ^{
           [weakSelf deleteProNameModel:proNameModel indexPath:indexPath];
        };
    } else {
        
        JGJBillModifyProNameView *modifyProNameView = [JGJBillModifyProNameView JGJBillModifyProNameViewShowWithMessage:@"更改项目名称"];
        modifyProNameView.theModifyProjectName = proNameModel.name;
        modifyProNameView.onClickedBlock = ^(NSString *modifiedProName){
            proNameModel.name = modifiedProName;
            [weakSelf modifyProNameModel:proNameModel indexPath:indexPath];
        };
    }
}
#pragma mark - 数据解析
- (void)jsonWithModel {
    self.dataSource = [JGJBillEditProNameModel mj_objectArrayWithKeyValuesArray:self.dataArray].mutableCopy;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - buttonAtion
- (void)editButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *title = sender.selected ? @"取消" : @"删除";
    [sender setTitle:title forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - 删除项目
- (void)deleteProNameModel:(JGJBillEditProNameModel *)proNameModel indexPath:(NSIndexPath *)indexPath{
    NSDictionary *parameters = @{@"pid_str":proNameModel.proId ?: [NSNull null]};
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delpro" parameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [self.dataSource removeObject:proNameModel];
        [self.tableView reloadData];

        UIViewController *preVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if ([preVc isKindOfClass:[YZGMateReleaseBillViewController class]] || [preVc isKindOfClass:[JGJMarkBillBaseVc class]]) {
            NSInteger pid = [proNameModel.proId integerValue];
            SEL deleteSelectProByPid = NSSelectorFromString(@"deleteSelectProByPid:");
            IMP imp = [preVc methodForSelector:deleteSelectProByPid];
            void (*func)(id, SEL, NSInteger) = (void *)imp;
            func(preVc, deleteSelectProByPid, pid);
        }

    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 更改项目名
- (void)modifyProNameModel:(JGJBillEditProNameModel *)proNameModel indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *parameters = @{@"pid":proNameModel.proId ?: [NSNull null],
                                 @"pro_name":proNameModel.name ?: [NSNull null]};
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/upproname" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.navigationController popViewControllerAnimated:YES];
        if ([self respondsToSelector:@selector(modifyThePorjectNameSuccess)]) {
            
            self.modifyThePorjectNameSuccess(indexPath,proNameModel.name);
        }
        
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (UIButton *)editButton {

    if (!_editButton) {
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [_editButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        [_editButton setTitle:@"删除" forState:UIControlStateNormal];
       UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
       self.navigationItem.rightBarButtonItem = titleItem;
    }
    return _editButton;
}

- (void)setNavigationLeftButtonItem {
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}
@end
