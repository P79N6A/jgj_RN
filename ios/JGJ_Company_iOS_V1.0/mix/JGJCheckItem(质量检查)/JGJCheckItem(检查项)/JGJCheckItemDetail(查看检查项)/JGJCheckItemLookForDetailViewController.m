//
//  JGJCheckItemLookForDetailViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckItemLookForDetailViewController.h"

#import "JGJCheacContentTableViewCell.h"

#import "JGJCheckItemTileTableViewCell.h"

#import "JGJCheckContentDetailTableViewCell.h"

#import "JGJNewCreatCheckItemAddView.h"

#import "JGJAddCheckItemContensViewController.h"

#import "JGJCheckContentFooterView.h"

#import "JGJPlaceEditeView.h"

#import "FDAlertView.h"

#import "JGJNewCreteCheckItemViewController.h"
@interface JGJCheckItemLookForDetailViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJCheacContentTableViewCellDelegate,


UIScrollViewDelegate,

editeDelegate,

FDAlertViewDelegate

>
@property(nonatomic ,strong)NSMutableArray *dataArr;



@end

@implementation JGJCheckItemLookForDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


- (void)initView{
    

    self.title = @"检查项";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    
    //底部的点击按钮
    self.view.backgroundColor = AppFontf1f1f1Color;

}
- (void)loadRightBarbutton
{
//    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
//    [releaseButton setImage:[UIImage imageNamed:@"more_write"] forState:UIControlStateNormal];
//    [releaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    releaseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
//
//    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
//    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self JGJDetailHttpRequst];

}
- (void)setMainCheckListModel:(JGJCheckItemListDetailModel *)mainCheckListModel
{
    if (!_mainCheckListModel) {
        _mainCheckListModel = [JGJCheckItemListDetailModel new];
    }
    _mainCheckListModel = mainCheckListModel;
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            //第三行那个检查内容
            JGJCheckItemTileTableViewCell *cell = [JGJCheckItemTileTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
            
        }else{
            //第一二行的名称和位置
            JGJCheacContentTableViewCell *cell = [JGJCheacContentTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textFiled.tag = indexPath.row;
            cell.textFiled.maxLength = 15;
            cell.tag = indexPath.row;
            cell.delegate = self;
            if (indexPath.row == 0) {
                cell.nameLable.text = @"名称";
                if (![NSString isEmpty:self.pubDetailModel.pro_name]) {
                    cell.textFiled.text = self.pubDetailModel.pro_name?:@"";
                    
                }
            }else{
                cell.nameLable.text = @"位置";
                
                if (![NSString isEmpty:self.pubDetailModel.location_text]) {
                    cell.textFiled.text = self.pubDetailModel.location_text?:@"";
                    
                }else{
                    
                 cell.nameLable.text = @"";
                    
                }
                
            }
            cell.textFiled.userInteractionEnabled = NO;
            
           
            return cell;
        }
    }else{
        
        JGJCheckContentDetailTableViewCell *cell = [JGJCheckContentDetailTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        JGJCheckItemPubDetailListModel *model = self.pubDetailModel.content_list[indexPath.section - 1];
        
        cell.model =model.dot_list[indexPath.row];
        return cell;
        
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pubDetailModel.content_list.count + 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1 && [NSString isEmpty: self.pubDetailModel.location_text ]) {
            return 0;
        }
        if (indexPath.row == 2) {
            return 38;
        }
        return 50;
    }else{
        
        JGJCheckItemPubDetailListModel *model = self.pubDetailModel.content_list[indexPath.section - 1];
        return [self RowHeight:[model.dot_list[indexPath.row] dot_name]] + 32;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 3;
        
    }
    if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] > 3 && ![self.pubDetailModel.content_list[section - 1] openO]) {
        //处理展开和收拢
        return 3;
    }
    return [[self.pubDetailModel.content_list[section - 1] dot_list] count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return [[UIView alloc]initWithFrame:CGRectZero];;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(24, 0, TYGetUIScreenWidth, 50)];
    lable.text = [self.pubDetailModel.content_list[section - 1] content_name]?:@"";
    view.backgroundColor = [UIColor whiteColor];
    lable.textColor = AppFont333333Color;
    lable.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:lable];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 4, 16)];
    lineLable.backgroundColor = AppFontEB4E4EColor;
    lineLable.layer.masksToBounds = YES;
    lineLable.layer.cornerRadius = 2;
    [view addSubview:lineLable];
    UIView *departLine = [[UIView alloc]initWithFrame:CGRectMake(10, 49, TYGetUIScreenWidth - 20, 0.5)];
    departLine.backgroundColor = AppFontdbdbdbColor;
    
    [view addSubview:departLine];
    
    
    
//    if (!self.lookForCheckItem) {
//        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth -  32, 17, 16, 16)];
//        deleteButton.tag = section ;
//        [deleteButton setImage:[UIImage imageNamed:@"cheackContent"] forState:UIControlStateNormal];
//        [deleteButton addTarget:self action:@selector(deleteCheckItemSection:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:deleteButton];
//        
//        
//        UILabel *lineLables = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth -  48, 17, 0.5, 16)];
//        lineLables.backgroundColor = AppFontdbdbdbColor;
//        lineLables.layer.masksToBounds = YES;
//        lineLables.layer.cornerRadius = 2;
//        [view addSubview:lineLables];
//    }
    
    return view;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return  [[UIView alloc]initWithFrame:CGRectZero];
        
      }else  if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] <= 3) {
          
      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
          
      view.backgroundColor = AppFontf1f1f1Color;
          
      return  view;
  
    }
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
//    view.backgroundColor = [UIColor redColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth,36)];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
    
//    lable.backgroundColor = AppFontdbdbdbColor;
    
    [view addSubview:lable];
    
    view.backgroundColor = AppFontF9F9F9Color;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth,36)];
    
    if ([self.pubDetailModel.content_list[section - 1] openO]) {
        
    [button setTitle:@"收起全部" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"closeItem"] forState:UIControlStateNormal];

    }else{
        
    [button setTitle:@"展开全部" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"openItem"] forState:UIControlStateNormal];

    }
    
//    [button setTitle:@"收起全部" forState:UIControlStateSelected];

    button.tag = section - 1;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    [button setTitleColor:AppFont666666Color forState:UIControlStateSelected];

    [button addTarget:self action:@selector(ClickMore:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    view.backgroundColor = AppFontF9F9F9Color;
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 35.5, TYGetUIScreenWidth, 0.5)];
    
    lineLable.backgroundColor = AppFontdbdbdbColor;

    [view addSubview:lineLable];


    return view;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] < 3) {
//        
//        return  [[UIView alloc]initWithFrame:CGRectZero];
//        
//    }
    if (section == 0 ) {
        return CGFLOAT_MIN;
        return tableView.sectionFooterHeight;
//        return 0;
    }else if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] <= 3)
    {
        return 10;
    }
    return 34;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGFLOAT_MIN;
        return tableView.sectionHeaderHeight;
//        return 0;
    }
    return 50;
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
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 52,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1 ;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)JGJCheckContentTextfiledEdite:(NSString *)text
{
    
    
}
#pragma mark - 编辑名称和位置
-(void)JGJCheckContentTextfiledEdite:(NSString *)text andTag:(NSInteger)indexRow
{
    if (indexRow == 0) {
        
        self.pubDetailModel.pro_name = text;
        
    }else{
        
        self.pubDetailModel.location_text = text;
        
    }
}



-(JGJCheckItemPubDetailModel *)pubDetailModel
{
    if (!_pubDetailModel) {
        
        _pubDetailModel = [JGJCheckItemPubDetailModel new];
        
    }
    return _pubDetailModel;
}


#pragma mark - 获取检查项详情
-(void)JGJDetailHttpRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:_mainCheckListModel.id?:@"" forKey:@"pro_id"];
    
    
    typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];

    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProInfo" parameters:paramDic success:^(id responseObject) {
        
        weakSelf.pubDetailModel = [JGJCheckItemPubDetailModel mj_objectWithKeyValues:responseObject];
        
        if ([weakSelf.pubDetailModel.is_operate?:@"0" intValue] && !_hiddenEditeBar) {
            
            [self loadRightBarbutton];
    
        }
        
        [weakSelf.tableview reloadData];
        
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];

    }];
}
#pragma mark - 修改
- (void)releaseInfo
{
    
    JGJPlaceEditeView *editeview = [[JGJPlaceEditeView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight , TYGetUIScreenWidth, 160)];
    
    editeview.delegate = self;
    
    [editeview  ShowviewWithVC];
    
}
#pragma mark -编辑
- (void)clickEditeButton
{

    JGJNewCreteCheckItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJNewCreteCheckItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJNewCreteCheckItemVC"];
    
    WorkReportVC.editeCheckItem = YES;
    
    WorkReportVC.mainCheckListModel = self.mainCheckListModel;
    
    WorkReportVC.WorkproListModel = self.WorkproListModel;
    
    [self.navigationController pushViewController:WorkReportVC animated:YES];

    
}
#pragma mark -删除
- (void)clickdeleteButton
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"是否删除该检查项？" delegate:self buttonTitles:@"取消",@"确定", nil];
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    
    [alert show];
    
}
#pragma mark -取消
- (void)clickcancelButton{
    
    
}

#pragma mark - 删除检查项
- (void)deleteCheckItem
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.pubDetailModel.pro_id?:@"" forKey:@"pro_id"];
    
    typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/delInspecPro" parameters:paramDic success:^(id responseObject) {
        
    [weakSelf.navigationController popViewControllerAnimated:YES];
        
    [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
    [TYLoadingHub hideLoadingView];
        
    }];
    
    
}



- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [self deleteCheckItem];
    }
}

- (void)ClickMore:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;

    JGJCheckItemPubDetailListModel *model = self.pubDetailModel.content_list[button.tag ];

    
    if ([button.titleLabel.text isEqualToString:@"展开全部"]) {
        model.openO = YES;
  
    }else{
        model.openO = NO;

    
    }
    
    self.pubDetailModel.content_list[button.tag] = model;
    
    
    [self.tableview reloadData];
    
    if ([button.titleLabel.text isEqualToString:@"展开全部"]) {
        [button setImage:[UIImage imageNamed:@"openItem"] forState:UIControlStateNormal];

//        button.selected = NO;
        [button setTitle:@"收起全部" forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"closeItem"] forState:UIControlStateNormal];

        [button setTitle:@"展开全部" forState:UIControlStateNormal];

        
//        button.selected = YES;
        
    }
}
@end
