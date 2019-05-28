//
//  JGJRecordWorkpointTypeCountCell.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordWorkpointTypeCountCell : UITableViewCell

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

//是否显示工否则显示小时
@property (nonatomic, assign) BOOL isShowWork;

//显示类型
@property (nonatomic, assign) NSInteger showType;

@end
