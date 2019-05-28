//
//  JGJAddAccountMemberInfoVc.m
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddAccountMemberInfoVc.h"

#import "JGJAddAccountMemberInfoCell.h"

#import "JGJCustomPopView.h"

#import "JGJMemberMangerRequestModel.h"

#import "JGJMemberMangerModel.h"

//承包对象 15个字

#define UndertakNameLength 15

typedef void(^MemberRealNameBlock)(id);

@interface JGJAddAccountMemberInfoVc ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJAddUserRequest *request;

@property (nonatomic, copy) MemberRealNameBlock memberRealNameBlock;

//获取对账开关的状态
@property (nonatomic, strong) JGJWorkdayGetRecordConfirmOffStatusModel *statusModel;

@end

@implementation JGJAddAccountMemberInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(checkRecordConfirmSwitch)];
    
    self.title = JLGisLeaderBool ? @"添加工人" : @"添加班组长";
    
    if ([self.contractor_type isEqualToString:@"1"]) {
        
        self.title = @"添加承包对象";
    }
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self numberOfRowWithSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        cell = [self registerMemberInfoCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        cell = [self registerSubOtherCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }
    
    return cell;

}

#pragma mark - 子类使用
- (UITableViewCell *)registerSubOtherCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell  cellWithTableViewNotXib:tableView];
    
    
    return cell;
}

- (UITableViewCell *)registerMemberInfoCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAddAccountMemberInfoCell *cell = [JGJAddAccountMemberInfoCell cellWithTableView:tableView];
    
    cell.contractor_type = self.contractor_type;
    
    cell.desModel = self.dataSource[indexPath.row];
    
    cell.topLineView.hidden = indexPath.row == 1;
    
    TYWeakSelf(self);
    
    cell.accountMemberInfoCellBlock = ^(JGJCommonInfoDesModel *desModel) {
        
        [weakself checkInputTelephone:desModel.des];
    };
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self registerSubClassWithTableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 子类使用
- (void)registerSubClassWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark - 子类使用确定行数
- (NSInteger)numberOfRowWithSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - 检测对账是否开关

- (void)checkRecordConfirmSwitch {
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-record-confirm-off-status" parameters:nil success:^(id responseObject) {
        
        JGJWorkdayGetRecordConfirmOffStatusModel *statusModel = [JGJWorkdayGetRecordConfirmOffStatusModel mj_objectWithKeyValues:responseObject];
        
        self.statusModel = statusModel;
    
        [self saveMemberInfoItemPressed];
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

#pragma mark - 保存成员信息按下
- (void)saveMemberInfoItemPressed {
    
    [self.view endEditing:YES];
    
    JGJCommonInfoDesModel *nameDesModel = self.dataSource.firstObject;
    
    JGJCommonInfoDesModel *telDesModel = self.dataSource.lastObject;
    
    self.request.name = nameDesModel.des;
    
    self.request.telph = telDesModel.des;
    
    if ([NSString isEmpty:nameDesModel.des]) {
        
        [TYShowMessage showPlaint:@"请输入对方的姓名"];
        
        return;
        
    }else if ([self.contractor_type isEqualToString:@"1"]) {
        
        if (nameDesModel.des.length < 2 || nameDesModel.des.length > UndertakNameLength) {
            
            [TYShowMessage showPlaint:@"姓名只能为二到十五个字"];
            
            return;
        }
        
    } else if (nameDesModel.des.length < 2 || nameDesModel.des.length > 10) {
        
        [TYShowMessage showPlaint:@"姓名只能为二到十个字"];
        
        return;
    }
    
    if ([NSString isEmpty:telDesModel.des] && ![NSString isEmpty:nameDesModel.des]) {
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        
        NSString *des = @"填写对方的手机号码，可以让对方更快与你在线对账，避免差异。确定不填写吗？";
        
        if ([self.contractor_type isEqualToString:@"1"]) {
            
//            1  //表示关闭 ；0:表示开启
            
            des = [self.statusModel.status isEqualToString:@"1"] ? @"填写电话号码后能找回误删的记工记录。确定不填写承包对象电话吗？" : @"填写对方的手机号码，可以让对方更快与你在线对账，避免差异。确定不填写承包对象电话吗？";
            
        }else {
            
            if ([self.statusModel.status isEqualToString:@"1"]) {
                
                des = @"填写电话号码后能找回误删的记工记录。确定不填写吗";
                
            }else {
                
                des = @"填写对方的手机号码，可以让对方更快与你在线对账，避免差异。确定不填写吗？";
                
            }
            
        }
        
        desModel.popDetail = des;
        
        desModel.leftTilte = @"不填写";
        
        desModel.rightTilte = @"继续填写";
        
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        __weak typeof(self) weakSelf = self;

        alertView.leftButtonBlock = ^{
            
            [weakSelf addUserInfoRequest];
            
        };
        
    }
    
    if (![NSString isEmpty:telDesModel.des] && ![NSString isEmpty:nameDesModel.des]) {
        
        [self addUserInfoRequest];
        
    }
    
}

#pragma mark - 添加用户信息请求
- (void)addUserInfoRequest {
    
    self.request.group_id = self.workProListModel.group_id;
    
    self.request.contractor_type = self.contractor_type;
    
    NSDictionary *body = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/add-fm" parameters:body success:^(id responseObject) {
        
        JGJSynBillingModel *memberModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
        
        if (self.addAccountMemberInfoVcBlock) {
            
            self.addAccountMemberInfoVcBlock(memberModel);
        }
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - 获取成员在我们平台注册之后的姓名
- (void)getMemberRealName {
    
    JGJCommonInfoDesModel *desModel = self.dataSource.lastObject;
    
    if ([NSString isEmpty:desModel.des]) {
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"telephone" : desModel.des ?:@""
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/useTelGetUserInfo" parameters:parameters success:^(id responseObject) {
        
        if (weakSelf.memberRealNameBlock) {
            
            weakSelf.memberRealNameBlock(responseObject);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - 判断是否输入数字进行判断
- (void)checkInputTelephone:(NSString *)telephone {
    
    if ([NSString isInputNum:telephone] && telephone.length == 11) {
        
        [self getMemberRealName];
        
        TYWeakSelf(self);
        
        JGJCommonInfoDesModel *desModel = self.dataSource.firstObject;
        
        self.memberRealNameBlock = ^(id responseObject) {
          
            JGJSynBillingModel *memberModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
            
            if (![NSString isEmpty:memberModel.real_name] && [memberModel.real_name isKindOfClass:[NSString class]]) {
                
                desModel.des = memberModel.real_name;
                
            }
            
//            else {
//                
//                desModel.des = nil;
//                                
//                desModel.placeholder = JLGisMateBool ? @"请输入班组长的姓名" : @"请输入工人的姓名";
//            }
            
            [weakself.tableView beginUpdates];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [weakself.tableView endUpdates];
            
        };
    }
    
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
        NSString *comRemark = @"(可以不填)";
        
        NSString *roleRemark  = [NSString stringWithFormat:@"%@电话%@", JLGisLeaderBool ? @"工人" : @"班组长", comRemark];
        
        NSArray *titles = @[@"工人姓名", roleRemark];
        
        NSArray *desTitles = @[@"请输入工人的姓名", @"请输入工人的电话号码"];
        
        if ([self.contractor_type isEqualToString:@"1"]) {
            
            NSString *telDes = [NSString stringWithFormat:@"电话号码%@", comRemark];
            
            titles = @[@"承包对象", telDes];
            
            desTitles = @[@"输入承包对象姓名、承包单位、承包项目名称" , @"请输入电话号码"];
        }
        
        if (JLGisMateBool) {
            
            titles = @[@"班组长姓名", roleRemark];
            
            desTitles = @[@"请输入班组长的姓名", @"请输入班组长的电话号码"];
        }
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJCommonInfoDesModel *desModel = [[JGJCommonInfoDesModel alloc] init];
            
            desModel.desType = index == 0 ? JGJCommonInfoDesNameType : JGJCommonInfoTelType;
            
            desModel.title = titles[index];
            
            //承包对象最大输入15个字长度
            
            if ([self.contractor_type isEqualToString:@"1"]) {
                
                desModel.nameLength = UndertakNameLength;
            }
            
            if (index == 1) {
                
                desModel.remarkTitle = comRemark;
            }
            
            desModel.placeholder = desTitles[index];
            
            [_dataSource addObject:desModel];
            
        }
        
    }
    
    return _dataSource;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (JGJAddUserRequest *)request {
    
    if (!_request) {
        
        _request = [JGJAddUserRequest new];
        
    }
    
    return _request;
}

@end
