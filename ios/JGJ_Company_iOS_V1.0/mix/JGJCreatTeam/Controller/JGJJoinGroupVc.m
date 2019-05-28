//
//  JGJJoinGroupVc.m
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJJoinGroupVc.h"
#import "JGJQRCodeView.h"
#import "NSDate+Extend.h"
#import "JGJChatRootVc.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

@interface JGJJoinGroupVc ()

@property (weak, nonatomic) IBOutlet JGJQRCodeView *QRCodeView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@end

@implementation JGJJoinGroupVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.QRCodeView.proListModel = self.proListModel;
    self.QRCodeView.codeViewType = JGJQRCodeViewJoin;
    [self.joinButton.layer setLayerCornerRadius:4.0];
    if ([self.proListModel.class_type isEqualToString:@"team"]) {
        self.title = @"加入项目组";
    } else if ([self.proListModel.class_type isEqualToString:@"group"]) {
        self.title = @"加入班组";
    }else if ([self.proListModel.class_type isEqualToString:@"groupChat"]) {
        self.title = @"进入群聊";
    }
    [self.joinButton setTitle:self.title  forState:UIControlStateNormal];
}

//在H5页面没有头子,扫描进入就会出现当前页面没有头子的问题
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (IBAction)joinBtnClick:(id)sender {
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf handleChatAction:weakSelf.proListModel];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 选中之后切换项目，首页项目改变
- (void)setIndexProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    [self insertGroup:proListModel];
    
    JGJIndexDataModel *proModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    
    if (![NSString isEmpty:proModel.group_id]) {
        
        return;
    }
    
    //班组项目组切换
    if (![proListModel.class_type isEqualToString:@"team"]) {

        return;
    }

    NSDictionary *body = @{

                           @"class_type" : proListModel.class_type?:@"",

                           @"group_id" : proListModel.group_id?:@""

                           };

    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-index-list" parameters:body success:^(id responseObject) {

        TYLog(@"切换项目首页responseObject = %@",responseObject);

        [JGJChatGetOffLineMsgInfo http_getChatIndexList];

    } failure:^(NSError *error) {


    }];
    
    
}

#pragma mark - 插入组
- (void)insertGroup:(JGJMyWorkCircleProListModel *)proListModel{
    
    JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[proListModel mj_JSONObject]];
    
    groupModel.max_asked_msg_id = @"0";
    
    groupModel.sys_msg_type = @"normal";
    
    groupModel.local_head_pic = [proListModel.members_head_pic mj_JSONString];
    
    groupModel.create_time = [JGJChatMsgDBManger localTime];
    
    [JGJChatMsgDBManger insertToChatGroupListTableWithJGJChatMsgListModel:groupModel];
    
//    [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
    
    
}

#pragma mark - 聊天界面
- (void)handleChatAction:(JGJMyWorkCircleProListModel *)worlCircleModel {
    if ([worlCircleModel.class_type isEqualToString:@"groupChat"]) {
        [self handleJoinGroupChatWithGroupChatModel:worlCircleModel];
    }else {
        JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
        
        //传递基本信息
        chatRootVc.workProListModel = worlCircleModel;
        [self.navigationController pushViewController:chatRootVc animated:YES];
    }
    
    //扫码切换项目
    [self setIndexProListModel:self.proListModel];
    
}

#pragma mark - 进入群聊
- (void)handleJoinGroupChatWithGroupChatModel:(JGJMyWorkCircleProListModel *)groupChatModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    chatRootVc.workProListModel = groupChatModel; //进入群聊
    [self.navigationController pushViewController:chatRootVc animated:YES];
    
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    if (!_addGroupMemberRequestModel) {
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        
        _addGroupMemberRequestModel.is_qr_code = @"1";
        _addGroupMemberRequestModel.group_id = self.proListModel.group_id;
        
        _addGroupMemberRequestModel.class_type = self.proListModel.class_type;
        _addGroupMemberRequestModel.inviter_uid = self.proListModel.inviter_uid;
        NSInteger timestamp = [[[NSDate date] timestamp] integerValue];
        _addGroupMemberRequestModel.qr_code_create_time = [NSString stringWithFormat:@"%@", @(timestamp)];
    }
    return _addGroupMemberRequestModel;
}

@end

