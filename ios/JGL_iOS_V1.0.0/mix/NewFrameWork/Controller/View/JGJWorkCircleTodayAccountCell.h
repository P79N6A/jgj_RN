//
//  JGJWorkCircleTodayAccountCell.h
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWorkDayModel.h"

typedef enum : NSUInteger {
    TodayAccountCellNotifyButtonType,
    TodayAccountCellSynProButtonType,
    TodayAccountCellCheckRecordButtonType,
    TodayAccountCellRecordButtonType
} TodayAccountCellButtonType;

typedef void(^JGJWorkCircleTodayAccountCellBlock)(TodayAccountCellButtonType);
@interface JGJWorkCircleTodayAccountCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)  YZGWorkDayModel *yzgWorkDayModel;
@property (nonatomic, assign) TodayAccountCellButtonType accountCellButtonType;
@property (nonatomic, copy) JGJWorkCircleTodayAccountCellBlock todayAccountCellBlock;
//2.1.0未读数添加
@property (nonatomic, copy) NSString *unread_msg_count; //工作消息未读数
@end
