//
//  JGJSureOrderListViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJSurePayView.h"
typedef NS_ENUM(NSInteger ,BuyGoodType){
    VIPServiceType,
    CloudNumType,
};
@interface JGJSureOrderListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet JGJSurePayView *buyView;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkCircleProListModel;
@property (nonatomic, strong) JGJMyRelationshipProModel *MyRelationshipProModel;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (assign ,nonatomic)BuyGoodType GoodsType;

//通知订购成功回调
@property (nonatomic, copy) NotifyServiceSuccessBlock notifyServiceSuccessBlock;
@end
