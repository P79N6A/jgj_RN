//
//  JGJAgentMonitorInfoCell.h
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordWorkpointsChangeModel.h"
#import "JGJRecordChangeListOtherBubbleView.h"
#import "JGJRecordWorkpointsChangeNewlyIncreasedView.h"
@interface JGJAgentMonitorInfoCell : UITableViewCell

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) JGJRecordWorkpointsChangeModel *changeInfoModel;
@property (nonatomic, strong) JGJRecordChangeListOtherBubbleView *otherBubbleView;
@property (nonatomic, strong) JGJRecordWorkpointsChangeNewlyIncreasedView *newlyIncreasedView;// 新增

@property (nonatomic, strong) NSIndexPath *indexPath;
@end
