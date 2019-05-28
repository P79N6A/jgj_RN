//
//  JGJWorkCircleProTypeTableViewCell.h
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ProListImageIcons @[@"icon_quality", @"icon_security", @"icon_inspect", @"icon_task", @"icon_notice", @"icon_Sign", @"icon_metting", @"icon_examination", @"icon_log",  @"icon_barometer",@"icon_knowledge_base", @"icon_cloud", @"icon_website", @"icon_equipment", @"icon_report", @"icon_member_manger",@"icon_Team_management"]

#define ProListDescs @[@"质量", @"安全", @"检查", @"任务", @"通知",@"考勤签到", @"会议", @"审批", @"工作日志", @"晴雨表", @"资料库", @"云盘", @"微官网", @"设备管理",@"记工报表", @"成员管理",@"项目设置"]

#define SelItemHeight (TYGetUIScreenWidth / 4.0 - 10)

typedef enum : NSUInteger {
    ProTypeHeaderSwitchProButtonType,
    ProTypeHeaderChatButtonType,
    ProTypeHeaderWorkReplyButtonType,
} ProTypeHeaderButtonType;

@class JGJWorkCircleProTypeTableViewCell;
@protocol JGJWorkCircleProTypeTableViewCellDelegate <NSObject>

- (void)JGJWorkCircleProTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel;

- (void)proTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell buttonType:(ProTypeHeaderButtonType)buttonType;

@end

@interface JGJWorkCircleProTypeTableViewCell : UITableViewCell

@property (nonatomic, weak) id <JGJWorkCircleProTypeTableViewCellDelegate> delegate;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;


@end
