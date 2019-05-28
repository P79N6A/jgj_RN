//
//  JGJSearchResultView.h
//  mix
//
//  Created by yj on 16/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJKnowBaseSearchResultDefaultCell.h"
#import "JGJChatGroupListModel.h"
@class JGJCustomSearchBar;

typedef enum : NSUInteger {
    JGJSearchMemberResultViewType, //搜索成员
    JGJSearchMemberAndGroupResultViewType,//搜索项目和单聊人员 聊聊搜索
    JGJSearchGroupChatListViewType, //选择项目搜索
    JGJSearchAddressBookMember, //搜索手机通讯录成员
    JGJSearchKnowBaseFileType, //搜索知识库类型
    JGJSearchKnowBaseNoRusultFileType, //没有搜索结果类型
    JGJSearchAddressType,//搜索位置
    JGJSearchProiCloudInfoType,//搜索云盘项目cell
    JGJSearchKnowBaseDownloadType,//资料库已下载cell
    JGJSearchContactedAddressBookType //搜索通信录好友
} JGJSearchResultViewType;
@class JGJSearchResultView;
@protocol JGJSearchResultViewdelegate <NSObject>
@optional
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedMember:(JGJSynBillingModel *)memberModel;
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedChatListModel:(JGJMyWorkCircleProListModel *)chatListModel;
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedChatListModel:(JGJMyWorkCircleProListModel *)chatListModel groupModel:(JGJChatGroupListModel *)groupModel;
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel;

- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedRow:(NSInteger)row;

// 点击了搜索的取消按钮
- (void)searchResultView:(JGJSearchResultView *)searchResultView clickedCancelButtonWithSearchBar:(JGJCustomSearchBar *)searchBar;

// 输入框文字改变
- (void)searchResultView:(JGJSearchResultView *)searchResultView searchBarWithChangeText:(NSString *)searchText;
@end

@interface JGJSearchResultView : UIView
@property (weak, nonatomic) id <JGJSearchResultViewdelegate> delegate;
@property (nonatomic, strong) NSArray *results;//设置搜索结果
//控制器类型 选择人员单聊 和选择人员群聊
@property (nonatomic, assign) JGJChatType chatType;

@property (nonatomic, assign) JGJGroupChatListVcType groupChatListVcType;

@property (assign, nonatomic) JGJSearchResultViewType resultViewType;

@property (strong, nonatomic) UITableView *tableView;

//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

@property (nonatomic, strong) JGJCustomSearchBar *searchbar;

@property (nonatomic, assign) JGJKnowBaseSearchResultDefaultCellType searchResultDefaultCellType; //获取搜索类型，知识库使用。搜索的类型

//导航栏和搜索框在同一个界面(其余分开的原因是搜索框位置在当前页面，点击搜索的时候移动到顶部)
- (instancetype)initWithFrame:(CGRect)frame showSearchView:(BOOL)showSearchView;
@end

