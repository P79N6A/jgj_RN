//
//  JGJCreatTeamSelectedProVC.m
//  mix
//
//  Created by yj on 16/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatTeamSelectedProVC.h"
#import "JGJCreatTeamSelectedCell.h"
#import "JGJCreatTeamVC.h"
#import "YZGOnlyAddProjectViewController.h"
#import "NSString+Extend.h"
#import "CFRefreshStatusView.h"

#import "TYTextField.h"

#import "JGJCommonButton.h"

#define SearchbarHeight 48

@interface JGJCreatTeamSelectedProVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    CFRefreshStatusViewDelegate,
    UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@property (nonatomic, copy) NSString *searchValue;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property(nonatomic ,strong)    NSMutableArray *backUpdataArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@end

@implementation JGJCreatTeamSelectedProVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self searchbar];
    
    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
    
    rightItemBtn.buttonTitle = @"新建项目";
    
    rightItemBtn.type = JGJCommonCreatProType;
    
    [rightItemBtn addTarget:self action:@selector(addProButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
    [self loadGroupProListNetData];
}
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.proLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCreatTeamSelectedCell *cell = [JGJCreatTeamSelectedCell cellWithTableView:tableView];
    
    cell.searchValue = self.searchValue;
    
    cell.projectListModel = self.proLists[indexPath.row];
    if (self.proLists.count > 0) {
        cell.lineView.hidden = indexPath.row == self.proLists.count - 1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJProjectListModel *projectListModel = self.proLists[indexPath.row];
    projectListModel.isSelected = !projectListModel.isSelected;
    JGJCreatTeamVC * creatTeamVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJCreatTeamVC class]]) {
            creatTeamVC = (JGJCreatTeamVC *)vc;
            break;
        }
    }
    if (creatTeamVC.projectListModel) {
        for (JGJProjectListModel *lastprojectListModel in self.proLists) {
            if ([lastprojectListModel.pro_id isEqualToString:creatTeamVC.projectListModel.pro_id]) {
                lastprojectListModel.isSelected = NO;
            }
        }
    }
    creatTeamVC.projectListModel = projectListModel;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJProjectListModel *projectListModel = self.proLists[indexPath.row];
    return [projectListModel.is_create_group isEqualToString:@"0"];
}

- (void)setProLists:(NSMutableArray *)proLists {
    _proLists = proLists;
    JGJCreatTeamVC *creatTeamVC  = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJCreatTeamVC class]]) {
            creatTeamVC = (JGJCreatTeamVC *)vc;
            break;
        }
    }
    for (JGJProjectListModel *lastprojectListModel in _proLists) {
        if (![NSString isEmpty:creatTeamVC.projectListModel.pro_id]) {
            if ([lastprojectListModel.pro_id isEqualToString:creatTeamVC.projectListModel.pro_id]) {
                lastprojectListModel.isSelected = YES;
            }
        }
    }
    
    if (proLists.count == 0 && self.backUpdataArr.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"没有可选择的项目"];
        
        statusView.frame = self.view.bounds;
        
        statusView.delegate = self;
        
        statusView.buttonTitle = @"新建项目";
        
        self.tableView.tableHeaderView = statusView;
        
    }else {
        
        self.tableView.tableHeaderView = nil;
    }
    
    [self.tableView reloadData];
}

-(void)loadGroupProListNetData{
//    NSDictionary *parameters = @{@"ctrl" : @"group",
//                                 @"action" : @"groupProList"
//                                 };
//    __weak typeof(self) weakSelf = self;
//    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        weakSelf.proLists = [JGJProjectListModel mj_objectArrayWithKeyValuesArray:responseObject];
//
//        weakSelf.backUpdataArr = _proLists;
//
//        weakSelf.topDistance.constant = _proLists.count == 0 ? 0 : SearchbarHeight;
//
//        weakSelf.searchbar.hidden = _proLists.count == 0;
//
//    } failure:nil];
//
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/group-pro-list" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        weakSelf.proLists = [JGJProjectListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        weakSelf.backUpdataArr = _proLists;
        
        weakSelf.topDistance.constant = _proLists.count == 0 ? 0 : SearchbarHeight;
        
        weakSelf.searchbar.hidden = _proLists.count == 0;
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - buttonAction
- (IBAction)addProButtonPressed:(UIBarButtonItem *)sender {
    
    YZGOnlyAddProjectViewController *editTeamNameVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    editTeamNameVc.isCreatTeamEditProName = YES;
    editTeamNameVc.title = @"新建项目";
    editTeamNameVc.proNameTFPlaceholder = @"请输入项目名称";
    [self.navigationController pushViewController:editTeamNameVc animated:YES];
}

#pragma mark - CFRefreshStatusViewDelegate
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
    [self addProButtonPressed:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"快速搜索关键字";
        
        _searchbar.searchBarTF.delegate = self;
                
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 30;
        
        __weak typeof(self) weakSelf = self;
        
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
            
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_searchbar];
        
        [_searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.equalTo(self.view);
            
            make.height.mas_equalTo(SearchbarHeight);
            
        }];
        
    }
    
    return _searchbar;
    
}

- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pro_name contains %@", lowerSearchText];
    
    NSMutableArray *dataSource = [self.backUpdataArr  filteredArrayUsingPredicate:predicate].mutableCopy;
    
    if (![NSString isEmpty:value]) {
        
        self.proLists = dataSource;
        
    } else {
        
        [self.view endEditing:YES];
        
        self.proLists = self.backUpdataArr;
        
    }
    
    self.searchValue = value;
    
    [self.tableView reloadData];
}

@end
