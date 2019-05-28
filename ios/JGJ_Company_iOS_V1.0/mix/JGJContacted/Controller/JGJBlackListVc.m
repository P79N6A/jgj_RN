//
//  JGJBlackListVc.m
//  mix
//
//  Created by YJ on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBlackListVc.h"
#import "JGJBlackListCell.h"
#import "JGJAddressBookTool.h"
#import "JGJPerInfoVc.h"
#import "CFRefreshStatusView.h"

#import "JGJRefreshTableView.h"

#define RowH 60
#define HeaderH 35
#define Padding 12
#define LinViewH 7
#define Selelcted
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define IndexPadding 5
#define OffsetY 75
@interface JGJBlackListVc () <JGJBlackListCellDelegate, UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet JGJRefreshTableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) JGJChatMsgListModel *jgjChatListModel; //聊天人的信息
@end

@implementation JGJBlackListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor = AppFontf1f1f1Color;
    self.isEdit = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBlackList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContactsModel.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    count = sortFindResult.findResult.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self JGJRegisterTableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)JGJRegisterTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJBlackListCell *cell = [JGJBlackListCell cellWithTableView:tableView];
    cell.delegate = self;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    contactModel.isSelected = self.isEdit;
    cell.contactModel = contactModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isEdit) {
        return;
    }
    [self JGJBlackListVcTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)JGJBlackListVcTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = contactModel.uid;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont32Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    if (self.sortContactsModel.sortContacts.count > 0) {
        SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;
        firstLetterLable.text = firstLetter;
    }
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

#pragma mark - JGJBlackListCellDelegate
- (void)JGJBlackListCell:(JGJBlackListCell *)cell contactModel:(JGJSynBillingModel *)contactModel {
    
    NSDictionary *parameters = @{
                                 @"uid" : contactModel.uid?:@""
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/rm-black-list" parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *blackListModels = self.blackListModels.mutableCopy;
        
        [blackListModels removeObject:contactModel];
        
        self.blackListModels = blackListModels;
        
        [TYShowMessage showSuccess:@"移除成功"];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - buttonAction
- (IBAction)handleRightItemAction:(UIBarButtonItem *)sender {
    self.isEdit = !self.isEdit;
    self.rightItem.title = self.isEdit ? @"编辑" : @"完成";
    [self.tableview reloadData];
}

#pragma mark - 加载黑名单列表
- (void)loadBlackList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    request.pagesize = JGJPageSize;
    
    request.pg = 1;
    
    request.requestApi = JGJChatGetBlackListURL;
    
    self.tableview.request = request;
    
    TYWeakSelf(self);
    
    [self.tableview loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
        self.blackListModels = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:tableView.dataArray];
        
        JGJComDefaultView *defaultView = nil;
        
        if (self.blackListModels.count == 0) {
            
            NSString *tips = @"如果在聊天过程中遇到恶意骚扰\n你可以将TA拉黑";
            
            defaultView = [[JGJComDefaultView alloc] initWithFrame:self.view.bounds];
            
            JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
            
            defaultViewModel.lineSpace = 5;
            
            defaultViewModel.des = tips;
            
            defaultViewModel.isHiddenButton = YES;
            
            defaultView.defaultViewModel = defaultViewModel;
            
        }
        
        return defaultView;
        
    }];
    
}

-(void)setBlackListModels:(NSMutableArray *)blackListModels {
    _blackListModels = blackListModels;
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_blackListModels];
    [self setFooterViewCount:_blackListModels.count];
    [self.tableview reloadData];
}

#pragma mark - 设置底部数据
- (void)setFooterViewCount:(NSUInteger)count {
    
    CGFloat height = count == 0 ? CGFLOAT_MIN : 40;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *memberNumLable = [[UILabel alloc] initWithFrame:footerView.bounds];
    memberNumLable.textAlignment = NSTextAlignmentCenter;
    memberNumLable.backgroundColor = AppFontf1f1f1Color;
    memberNumLable.textColor = AppFont999999Color;
    memberNumLable.font = [UIFont systemFontOfSize:AppFont24Size];
    [footerView addSubview:memberNumLable];
    self.tableview.tableFooterView = footerView;
    memberNumLable.text = [NSString stringWithFormat:@"共%@人",@(count)];
    
    if (count == 0) {
        
        height = CGFLOAT_MIN;
        
        memberNumLable.text = @"";
    }
}


- (void)setSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    _sortContactsModel = sortContactsModel;
    [self handleNoSortContactsModel:_sortContactsModel];
    [self.tableview reloadData];
}

#pragma mark - 处理没有数据的情况
- (void)handleNoSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    if (sortContactsModel.sortContacts.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        NSString *tips = @"如果在聊天过程中遇到恶意骚扰\n你可以将TA拉黑";
        //        if (self.blackListVcType == JGJTransferAuthorityVcType) {
        //            tips = @"本群无更多成员可选择";
        //        }
        JGJComDefaultView *defaultView = [[JGJComDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
        
        defaultViewModel.lineSpace = 5;
        
        defaultViewModel.des = tips;
        
        defaultViewModel.isHiddenButton = YES;
        
        defaultView.defaultViewModel = defaultViewModel;
        
        self.tableview.tableHeaderView = defaultView;
        
    } else {
        self.tableview.tableHeaderView = nil;
    }
}

- (JGJChatMsgListModel *)jgjChatListModel {
    if (!_jgjChatListModel) {
        _jgjChatListModel = [JGJChatMsgListModel new];
    }
    return _jgjChatListModel;
}
@end

