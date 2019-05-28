//
//  JGJSynBillingManageVC.h
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWageDetailModel.h"
#import "CFRefreshTableView.h"
typedef void(^skipToNextVc)(UIViewController *nextVc);
@class WageMoreDetailInitModel;
@interface JGJSynBillingManageVC : UIViewController
@property (nonatomic,copy) NSString *projectID;
@property (nonatomic, strong) JGJSynBillingCommonModel *synBillingCommonModel;
@property (nonatomic, strong) WageMoreDetailInitModel *wageMoreDetailInitModel;
@property (nonatomic, strong) NSMutableArray *selectedSynBillingModels;//选中的同步联系人
//总的数据源编辑之后添加
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL isScroTop;//是否滚动到顶部
@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;

@property (nonatomic, strong) NSMutableArray *sortContacts ;//排序后的联系人
@property (nonatomic, strong) NSMutableArray *selectedAddressBooks;//添加通信录返回的单个数据
@property (nonatomic, strong) NSArray *backupsDataSource; //备份数据搜索用
@property (nonatomic, strong) NSMutableArray *backupsOtherDataSource; //备份数据列表用
@property (strong, nonatomic) UILabel *centerShowLetter;
//底部视图
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchBarViewH;
@property (nonatomic, assign) JGJGroupMemberMangeType groupMemberMangeType;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton; //处理是否显示全选按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmSynBtn;
@property (strong, nonatomic) JGJActiveGroupModel *activeGroupModel; //主要用于传入是否有项目组

@property (nonatomic,copy) skipToNextVc skipToNextVc;
//选中之后从通信录页面跳转至顶部已选中
- (void)didClickedButtonPressedSelectedSynBillingModel:(JGJSynBillingModel *)addressBookModel;

//重写以下方法
- (IBAction)confirmSynButtonPressed:(UIButton *)sender;//重写按钮
- (void)loadNetData;
- (void)commonSet;
- (void)jsonWithModel;//获取数据
//每次刷新之后和已选择的数据作比较
- (void)refreshSelelctedDataSource:(NSMutableArray *)dataSource;
//    根据数据排序
- (void)searchSynBillingModel:(NSMutableArray *)synBillingModels;
@end

@interface WageMoreDetailInitModel : TYModel

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,assign) NSInteger infoId;
@property (nonatomic,assign) NSInteger cur_uid;
@property (nonatomic,assign) WageDetailFilterType wageDetailFilterType;
@property (nonatomic, copy) NSString *sync_id;//需要同步项目的id 1.0添加
@property (nonatomic, copy) NSString *pro_name;//项目名字
@end
