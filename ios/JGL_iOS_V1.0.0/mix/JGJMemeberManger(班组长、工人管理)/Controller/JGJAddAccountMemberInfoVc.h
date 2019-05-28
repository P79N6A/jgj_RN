//
//  JGJAddAccountMemberInfoVc.h
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJAddAccountMemberInfoVcBlock)(JGJSynBillingModel *memberModel);

@interface JGJAddAccountMemberInfoVc : UIViewController

@property (nonatomic, copy) JGJAddAccountMemberInfoVcBlock addAccountMemberInfoVcBlock;

@property (nonatomic, strong, readonly) NSMutableArray *dataSource;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@end
