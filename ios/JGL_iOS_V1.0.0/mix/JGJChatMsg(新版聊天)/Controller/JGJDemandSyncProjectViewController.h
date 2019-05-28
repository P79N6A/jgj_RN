//
//  JGJDemandSyncProjectViewController.h
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

typedef void(^RefuseDemandSyncProjectOrBillBlock)(id info);
typedef void(^SuccessDemandSyncProjectOrBillBlock)(id info);
@interface JGJDemandSyncProjectViewController : UIViewController

// 拒绝同步项目或拒绝同步记工
@property (nonatomic, copy) RefuseDemandSyncProjectOrBillBlock refuseDemandSyncProjectOrBill;
// 同步项目成功或同步记工成功
@property (nonatomic, copy) SuccessDemandSyncProjectOrBillBlock successDemandSyncProjectOrBill;

@property (nonatomic, strong) JGJChatMsgListModel *msgModel;
@end
