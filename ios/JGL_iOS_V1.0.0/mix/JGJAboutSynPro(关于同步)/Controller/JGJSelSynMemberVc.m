//
//  JGJSelSynMemberVc.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSelSynMemberVc.h"

#import "JGJSelSynMemberCell.h"

#import "JGJAccountingMemberCell.h"

#import "JGJAboutSynRequestModel.h"
#import "JGJAddAccountMemberInfoVc.h"
#import "JGJSynAddressBookVC.h"
@interface JGJSelSynMemberVc ()<YZGAddContactsHUBViewDelegate>

@end



@implementation JGJSelSynMemberVc

@synthesize addWorkerContactsHUBView = _addWorkerContactsHUBView;

@synthesize firstSectionInfos = _firstSectionInfos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择同步对象";
    
    if (self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
        
        self.title = @"邀请他人向我同步";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求接口
- (NSString *)requestApi {
    
    return @"jlworksync/getusersynclist";
}

#pragma mark - 记账请求
- (void)accountMemberRequest{
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:[self requestApi] parameters:nil success:^(NSArray *responseObject) {
        
        [self handleSuccessResponse:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (NSPredicate *)setMemberPredicate {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"target_uid=%@",self.seledAccountMember.target_uid];
    
    return predicate;
}

#pragma mark - 重写父类
- (NSString *)delMemberApi {
    
    return @"jlworksync/delusersync";
}

#pragma mark - 重写父类
- (NSDictionary *)delParametersWithUid:(NSString *)uid {
    
    return @{@"uid" : uid ?:@""};
}

#pragma mark - YZGAddContactsHUBViewDelegate
- (void)AddContactsHubSaveBtcClick:(YZGAddContactsHUBView *)contactsView {
    
    [self popToReleaseBillVc:contactsView.yzgAddForemanModel];
    //    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    //
    //    memberModel.name = contactsView.nameTF.text;
    //
    //    memberModel.telph = contactsView.phoneNumTF.text;
    //
    //    [self addSynMemberWithMemberModel:memberModel contactsView:contactsView];
    //
    //    //要求同步
    //    if (self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
    //
    //        [self requireMemberSynWithMemberModel:memberModel];
    //
    //    }
    
}

#pragma mark - YZGAddContactsHUBViewDelegate
//- (void)AddContactsHubSaveBtcClick:(YZGAddContactsHUBView *)contactsView {
//
//    [self popToReleaseBillVc:contactsView.yzgAddForemanModel];
//}

- (void)popToReleaseBillVc:(YZGAddForemanModel *)addForemanModel{
    
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    
    memberModel.uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    
    //同步项目的话使用的是target_uid
    if (self.addWorkerContactsHUBView.hubViewType == YZGAddContactsHUBViewSynType) {
        
        memberModel.target_uid = [NSString stringWithFormat:@"%@", @(addForemanModel.uid)];
    }
    
    memberModel.telph = addForemanModel.telph;
    
    memberModel.name = addForemanModel.name;
    
    [self selectedMemberWithMemberModel:memberModel];
    
}

#pragma mark - 选中同步人员
- (void)selectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    //已经存在直接返回
    if (memberModel.isExistedSynMember) {
        
        [self handleSynMemberWithMember:memberModel];
        
    }else {
        
        [self addSynMemberWithMemberModel:memberModel contactsView:nil];
        
    }
    
    //要求同步
    if (self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
        
        [self requireMemberSynWithMemberModel:memberModel];
        
    }
    
}

- (void)addSynMemberWithMemberModel:(JGJSynBillingModel *)memberModel contactsView:(YZGAddContactsHUBView *)contactsView {
    
    TYWeakSelf(self);
    
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    
    if ([myTel isEqualToString:memberModel.telph]) {
        
        [TYShowMessage showPlaint:@"无法对自己同步项目！"];
        
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/optusersync" parameters:@{@"realname":memberModel.name,@"telph":memberModel.telph,@"descript":@"",@"option":@"a"} success:^(id responseObject) {
        
        YZGAddForemanModel *yzgAddForemanModel = [YZGAddForemanModel new];
        
        yzgAddForemanModel.telph = memberModel.telph;
        
        yzgAddForemanModel.name = memberModel.name;
        
        yzgAddForemanModel.uid = [responseObject[@"target_uid"] integerValue];
        
        memberModel.target_uid = [NSString stringWithFormat:@"%@", responseObject[@"target_uid"]];
        
        if (weakself.hubViewType != YZGAddContactsHUBViewSynToMeType) {
            
            [weakself handleSynMemberWithMember:memberModel];
            
            //            [TYShowMessage showSuccess:@"添加成功！"];
            
        }else if (weakself.hubViewType == YZGAddContactsHUBViewSynToMeType) {
            
            //当前页面添加不返回
            if (contactsView) {
                
                [contactsView removeFromSuperview];
                
                [weakself beginReFresh];
                
            }
            
        }
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)requireMemberSynWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJRequireSynRequestModel *requireModel = [JGJRequireSynRequestModel new];
    
    requireModel.name = memberModel.name;
    
    requireModel.telph = memberModel.telephone;
    
    NSDictionary *parameters = [requireModel mj_keyValues];
    
    NSString *myTel = [TYUserDefaults objectForKey:JLGPhone];
    
    //不能同步自己
    
    if ([memberModel.telph isEqualToString:myTel]) {
        
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    //    GET /sync/ask-user-to-sync
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/askUserToSync" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"发送成功！"];
        
        [self handleSynToMeSkipVc];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
    
}

- (void)handleSynMemberWithMember:(JGJSynBillingModel *)memberModel {
    
    if (self.accountingMemberVCSelectedMemberBlock) {
        
        self.accountingMemberVCSelectedMemberBlock(memberModel);
        
    }
    
    //返回到新增同步页面
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJAddSynInfoVc")]) {
            
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
        
    }
    
}

#pragma mark - 处理同步给我的添加成功然后跳转
- (void)handleSynToMeSkipVc {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJSynRecordParentVc")]) {
            
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
        
    }
}

//- (JGJAccountingMemberCell *)selMemberCellWithTableView:(UITableView *)tableView {
//
//    JGJAccountingMemberCell *memberCell = [JGJAccountingMemberCell cellWithTableView:tableView];
//
//    memberCell.isHiddenName = YES;
//
//    return memberCell;
//}

#pragma mark - 子类使用
- (void)setMemberWithCell:(JGJAccountingMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel {
    
    //    cell.isHiddenName = YES;
    
    cell.searchValue = self.searchValue;
    
    cell.accountMember = memberModel;
    
    cell.isShowDelButton = self.isShowDelButton;
}

#pragma mark - 没有记账人员去掉常选工人、班组长最后一个标识
- (void)cancelFirstSectionLastRowInfo {
    
    if (self.accountMembers.count == 0 && self.firstSectionInfos.count > 0) {
        
        JGJCommonInfoDesModel *infoDesModel = self.firstSectionInfos.lastObject;
        
        infoDesModel.title = @"";
        
    }else if (self.accountMembers.count > 0) {
        
        JGJCommonInfoDesModel *infoDesModel = self.firstSectionInfos.lastObject;
        
        infoDesModel.title = @"常用同步对象";
        
    }
    
}

#pragma mark - 重写父类获取对应点的id
- (NSString *)delMemberWithMember:(JGJSynBillingModel *)member {
    
    NSString *uid = [NSString stringWithFormat:@"%@", member.target_uid];
    
    return uid;
}

- (void)setTopInfoSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [self normalWorkerDidSelectRowAtIndexPath:indexPath];
    self.memberType = AddOtherMemberType;
    
    switch (indexPath.row) {
        case 0:{
            
            [self addTelContacts];
        }
            break;
        case 1:{
            
            
            if (self.hubViewType == YZGAddContactsHUBViewSynType || self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
                
                [self addSingleAccountMemberModel];
                
            }else {
                
                [self addAccountMemberInfo];
            }
            
            self.memberType = AddSingleMemberType;
            
        }
            
            break;
        default:
            break;
    }
}

#pragma mark - 添加单个人员
- (void)addSingleAccountMemberModel {
    
    if (!self.addWorkerContactsHUBView.delegate) {
        
        self.addWorkerContactsHUBView.delegate = self;
    }
    
    [self.addWorkerContactsHUBView showAddContactsHubView];
}

- (void)addAccountMemberInfo {
    
    JGJAddAccountMemberInfoVc *addMemberInfoVc = [[JGJAddAccountMemberInfoVc alloc] init];
    
    //是否是记得承包
    
    addMemberInfoVc.contractor_type = self.contractor_type;
    
    addMemberInfoVc.workProListModel = self.workProListModel;
    
    [self.navigationController pushViewController:addMemberInfoVc animated:YES];
    
    TYWeakSelf(self);
    
    addMemberInfoVc.addAccountMemberInfoVcBlock = ^(JGJSynBillingModel *memberModel) {
        
        [weakself selectedMemberWithMemberModel:memberModel];
        
    };
}

#pragma mark - 添加通讯录
- (void)addTelContacts{
    
    JGJSynAddressBookVC *synAddressBookVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynAddressBookVC"];
    
    synAddressBookVC.synBillingModels = self.accountMembers.mutableCopy ;
    
    synAddressBookVC.addressBookAddButtonType = [self buttonType];
    
    synAddressBookVC.dataArray = [self.accountMembers  mutableCopy];
    
    synAddressBookVC.workProListModel = self.workProListModel;
    
    synAddressBookVC.hubViewType = self.hubViewType;
    
    synAddressBookVC.contractor_type = self.contractor_type;
    
    [self.navigationController pushViewController:synAddressBookVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //通讯录选择回调
    synAddressBookVC.addSynModelBlock = ^(JGJSynBillingModel *accountMember) {
        
        //返回到对应页面
        [weakSelf selectedMemberWithMemberModel:accountMember];
        
    };
}

#pragma mark - 同步按钮下的类型
- (AddressBookAddButtonType)buttonType {
    
    return AddressBookAddWorkerButton;
    
}

- (YZGAddContactsHUBView *)addWorkerContactsHUBView
{
    if (!_addWorkerContactsHUBView) {
        
        _addWorkerContactsHUBView = [[YZGAddContactsHUBView alloc] initWithFrame:self.view.bounds];
        
        _addWorkerContactsHUBView.hubViewType =  self.hubViewType == YZGAddContactsHUBViewSynToMeType? YZGAddContactsHUBViewSynToMeType : YZGAddContactsHUBViewSynType;
        
    }
    
    return _addWorkerContactsHUBView;
}

- (NSMutableArray *)firstSectionInfos {
    
    if (!_firstSectionInfos) {
        
        _firstSectionInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"从手机联系人选择", @"手动新增同步对象", @"常用同步对象"];
        
        NSArray *desTitles = @[@"选择手机通讯录中的联系人", @"输入电话号码和姓名", @""];
        
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
            
            infoDesModel.trailing = infoDesModel.leading;
            
            [_firstSectionInfos addObject:infoDesModel];
        }
        
    }
    
    return _firstSectionInfos;
    
}

@end
