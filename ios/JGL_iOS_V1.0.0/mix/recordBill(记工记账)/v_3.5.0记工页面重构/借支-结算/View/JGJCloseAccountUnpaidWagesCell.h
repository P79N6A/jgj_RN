//
//  JGJCloseAccountUnpaidWagesCell.h
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@interface JGJCloseAccountUnpaidWagesCell : UITableViewCell

@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic, strong,readonly) UIButton *unpaidWagesExplainBtn;// 未结工资说明按钮
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;


@end
