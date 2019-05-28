//
//  JGJCloseAccountSubsidyCell.h
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@interface JGJCloseAccountSubsidyCell : UITableViewCell

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic, assign) BOOL is_unfold_subsidyCell;// 是否展开 补贴 奖励 罚款cell
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@end
