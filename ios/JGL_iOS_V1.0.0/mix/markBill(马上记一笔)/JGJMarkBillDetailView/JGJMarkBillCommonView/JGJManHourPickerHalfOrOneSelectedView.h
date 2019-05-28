//
//  JGJManHourPickerHalfOrOneSelectedView.h
//  mix
//
//  Created by Tony on 2018/11/22.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@protocol JGJManHourPickerHalfOrOneSelectedViewDelegate <NSObject>

- (void)selectedHalfOrOneTimeWithTimeStr:(NSString *)timeSelected isManHourTime:(BOOL)isManHourTime;

@end
@interface JGJManHourPickerHalfOrOneSelectedView : UIView

@property (nonatomic, weak) id<JGJManHourPickerHalfOrOneSelectedViewDelegate> halfOrOneDelegate;

@property (nonatomic, assign) BOOL isManHourTime;// 是否显示正常上班时间
@property (nonatomic, assign) BOOL isContractType;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@end
