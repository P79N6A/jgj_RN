//
//  JGJWebUnSeniorPayVc.m
//  JGJCompany
//
//  Created by yj on 2017/8/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWebUnSeniorPayVc.h"

#import "JGJQuaSafeOrderDefaultView.h"

#import "JGJSureOrderListViewController.h"

#import "JGJGroupMangerTool.h"

#import "JGJWebAllSubViewController.h"

@interface JGJWebUnSeniorPayVc ()

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *orderDefaultView;

@end

@implementation JGJWebUnSeniorPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
 
    [self.view addSubview:self.orderDefaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JGJQuaSafeOrderDefaultView *)orderDefaultView {
    
    if (!_orderDefaultView) {
        
        _orderDefaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"点击了解该功能";
        
        infoModel.desInfo = @"如需使用该功能，请点击申请，\n我们的客服将尽快与你联系";
        
        infoModel.actionButtonTitle = @"申请";
        
        _orderDefaultView.infoModel = infoModel;
        
        __weak typeof(self) weakSelf = self;
        
        _orderDefaultView.handleQuaSafeOrderDefaultViewBlock = ^(JGJQuaSafeOrderDefaultViewButtonType buttonType, JGJQuaSafeOrderDefaultView *defaultView) {
                        
            [weakSelf handleDefaultAction:buttonType];
            
        };
    }
    
    //获取当前项目有没有购买过
    _orderDefaultView.workProListModel = self.proListModel;
    
    return _orderDefaultView;
}

#pragma mark - 处理缺省页事件订购
- (void)handleDefaultAction:(JGJQuaSafeOrderDefaultViewButtonType)buttonType {
    
    switch (buttonType) {
            
        case QuaSafeOrderDefaultViewDesButtonType:{
            
            [self clickedHelpCenter];
        }
            
            break;
            
        case QuaSafeOrderDefaultViewActionButtonType:{
            
            [self handleOrderVcWithBuyGoodType:VIPServiceType];
        }
            
            break;
            
        case QuaSafeOrderDefaultViewTryUseActionButtonType:{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 进入购买页面
- (void)handleOrderVcWithBuyGoodType:(BuyGoodType)buyGoodType {
    
    JGJServiceOverTimeRequest *request = [JGJServiceOverTimeRequest new];
    
    request.group_id = self.proListModel.group_id;
    
    request.class_type = self.proListModel.class_type;
    
    request.server_type = @"1";
    
    [JGJServiceOverTimeRequest serviceOverTimeRequest:request requestBlock:^(id response) {
        
        
    }];
    
//    JGJSureOrderListViewController *SureOrderListVC = [[UIStoryboard storyboardWithName:@"JGJSureOrderListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSureOrderListVC"];
//    
//    SureOrderListVC.GoodsType = buyGoodType;
//    
//    JGJOrderListModel *orderListModel = [JGJOrderListModel new];
//    
//    orderListModel.group_id = self.proListModel.group_id;
//    
//    orderListModel.upgrade = YES;
//    
//    orderListModel.class_type = self.proListModel.class_type;
//    
//    orderListModel.goodsType = VIPServiceType;
//        
//    SureOrderListVC.orderListModel = orderListModel;
//    
//    [self.navigationController pushViewController:SureOrderListVC animated:YES];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    SureOrderListVC.notifyServiceSuccessBlock = ^(id response) {
//        
//        if (weakSelf.webUnSeniorPayVcBlock) {
//            
//            weakSelf.webUnSeniorPayVcBlock(response);
//        }
//    
//    };
    
}

#pragma makr - 进入帮助中心
- (void)clickedHelpCenter {
    
    NSString *webUrl = @"";
    
    switch (self.webUnSeniorPayVcType) {
            
        case JGJWebUnSeniorPayVcEquipmentType:{ //设备
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"help/hpDetail?id=101&close=0"];
            
        }
            
            break;
            
        case JGJWebUnSeniorPayVcQualityCheckType:{ //质量检查
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"help/hpDetail?id=182"];
        }
            
            break;
            
        case JGJWebUnSeniorPayVcQualityStaType:{ //质量统计
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"help/hpDetail?id=104"];
        }
            
            break;
            
        case JGJWebUnSeniorPayVcSafeCheckType:{ //安全检查
            //            help/hpDetail?id=99
            
        }
            
            break;
            
        case JGJWebUnSeniorPayVcSafeStaType:{ //安全统计
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"help/hpDetail?id=103"];
        }
            
            break;
            
        case JGJWebUnSeniorPayVcCheckType:{ //检查
            
            webUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"help/hpDetail?id=182"];
        }
            
            break;
            
        default:
            break;
    }
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}

@end
