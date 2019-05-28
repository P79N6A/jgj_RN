//
//  JGJChatOhterListBaseVc.h
//  JGJCompany
//
//  Created by Tony on 2016/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"
#import "JGJRepeatInitView.h"
#import "UILabel+GNUtil.h"
#import "JGJLogHeaderView.h"
typedef void(^filterBlock)(JGJLogTotalListModel *LogTotalListModel);

@interface JGJChatOhterListBaseVc : JGJChatListBaseVc
<clickRepeatButtondelegate,
clickLogTopButtondelegate
>
@property (nonatomic,strong) NSMutableDictionary *parameters;
@property (nonatomic,strong) NSMutableArray      *datasource;
@property (nonatomic,strong) JGJLogTotalListModel      *LogTotalModel;
@property (nonatomic,copy) filterBlock filterBlocks;
@property (nonatomic,strong) JGJRepeatInitView *repeatView;
@property (nonatomic,strong) JGJLogHeaderView *headerView;
@property (nonatomic,assign) logClickType logQuestType;

@property (nonatomic,strong) JGJFilterLogModel *filterModel;
//小铃铛是否有新消息
@property (nonatomic, assign) BOOL is_new_message;

@property (nonatomic, copy) NSString *cur_name;
-(void)filterLogWithParamDic:(NSDictionary *)paramDic andtype:(logClickType)type andBlock:(filterBlock)blockArr;

-(void)filterLogWithParamDic:(NSDictionary *)paramDic andtype:(logClickType)type isFielterIn:(BOOL)isFielterIn;



@end
