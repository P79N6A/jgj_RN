//
//  JGJRecordWorkpointsAllTypeMoneyCell.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJRecordWorkpointsAllTypeMoneyCell : UITableViewCell

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

+(CGFloat)cellHeight;

//显示类型
@property (nonatomic, assign) NSInteger showType;

@property (weak, nonatomic) IBOutlet LineView *bottomLineView;

@end
