//
//  JGJTransferAuthorityVc.m
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTransferAuthorityVc.h"
#import "JGJCustomPopView.h"
#import "JGJBlackListCell.h"
#import "JGJAddressBookTool.h"
#define RowH 60
#define HeaderH 35
#define Padding 12
#define LinViewH 7
@interface JGJTransferAuthorityVc () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JGJTransferAuthorityVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    [self handleTableViewHeader];
    [self getMembers];
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
    
    JGJBlackListCell *cell = [JGJBlackListCell cellWithTableView:tableView];
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    contactModel.isSelected = YES;
    cell.contactModel = contactModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (void)JGJBlackListVcTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = [NSString stringWithFormat:@"你确定要将本群的管理权转让给 %@ 吗?",memberModel.name];
    desModel.popTextAlignment = NSTextAlignmentLeft;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        [weakSelf handleTransAuthorConfirmButtonPressedWithMemberModel:memberModel];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self JGJBlackListVcTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)handleTransAuthorConfirmButtonPressedWithMemberModel:(JGJSynBillingModel *)memberModel {
    NSDictionary *parameters = @{
                                 @"uid" : memberModel.uid ?:@"",
                                 @"class_type" : @"groupChat",
                                 @"group_id" : self.workProListModel.group_id ?:@""};
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJSwitchManagerURL parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"转让管理权成功"];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [weakSelf.members removeObject:memberModel]; //移除当前失败的人
        
        [weakSelf.tableView reloadData];
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 设置头部转让管理权，审计群聊
- (void)handleTableViewHeader {
    NSString *titleStr = @"请选择新的群主";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, HeaderH)];
    headerView.backgroundColor = AppFontE6E6E6Color;
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
}


@end
