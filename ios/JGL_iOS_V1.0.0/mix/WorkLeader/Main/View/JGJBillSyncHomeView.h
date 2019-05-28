//
//  JGJBillSyncHomeView.h
//  mix
//
//  Created by jizhi on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateBillRecordWorkpointsView.h"

@interface JGJBillSyncHomeView : YZGMateBillRecordWorkpointsView

@property (strong, nonatomic) IBOutlet UILabel *firstLable;
@property (strong, nonatomic) IBOutlet UILabel *twolable;
@property (strong, nonatomic) IBOutlet UILabel *threelable;
@property (nonatomic,strong) YZGRecordWorkModel *thirdRecordWorkModel;//第三个模型
@end
