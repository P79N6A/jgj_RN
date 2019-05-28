//
//  JGJTaskPrincipalVc.m
//  mix
//
//  Created by yj on 2017/6/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskPrincipalVc.h"

#import "JGJTaskSelMemberCell.h"

#import "JGJPublishTaskVc.h"

#import "JGJQualityRecordVc.h"

#import "JGJQualityFilterVc.h"

#import "NSString+Extend.h"

#import "JGJQualitySafeCheckFiliterVc.h"

#import "JGJPubQuaSafeCheckVc.h"
#import "JGJTaskViewController.h"
#import "JGJAddressBookTool.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "CFRefreshStatusView.h"
#import "TYTextField.h"
#import "JGJDefultTipsLable.h"
#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

@interface JGJTaskPrincipalVc ()<

UITableViewDelegate,

UITableViewDataSource,

UITextFieldDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息
@property (strong, nonatomic) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母
@property (strong, nonatomic) UILabel *centerShowLetter;

@property (strong, nonatomic) SortFindResultModel *waitTaskResultModel;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property(nonatomic ,strong)  NSMutableArray *backUpdataArr;

@property (nonatomic, copy)   NSString *searchValue;

@property(nonatomic ,strong) JGJAddressBookSortContactsModel *backUpSortContactsModel;

//选中的人员
@property (nonatomic, strong) JGJSynBillingModel *selPrincipalModel;

@property (nonatomic, strong) JGJDefultTipsLable *tips;

@end

@implementation JGJTaskPrincipalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSubView];
    
    if (self.memberSelType == JGJMemberSelPrincipalType || self.memberSelType ==JGJQualityDetailModifyMemeberType || self.memberSelType == JGJMemberFilterRecirdMemeberType || self.memberSelType == JGJRectNotifySelMemberType) {
        
        self.title = @"选择整改负责人";
    }else if (self.memberSelType == JGJMemberUndertakeMemeberType) {
    
        self.title = @"选择负责人";
    }else if (self.memberSelType == JGJMemberSelPerformerType) {
    
        self.title = @"选择执行者";
    }else if (self.memberSelType == JGJMemberCommitMemeberType) {
        
        self.title = @"选择问题提交人";
    }else if (self.memberSelType == JGJMemberCheckExecMemeberType) {
        
        self.title = @"选择检查执行人";
    }else if (self.memberSelType == JGJMemberCheckPlanCommitMemeberType) {
        
        self.title = @"选择检查计划提交人";
    }else if (self.memberSelType == JGJModifyTaskPrincipalType)
    {
        self.title = @"选择任务负责人";

    }else if (self.memberSelType == JGJPubCheckPlanSelMemberType) {
    
         self.title = @"选择检查执行人";
    }else if (self.memberSelType == JGJAgencySelMemberType) {
        
        self.title = @"选择代班长";
    }
    
    
    if (self.principalModels.count > 0) {
        
        if ([_principalModels.firstObject isKindOfClass:[JGJAddressBookSortContactsModel class]]) {
            
            self.sortContactsModel = _principalModels[0];
            
            self.contactsLetters = self.sortContactsModel.contactsLetters;
            
            self.backUpSortContactsModel = self.sortContactsModel;
            
            if (self.lastIndexPath) {
                
                [self.tableView scrollToRowAtIndexPath:self.lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }

        [self.tableView reloadData];
        
    }else {
        
        [self loadGroupMembers];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    count = sortFindResult.findResult.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskSelMemberCell *cell = [JGJTaskSelMemberCell cellWithTableView:tableView];
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    cell.isOffset = _contactsLetters.count  > ShowCount;

    cell.searchValue = self.searchValue;
    
    memberModel.isSelected = [memberModel.uid isEqualToString:self.principalModel.uid];
    
    cell.contactModel = memberModel;
    
    if (memberModel.isSelected) {

        self.lastIndexPath = indexPath;
    }
    
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    memberModel.indexPathMember = indexPath;
    
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = AppFontf1f1f1Color;
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if ([self.sortContactsModel.sortContacts[section] isKindOfClass:[SortFindResultModel class]]) {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
        firstLetterLable.text = firstLetter ;
    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *principalModel = sortFindResult.findResult[indexPath.row];
    
    if ([principalModel.is_active isEqualToString:@"0"]) {
        
        [TYShowMessage showPlaint:@"该用户还未注册，不能选择"];
        
        return;
    }
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if(temp && temp != indexPath) {
        
        TYLog(@"------%@ ------%@", @(self.lastIndexPath.row), sortFindResult.findResult);
        
//        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[self.lastIndexPath.section];
//
//        JGJSynBillingModel *lastmemberModel = sortFindResult.findResult[self.lastIndexPath.row];
//
//        lastmemberModel.isSelected = NO;//修改之前选中的cell的数据为不选中
//
//        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    //选中的修改为当前行
    
    self.lastIndexPath = indexPath;
    
    principalModel.isSelected = YES;
    
    //选中的 人员
    self.principalModel = principalModel;
    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [tableView reloadData];
    
    if (self.memberSelType == JGJMemberSelPerformerType || self.memberSelType == JGJMemberUndertakeMemeberType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJPublishTaskVc class]]) {
                
                JGJPublishTaskVc *publishTaskVc = (JGJPublishTaskVc *)vc;
                
                publishTaskVc.principalModels = self.cacheSortContactsModels;
                
                publishTaskVc.principalModel = principalModel;
                
                publishTaskVc.lastIndexPath = self.lastIndexPath;
                
                [publishTaskVc freshIndexSection:1 row:0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.memberSelType == JGJMemberSelPrincipalType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityRecordVc class]]) {
                
                JGJQualityRecordVc *qualityRecordVc = (JGJQualityRecordVc *)vc;
                
                JGJCreatTeamModel *selPrincipalModel = qualityRecordVc.prinTimeInfos[2];
                
                selPrincipalModel.detailTitle = principalModel.real_name;
                
                selPrincipalModel.detailTitlePid = principalModel.uid;
                
                qualityRecordVc.principalModels = self.cacheSortContactsModels;
                
                qualityRecordVc.lastIndexPath = self.lastIndexPath;
                
                [qualityRecordVc freshIndexSection:3 row:2];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.memberSelType == JGJMemberCommitMemeberType || self.memberSelType == JGJMemberFilterRecirdMemeberType) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualityFilterVc class]]) {
                
                JGJQualityFilterVc *qualityRecordVc = (JGJQualityFilterVc *)vc;
                
                JGJCreatTeamModel *selPrincipalModel = qualityRecordVc.fourSectionInfos[1];
                
                NSInteger row = 1;
                
                if (self.memberSelType == JGJMemberCommitMemeberType) {
                    
                    row = 2;
                    
                    selPrincipalModel = qualityRecordVc.fourSectionInfos[2];
                    
                    qualityRecordVc.commitModels = self.cacheSortContactsModels;
                }
                
                selPrincipalModel.detailTitle = principalModel.real_name;
                
                selPrincipalModel.detailTitlePid = principalModel.uid;

                if (self.memberSelType == JGJMemberFilterRecirdMemeberType) {
                    
                    qualityRecordVc.principalModels = self.cacheSortContactsModels;
                }
                
                qualityRecordVc.lastIndexPath = self.lastIndexPath;
                
                [qualityRecordVc freshIndexSection:3 row:row];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
            }
        }
        
    }else if (self.memberSelType == JGJMemberCheckExecMemeberType || self.memberSelType == JGJMemberCheckPlanCommitMemeberType) {
    
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJQualitySafeCheckFiliterVc class]]) {
                
                JGJQualitySafeCheckFiliterVc *qualityRecordVc = (JGJQualitySafeCheckFiliterVc *)vc;
                
                JGJCreatTeamModel *selPrincipalModel = qualityRecordVc.thirdSectionInfos[0];
                
                NSInteger row = 0;
                
                if (self.memberSelType == JGJMemberCheckPlanCommitMemeberType) {
                    
                    row = 1;
                    
                    selPrincipalModel = qualityRecordVc.thirdSectionInfos[1];
                }
                
                selPrincipalModel.detailTitle = principalModel.real_name;
                
                selPrincipalModel.detailTitlePid = principalModel.uid;
                
                qualityRecordVc.principalModels = self.cacheSortContactsModels;
                
                qualityRecordVc.lastIndexPath = self.lastIndexPath;
                
                [qualityRecordVc freshIndexSection:2 row:row];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
                
            }else if ([vc isKindOfClass:[JGJPubQuaSafeCheckVc class]]){ //发布检查计划
                
                if ([self.delegate respondsToSelector:@selector(taskPrincipalVc:didSelelctedMemberModel:)]) {
                    
                    [self.delegate taskPrincipalVc:self didSelelctedMemberModel:principalModel];
                }
                
            }
        }
    
    }
//    else if ([self.delegate respondsToSelector:@selector(taskPrincipalVc:didSelelctedMemberModel:)]) {
//
//        [self.delegate taskPrincipalVc:self didSelelctedMemberModel:principalModel];
//
//    }
    else if (self.memberSelType == JGJModifyTaskPrincipalType) {//修改负责人
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[JGJTaskViewController class]]) {
                
                JGJTaskViewController *taskVC = (JGJTaskViewController *)vc;
                NSMutableArray *uidArr = [NSMutableArray array];
                [uidArr addObject:principalModel.uid?:@""];
                [taskVC upEditeTaskPersonAndUID:uidArr isPrincipal:YES];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    if ([self.delegate respondsToSelector:@selector(taskPrincipalVc:didSelelctedMemberModel:)]) {
        
        [self.delegate taskPrincipalVc:self didSelelctedMemberModel:principalModel];
   }
}

- (void)initialSubView {
    
    [self.view addSubview:self.searchbar];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(self.view);
        
        make.top.mas_equalTo(self.searchbar.mas_bottom);
    }];
    
}

- (void)loadGroupMembers {
    
    NSDictionary *parameters = @{
                                 @"class_type" : self.proListModel.class_type?:@"",
                                 @"group_id" : self.proListModel.group_id?:@""
                                 };

    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/get-members-list" parameters:parameters success:^(id responseObject) {

        self.principalModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];

        [self getInitialPrincipalModel];
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 选中首次的项目负责人
- (void)getInitialPrincipalModel {

    //首次质量详情页选中修改人员
    if (![NSString isEmpty:self.principalModel.uid] && (self.memberSelType == JGJQualityDetailModifyMemeberType || self.memberSelType == JGJPubCheckPlanSelMemberType || self.memberSelType == JGJModifyTaskPrincipalType)) {
        
        if (![NSString isEmpty:self.principalModel.uid]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid=%@",self.principalModel.uid];
            
            NSArray *filterMembers = [_principalModels filteredArrayUsingPredicate:predicate];
            
            if (filterMembers.count > 0) {
                
                JGJSynBillingModel *memberModel = filterMembers.firstObject;
                
                memberModel.isSelected = YES;
                
                self.lastIndexPath = memberModel.indexPathMember;
            }
            
        }
        
    }

}

- (void)setPrincipalModels:(NSArray *)principalModels {
    
    _principalModels = principalModels;
    
    //代理人的话去掉创建者
    if (self.memberSelType == JGJAgencySelMemberType) {
        
        NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid!=%@",uid];
        
        if (_principalModels.count > 0 && [_principalModels.firstObject isKindOfClass:[JGJSynBillingModel class]]) {
            
            _principalModels = [_principalModels filteredArrayUsingPredicate:predicate];
            
        }
        
    }
    
    JGJSynBillingModel *addModel = nil;
    
    if (self.sortContactsModel.sortContacts.count > 0) {
        
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[0];

        if (sortFindResult.findResult.count > 0) {
            
            addModel = sortFindResult.findResult[0];
        }
        
    }
    
    if ([_principalModels.firstObject isKindOfClass:[JGJAddressBookSortContactsModel class]]) {
        
        if (_principalModels.count > 0) {
            
            self.sortContactsModel = _principalModels[0];
            
            self.contactsLetters = self.sortContactsModel.contactsLetters;
        }
        
    }else {
    
        self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_principalModels];
        
        self.contactsLetters = self.sortContactsModel.contactsLetters;
        
    }
    
    if (self.memberSelType == JGJMemberUndertakeMemeberType && !addModel.isAddModel) {
        
        NSMutableArray *sortContacts = self.sortContactsModel.sortContacts.mutableCopy;

        self.sortContactsModel.sortContacts = sortContacts;
    }
    
    self.cacheSortContactsModels = @[self.sortContactsModel];
    
    //备份搜索的值
    if (!self.backUpSortContactsModel && self.sortContactsModel.sortContacts.count > 0) {
        
        self.backUpSortContactsModel = self.sortContactsModel;
        
    }
    
    self.backUpdataArr = self.principalModels.mutableCopy;
    
    [TYLoadingHub hideLoadingView];
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

#pragma mark - 创建右边索引

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        JGJTaskSelMemberCell *cell = tableView.visibleCells[0];
        self.centerShowLetter.text = cell.contactModel.firstLetteter.uppercaseString;
        self.centerShowLetter.hidden = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    self.centerShowLetter.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.centerShowLetter.hidden = !decelerate;
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount) {
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
    [self.view addSubview:self.sectionIndexView];
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setContactsLetters:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

- (JGJCustomSearchBar *)searchbar {
    
    if (!_searchbar) {
        
        _searchbar = [JGJCustomSearchBar new];
        
        _searchbar.searchBarTF.placeholder = @"请输入成员名字进行搜索";
        
        _searchbar.searchBarTF.delegate = self;
        
//        _searchbar.hidden = YES;
        
        _searchbar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
        
        _searchbar.searchBarTF.returnKeyType = UIReturnKeyDone;
        
        _searchbar.searchBarTF.maxLength = 20;
        
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

- (void)searchWithValue:(NSString *)value {
    
    [self.tableView reloadData];
    
    NSMutableArray *dataSource = [NSMutableArray new];
    
    self.searchValue = value;
    
    if ([NSString isEmpty:value]) {
        
        self.searchbar.searchBarTF.text = nil;
    }
    
    NSString *lowerSearchText = value.lowercaseString;
    
    for (SortFindResultModel *sortContactModel in self.backUpSortContactsModel.sortContacts) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", lowerSearchText];
        
        NSMutableArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate].mutableCopy;
        
        [dataSource addObjectsFromArray:contacts];
        
    }
    
    if (![NSString isEmpty:value]) {
        
        JGJAddressBookSortContactsModel *sortContactsModel = [JGJAddressBookTool  addressBookToolSortContcts:dataSource];
        
        self.sortContactsModel = sortContactsModel;
        
        if (dataSource.count == 0) {
            
            [self.view addSubview:self.tips];
            
        }else {
            
            if ([self.view.subviews containsObject:self.tips]) {
                
                [self.tips removeFromSuperview];
            }
        }
        
    } else {
        
        [self.view endEditing:YES];
        
        self.sortContactsModel = self.backUpSortContactsModel;
        
        if ([self.view.subviews containsObject:self.tips]) {
            
            [self.tips removeFromSuperview];
        }
    }
    
    [self.tableView reloadData];
}

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
}

- (JGJDefultTipsLable *)tips {
    
    if (!_tips) {
        
        _tips = [[JGJDefultTipsLable alloc] initWithOffsetY:0 tips:@"未找到对应成员"];
        
    }
    
    return _tips;
}

@end
