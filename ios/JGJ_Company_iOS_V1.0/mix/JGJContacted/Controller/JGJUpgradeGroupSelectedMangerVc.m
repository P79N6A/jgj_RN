//
//  JGJUpgradeGroupSelectedMangerVc.m
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUpgradeGroupSelectedMangerVc.h"
#import "JGJSelectedCreaterCell.h"
#import "JGJChatRootVc.h"
#import "JGJAddressBookTool.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
#define RowH 60
#define HeaderH 35
#define Padding 12
#define LinViewH 7
@interface JGJUpgradeGroupSelectedMangerVc ()
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (strong, nonatomic) JGJSynBillingModel *memberModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;
@end

@implementation JGJUpgradeGroupSelectedMangerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    //默认按钮禁用
    self.rightItem.enabled = NO;
    [self getMembers];
    [self handleTableViewHeader];
}

- (void)getMembers {
    NSArray *contacts = self.members.copy;
    NSString *telephone = [TYUserDefaults objectForKey:JLGPhone]; //去掉自己,这里可以和下面的谓词写在一起
    for (NSInteger indx = contacts.count - 1; indx > 0; indx --) {
        JGJSynBillingModel *memebrModel = contacts[indx];
        if ([memebrModel.telephone isEqualToString:telephone]) {
            [self.members removeObject:memebrModel];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel != %@", @(YES)];
    contacts = [self.members filteredArrayUsingPredicate:predicate];
    self.members = contacts.mutableCopy;
    
    NSPredicate *selpredicate = [NSPredicate predicateWithFormat:@"isSelected=%@", @(YES)];
    
    JGJSynBillingModel *selMemberModel = [self.members filteredArrayUsingPredicate:selpredicate].lastObject;
    
    if (![NSString isEmpty:selMemberModel.uid]) {
        
        selMemberModel.isSelected = NO;
    }
    
}

- (void)setMembers:(NSMutableArray *)members {
    _members = members;
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:_members];
    if (_members.count > 0) {
        [self setFooterViewCount:_members.count];
    }
    [self.tableView reloadData];
}

#pragma mark - 设置底部数据
- (void)setFooterViewCount:(NSUInteger)count {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 40)];
    footerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *memberNumLable = [[UILabel alloc] initWithFrame:footerView.bounds];
    memberNumLable.textAlignment = NSTextAlignmentCenter;
    memberNumLable.backgroundColor = AppFontf1f1f1Color;
    memberNumLable.textColor = AppFont999999Color;
    memberNumLable.font = [UIFont systemFontOfSize:AppFont24Size];
    [footerView addSubview:memberNumLable];
    self.tableView.tableFooterView = footerView;
    memberNumLable.text = [NSString stringWithFormat:@"共%@人",@(count)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContactsModel.sortContacts.count;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    count = sortFindResult.findResult.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSelectedCreaterCell *cell = [JGJSelectedCreaterCell cellWithTableView:tableView];
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    cell.contactModel = memberModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self JGJBlackListVcTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)JGJBlackListVcTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *temp = self.lastIndexPath;
    SortFindResultModel *sortFindResult = nil;
    if(temp && temp != indexPath) {
        sortFindResult = self.sortContactsModel.sortContacts[self.lastIndexPath.section];
        JGJSynBillingModel *lastmemberModel = sortFindResult.findResult[self.lastIndexPath.row];;
        lastmemberModel.isSelected = NO;//修改之前选中的cell的数据为不选中
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    //选中的修改为当前行
    sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    memberModel.indexPathMember = indexPath;
    self.lastIndexPath = indexPath;
    memberModel.isSelected = YES;
    if (memberModel.isSelected) {
        self.memberModel = memberModel;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //按钮启用
    self.rightItem.enabled = YES;
}

- (IBAction)handleRightItemAction:(UIBarButtonItem *)sender {
    NSDictionary *parameters = @{
                                 @"uid" : self.memberModel.uid ?:@"",
                                 @"group_id" : self.workProListModel.group_id ?:@"",
                                 @"group_name" : self.workProListModel.group_name?:@"",
                                 @"class_type" : @"groupChat"
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/upgrade-group" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJMyWorkCircleProListModel *workCircleProListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
        //更新聊聊表数据
        
        [self upgradeGroup:self.workProListModel];
        
        [self handleSkipChatVcWithWorkCirclePro:workCircleProListModel];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)handleSkipChatVcWithWorkCirclePro:(JGJMyWorkCircleProListModel *)workCircleProListModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    workCircleProListModel.class_type = @"team";
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    workCircleProListModel.myself_group = [myUid isEqualToString:self.memberModel.uid] ? @"1" : @"0";
    
    chatRootVc.workProListModel = workCircleProListModel;
    
    [self.navigationController pushViewController:chatRootVc animated:YES];
    
}

#pragma mark - 更新聊聊表数据

- (void)upgradeGroup:(JGJMyWorkCircleProListModel *)proListModel {
    
    // 删除聊聊列表数据
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = proListModel.class_type;
    
    groupModel.group_id = proListModel.group_id;
    
    groupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    //删除
    [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
    
    //删除之后获取俩聊列表接口
    
    [JGJChatGetOffLineMsgInfo http_getChatGroupListSuccess:nil];
    
}

#pragma mark - 设置头部转让管理权，审计群聊
- (void)handleTableViewHeader {
    NSString *titleStr = nil;
    titleStr = @"请选择班组创建者";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, HeaderH)];
    headerView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.tableHeaderView = headerView;
    UILabel *titleLable = [UILabel new];
    titleLable.text = titleStr;
    titleLable.textColor = AppFont666666Color;
    titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    [headerView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(HeaderH));
        make.centerY.equalTo(headerView.mas_centerY);
        make.leading.equalTo(@12);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AppFontdbdbdbColor;
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@12);
        make.trailing.equalTo(@-12);
        make.bottom.equalTo(headerView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

@end

