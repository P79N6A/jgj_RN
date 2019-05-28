//
//  JGJShowWorkDayView.h
//  mix
//
//  Created by Tony on 2018/7/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//  晒工天

#import <UIKit/UIKit.h>

typedef void(^ShowWorkDay)(void);
@interface JGJShowWorkDayView : UIView

@property (nonatomic, copy) ShowWorkDay showWorkDay;
@end
