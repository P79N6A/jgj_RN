//
//  JGJTaskTracerVc.m
//  mix
//
//  Created by yj on 2017/6/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskTracerVc.h"

#import "JGJContactedAddressBookCell.h"

#import "UILabel+GNUtil.h"

#import "JGJPublishTaskVc.h"

#import "JGJTaskTracerCell.h"

#import "JGJTaskViewController.h"

#import "JGJAddressBookTool.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
#import "CFRefreshStatusView.h"

#import "TYTextField.h"

#import "JGJDefultTipsLable.h"

#import "JGJImageModelView.h"

#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75

@interface JGJTaskTracerVc () <

    JGJGroupChatSelelctedMemberHeadViewDelegate,

    DSectionIndexViewDelegate,

    DSectionIndexViewDataSource,

    UITextFieldDelegate,

    ClickPeopleItemButtondelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *selTracerLable;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSMutableArray *selectedMembers; //选中的追踪成员

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息
@property (strong, nonatomic) DSectionIndexView *sectionIndexView;
@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母
@property (strong, nonatomic) UILabel *centerShowLetter;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property (nonatomic, copy)   NSString *searchValue;

@property(nonatomic ,strong) JGJAddressBookSortContactsModel *backUpSortContactsModel;

@property(nonatomic ,strong)  NSMutableArray *backUpdataArr;

@property (nonatomic, strong) JGJDefultTipsLable *tips;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSelectedMemberViewH;

@property (weak, nonatomic) IBOutlet UIView *contentSelectedMemberView;

//用的以前的控件
@property (strong, nonatomic) JGJImageModelView *imageModelView;

//YES不排除当前未注册人员
@property (assign, nonatomic) BOOL is_sel_all;

@end

@implementation JGJTaskTracerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchbar];
    
    NSString *title = @"选择参与者";
    
    switch (self.taskTracerType) {
            
        case JGJTaskJoinTracerType:{
            
            self.is_sel_all = YES;
        }
            break;
            
        case JGJTaskExecutorTracerType:{
            
            title = @"选择执行人";
            
            self.is_sel_all = YES;
        }
            break;
            
        case JGJLogExecutorTracerType:
            
        case JGJNoticeExecutorTracerType:{

            title = @"选择接收人";
            
            self.is_sel_all = YES;
        }

            break;
            
        default:
            break;
    }
    
    self.title = title;
    
    [self.confirmButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.selTracerLable.text = @"本次已选中0人";
    
    self.selTracerLable.textColor = AppFont666666Color;
    
    [self.selTracerLable markText:@"0" withColor:AppFontd7252cColor];
    
    JGJGroupChatSelelctedMemberHeadView *headerView = [[JGJGroupChatSelelctedMemberHeadView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    
    self.headerView = headerView;
    
    headerView.groupListModel = self.proListModel;
    
    headerView.delegate = self;
    
    if (self.taskTracerModels.count > 0) {
        
        [self.selectedMembers removeAllObjects];
        
        [self showBottomInfo];
        
        self.bottomViewH.constant = 63;
        
        self.tableView.tableHeaderView = self.headerView;
        
//        self.headerView.selectedButton.selected = self.selectedButtonStatus;
    }else {

        [self loadGroupMembers];
    }
    
    [self.confirmButton setBackgroundColor:AppFontEB4E4EColor];
//    [self setNavigationLeftButtonItem];
    
    [self.contentSelectedMemberView addSubview:self.imageModelView];
    
    if (self.existedMembers.count > 0) {
        
        self.selectedMembers = self.existedMembers.mutableCopy;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self setNavigationLeftButtonItem];
}

- (void)setNavigationLeftButtonItem {
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);

    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backBtnClick:(UIButton *)sender {

    [self freshPublshTaskTracer];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortContactsModel.sortContacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    
    contactModel.is_creater = @"0";
    
    contactModel.is_admin = NO;
    
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    
    count = sortFindResult.findResult.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJTaskTracerCell *cell = [JGJTaskTracerCell cellWithTableView:tableView];

    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    
    cell.isOffset = _contactsLetters.count  > ShowCount;
    
    cell.searchValue = self.searchValue;
    
    contactModel.is_creater = @"0";
    
    contactModel.is_admin = NO;
    
    contactModel.is_agency = NO;
    
    cell.contactModel = contactModel;
    
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    
    return cell;

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
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    //通知未注册的人员也要选择
    if ([memberModel.is_active isEqualToString:@"0"] && !self.is_sel_all) {
        
        [TYShowMessage showPlaint:@"该用户还未注册，不能选择"];
        
        return;
    }
    
    memberModel.isSelected = !memberModel.isSelected;
    
    if (memberModel.isSelected) {
        
        [self.selectedMembers addObject:memberModel];
        
    }else {
    
        [self.selectedMembers removeObject:memberModel];
    }
    
    [self showBottomInfo];
    
}

#pragma mark - JGJGroupChatSelelctedMemberHeadViewDelegate
- (void)JGJGroupChatSelelctedMemberHeadView:(JGJGroupChatSelelctedMemberHeadView *)headerView groupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    
    if (headerView.selectedButton.selected) {
        
        [self.selectedMembers removeAllObjects];
        
        NSMutableArray *allSelMembers = [NSMutableArray new];
        
        for (JGJSynBillingModel *memberModel in self.taskTracerModels) {
            
            //通知未注册的人员也能选择
            if ([memberModel.is_active isEqualToString:@"1"] || self.is_sel_all) {
                
                memberModel.isSelected = YES;
                
                [allSelMembers addObject:memberModel];
                
            }else {
                
                memberModel.isSelected = NO;
            }
            
        }
        
        [self.selectedMembers addObjectsFromArray:allSelMembers];
        
    }else {
        
        for (JGJSynBillingModel *memberModel in self.taskTracerModels) {
            
            memberModel.isSelected = NO;
        }
        
        [self.selectedMembers removeAllObjects];
    }

    [self showBottomInfo];

}

- (IBAction)handleConfirmButtonPressed:(UIButton *)sender {
    
#pragma mark - 刘远强修改 修改任务负责人
    if (_taskEditeStatus) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[JGJTaskViewController class]]) {
                
                NSMutableArray *uidArr = @[@""].mutableCopy;
                for (int index = 0; index <self.taskTracerModels.count; index ++) {
                    
                    JGJSynBillingModel *model = (JGJSynBillingModel *)self.taskTracerModels[index];
                    
                    if (model.isSelected) {
                        
                        [uidArr addObject:model.uid];
                    }
                }
                JGJTaskViewController *taskVC = (JGJTaskViewController *)vc;
                [taskVC upEditeTaskPersonAndUID:uidArr isPrincipal:NO];
                
                
            }
        }
    }else{
        [self freshPublshTaskTracer];

    
    }
    
    // 用于判断是否全选联系人
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == %@", @(YES)];
    
    NSArray *selectedMembers = [self.taskTracerModels filteredArrayUsingPredicate:predicate];
    
//    NSPredicate *unAvctivePredicate = [NSPredicate predicateWithFormat:@"is_active == %@", @"0"];
//    
//    NSArray *unAvctiveMembers = [self.taskTracerModels filteredArrayUsingPredicate:unAvctivePredicate];
    
    BOOL isSelectedAllMembers = selectedMembers.count == self.taskTracerModels.count;
    
    if ([self.delegate respondsToSelector:@selector(taskTracerVc:didSelelctedMembers:isSelectedAllMembers:)]) {
        
        [self.delegate taskTracerVc:self didSelelctedMembers:[self selMembers] isSelectedAllMembers:isSelectedAllMembers];
    }
    if ([self.delegate respondsToSelector:@selector(taskTracerVc:didSelelctedMembers:)]) {
        
        [self.delegate taskTracerVc:self didSelelctedMembers:[self selMembers]];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)selMembers {
    
    NSMutableArray *selectedMembers = [NSMutableArray new];
    
    for (JGJSynBillingModel *memberModel in self.taskTracerModels) {
        
        if (memberModel.isSelected) {
            
            [selectedMembers addObject:memberModel];
        }
        
    }
    
    return selectedMembers;
}

- (void)freshPublshTaskTracer {

    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJPublishTaskVc class]]) {
            
            JGJPublishTaskVc *publishTaskVc = (JGJPublishTaskVc *)vc;
            
            NSMutableArray *selectedMembers = [NSMutableArray new];
            
            for (JGJSynBillingModel *memberModel in self.taskTracerModels) {
                
                if (memberModel.isSelected) {
                    
                    [selectedMembers addObject:memberModel];
                }
                
            }
            
            JGJSynBillingModel *addModel = [JGJSynBillingModel new];
            
            addModel.real_name = @"添加";
            
            addModel.isAddModel = YES;
            
            addModel.head_pic = @"add_ principal_icon";
            
            [selectedMembers addObject:addModel];
            
            publishTaskVc.selectedButtonStatus = self.headerView.selectedButton.selected ;
            
            publishTaskVc.allTaskTracerModels = self.taskTracerModels;
            
            publishTaskVc.taskTracerModels = selectedMembers;
            
            [publishTaskVc freshIndexSection:2 row:0];
            
            break;
        }
        
    }

}

- (void)loadGroupMembers {

    NSDictionary *parameters = @{
                                 
                                 @"class_type" : self.proListModel.class_type?:@"",
                                 
                                 @"group_id" : self.proListModel.group_id?:@""
                                 
                                };

    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        weakSelf.taskTracerModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
        
         [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 显示底部描述
- (void)showBottomInfo {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == %@", @(YES)];
    
    NSArray *selectedMembers = [self.taskTracerModels filteredArrayUsingPredicate:predicate];
    
    NSArray *unAvctiveMembers = @[];
    
    //通知是全选，其余类型不能选择未注册人员
    if (!self.is_sel_all) {
        
        NSPredicate *unAvctivePredicate = [NSPredicate predicateWithFormat:@"is_active == %@", @"0"];
        
        unAvctiveMembers = [self.taskTracerModels filteredArrayUsingPredicate:unAvctivePredicate];
    }
        
    self.headerView.selectedButton.selected = selectedMembers.count == self.taskTracerModels.count - unAvctiveMembers.count;
    
    if (self.existedMembers.count > 0 || self.selectedMembers.count > 0) {

        //人数全选标记已选中
        self.headerView.selectedButton.selected = selectedMembers.count == self.taskTracerModels.count - unAvctiveMembers.count;
    }
    
    NSString *memberCountStr = [NSString stringWithFormat:@"%@", @(selectedMembers.count)];
    
    self.selTracerLable.text = [NSString stringWithFormat:@"本次已选中%@人", memberCountStr];
    
    [self.selTracerLable markText:memberCountStr withColor:AppFontd7252cColor];
    
    [self.tableView reloadData];
}

- (void)setTaskTracerModels:(NSMutableArray *)taskTracerModels {

    _taskTracerModels = taskTracerModels;
    
    self.bottomViewH.constant = _taskTracerModels.count == 0 ? 0 : 63;
    
    if (_taskTracerModels.count > 0) {
        
        self.tableView.tableHeaderView = self.headerView;
        
    }
    
    //排序
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_taskTracerModels];
    
    self.contactsLetters = self.sortContactsModel.contactsLetters;
    
    //备份搜索的值
    if (!self.backUpSortContactsModel && self.sortContactsModel.sortContacts.count > 0) {
        
        self.backUpSortContactsModel = self.sortContactsModel;
        
    }
    
    //备份数据
     self.backUpdataArr = _taskTracerModels.mutableCopy;
    
    [self compareExistJoinMember];
    
    [self.tableView reloadData];

}
#pragma mark - 任务详情存在的参与者 2.3.2任务参与者
- (void)compareExistJoinMember {
    
    //循环外面的数据标选中
    
    if (self.taskTracerType == JGJTaskJoinTracerType) {
        
        for (JGJSynBillingModel *joinMemberModel in self.joinMembers) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid=%@", joinMemberModel.uid];
            
            NSArray *existJoinModels = [_taskTracerModels filteredArrayUsingPredicate:predicate];
            
            if (existJoinModels.count > 0) {
                
                JGJSynBillingModel *existJoinModel = existJoinModels.firstObject;
                
                existJoinModel.isSelected = YES;
            }
            
        }
        
    }else {
        
        for (JGJSynBillingModel *joinMemberModel in self.existedMembers) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid=%@", joinMemberModel.uid];
            
            NSArray *existJoinModels = [_taskTracerModels filteredArrayUsingPredicate:predicate];
            
            if (existJoinModels.count > 0) {
                
                JGJSynBillingModel *existJoinModel = existJoinModels.firstObject;
                
                existJoinModel.isSelected = YES;
            }
            
        }
        
    }
    
    [self showBottomInfo];
    

}

- (NSMutableArray *)selectedMembers {

    if (!_selectedMembers) {
        
        _selectedMembers = [NSMutableArray new];
    }
    
    return _selectedMembers;
}

#pragma mark - 创建右边索引

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0 && tableView.visibleCells.count > 0) {
        JGJTaskTracerCell *cell = tableView.visibleCells[0];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
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

- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    
    _sortContactsModel = sortContactsModel;
    
    self.contactsLetters = sortContactsModel.contactsLetters;
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
    
    [self searchWithValue:nil];
    
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
        
        self.headerView.frame = CGRectZero;
        
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
        
        self.headerView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 50);
        
        if ([self.view.subviews containsObject:self.tips]) {
            
            [self.tips removeFromSuperview];
        }
        
    }
    
    self.headerView.hidden = ![NSString isEmpty:value];
    
    [self.tableView reloadData];
}

- (JGJDefultTipsLable *)tips {
    
    if (!_tips) {
        
        _tips = [[JGJDefultTipsLable alloc] initWithOffsetY:0 tips:@"未找到对应成员"];
        
    }
    
    return _tips;
}

@end
