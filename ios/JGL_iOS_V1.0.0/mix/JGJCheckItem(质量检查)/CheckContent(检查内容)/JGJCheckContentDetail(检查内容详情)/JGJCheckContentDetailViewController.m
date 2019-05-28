//
//  JGJCheckContentDetailViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckContentDetailViewController.h"

#import "JGJCheckContentTitleTableViewCell.h"

#import "JGJCheckContentDetailListTableViewCell.h"

#import "JGJPlaceEditeView.h"

#import "FDAlertView.h"

#import "JGJCreatCheackContentViewController.h"

@interface JGJCheckContentDetailViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

editeDelegate,

FDAlertViewDelegate
>
@property (strong ,nonatomic)JGJCheckContentDetailModel *dataModel;
@end

@implementation JGJCheckContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检查内容";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self JGJHttpRequest];
    
}
-(void)loadRightBarButton
{

//    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
//    [releaseButton setImage:[UIImage imageNamed:@"more_write"] forState:UIControlStateNormal];
//    [releaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    releaseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
//    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
//    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];

}
- (void)releaseInfo
{
    JGJPlaceEditeView *editeview = [[JGJPlaceEditeView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight , TYGetUIScreenWidth, 160)];
    
    editeview.delegate = self;
    [editeview  ShowviewWithVC];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataModel.dot_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JGJCheckContentTitleTableViewCell * cell = [JGJCheckContentTitleTableViewCell cellWithTableView:self.tableview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel;

        return cell;
    }else{
    
        JGJCheckContentDetailListTableViewCell * cell = [JGJCheckContentDetailListTableViewCell cellWithTableView:self.tableview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel.dot_list[indexPath.row];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return [self RowHeight:[self.dataModel.dot_list[indexPath.row] dot_name]?:@""] + 32;

    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return [[UIView alloc]initWithFrame:CGRectZero];;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 38)];
    view.backgroundColor = AppFontf1f1f1Color;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth, 38)];
    lable.backgroundColor = AppFontf1f1f1Color;
    lable.text = @"检查内容分项";
    lable.textColor = AppFont333333Color;
    lable.font = [UIFont systemFontOfSize:15];
    [view addSubview:lable];

    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 38;
}
-(void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel) {
        _WorkproListModel = [JGJMyWorkCircleProListModel new];
    }
    _WorkproListModel = WorkproListModel;
}


-(float)RowHeight:(NSString *)Str
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
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20 ,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1 ;
    
}
-(void)setListModel:(JGJCheckItemListDetailModel *)listModel
{

    if (!_listModel) {
        _listModel = [JGJCheckItemListDetailModel new];
    }
    _listModel = listModel;
}
-(void)JGJHttpRequest
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.listModel.id?:@"" forKey:@"content_id"];

    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectContentInfo" parameters:paramDic success:^(id responseObject) {
        self.dataModel = [JGJCheckContentDetailModel mj_objectWithKeyValues:responseObject];
        [self.tableview reloadData];
        
        if ([self.dataModel.is_operate?:@"0" integerValue]) {
            
            [self loadRightBarButton];

        }
        
    }failure:^(NSError *error) {
        
    }];
}
#pragma mark - 删除
-(void)clickdeleteButton
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"是否删除该检查内容？" delegate:self buttonTitles:@"取消",@"确定", nil];
    //    alert.tag = 1;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    
    [alert show];
    
    
}
-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除
        [self deleteCheckContent];
        
    }else{
    
    
    }

}
#pragma mark - 编辑
- (void)clickEditeButton
{
    
    JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    WorkReportVC.totalModel = self.dataModel;
    WorkReportVC.EditeBool = YES;
    WorkReportVC.listModel = self.listModel;
    [self.navigationController pushViewController:WorkReportVC animated:YES];

}

- (void)clickcancelButton
{

}

- (void)deleteCheckContent{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.dataModel.id?:@"" forKey:@"content_id"];
    typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/delInspectContent" parameters:paramDic success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        [TYShowMessage showSuccess:@"删除成功！"];
        
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        
    }];
}
@end
