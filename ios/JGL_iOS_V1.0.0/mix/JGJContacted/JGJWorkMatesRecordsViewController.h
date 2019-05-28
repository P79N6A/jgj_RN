//
//  JGJWorkMatesRecordsViewController.h
//  mix
//
//  Created by Tony on 2017/7/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordWorkHomeMoneyView.h"
#import "YZGWorkDayModel.h"
#import "YZGMateBillRecordWorkpointsView.h"

@interface JGJWorkMatesRecordsViewController : UIViewController
<
YZGMateBillRecordWorkpointsViewDelegate
>
@property(nonatomic,strong)UIScrollView *mainscrollView;
@property (strong, nonatomic) RecordWorkHomeMoneyView *recordWorkHomeMoneyView;
@property (nonatomic,copy) NSString *postApiString;//接口名字
@property (nonatomic,strong) YZGWorkDayModel *yzgWorkDayModel;

@property (nonatomic, assign) BOOL isShowChangeRole;// 是否显示 切换身份
@end
