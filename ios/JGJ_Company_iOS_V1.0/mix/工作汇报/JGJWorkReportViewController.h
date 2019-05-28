//
//  JGJWorkReportViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGAddProExperienceViewController.h"
#import "JGJWorkReportTypeView.h"
#import "JGJChatMsgListModel.h"
typedef NS_ENUM(NSUInteger, workReportType) {
    JGJWorkReportTypeDay,
    JGJWorkReportTypeWeek,
    JGJWorkReportTypemonth
};
@interface JGJWorkReportViewController : JLGAddProExperienceViewController
@property (nonatomic ,strong)JGJWorkReportTypeView *WorkREportView;
@property (nonatomic ,assign)workReportType workReportType;
@property (nonatomic ,assign)JGJSendDailyModel *sendDailyModel;
@property(nonatomic ,strong)JGJChatMsgListModel *chatMsgListModel;//编辑修改的模型
@property (strong,nonatomic)JGJMyWorkCircleProListModel*WorkCicleProListModel;
@property (strong,nonatomic)JGJWorkReportSendModel*JGJWorkReportModel;
@property (strong,nonatomic)UITableView *WorkTableview;

@end
