//
//  JGJDemandSyncProjectViewController.h
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

typedef void(^RefuseDemandSyncProjectBlock)(id info);
typedef void(^SuccessDemandSyncProjectBlock)(id info);
typedef void(^CreateNewProjectBlock)(NSDictionary *dic);
typedef void(^JoinCurrentProjectBlock)(NSDictionary *dic);
@interface JGJDemandSyncProjectViewController : UIViewController

// 拒绝同步项目或拒绝同步记工
@property (nonatomic, copy) RefuseDemandSyncProjectBlock refuseDemandSyncProject;
// 同步项目成功或同步记工成功
@property (nonatomic, copy) SuccessDemandSyncProjectBlock successDemandSyncProject;
// 创建新项目组
@property (nonatomic, copy) CreateNewProjectBlock createNewProjectBlock;
// 加入现有项目组
@property (nonatomic, copy) JoinCurrentProjectBlock joinCurrentProjectBlock;
@property (nonatomic, strong) JGJChatMsgListModel *msgModel;
@end
