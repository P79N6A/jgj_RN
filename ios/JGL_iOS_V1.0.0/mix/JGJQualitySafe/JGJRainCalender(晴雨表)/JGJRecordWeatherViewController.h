//
//  JGJRecordWeatherViewController.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordWeatherViewController : UIViewController
@property (nonatomic , strong)UITableView *tableview;
@property (nonatomic , strong)JGJRecordWeatherModel *recordWeatherModel;
@property (nonatomic , strong)JGJMyWorkCircleProListModel *WorkCicleProListModel;
@property (nonatomic , assign)BOOL EditeCalender;
@property (nonatomic ,strong)NSDate *currentDate;
@property (nonatomic ,strong)NSString *calenderDay;//这一天的农历时间

@end
