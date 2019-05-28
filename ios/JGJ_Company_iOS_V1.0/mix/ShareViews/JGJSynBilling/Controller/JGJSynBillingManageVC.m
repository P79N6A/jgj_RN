//
//  JGJSynBillingManageVC.m
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynBillingManageVC.h"
#import "JGJSyncProlistVC.h"
#import "JGJSynBillingManageCell.h"
#import "JGJSynAddressBookVC.h"
#import "NSString+Extend.h"
#import "Searchbar.h"
#import "UILabel+GNUtil.h"
#import "CustomAlertView.h"
#import "UIView+GNUtil.h"
#import "UIImage+Cut.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "JGJCustomAlertView.h"
#import "JGJShareProDesView.h"
#import "JGJGuideImageVc.h"

#import "JGJWebAllSubViewController.h"

#define RowH 75
#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

@implementation WageMoreDetailInitModel
@end

@interface JGJSynBillingManageVC () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, CFRefreshStatusViewDelegate, DSectionIndexViewDataSource,DSectionIndexViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showSelectedCountLable;
@property (weak, nonatomic) IBOutlet UIButton *addSynModelButton;
@property (strong, nonatomic)  Searchbar *searchBar;
@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母
@property (nonatomic, strong) NSMutableDictionary *sameFirstContactsDic;//便于模型转换
@property (retain, nonatomic) DSectionIndexView *sectionIndexView;
@property (assign, nonatomic) BOOL                         isMoveRightButton;//根据是否显示索引右移按钮
@property (assign, nonatomic) BOOL iSExistPro;

@property (weak, nonatomic) IBOutlet UIView *contentTopView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopViewH;

@end

@implementation JGJSynBillingManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self commonSet];
    [self loadNetData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(synHelpCenter)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.contentTopView addGestureRecognizer:tap];
    
     self.contentTopView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.centerShowLetter.hidden = YES;
    
//    UIView *cusTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 64)];
//    [self.view addSubview:cusTopView];
//    UIImageView *custopImageView = [UIImageView new];
//    custopImageView.frame = cusTopView.bounds;
//    custopImageView.image = [UIImage imageNamed:@"nav_image_icon"];
//    [cusTopView addSubview:custopImageView];
    
    [self.tableView headerBegainRefreshing];
    [self.sectionIndexView reloadItemViews];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    if (self.skipToNextVc) {
        self.skipToNextVc(self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if ([self.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContacts[section];
        count = sortFindResult.findResult.count;
    }
    
    if ([self.sortContacts[section] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *addressBooks = self.sortContacts[section];
        count = addressBooks.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSynBillingManageCell *cell = [JGJSynBillingManageCell cellWithTableView:tableView];
//    共用模型区分同步账单管理
    cell.synBillingCommonModel = self.synBillingCommonModel;
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *synBillingModel = sortFindResult.findResult[indexPath.row];
    synBillingModel.isMoveRightButton = self.isMoveRightButton;
    cell.synBillingModel = synBillingModel;
    cell.lineViewH.constant = (sortFindResult.findResult.count -1 - indexPath.row) == 0 ? 0 :  LinViewH;
    __weak typeof(self) weakSelf = self;
    __weak JGJSynBillingManageCell *weakCell = cell;
    cell.synBillingModelBlock = ^(JGJSynBillingModel *synBillingModel) {
        if (synBillingModel.isSelected) {
            [weakSelf.selectedSynBillingModels addObject:synBillingModel];
//            //            处理已选中区域外的选中状态
            [ weakSelf didClickedCurrentCellMoveTop:weakCell indexPath:indexPath tableView:tableView];
        }
        else {
            [weakSelf.selectedSynBillingModels removeObject:synBillingModel];
//            处理已选中区域中的取消状态
            if (indexPath.section == 0 && [sortFindResult.firstLetter isEqualToString:@"已选中"]) {
                //    刷新数据之后判断是否选中的数据
                weakSelf.dataSource = weakSelf.backupsDataSource.mutableCopy;
                //    刷新数据之后判断是否选中的数据
                [weakSelf refreshSelelctedDataSource:self.dataSource];
                if ([weakSelf.dataSource containsObject:synBillingModel]) {
                    
                    JGJSynBillingModel *synBilling = weakSelf.dataSource[[weakSelf.dataSource indexOfObject:synBillingModel]];
                    synBilling.isSelected = NO;//当前的数据取消
                } else {
                    [weakSelf.dataSource addObject:synBillingModel];
                }
                //    根据数据排序
                [weakSelf searchSynBillingModel:self.dataSource];
                if (weakSelf.selectedSynBillingModels.count > 0) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                }
            }
        }
        [weakSelf showSynBillingSelectedCount:weakSelf.selectedSynBillingModels];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    JGJSynBillingModel *synBillingModel = sortFindResult.findResult[indexPath.row];
    if (!self.synBillingCommonModel.isWageBillingSyn) {
        JGJSyncProlistVC *syncProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSyncProlistVC"];
        syncProlistVC.synBillingModel = synBillingModel;
        [self.navigationController pushViewController:syncProlistVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if ([self.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContacts[section];
        firstLetterLable.text = sortFindResult.firstLetter.uppercaseString;
    }
    
    if ([self.sortContacts[section] isKindOfClass:[NSMutableArray class]]) {
         firstLetterLable.text = @"已选中";
    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        self.sectionIndexView.hidden = YES;
        return;
    }
    if (tableView.visibleCells.count > 0) {
        JGJSynBillingManageCell *cell = tableView.visibleCells[0];
        self.centerShowLetter.text = cell.synBillingModel.firstLetteter.uppercaseString;
        if ([cell.synBillingModel.firstLetteter isEqualToString:@"已选中"]) {
            self.centerShowLetter.hidden = YES; //如果中心字母当是"已选中"不显示
        } else {
            self.centerShowLetter.hidden = NO;
            self.sectionIndexView.hidden = NO;
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        self.sectionIndexView.hidden = YES;
        return;
    }
    self.centerShowLetter.hidden = NO;
    self.sectionIndexView.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.centerShowLetter.hidden = !decelerate;
}

/** 搜索框的文字发生改变的时候调用 */
- (void)textFieldDidChange:(UITextField *)textField {

    NSString *lowerSearchText = textField.text.lowercaseString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains %@ or telephone contains %@", lowerSearchText, lowerSearchText];
    self.dataSource = [self.backupsDataSource  filteredArrayUsingPredicate:predicate].mutableCopy;
    [self.tableView reloadData];
    if (textField.text.length > 0 && textField.text != nil) {
            [self getContactsFirstletter:self.dataSource];
    } else {
        [self getContactsFirstletter:self.backupsDataSource.mutableCopy];
    }
    [self.tableView reloadData];
}

#pragma mark - 全选 按钮按下 只在删除时显示
- (IBAction)allSelelctedButtonPressed:(UIButton *)sender {

}

#pragma mark - 确认 按钮按下
- (IBAction)confirmSynButtonPressed:(UIButton *)sender {
    
    NSMutableString *upLoadProinfoStr = [NSMutableString string];
    for (JGJSynBillingModel *synBillingModel in self.selectedSynBillingModels) {
        [upLoadProinfoStr appendFormat:@"%@,%@,%@;",synBillingModel.target_uid, self.wageMoreDetailInitModel.sync_id,self.wageMoreDetailInitModel.pro_name];
    }
//    删除末尾的分号
    if (upLoadProinfoStr.length > 0 && upLoadProinfoStr != nil) {
        
          [upLoadProinfoStr deleteCharactersInRange:NSMakeRange(upLoadProinfoStr.length - 1, 1)];
    }
    NSString *pid = self.wageMoreDetailInitModel.sync_id;
    NSDictionary *parameters = @{@"pro_info" : upLoadProinfoStr ?: [NSNull null],
                                                         @"pid" : pid ? : [NSNull null]};

    __weak typeof(self) weakSelf = self;
    
    JGJCustomAlertView *customAlertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"仅同步工人的工作时长"];
    customAlertView.message.font = [UIFont systemFontOfSize:AppFont34Size];
    customAlertView.onClickedBlock = ^{
    
        CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
        [alertView showProgressImageView];
        [JLGHttpRequest_AFN PostWithApi:@"jlworksync/syncpro" parameters:parameters success:^(NSArray *responseObject) {
            alertView.onOkBlock = ^{
                [weakSelf backButtonPressed];
            };
            [alertView showSuccessImageView];
            //    每次同步数据之后清楚选中的数据,并且隐藏底部视图
            [self.selectedSynBillingModels removeAllObjects];
            [self showSynBillingSelectedCount:self.selectedSynBillingModels];
            [self.tableView headerBegainRefreshing];
        }failure:^(NSError *error) {
            [alertView removeFromSuperview];
            [TYShowMessage showError:@"同步失败"];
        }];
    };
}

- (void)commonSet {
    self.tableView.backgroundColor = AppFontf1f1f1Color;
     self.tableView.hidden = YES;
    self.confirmSynBtn.backgroundColor = AppFontd7252cColor;
//    [self.confirmSynBtn setTitle:@"确认同步" forState:UIControlStateNormal];
    [self.confirmSynBtn.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    self.showSelectedCountLable.textColor = AppFont666666Color;
    [self.contentSearchBarView addSubview:self.searchBar];
    self.showSelectedCountLable.textColor = AppFont666666Color;
    self.showSelectedCountLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.navigationItem.title = self.synBillingCommonModel.synBillingTitle;
    self.contentView.hidden = YES;
    self.contentViewH.constant = 0;
    self.tableView.sectionIndexColor = AppFont999999Color;   //可以改变字体的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];  //可以改变索引背景色
    [self.view addSubview:self.centerShowLetter];
    self.contentSearchBarViewH.constant = 0;
    self.contentSearchBarView.hidden = YES;
    self.addSynModelButton.hidden = YES;
    self.addSynModelButton.width = 0;

}

- (void)loadNetData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.synBillingCommonModel.isWageBillingSyn) {
        NSString *proId = self.wageMoreDetailInitModel.sync_id;
        [parameters setObject:proId forKey:@"pid"];
        parameters = @{@"pid" : proId ?:[NSNull null],
                       @"pro_name" : self.wageMoreDetailInitModel.pro_name ?:[NSNull null]
                       }.mutableCopy;
    }
    self.tableView.parameters = parameters;
    self.tableView.currentUrl = @"jlworksync/getusersynclist";
    __weak typeof(self) weakSelf = self;
    [self.tableView loadWithViewOfStatus:^UIView *(CFRefreshTableView *tableView, ERefreshTableViewStatus status) {
       __block CFRefreshStatusView *view;
        switch (status) {
                
            case RefreshTableViewStatusNormal: {
              
            }
                break;
            case RefreshTableViewStatusNoResult: {
                if (self.synBillingCommonModel.isWageBillingSyn) { //记工统计进入界面
                    view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips: @"你还没有给任何人同步数据"];
                    view.buttonTitle = @"马上添加同步人";
                } else {
                     [weakSelf handleCurrentContactsIsExistPro];
                }
            }
                break;
                
            case RefreshTableViewStatusNoNetwork: {
                view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"请检查网络链接"];
            }
                break;
                
            case RefreshTableViewStatusLoadError:
                view = [[CFRefreshStatusView alloc] initWithImage:[UIImage imageNamed:@"NoDataDefault_NoManagePro"] withTips:@"出错了，稍后再试试吧~"];
                break;
                
            default:break;
        }
        
        if (!view) {
            view = [CFRefreshStatusView defaultViewWithStatus:status];
        }
        [self jsonWithModel];
        view.textColor = AppFontccccccColor;
        view.delegate = self;
        weakSelf.tableView.hidden = NO;
        weakSelf.contentSearchBarViewH.constant = self.tableView.dataArray.count == 0 ? 0 : 48;
        weakSelf.contentSearchBarView.hidden = self.tableView.dataArray.count == 0;
        return view;
        
    }];
    
}

#pragma mark - 判断当前用户是否有项目 1.0临时添加
- (void)handleCurrentContactsIsExistPro {
    NSString *userUid = [TYUserDefaults objectForKey:JLGUserUid];
    NSDictionary *parameters = @{@"uid" :userUid?:[NSNull null],
                                 @"synced" : @(0)
                                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/prolist" parameters:parameters success:^(id responseObject) {
        NSArray *pros = responseObject;
        BOOL ISExistPro = pros.count > 0;
        self.iSExistPro = ISExistPro;
        NSString *tips = !ISExistPro ? @"你还没有自己的项目" : @"你还没有给任何人同步项目";
        NSString *buttonTitle = ISExistPro ? @"新增同步人" : @"马上创建项目";
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:tips];
        [statusView botttomButtonTilte:@"了解同步项目的功能" buttomImage:@""];
        statusView.frame = self.view.bounds;
        statusView.delegate = self;
        self.tableView.tableHeaderView = statusView;
        statusView.buttonTitle = buttonTitle;
    } failure:^(NSError *error) {
        
    }];
}

- (void)jsonWithModel {

    [self.sortContacts removeAllObjects];
//    [self.tableView headerBegainRefreshing];
    
    self.dataSource = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:self.tableView.dataArray];
    
    self.contentTopViewH.constant = self.dataSource.count == 0 ? 0 : 45;
    
    self.contentTopView.hidden = self.dataSource.count == 0;
    
    if (self.dataSource.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        
        
    }else {
    
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"新增同步人" style:UIBarButtonItemStylePlain target:self action:@selector(addBookMember)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.backupsDataSource = self.dataSource.copy;
    self.backupsOtherDataSource = self.dataSource;
//    刷新数据之后判断是否选中的数据
    [self refreshSelelctedDataSource:self.dataSource];
//    根据数据排序
    [self searchSynBillingModel:self.dataSource];
    self.contentSearchBarView.hidden = self.dataSource.count == 0;
    self.contentSearchBarViewH.constant = self.dataSource.count == 0 ? 0 : 48;
    self.addSynModelButton.hidden = self.dataSource.count == 0;
    self.addSynModelButton.width = self.dataSource.count == 0 ? 0 : 86;
    self.centerShowLetter.hidden = YES;
    
//    [self getContactsFirstletter:self.dataSource];
}

//每次刷新之后和已选择的数据作比较
- (void)refreshSelelctedDataSource:(NSMutableArray *)dataSource {
    for (JGJSynBillingModel *synBillingModel in dataSource) {
        for (JGJSynBillingModel *synSelelctedBillingModel in self.selectedSynBillingModels) {
            if ([synBillingModel.telephone isEqualToString:synSelelctedBillingModel.telephone]) {
                synBillingModel.isSelected = YES;
            }
        }
    }
}
//    根据数据排序
- (void)searchSynBillingModel:(NSMutableArray *)synBillingModels {
    if (self.dataSource.count) {
//        [TYLoadingHub showLoadingWithMessage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getContactsFirstletter:synBillingModels];
            if (self.sortContacts.count > 0) {
                self.tableView.hidden = NO;
//                刷新之后将已选中的防止顶部
                [self didClickedButtonPressedSelectedSynBillingModel:nil];
                [self.tableView reloadData];
            }
//            [TYLoadingHub hideLoadingView];
        });
    }
}

- (void)getContactsFirstletter:(NSMutableArray *)contacts {
    NSMutableArray *sortContacts = [NSMutableArray array];
    NSMutableArray *allContacts = [NSMutableArray arrayWithArray:contacts];
    NSMutableArray *contactsLetters = [NSMutableArray array];
    for (JGJSynBillingModel *result in contacts) {
        result.firstLetteter = [NSString firstCharactor:result.real_name];
         [contactsLetters addObject:result.firstLetteter.uppercaseString];
    }
    //    contactsLetters包含没有重复的字母
    NSSet *set = [NSSet setWithArray:contactsLetters];
    contactsLetters = [set allObjects].mutableCopy;
    contactsLetters = [NSMutableArray arrayWithArray: [contactsLetters sortedArrayUsingSelector:@selector(compare:)]];
    self.contactsLetters = contactsLetters;
    self.isMoveRightButton = self.contactsLetters.count > ShowCount;
    //包含相同首字母的放在一起, 删除已经包含的数据,减少循环次数
    NSMutableDictionary *sameFirstContactsDic = [NSMutableDictionary dictionary];
    self.sameFirstContactsDic = sameFirstContactsDic;
    for (NSString *firstLetter in contactsLetters) {
        NSMutableArray *sameFirstContacts = [NSMutableArray array];
        for (int i = 0; i < allContacts.count; i ++) {
            JGJSynBillingModel *result = allContacts[i];
            if ([result.firstLetteter.uppercaseString isEqualToString: firstLetter.uppercaseString]) {
                [sameFirstContacts addObject:result];
                //                [allContacts removeObject:result];//在这里可以减少循环次数,但是删除了相同数据
            }
        }
//        NSDictionary *contactDic = @{@"firstLetter" : firstLetter,
//                                     @"findResult" : sameFirstContacts};
        NSMutableDictionary *contactDic = [NSMutableDictionary dictionaryWithDictionary:@{@"firstLetter" : firstLetter,
                                                                                          @"findResult" : sameFirstContacts}];
        [sortContacts addObject:contactDic];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    [sortContacts sortUsingDescriptors:sortDescriptors];
    self.sortContacts = [SortFindResultModel mj_objectArrayWithKeyValuesArray:sortContacts];
}

- (Searchbar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [Searchbar searchBar];
        [_searchBar addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _searchBar.backgroundColor = TYColorHex(0Xf3f3f3);
        _searchBar.frame = CGRectMake(12, 7, TYGetUIScreenWidth - 24, 33);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名或手机号码查找";
        [_searchBar setReturnKeyType:UIReturnKeyDone];
    }
    return _searchBar;
}

#pragma mark - 显示底部控件状态
- (void)showSynBillingSelectedCount:(NSMutableArray *)synBillings {
    if (self.groupMemberMangeType == JGJGroupMemberMangeRemoveMemberType) {
        self.showSelectedCountLable.hidden = YES;
        self.allSelectedButton.hidden = NO;
        self.contentView.hidden = NO;
        self.contentViewH.constant = 63;
        return;
    }
    self.selectedSynBillingModels = synBillings;
    NSString *countStr = [NSString stringWithFormat:@"%@", @(synBillings.count)];
    self.showSelectedCountLable.text = [NSString stringWithFormat:@"已选中 %@ 人", countStr];
    [self.showSelectedCountLable markText:countStr withColor:AppFontd7252cColor];
    if (synBillings.count == 0 && self.groupMemberMangeType != JGJGroupMemberMangeRemoveMemberType) {
        self.contentView.hidden = YES;
        self.contentViewH.constant = 0;
    } else {
        self.contentView.hidden = NO;
        self.contentViewH.constant = 63;
        self.allSelectedButton.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (NSMutableArray *)selectedSynBillingModels {

    if (!_selectedSynBillingModels) {
        _selectedSynBillingModels = [NSMutableArray array];
    }
    return _selectedSynBillingModels;
}

- (NSMutableArray *)selectedAddressBooks {

    if (!_selectedAddressBooks) {
        
        _selectedAddressBooks = [NSMutableArray array];
    }
    return _selectedAddressBooks;
}

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = AppFontd7252cColor;
        _centerShowLetter.hidden = YES;
    }
    return _centerShowLetter;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount ) {
        if (!self.sectionIndexView) {
             [self creatTableIndexView];
        }
        BOOL isShow = _contactsLetters.count  > ShowCount? NO:YES; //搜索时隐藏所以
        self.sectionIndexView.hidden = isShow;
        [self.sectionIndexView reloadItemViews];
    }else {
        
        self.sectionIndexView.hidden = YES;
        
    }
}

#pragma Mark - 创建右边索引
- (void)creatTableIndexView {

    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(TYGetUIScreenWidth - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    if (self.sectionIndexView) {
        [self.sectionIndexView removeFromSuperview];
        [self.view addSubview:self.sectionIndexView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    JGJSynAddressBookVC *synAddressBookVC = segue.destinationViewController;
//    首次传入同步账单联系人
    synAddressBookVC.synBillingModels = self.backupsDataSource.mutableCopy;//已选中区域外的传过去
    synAddressBookVC.selelctedModels = self.selectedSynBillingModels;//将已选中区域也传过去
    synAddressBookVC.synBillingCommonModel = self.synBillingCommonModel;
    __weak typeof(self) weakSelf = self;
    synAddressBookVC.addSynModelBlock = ^(JGJSynBillingModel *addressBookModel){
        weakSelf.isScroTop = YES;//添加过来的自动滚动到顶部
        [weakSelf didClickedButtonPressedSelectedSynBillingModel:addressBookModel];
    };
//
}

- (void)addBookMember {

    JGJSynAddressBookVC *synAddressBookVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynAddressBookVC"];
    //    首次传入同步账单联系人
    synAddressBookVC.synBillingModels = self.backupsDataSource.mutableCopy;//已选中区域外的传过去
    synAddressBookVC.selelctedModels = self.selectedSynBillingModels;//将已选中区域也传过去
    synAddressBookVC.synBillingCommonModel = self.synBillingCommonModel;
    __weak typeof(self) weakSelf = self;
    synAddressBookVC.addSynModelBlock = ^(JGJSynBillingModel *addressBookModel){
        weakSelf.isScroTop = YES;//添加过来的自动滚动到顶部
        [weakSelf didClickedButtonPressedSelectedSynBillingModel:addressBookModel];
    };
    
    [self.navigationController pushViewController:synAddressBookVC animated:YES];
}

#pragma Mark -  选中之后从通信录页面跳转至顶部已选中
- (void)didClickedButtonPressedSelectedSynBillingModel:(JGJSynBillingModel *)addressBookModel {

    //        删除之前的已选择中区,防止出现多个已选中区
    SortFindResultModel *sortFindResultFirstModel = [self.sortContacts firstObject];
    if ([sortFindResultFirstModel.firstLetter isEqualToString:@"已选中"]) {
        [self.sortContacts removeObject:sortFindResultFirstModel];
    }
    addressBookModel.firstLetteter = @"已选中";
    addressBookModel.isSelected = YES;
    addressBookModel.real_name = addressBookModel.name;
    addressBookModel.telephone = addressBookModel.telph;
    //        保存所有选中的状态当前页面和通信录
    if (addressBookModel != nil) {
          [self.selectedSynBillingModels addObject:addressBookModel];
    }
    //        将当前页面已选中的数据移除
    for (JGJSynBillingModel *synSelelctedBillingModel in self.selectedSynBillingModels) {
        for (int i = 0; i < self.dataSource.count; i ++) {
            JGJSynBillingModel *synBillingModel = self.dataSource[i];
            if ([synSelelctedBillingModel.telephone isEqualToString:synBillingModel.telephone]) {
                [self.dataSource removeObject:synSelelctedBillingModel];
            }
        }
    }
    //      重新排序
    [self getContactsFirstletter:self.dataSource];
    NSDictionary *contactDic = @{@"firstLetter" : @"已选中",
                                 @"findResult" : self.selectedSynBillingModels
                                 };
    SortFindResultModel *sortFindResultModel = [SortFindResultModel mj_objectWithKeyValues:contactDic];
    //        通信录返回的数据插入顶部已选中区域
    if (sortFindResultModel.findResult.count > 0) {
        [self.sortContacts insertObject:sortFindResultModel  atIndex:0];
    }
    if ( self.sortContacts.count) {
        if (self.isScroTop) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self.tableView reloadData];
    }
    //        显示底部按钮
    [self showSynBillingSelectedCount:sortFindResultModel.findResult.mutableCopy];
}

#pragma Mark - 判断已选中区域之外选中当前cell位移效果

- (void)didClickedCurrentCellMoveTop:(JGJSynBillingManageCell *)cell indexPath:(NSIndexPath *)indexPath  tableView:(UITableView *)tableView {

    //    调用最初的数据源
    self.dataSource = self.backupsDataSource.mutableCopy;
    //    刷新数据之后判断是否选中的数据
    [self refreshSelelctedDataSource:self.dataSource];
    //    根据数据排序
    [self searchSynBillingModel:self.dataSource];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//    CGRect rect = [tableView convertRect:rectInTableView toView:tableView.superview];
//    CGRect tabRect = CGRectMake(rect.origin.x, rect.origin.y + 65, rect.size.width, rect.size.height - LinViewH);
//    UIImage *image = [UIImage viewSnapshot:[[UIApplication sharedApplication] keyWindow] withInRect:tabRect];
//    UIImageView *currentCell = [[UIImageView alloc] initWithImage:image];
//    currentCell.backgroundColor = [UIColor orangeColor];
//    currentCell.frame = rect;
//    [self.view addSubview:currentCell];
//    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        currentCell.transform = CGAffineTransformMakeTranslation(0, -75);
//        currentCell.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        [currentCell removeFromSuperview];
//    }];
}

#pragma mark - CFRefreshStatusViewDelegate

- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
    NSUInteger synContactCount = self.dataSource.count;
    NSString *storyboardName = nil;
    NSString *vcIdentifier = nil;
//    记工统计进入添加联系人 ,首页进入需要判断有不有联系人和项目
    if (self.synBillingCommonModel.isWageBillingSyn) {
        JGJSynAddressBookVC *synAddressBookVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynAddressBookVC"];;
        //    首次传入同步账单联系人
        synAddressBookVC.synBillingModels = self.backupsDataSource.mutableCopy;//已选中区域外的传过去
        synAddressBookVC.selelctedModels = self.selectedSynBillingModels;//将已选中区域也传过去
        synAddressBookVC.synBillingCommonModel = self.synBillingCommonModel;
        __weak typeof(self) weakSelf = self;
        synAddressBookVC.addSynModelBlock = ^(JGJSynBillingModel *addressBookModel){
            weakSelf.isScroTop = YES;//添加过来的自动滚动到顶部
            [weakSelf didClickedButtonPressedSelectedSynBillingModel:addressBookModel];
        };
        [self.navigationController pushViewController:synAddressBookVC animated:YES];
    } else {
        if (!self.iSExistPro && synContactCount == 0) {
            storyboardName = @"JGJCreatPro";
            vcIdentifier = @"JGJCreatProCompanyVC";
        }else  {
            storyboardName = @"JGJSynBilling";
            vcIdentifier = @"JGJSynAddressBookVC";
        }
        UIViewController *creatProVC = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcIdentifier];
        [self.navigationController pushViewController:creatProVC animated:YES];
    }
}

#pragma mark - 无数据无项目底部警告按钮按下
- (void)handleAlertButtonAction:(CFRefreshStatusView *)statusView {
//    JGJGuideImageVc *guideImageVc = [[JGJGuideImageVc alloc] initWithImageType:GuideImageTypeSysManage];
    
    [self synHelpCenter];
}

#pragma mark - 同步帮中心
- (void)synHelpCenter {

    NSString *url = [NSString stringWithFormat:@"%@help/hpDetail?id=95", JGJWebDiscoverURL];
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.contactsLetters objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = AppFont999999Color;
    itemView.titleLabel.highlightedTextColor = AppFontd7252cColor;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.contactsLetters objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [self.contactsLetters objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    __weak typeof(self) weakSelf  = self;
    self.centerShowLetter.text = self.contactsLetters[section];
    self.centerShowLetter.hidden = NO;
    sectionIndexView.touchCancelBlock = ^(DSectionIndexView *sectionIndexView, BOOL isTouchCancel){
        //        延时的目的是当touch停止的时候还会滚动一小段时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.centerShowLetter.hidden = isTouchCancel;
        });
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContactsLetters:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

@end
