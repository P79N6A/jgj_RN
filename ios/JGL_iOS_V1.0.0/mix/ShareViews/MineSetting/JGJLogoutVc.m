//
//  JGJLogoutVc.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutVc.h"

#import "JGJLogoutTopDesCell.h"

#import "JGJLogoutItemDesCell.h"

#import "JGJLogoutRemindDesCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "JGJLogoutPopView.h"

#import "JGJLogoutReasonView.h"

#import "JGJCustomLable.h"

#import "IQKeyboardManager.h"

@implementation JGJLogoutStatusModel


@end

@interface JGJLogoutVc () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *desInfos;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonViewH;

@property (assign, nonatomic) NSInteger rowCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) JGJLogoutPopView *logoutPopView;

@property (copy, nonatomic) NSString *verCode;

//状态模型
@property (strong, nonatomic) JGJLogoutStatusModel *statusModel;

@property (strong, nonatomic) JGJLogoutReasonView *reasonView;

@property (strong, nonatomic) JGJCustomLable *footerTitleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJLogoutReasonRequestModel *reasonRequest;

@property (nonatomic, strong) JGJCustomLable *footerDesLable;

@end

@implementation JGJLogoutVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注销账号";
    
    [self.logoutBtn.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius];
    
    [self.logoutBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    TYWeakSelf(self);
    
    self.logoutPopView.logoutPopViewBlock = ^(NSString *verCode) {
      
        weakself.verCode = verCode;
    };
    
    [self getAcountStatus];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEndEdit)];
    
    tapGesture.numberOfTapsRequired = 1;

    tapGesture.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:tapGesture];
    
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            JGJLogoutTopDesCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"JGJLogoutTopDesCell" forIndexPath:indexPath];

            firstCell.desModel = self.desInfos[0];
            
            cell = firstCell;
        }
            break;
        case 1:{
            
            JGJLogoutRemindDesCell *remindDesCell = [tableView dequeueReusableCellWithIdentifier:@"JGJLogoutRemindDesCell" forIndexPath:indexPath];
            remindDesCell.desModel = self.desInfos[1];
            cell = remindDesCell;
        }
            
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0;
    
    JGJLogoutItemDesModel *desModel = self.desInfos[indexPath.row];;
    
    switch (indexPath.row) {
        case 0:{
            
            height = 0;
        }
            break;
            
        case 1:{

            height = desModel.desH + 40;
            
        }
            
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return ![self.statusModel.status isEqualToString:@"1"] && ![self.statusModel.status isEqualToString:@"2"] && self.dataSource.count > 0 ? self.footerTitleView.height : CGFLOAT_MIN;;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return ![self.statusModel.status isEqualToString:@"1"] && ![self.statusModel.status isEqualToString:@"2"] &&self.dataSource.count > 0  ? self.footerTitleView : nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  CGFLOAT_MIN;;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
    
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
//    TYWeakSelf(self);
//
//    self.logoutPopView.logoutPopViewOkBlock = ^{
//
//        [weakself requestAccountCancellation];
//    };
    
    [self requestAccountCancellation];
}

#pragma mark - 删除账户请求
- (void)requestAccountCancellation {
    
    NSMutableArray *codes = [NSMutableArray array];
    
    for (JGJLogoutReasonModel *reasonMode in self.dataSource) {
        
        if (![NSString isEmpty:reasonMode.code] && reasonMode.isSel) {
            
            [codes addObject:reasonMode.code];
        }
        
        if (reasonMode.isOther) {
            
            self.reasonRequest.reason  = reasonMode.des;
        }
    }
    
    NSString *code = [codes componentsJoinedByString:@","];
    
    self.reasonRequest.code = code;
    
    self.reasonRequest.vcode = self.verCode;
    
    if ([NSString isEmpty:code] && [NSString isEmpty:self.reasonRequest.reason]) {
        
        [TYShowMessage showPlaint:@"请反馈你的注销原因"];
        
        return;
    }
    
//    if ([NSString isEmpty:self.verCode]) {
//
//        //        [TYShowMessage showPlaint:@"请输入验证码"];
//
//        return;
//
//    }
    
    if ([NSString isEmpty:self.verCode]) {
        
        [self.logoutPopView showPopView];
        
        TYWeakSelf(self);
        
        self.logoutPopView.logoutPopViewOkBlock = ^{
          
            [weakself requestAccountCancel];
        };
        
    }else {
        
        [self requestAccountCancel];
    }
    
}

#pragma mark- 发送注销请求
- (void)requestAccountCancel {
    
    self.reasonRequest.vcode = self.verCode;
    
    NSDictionary *parameters = [self.reasonRequest mj_keyValues];
    
    [TYShowMessage showHUDWithMessage:@"注销中..."];
    [JLGHttpRequest_AFN PostWithApi:@"v2/Signup/accountCancellation" parameters:parameters success:^(id responseObject) {
        
        [self getAcountStatus];
        
        [TYShowMessage hideHUD];
        
    } failure:^(NSError *error) {
        
        [TYShowMessage hideHUD];
    }];
}

#pragma mark - 获取注销原因列表
- (void)requestLogoutReasonList {
    
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id" : @"85"} success:^(id responseObject) {
        
        self.dataSource = [JGJLogoutReasonModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYShowMessage hideHUD];
        
    } failure:^(NSError *error) {
        
        [TYShowMessage hideHUD];
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    if (self.dataSource.count > 0 && ![_statusModel.status isEqualToString:@"1"] && ![_statusModel.status isEqualToString:@"2"]) {
        
        _reasonView = [[JGJLogoutReasonView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, [JGJLogoutReasonView logoutReasonViewHeightWithCount:_dataSource.count] + 30)];
        
        _reasonView.backgroundColor = [UIColor whiteColor];
        
        self.tableView.tableFooterView = _reasonView;
        
        JGJLogoutReasonModel *reasonModel = [JGJLogoutReasonModel new];
        
        reasonModel.isOther = YES;
        
        reasonModel.name = @"其他";
        
        [self.dataSource addObject:reasonModel];
        
        _reasonView.dataSource = self.dataSource;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - 获取账号状态
- (void)getAcountStatus {
    
//    "status": "1", //0没有任何住下操作，1，注销提交，2，注销成功，3住下被拒
//    "comment": "你已提交注销帐号申请，请耐心等待，平台工作人员将与你进行电话联系确认" //备注信息
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/Signup/accountStatus" parameters:nil success:^(id responseObject) {
    
        self.statusModel = [JGJLogoutStatusModel mj_objectWithKeyValues:responseObject];
        
        //获取注销原因列表
        [self requestLogoutReasonList];
        
    } failure:^(NSError *error) {

    }];
    
}

- (void)setStatusModel:(JGJLogoutStatusModel *)statusModel {
    
    _statusModel = statusModel;
    
    //0没有任何住下操作，1，注销提交，2，注销成功，3注销被拒
    
    self.bottomView.hidden = NO;
    
    self.bottonViewH.constant = 63;
    
    //不显示注销原因
    if ([statusModel.status isEqualToString:@"2"] || [statusModel.status isEqualToString:@"1"]) {
        
        self.reasonView.hidden = YES;
        
        self.reasonView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN);
        
        self.bottonViewH.constant = 0;
        
        _rowCount = self.desInfos.count;
        
        self.bottomView.hidden = YES;
        
        self.bottomSpace.constant = 0;
    }
    
    if (![NSString isEmpty:statusModel.comment]) {
        
        self.footerDesLable.text = statusModel.comment;
        
        self.tableView.tableFooterView = self.footerDesLable;
    }
    
    [self.tableView reloadData];
    
}

- (NSMutableArray *)desInfos {

    NSArray *titles = @[@"",
//                        @"帐号对应的班组和项目信息",
//                        @"合伙人保证金和可提现余额",
//                        @"帐号订购的服务",
//                        @"重要提醒:",
                        @""];

    NSArray *desInfos = @[

                          @"你提交的注销申请生效前，平台将进行以下验证，以保证你的帐号、财产安全：",

//                          @"对该帐号在吉工家和吉工宝创建的记工、班组、项目等信息进行删除确认，以免误操作造成数据丢失。",
//
//                          @"验证该帐号是否加入合伙人，是否有余额未提现，是否有保证金未退还。",
//
//                          @"对该帐号订购的剩余服务进行核查，以免造成不必要的浪费。",
//
//                          @"注销账号是不可恢复的操作，你将无法再使用该帐号找回你添加的任何信息（即使你使用相同帐号再次登录），因此注销帐号之前，请确认与该帐号相关的所有服务均已进行妥善处理。",

                          @""
                          ];

    if (!_desInfos) {

        _desInfos = [NSMutableArray new];

        for (NSInteger indx = 0; indx < titles.count; indx++) {

            JGJLogoutItemDesModel *desModel = [JGJLogoutItemDesModel new];

            desModel.title = titles[indx];

            desModel.desInfo = desInfos[indx];

            if (indx == desInfos.count - 1) {

                desModel.desInfoColor = AppFont333333Color;
            }
            
            if (indx == 0) {
                
                desModel.desH = 50;
            }
            
            if (indx == 1) {
                
                desModel.desH = (TYGetUIScreenWidth - 30) * 0.405;
            }

            [_desInfos addObject:desModel];
        }
    }

    return _desInfos;
}

- (JGJLogoutPopView *)logoutPopView {
    
    if (!_logoutPopView) {
        
        _logoutPopView = [[JGJLogoutPopView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    }
    
    return _logoutPopView;
}

- (JGJCustomLable *)footerTitleView {
    
    if (!_footerTitleView) {
        
        _footerTitleView = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 38)];
        
        _footerTitleView.text = @"注销原因";
        
        _footerTitleView.font = [UIFont boldSystemFontOfSize:AppFont34Size];
        
        _footerTitleView.textInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
        
        _footerTitleView.textAlignment = NSTextAlignmentCenter;
        
        _footerTitleView.textColor  = AppFont333333Color;
        
    }
    
    return _footerTitleView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 工具条平移的距离 == 屏幕高度 - 键盘最终的Y值
    
    CGFloat textViewH = self.reasonView.cell.height + (TYIS_IPHONE_5_OR_LESS ? -186 : 100);
    
    CGFloat bottomH = 63.0;
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect coverRect = [self.reasonView.cell convertRect:self.reasonView.cell.textView.frame toView:self.view.window];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - rect.origin.y;
    
    CGFloat tabBarH = bottomH + JGJ_IphoneX_BarHeight;
    
    if (yEndOffset < tabBarH) {
        
        CGPoint point = CGPointMake(0, self.tableView.contentSize.height - self.tableView.height);
        
        [self.tableView setContentOffset:point animated:YES];
        
        yEndOffset = tabBarH;
        
        self.bottomSpace.constant = tabBarH;
        
    }else {
        
//        CGFloat OffsetY = coverRect.origin.y - rect.origin.y;
        
        yEndOffset = (rect.size.height + textViewH + bottomH);
        
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - rect.size.height) animated:YES];
                
    }
    
//     CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:duration animations:^{
//
//        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.bottom.mas_equalTo(self.view).mas_offset(-yEndOffset);
//
//            make.top.mas_equalTo(self.view).mas_offset(-yEndOffset);
//
//        }];
//
//    } completion:^(BOOL finished) {
//
//
//    }];
    
}

- (void)tapEndEdit {
    
    [self.view endEditing:YES];
}

- (JGJLogoutReasonRequestModel *)reasonRequest {
    
    if (!_reasonRequest) {
        
        _reasonRequest = [JGJLogoutReasonRequestModel new];
    }
    
    return _reasonRequest;
}

- (JGJCustomLable *)footerDesLable {
    
    if (!_footerDesLable) {
        
        _footerDesLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 48, 50)];
        
        _footerDesLable.textAlignment = NSTextAlignmentLeft;
        
        _footerDesLable.textColor = AppFont333333Color;
        
        _footerDesLable.font = [UIFont systemFontOfSize:AppFont22Size];
        
        _footerDesLable.numberOfLines = 0;
        
        _footerDesLable.textInsets = UIEdgeInsetsMake(0, 24, 0, 24);
        
        _footerDesLable.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _footerDesLable;
}

@end
