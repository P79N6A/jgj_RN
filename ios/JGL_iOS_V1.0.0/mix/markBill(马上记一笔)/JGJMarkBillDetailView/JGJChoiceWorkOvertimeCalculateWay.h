//
//  JGJChoiceWorkOvertimeCalculateWay.h
//  mix
//
//  Created by ccclear on 2019/4/15.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TheOvertimeWageByWay)(NSInteger btnIndex);
typedef void(^ClickTheOvertimeWageByWay)(void);

@interface JGJChoiceWorkOvertimeCalculateWay : UIView

@property (nonatomic, copy) TheOvertimeWageByWay theOvertimeWageByWay;
@property (nonatomic, copy) ClickTheOvertimeWageByWay clickTheOvertimeWageByWay;

@property (nonatomic, assign) BOOL overtimeWageByTheHour;

@end
