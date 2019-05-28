//
//  JGJBaseMenuView.h
//  mix
//
//  Created by yj on 2018/5/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberImpressTagView.h"

#define JGJBaseMenuViewDurTime 0.4

@class JGJFirstFilterView;

typedef void(^JGJBaseMenuViewBlock)(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel, NSArray *tagModels, NSArray *remark_tagModels, NSArray *desInfos, BOOL isRest, NSArray *seltagModels, NSArray *selremark_tagModels, NSArray *agentags, NSArray *selAgentags);

@interface JGJBaseMenuView : UIView

@property (nonatomic, assign) CGFloat limiWidth;

//全部的项目
@property (nonatomic, strong) NSArray *allPros;

//全部的班组长
@property (nonatomic, strong) NSArray *allMembers;

//默认选中参数
@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

@property (nonatomic, copy) JGJBaseMenuViewBlock baseMenuViewBlock;

//类型标签
@property (nonatomic, strong) NSMutableArray *recordTags;

//备注标签
@property (nonatomic, strong) NSMutableArray *notetags;

//代理人标签
@property (nonatomic, strong) NSMutableArray *agencytags;

//选中的传入类型标签
@property (nonatomic, strong) NSArray *selrecordTtags;

//选中的传入备注标签
@property (nonatomic, strong) NSArray *selnotetags;

//选中的传入是否有代理人标签
@property (nonatomic, strong) NSMutableArray *selAgencytags;


//传入之前筛选的模型
@property (nonatomic, strong) NSMutableArray *proInfos;

//当前状态
@property (nonatomic, assign) BOOL isRest;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

- (instancetype)initWithFrame:(CGRect)frame proListModel:(JGJMyWorkCircleProListModel *)proListModel;

- (void)pushView;

// 是否代理班组长
- (BOOL)isAgency;

@end
