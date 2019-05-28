//
//  JGJRecordStaListHeaderView.h
//  mix
//
//  Created by yj on 2018/1/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

#import "JGJRecordHeader.h"

@interface JGJRecordStaListHeaderView : UIView

@property (strong, nonatomic) JGJRecordWorkStaModel *recordWorkStaModel;

@property (weak, nonatomic) IBOutlet LineView *topLineView;

//统计类型
@property (nonatomic, assign) JGJRecordStaType staType;

@end
