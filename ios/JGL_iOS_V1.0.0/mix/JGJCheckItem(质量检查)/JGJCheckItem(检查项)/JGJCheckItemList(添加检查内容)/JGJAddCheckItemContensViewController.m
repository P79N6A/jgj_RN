//
//  JGJAddCheckItemContensViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddCheckItemContensViewController.h"

#import "JGJChoiceCheckItemContentTableViewCell.h"

#import "JGJCheckContentDetailViewController.h"

#import "JGJNewCreteCheckItemViewController.h"

#import "JGJNoDataDefultView.h"

#import "JGJCreatCheackContentViewController.h"

@interface JGJAddCheckItemContensViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJChoiceCheckItemContentTableViewCellDelegate
>

@property(strong ,nonatomic)JGJCreateCheckModel *createModel;

@property(strong ,nonatomic)NSMutableArray <JGJCheckContentDetailModel *>*dataArr;

@property(strong ,nonatomic)NSMutableArray <JGJCheckContentDetailModel *>*selectArr;

@property (strong, nonatomic)JGJNoDataDefultView *noDataDefultView;

@property (strong ,nonatomic)JGJNodataDefultModel *defultDataModel;//迎来显示默认页显示模型

@property(strong ,nonatomic)NSMutableArray  *indexpaths;

@property (strong, nonatomic)NSMutableArray <JGJCheckItemPubDetailListModel *>*historyMulArr;

@property(assign ,nonatomic)BOOL  jump;


@end

@implementation JGJAddCheckItemContensViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    for (int i = 0; i < self.hadMutlArr.count; i ++) {
        JGJCheckContentDetailModel *model = [JGJCheckContentDetailModel new];
        model.content_id = [self.hadMutlArr[i] content_id];
        model.content_name = [self.hadMutlArr[i] content_name];
        model.dot_list = [self.hadMutlArr[i] dot_list];
        [self.selectArr addObject:model];
    }
    
    [self initView];
    
    self.addButton.layer.cornerRadius = 5;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.userInteractionEnabled = NO;
    self.addButton.backgroundColor = AppFont999999Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    
}
- (void)initView{
    self.title = @"选择检查内容";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelection = YES;

   

}

- (void)initRightLoadBtn
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(newCretecheckContent)];
    self.navigationItem.rightBarButtonItem = button;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self JGJHttpRequst];



}
-(NSMutableArray<JGJCheckContentDetailModel *> *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(NSMutableArray *)indexpaths
{
    if (!_indexpaths) {
        
        _indexpaths = [NSMutableArray array];
        
    }
    return  _indexpaths;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJChoiceCheckItemContentTableViewCell *cell = [JGJChoiceCheckItemContentTableViewCell cellWithTableView:tableView];
    cell.indexpaths = indexPath;
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    
    for (int i = 0; i < self.hadMutlArr.count; i ++) {
        if ([[self.dataArr[indexPath.row] content_id] isEqualToString:[self.hadMutlArr[i] content_id]]) {
            
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            

            
            if (![self.indexpaths containsObject:indexPath]) {
                
                [self.indexpaths addObject:indexPath];
   
            }
            
        }
   
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJCheckContentDetailViewController *contenVC = [[UIStoryboard storyboardWithName:@"JGJCheckContentDetailViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckContentDetailVC"];
    contenVC.WorkproListModel = self.WorkproListModel;
    
    JGJCheckItemListDetailModel *model = [JGJCheckItemListDetailModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    contenVC.listModel = model;


    [self.navigationController pushViewController:contenVC animated:YES];

}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJCheckContentDetailViewController *contenVC = [[UIStoryboard storyboardWithName:@"JGJCheckContentDetailViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckContentDetailVC"];
    contenVC.WorkproListModel = self.WorkproListModel;
    
    JGJCheckItemListDetailModel *model = [JGJCheckItemListDetailModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    contenVC.listModel = model;
    
#pragma mark - 选中后查看详情回来也要选中
    
    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];

    
    [self.navigationController pushViewController:contenVC animated:YES];
    return nil;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_hadMutlArr removeObject:self.dataArr[indexPath.row]];
    
    JGJCheckContentDetailViewController *contenVC = [[UIStoryboard storyboardWithName:@"JGJCheckContentDetailViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCheckContentDetailVC"];
    contenVC.WorkproListModel = self.WorkproListModel;
    
    JGJCheckItemListDetailModel *model = [JGJCheckItemListDetailModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    contenVC.listModel = model;
    
#pragma mark - 选中后查看详情回来也要选中
    
    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];

    
    [self.navigationController pushViewController:contenVC animated:YES];
    return nil;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
#pragma mark - 点击左边的选中按钮
-(void)clickCheckItemContentBtn:(NSIndexPath *)indexpath
{
    
    
    if ([self.tableView.indexPathsForSelectedRows containsObject:indexpath]) {
        
        [self.tableView deselectRowAtIndexPath:indexpath animated:YES];
 
    }else{
    
        [self.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];

    }
    self.selectArr = [[NSMutableArray alloc]init];
    
    for (int index = 0; index < self.tableView.indexPathsForSelectedRows.count; index ++) {
        NSIndexPath *nIndexpath = self.tableView.indexPathsForSelectedRows[index];
        [self.selectArr addObject:self.dataArr[nIndexpath.row]];
    }
    [self buttonStatus];

}
-(void)buttonStatus
{
    
    
    /*
    BOOL isequl = YES;
    
    if (self.historyMulArr.count != self.selectArr.count) {
        
        isequl = NO;

    }else{
        NSMutableArray *hisContentidArr = [[NSMutableArray alloc]init];
        NSMutableArray *selectContentidArr = [[NSMutableArray alloc]init];

        for (int i = 0; i < self.historyMulArr.count; i ++) {
            [hisContentidArr addObject:[self.historyMulArr[i] content_id]?:@""];
            [selectContentidArr addObject:[self.selectArr[i] content_id]?:@""];
        }
        
        for (int i = 0; i < hisContentidArr.count; i ++) {

        if (![hisContentidArr containsObject:selectContentidArr[i]]) {
            
            isequl = NO;
            
          }
        }
    }

     if (!isequl) {*/
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
-(void)setHadMutlArr:(NSMutableArray<JGJCheckItemPubDetailListModel *> *)hadMutlArr
{
    if (!_hadMutlArr) {
        _hadMutlArr = [[NSMutableArray alloc]init];
        self.historyMulArr = hadMutlArr;

    }
    _hadMutlArr = hadMutlArr;
}
-(NSMutableArray<JGJCheckContentDetailModel *> *)selectArr
{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc]init];
    }
    return _selectArr;
}
-(void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel) {
        
        _WorkproListModel = [[JGJMyWorkCircleProListModel alloc]init];
        
    }
    
    _WorkproListModel = WorkproListModel;
    
}
-(NSMutableArray<JGJCheckItemPubDetailListModel *> *)historyMulArr
{
    if (!_historyMulArr) {
        _historyMulArr = [NSMutableArray array];
    }
    return _historyMulArr;
}
- (void)JGJHttpRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    [paramDic setObject:@"" forKey:@"content_ids"];

    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];

    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectContentList" parameters:paramDic success:^(id responseObject) {
        self.dataArr = [JGJCheckContentDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];

        [self initDeflutView];
        
        if (self.dataArr.count) {
            [self initRightLoadBtn];
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [self buttonStatus];
////            _jump = NO;
//        });
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
  
    }];

}

-(JGJNodataDefultModel *)defultDataModel
{
    if (!_defultDataModel) {
        _defultDataModel = [[JGJNodataDefultModel alloc]init];
    }
    return _defultDataModel;
}
-(void)initDeflutView{
    typeof(self) weakSelf = self;
    if (_noDataDefultView) {
        [_noDataDefultView removeFromSuperview];
        _noDataDefultView = nil;
    }
    if (self.dataArr.count <= 0) {
        
        self.defultDataModel.helpTitle = @"查看帮助";
        
        self.defultDataModel.pubTitle = @"新建检查内容";
        
        self.defultDataModel.contentStr = @"暂无检查内容";
        
        _noDataDefultView = [[JGJNoDataDefultView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 60) andSuperView:self.view andModel:weakSelf.defultDataModel helpBtnBlock:^(NSString *title){
            
        } pubBtnBlock:^(NSString *title) {
            
            weakSelf.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];

                JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
            
                WorkReportVC.checkContentListGo = YES;
            
                WorkReportVC.WorkproListModel = weakSelf.WorkproListModel;
                
                [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
            
        }];
    }
}

#pragma mark - 点击底部按钮
- (IBAction)clickAddbtn:(id)sender {
    
    NSMutableArray <JGJCheckItemPubDetailListModel *>*dataArr  = [[NSMutableArray alloc]init];
    for ( int index = 0; index < self.selectArr.count ; index ++) {
        JGJCheckItemPubDetailListModel *model = [JGJCheckItemPubDetailListModel new];
        
        model.content_name = [self.selectArr[index] content_name];
        
        model.dot_list = [[NSMutableArray alloc]initWithArray:[self.selectArr[index] dot_list]];
        
        model.content_id = [self.selectArr[index] content_id];
        if (![dataArr containsObject:model]) {
            
            [dataArr addObject:model];
   
        }
    }
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJNewCreteCheckItemViewController class]]) {
            
            JGJNewCreteCheckItemViewController *createVC = (JGJNewCreteCheckItemViewController *)vc;
            createVC.SelectdataArr = dataArr;
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

- (void)newCretecheckContent
{
    self.hadMutlArr = [[NSMutableArray alloc]initWithArray:self.selectArr];
    
    JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
    
    WorkReportVC.checkContentListGo = YES;
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
//    _jump = YES;
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];

}

-(void)setCreateNextModel:(JGJCheckItemPubDetailListModel *)createNextModel
{
    _createNextModel = [JGJCheckItemPubDetailListModel new];
    _createNextModel = createNextModel;
    
    JGJCheckItemPubDetailListModel *model = [JGJCheckItemPubDetailListModel new];
    model.content_name = createNextModel.content_name;
    model.content_id = createNextModel.content_id;
    JGJCheckContentDetailModel *selectModel = [JGJCheckContentDetailModel new];
    selectModel.content_name = createNextModel.content_name;
    selectModel.content_id = createNextModel.content_id;
    selectModel.dot_list = createNextModel.dot_list;
    [self.hadMutlArr addObject:model];
    [self.selectArr addObject:selectModel];
    [self.tableView reloadData];

    
    [self buttonStatus];
}
@end
