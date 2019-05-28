//
//  JGJPerInfoVc.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//  个人资料

#import "JGJPerInfoVc.h"
#import "JGJCustomButtonCell.h"
#import "JGJPerInfoHeadCell.h"
#import "JGJCreatTeamCell.h"
#import "JGJPerInfoBlackListView.h"
#import "JGJChatRootVc.h"
#import "TYPhone.h"
#import "JGJCustomPopView.h"
#import "JGJEditNameVc.h"
#import "JGJSclePhoto.h"
#import "NSString+Extend.h"
#import "JGJAddFriendSendMsgVc.h"
#import "PopoverView.h"
#import "CustomAlertView.h"
#import "JGJWebAllSubViewController.h"
#import "JGJChatMsgComTool.h"

#import "JGJChatListAllVc.h"

#import "JGJPerInfoPostCell.h"

#import "NSString+Extend.h"

#import "JGJCheckPhotoTool.h"

#import "JGJCommonFriendlyCell.h"

#import "JGJConCommonFriendVc.h"

#import "JGJTabBarViewController.h"

#import "JLGCustomViewController.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJCusActiveSheetView.h"
#import "JGJPerInfoSignatureCell.h"

typedef enum : NSUInteger {
    JGJPerInfoVcHeadCellType,
    JGJPerInfoVcSignatureCellType, //个性签名
    JGJPerInfoVcRemarkCellType,
    JGJPerInfoVcTAHomePageCellType, //Ta的主页
    JGJPerInfoVcCommonFriendsCellType,//共同好友
    JGJPerInfoVcChatCellType,
    JGJPerInfoVcAddFriendCellType, //加为朋友
    JGJPerInfoVcCallCellType
} JGJPerInfoVcCellType;

static NSString * const signatureCellId = @"JGJPerInfoSignatureCell";

@interface JGJPerInfoVc () <
UITableViewDelegate,
UITableViewDataSource,
JGJCustomButtonCellDelegate,
JGJPerInfoBlackListViewDelegate,
JGJEditNameVcDelegate,
JGJPerInfoHeadCellDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) JGJCustomButtonModel *customButtonModel;
//名字备注
@property (nonatomic, strong) JGJCreatTeamModel *remarkModel;
@property (nonatomic, strong) JGJChatPerInfoModel *perInfoModel;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

@implementation JGJPerInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JGJPerInfoSignatureCell class]) bundle:nil] forCellReuseIdentifier:signatureCellId];
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    //类型转换，外面有传进来是nsnummber型
    self.jgjChatListModel.uid = [NSString stringWithFormat:@"%@", self.jgjChatListModel.uid];
    
    //自己的话不显示
    if ([myUid isEqualToString:self.jgjChatListModel.uid]) {
        
//        self.navigationItem.rightBarButtonItem = nil;
        
        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        
        self.title = [myUid isEqualToString:self.jgjChatListModel.uid] ? @"我的资料": @"他的资料";
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadNetData];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSInteger count = 8;
    
    BOOL isVerifyShown = (self.status == JGJFriendListUnAddMsgType && ![NSString isEmpty:self.message]);
    
    //自己的话只有6行且备注名字高度0
    if ([myUid isEqualToString:self.jgjChatListModel.uid] || isVerifyShown) {
        
        count = 6;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case JGJPerInfoVcHeadCellType: {
            cell = [self handleRegisterHeadCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case JGJPerInfoVcSignatureCellType: {
            cell = [self handleRegisterSignatureCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
            
        case JGJPerInfoVcRemarkCellType:{
            cell = [self handleRegisterRemarkCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case JGJPerInfoVcTAHomePageCellType:{
            cell = [self handleRegisterHomePageCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case JGJPerInfoVcCommonFriendsCellType:{ //3.0.0共同好友
            
            cell = [self registerCommonFriendlyCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case JGJPerInfoVcChatCellType:{
            cell = [self handleRegisterChatCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case JGJPerInfoVcAddFriendCellType:{
            cell = [self handleRegisterAddFriendCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
        case JGJPerInfoVcCallCellType:{
            cell = [self handleRegisterCallCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 45.0;
    
    BOOL isSelf = [_jgjChatListModel.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]];
    
    switch (indexPath.row) {
        case JGJPerInfoVcHeadCellType:
            height = [JGJPerInfoHeadCell headHeightWithMessage:self.message status:self.status];
            break;
        case JGJPerInfoVcSignatureCellType: {
            CGFloat cellHeight = [JGJPerInfoSignatureCell heightWithSignature:self.perInfoModel.signature];
            height = MAX(height, cellHeight);
            break;
        }
            
        case JGJPerInfoVcRemarkCellType:{
            height = isSelf ? 0.0 : height;
        }
            
            break;
        case JGJPerInfoVcChatCellType: ////显示聊天，和黑名单按钮
            height = 87.0;
            if (self.status == JGJFriendListUnAddMsgType && ![NSString isEmpty:self.message]){
                height = 87.0;
            } else {
                if (!self.perInfoModel.is_chat) {
                    height = self.perInfoModel.is_black ? 110.0 : 22.0; //22这个高度是间距,110是移除黑名单显示的高度
                }
            }
            break;
        case JGJPerInfoVcTAHomePageCellType: {//Ta的主页
            
            if (self.perInfoModel.pic_src.count > 0) {
                
                height = 100;
                
            }else if (self.perInfoModel.pic_src.count == 0 && ![NSString isEmpty:self.perInfoModel.content]) {
                
                height = [NSString stringWithContentWidth:[JGJPerInfoPostCell postCellMaxLayoutWidth] content:self.perInfoModel.content font:AppFont30Size] ;
                
                if (height > [JGJPerInfoPostCell postCellMaxRowHeight]) {
                    
                    height =[JGJPerInfoPostCell postCellMaxRowHeight];
                }
                
                height += 26;
                
            }else {
                
                height = 45.0;
            }
            
        }
            break;
        
        case JGJPerInfoVcCommonFriendsCellType:{ //3.0.0共同好友

            if (isSelf || _perInfoModel.common_friends.count == 0) {
                
                height = CGFLOAT_MIN;
                
            }else {

                height = 95;
            }
        }
            break;
        
        case JGJPerInfoVcAddFriendCellType: {//是朋友关系显示加为朋友按钮
            if (self.perInfoModel.is_friend || self.perInfoModel.is_black) {
                height = 0;
            }
            
        }
            break;
        case JGJPerInfoVcCallCellType:{
            if (self.perInfoModel.is_hidden) {
                height = 0;
            }
            
            //拨打电话高度调整,发消息和拨打电话间距相等
            if (self.perInfoModel.is_friend || self.perInfoModel.is_black) {
                
                height = 45.0;
            }
            
            height = 87.0;
            
        }
            break;
        default:
            break;
    }
    
    return height;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JGJPerInfoVcRemarkCellType) {
        JGJEditNameVc *editNameVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditNameVc"];
        editNameVc.delegate = self;
        editNameVc.defaultName = self.perInfoModel.comment_name;
        editNameVc.editNameVcType = JGJEditContactedNameVcType;
        [self.navigationController pushViewController:editNameVc animated:YES];
    }else if (indexPath.row == JGJPerInfoVcTAHomePageCellType) {
        NSString *url = [NSString stringWithFormat:@"dynamic/user?uid=%@&hidebtn=1",  self.perInfoModel.uid];
        JGJWebAllSubViewController *webViewController = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeDynamic URL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }else if (indexPath.row == JGJPerInfoVcCommonFriendsCellType) {
        
        JGJConCommonFriendVc *friendVc = [JGJConCommonFriendVc new];
        
        friendVc.friendsList = self.perInfoModel.common_friends;
        
        friendVc.perInfoModel = self.perInfoModel;
        
        [self.navigationController pushViewController:friendVc animated:YES];
    } else if (indexPath.row == JGJPerInfoVcSignatureCellType) {
        // 个性签名
        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        if ([myUid isEqualToString:self.jgjChatListModel.uid]) {
            NSString *urlString = [NSString stringWithFormat:@"%@my/list",JGJWebDiscoverURL];
            JGJWebAllSubViewController *profileVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:urlString];
            [self.navigationController pushViewController:profileVc animated:YES];
        }
        
    }
    
    
}


#pragma mark - cell处理

- (UITableViewCell *)handleRegisterHeadCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJPerInfoHeadCell *headCell = [JGJPerInfoHeadCell cellWithTableView:tableView];
    headCell.perInfoModel = self.perInfoModel;
    headCell.delegate = self;
    return headCell;
}

/**
 个性签名
 */
- (UITableViewCell *)handleRegisterSignatureCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJPerInfoSignatureCell *signatureCell = [tableView dequeueReusableCellWithIdentifier:signatureCellId forIndexPath:indexPath];
    signatureCell.signature = self.perInfoModel.signature;
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    signatureCell.showArrow = [myUid isEqualToString:self.jgjChatListModel.uid];
    return signatureCell;
}

- (UITableViewCell *)handleRegisterRemarkCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCreatTeamCell *remarkCell = [JGJCreatTeamCell cellWithTableView:tableView];
    self.remarkModel.detailTitle = self.perInfoModel.comment_name;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    //自己的话不显示
    if ([myUid isEqualToString:self.jgjChatListModel.uid]) {
        
        self.remarkModel.title = @"";
        
        self.remarkModel.isHiddenArrow = YES;
    }
    
    remarkCell.creatTeamModel = self.remarkModel;
    return remarkCell;
}

- (UITableViewCell *)handleRegisterChatCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCustomButtonCell *chatButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
    chatButtonCell.delegate = self;
    JGJCustomButtonModel *customButtonModel = [[JGJCustomButtonModel alloc] init];
    
    if (self.status == JGJFriendListUnAddMsgType && ![NSString isEmpty:self.message]) {
        customButtonModel.buttonTitle = @"通过验证";
        customButtonModel.buttontype = JGJCustomVerifyPassedButtonCell;
    } else {
       customButtonModel.buttonTitle = self.perInfoModel.is_black ? @"移除黑名单": @"发消息";
       customButtonModel.buttontype = self.perInfoModel.is_black ? JGJCustomJoinRemoveBlackListButtonCell : JGJCustomChatButtonCell;
        if (!self.perInfoModel.is_black) {
            customButtonModel.isHidden = !self.perInfoModel.is_chat; //不能聊天隐藏聊天按钮
        }
    }
    customButtonModel.titleColor = [UIColor whiteColor];
    customButtonModel.layerColor = AppFontd7252cColor;
    customButtonModel.backColor = AppFontd7252cColor;

    chatButtonCell.customButtonModel = customButtonModel;
    return chatButtonCell;
    
}

- (UITableViewCell *)handleRegisterCallCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCustomButtonCell *callButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
    callButtonCell.delegate = self;
    JGJCustomButtonModel *customButtonModel = [[JGJCustomButtonModel alloc] init];
    customButtonModel.buttonTitle = @"拨打电话";
    if ([_jgjChatListModel.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        customButtonModel.isHidden = YES;
    }
    customButtonModel.isHidden = self.perInfoModel.is_hidden;
    customButtonModel.buttontype = JGJCustomCallButtonCell;
    customButtonModel.backColor = [UIColor whiteColor];
    customButtonModel.titleColor = AppFontd7252cColor;
    customButtonModel.layerColor = AppFontd7252cColor;
    callButtonCell.customButtonModel = customButtonModel;
    return callButtonCell;
}

- (UITableViewCell *)handleRegisterAddFriendCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJCustomButtonCell *callButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
    callButtonCell.delegate = self;
    JGJCustomButtonModel *customButtonModel = [[JGJCustomButtonModel alloc] init];
    customButtonModel.buttonTitle = @"加为朋友";
    customButtonModel.isHidden =  self.perInfoModel.is_friend  || self.perInfoModel.is_black; //是朋友关系隐藏
    if ([_jgjChatListModel.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        customButtonModel.isHidden = YES;
    }
    customButtonModel.buttontype = JGJCustomAddFriendButtonCell;
    customButtonModel.backColor = [UIColor whiteColor];
    customButtonModel.titleColor = AppFontd7252cColor;
    customButtonModel.layerColor = AppFontd7252cColor;
    callButtonCell.customButtonModel = customButtonModel;
    return callButtonCell;
}

- (UITableViewCell *)handleRegisterHomePageCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJPerInfoPostCell *postCell = [JGJPerInfoPostCell cellWithTableView:tableView];
    
    postCell.perInfoModel = self.perInfoModel;
    
    return postCell;
}

#pragma mark - 共同好友
- (UITableViewCell *)registerCommonFriendlyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCommonFriendlyCell *cell = [JGJCommonFriendlyCell cellWithTableView:tableView];
    
    cell.isHiddenSubView = [_jgjChatListModel.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] || _perInfoModel.common_friends.count == 0;
    
    cell.perInfoModel = self.perInfoModel;
    
    return cell;
}


#pragma mark -JGJEditNameVcDelegate
- (void)editNameVc:(JGJEditNameVc *)editNameVc nameString:(NSString *)nameTF {
    
    NSDictionary *parameters = @{
                                 
                                 @"uid" : self.jgjChatListModel.uid?:@"",
                                 
                                 @"comment_name" : nameTF?:@""
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJModifyCommentNameURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJChatPerInfoModel *perInfoModel = weakSelf.perInfoModel;
        
        perInfoModel.comment_name = nameTF;
        
        self.perInfoModel = perInfoModel;
        
        if (weakSelf.callHandelPerInfoBlock) {
            
            weakSelf.callHandelPerInfoBlock(weakSelf.perInfoModel);
        }
        
        //修改备注名字
        [weakSelf handleModifComName];
        
        [weakSelf.tableView reloadData];
        
        [editNameVc.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
         [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - JGJPerInfoHeadCellDelegate
- (void)perInfoHeadWithCell:(JGJPerInfoHeadCell *)cell perInfoModel:(JGJChatPerInfoModel *)perInfoModel {
//    [JGJSclePhoto InitImageURL:perInfoModel.head_pic];
    
    BOOL isUnCanShowImage = [perInfoModel.head_pic containsString:@"headpic_m"] || [perInfoModel.head_pic containsString:@"headpic_f"] || [perInfoModel.head_pic containsString:@"nopic"] || [NSString isEmpty:perInfoModel.head_pic];
    
    if (!isUnCanShowImage) {
        
        [JGJCheckPhotoTool browsePhotoImageView:@[perInfoModel.head_pic] selImageViews:@[cell.headPic.imageView] didSelPhotoIndex:0];
    }
}

#pragma mark - JGJCustomButtonCellDelegate
- (void)customButtonCell:(JGJCustomButtonCell *)cell ButtonCellType:(JGJCustomButtonCellType)buttonCellType {
    switch (buttonCellType) {
        case JGJCustomChatButtonCell: {
            [self handleIsAddBlackList:JGJCustomChatButtonCell]; //判断是否被拉黑，未被拉黑才聊天
        }
            break;
        case JGJCustomCallButtonCell:{
            if ([self.perInfoModel.telephone containsString:@"***"]) {
                [TYShowMessage showPlaint:@"你还不能拨打电话!"];
                return;
            }
            [TYPhone callPhoneByNum:self.perInfoModel.telephone view:self.view];
        }
            break;
        case JGJCustomJoinBlackButtonCell: {
            [self handleJoinBlackList];
        }
            break;
        case JGJCustomJoinRemoveBlackListButtonCell: {
            [self handleRemoveBlackList];
        }
            break;
        case JGJCustomAddFriendButtonCell:{
            //             [self handleIsAddBlackList:JGJCustomAddFriendButtonCell]; //判断是否被拉黑，才能加入朋友
            [self handleJoinedfriend];
        }
            break;
        case JGJCustomVerifyPassedButtonCell:{
            [self handleAgreeFriend];
            return;
        }
            break;
        default:
            break;
    }
    
    [self loadNetData]; //重新加载数据
}

- (void)handleAgreeFriend
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = self.jgjChatListModel.uid ? : @"";
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"chat/agree-friends" parameters:params success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"添加成功"];
        self.status = JGJFriendListAddedMsgType;
        self.message = nil;
        [self loadNetData];
        
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)handleJoinedfriend {
    NSDictionary *parameters = @{
                                 @"uid" : self.perInfoModel.uid?:@""
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-friends-confidition" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJAddFriendSendMsgVc *addFriendSendMsgVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendSendMsgVc"];
        
        addFriendSendMsgVc.perInfoModel = weakSelf.perInfoModel;
        
        [weakSelf.navigationController pushViewController:addFriendSendMsgVc animated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 是否被对方拉黑
- (void)handleIsAddBlackList:(JGJCustomButtonCellType)buttonCellType {
    NSDictionary *body = @{
                           @"uid" : self.jgjChatListModel.uid ?:@""
                           };
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/is-black-list" parameters:body success:^(id responseObject) {
        
        BOOL isInBlackList = [responseObject[@"is_in_black_list"] boolValue];
        if (buttonCellType == JGJCustomChatButtonCell) {
            [weakSelf handleSKipSingleChatWithisCanSingleChat:isInBlackList];
        }
        [TYLoadingHub hideLoadingView];
        
        if (isInBlackList) {
            
            //删除聊天记录
            [weakSelf handleRemoveAllMsg];
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 进入单聊页面
- (void)handleSKipSingleChatWithisCanSingleChat:(BOOL)isCanSingleChat {
    
    if (self.jgjChatListModel.is_find_job) {
        self.workProListModel.chatfindJobModel.isProDetail = YES; //招工信息进入聊天页面
    }
    
    if (!isCanSingleChat) { //1被拉入黑名单  0没有被拉入黑名单
        JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
        self.workProListModel.class_type = @"singleChat";
        
        //这句是保证group_id唯一性用了setter方法下个版本吧一起改
        self.workProListModel.team_id = nil;
        
        self.workProListModel.group_id = self.jgjChatListModel.uid; //个人uid
        
        self.workProListModel.team_name = nil;
        
        if (![NSString isEmpty:self.perInfoModel.comment_name]) {
            
            self.workProListModel.group_name = self.perInfoModel.comment_name;
            
        }else if (![NSString isEmpty:self.perInfoModel.real_name]) {
            
            self.workProListModel.group_name = self.perInfoModel.real_name;
            
        }
        
        chatRootVc.workProListModel = self.workProListModel;
        
        // 能进入聊天 本地创建一个聊天组
        JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
        groupModel.group_id = self.workProListModel.group_id;
        groupModel.class_type = @"singleChat";
        groupModel.local_head_pic = [@[self.jgjChatListModel.head_pic] mj_JSONString];
        groupModel.group_name = self.workProListModel.group_name;
        groupModel.members_num = @"2";
        [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModel:groupModel];
        
        [self.navigationController pushViewController:chatRootVc animated:YES];
        
    }else {
        [TYShowMessage showPlaint:@"对方暂时不想和你聊天"];
    }
}

#pragma mark - JGJPerInfoBlackListViewDelegate
- (void)perInfoBlackListView:(JGJPerInfoBlackListView *)blackListView perInfoBlackListViewButtonType:(JGJPerInfoBlackListViewButtonType)buttonType {
    if (buttonType == JGJPerInfoBlackListViewJoinBlackButtonType) {
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = @"注意：拉黑后，你和TA都将看不到对方的聊天信息，也不能再相互发送聊天信息了。你确定要将TA拉黑吗？";;
        desModel.popTextAlignment = NSTextAlignmentLeft;
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        __weak typeof(self) weakSelf = self;
        alertView.onOkBlock = ^{
            [weakSelf handleJoinBlackList];
        };
    }
}

#pragma mark - 移除黑名单
- (void)handleRemoveBlackList {
    NSDictionary *body = @{
                           
                           @"uid" : self.jgjChatListModel.uid ?:@""
                           
                           };
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:@"group/rm-black-list" parameters:body success:^(id responseObject) {
        
        weakSelf.customButtonModel.buttontype = JGJCustomChatButtonCell;
        
        [weakSelf loadNetData]; //重新加载数据
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 加入黑名单
- (void)handleJoinBlackList {
    NSDictionary *body = @{
                           @"uid" : self.jgjChatListModel.uid ?:@""
                           };
    __weak typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithNapi:@"group/add-black-list" parameters:body success:^(id responseObject) {
        
        weakSelf.customButtonModel.buttontype = JGJCustomJoinBlackButtonCell;
        
        [weakSelf loadNetData]; //重新加载数据
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - buttonAction
/**
 点击右上角"更多"按钮
 */
- (IBAction)handleRightButton:(UIButton *)sender {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL isMyPerInfo = [myUid isEqualToString:self.jgjChatListModel.uid];
    
    if (isMyPerInfo) {
        
        [self checkMyInfoSheetView];
        
        return;
    }
    
//    if (self.perInfoModel.is_black && !self.perInfoModel.is_friend) { //在黑名单，不是好友 不显示
//        return ;
//    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:[self JGJChatActions]];
}

- (void)checkMyInfoSheetView {
    
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:@[@"我的个人资料", @"取消"] buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            NSString *webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"my/list"];
            
            //    [TYShowMessage showSuccess:@"帮助按钮按下"];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
            
            [weakSelf.navigationController pushViewController:webVc animated:YES];
            
        }
        
    }];
    
    [sheetView showView];
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    // 拉黑 action
    __weak typeof(self) weakSelf = self;
    PopoverAction *joinBlackAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"blacklist-icon"] title:@"拉黑" handler:^(PopoverAction *action) {
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = @"注意：拉黑后，你和TA都将看不到对方的聊天信息，也不能再相互发送聊天信息了。你确定要将TA拉黑吗？";;
        desModel.popTextAlignment = NSTextAlignmentLeft;
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        __weak typeof(self) weakSelf = self;
        alertView.onOkBlock = ^{
            
            [weakSelf handleJoinBlackList];
        };
        
    }];
    // 删除 action
    PopoverAction *removeMemberAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"garbage-can-icon"] title:@"删除好友" handler:^(PopoverAction *action) {
        [weakSelf handleDelButtonPressed];
    }];
    // 投诉 action
    PopoverAction *complainAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"perinfo-complain"] title:@"投诉" handler:^(PopoverAction *action) {
        NSString *url = [NSString stringWithFormat:@"%@report?key=%@&mstype=person",JGJWebDiscoverURL,weakSelf.jgjChatListModel.uid];
        JGJWebAllSubViewController *complainWebVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
        [self.navigationController pushViewController:complainWebVc animated:YES];
    }];
    
//    NSArray *popArray = @[joinBlackAction, removeMemberAction];
//    if (!self.perInfoModel.is_black && !self.perInfoModel.is_friend) { //不在黑名单，不是好友显示拉黑
//        popArray = @[joinBlackAction];
//    }else if (self.perInfoModel.is_black && self.perInfoModel.is_friend) { //在黑名单，是好友显示删除
//        popArray =  @[removeMemberAction];
//    }else if (!self.perInfoModel.is_black && self.perInfoModel.is_friend) { //不在黑名单，是好友
//        popArray =  @[joinBlackAction, removeMemberAction];
//    }
    //在黑名单不是好友不显示
    
    // 创建popActions
    NSMutableArray *popActions = [NSMutableArray array];
    // 不在黑名单
    if (!self.perInfoModel.is_black) {
        [popActions addObject:joinBlackAction];
    }
    // 是好友
    if (self.perInfoModel.is_friend) {
        [popActions addObject:removeMemberAction];
    }
    // 不是自己
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    BOOL isSelf = [myUid isEqualToString:self.jgjChatListModel.uid];
    if (!isSelf) {
        [popActions addObject:complainAction];
    }
    return [NSArray arrayWithArray:popActions];
}

#pragma mark - 删除联系人
- (void)handleDelButtonPressed {
    NSDictionary *parameters = @{@"ctrl" : @"Chat",
                                 @"action" : @"delChatMember",
                                 @"uid" : self.perInfoModel.uid?:@"",
                                 @"type" : @"friend"};
    
    
    __weak typeof(self) weakSelf = self;
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:@"删除朋友，同时将删除与TA的聊天记录，你确定要删除吗？" leftButtonTitle:@"取消" midButtonTitle:nil rightButtonTitle:@"确定"];
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    
    alertView.onOkBlock = ^{
        
        [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelFriendURL parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            [self loadNetData];
            
            [weakSelf handleRemoveAllMsg];
            
        } failure:^(NSError *error) {
            
        }];
        
    };
    
}

#pragma mark - 更新聊聊表

- (void)updateGroup {
    
    
}

#pragma mark - 移除本地全部和这个人的聊天信息
- (void)handleRemoveAllMsg {
    
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel new];
    
    groupModel.class_type = @"singleChat";
    
    groupModel.group_id = self.perInfoModel.uid;
    [JGJChatMsgDBManger deleteChatGroupListDataWithModel:groupModel];
}

#pragma mark - 获取网络数据
- (void)loadNetData {
//    NSString *isFindJob = [NSString stringWithFormat:@"%@", @(self.workProListModel.is_find_job)];
    NSDictionary *body = @{
                           @"uid" : self.jgjChatListModel.uid ?:@"",
                           @"class_type" : self.jgjChatListModel.class_type ?:@"",
                           @"group_id" : self.jgjChatListModel.group_id ?:@"",
//                           @"is_find_job" : isFindJob?:@"1"
                           };
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-chat-member-info" parameters:body success:^(id responseObject) {

        TYLog(@"个人资料=====>%@",responseObject);
        
        JGJChatPerInfoModel *perInfoModel = [JGJChatPerInfoModel mj_objectWithKeyValues:responseObject];
        // 设置验证信息和好友关系状态
        perInfoModel.message = self.message;
        perInfoModel.status = self.status;
        
// 只要不在黑名单就能打电话
        
        if (!perInfoModel.is_hidden) {
            
            perInfoModel.is_hidden = perInfoModel.is_black;
            
        }
        
        self.perInfoModel = perInfoModel;
       
        
        if ([NSString isEmpty:self.perInfoModel.uid]) {
            
            self.perInfoModel.uid = self.jgjChatListModel.uid;
        }
        
        //单聊才更新聊聊对方名字
        
        if ([self.workProListModel.class_type isEqualToString:@"singleChat"]) {
            
            [self updateSignChatDB];
        }
        
//更新用户最新头像
//        
        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
        
        msgModel.class_type = self.jgjChatListModel.class_type;
        
        msgModel.group_id = self.jgjChatListModel.group_id;
        
        msgModel.msg_sender = perInfoModel.uid;
        
        msgModel.modify_head_pic = perInfoModel.head_pic;

        JGJChatMsgListModel *oldMsgModel = [JGJChatMsgDBManger getMaxUserMsgModel:msgModel];
        
        if (![oldMsgModel.user_info.head_pic isEqualToString:msgModel.head_pic]) {
            
            [TYNotificationCenter postNotificationName:JGJAddObserverModifyUserHeadPicNotify object:self.perInfoModel];
            
            [JGJChatMsgDBManger updateUserInfoWithMsgModel:msgModel];
            
        }
        
        [self handleModifComName];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 更新数据库

- (void)updateSignChatDB {
    
    NSString *comment_name = self.perInfoModel.comment_name;
    
    if ([NSString isEmpty:comment_name]) {
        
        comment_name = self.perInfoModel.real_name?:@"";
    }
    
    self.jgjChatListModel.head_pic = self.perInfoModel.head_pic;
    
    self.jgjChatListModel.send_name = comment_name;
    
    [JGJChatMsgComTool updateSingleDBChatModel:self.jgjChatListModel];
}

- (void)setPerInfoModel:(JGJChatPerInfoModel *)perInfoModel {
    _perInfoModel = perInfoModel;
    //在我的黑名单，不是好友关系不显示
    if (_perInfoModel.is_black && !_perInfoModel.is_friend) {;
//        self.moreButton.hidden = YES;
        self.customButtonModel.buttontype = JGJCustomJoinBlackButtonCell;
    }else {
//        self.moreButton.hidden = NO;
        self.customButtonModel.buttontype = JGJCustomChatButtonCell;
    }
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
- (JGJCustomButtonModel *)customButtonModel {
    
    if (!_customButtonModel) {
        _customButtonModel = [[JGJCustomButtonModel alloc] init];
        _customButtonModel.font = [UIFont systemFontOfSize:AppFont30Size];
    }
    return _customButtonModel;
}

- (JGJCreatTeamModel *)remarkModel {
    
    if (!_remarkModel) {
        _remarkModel = [JGJCreatTeamModel new];
        _remarkModel.title = @"备注名字";
    }
    return _remarkModel;
}

- (JGJChatMsgListModel *)jgjChatListModel {
    if (!_jgjChatListModel) {
        _jgjChatListModel = [JGJChatMsgListModel new];
    }
    return _jgjChatListModel;
}

- (JGJMyWorkCircleProListModel *)workProListModel {
    if (!_workProListModel) {
        _workProListModel = [JGJMyWorkCircleProListModel new];
    }
    return _workProListModel;
}

#pragma mark - 修改备注名字
- (void)handleModifComName {
    
    //回调修改
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    if (![user_id isEqualToString:self.perInfoModel.uid]) {// 单聊 进入个人资料 如果看的自己，不更新名字
        
        [TYNotificationCenter postNotificationName:JGJAddObserverModifyNameNotify object:self.perInfoModel];
        
    }
    //单聊更新聊聊列表名字
    if ([self.jgjChatListModel.class_type isEqualToString:@"singleChat"]) {
        
        [self updateSignChatDB];
    }
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    if (![NSString isEmpty:self.perInfoModel.comment_name]) {
        
        msgModel.user_name = self.perInfoModel.comment_name;
        
    }else if (![NSString isEmpty:self.perInfoModel.chat_name]) {
        
        msgModel.user_name = self.perInfoModel.chat_name;
        
    }else if (![NSString isEmpty:self.perInfoModel.real_name]) {
        
        msgModel.user_name = self.perInfoModel.real_name;
        
    }

    else {
        
        msgModel.user_name = self.perInfoModel.comment_name;
    }
    
    msgModel.msg_sender = self.perInfoModel.uid;
    
    msgModel.group_id = self.jgjChatListModel.group_id;
    
    msgModel.class_type = self.jgjChatListModel.class_type;
    
    msgModel.head_pic = self.perInfoModel.head_pic;
    
    [JGJChatMsgComTool handleModifyChatModel:msgModel];
}

@end
