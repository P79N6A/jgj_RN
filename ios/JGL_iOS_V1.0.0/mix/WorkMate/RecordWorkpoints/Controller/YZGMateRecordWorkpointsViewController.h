//
//  YZGMateRecordWorkpointsViewController.h
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FScalendar.h"
#import "YZGWorkDayModel.h"
#import "YZGMateWorkitemsViewController.h"
#import "YZGMateBillRecordWorkpointsView.h"
#import "YZGGetIndexRecordViewController.h"

@interface YZGMateRecordWorkpointsViewController : UIViewController
<
    YZGMateBillRecordWorkpointsViewDelegate
>
@property (nonatomic,copy) NSString *postApiString;//接口名字
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;//日历
@property (nonatomic,strong) YZGWorkDayModel *yzgWorkDayModel;

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
@end
