//
//  JGJAddCheckItemPlanViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddCheckItemPlanViewController.h"

#import "JGJChoiceCheckItemContentTableViewCell.h"

#import "JGJCheckPlanViewController.h"

#import "JGJCheckItemLookForDetailViewController.h"

#import "JGJNewCreteCheckItemViewController.h"

@interface JGJAddCheckItemPlanViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJChoiceCheckItemContentTableViewCellDelegate

>
@property (strong, nonatomic)NSMutableArray <JGJCheckContentListModel *>*dataArr;

@property (strong, nonatomic)NSMutableArray <JGJCheckContentListModel *>*historyMulArr;

@property (strong, nonatomic)NSMutableArray <JGJCheckContentListModel *>*selectArr;//选中的

@property(strong ,nonatomic)NSMutableArray  *indexpaths;

@property(assign ,nonatomic)BOOL  jump;

@property(strong ,nonatomic)NSTimer  *timer;

@end

@implementation JGJAddCheckItemPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeTimer) userInfo:nil repeats:NO];
    _tabelview.dataSource = self;
    _tabelview.delegate = self;
    _tabelview.allowsMultipleSelection = YES;
    _tabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabelview.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.selectArr = [[NSMutableArray alloc]initWithArray:self.hadMutlArr];
    
    self.title = @"选择检查项";
    
    
    self.addButton.layer.cornerRadius = 5;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.userInteractionEnabled = NO;
    self.addButton.backgroundColor = AppFont999999Color;
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(newCretecheckitem)];
//    self.navigationItem.rightBarButtonItem = button;
}
-(void)removeTimer
{
    
    [UIView animateWithDuration:.2 animations:^{
        _waringLableConstance.constant = 0;
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self JGJHttpRequst];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JGJChoiceCheckItemContentTableViewCell *cell = [JGJChoiceCheckItemContentTableViewCell cellWithTableView:tableView];
    
    cell.indexpaths = indexPath;
    
    cell.delegate = self;
    
    for (int i = 0; i < self.hadMutlArr.count; i ++) {
        
        if ([[self.dataArr[indexPath.row] pro_id] isEqualToString:[self.hadMutlArr[i] pro_id]]) {
            
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            if (![self.indexpaths containsObject:indexPath]) {
                
                [self.indexpaths addObject:indexPath];
                
            }
        }
        
    }

    
    cell.checkItemModel = self.dataArr[indexPath.row];
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    JGJCheckItemLookForDetailViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckItemLookForDetailViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckItemLookForDetailVC"];
    
    WorkReportVC.lookForCheckItem = YES;
    
    WorkReportVC.hiddenEditeBar = YES;
    
    self.mainCheckListModel = [JGJCheckItemListDetailModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    
    WorkReportVC.mainCheckListModel = self.mainCheckListModel;
    
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJCheckItemLookForDetailViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckItemLookForDetailViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckItemLookForDetailVC"];
    
    WorkReportVC.lookForCheckItem = YES;
    
    WorkReportVC.hiddenEditeBar = YES;
    
    self.mainCheckListModel.id = [self.dataArr[indexPath.row] pro_id];
    
    WorkReportVC.mainCheckListModel = self.mainCheckListModel;
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
#pragma mark - 选中后查看详情回来也要选中
    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];
    
    return nil;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJCheckItemLookForDetailViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckItemLookForDetailViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckItemLookForDetailVC"];
    
    WorkReportVC.lookForCheckItem = YES;
    
    WorkReportVC.hiddenEditeBar = YES;
    
    self.mainCheckListModel.id = [self.dataArr[indexPath.row] pro_id];
    
    WorkReportVC.mainCheckListModel = self.mainCheckListModel;
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
#pragma mark - 选中后查看详情回来也要选中
    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark - 选中按钮
- (void)clickCheckItemContentBtn:(NSIndexPath *)indexpath
{
    
    if ([self.tabelview.indexPathsForSelectedRows containsObject:indexpath]) {
        
        [self.tabelview deselectRowAtIndexPath:indexpath animated:YES];
        
    }else{
        
        [self.tabelview selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    }
    self.selectArr = [[NSMutableArray alloc]init];
    
    for (int index = 0; index < self.tabelview.indexPathsForSelectedRows.count; index ++) {
        
        NSIndexPath *nIndexpath = self.tabelview.indexPathsForSelectedRows[index];
        
        [self.selectArr addObject:self.dataArr[nIndexpath.row]];
        
    }
    [self buttonStatus];
    
    [self orderDeleteCheckItem];

}
#pragma mark - 将删除的检查项插入数组

- (void)orderDeleteCheckItem
{

    for (int i = 0; i < self.hadMutlArr.count; i ++) {
        if (![self.hadMutlArr[i] is_active]) {
            if (self.selectArr.count - 1 >= i) {
               
                [self.selectArr insertObject:self.hadMutlArr[i] atIndex:i];
                
            }else{
            
                [self.selectArr insertObject:self.hadMutlArr[i] atIndex:self.selectArr.count];

            }
        }
    }
    
}

- (void)JGJHttpRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@"" forKey:@"pg"];
    
    [paramDic setObject:@"" forKey:@"pagesize"];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];

    typeof(self) weakSelf = self;
    
//    [TYLoadingHub showLoadingWithMessage:nil];
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspecProList" parameters:paramDic success:^(id responseObject) {
        
        
        weakSelf.dataArr = [JGJCheckContentListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        
        [weakSelf.tabelview reloadData];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            [self buttonStatus];
            
//            _jump = NO;
            
        });
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];

    }];
    
    
}

- (JGJCheckItemListDetailModel *)mainCheckListModel
{
    if (!_mainCheckListModel) {
        _mainCheckListModel = [JGJCheckItemListDetailModel new];
    }
    return _mainCheckListModel;
}
-(void)buttonStatus
{

    /*
    if (self.indexpaths.count != self.tabelview.indexPathsForSelectedRows.count) {
        isequl = NO;
    }else{
        if (self.indexpaths.count > self.tabelview.indexPathsForSelectedRows.count) {
            for (int index = 0; index < self.tabelview.indexPathsForSelectedRows.count; index ++) {
                if (![self.indexpaths containsObject:self.tabelview.indexPathsForSelectedRows[index]]) {
                    
                    isequl = NO;
                }
            }
        }else{
            for (int index = 0; index < self.indexpaths.count; index ++) {
                
                if (![self.tabelview.indexPathsForSelectedRows containsObject:self.indexpaths[index]]) {
                    isequl = NO;
                }
            }
        }
        
    }
    
    //新建跳转回来
    if (_jump) {
        if ((![NSString isEmpty:self.defultModel.pro_name] && ![NSString isEmpty:self.defultModel.pro_id]) || self.selectArr.count > 0) {
            
            isequl = NO;
            
        }
    }

    
    if ((!isequl && self.hadMutlArr.count > 0) || (self.hadMutlArr.count <= 0 && self.selectArr.count > 0)) {*/
    /*
    BOOL isequl = YES;

    if (self.historyMulArr.count != self.selectArr.count) {
        
        isequl = NO;
        
    }else{
        
    
        NSMutableArray *hisContentidArr = [[NSMutableArray alloc]init];
        NSMutableArray *selectContentidArr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.historyMulArr.count; i ++) {
            [hisContentidArr addObject:[self.historyMulArr[i] pro_id]?:@""];
            [selectContentidArr addObject:[self.selectArr[i] pro_id]?:@""];
        }
        
        for (int i = 0; i < hisContentidArr.count; i ++) {
            
            if (![hisContentidArr containsObject:selectContentidArr[i]]) {
                
                isequl = NO;
                
            }
        }
        
    }
    if (!isequl) {
*/
        self.addButton.layer.cornerRadius = 5;
        self.addButton.layer.masksToBounds = YES;
        self.addButton.backgroundColor = AppFontEB4E4EColor;
        self.addButton.userInteractionEnabled = YES;
    /*
    }else{
        self.addButton.layer.cornerRadius = 5;
        self.addButton.layer.masksToBounds = YES;
        self.addButton.userInteractionEnabled = NO;
        self.addButton.backgroundColor = AppFont999999Color;
        
    }*/
}
-(NSMutableArray *)indexpaths
{
    if (!_indexpaths) {
        _indexpaths = [[NSMutableArray alloc]init];
    }
    return _indexpaths;
    
}

-(JGJAddCheckItemModel *)CheckModel
{
    if (!_CheckModel) {
        _CheckModel = [JGJAddCheckItemModel new];
    }
    return _CheckModel;
}

- (NSMutableArray<JGJCheckContentListModel *> *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc]init];
        
    }
    
    return _dataArr;
    
}

-(NSMutableArray<JGJCheckContentListModel *> *)selectArr
{
    if (!_selectArr) {
        
        _selectArr = [[NSMutableArray alloc]init];
    }
    return _selectArr;
}
-(void)setHadMutlArr:(NSMutableArray<JGJCheckContentListModel *> *)hadMutlArr
{
    if (!_hadMutlArr) {
        
        _hadMutlArr = [[NSMutableArray alloc]init];
        
        self.historyMulArr = hadMutlArr;

    }
    
    _hadMutlArr = hadMutlArr;

}
- (NSMutableArray<JGJCheckContentListModel *> *)historyMulArr
{
    if (!_historyMulArr) {
        
        _historyMulArr = [NSMutableArray array];
        
    }
    return _historyMulArr;
}
- (IBAction)clickAddBtn:(id)sender {
    
      for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJCheckPlanViewController class]]) {
            
            JGJCheckPlanViewController *createVC = (JGJCheckPlanViewController *)vc;
            
            createVC.selectArr = self.selectArr;
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}
-(void)newCretecheckitem
{

    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];
    
    JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
    
    WorkReportVC.createCheckItemGo = YES;
    
//    _jump = YES;
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];

}
-(void)setDefultModel:(JGJCheckContentListModel *)defultModel
{
    _defultModel = [JGJCheckContentListModel new];
    
    _defultModel = defultModel;
    
    [self.selectArr addObject:defultModel];
    
    [self.hadMutlArr addObject:defultModel];
    
    [self.tabelview reloadData];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self buttonStatus];
//   
//    });

}
@end
