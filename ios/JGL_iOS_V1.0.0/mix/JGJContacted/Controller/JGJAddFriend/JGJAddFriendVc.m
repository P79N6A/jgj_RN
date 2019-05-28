//
//  JGJAddFriendVc.m
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//  添加朋友页面

#import "JGJAddFriendVc.h"
#import "TYTextField.h"
#import "JGJAddFriendSourceCell.h"
#import "UIView+YYAdd.h"
#import "JGJAddFriendDesCell.h"
#import "NSString+Extend.h"
#import "JGJAddressBookTool.h"
#import "JGJCreateGroupVc.h"
#import "JGJQRCodeVc.h"
#import "JGJAddFriendAddressBookVc.h"
#import "JGJPerInfoVc.h"
#import "JGJGroupChatListVc.h"

#import <AddressBook/AddressBook.h>

#import "TYAddressBook.h"
#import "JGJDataManager.h"


typedef enum : NSUInteger {
    JGJAddFriendSourcesVcStyle, //朋友类型
    JGJAddFriendResultVcStyle, //搜索结果
    JGJAddFriendUnResultVcStyle //没有搜索结果
} JGJAddFriendVcStyle;

@interface JGJAddFriendVc ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (strong, nonatomic) NSMutableArray *friendSources; //添加朋友类型
//@property (strong, nonatomic) NSMutableArray *friendResult; //搜索人员结果
@property (assign, nonatomic) JGJAddFriendVcStyle addFriendVcStyle;
@property (strong, nonatomic) JGJAddFriendStyleModel *searchMemberModel;
@end

@implementation JGJAddFriendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self friendSources];
    [self.tableView reloadData];
    self.addFriendVcStyle = JGJAddFriendSourcesVcStyle;
    [self commonInit];
    
    [self unfoldAddressBook];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBarTF.text = nil;
    [self searchValueChange:nil];
    
    //进来刷新的目的是切换账号可能还是之前的数据
    [self.tableView reloadData];
}

#pragma mark - 通用设置
- (void)commonInit{
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 11;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        [weakSelf searchValueChange:value];
    };
}

- (void)searchValueChange:(NSString *)value {
    self.searchMemberModel = nil;
    if ([NSString isEmpty:value]) {
        self.addFriendVcStyle = JGJAddFriendSourcesVcStyle;
        [self friendSources];
    }else {
        self.searchBarTF.text = value;
        self.addFriendVcStyle = JGJAddFriendResultVcStyle;
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
//    JGJAddFriendSourcesVcStyle, //朋友类型
//    JGJAddFriendResultVcStyle //搜索结果
    switch (self.addFriendVcStyle) {
        case JGJAddFriendSourcesVcStyle:
            count = self.friendSources.count;
            break;
        case JGJAddFriendUnResultVcStyle:
        case JGJAddFriendResultVcStyle:
            count = 1;
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    JGJAddFriendSourceCell *friendSourceCell = [JGJAddFriendSourceCell cellWithTableView:tableView];
    switch (self.addFriendVcStyle) {
        case JGJAddFriendSourcesVcStyle: {
            JGJAddFriendStyleModel *searchMemberModel = self.friendSources[indexPath.row];
            friendSourceCell.sourceModel = searchMemberModel;
            cell = friendSourceCell;
        }
            break;
        case JGJAddFriendResultVcStyle:{
            //搜索有结果
            if (![NSString isEmpty:self.searchMemberModel.uid]) {
                self.searchMemberModel.addFriendSourceCellStyle = JGJAddFriendSourceSearchResult;
                friendSourceCell.sourceModel = self.searchMemberModel;
                cell = friendSourceCell;
            }else {
                JGJAddFriendDesCell *desCell = [JGJAddFriendDesCell cellWithTableView:tableView];
                desCell.searchTel = self.searchBarTF.text;
                cell = desCell;
            }
        }
            break;
        case JGJAddFriendUnResultVcStyle:{
            JGJAddFriendDesCell *desCell = [JGJAddFriendDesCell cellWithTableView:tableView];
            desCell.searchTel = nil;
            cell = desCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    JGJAddFriendSourceDefault,
//    JGJAddFriendSourceMineStyle, //自己显示
//    JGJAddFriendSourceQrcodeStyle, //扫一扫
//    JGJAddFriendSourceAddressBookStyle,//通讯录
//    JGJAddFriendSourceSearchResult//搜索结果
    switch (self.addFriendVcStyle) {
        case JGJAddFriendSourcesVcStyle: {
            [self JGJTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
            break;
        case JGJAddFriendResultVcStyle:{
            TYLog(@"网络搜索该吉工家用户");
            if (![NSString isEmpty:self.searchMemberModel.uid]) {
                [self handleSkipPerInfoWithSearchMemberModel:self.searchMemberModel];
            }else {
                [self handleSearchAddressBooks];
            }
        }
            break;
        default:
            break;
    }
}

- (void)handleSkipPerInfoWithSearchMemberModel:(JGJAddFriendStyleModel *)memberModel {
    NSString *myTelephone = [TYUserDefaults objectForKey:JLGPhone];
    if ([memberModel.telephone isEqualToString:myTelephone]) {
        [self handelGenerateQrcodeActionWithfriendStyleModel:self.searchMemberModel];
    }else {
        // 设置好友来源为手机号搜索
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromTelephoneSearch;
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.uid = memberModel.uid;
        perInfoVc.jgjChatListModel.group_id = memberModel.uid;
        perInfoVc.jgjChatListModel.class_type = @"singleChat";
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
}

- (void)JGJTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJAddFriendSourceCellStyle sourceCellStyle = (JGJAddFriendSourceCellStyle)indexPath.row + 1;
    switch (sourceCellStyle) {
        case 1: {
            // 我的吉工家二维码
            JGJAddFriendStyleModel *sourceModel = self.friendSources[0];
            [self handelGenerateQrcodeActionWithfriendStyleModel:sourceModel];
        }
            break;
            
        case 2:{
            // 手机通讯录添加
            JGJAddFriendAddressBookVc *addressBookVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendAddressBookVc"];
            [self.navigationController pushViewController:addressBookVc animated:YES];
        }
            break;
            
        case 3:{
            // 从项目加朋友
            JGJGroupChatListVc *workChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
            
            workChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
            
            workChatListVc.chatType = JGJSingleChatType;
            
            [self.navigationController pushViewController:workChatListVc animated:YES];
            
        }
            
            break;
            
        case 4:{
            // 扫码加朋友
            JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];
            [self.navigationController pushViewController:jgjQRCodeVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - buttonaction
#pragma mark - 处理二维码生成
- (void)handelGenerateQrcodeActionWithfriendStyleModel:(JGJAddFriendStyleModel *)friendStyleModel {
    JGJCreateGroupVc *joinGroupVc = [JGJCreateGroupVc new];
    JGJMyWorkCircleProListModel *workProListModel = [JGJMyWorkCircleProListModel new];
    workProListModel.team_name = nil;
    workProListModel.group_name = friendStyleModel.real_name;
    workProListModel.group_id = friendStyleModel.uid;
    workProListModel.team_id = nil;
    workProListModel.members_head_pic = @[friendStyleModel.head_pic?:@""];
    workProListModel.class_type = @"addFriend";
    joinGroupVc.workProListModel = workProListModel;
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}

- (void)handleSearchAddressBooks {
    NSDictionary *parameters = @{
                                 
                                 @"telephone" : self.searchBarTF.text?: @""
                                 
                                 };

    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-lookup-member" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        weakSelf.searchMemberModel = [JGJAddFriendStyleModel mj_objectWithKeyValues:responseObject];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)setSearchMemberModel:(JGJAddFriendStyleModel *)searchMemberModel {
    _searchMemberModel = searchMemberModel;
//    JGJAddFriendSourcesVcStyle, //朋友类型
//    JGJAddFriendResultVcStyle //搜索结果
    if (![NSString isEmpty:searchMemberModel.uid]) {
        self.addFriendVcStyle = JGJAddFriendResultVcStyle;
    }else {
        self.addFriendVcStyle = JGJAddFriendUnResultVcStyle;
    }
    [self.tableView reloadData];
}

-(NSMutableArray *)friendSources {
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    NSString *telephone = [TYUserDefaults objectForKey:JLGPhone];
    NSString *realName = [TYUserDefaults objectForKey:JLGRealName];
    NSString *userName = [TYUserDefaults objectForKey:JGJUserName];
    
    if (![NSString isEmpty:realName]) {
        
        userName = realName;
    }
    
    NSString *myHeadPicStr = [TYUserDefaults objectForKey:JLGHeadPic];
    NSArray *titles = @[@"我的吉工家二维码", @"从手机通讯录加朋友", @"从项目加朋友", @"扫码加朋友"];
    NSArray *des = @[telephone, @"添加或邀请手机通讯录中的朋友", @"添加或邀请项目中的朋友", @"扫描吉工家二维码名片"];
    NSArray *images = @[myHeadPicStr?:@"", @"from_addressbook_icon", @"from_pro_add_icon", @"sweep_Qrcode_join_team"];
    NSMutableArray *sourceModels = [NSMutableArray array];
    if (!_friendSources) {
        for (NSUInteger index = 0; index < des.count; index ++) {
            JGJAddFriendStyleModel *sourceModel = [[JGJAddFriendStyleModel alloc] init];
            sourceModel.title = titles[index];
            sourceModel.real_name = titles[index];//生成二维码使用
            sourceModel.real_name = index == 0 ? userName : @"";
            
            if (![NSString isEmpty:userName]) {
                
                sourceModel.real_name = userName;
            }
            
            sourceModel.des = des[index];
            sourceModel.head_pic = images[index];
            sourceModel.isShowQrcode = index == 0;
            [sourceModels addObject:sourceModel];
            sourceModel.uid = index == 0 ? myUid : nil;
        }
        _friendSources = sourceModels;
    }
    return _friendSources;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {

    
}

#pragma mark - 打开通信录
- (void)unfoldAddressBook {
    
    TYWeakSelf(self);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [TYAddressBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            
            if(isAuthorized)
            {
                TYLog(@"打开了------------------");
                
                //                [weakself firstOpenAdddressbook];
                
                [TYAddressBook loadAddressBookByHttp];
            }
            
        }];
    }
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        //        [self firstOpenAdddressbook];
        
        [TYAddressBook loadAddressBookByHttp];
    }
    
}

@end
