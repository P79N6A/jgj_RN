#import "JGJDemandSyncProjectViewController.h"
#import "JGJSyncProjectInfoDetailView.h"
#import "JGJSyncProjectInfoBottomView.h"
#import "FDAlertView.h"
#import "JGJNewAddProlistVC.h"
#import "JGJWorkingChatMsgViewController.h"
#import "JGJCreatProCompanyVC.h"
#import "JGJNotifyJoinExistProVC.h"
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
        
        if (weakself.msgModel.chatListType == JGJChatListDemandSyncProjectType) {// 同步项目请求
            if (index == 0) {// 拒绝同步项目或者拒绝同步同步记工
                
                NSString *alertStr = [NSString stringWithFormat:@"你确定要拒绝同步项目给%@吗?",weakself.msgModel.user_info.real_name];;
                
                FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:alertStr delegate:weakself buttonTitles:@"取消",@"确认拒绝", nil];
                
                [alert setMessageColor:AppFont000000Color fontSize:16];
                
                [alert show];
                
            }else if (index == 1) {// 同意同步项目
                
                
                [TYLoadingHub showLoadingWithMessage:nil];
                [JLGHttpRequest_AFN PostWithNapi:@"sign/get-user-info-by-uid" parameters:@{@"uid":weakself.msgModel.msg_sender} success:^(id responseObject) {
                    
                    [TYLoadingHub hideLoadingView];
                    JGJNewAddProlistVC *newAddProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewAddProlistVC"];
                    newAddProlistVC.isWorkVCComeIn = YES;
                    JGJSynBillingModel *synBillingModel = [[JGJSynBillingModel alloc] init];
                    synBillingModel.target_uid = weakself.msgModel.msg_sender;
                    synBillingModel.msg_id = weakself.msgModel.msg_id;
                    synBillingModel.real_name = responseObject[@"real_name"]?:@"";
                    newAddProlistVC.synBillingModel = synBillingModel;
                    [weakself.navigationController pushViewController:newAddProlistVC animated:YES];
                    
                    newAddProlistVC.synProListSuccessBlock = ^(NSDictionary *dic) {
                        
                        if (weakself.successDemandSyncProject) {
                            
                            weakself.successDemandSyncProject(dic);
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
        }else if (weakself.msgModel.chatListType == JGJChatListSyncProjectToYouType) {// 创建新项目/加入现有项目组
            
            if (index == 0) {// 创建新项目
                
                JGJCreatProCompanyVC *creatProVC = [[UIStoryboard storyboardWithName:@"JGJCreatPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatProCompanyVC"];
                JGJNewNotifyModel *notifyModel = [[JGJNewNotifyModel alloc] init];
                notifyModel.target_uid = weakself.msgModel.msg_id;
                creatProVC.notifyModel = notifyModel;
                
                [weakself.navigationController pushViewController:creatProVC animated:YES];
                
                creatProVC.creatProSuccess = ^(NSDictionary *dic) {
                    
                    if (weakself.createNewProjectBlock) {
                        
                        weakself.createNewProjectBlock(dic);
                    }
                };
                
            }else if (index == 1) {// 加入现有项目
                
                JGJNewNotifyModel *notifyModel = [[JGJNewNotifyModel alloc] init];
                
                notifyModel.target_uid = weakself.msgModel.msg_id;
                notifyModel.team_name = weakself.msgModel.extend.pro_name;
                
                JGJNotifyJoinExistProVC *joinExistProVC = [[UIStoryboard storyboardWithName:@"JGJNewNotify" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNotifyJoinExistProVC"];
                joinExistProVC.notifyModel = notifyModel;
                [weakself.navigationController pushViewController:joinExistProVC animated:YES];
                
                joinExistProVC.notifyJoinExistProSuccessBlock = ^(NSDictionary *dic) {
                    
                    if (weakself.joinCurrentProjectBlock) {
                        
                        weakself.joinCurrentProjectBlock(dic);
                    }
                    
                };
            }
        }
        
    };
}


- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithNapi:@"sync/refuse-sync-project" parameters:@{@"msg_id":self.msgModel.msg_id} success:^(id responseObject) {
            
            
            if (self.refuseDemandSyncProject) {// 拒绝同步项目
                
                self.refuseDemandSyncProject(responseObject);
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
        
    }else if (_msgModel.chatListType == JGJChatListSyncProjectToYouType) {
        
        self.title = @"对你同步项目";
    }
    
    self.infoDetailView.msgModel = _msgModel;
    self.bottomView.msgModel = _msgModel;
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

