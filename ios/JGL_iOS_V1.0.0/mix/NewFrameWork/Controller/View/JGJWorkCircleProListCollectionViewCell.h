//
//  JGJWorkCircleProListCollectionViewCell.h
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//没有代班情况
#define GroupListImageIcons @[@"icon_Accounting", @"account_borrow_icon",@"account_books_icon", @"icon_Sign", @"icon_notice", @"icon_quality", @"icon_security", @"icon_log",@"icon_member_manger",@"icon_Team_management"]

#define GroupListDescs @[@"记工",@"借支/结算", @"出勤公示", @"考勤签到", @"通知", @"质量", @"安全",  @"工作日志",@"成员管理", @"班组设置"]

//我设置的代班情况
#define MySetAgencyListImageIcons @[@"icon_Accounting", @"account_borrow_icon",@"record_change_icon",@"account_books_icon", @"icon_Sign", @"icon_notice", @"icon_quality", @"icon_security", @"icon_log",@"icon_member_manger",@"icon_Team_management"]

#define MySetAgencyListDescs @[@"记工",@"借支/结算", @"记工变更",@"出勤公示", @"考勤签到", @"通知", @"质量", @"安全",  @"工作日志",@"成员管理", @"班组设置"]

//代班情况
#define AgencyGroupListImageIcons @[@"agency_record_icon",@"agency_workpoint_icon",@"agency_accountcheck_icon",@"record_change_icon",@"icon_Accounting", @"account_borrow_icon",@"account_books_icon", @"icon_Sign", @"icon_notice", @"icon_quality", @"icon_security", @"icon_log",@"icon_member_manger", @"icon_Team_management"]

#define AgencyGroupListDescs @[@"代班记工", @"代班流水", @"代班对账",@"记工变更",@"记工",@"借支/结算", @"出勤公示", @"考勤签到", @"通知", @"质量", @"安全",  @"工作日志", @"成员管理",@"班组设置" ]

//项目
#define ProListImageIcons @[@"icon_quality", @"icon_security", @"icon_inspect", @"icon_task", @"icon_notice", @"icon_Sign", @"icon_metting", @"icon_examination", @"icon_log",  @"icon_barometer",@"icon_knowledge_base", @"icon_cloud", @"icon_website", @"icon_equipment", @"icon_report", @"icon_member_manger",@"icon_Team_management"]

#define ProListDescs @[@"质量", @"安全", @"检查", @"任务", @"通知",@"考勤签到", @"会议", @"审批", @"工作日志", @"晴雨表", @"资料库", @"云盘", @"微官网", @"设备管理",@"记工报表",@"成员管理",@"项目设置"]

#define SelItemHeight (TYGetUIScreenWidth / 4.0 - 10)

static NSString *const CellID = @"JGJWorkCircleProListCollectionViewCell";

@class JGJWorkCircleProListCollectionViewCell;
@protocol JGJWorkCircleProListCollectionViewCellDelegate <NSObject>

- (void)workCircleProListCollectionViewCell:(JGJWorkCircleProListCollectionViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel;

@end
@interface JGJWorkCircleProListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)  JGJWorkCircleMiddleInfoModel *infoModel;

@property (nonatomic, weak) id <JGJWorkCircleProListCollectionViewCellDelegate> delegate;

@end
