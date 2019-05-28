//
//  JGJMemberFilterView.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberFilterView.h"

#import "JGJFilterAccountMemberCell.h"

#import "JGJAddressBookTool.h"

#import "UIView+GNUtil.h"

#import "JGJCusNavBar.h"

#define HeaderH 25

@interface JGJMemberFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息

//首次筛选人员默认选择
@property (nonatomic, assign) BOOL isFirstFilter;

@property (nonatomic, strong) JGJCusNavBar *cusNavBar;

@end

@implementation JGJMemberFilterView
//@synthesize allMembers = _allMembers;

- (instancetype)initWithFrame:(CGRect)frame proListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(TYGetUIScreenWidth - 40, 0, TYGetUIScreenWidth - 40, TYGetUIScreenHeight);
        
        self.proListModel = proListModel;
        
        [self initialSubView];
    }
    
    return self;
    
}

- (void)initialSubView {
    
    [self addSubview:self.cusNavBar];
    
    [self addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
    
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    
    JGJFilterAccountMemberHeaderView *headerView = [[JGJFilterAccountMemberHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    
    headerView.proListModel = self.proListModel;
    
    self.headerView = headerView;
    
    self.tableView.tableHeaderView = headerView;
    
    TYWeakSelf(self);
    headerView.filterAccountMemberHeaderViewBlock = ^(id headerView) {
      
        NSIndexPath *temp = self.lastIndexPath;
        
        //取消具体人员的选中
        if (weakself.lastIndexPath) {
            
            SortFindResultModel *lastSortFindResult = weakself.sortContactsModel.sortContacts[weakself.lastIndexPath.section];
            
            JGJSynBillingModel *lastMemberModel = lastSortFindResult.findResult[weakself.lastIndexPath.row];
            
            lastMemberModel.isSelected = NO;
            
            [weakself.tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //全部人员的筛选
        if (weakself.memberFilterViewBlock) {
            
            JGJSynBillingModel *allMemberModel = [[JGJSynBillingModel alloc] init];
            
            allMemberModel.name = RecordMemberDes;
            
            if (![NSString isEmpty:self.proListModel.group_id]) {
                
                allMemberModel.name = AgencyDes;
            }
            
            weakself.memberFilterViewBlock(allMemberModel);
        }
    };
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sortContactsModel.sortContacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return HeaderH;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont24Size];
    firstLetterLable.frame = CGRectMake(12, 0, TYGetUIScreenWidth, HeaderH);
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    
    if (sortFindResult.findResult.count > 0) {

        NSString *firstLetter = sortFindResult.firstLetter.uppercaseString;

        firstLetterLable.text = firstLetter;
    }
    
    firstLetterLable.textColor = AppFont999999Color;
    
    [headerView addSubview:firstLetterLable];
    
    return headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[section];
    
    NSInteger count = sortFindResult.findResult.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJFilterAccountMemberCell *cell = [JGJFilterAccountMemberCell cellWithTableView:tableView];
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    if (![NSString isEmpty:_selMemberModel.class_type_id] && [memberModel.class_type_id isEqualToString:_selMemberModel.class_type_id]) {
        
        memberModel.isSelected = YES;
        
    }else {
        
         memberModel.isSelected = NO;
    }
    
    cell.memberModel = memberModel;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    if (![NSString isEmpty:_selMemberModel.class_type_id] && [memberModel.class_type_id isEqualToString:_selMemberModel.class_type_id]) {
        
        self.lastIndexPath = indexPath;
    }
    
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section];
    
    JGJSynBillingModel *memberModel = sortFindResult.findResult[indexPath.row];
    
    //3.3.7添加
    _selMemberModel = memberModel;
    
    if (self.memberFilterViewBlock) {
        
        self.memberFilterViewBlock(memberModel);
    }
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if (temp && temp != indexPath) {
        
        SortFindResultModel *lastSortFindResult = self.sortContactsModel.sortContacts[self.lastIndexPath.section];
        
        JGJSynBillingModel *lastMemberModel = lastSortFindResult.findResult[self.lastIndexPath.row];
        
        lastMemberModel.isSelected = NO;
        
//        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    memberModel.isSelected = YES;
    
    self.lastIndexPath = indexPath;
    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    //取消头部的选中
    if (self.headerView.isSelHeaderView) {
        
        self.headerView.isSelHeaderView = NO;
    }
    
    [self.tableView reloadData];
    
    //已筛选
    _isFirstFilter = YES;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, self.cusNavBar.height, TYGetUIScreenWidth, self.height - self.cusNavBar.height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (void)setAllMembers:(NSArray *)allMembers {
    
    _allMembers = allMembers;
    
    self.sortContactsModel = [JGJAddressBookTool addressBookToolSortContcts:allMembers];
    
    [self.tableView reloadData];
}

- (void)setStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    _staListModel = staListModel;
    
    //默认选中全部班组长,一人几多天有人员就不选中
    self.headerView.isSelHeaderView = [NSString isEmpty:_staListModel.class_type_id];
    
}

- (void)setSelMemberModel:(JGJSynBillingModel *)selMemberModel {
    
    _selMemberModel = selMemberModel;
    
    //默认选中全部班组长,一人几多天有人员就不选中
    self.headerView.isSelHeaderView = [NSString isEmpty:_selMemberModel.class_type_id];
    
    [self.tableView reloadData];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.memberFilterViewBlock) {
        
        self.memberFilterViewBlock(nil);
    }
}

- (JGJCusNavBar *)cusNavBar {
    
    if (!_cusNavBar) {
        
        _cusNavBar = [[JGJCusNavBar alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 40, JGJ_NAV_HEIGHT)];
        
        _cusNavBar.title.text = MemberDes;
        
        if (![NSString isEmpty:self.proListModel.group_id]) {
            
            _cusNavBar.title.text = AgencyDes;
        }
        
        TYWeakSelf(self);
        
        //返回按钮按下
        _cusNavBar.backBlock = ^{
            
            if (weakself.backBlock) {

                weakself.backBlock();
            }
            
        };
        
    }
    
    return _cusNavBar;
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
}

@end
