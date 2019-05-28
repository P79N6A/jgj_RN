//
//  JGJQualityFilterVc.h
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQualityFilterVc;

@protocol JGJQualityFilterVcDelegate <NSObject>

@optional

- (void)qualityFilterVc:(JGJQualityFilterVc *)filterVc;

@end

@interface JGJQualityFilterVc : UIViewController

//能够选择的整改负责人
@property (nonatomic, strong) NSArray *principalModels;

//上次选中的
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

//问题状态和严重程度
@property (nonatomic, strong) NSMutableArray *firstSectionInfos;

//整改负责人、问题提交人
@property (nonatomic, strong) NSMutableArray *fourSectionInfos;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//严重程度,存放全部状态.反选使用
@property (nonatomic, strong) NSArray *qualityLevelModels;

//质量问题状态
@property (nonatomic, strong) NSArray *qualityStatusModels;

//保存请求数据
@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row;

@property (nonatomic, weak) id <JGJQualityFilterVcDelegate> delegate;

//筛选类型
@property (nonatomic, assign) QuaSafeFilterType filterType;

//保存重置前的状态
@property (nonatomic, strong) JGJQualitySafeListRequestModel *lastRequestModel;

//能够选择的问题提交人
@property (nonatomic, strong) NSArray *commitModels;

//是否是重置状态
@property (nonatomic, assign, readonly) BOOL isReset;

@end
