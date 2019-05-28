//
//  JGJRecordWorkpointStaView.h
//  mix
//
//  Created by yj on 2018/7/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

typedef void(^TapActionBlock)(JGJRecordWorkPointModel *recordWorkPointModel);

@interface JGJRecordWorkpointStaView : UIView

@property (nonatomic, copy) TapActionBlock tapActionBlock;

@property (nonatomic, strong) JGJRecordWorkPointModel *recordWorkPointModel;

//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

//统计进入是否隐藏查看按钮
@property (nonatomic, assign) BOOL is_hidden_checkBtn;
@property (weak, nonatomic) IBOutlet LineView *topLineView;

@property (weak, nonatomic,readonly) IBOutlet UIButton *checkBtn;

+(CGFloat)staViewHeight;

@end
