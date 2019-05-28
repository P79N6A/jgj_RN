//
//  JGJBuilderDiaryViewController.h
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGAddProExperienceViewController.h"
#import "JGJChatMsgListModel.h"
typedef NS_ENUM(NSInteger ,LogchoiceTimeType){
    LogstartTimeType,
    LogendTimeType,
    logSingerTimeType,
};
@interface JGJBuilderDiaryViewController : JLGAddProExperienceViewController
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)JGJChatMsgListModel *chatMsgListModel;//编辑修改的模型
@property (strong ,nonatomic)JGJSendDailyModel *sendDailyModel;
@property (strong ,nonatomic)JGJMyWorkCircleProListModel*WorkCicleProListModel;
@property (nonatomic ,assign)BOOL eidteBuilderDaily;
@property (nonatomic ,assign)NSInteger LogId;
@property (nonatomic ,assign)LogchoiceTimeType choiceType;
@property (nonatomic ,strong)JGJGetLogTemplateModel *GetLogTemplateModel;
@property (nonatomic ,strong)JGJLogDetailModel *logEditeModel;
@property (nonatomic ,strong)NSMutableArray <JGJElementDetailModel *> *editeElementDetailModelArr;
@property (nonatomic ,strong)NSMutableDictionary *MoreparmDic;
@property (nonatomic ,strong)NSMutableDictionary *moreWeatherParm;
@property (nonatomic ,strong)NSMutableDictionary *timedic;
@property (nonatomic ,assign)BOOL chatRoomGo;
@property (nonatomic, strong) NSString *receiver_uid;

//3.5.2添加
@property (nonatomic,strong) JGJLogDetailModel *logDetailModel;;

@end
