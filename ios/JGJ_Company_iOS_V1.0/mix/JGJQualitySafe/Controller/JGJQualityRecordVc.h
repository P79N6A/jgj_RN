//
//  JGJQualityRecordVc.h
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JLGAddProExperienceViewController.h"

@interface JGJQualityRecordVc : JLGAddProExperienceViewController

//区分质量和安全
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (strong, nonatomic) NSIndexPath *lastIndexPath; //上次选中的

@property (strong, nonatomic) NSIndexPath *lastLevelIndexPath;

//严重程度,存放全部状态.反选使用
@property (nonatomic, strong) NSArray *qualityLevelModels;

//存放位置，严重程度
@property (nonatomic, strong, readonly) NSMutableArray *locaLevelInfos;

//所需整改 整改负责人 整改完成期限
@property (nonatomic, strong) NSMutableArray *prinTimeInfos;

//能够选择的整改负责人
@property (nonatomic, strong) NSArray *principalModels;

//刷新数据
- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row;

//添加检查记录带过去大项小项结果

@property (nonatomic, strong) JGJQuaSafeCheckRecordListModel *listModel;

@end
