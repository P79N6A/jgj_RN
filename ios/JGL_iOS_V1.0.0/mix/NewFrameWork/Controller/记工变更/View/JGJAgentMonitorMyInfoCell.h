//
//  JGJAgentMonitorMyInfoCell.h
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordWorkpointsChangeModel.h"
#import "JGJRecordChangeListMyBubbleView.h"
#import "JGJRecordWorkpointsChangeNewlyIncreasedView.h"
@interface JGJAgentMonitorMyInfoCell : UITableViewCell

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) JGJRecordWorkpointsChangeModel *changeInfoModel;
@property (nonatomic, strong) JGJRecordChangeListMyBubbleView *myBubbleView;
@property (nonatomic, strong) JGJRecordWorkpointsChangeNewlyIncreasedView *newlyIncreasedView;// 新增

@property (nonatomic, strong) NSIndexPath *indexPath;
@end
