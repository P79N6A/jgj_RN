//
//  JGJUnWagesShortWorkCell.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWTableViewCell.h"

@interface JGJUnWagesShortWorkCell : SWTableViewCell

@property (assign, nonatomic) BOOL isHiddenLineView;

@property (strong, nonatomic) JGJRecordWorkPointListModel *listModel;

//是否显示工否则显示小时
@property (nonatomic, assign) BOOL isShowWork;

//是否批量删除
@property (nonatomic, assign) BOOL isBatchDel;

@property (nonatomic, assign) BOOL isScreenShowLine;

//显示类型
@property (nonatomic, assign) NSInteger showType;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *nextImageView;

@property (nonatomic, assign) BOOL isCurrentSureBillVCComeIn;


@end
