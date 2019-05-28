//
//  JGJChatListLogVc.m
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListLogVc.h"
#import "JGJChatNoticeVc.h"
#import "JGJBuilderDiaryViewController.h"
#import "JGJLogHeaderView.h"
#import "JGJPublishLogButton.h"
#import "JGJLogFilterViewController.h"
#import "JGJLogAlertView.h"
#import "JGJMoreLogView.h"
#import "JGJBuyAlerView.h"
#import "JGJSureOrderListViewController.h"

#import "JGJMsgFlagView.h"

#import "JGJQualityMsgReplyListVc.h"

#import "JGJGroupMangerTool.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJChatListLogVc ()
<
//clickLogTopButtondelegate,
choiceLogDelegate
//clickRepeatButtondelegate
>
@property (weak, nonatomic) IBOutlet UIButton *releaseLogButton;
@property (nonatomic ,strong)JGJPublishLogButton *bottemButton;
@property (nonatomic ,strong)JGJGetLogTemplateModel *GetLogTemplateModel;
@property (nonatomic ,strong)NSMutableArray <JGJGetLogTemplateModel *>*dataArrs;
@property (strong, nonatomic) JGJMsgFlagView *msgFlagView; //新消息标记
@end

@implementation JGJChatListLogVc

- (void)dataInit{
    [super dataInit];
    self.msgType = @"log";
    self.title = @"工作日志";
    [self.releaseLogButton.layer setLayerCornerRadius:JGJCornerRadius];
    if ( [NSString isEmpty: _model.cat_name ]) {
        self.title = @"工作日志";
        
    }else{
        self.title = _model.cat_name;
        
    }
    self.releaseLogButton.hidden = YES;
    if (!self.workProListModel.isClosedTeamVc) {
        [self.view addSubview:self.bottemButton];
    }else{
        _bottmConstance.constant = -63;
    }
    
    [self getApproval];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.msgFlagView];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    __weak typeof(self) weakSelf = self;
    
    self.msgFlagView.msgFlagViewBlock = ^{
        
        [weakSelf replyButtonClick];
        
        [weakSelf.msgFlagView setHiddenFlagView:YES];
    };
    
    [self delUnread_ListLog_work_count];
}

- (void)delUnread_ListLog_work_count {
    
    JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
    indexModel.unread_log_count = @"0";
    [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    
    // 清除聊聊列表对应的质量未读数
    JGJChatGroupListModel *originGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:indexModel.group_id classType:indexModel.class_type];
    originGroupModel.unread_log_count = @"0";
    [JGJChatMsgDBManger updateChatGroupListTableTheUnread_work_countWithGroupListModel:originGroupModel group_id:indexModel.group_id class_type:indexModel.class_type];
}

#pragma mark - 消息回复列表
- (void)replyButtonClick {
    
    JGJQualityMsgReplyListVc *msgReplyListVc = [JGJQualityMsgReplyListVc new];
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    commonModel.msg_type = @"log";
    
    msgReplyListVc.commonModel = commonModel;
    
    msgReplyListVc.proListModel = self.workProListModel;
    
    [self.navigationController pushViewController:msgReplyListVc animated:YES];
    
}

- (IBAction)releaseLogButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        [TYShowMessage showPlaint:showPlaint];
        return;
    }
    
//    JGJChatNoticeVc *logVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
//    logVc.pro_name = self.workProListModel.pro_name;
//    logVc.chatListType = JGJChatListLog;
//    logVc.workProListModel = self.workProListModel;
//    [self.navigationController pushViewController:logVc animated:YES];
    
    JGJBuilderDiaryViewController *BuilderVC = [JGJBuilderDiaryViewController new];
    BuilderVC.WorkCicleProListModel = self.workProListModel;
    [self.navigationController pushViewController:BuilderVC animated:YES];

}
-(JGJPublishLogButton *)bottemButton
{
    if (!_bottemButton) {
        
        CGFloat navBarHeight = 0;
        
        if (isiPhoneX) {
            navBarHeight = 34;
        }
        _bottemButton = [[JGJPublishLogButton alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight - 134 - navBarHeight, TYGetUIScreenWidth, 70)];
        _bottemButton.backgroundColor = [UIColor whiteColor];
        _bottemButton.delegate = self;
        _bottemButton.publishLogButton.backgroundColor = AppFontEB4E4EColor;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        lable.backgroundColor = AppFontf1f1f1Color;
        [_bottemButton addSubview:lable];
    }
    return _bottemButton;
}


//选择日志模板
- (void)clickChoiceTemplateLogButton {
    
    self.workProListModel.logTypes = choicelogTemplateType;
    if (_dataArrs) {
       
        [self initLogViewwithArr:_dataArrs];
    }

}
//上次发送的日志类型 发通用日志或者上次的日志类型
- (void)clickChoicePublsihLogButton {
    
    BOOL NoDeleteModel = NO;
    
    JGJBuilderDiaryViewController *BuilderVC = [JGJBuilderDiaryViewController new];
    self.workProListModel.logTypes = choicelogTemplateType;
    BuilderVC.WorkCicleProListModel = self.workProListModel;
    
    JGJGetLogTemplateModel *model = [JGJGetLogTemplateModel new];
    NSData *data = [TYUserDefaults objectForKey:JGJOldLogType];
    if (data) {
        model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([NSString isEmpty:model.cat_id] && [NSString isEmpty:model.cat_name]) {
            //第一次进入
            model.cat_id = @"";
            model.cat_name = @"通用日志";
            NoDeleteModel = YES;
            
        }else{
            if ([NSString isEmpty:model.cat_id] && ![NSString isEmpty:model.cat_name]) {
                model.cat_id = @"";
                model.cat_name = @"通用日志";
                NoDeleteModel = YES;
                
            }else{
                for (int index = 0; index <_dataArrs.count; index ++) {
                    if ([[_dataArrs[index] cat_id] isEqualToString:model.cat_id]) {
                        NoDeleteModel = YES;
                    }
                }
            }
        }
        if (NoDeleteModel) {
            BuilderVC.GetLogTemplateModel = model;
            self.workProListModel.logTypes = choicelogTemplateType;
            [self.navigationController pushViewController:BuilderVC animated:YES];
        }else{
            [TYShowMessage showError:@"该日志模板已停用，请使用其他日志模板"];
            [_bottemButton.publishLogButton setTitle:@"发通用日志" forState:UIControlStateNormal];
            
            model.cat_id = @"";
            model.cat_name = @"通用日志";
            NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:model];
            [TYUserDefaults setObject:udObject forKey:JGJOldLogType];
            
            
        }
        
    }else{
        model.cat_id = @"";
        model.cat_name = @"通用日志";
        [_bottemButton.publishLogButton setTitle:@"发通用日志" forState:UIControlStateNormal];
        BuilderVC.GetLogTemplateModel = model;
        self.workProListModel.logTypes = choicelogTemplateType;
        [self.navigationController pushViewController:BuilderVC animated:YES];
    }
    
    
}
- (void)initLogViewwithArr:(NSMutableArray *)arr{
    //    __weak weakself = self;
  
    BOOL isShowAdd;
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        
        isShowAdd = NO;
    }else {
        
        isShowAdd = YES;
    }
    JGJMoreLogView *moreView = [[JGJMoreLogView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight , TYGetUIScreenWidth, 270) ishowAddRow:isShowAdd didSelectedIndexPathBlock:^(NSIndexPath *indexpath) {
        if (indexpath.row >= _dataArrs.count) {
            if ([self.workProListModel.is_senior intValue]) {//黄金版
                
                [JGJLogAlertView  showBottemRedAndIkownWithContent:nil andClickCancelButton:^(NSString *content) {
                    
                }];
            }else{
                
                //普通半
                [JGJBuyAlerView showBottemMoreButtonWithContent:nil andClickCancelButton:^(NSString *content) {

                    //弹框申请
                    JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];
                    
                    request.group_id = self.workProListModel.group_id;
                    
                    request.class_type = self.workProListModel.class_type;
                    
                    request.server_type = @"1";
                    
                    [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {
                        
                        
                    }];
                    
                } cancelBlock:^(NSString *content) {
                    
                }];
            }
            //此处是点几了加号
            return ;
        }
        
        
        JGJBuilderDiaryViewController *BuilderVC = [JGJBuilderDiaryViewController new];
        BuilderVC.WorkCicleProListModel = self.workProListModel;
        BuilderVC.GetLogTemplateModel = _dataArrs[indexpath.row];
        
        // 获取 之前发送日志保存的缓存
        NSDictionary *moreDic = [TYUserDefaults objectForKey:JGJBuilderDiaryMoreparmDic];
        if (moreDic.allKeys.count > 0) {
            
            NSString *cat_id = [moreDic objectForKey:@"cat_id"];
            // 选择的模板不同 清空缓存
            if (![BuilderVC.GetLogTemplateModel.cat_id isEqualToString:cat_id]) {
                
                [TYUserDefaults setObject:[NSMutableDictionary dictionary] forKey:JGJBuilderDiarymoreWeatherParm];
                [TYUserDefaults setObject:[NSMutableDictionary dictionary] forKey:JGJBuilderDiaryMoreparmDic];
                
            }
        }
        
        self.workProListModel.logTypes = choicelogTemplateType;
        JGJGetLogTemplateModel *model = _dataArrs[indexpath.row];
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:model];
        [TYUserDefaults setObject:udObject forKey:JGJOldLogType];
        [self.navigationController pushViewController:BuilderVC animated:YES];
        
    } initWithArr:arr];
    [self.view addSubview:moreView];
    
    [moreView show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _model = [JGJGetLogTemplateModel new];
    NSData *data = [TYUserDefaults objectForKey:JGJOldLogType];
    _model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [_bottemButton.publishLogButton setTitle:_model.cat_name?[@"发" stringByAppendingString: _model.cat_name]:@"发通用日志" forState:UIControlStateNormal];
    
}

#pragma mark - 获取所有自定义日志模板
-(void)getApproval
{
    NSDictionary *paridc;
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        
        paridc = @{@"type":@"grouplog",
                   @"sort":@"",
                   @"group_id":self.workProListModel.group_id,
                   @"class_type":self.workProListModel.class_type,
                   
                   };
    }else {
        
        paridc = @{@"type":@"log",
                   @"sort":@"",
                   @"group_id":self.workProListModel.group_id,
                   @"class_type":self.workProListModel.class_type,
                   
                   };
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"/v2/Approval/approvalCatList" parameters:paridc success:^(id responseObject) {
        //    _dataArrs = [NSMutableArray array];
        _dataArrs = [JGJGetLogTemplateModel mj_objectArrayWithKeyValuesArray:responseObject];
        //    [self initLogViewwithArr:_dataArrs];
        
    } failure:^(NSError *error) {
        
    }];
    
}

//发施工日志
- (JGJMsgFlagView *)msgFlagView {
    
    if (!_msgFlagView) {
        
        _msgFlagView = [[JGJMsgFlagView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        
        [_msgFlagView setHiddenFlagView:YES];
    }
    
    return _msgFlagView;
}

- (void)setCur_name:(NSString *)cur_name {
    
    [super setCur_name:cur_name];
}

#pragma mark - 小铃铛标识
- (void)freshMessage {
    
    [self.msgFlagView setHiddenFlagView:!self.is_new_message];
}

@end
