//
//  JGJRecordsViewController.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FScalendar.h"
#import "YZGWorkDayModel.h"
#import "YZGMateWorkitemsViewController.h"
#import "YZGMateBillRecordWorkpointsView.h"
#import "YZGGetIndexRecordViewController.h"
#import "RecordWorkHomeMoneyView.h"
@interface JGJRecordsViewController : UIViewController
<
YZGMateBillRecordWorkpointsViewDelegate
>
@property (strong, nonatomic) IBOutlet RecordWorkHomeMoneyView *recordWorkHomeMoneyView;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic,copy) NSString *postApiString;//接口名字
@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic,strong) YZGWorkDayModel *yzgWorkDayModel;
@property (strong, nonatomic) IBOutlet UILabel *secondlab;
@property (strong, nonatomic) IBOutlet UILabel *threelab;
@property (strong, nonatomic) IBOutlet UILabel *fourlab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarConstance;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *billlyout;//记工流水比例
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;
- (void)JLGHttpRequest;

/**
 *  初始化记工流水的View
 */
- (void)setUpRecordWorkView;


/**
 *  配饰recordWorkView
 *
 *  @param section 是第几排，如果是第一排,section(tag)为1，如果是第二排,section(tag)为2
 *  @param index   是第几个，如果是第一个,index(tag)为1,如果是第二个,index(tag)为2
 */
- (void)RecordWorkViewBtnClick:(NSInteger)section index:(NSInteger )index;

/**
 *  刷新红点
 */
- (void)RecordWorkViewReloadData;
- (void)ClickDownButton;

- (void)pushToWorkitemsVc:(NSDate *)date;
@end
