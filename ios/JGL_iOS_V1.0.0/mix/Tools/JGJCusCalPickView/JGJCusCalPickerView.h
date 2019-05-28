//
//  JGJCusCalPickerView.h
//  mix
//
//  Created by YJ on 17/3/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "GYZCustomCalendarPickerView.h"

@class JGJCusCalPickerView;
typedef void(^HandleCusCalPickerViewBlock)(JGJCusCalPickerView *);
@interface JGJCusCalPickerView : GYZCustomCalendarPickerView
@property (nonatomic, copy) HandleCusCalPickerViewBlock handleCusCalPickerViewBlock;
- (void)hiddenPickView;
@end
