//
//  JGJCusSwitchMsgCell.h
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@class JGJCusSwitchMsgCell;
@protocol JGJCusSwitchMsgCellDelegate <NSObject>

@optional
- (void)cusSwitchMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType;
@end
@interface JGJCusSwitchMsgCell : UITableViewCell
@property (weak, nonatomic) id <JGJCusSwitchMsgCellDelegate> delegate;
@property (assign, nonatomic)JGJCusSwitchMsgCellType switchMsgCellType;
@property (strong, nonatomic) JGJChatDetailInfoCommonModel *commonModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
/**
 *  项目组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

//全屏宽度显示
@property (nonatomic, assign) BOOL isAllScreenWShow;
@end
