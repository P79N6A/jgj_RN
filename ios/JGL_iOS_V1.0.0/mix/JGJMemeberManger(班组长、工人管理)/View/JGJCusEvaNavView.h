//
//  JGJCusEvaNavView.h
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCusEvaNavViewClosedButtonPressedBlock)(void);

@interface JGJCusEvaNavView : UIView

@property (copy, nonatomic) JGJCusEvaNavViewClosedButtonPressedBlock closedButtonPressedBlock;

@end
