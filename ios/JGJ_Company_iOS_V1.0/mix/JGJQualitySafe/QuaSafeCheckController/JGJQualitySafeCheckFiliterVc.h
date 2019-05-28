//
//  JGJQualitySafeCheckFiliterVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQualitySafeCheckFiliterVc;

@protocol JGJQualitySafeCheckFiliterVcDelegate <NSObject>

@optional

- (void)qualityFilterVc:(JGJQualitySafeCheckFiliterVc *)filterVc;

@end

@interface JGJQualitySafeCheckFiliterVc : UIViewController

//能够选择的整改负责人
@property (nonatomic, strong) NSArray *principalModels;

//上次选中的
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

//问题状态和严重程度
@property (nonatomic, strong) NSMutableArray *firstSectionInfos;

//计划人、提交人
@property (nonatomic, strong, readonly) NSMutableArray *thirdSectionInfos;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//严重程度,存放全部状态.反选使用
@property (nonatomic, strong) NSArray *qualityLevelModels;

//质量问题状态
@property (nonatomic, strong) NSArray *qualityStatusModels;

//保存请求数据
@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row;

@property (nonatomic, weak) id <JGJQualitySafeCheckFiliterVcDelegate> delegate;

@end
