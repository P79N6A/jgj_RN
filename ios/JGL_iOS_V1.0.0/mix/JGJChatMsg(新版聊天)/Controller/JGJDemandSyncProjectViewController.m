//
//  JGJDemandSyncProjectViewController.m
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJDemandSyncProjectViewController.h"
#import "JGJSyncProjectInfoDetailView.h"
#import "JGJSyncProjectInfoBottomView.h"
#import "FDAlertView.h"
#import "JGJAddSynInfoVc.h"
#import "JGJWorkingChatMsgViewController.h"
@interface JGJDemandSyncProjectViewController ()<FDAlertViewDelegate>

@property (nonatomic, strong) JGJSyncProjectInfoDetailView *infoDetailView;
@property (nonatomic, strong) JGJSyncProjectInfoBottomView *bottomView;
@end

@implementation JGJDemandSyncProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontECECECColor;
    
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.infoDetailView];
    
    [self setUpLayout];
    
    TYWeakSelf(self);
    _bottomView.bottomBlock = ^(NSInteger index) {
      
        if (weakself.msgModel.chatListType == JGJChatListDemandSyncProjectType || weakself.msgModel.chatListType == JGJChatListDemandSyncBillType) {// 同步项目请求或同步记工请求
            if (index == 0) {// 拒绝同步项目或者拒绝同步同步记工
                
                NSString *alertStr = [NSString stringWithFormat:@"你确定要拒绝同步项目给%@吗?",weakself.msgModel.user_info.real_name];;
                
                FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:alertStr delegate:weakself buttonTitles:@"取消",@"确认拒绝", nil];
                
                alert.isHiddenDeleteBtn = YES;
                [alert setMessageColor:AppFont000000Color fontSize:16];
                
                [alert show];
                
            }else if (index == 1) {// 同意同步项目或者同意同步记工
                
                [TYLoadingHub showLoadingWithMessage:nil];
                
                [JLGHttpRequest_AFN PostWithNapi:@"sign/get-user-info-by-uid" parameters:@{@"uid":weakself.msgModel.msg_sender} success:^(id responseObject) {
                    
                    [TYLoadingHub hideLoadingView];
                    JGJAddSynInfoVc *synInfoVc = [[JGJAddSynInfoVc alloc] init];
                    if (weakself.msgModel.chatListType == JGJChatListDemandSyncProjectType) {// 同步项目
                        
                        synInfoVc.syncType = JGJSyncRecordWorkType;
                        
                    }else if (weakself.msgModel.chatListType == JGJChatListDemandSyncBillType) {// 同步记工
                        
                        synInfoVc.syncType = JGJSyncRecordWorkAndAccountsType;
                    }
                    JGJNewNotifyModel *notifyModel = [[JGJNewNotifyModel alloc] init];
                    
                    notifyModel.target_uid = [NSString stringWithFormat:@"%@",responseObject[@"uid"]];
                    notifyModel.user_name = responseObject[@"real_name"]?:@"";
                    notifyModel.msg_id = weakself.msgModel.msg_id;
                    
                    synInfoVc.notifyModel = notifyModel;
                    [weakself.navigationController pushViewController:synInfoVc animated:YES];
                    
                    synInfoVc.synSuccessBlock = ^(NSDictionary *dic) {
                        
                        if (weakself.successDemandSyncProjectOrBill) {
                            
                            weakself.successDemandSyncProjectOrBill(dic);
                        }
                        for (UIViewController *vc in weakself.navigationController.viewControllers) {
                            
                            if ([vc isKindOfClass:[JGJWorkingChatMsgViewController class]]) {
                                
                                [weakself.navigationController popToViewController:vc animated:YES];
                            }
                        }
                        
                    };
                    
                } failure:^(NSError *error) {
                    
                    [TYLoadingHub hideLoadingView];
                }];
                
            }
        }
        
    };
}


- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"sync/refuse-sync-project" parameters:@{@"msg_id":self.msgModel.msg_id} success:^(id responseObject) {
            
            TYLog(@"拒绝同步回调 = %@",responseObject);
        
            if (self.refuseDemandSyncProjectOrBill) {// 拒绝同步项目或拒绝同步记工
                
                self.refuseDemandSyncProjectOrBill(responseObject);
            }

            [self.navigationController popViewControllerAnimated:YES];

            [TYLoadingHub hideLoadingView];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
            
        }];
        
    }
}
- (void)setUpLayout {
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-JGJ_IphoneX_BarHeight);
        make.height.mas_equalTo(60);
    }];
    
    [_infoDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.equalTo(_bottomView.mas_top).offset(0);
    }];
}

- (void)setMsgModel:(JGJChatMsgListModel *)msgModel {
    
    _msgModel = msgModel;
    if (_msgModel.chatListType == JGJChatListDemandSyncProjectType) {
        
        self.title = @"要求同步项目";
        
    }else if (_msgModel.chatListType == JGJChatListDemandSyncBillType) {
        
        self.title = @"记工同步请求";
    }
    
    self.infoDetailView.msgModel = _msgModel;
}

- (JGJSyncProjectInfoDetailView *)infoDetailView {
    
    if (!_infoDetailView) {
        
        _infoDetailView = [[JGJSyncProjectInfoDetailView alloc] init];
    }
    return _infoDetailView;
}

- (JGJSyncProjectInfoBottomView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[JGJSyncProjectInfoBottomView alloc] init];
    }
    return _bottomView;
}

@end
