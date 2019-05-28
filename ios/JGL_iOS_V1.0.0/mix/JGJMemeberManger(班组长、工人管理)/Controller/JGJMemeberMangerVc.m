//
//  JGJMemeberMangerVc.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemeberMangerVc.h"

#import "JGJAccountingMemberCell.h"

#import "JGJMemeberMangerDetailVc.h"

#import "JGJSurePoorbillViewController.h"

#import "JGJFilterBottomButtonView.h"

#import "JGJMemeberMangerCell.h"

#import "JGJMemberMangerAppraiseVc.h"

#import "UILabel+GNUtil.h"

#import "JGJCustomPopView.h"

#import "JGJComHeaderView.h"

#import "CFRefreshStatusView.h"

#import "JGJWageLevelViewController.h"
#import "JGJCusActiveSheetView.h"
#import "JGJCusBottomSelBtnView.h"
@interface JGJMemeberMangerVc ()<JGJMemeberMangerCellDelegate, JGJComHeaderViewDelegate>

{
    
    BOOL _isCancelStatus;//普通状态和更多操作状态
    NSInteger _delMembersOrBatchSetWages;// 0 代表批量设置工资 1 代表删除工人
}

@property (nonatomic, strong) JGJFilterBottomButtonView *buttonView;

@property (nonatomic, strong) JGJCusBottomSelBtnView *cusSelBtnView;

//顶部描述信息
@property (nonatomic, strong) UILabel *topDesLable;

@property (nonatomic, strong) NSMutableArray *selMembers;

@property (nonatomic, strong) JGJComHeaderView *headerView;

@end

@implementation JGJMemeberMangerVc

@synthesize firstSectionInfos = _firstSectionInfos;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = JLGisMateBool ? @"班组长" : @"工人管理";
    
    self.title = title;
    
    self.memberType = AddGroupMangerMember;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    
    [self.view addSubview:self.cusSelBtnView];
    [self.view addSubview:self.topDesLable];
    
    //默认不显示全选状态
    
    [self setHeaderStatus:NO];
    
    [self beginReFresh];
    
}

- (void)subViewWillAppear:(BOOL)animated {
    
    self.searchbar.searchBarTF.text = nil;
    
    [self searchWithValue:nil];
    
    [self.tableView reloadData];
}

- (void)registerSubClassSearchWithValue:(NSString *)value {
    
    BOOL isHidden = ![NSString isEmpty:value];
    
    self.headerView.hidden = isHidden;
    
    if (isHidden) {
        
        self.headerView.height = 0;
        self.cusSelBtnView.leftBtn.hidden = YES;
        
    } else {
        
        self.headerView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 36);
        self.cusSelBtnView.leftBtn.hidden = NO;
    }
    
    if (!_isCancelStatus) {
        
        self.cusSelBtnView.hidden = YES;
    }
}

- (void)setHeaderStatus:(BOOL)isShowAllSel {
    
    if (_delMembersOrBatchSetWages == 0) {
        
        if (self.selMembers.count > 0) {
            
            [self.cusSelBtnView.rightBtn setTitle:[NSString stringWithFormat:@"批量设置工资标准(%ld)",self.selMembers.count] forState:(UIControlStateNormal)];
        }else {
            
            [self.cusSelBtnView.rightBtn setTitle:@"批量设置工资标准" forState:(UIControlStateNormal)];
        }
        
    }else {
        
        if (self.selMembers.count > 0) {
            
            [self.cusSelBtnView.rightBtn setTitle:[NSString stringWithFormat:JLGisMateBool ? @"删除班组长(%ld)" : @"删除工人(%ld)",self.selMembers.count] forState:(UIControlStateNormal)];
        }else {
            
            [self.cusSelBtnView.rightBtn setTitle:JLGisMateBool ? @"删除班组长": @"删除工人" forState:(UIControlStateNormal)];
        }
        
    }
    self.headerView.isShowAllSelBtn = NO;
    
    self.headerView.title = [NSString stringWithFormat:@"常选%@", JLGisLeaderBool ? @"工人" : @"班组长"];
}

- (CGRect)setSubTableViewFrame {
    
    CGRect rect = CGRectMake(0, SearchbarHeight + self.topDesLable.height, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - SearchbarHeight - self.topDesLable.height - (_isCancelStatus ? self.cusSelBtnView.height : 0));
    
    return rect;
}

- (void)setSeachbarConstantWithSearchbar:(JGJCustomSearchBar *)searchbar {
    
    searchbar.frame = CGRectMake(0, TYGetMaxY(self.topDesLable), TYGetUIScreenWidth, SearchbarHeight);
    
}


#pragma mark - 重写父类选中人员
- (void)workMangerSubClassSelectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.memberType == AddOtherMemberType) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.memberType == AddSingleMemberType){ //工人管理添加后直接返回
        
        [self beginReFresh];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
        
    } else {
        
        //取消状态
        if (_isCancelStatus) {
            
            memberModel.isSelected = !memberModel.isSelected;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid==%@",memberModel.uid];
            
            NSArray *existMembers = [self.selMembers filteredArrayUsingPredicate:predicate];
            
            if (memberModel.isSelected && existMembers.count == 0) {
                
                [self.selMembers addObject:memberModel];
                
            }else {
                
                JGJSynBillingModel *existModel = existMembers.firstObject;
                
                [self.selMembers removeObject:existModel];
                
            }
            
            JGJMemeberMangerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.workerManger = memberModel;
            
            [self setHeaderSelectedStatus];
            
            //用于显示全选数量
            [self setHeaderStatus:_isCancelStatus];
            
        }else {
            
            JGJMemeberMangerDetailVc *detailVc = [[JGJMemeberMangerDetailVc alloc] init];
            
            detailVc.memberModel = memberModel;
            
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }
        
    }
    
}

#pragma mark - 设置头部状态
- (void)setHeaderSelectedStatus {
    
    if (self.selMembers.count > 0) {
        
        self.cusSelBtnView.leftBtn.selected = self.selMembers.count == self.accountMembers.count;
        
    }else {
        
        self.cusSelBtnView.leftBtn.selected = NO;
        
    }
    
    if (self.cusSelBtnView.leftBtn.selected) {
        
        [self.cusSelBtnView.leftBtn setTitle:@"取消全选" forState:(UIControlStateNormal)];
        _cusSelBtnView.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _cusSelBtnView.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
    }else {
        
        [self.cusSelBtnView.leftBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        _cusSelBtnView.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _cusSelBtnView.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    }
    
}

- (void)selMemberStatus:(JGJSynBillingModel *)memberModel {
    
    
}

#pragma mark - 更多操作按钮按下
- (void)rightItemPressed {
    
    [self.view endEditing:YES];
    [self setPageStatus];
    
    TYLog(@"---更多操作按钮按下");
}

- (void)setPageStatus {
    
    if (_isCancelStatus) {// 当前是 取消状态
        
        _isCancelStatus = !_isCancelStatus;
        CGFloat height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - SearchbarHeight - self.topDesLable.height;
        
        self.navigationItem.rightBarButtonItem.title = @"更多";
        
        for (JGJSynBillingModel *memberModel in self.selMembers) {
            
            memberModel.isSelected = NO;
            
        }
        
        [self.selMembers removeAllObjects];
        
        [self setHeaderSelectedStatus];
        
        [self setHeaderStatus:_isCancelStatus];
        [self searchWithValue:nil];
        
        self.cusSelBtnView.hidden = YES;
        
        self.tableView.height = height;
        
        [self.tableView reloadData];
        
    }else {// 当前是 更多 状态
        
        NSArray *buttons = @[@"批量设置工资标准", JLGisMateBool ? @"删除班组长": @"删除工人", @"取消"];
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongself = self;
        
        JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
            
            if (buttonIndex != 2) {
                
                strongself -> _delMembersOrBatchSetWages = buttonIndex;
                _isCancelStatus = !_isCancelStatus;
                CGFloat height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - SearchbarHeight - weakSelf.cusSelBtnView.height - weakSelf.topDesLable.height;
                
                weakSelf.navigationItem.rightBarButtonItem.title = @"取消";
                [weakSelf setHeaderSelectedStatus];
                
                [weakSelf setHeaderStatus:_isCancelStatus];
                
                weakSelf.cusSelBtnView.hidden = NO;
                weakSelf.cusSelBtnView.leftBtn.hidden = NO;
                
                if (buttonIndex == 0) {
                    
                    [weakSelf.cusSelBtnView.rightBtn setTitle:@"批量设置工资标准" forState:(UIControlStateNormal)];
                    
                }else {
                    
                    [weakSelf.cusSelBtnView.rightBtn setTitle:JLGisMateBool ? @"删除班组长": @"删除工人" forState:(UIControlStateNormal)];
                }
                
                weakSelf.tableView.height = height;
                
                [weakSelf.tableView reloadData];
            }
        }];
        
        [sheetView showView];
    }
    
}

- (void)searchAccountMember {
    
    [self setHeaderSelectedStatus];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView selMemberCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemeberMangerCell *memberCell = [JGJMemeberMangerCell cellWithTableView:tableView];
    
    memberCell.isCancelStatus = _isCancelStatus;
    
    memberCell.delegate = self;
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section - 1];
    
    JGJSynBillingModel *memberModel = sortFindResultModel.findResult[indexPath.row];
    
    memberCell.searchValue = self.searchValue;
    
    memberCell.workerManger = memberModel;
    
    memberCell.lineViewH.constant = sortFindResultModel.findResult.count - 1 == indexPath.row ? CGFLOAT_MIN : 10;
    
    memberCell.centerY.constant = sortFindResultModel.findResult.count - 1 == indexPath.row ? CGFLOAT_MIN : -5;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.contactsLetters.count > ShowCount) {
        
        memberCell.trail.constant = 40;
        
    }else {
        
        memberCell.trail.constant = 12;
    }
    
    return memberCell;
}

- (CGFloat)registerSubClassWithtableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indexPath.section - 1];
    
    JGJSynBillingModel *memberModel = sortFindResultModel.findResult[indexPath.row];
    
    if (self.contactsLetters.count > ShowCount) {
        
        memberModel.is_show_indexes = YES;
        
    }
    
    CGFloat height = JGJMemberRowH;
    
    if (!_isCancelStatus) {
        
        height = JGJMemberRowH - 13 + memberModel.work_manger_height;
    }
    
    if (sortFindResultModel.findResult.count -1 == indexPath.row) {
        
        height -= 10;
    }
    
    return height;
}

#pragma mark - 子类使用
- (void)setMemberWithCell:(JGJAccountingMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel {
    
    cell.isShowDelButton = self.isShowDelButton;
    
    cell.searchValue = self.searchValue;
    
    cell.workerManger = memberModel;
    
    TYWeakSelf(self);
    
    cell.checkAccountButtonPressedBlock = ^(JGJAccountingMemberCell *cell) {
        
        [weakself checkAccountWithMemberModel:cell.workerManger];
    };
}

#pragma mark - 对账
- (void)checkAccountWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
    
    poorBillVC.uid = memberModel.uid;
    
    [self.navigationController pushViewController:poorBillVC animated:YES];
    
    TYWeakSelf(self);
    
    poorBillVC.successBlock = ^{
        
        [weakself beginReFresh];
        
    };
    
}

#pragma mark - 重写父类选择顶部类型
- (void)setTopInfoSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self normalWorkerDidSelectRowAtIndexPath:indexPath];
}

#pragma mark - 请求接口
- (NSString *)requestApi {
    
    return @"workday/worker-role-list";
}

- (void)memeberMangerCell:(JGJMemeberMangerCell *)cell btnType:(JGJMemeberMangerCellBtnType)btnType {
    
    switch (btnType) {
            
        case EvaBtnType:{
            
            [self evaBtnPressedWithMemberModel:cell.workerManger];
        }
            
            break;
            
        case checkAccountBtnType:{
            
            [self checkAccountWithMemberModel:cell.workerManger];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 评价按钮按下
- (void)evaBtnPressedWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJMemberMangerAppraiseVc *appraiseVc = [[JGJMemberMangerAppraiseVc alloc] init];
    
    appraiseVc.memberModel = memberModel;
    
    [self.navigationController pushViewController:appraiseVc animated:YES];
    
    TYWeakSelf(self);
    
    //评价成功之后，工人管理is_comment设置为NO
    
    appraiseVc.successBlock = ^{
        
        memberModel.is_comment = NO;
        
        [weakself.tableView reloadData];
        
    };
}

#pragma mark - JGJComHeaderViewDelegate
- (void)headerView:(JGJComHeaderView *)headerView isAllSel:(BOOL)isAllSel {
    
    [self.selMembers removeAllObjects];
    
    headerView.selBtn.selected = isAllSel;
    
    for (NSInteger indx = 0; indx < self.sortContactsModel.sortContacts.count; indx++) {
        
        SortFindResultModel *sortFindResultModel = self.sortContactsModel.sortContacts[indx];
        
        for (JGJSynBillingModel *memberModel in sortFindResultModel.findResult) {
            
            memberModel.isSelected = isAllSel;
            
            if (memberModel.isSelected && ![NSString isEmpty:memberModel.uid]) {
                
                [self.selMembers addObject:memberModel];
                
            }
        }
    }
    
    //用于显示全选数量
    
    [self setHeaderStatus:_isCancelStatus];
    
    [self.tableView reloadData];
}

#pragma mark - 头添加全选按钮

- (void)handleNoList:(NSArray *)list  {
    
    if (list.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        _isCancelStatus = NO;
        
        CGFloat height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - JGJ_IphoneX_BarHeight;
        
        self.tableView.height = height;
        
        self.cusSelBtnView.hidden = YES;
        
    } else {
        
        self.tableView.tableHeaderView = self.headerView;
        
    }
    
}

#pragma mark - 重写父类的getter方法
- (NSMutableArray *)firstSectionInfos {
    
    if (!_firstSectionInfos) {
        
        _firstSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"常选班组长"];
        
        NSArray *desTitles = @[@""];
        
        //工头身份
        if (JLGisLeaderBool) {
            
            titles = @[@"常选工人"];
            
        }
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJCommonInfoDesModel *infoDesModel = [JGJCommonInfoDesModel new];
            
            infoDesModel.title = titles[index];
            
            infoDesModel.des = desTitles[index];
            
            infoDesModel.isHidden = index == titles.count - 1;
            
            infoDesModel.leading = index == 1 ? 0 : 10;
            
            infoDesModel.trailing = infoDesModel.leading;
            
            NSString *imageStr = nil;
            
            if (index == 0) {
                
                imageStr = @"from_addressbook_icon";
                
            }else if (index == 1) {
                
                imageStr = @"from_tel_icon";
                
            }
            
            infoDesModel.imageStr = imageStr;
            
            [_firstSectionInfos addObject:infoDesModel];
        }
        
    }
    
    return _firstSectionInfos;
    
}

- (JGJCusBottomSelBtnView *)cusSelBtnView {
    
    if (!_cusSelBtnView) {
        
        CGFloat height = (TYIST_IPHONE_X ? JGJ_IphoneX_BarHeight : 0) + 60;
        _cusSelBtnView = [[JGJCusBottomSelBtnView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT, TYGetUIScreenWidth, height)];
        _cusSelBtnView.hidden = YES;
        
        [_cusSelBtnView.leftBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        TYWeakSelf(self);
        __strong typeof(self) strongself = self;
        _cusSelBtnView.leftBlock = ^(UIButton *sender) {// 全选
            
            sender.selected = !sender.selected;
            
            [weakself.selMembers removeAllObjects];
            for (NSInteger indx = 0; indx < weakself.accountMembers.count; indx++) {
                
                JGJSynBillingModel *memberModel = weakself.accountMembers[indx];
                memberModel.isSelected = sender.selected;
                
                if (memberModel.isSelected && ![NSString isEmpty:memberModel.uid]) {
                    
                    [weakself.selMembers addObject:memberModel];
                    
                }
            }
            
            [weakself.tableView reloadData];
            
            if (sender.selected) {
                
                [weakself.cusSelBtnView.leftBtn setTitle:@"取消全选" forState:(UIControlStateNormal)];
                weakself.cusSelBtnView.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                weakself.cusSelBtnView.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            }else {
                
                [weakself.cusSelBtnView.leftBtn setTitle:@"全选" forState:(UIControlStateNormal)];
                weakself.cusSelBtnView.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
                weakself.cusSelBtnView.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
                
            }
            
            if (self.selMembers.count > 0) {
                
                if (strongself -> _delMembersOrBatchSetWages == 0) {
                    
                    [weakself.cusSelBtnView.rightBtn setTitle:[NSString stringWithFormat:@"批量设置工资标准(%ld)",weakself.selMembers.count] forState:(UIControlStateNormal)];
                }else {
                    
                    [weakself.cusSelBtnView.rightBtn setTitle:[NSString stringWithFormat:JLGisMateBool ? @"删除班组长(%ld)" : @"删除工人(%ld)" ,weakself.selMembers.count] forState:(UIControlStateNormal)];
                }
            }else {
                
                if (strongself -> _delMembersOrBatchSetWages == 0) {
                    
                    [weakself.cusSelBtnView.rightBtn setTitle:@"批量设置工资标准" forState:(UIControlStateNormal)];
                }else {
                    
                    [weakself.cusSelBtnView.rightBtn setTitle:JLGisMateBool ? @"删除班组长" : @"删除工人" forState:(UIControlStateNormal)];
                }
            }
            
        };
        
        _cusSelBtnView.rightBlock = ^(UIButton *sender) {// 批量设置工资 或者 删除工人
            
            if (weakself.selMembers.count == 0 || !weakself.selMembers) {
                
                NSString *des = [NSString stringWithFormat:@"你还未选择任何%@", JLGisLeaderBool ? @"工人" : @"班组长"];
                
                [TYShowMessage showPlaint:des];
                
                return ;
            }
            
            if (strongself -> _delMembersOrBatchSetWages == 0) {// 批量设置工资
                
                if (weakself.selMembers.count > 0) {
                    
                    [weakself setWages];
                    
                }
                
            }else {// 删除工人
                
                if (weakself.selMembers.count > 0) {
                    
                    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
                    
                    desModel.popDetail = @"选择删除的用户中，如果有无电话号码的用户，删除后将无法对该类用户记工记账。确定要删除吗？";
                    
                    desModel.popTextAlignment = NSTextAlignmentLeft;
                    
                    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
                    
                    alertView.onOkBlock = ^{
                        
                        [weakself delMembers];
                        
                    };
                    
                }
            }
            
        };
    }
    return _cusSelBtnView;
}

#pragma mark - 批量删除
- (void)delMembers {
    
    NSMutableArray *uidArr = [[NSMutableArray alloc] init];
    
    for (JGJSynBillingModel *memberModel in self.selMembers) {
        
        if (![NSString isEmpty:memberModel.uid]) {
            
            [uidArr addObject:memberModel.uid];
        }
        
    }
    
    if (uidArr.count == 0) {
        
        return;
    }
    
    NSString *uids = [uidArr componentsJoinedByString:@","];
    
    NSDictionary *parameters = @{@"uids" : uids};
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/del-fm" parameters:parameters success:^(id responseObject) {
        
        //删除后移除成员
        
        [self.selMembers removeAllObjects];
        
        [self searchWithValue:nil];
        
        [self beginReFresh];
        
        _isCancelStatus = YES;
        
        [self setPageStatus];
        
        [TYLoadingHub hideLoadingView];
        
        NSString *des = [NSString stringWithFormat:@"删除%@成功", JLGisLeaderBool ? @"工人" : @"班组长"];
        
        [TYShowMessage showSuccess:des];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 批量设置工资
- (void)setWages{
    
    JGJWageLevelViewController *wageLevelVc = [[UIStoryboard storyboardWithName:@"JGJWageLevelVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWageLevelVC"];
    
    wageLevelVc.wagesMembers = self.selMembers;
    wageLevelVc.yzgGetBillModel = [[YZGGetBillModel alloc] init];
    
    TYWeakSelf(self);
    
    wageLevelVc.setWageLevelSuccess = ^{
        
        //返回的时候移除数据
        
        [weakself.selMembers removeAllObjects];
        
        [weakself headerView:self.headerView isAllSel:NO];
        
        _isCancelStatus = YES;
        
        [weakself setPageStatus];
        
        [weakself.tableView reloadData];
        
    };
    
    [self.navigationController pushViewController:wageLevelVc animated:YES];
}

- (UILabel *)topDesLable {
    
    if (!_topDesLable) {
        
        _topDesLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 51)];
        
        _topDesLable.textColor = AppFontFF6600Color;
        
        _topDesLable.numberOfLines = 0;
        
        _topDesLable.font = [UIFont boldSystemFontOfSize:AppFont26Size];
        
        if (TYGetUIScreenWidth <= 375) {
            
            _topDesLable.font = [UIFont boldSystemFontOfSize:12];
        }
        
        _topDesLable.backgroundColor = AppFontFDF1E0Color;
        
        NSString *role = JLGisLeaderBool ? @"工人" : @"班组长";
        
        NSString *desInfo = [NSString stringWithFormat:@"记工完成后，记工对象自动加入该列表\n可以删除、修改、评价%@以及批量设置多个%@的工资标准", role, role];
        
        [_topDesLable setAttributedText:desInfo lineSapcing:5 textAlign:NSTextAlignmentCenter];
        
    }
    
    return _topDesLable;
}

- (NSMutableArray *)selMembers {
    
    if (!_selMembers) {
        
        _selMembers = [[NSMutableArray alloc] init];
    }
    
    return _selMembers;
}

- (JGJComHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[JGJComHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
        
        _headerView.delegate = self;
        
    }
    
    return _headerView;
}

@end
