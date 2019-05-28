//
//  JGJNewMarkBillChoiceProjectViewController.m
//  mix
//
//  Created by Tony on 2018/6/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNewMarkBillChoiceProjectViewController.h"
#import "TYTextField.h"
#import "JGJNewMarkBillProjectListCell.h"
#import "JGJNewMarkBillProjectModel.h"
#import "JGJCustomPopView.h"
#import "JGJCreateNewProjectView.h"
#import "IQKeyboardManager.h"
#import "SJButton.h"
#import "JGJMoreDayViewController.h"
#import "JGJNewCreateProjectAlertView.h"
@interface JGJNewMarkBillChoiceProjectViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,JGJNewMarkBillProjectListCellDelegate>
{
    JGJNewMarkBillProjectListCell *_cell;
    BOOL _startEdite;
    UIButton *_rightBtn;
}

@property (nonatomic, strong) NSMutableArray <JGJNewMarkBillProjectModel*> *projectListArr;
@property (nonatomic ,strong) NSMutableArray <JGJNewMarkBillProjectModel*> *backUpdataArr;
@property (nonatomic, strong) JGJCustomSearchBar *searchbar;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *projectListTb;
@property (nonatomic, strong) UIView *bottomBackView;
@property (nonatomic, strong) SJButton *createBtn;
@property (nonatomic, strong) JGJCreateNewProjectView *createNewProjectView;
@property (nonatomic, strong) NSString *searchValue;

@end

@implementation JGJNewMarkBillChoiceProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.title = @"选择项目";
    
    [self createRightItem];
    [self initializeAppearance];
    [IQKeyboardManager sharedManager].enable = NO;
    

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight   = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        // 修改下边距约束
        _createNewProjectView.sd_layout.bottomSpaceToView(self.view, keyboardHeight);
    }];
    
    [_createNewProjectView updateLayout];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    
    // 获得键盘动画时长
    NSDictionary *userInfo   = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        // 修改为以前的约束（距下边距0）
        _createNewProjectView.sd_layout.bottomSpaceToView(self.view, -50);
    }];
    [_createNewProjectView updateLayout];
}


- (void)createRightItem {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 100, 44);
    rightBtn.titleLabel.font = FONT(15);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitle:@"修改及删除" forState:(UIControlStateNormal)];
    [rightBtn setTitle:@"取消" forState:(UIControlStateSelected)];
    [rightBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(editeProject:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightBtn = rightBtn;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJMoreDayViewController class]]) {
            
            JGJMoreDayViewController *moreDay = (JGJMoreDayViewController *)vc;
            [moreDay showMoreDayPickerView];
        }
    }
}


#pragma mark -设置缺省页
- (JGJComDefaultView *)setHeaderDefaultView {
    
    JGJComDefaultView *defaultView = [[JGJComDefaultView alloc] initWithFrame:self.view.bounds];
    
    JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
    
    defaultViewModel.lineSpace = 5;
    
    defaultViewModel.des = @"暂无同步给他人的数据\n若需同步数据，请点击右上角的\"新增同步\"";
    
    defaultViewModel.buttonTitle = @"新建项目";
    
    defaultView.defaultViewModel = defaultViewModel;
    
    defaultView.comDefaultViewBlock = ^{// 新建项目
       
        
    };
    
    return defaultView;
}

- (void)initializeAppearance {
    
    _searchValue = @"";
    _projectListArr = [NSMutableArray new];
    _backUpdataArr = [NSMutableArray new];
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.line];
    [self.view addSubview:self.projectListTb];
    [self.view addSubview:self.bottomBackView];
    [self.bottomBackView addSubview:self.createBtn];
    
    [self.view addSubview:self.createNewProjectView];
    
    [self setUpLayout];
    
    [self loadProjectListData];
    [_bottomBackView updateLayout];
    [_createBtn updateLayout];
    
    _createBtn.layer.cornerRadius = 5;
}

- (void)setUpLayout {

    _searchbar.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(48);
    _line.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(_searchbar, 0).heightIs(0.5);
    _projectListTb.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_line, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 65 + JGJ_IphoneX_BarHeight);
    
    _bottomBackView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(65);
    _createBtn.sd_layout.leftSpaceToView(_bottomBackView, 10).rightSpaceToView(_bottomBackView, 10).centerYEqualToView(_bottomBackView).heightIs(45);

    _createNewProjectView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, -50).heightIs(50);
}

- (void) loadProjectListData {
    
    _startEdite = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [self.searchbar.searchBarTF endEditing:YES];
    self.bottomBackView.hidden = NO;
    self.searchbar.searchBarTF.text = @"";
    self.searchValue = @"";
    
    NSDictionary *param;
    if (_isMarkSingleBillComeIn) {
        
        param = @{@"is_record":@(YES)};
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"group/group-pro-list" parameters:param success:^(NSArray *responseObject) {
       
        [TYLoadingHub hideLoadingView];
        [_backUpdataArr removeAllObjects];
        _projectListArr = [JGJNewMarkBillProjectModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (int i = 0; i < _projectListArr.count; i ++) {
            
            JGJNewMarkBillProjectModel *listModel = _projectListArr[i];
            JGJNewMarkBillProjectModel *updateModel = [[JGJNewMarkBillProjectModel alloc] init];
            updateModel.pro_id = listModel.pro_id;
            updateModel.pro_name = listModel.pro_name;
            updateModel.isEditeStating = listModel.isEditeStating;
            updateModel.is_create_group = listModel.is_create_group;
            [_backUpdataArr addObject:updateModel];
        }
        
        if (responseObject.count == 0) {
            
            // 没有项目,缺省页
            
        }else{
            
        }
        
        [_projectListTb reloadData];
    
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setBillModel:(YZGGetBillModel *)billModel {
    
    _billModel = billModel;
}

- (void)editeProject:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = NO;
        _startEdite = NO;
        [IQKeyboardManager sharedManager].enable = NO;
        
        if (![NSString isEmpty:self.searchValue]) {
            
            [self searchWithValue:self.searchValue];
        }else {
            
            for (int i = 0; i < _projectListArr.count; i ++) {
                
                JGJNewMarkBillProjectModel *pModel = _projectListArr[i];
                pModel.isEditeStating = NO;
                [_projectListArr replaceObjectAtIndex:i withObject:pModel];
            }
            
            self.projectListArr = self.backUpdataArr;
            [_projectListTb reloadData];
        }
        
        self.bottomBackView.hidden = NO;
        
    }else {
        
        [IQKeyboardManager sharedManager].enable = YES;
        [self.createNewProjectView.inputContent endEditing:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        sender.selected = YES;
        _startEdite = YES;
        self.bottomBackView.hidden = YES;
        [_projectListTb reloadData];
    }
    
    
}

- (void)setIsMarkSingleBillComeIn:(BOOL)isMarkSingleBillComeIn {
    
    _isMarkSingleBillComeIn = isMarkSingleBillComeIn;
}

// 新增项目
- (void)createNewProject {
    
    [IQKeyboardManager sharedManager].enable = NO;
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [_createNewProjectView.inputContent becomeFirstResponder];

}
#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _projectListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *ID = NSStringFromClass([JGJNewMarkBillProjectListCell class]);
    _cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!_cell) {

        _cell = [[JGJNewMarkBillProjectListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (_startEdite) {
        
        [_cell startEdite];
    }else {
        
        [_cell endEdite];
    }
    
    _cell.isMarkSingleBillComeIn = self.isMarkSingleBillComeIn;
    _cell.searchValue = self.searchValue;
    _cell.selectedProjectName = _billModel.proname;
    _cell.projectModel = _projectListArr[indexPath.row];
    
    if (_cell.projectModel.isEditeStating) {
        
        [_cell.contentField becomeFirstResponder];
    }
    _cell.tag = indexPath.row + 1000;
    _cell.projectListCellDelegate = self;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return _cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJNewMarkBillProjectModel *projectModel = _projectListArr[indexPath.row];
    if (!_isMarkSingleBillComeIn) {//新建班组进入选择项目页面
        
        if ([projectModel.is_create_group isEqualToString:@"1"]) {// 已有班组
            
            JGJNewCreateProjectAlertView *createProjectAlertView = [[JGJNewCreateProjectAlertView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
            // 获取匹配规则后生成的数字 v3.5.2(需求 -> 新建班组，选择已有班组的项目后的流程优化)
            __block NSString *pro_name = [self getRegulationMatchStringWithProjectName:projectModel.pro_name];
            createProjectAlertView.projectName = pro_name;
            [createProjectAlertView show];
            
            createProjectAlertView.cancle = ^{
              
                
            };
            
            TYWeakSelf(self)
            createProjectAlertView.agree = ^(NSString *project_name,UIView *view) {
                
                if (project_name.length > 20) {
                    
                    [TYShowMessage showError:@"项目名称太长，请重新输入"];
                    
                    
                }else {
                    
                    [TYLoadingHub showLoadingWithMessage:nil];
                    [view removeFromSuperview];
                    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":project_name} success:^(id responseObject) {
                        
                        [TYLoadingHub hideLoadingView];
                        if ([weakself.projectListVCDelegate respondsToSelector:@selector(selectedProjectWithProjectModel:)]) {
                            
                            JGJNewMarkBillProjectModel *projectModel = [[JGJNewMarkBillProjectModel alloc] init];
                            projectModel.pro_name = responseObject[@"pro_name"];
                            projectModel.pro_id = responseObject[@"pid"];
                            [weakself.projectListVCDelegate selectedProjectWithProjectModel:projectModel];
                            [weakself.createNewProjectView.inputContent endEditing:YES];
                            [[NSNotificationCenter defaultCenter] removeObserver:weakself];
                            [weakself.navigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    } failure:^(NSError *error) {
                        
                        [TYLoadingHub hideLoadingView];
                    }];
                }
            };
            return;
        }
    }
    
    if ([self.projectListVCDelegate respondsToSelector:@selector(selectedProjectWithProjectModel:)]) {
        
        [_projectListVCDelegate selectedProjectWithProjectModel:_projectListArr[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)getRegulationMatchStringWithProjectName:(NSString *)projectName {
    
    NSString *pro_name = @"";
    
    // 1、拆分当前点击的项目名称
    NSString *first_str = [projectName substringToIndex:projectName.length - 2];
    NSString *second_str = [projectName substringFromIndex:projectName.length - 2];
    
    // 判断最后两位为数字
    if (![NSString isInputNum:second_str]) {// 不是数字
        
        first_str = projectName;
        second_str = @"00";
        
    }
    // 2、循环出当前项目列表，每个项目名称 安装1、步骤拆分每条数据，找出和first_str相同的项目名称,把最后两位数字，放入数组 same_name_number_strArr，并找出最后两位最大的数字
    NSMutableArray *same_name_number_strArr = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.projectListArr.count; i ++) {
        
        JGJNewMarkBillProjectModel *projectModel = _projectListArr[i];
        NSString *circulation_pro_name = @"";
        if (projectModel.pro_name.length < 3) {
            
            circulation_pro_name = [NSString stringWithFormat:@"%@00",projectModel.pro_name];
            
        }else {
            
            circulation_pro_name = projectModel.pro_name;
        }
        
        NSString *circulation_first_str = [circulation_pro_name substringToIndex:circulation_pro_name.length - 2];
        NSString *circulation_second_str = [circulation_pro_name substringFromIndex:circulation_pro_name.length - 2];
        // 3、判断最后两位为数字
        if (![NSString isInputNum:circulation_second_str]) {// 不是数字
            
            circulation_first_str = projectModel.pro_name;
            circulation_second_str = @"00";
            
        }
        
        // 4、找出和first_str相同的项目名称，放入数组 same_first_strArr
        if ([first_str isEqualToString:circulation_first_str]) {// 相同

            [same_name_number_strArr addObject:@([circulation_second_str integerValue])];

        }
        
    }
    NSInteger max_number = 0;
    max_number = [[same_name_number_strArr valueForKeyPath:@"@max.floatValue"] integerValue] + 1;
    if (max_number < 9) {
        
        pro_name = [NSString stringWithFormat:@"%@0%ld",first_str,max_number];
        
    }else {
        
        pro_name = [NSString stringWithFormat:@"%@%ld",first_str,max_number];
    }
    
    return pro_name;
}

#pragma mark - JGJNewMarkBillProjectListCellDelegate
- (void)modifyProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel cell:(JGJNewMarkBillProjectListCell *)cell {
    
    // 1.获取对面编辑的model在数组中的index
    NSInteger index = cell.tag - 1000;
    // 2.将model的isEditeStating变为yes状态
    projectModel.isEditeStating = YES;
    
    // 3.替换数据源
    [_projectListArr replaceObjectAtIndex:index withObject:projectModel];
    
    for (int i = 0; i < _projectListArr.count; i ++) {
        
        JGJNewMarkBillProjectModel *pModel = _projectListArr[i];
        if (projectModel.pro_id != pModel.pro_id) {
            
            pModel.isEditeStating = NO;
            [_projectListArr replaceObjectAtIndex:i withObject:pModel];
        }
    }
    
    // 4.刷新数据源
    [_projectListTb reloadData];
    [_projectListTb layoutIfNeeded];
}

- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = [NSString stringWithFormat:@"确认删除 %@ 项目吗?",projectModel.pro_name];
    desModel.popTextAlignment = NSTextAlignmentLeft;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        NSDictionary *parameters = @{@"pid_str":projectModel.pro_id ?: [NSNull null]};
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:@"workday/del-pro" parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            [TYShowMessage showSuccess:@"项目删除成功！"];
            _startEdite = NO;
            _rightBtn.selected = NO;
            [self loadProjectListData];
            if ([self.projectListVCDelegate respondsToSelector:@selector(deleteProjectWithProjectModel:)]) {
                
                [self.projectListVCDelegate deleteProjectWithProjectModel:projectModel];
                
            }
            
            
        } failure:^(NSError *error) {
           
            [TYLoadingHub hideLoadingView];
        }];

    };
    
}

- (void)saveProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel isEqualProjectName:(BOOL)isEqualProjectName editeName:(NSString *)editeBame{
    
    if (isEqualProjectName) {// 是否修改的项目名称和之前的相同
        
        [TYShowMessage showSuccess:@"项目修改成功!"];
        _startEdite = NO;
        _rightBtn.selected = NO;
        [self loadProjectListData];
        
    }else {
        
        NSDictionary *parameters = @{@"pid_str":projectModel.pro_id ?: [NSNull null],
                                     @"pro_name":editeBame ?: [NSNull null]};
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithNapi:@"workday/modify-pro" parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            [TYShowMessage showSuccess:@"项目修改成功!"];
            
            projectModel.pro_name = editeBame;
            if (_isMarkSingleBillComeIn) {
                
                if (![NSString isEmpty:_billModel.proname]) {
                    
                    if (_billModel.pid == [projectModel.pro_id integerValue]) {
                        
                        _billModel.proname = projectModel.pro_name;
                        if ([self.projectListVCDelegate respondsToSelector:@selector(selectedProjectWithProjectModel:)]) {
                            
                            [_projectListVCDelegate selectedProjectWithProjectModel:projectModel];
                            
                        }
                    }
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [TYShowMessage hideHUD];
                    _startEdite = NO;
                    _rightBtn.selected = NO;
                    [self loadProjectListData];
                });
            }else {
                
                if ([projectModel.is_create_group isEqualToString:@"1"]) {// 已有班组
                    
                    _startEdite = NO;
                    _rightBtn.selected = NO;
                    [self loadProjectListData];
                }else {
                    
                    if (![NSString isEmpty:_billModel.proname]) {
                        if (_billModel.pid == [projectModel.pro_id integerValue]) {
                            
                            _billModel.proname = projectModel.pro_name;
                            if ([self.projectListVCDelegate respondsToSelector:@selector(selectedProjectWithProjectModel:)]) {
                                
                                [_projectListVCDelegate selectedProjectWithProjectModel:projectModel];
                                
                            }
                        }
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [TYShowMessage hideHUD];
                        _startEdite = NO;
                        _rightBtn.selected = NO;
                        [self loadProjectListData];
                    });
                }
            }
            
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
    
}


- (void)searchWithValue:(NSString *)value {
    
    NSString *lowerSearchText = value.lowercaseString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pro_name contains %@", lowerSearchText];
    
    NSMutableArray *dataSource = [self.backUpdataArr  filteredArrayUsingPredicate:predicate].mutableCopy;
    
    if (![NSString isEmpty:value]) {
        
        self.projectListArr = dataSource;
        
    } else {
        
        [self.view endEditing:YES];
        
        self.projectListArr = self.backUpdataArr;
        
    }
    
    self.searchValue = value;
    
    [self.projectListTb reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.createNewProjectView.inputContent endEditing:YES];
    [self.searchbar.searchBarTF endEditing:YES];
}
#pragma mark - getter/setter
- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchbar.searchBarTF.returnKeyType = UIReturnKeySearch;
        _searchbar.searchBarTF.placeholder = @"快速搜索关键字";
        _searchbar.searchBarTF.backgroundColor = AppFontf3f3f3Color;
        _searchbar.searchBarTF.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        _searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            [weakSelf searchWithValue:value];
        };
        
        _searchbar.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _searchbar;
    
}

- (UITableView *)projectListTb {
    
    if (!_projectListTb) {
        
        _projectListTb = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _projectListTb.backgroundColor = AppFontf1f1f1Color;
        _projectListTb.showsVerticalScrollIndicator = NO;
        _projectListTb.delegate = self;
        _projectListTb.dataSource = self;
        _projectListTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _projectListTb.tableFooterView = [[UIView alloc] init];
        _projectListTb.rowHeight = 50.f;
 
        
    }
    return _projectListTb;
}

- (UIView *)bottomBackView {
    
    if (!_bottomBackView) {
        
        _bottomBackView = [[UIView alloc] init];
        _bottomBackView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBackView;
}

- (SJButton *)createBtn {
    
    if (!_createBtn) {
        
        _createBtn = [SJButton buttonWithType:SJButtonTypeHorizontalImageTitle];
        _createBtn.backgroundColor = AppFontEB4E4EColor;
        [_createBtn setImage:IMAGE(@"createNewProjectAdd") forState:SJControlStateNormal];
        [_createBtn setTitle:@"新建项目" forState:(SJControlStateNormal)];
        [_createBtn setTitleColor:[UIColor whiteColor] forState:(SJControlStateNormal)];
        _createBtn.titleLabel.font = FONT(AppFont34Size);
        
        [_createBtn addTarget:self action:@selector(createNewProject) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _createBtn;
}

- (JGJCreateNewProjectView *)createNewProjectView {
    
    if (!_createNewProjectView) {
        
        __weak typeof(self) weakSelf = self;
        _createNewProjectView = [[JGJCreateNewProjectView alloc] init];
        _createNewProjectView.createProject = ^(NSString *pro_name) {
          
            if ([NSString isEmpty:pro_name]) {
                
                [TYShowMessage showError:@"请输入项目名称"];
                
            }else {
                
                // 过滤字符串首位空格
                pro_name = [pro_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [TYLoadingHub showLoadingWithMessage:nil];
                [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":pro_name} success:^(id responseObject) {
                    
                    [TYLoadingHub hideLoadingView];
                    if ([weakSelf.projectListVCDelegate respondsToSelector:@selector(selectedProjectWithProjectModel:)]) {
                        
                        JGJNewMarkBillProjectModel *projectModel = [[JGJNewMarkBillProjectModel alloc] init];
                        projectModel.pro_name = responseObject[@"pro_name"];
                        projectModel.pro_id = responseObject[@"pid"];
                        [weakSelf.projectListVCDelegate selectedProjectWithProjectModel:projectModel];
                        
                        [weakSelf.createNewProjectView.inputContent endEditing:YES];
                        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    [TYLoadingHub hideLoadingView];
                }];
                
            }

        };
    }
    return _createNewProjectView;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}
@end
