//
//  JGJSummerViewController.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
@interface JGJSummerViewController : UIViewController
//@property(nonatomic ,strong)FSCalendar *calendar;
@property(nonatomic ,strong)UITableView *baseTableview;
@property(assign ,nonatomic)NSInteger calenderH;
@property (nonatomic , strong)JGJMyWorkCircleProListModel *WorkCicleProListModel;
@property (nonatomic , strong)JGJRainCalenderDetailModel *rainCalenderDetailModel;
@end
