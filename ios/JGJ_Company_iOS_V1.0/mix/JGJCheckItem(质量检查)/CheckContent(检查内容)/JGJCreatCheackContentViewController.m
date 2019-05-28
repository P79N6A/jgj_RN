//
//  JGJCreatCheackContentViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCreatCheackContentViewController.h"

#import "JGJCheacContentTableViewCell.h"

#import "JGJEditeCheacContentTableViewCell.h"

#import "JGJCheckContentFooterView.h"

#import "JGJAddCheckItemContensViewController.h"

//#import "IQKeyboardManager.h"
@interface JGJCreatCheackContentViewController ()
<UITableViewDelegate,

UITableViewDataSource,

JGJCheckContentFooterViewdelegate,

JGJCheacContentTableViewCellDelegate,

JGJEditeCheacContentTableViewCellDelegate,

UIScrollViewDelegate
>

@property (strong ,nonatomic)JGJCheckContentFooterView *footView;

@property (strong ,nonatomic)JGJCreateCheckModel  *creatModel;

@property (strong, nonatomic)UIView *bottomView;

@end

@implementation JGJCreatCheackContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//
//    [IQKeyboardManager sharedManager].enable = NO;
    
}
-(void)initView{
    if (_EditeBool) {
        self.title = @"修改检查内容";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(publishCreate)];
        self.navigationItem.rightBarButtonItem = item;
        [self JGJHttpRequest];
    }else{
        self.title = @"新建检查内容";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishCreate)];
        self.navigationItem.rightBarButtonItem = item;
        

    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = self.footView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self bottomView];
    [self.bottmViews addSubview:self.bottomView];
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
#pragma mark - 默认一个检查内容分项
    JGJCreateCheckDetailModel *model = [JGJCreateCheckDetailModel new];
    
    [self.creatModel.dot_list addObject:model];



}

- (JGJCheckContentFooterView *)footView
{
    if (!_footView) {
        
        _footView = [[JGJCheckContentFooterView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
        _footView.delegate = self;
        
    }
    return _footView;
}
- (JGJCreateCheckModel *)creatModel
{
    if (!_creatModel) {
        _creatModel = [JGJCreateCheckModel new];
    }
    return _creatModel;
}
-(void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel) {
        _WorkproListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkproListModel = WorkproListModel;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
        _bottomView.backgroundColor = AppFontf1f1f1Color;
        
        [_bottomView addSubview:self.footView];
    }
    return _bottomView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    JGJCheacContentTableViewCell *cell = [JGJCheacContentTableViewCell cellWithTableView:tableView];
        
    cell.delegate = self;
        
    cell.textFiled.maxLength = 15;
        if (![NSString isEmpty: self.creatModel.content_name ]) {
            
    cell.textFiled.text =self.creatModel.content_name;
  
        }else{
            
    cell.textFiled.placeholder = @"请输入检查内容名称";
            
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
        
    }else{
        
    JGJEditeCheacContentTableViewCell *cell = [JGJEditeCheacContentTableViewCell cellWithTableView:tableView];
        
    cell.placeLable.text = @"请输入检查内容分项要求";
        
    cell.delegate = self;
        
    cell.deleteButton.tag = indexPath.row;
        
    cell.textView.tag = indexPath.row;
        
        if (![NSString isEmpty:[self.creatModel.dot_list[indexPath.row] dot_name]]){
            cell.textView.text = [self.creatModel.dot_list[indexPath.row] dot_name];
            cell.placeLable.hidden = YES;
        }else{
            cell.placeLable.hidden = NO;

        }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if (![NSString isEmpty: [self.creatModel.dot_list[indexPath.row] dot_id]] && _EditeBool) {
        
            cell.textView.userInteractionEnabled = NO;
 
        }


    return cell;

    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        
        return 1;
        
    }else{
        
        return self.creatModel.dot_list.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1/* && self.creatModel.dot_list.count > 0*/) {
        
        UIView *view = [[UIView alloc]init];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
        lable.text = @"   检查内容分项";
        
        lable.textColor = AppFont333333Color;
        
        lable.font = [UIFont systemFontOfSize:15];
        
        [view addSubview:lable];
        
        UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEting)];
        
        view.userInteractionEnabled = YES;
        
        [view addGestureRecognizer:tapGuesstrue];
        
        if (self.creatModel.dot_list.count <= 0) {
            [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(self.view.frame)- 64 - 60)];
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *lables = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, TYGetUIScreenWidth, 36)];
            lables.text = @"暂无检查内容分项";
            
//            lable.backgroundColor = AppFontf1f1f1Color;
            
            lables.textColor = AppFont999999Color;
            
            lables.textAlignment = NSTextAlignmentCenter;
            
            lables.font = [UIFont systemFontOfSize:17];
            
            [view addSubview:lables];
            
            lable.backgroundColor = AppFontf1f1f1Color;

        }else{
            [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
            
            view.backgroundColor = AppFontf1f1f1Color;

        }
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
        
 
        
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.view endEditing:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    if (self.creatModel.dot_list.count <= 0) {
        return CGRectGetHeight(self.view.frame)- 64 - 60;
    }
    return 36;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
#pragma mark - 点击添加按钮
- (void)JGJCheckContentClickBtn
{
    
    [self.view endEditing:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.creatModel.dot_list.count inSection:1];
    JGJCreateCheckDetailModel *model = [JGJCreateCheckDetailModel new];
    
    [self.creatModel.dot_list insertObject:model atIndex:self.creatModel.dot_list.count];
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    
//    [self jugeBottomViewHidden];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    


}
#pragma mark - 发布
- (void)publishCreate
{
    if ([NSString isEmpty: self.creatModel.content_name]) {
        [TYShowMessage showError:@"请填写检查内容名称"];
        return;
    }else if ( self.creatModel.dot_list.count <= 0 ){
    
        [TYShowMessage showError:@"请添加检查内容分项"];
        return;
    }
    
    
    for (int index = 0; index < self.creatModel.dot_list.count; index ++) {
      
        if ([NSString isEmpty: [self.creatModel.dot_list[index] dot_name]]) {
            [TYShowMessage showError:@"请填写检查内容分项要求"];

            return;
            
            
        }
    }
    if (_EditeBool) {
        
    [self modifyJGJHttpRequest];
        
    }else{
        
    [self JLGHttpRequst];
        
    }
}
#pragma mark - 编辑标题
-(void)JGJCheckContentTextfiledEdite:(NSString *)text
{
    self.creatModel.content_name = text;
}

#pragma mark- 编辑检查内容分项
-(void)JGJEditeCheacContentTextviewEdite:(NSString *)text andTag:(NSInteger)indexpathRow
{
    
    JGJCreateCheckDetailModel *detailModel = self.creatModel.dot_list[indexpathRow];
    detailModel.dot_name = text;
    
    
}
#pragma mark - 点击删除按钮
- (void)JGJEditeCheacContentClickDeleteButtonWithTag:(NSInteger)indexpathRow
{
    [self.view endEditing:YES];
//    [self jugeBottomViewHidden];
//    if (self.creatModel.dot_list.count == 1) {
//        [TYShowMessage showError:@"这里显示还有一行时删除的提示语，等产品"];
//        return;
//    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexpathRow inSection:1];
    
    [self.creatModel.dot_list removeObjectAtIndex:indexpathRow];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
    });

}

- (void)jugeBottomViewHidden
{
    if (self.tableView.contentSize.height > TYGetUIScreenHeight - 63 ) {
        
        self.bottomView.hidden = NO;
        
    }else{
        
        self.bottomView.hidden = YES;
        
    }
    if (self.bottomView.hidden) {
        
        self.tableView.tableFooterView = self.footView;
        [UIView animateWithDuration:.1 animations:^{
            self.bottomConstance.constant = 0;
            
        }];
    }else{
        
        self.tableView.tableFooterView = nil;
        [UIView animateWithDuration:.1 animations:^{
            self.bottomConstance.constant = 74;
            
            
        }];
    }
    
}
-(void)setListModel:(JGJCheckItemListDetailModel *)listModel
{
    if (!_listModel) {
        _listModel = [JGJCheckItemListDetailModel new];
    }
    _listModel = listModel;
}
-(void)setTotalModel:(JGJCheckContentDetailModel *)totalModel
{
    if (!_totalModel) {
        
        _totalModel = [JGJCheckContentDetailModel new];
    }
    _totalModel = totalModel;
}
#pragma mark - 修改发布
- (void)modifyJGJHttpRequest
{
    NSMutableArray *contentArr = [NSMutableArray array];
    
    for (int index = 0; index < self.creatModel.dot_list.count; index ++) {
        NSMutableDictionary *DataDic = [NSMutableDictionary dictionary];
        [DataDic setObject:[self.creatModel.dot_list[index] dot_name]?:@"" forKey:@"dot_name"];
        [DataDic setObject:[self.creatModel.dot_list[index] dot_id]?:@"0" forKey:@"dot_id"];
        [contentArr addObject:DataDic];
        
    }
    
    NSString *jsonStr = [self arrayToJSONString:contentArr];
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:self.totalModel.id?:@"" forKey:@"content_id"];
    
    [parmDic setObject:self.creatModel.content_name?:@"" forKey:@"content_name"];
    
    [parmDic setObject:jsonStr?:@"" forKey:@"dots_content"];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/updateInspectContent" parameters:parmDic success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"修改成功!"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(NSError *error) {
        
        
    }];



}
#pragma mark - 发布按钮
- (void)JLGHttpRequst
{
    NSMutableArray *contentArr = [NSMutableArray array];
    
    for (int index = 0; index < self.creatModel.dot_list.count; index ++) {
        NSMutableDictionary *DataDic = [NSMutableDictionary dictionary];
        [DataDic setObject:[self.creatModel.dot_list[index] dot_name]?:@"" forKey:@"dot_name"];
        [DataDic setObject:[self.creatModel.dot_list[index] dot_id]?:@"0" forKey:@"dot_id"];
        [contentArr addObject:DataDic];

    }
    typeof(self) weakSelf = self;
    NSString *jsonStr = [self arrayToJSONString:contentArr];
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [parmDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [parmDic setObject:self.creatModel.content_name?:@"" forKey:@"content_name"];
    
    [parmDic setObject:jsonStr?:@"" forKey:@"dots_content"];
    
    [parmDic setObject:@"1" forKey:@"is_object"];


    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/addInspectContent" parameters:parmDic success:^(id responseObject) {
        
        if (_checkContentListGo) {
            JGJCheckItemPubDetailListModel *model = [JGJCheckItemPubDetailListModel mj_objectWithKeyValues:responseObject];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[JGJAddCheckItemContensViewController class]]) {
                    
                    JGJAddCheckItemContensViewController *itemVC = (JGJAddCheckItemContensViewController *)vc;
                    
                    itemVC.createNextModel = model;
                    
                    break;
//                    [weakSelf.navigationController popViewControllerAnimated:YES];

                }
            }
        }else{
       
        }
        
        [TYShowMessage showSuccess:@"发布成功!"];
        [weakSelf.navigationController popViewControllerAnimated:YES];


    }failure:^(NSError *error) {
        
        
    }];

}

#pragma mark修改时获取接口
-(void)JGJHttpRequest
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.listModel.id?:@"" forKey:@"content_id"];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectContentInfo" parameters:paramDic success:^(id responseObject) {
        
        self.creatModel = [JGJCreateCheckModel mj_objectWithKeyValues:responseObject];
        
        [self.tableView reloadData];

    }failure:^(NSError *error) {
        
    }];
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonString;
}
-(void)JGJCheckContentTextfiledEdite:(NSString *)text andTag:(NSInteger)indexRow
{

}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//
//}
-(void)endEting
{
    [self.view endEditing:YES];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [ IQKeyboardManager sharedManager].enable = YES;
    
    
}
@end
