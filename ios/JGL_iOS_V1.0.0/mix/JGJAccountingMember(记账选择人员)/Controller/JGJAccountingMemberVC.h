//
//  JGJAccountingMemberVC.h
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCommonInfoDesCell.h"

#import "YZGAddContactsHUBView.h"

#define ShowCount 10

typedef enum : NSUInteger {
    
    AddSingleMemberDefaultType,
    
    AddSingleMemberType = 1, //添加单个成员
    
    AddOtherMemberType, //添加其他成员(通讯录、列表成员等)
    
    AddComMemberType, //常用人员
    
    AddGroupMangerMember //班组管理
    
} AddMemberType;

typedef void(^JGJAccountingMemberVCSelectedMemberBlock)(id);

@interface JGJAccountingMemberVC : UIViewController 

@property (nonatomic, assign) BOOL isGroupMember;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
//选中的记账人员
@property (nonatomic, strong) JGJSynBillingModel *seledAccountMember;

@property (nonatomic, copy) JGJAccountingMemberVCSelectedMemberBlock accountingMemberVCSelectedMemberBlock;

//回传数据
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;

//进入的控制器
@property (nonatomic, weak) UIViewController *targetVc;

//子类使用
@property (strong, nonatomic, readonly) YZGAddContactsHUBView  *addWorkerContactsHUBView;

//顶部描述信息
@property (nonatomic, strong, readonly) NSMutableArray *firstSectionInfos;

//添加成员类型
@property (nonatomic, assign) AddMemberType memberType;

//记账人员子类使用
@property (nonatomic, strong, readonly) NSArray *accountMembers;

//搜索的人员

@property (nonatomic, strong) NSMutableArray *searchAccountMembers;

//是否显示删除按钮子类使用
@property (nonatomic, assign, readonly) BOOL isShowDelButton;

//添加人员类型同步给我的 和 同步记工文案不同
@property (nonatomic, assign) YZGAddContactsHUBViewType hubViewType;

@property (nonatomic, copy, readonly) NSString *searchValue;

//代理设置的标题
@property (nonatomic, copy) NSString *agency_title;

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@property (nonatomic, strong,readonly) UITableView *tableView;

@property (nonatomic, strong, readonly) NSArray *contactsLetters;//包含首字母

@property (nonatomic, strong, readonly) JGJCustomSearchBar *searchbar;

//班组进入记多人然后记单笔
@property (nonatomic, assign) BOOL isMarkBill;

// 是否是从首页进入记账页面
@property (nonatomic, assign) BOOL is_Home_Bill;

- (void)normalWorkerDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//成功后处理
- (void)handleSuccessResponse:(NSArray *)responseObject;

//子类使用 添加同步人员处理
- (void)popToReleaseBillVc:(YZGAddForemanModel *)addForemanModel;

//开始刷新子类使用
- (void)beginReFresh;

//子类调用清空搜索

- (void)searchWithValue:(NSString *)value;

@end
