//
//  JGJSearchResultView.m
//  mix
//
//  Created by yj on 16/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSearchResultView.h"
#import "JGJContactedListCell.h"
#import "JGJGroupChatSelectedMemberCell.h"
#import "JGJContactedListCell.h"
#import "JGJGroupChatListCell.h"
#import "JGJAddFriendAddressBookCell.h"
#import "JGJknowRepoChildVcCell.h"
#import "JGJPublQualityLocaCell.h"
#import "JGJProicloudListCell.h"
#import "JGJKonwBaseDownloadCell.h"
#import "TYTextField.h"

#import "JGJContactedAddressBookCell.h"

#define SearchResultViewAlpha 0.97
@interface JGJSearchResultView () <
UITableViewDelegate,
UITableViewDataSource
>

//暂无记录提示文字
@property (nonatomic, copy) UILabel *tips;

@end
@implementation JGJSearchResultView
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat searchResultViewY = JGJ_NAV_HEIGHT;
        
        self.frame = CGRectMake(frame.origin.x, searchResultViewY, frame.size.width, frame.size.height);
        self.backgroundColor = AppFontf1f1f1Color;
        self.alpha = SearchResultViewAlpha;
        [self addSubview:self.tableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showSearchView:(BOOL)showSearchView {
    
    if (self = [super initWithFrame:frame]) {
        
        self.searchbar = [JGJCustomSearchBar new];
        
        __weak typeof(self) weakSelf = self;
        
        self.searchbar.searchBarTF.valueDidChange = ^(NSString *value){
            
            if ([weakSelf.delegate respondsToSelector:@selector(searchResultView:searchBarWithChangeText:)]) {
                
                [weakSelf.delegate searchResultView:weakSelf searchBarWithChangeText:value];
            }
            
        };
        
        self.searchbar.handleButtonPressedBlcok = ^(JGJCustomSearchBar *searchBar) {
            
            if ([weakSelf.delegate respondsToSelector:@selector(searchResultView:clickedCancelButtonWithSearchBar:)]) {
                
                [weakSelf.delegate searchResultView:weakSelf clickedCancelButtonWithSearchBar:searchBar];
            }
        };
        
        self.searchbar.frame = CGRectMake(0, 20, TYGetUIScreenWidth, 48);
        
        self.tableView.frame = CGRectMake(frame.origin.x, TYGetMaxY(self.searchbar), frame.size.width, frame.size.height - TYGetMaxY(self.searchbar));
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        
        self.backgroundColor = AppFontf1f1f1Color;
        
        self.alpha = SearchResultViewAlpha;
        
        [self addSubview:self.searchbar];
        
        self.searchbar.isShowSearchBarTop = YES;
        
        [self addSubview:self.tableView];
        
    }
    
    return self;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (self.resultViewType) {
        case JGJSearchMemberResultViewType:{
            height = [JGJGroupChatSelectedMemberCell chatSelectedMemberCellHeight];
        }
            break;
        case JGJSearchMemberAndGroupResultViewType:{
            height = [JGJContactedListCell contactedListCellHeight];
        }
            break;
        case JGJSearchGroupChatListViewType:{
            height = [JGJGroupChatListCell JGJGroupChatListCellHeight];
        }
            break;
            
        case JGJSearchAddressBookMember:{
            height = [JGJAddFriendAddressBookCell JGJAddFriendAddressBookCellHeight];
        }
            break;
            
        case JGJSearchKnowBaseFileType: {
            
            JGJKnowBaseModel *knowBaseModel = self.results[indexPath.row];
            
            height = knowBaseModel.cellHeight;
        }
            break;
        case JGJSearchKnowBaseNoRusultFileType: {
            
            height = [JGJKnowBaseSearchResultDefaultCell knowBaseSearchResultDefaultCellHeight];
        }
            break;
        case JGJSearchAddressType:{
            
            height = 50;
        }
            
            break;
        case JGJSearchProiCloudInfoType:{
            
            JGJProicloudListModel *cloudListModel = self.results[indexPath.row];
            
            CGFloat height = cloudListModel.isExpand ? 110 : 70;
            
            if (cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType) {
                
                height = 70;
            }
            
            return height;
        }
            
            break;
            
        case JGJSearchKnowBaseDownloadType:{
            
            JGJKnowBaseModel *knowBaseModel = self.results[indexPath.row];
            
            height = knowBaseModel.downloadCellHeight;
            
            if (height < 65) {
                
                height = 65;
            }
        }
            break;
            
        case JGJSearchContactedAddressBookType:{
            
            height = [JGJContactedAddressBookCell cellHeight];
        }
            
            break;
            
        default:{
            
            height = 70;
        }
            break;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    if (self.resultViewType == JGJSearchAddressBookMember) {
        
        count = self.results.count;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.results.count;
    if (self.resultViewType == JGJSearchAddressBookMember) {
        
        SortFindResultModel *sortFindResult = self.results[section];
        
        count = sortFindResult.findResult.count;
        
    }else if (self.resultViewType == JGJSearchKnowBaseNoRusultFileType) {
        
        count = 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.resultViewType == JGJSearchMemberResultViewType) { //搜索人员
        
        JGJGroupChatSelectedMemberCell *selectedMemberCell = [JGJGroupChatSelectedMemberCell cellWithTableView:tableView];
        selectedMemberCell.chatType = self.chatType;
        
        selectedMemberCell.searchValue = self.searchValue;
        
        selectedMemberCell.groupChatMemberModel = self.results[indexPath.row];
        
        selectedMemberCell.lineView.hidden = indexPath.row == self.results.count - 1;
        
        cell = selectedMemberCell;
        
    }else if (self.resultViewType == JGJSearchMemberAndGroupResultViewType) {
        
        JGJContactedListCell *contactedListCell = [JGJContactedListCell cellWithTableView:tableView];
        
        //        JGJMyWorkCircleProListModel *proListModel = self.results[indexPath.row];
        JGJChatGroupListModel *proListModel = self.results[indexPath.row];
        contactedListCell.searchValue = self.searchValue;
        
        contactedListCell.groupModel = proListModel;
        
        cell = contactedListCell;
        
    }else if (self.resultViewType == JGJSearchGroupChatListViewType) {
        
        JGJGroupChatListCell *chatListCell = [JGJGroupChatListCell cellWithTableView:tableView];
        chatListCell.lineView.hidden = self.results.count - 1 == indexPath.row;
        chatListCell.groupChatListVcType = self.groupChatListVcType; //区分是否显示数量
        chatListCell.chatType = self.chatType;
        chatListCell.searchValue = self.searchValue;
        chatListCell.groupListModel = self.results[indexPath.row];
        cell = chatListCell;
        
    }else if (self.resultViewType ==  JGJSearchAddressBookMember) {
        
        cell = [self handleRegisterAddressBookCellWithTableView:tableView indexpath:indexPath];
        
    }else if (self.resultViewType == JGJSearchKnowBaseFileType) {
        
        cell = [self handleRegisterKnowRepoChildVcCellWithTableView:tableView indexpath:indexPath];
        
    }else if (self.resultViewType == JGJSearchKnowBaseNoRusultFileType) { //没有数据类型
        
        cell = [self handleRegisterKnowBaseSearchResultDefaultCellWithTableView:tableView indexpath:indexPath];
    }else if (self.resultViewType == JGJSearchAddressType) { //没有数据类型
        
        cell = [self handleRegisterAddressCellWithTableView:tableView indexpath:indexPath];
        
    }else if (self.resultViewType == JGJSearchProiCloudInfoType) { //云盘列表
        
        cell = [self handleRegisterProiColudCellWithTableView:tableView indexpath:indexPath];
    }else if (self.resultViewType == JGJSearchKnowBaseDownloadType) {
        
        cell = [self handleRegisterKnowRepoDownloadCellWithTableView:tableView indexpath:indexPath];
        
    }else if (self.resultViewType == JGJSearchContactedAddressBookType) {
        
        cell = [self handleRegisterContactedAddressBookCellWithTableView:tableView indexpath:indexPath];
        
    }
    return cell;
}

- (UITableViewCell *)handleRegisterAddressBookCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    JGJAddFriendAddressBookCell *cell = [JGJAddFriendAddressBookCell cellWithTableView:tableView];;
    SortFindResultModel *sortFindResult = self.results[indexPath.section];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    cell.searchValue = self.searchValue;
    cell.contactModel = contactModel;
    cell.lineView.hidden = sortFindResult.findResult.count -1 == indexPath.row;
    return cell;
}

- (UITableViewCell *)handleRegisterKnowBaseSearchResultDefaultCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJKnowBaseSearchResultDefaultCell *cell = [JGJKnowBaseSearchResultDefaultCell cellWithTableView:tableView];;
    
    cell.searchValue = self.searchValue;
    
    cell.searchResultDefaultCellType = self.searchResultDefaultCellType;
    
    return cell;
}

- (UITableViewCell *)handleRegisterKnowRepoChildVcCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJknowRepoChildVcCell *cell = [JGJknowRepoChildVcCell cellWithTableView:tableView];
    
    JGJKnowBaseModel *knowBaseModel = self.results[indexPath.row];
    
    knowBaseModel.knowBaseIndexPath = indexPath;
    
    cell.searchValue = self.searchValue;
    
    cell.knowBaseModel = knowBaseModel;
    
    cell.lineView.hidden = self.results.count -1 == indexPath.row;
    
    return cell;
}

- (UITableViewCell *)handleRegisterKnowRepoDownloadCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJKonwBaseDownloadCell *cell = [JGJKonwBaseDownloadCell cellWithTableView:tableView];
    
    JGJKnowBaseModel *knowBaseModel = self.results[indexPath.row];
    
    knowBaseModel.knowBaseIndexPath = indexPath;
    
    cell.searchValue = self.searchValue;
    
    cell.knowBaseModel = knowBaseModel;
    
    cell.lineView.hidden = self.results.count -1 == indexPath.row;
    
    return cell;
}

- (UITableViewCell *)handleRegisterAddressCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJPublQualityLocaCell *cell = [JGJPublQualityLocaCell cellWithTableView:tableView];
    
    JGJQualityLocationModel *locationModel = self.results[indexPath.row];
    
    cell.searchValue = self.searchValue;
    
    cell.locationModel = locationModel;
    
    cell.lineView.hidden = self.results.count -1 == indexPath.row;
    
    return cell;
}

- (UITableViewCell *)handleRegisterProiColudCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {
    
    JGJProicloudListCell *cell = [JGJProicloudListCell cellWithTableView:tableView];
    
    JGJProicloudListModel *cloudListModel = self.results[indexPath.row];
    
    //    cloudListModel.cloudListCellType = self.cloudListCellType;
    
    cell.cloudListModel = cloudListModel;
    
    return cell;
}

- (UITableViewCell *)handleRegisterContactedAddressBookCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath {

    JGJContactedAddressBookCell *cell = [JGJContactedAddressBookCell cellWithTableView:tableView];

    JGJSynBillingModel *contactModel = self.results[indexPath.row];
    
    cell.addressBookCellType = JGJContactedAddressBookCellDefaultType;

    cell.contactModel = contactModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.resultViewType) {
        
        case JGJSearchContactedAddressBookType:
        
        case JGJSearchMemberResultViewType:{
            
            JGJSynBillingModel *contactModel = self.results[indexPath.row];
            
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedMember:)]) {
                
                [self.delegate searchResultView:self didSelectedMember:contactModel];
                
            }
            
        }
            break;
        case JGJSearchMemberAndGroupResultViewType:{
            
            //            JGJMyWorkCircleProListModel *chatListModel = self.results[indexPath.row];
            JGJChatGroupListModel *model = self.results[indexPath.row];
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedChatListModel: groupModel:)]) {
                
                JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
                proListModel.group_id = model.group_id;
                proListModel.class_type = model.class_type;
                proListModel.group_name = model.group_name;
                proListModel.members_num = model.members_num;
                proListModel.is_sticked = model.is_top;
                proListModel.pro_id = model.pro_id;
                proListModel.creater_uid = model.creater_uid;
                proListModel.isClosedTeamVc = model.is_closed;
                
                [self.delegate searchResultView:self didSelectedChatListModel:proListModel groupModel:model];
            }
        }
            break;
        case JGJSearchGroupChatListViewType:{
            JGJMyWorkCircleProListModel *chatListModel = self.results[indexPath.row];
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedChatListModel:)]) {
                [self.delegate searchResultView:self didSelectedChatListModel:chatListModel];
            }
        }
            break;
        case JGJSearchAddressBookMember: {
            SortFindResultModel *sortFindResult = self.results[indexPath.section];
            JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedMember:)]) {
                [self.delegate searchResultView:self didSelectedMember:contactModel];
            }
        }
            break;
            
            //资料库
        case JGJSearchKnowBaseDownloadType:
        case JGJSearchKnowBaseFileType:{
            
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedKnowBaseModel:)]) {
                
                if (self.results.count > 0) {
                    
                    JGJKnowBaseModel *knowBaseModel = self.results[indexPath.row];
                    [self.delegate searchResultView:self didSelectedKnowBaseModel:knowBaseModel];
                }
                
            }
            
        }
            break;
            
        case JGJSearchKnowBaseNoRusultFileType: {
            
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedKnowBaseModel:)]) {
                
                [self.delegate searchResultView:self didSelectedKnowBaseModel:nil];
                
            }
            
        }
            break;
            
        case JGJSearchAddressType: {
            
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedRow:)]) {
                
                [self.delegate searchResultView:self didSelectedRow:indexPath.row];
                
            }
            
        }
            break;
            
        case JGJSearchProiCloudInfoType: {
            
            if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectedRow:)]) {
                
                [self.delegate searchResultView:self didSelectedRow:indexPath.row];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)setResults:(NSArray *)results {
    
    _results = results;
    
    if (self.resultViewType != JGJSearchAddressType) {
        
        if (results.count == 0 && ![NSString isEmpty:self.searchValue]) {
            
            [self addSubview:self.tips];
            
        }else if ([self.subviews containsObject:self.tips]) {
            
            [self.tips removeFromSuperview];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - 搜索知识库的时候使用
- (void)setSearchResultDefaultCellType:(JGJKnowBaseSearchResultDefaultCellType)searchResultDefaultCellType {
    
    _searchResultDefaultCellType = searchResultDefaultCellType;
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        _tableView.alpha = 0.97;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
}

- (UILabel *)tips {
    
    if (!_tips) {
        
        _tips = [UILabel new];
        
        _tips.textAlignment = NSTextAlignmentCenter;
        
        _tips.text = @"未搜索到相关内容";
        
        _tips.textColor = AppFont999999Color;
        
        _tips.font = [UIFont systemFontOfSize:AppFont30Size];
        
        _tips.centerY = TYKey_Window.centerY - (TYGetUIScreenHeight - 216) / 2.0;
        
        _tips.size = CGSizeMake(TYGetUIScreenWidth, 50);
        
        _tips.x = self.width / 2.0 - TYGetUIScreenWidth / 2.0;
        
    }
    
    return _tips;
    
}

@end

