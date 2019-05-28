//
//  JGJLogFilterViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,choiceTimeType){
    startTimeType,
    endTimeType,
};
@interface JGJLogFilterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (assign ,nonatomic) choiceTimeType timeType;
@property (strong ,nonatomic) JGJGetLogTemplateModel *getLogModel;
@property (strong ,nonatomic) NSMutableArray *dataArr;
@property (strong ,nonatomic) JGJMyWorkCircleProListModel *WorkCircleProListModel;
@property (strong ,nonatomic) JGJSetRainWorkerModel *peopleInfoModel;

@property (nonatomic, assign) BOOL isMeLogType;

@property (nonatomic,strong) JGJFilterLogModel *orignalFilterModel;
@property (nonatomic, copy) NSString *cur_name;

@end
