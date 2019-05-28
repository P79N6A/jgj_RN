//
//  JGJCalendarViewController.h
//  mix
//
//  Created by YJ on 16/6/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CalendarVcBlock)(void);

@interface JGJCalendarViewController : UIViewController
@property (nonatomic, strong) JGJCalendarModel *calendarModel;

//日历返回回调当前用于webView隐藏头子用
@property (nonatomic, copy) CalendarVcBlock calendarVcBlock;
@end
