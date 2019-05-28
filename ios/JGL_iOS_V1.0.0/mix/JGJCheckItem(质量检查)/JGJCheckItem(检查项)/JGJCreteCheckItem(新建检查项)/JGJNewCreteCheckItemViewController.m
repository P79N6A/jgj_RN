//
//  JGJNewCreteCheckItemViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNewCreteCheckItemViewController.h"

#import "JGJCheacContentTableViewCell.h"

#import "JGJCheckItemTileTableViewCell.h"

#import "JGJCheckContentDetailTableViewCell.h"

#import "JGJNewCreatCheckItemAddView.h"

#import "JGJAddCheckItemContensViewController.h"

#import "JGJCheckContentFooterView.h"

#import "JGJPlaceEditeView.h"

#import "FDAlertView.h"

#import "JGJCreatCheackContentViewController.h"

#import "JGJAddCheckItemPlanViewController.h"

#import "JGJCheckTheItemViewController.h"

#import "JGJCheckItemNoDoatTableViewCell.h"
@interface JGJNewCreteCheckItemViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJCheacContentTableViewCellDelegate,

JGJCheckContentFooterViewdelegate,

UIScrollViewDelegate
>

@property(nonatomic ,strong)NSMutableArray *dataArr;

@property (strong ,nonatomic)JGJCheckContentFooterView *footView;

@property (strong ,nonatomic)JGJNewCreatCheckItemAddView *addBottomView;

@property (strong, nonatomic)UIView *bottomView;

@property (strong ,nonatomic)JGJCheckItemMainListModel *listModel;//检查想和检查内容mg列表



@end

@implementation JGJNewCreteCheckItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
//    [self.view addSubview:self.bottomView];
    [self.bottomViews addSubview:self.bottomView];
}

- (void)initView{


    
        
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = nil;
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
//    self.tableview.tableFooterView = self.footView;//新加
    //底部的点击按钮

    if (_editeCheckItem) {
        
        [self JGJDetailHttpRequst];
        
        self.title = @"修改检查项";

        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(publishModifyCheckItem)];
        
        self.navigationItem.rightBarButtonItem = item;
        
//        self.tableview.tableFooterView = nil;
        
    }else{
        
        self.title = @"新建检查项";

        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishNewCreateCheckItem)];
        self.navigationItem.rightBarButtonItem = item;

    }

    


}
#pragma mark - 默认引导页
-(void)initBottomDefultView
{

    typeof(self)weakSelf = self;
    self.addBottomView = [JGJNewCreatCheckItemAddView showView:self.view andBlock:^(NSString *title) {

        
        
        
        JGJAddCheckItemContensViewController *addVc = [[UIStoryboard storyboardWithName:@"JGJAddCheckItemContensViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddCheckItemContensVC"];
        addVc.hadMutlArr = weakSelf.pubDetailModel.content_list;
        
        addVc.WorkproListModel = weakSelf.WorkproListModel;
        [weakSelf.navigationController pushViewController:addVc animated:YES];
        /*
        JGJCreatCheackContentViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCreatCheackContentViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCreatCheackContentVC"];
        WorkReportVC.WorkproListModel = self.WorkproListModel;
        
        [weakSelf.navigationController pushViewController:WorkReportVC animated:YES];
        */
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self JGJHttpRequest];
    
}
- (void)setMainCheckListModel:(JGJCheckItemListDetailModel *)mainCheckListModel
{
    if (!_mainCheckListModel) {
        
        _mainCheckListModel = [JGJCheckItemListDetailModel new];
    }
    _mainCheckListModel = mainCheckListModel;
}
- (JGJCheckContentFooterView *)footView
{
    if (!_footView) {
        _footView = [[JGJCheckContentFooterView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
        _footView.delegate = self;
        [_footView buttonTitle:@"选择检查内容"];
    }
    return _footView;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
        _bottomView.backgroundColor = AppFontf1f1f1Color;
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, .5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        [_bottomView addSubview:lable];
        [_bottomView addSubview:self.footView];
    }
    return _bottomView;
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
            if (self.pubDetailModel.content_list.count <= 0) {
                
                JGJCheckItemNoDoatTableViewCell *cell = [JGJCheckItemNoDoatTableViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.Content = @"暂无检查内容";
                
                return cell;

                
            }else{
            
                JGJCheckItemTileTableViewCell *cell = [JGJCheckItemTileTableViewCell cellWithTableView:tableView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
            }
 
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
            cell.textFiled.placeholder = @"请输入检查项名称";
                if (![NSString isEmpty:self.pubDetailModel.pro_name]) {
                    cell.textFiled.text = self.pubDetailModel.pro_name?:@"";
   
                }
            }else{
            cell.nameLable.text = @"位置";
            cell.textFiled.placeholder = @"请输入位置信息";
                
                if (![NSString isEmpty:self.pubDetailModel.location_text]) {
                    cell.textFiled.text = self.pubDetailModel.location_text?:@"";
                    
                }

            }

 
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
        if (indexPath.row == 2) {
            if (self.pubDetailModel.content_list.count <= 0) {
                return  CGRectGetHeight(self.view.frame) - 106 - 64;
            }
            return 38;
            
        }
        return 50;
    }else{
        
        JGJCheckItemPubDetailListModel *model = self.pubDetailModel.content_list[indexPath.section - 1];
        return [self RowHeight:[model.dot_list[indexPath.row] dot_name]] + 32;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

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

//    if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] > 3) {
//        return 3;
//    }
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
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth -  32, 17, 16, 16)];
    
    deleteButton.tag = section ;
    
    [deleteButton setImage:[UIImage imageNamed:@"cheackContent"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteCheckItemSection:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:deleteButton];
        
        
    UILabel *lineLables = [[UILabel alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth -  48, 17, 0.5, 16)];
    
    lineLables.backgroundColor = AppFontdbdbdbColor;
    
    lineLables.layer.masksToBounds = YES;
    
    lineLables.layer.cornerRadius = 2;
    
    [view addSubview:lineLables];

    return view;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return  [[UIView alloc]initWithFrame:CGRectZero];
    }
    if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] <= 3) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
            view.backgroundColor = AppFontf1f1f1Color;
        
            return view;

    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth,34)];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 34)];
    
//    lable.backgroundColor = AppFontdbdbdbColor;
    
    [view addSubview:lable];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth,34)];
    
    if ([self.pubDetailModel.content_list[section - 1] openO]) {
        
        [button setTitle:@"收起全部" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"closeItem"] forState:UIControlStateNormal];

        
    }else{
        
        [button setTitle:@"展开全部" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"openItem"] forState:UIControlStateNormal];

        
    }
    
    //    [button setTitle:@"收起全部" forState:UIControlStateSelected];
//    [button setImage:[UIImage imageNamed:@"closeItem"] forState:UIControlStateNormal];
    button.tag = section - 1;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    [button setTitleColor:AppFont666666Color forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(ClickMore:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    view.backgroundColor = AppFontF9F9F9Color;
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 33.5, TYGetUIScreenWidth, 0.5)];
    
    lineLable.backgroundColor = AppFontdbdbdbColor;
    
    [view addSubview:lineLable];
    
    

//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
//    view.backgroundColor = AppFontf1f1f1Color;
    return view;
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
        return tableView.sectionFooterHeight;

//        return 0;
    }
    if ([[self.pubDetailModel.content_list[section - 1] dot_list] count] > 3) {
        
        return 34;
    }
    return 10;
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
#pragma mark - 删除这一列
- (void)deleteCheckItemSection:(UIButton *)sender
{
    [self.view endEditing:YES];

    
    UIButton *button = (UIButton *)sender;
    
    [self.pubDetailModel.content_list removeObjectAtIndex:button.tag - 1];
    

    
    [self.tableview beginUpdates];
    
    [self.tableview deleteSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableview endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
//        [self jugeBottomViewHidden];

    });

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];

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
#pragma mark - 发布检查项
-(void)publishNewCreateCheckItem
{
    [self.view endEditing:YES];

    [self saveHttpRequst];
    
}
#pragma mark - 编辑保存
-(void)publishModifyCheckItem
{
    [self.view endEditing:YES];

    [self JGJHttpEditeRequst];

}
#pragma mark - 点击添加检查点
-(void)JGJCheckContentClickBtn
{
    [self.view endEditing:YES];

    
//    [self jugeBottomViewHidden];
    
    
    JGJAddCheckItemContensViewController *addVc = [[UIStoryboard storyboardWithName:@"JGJAddCheckItemContensViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddCheckItemContensVC"];
    addVc.hadMutlArr = self.pubDetailModel.content_list;

    addVc.WorkproListModel = self.WorkproListModel;
    [self.navigationController pushViewController:addVc animated:YES];

}
#pragma mark - 处理底部添加按钮是否固定

- (void)jugeBottomViewHidden
{
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    [self.view addSubview:self.bottomView];
    
    if (self.tableview.contentSize.height > TYGetUIScreenHeight - 63 ) {
        
        self.bottomView.hidden = NO;
        
    }else{
        
        self.bottomView.hidden = YES;
        
    }
    if (self.bottomView.hidden) {
        
        self.tableview.tableFooterView = self.footView;
        [UIView animateWithDuration:.1 animations:^{
            self.bottomConstance.constant = 0;

        }];
    }else{
        
        self.tableview.tableFooterView = nil;
        
        [UIView animateWithDuration:.1 animations:^{
            self.bottomConstance.constant = 74;

  
        }];
    }
    


}
-(JGJCheckItemPubDetailModel *)pubDetailModel
{
    if (!_pubDetailModel) {
        _pubDetailModel = [JGJCheckItemPubDetailModel new];
    }
    return _pubDetailModel;
}
#pragma mark - 选中内容设置值
-(void)setSelectdataArr:(NSMutableArray<JGJCheckItemPubDetailListModel *> *)SelectdataArr
{

    if (self.pubDetailModel.content_list.count) {
        
        [self.pubDetailModel.content_list removeAllObjects];
 
    }
    
    [self.pubDetailModel.content_list addObjectsFromArray:SelectdataArr];
    [self.tableview reloadData];
    
}


#pragma mark - 保存发布

- (void)saveHttpRequst
{
    
    NSMutableArray *idsArr = [NSMutableArray array];
    for (int i = 0; i < self.pubDetailModel.content_list.count; i ++) {
        [idsArr addObject:[self.pubDetailModel.content_list[i] content_id]?:@""];
    }
    if ([NSString isEmpty: self.pubDetailModel.pro_name]) {
        [TYShowMessage showPlaint:@"有信息未填写。填写完整后可发布"];
        return;
    }
    if (idsArr.count <= 0) {
        [TYShowMessage showPlaint:@"没有检查内容，添加完成后可发布"];
        return;
    }
    NSString *string = [idsArr componentsJoinedByString:@","];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:self.pubDetailModel.pro_name?:@"" forKey:@"pro_name"];
    
    [paramDic setObject:self.pubDetailModel.location_text?:@"" forKey:@"location_text"];
    
    [paramDic setObject:string?:@"" forKey:@"content_ids"];

    [paramDic setObject:@"1" forKey:@"is_object"];

    
    typeof(self) weakSelf = self;
    
   [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/addInspecPro" parameters:paramDic success:^(id responseObject) {
       
       if (_checkItemNodata) {
           JGJCheckTheItemViewController *WorkReportVC = [[UIStoryboard storyboardWithName:@"JGJCheckTheItemViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJCheckTheItemVC"];
           
           WorkReportVC.backMain = YES;
           
           WorkReportVC.WorkproListModel = self.WorkproListModel;
           
           [self.navigationController pushViewController:WorkReportVC animated:YES];
       }else{
       JGJCheckContentListModel *defultModel = [JGJCheckContentListModel mj_objectWithKeyValues:responseObject];
       
       if (self.createCheckItemGo) {
           for (UIViewController *addVC in weakSelf.navigationController.viewControllers) {
               if ([addVC isKindOfClass:[JGJAddCheckItemPlanViewController class]]) {
                   
                   JGJAddCheckItemPlanViewController *checkAddVC = (JGJAddCheckItemPlanViewController *)addVC;
                   checkAddVC.defultModel = defultModel;
                   break;
               }
           }
       }
       
       [weakSelf.navigationController popViewControllerAnimated:YES];
       }
       [TYShowMessage showSuccess:@"发布成功!"];
       
   }failure:^(NSError *error) {
    
   }];


}
#pragma mark - 查看检查项详情和编辑检查项

- (void)JGJHttpEditeRequst
{
    NSMutableArray *idsArr = [NSMutableArray array];
    for (int i = 0; i < self.pubDetailModel.content_list.count; i ++) {
        [idsArr addObject:[self.pubDetailModel.content_list[i] content_id]?:@""];
    }
    if ([NSString isEmpty: self.pubDetailModel.pro_name]) {
        [TYShowMessage showPlaint:@"有信息未填写。填写完整后可发布"];
        return;
    }
    if (idsArr.count <= 0) {
        [TYShowMessage showPlaint:@"没有检查内容，添加完成后可发布"];
        return;
    }
    NSString *string = [idsArr componentsJoinedByString:@","];
    

    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.pubDetailModel.pro_id?:@"" forKey:@"pro_id"];

    [paramDic setObject:self.pubDetailModel.pro_name?:@"" forKey:@"pro_name"];
    
    [paramDic setObject:self.pubDetailModel.location_text?:@"" forKey:@"location_text"];
    
    [paramDic setObject:string?:@"" forKey:@"content_ids"];

    typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/updateInspecPro" parameters:paramDic success:^(id responseObject) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [TYShowMessage showSuccess:@"修改成功!"];
        
    }failure:^(NSError *error) {
        
    }];



}
#pragma mark - 获取检查项详情修改时需要
-(void)JGJDetailHttpRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:_mainCheckListModel.id?:@"" forKey:@"pro_id"];
 
    
    typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProInfo" parameters:paramDic success:^(id responseObject) {
        
        weakSelf.pubDetailModel = [JGJCheckItemPubDetailModel mj_objectWithKeyValues:responseObject];
        
        [weakSelf.tableview reloadData];
        
//        [self.view addSubview:self.bottomView];

//        [self jugeBottomViewHidden];
    }failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点接口看是否显示默认引导页

- (void)JGJHttpRequest
{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@"content" forKey:@"type"];
    
    typeof(self) weakSelf = self;
    

    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/inspect/getInspectProOrContent" parameters:paramDic success:^(id responseObject) {
        
        weakSelf.listModel = [JGJCheckItemMainListModel mj_objectWithKeyValues:responseObject];
        
        //此处去掉默认页 没有检查内容的时候
        /*
        if (weakSelf.listModel.list.count <= 0) {
            
            [weakSelf initBottomDefultView];
            
        }else{
        */
            
//            [self jugeBottomViewHidden];
        /*
        }
        */
        [TYLoadingHub hideLoadingView];
        
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}

- (void)ClickMore:(UIButton *)button
{

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
