//
//  JGJCurrentSureBillListViewController.m
//  mix
//
//  Created by ccclear on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCurrentSureBillListViewController.h"
#import "JGJUnWagesShortWorkCell.h"
#import "JGJHeaderFooterPaddingView.h"
#import "JGJCheckAccountHeaderView.h"
#import "NSDate+Extend.h"
#import "JGJModifyBillListViewController.h"
#import "JGJRecordBillDetailViewController.h"
#import "YZGNoWorkitemsView.h"
#import "NSArray+JGJDateSort.h"
#import "JGJCustomLable.h"
@interface JGJCurrentSureBillListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *sureBillList;

@property (nonatomic, strong) NSMutableArray *sortDataSource;
@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) YZGNoWorkitemsView *yzgNoWorkitemsView;

@end

@implementation JGJCurrentSureBillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontEBEBEBColor;
    self.title = @"本次确认的";
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.sureBillList];
    
    [_sureBillList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.left.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    JGJPageSizeModel *pageSizeModel = [[JGJPageSizeModel alloc] init];
    NSArray *sureBill = [TYUserDefaults objectForKey:[NSString stringWithFormat:@"%@%@",JGJSureBillArray,[TYUserDefaults objectForKey:JLGUserUid]]];
    if (sureBill.count > 0) {
        
        self.sortDataSource = [pageSizeModel sortDesDataSource:[JGJRecordWorkPointListModel mj_objectArrayWithKeyValuesArray:sureBill]];
        [self.yzgNoWorkitemsView removeFromSuperview];
    }else {
        
        [self.view addSubview:self.yzgNoWorkitemsView];
    }
    
    [self.sureBillList reloadData];
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.sortDataSource[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJUnWagesShortWorkCell *cell = [JGJUnWagesShortWorkCell cellWithTableView:tableView];
    
    cell.isCurrentSureBillVCComeIn = YES;
    //工时、工天显示
    cell.showType = self.selTypeModel.type;
    
    NSArray *workdays = self.sortDataSource[indexPath.section];
    
    JGJRecordWorkPointListModel *listModel = workdays[indexPath.row];
    
    cell.listModel = listModel;
    
    cell.isHiddenLineView = (workdays.count - 1 == indexPath.row) && (self.sortDataSource.count != indexPath.section);
    
    cell.isScreenShowLine = self.sortDataSource.count == indexPath.section;
    
    cell.nextImageView.hidden = NO;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 40;
        
    }else {
        
       return 30;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    JGJHeaderFooterPaddingView *paddingView = [JGJHeaderFooterPaddingView headerFooterPaddingViewWithTableView:tableView];
    
    CGFloat originalY = section == 0 ? 0 : 9.5;
    
    BOOL isHidden = self.sortDataSource.count - 1 == section;
    
    [paddingView setUpdateLineViewLayoutWithTop:originalY left:0 right:0 isHidden:isHidden];
    
    return paddingView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = self.sortDataSource.count - 1 == section ? 0.01 : 10;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = AppFontEBEBEBColor;
    if (section == 0) {
    
        backView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 40);
    }else {
        
        backView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 30);
    }
    
    UIView *backTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
    backTopLine.backgroundColor = AppFontdbdbdbColor;
    [backView addSubview:backTopLine];

    if (section == 0) {

        backTopLine.hidden = YES;

    }else {

        backTopLine.hidden = NO;
    }

    JGJCustomLable *titleLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, section == 0 ? 10 : 0, TYGetUIScreenWidth, 30)];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    titleLable.textColor = AppFont666666Color;
    titleLable.backgroundColor = AppFontf7f7f7Color;
    [backView addSubview:titleLable];
    

    UIView *titleLableTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(titleLable.frame), TYGetUIScreenWidth, 0.5)];
    titleLableTopLine.backgroundColor = AppFontdbdbdbColor;
    [backView addSubview:titleLableTopLine];
    
    NSArray *workdays = self.sortDataSource[section];
    if (workdays.count > 0) {
        
        JGJRecordWorkPointWorkdayListModel *workdayListModel = workdays[0];
        
        NSString *date_turn = [NSDate convertChineseDateWithDate:workdayListModel.date];
        titleLable.text = [NSString stringWithFormat:@"%@ (%@)", workdayListModel.date, date_turn];
        titleLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        
    }
    
    return backView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:self.sortDataSource[indexPath.section][indexPath.row]];
    
    JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
    recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
    recordBillVC.is_currentSureBill_come_in = YES;
    [self.navigationController pushViewController:recordBillVC animated:YES];
    
}

- (MateWorkitemsItems *)TransformModel:(JGJRecordWorkPointListModel *)wageBestDetailWorkday{
    
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.accounts_type.code = [wageBestDetailWorkday.accounts_type integerValue];
    mateWorkitemsItem.id =  [wageBestDetailWorkday.recordId?:@"0" longLongValue];
    mateWorkitemsItem.record_id = wageBestDetailWorkday.recordId ? :@"0";
    return mateWorkitemsItem;
}


- (UITableView *)sureBillList {
    
    if (!_sureBillList) {
        
        _sureBillList = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _sureBillList.rowHeight = 80;
        _sureBillList.backgroundColor = [UIColor clearColor];
        _sureBillList.showsVerticalScrollIndicator = NO;
        _sureBillList.delegate = self;
        _sureBillList.dataSource = self;
        _sureBillList.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _sureBillList;
}

- (NSMutableArray *)sortDataSource {
    
    if (!_sortDataSource) {
        
        _sortDataSource = [[NSMutableArray alloc] init];
    }
    return _sortDataSource;
}

- (YZGNoWorkitemsView *)yzgNoWorkitemsView
{
    if (!_yzgNoWorkitemsView) {
        
        _yzgNoWorkitemsView = [[YZGNoWorkitemsView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, self.view.frame.size.height)];
        _yzgNoWorkitemsView.departLable.hidden = YES;
        // 暂无需要你对账的记工 对账完成的记工可去记工流水查看详情
        NSString *firstString = [NSString stringWithFormat:@"暂无本次已确认的记工记账\n上次确认的记工，请前往记工流水查看"];
        _yzgNoWorkitemsView.contentView.backgroundColor = [UIColor whiteColor];
        
        [_yzgNoWorkitemsView setContentStr:firstString];
        [_yzgNoWorkitemsView setButtonShow:YES];
        _yzgNoWorkitemsView.noRecordButton.hidden = YES;
        _yzgNoWorkitemsView.backButton.hidden = YES;
    }
    return _yzgNoWorkitemsView;
}
@end
