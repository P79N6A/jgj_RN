//
//  JGJFirstFilterView.h
//  mix
//
//  Created by yj on 2018/5/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBaseMenuView.h"

#import "JGJMemberImpressTagView.h"

#import "JGJComTitleDesCell.h"

typedef enum : NSUInteger {
    
    JGJFirstFilterProType, //筛选项目
    
    JGJFirstFilterMemberType, //筛选选择工人

} JGJFirstFilterViewType;

@class JGJFirstFilterView;

typedef void(^JGJFirstFilterViewBlock)(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel, NSArray *tagModels, NSArray *remark_tagModels, NSArray *desInfo, BOOL isRest, NSArray *seltagModels, NSArray *selremark_tagModels, NSArray *agentags, NSArray *selAgentags);

@protocol JGJFirstFilterViewDelegate <NSObject>

- (void)filterView:(JGJFirstFilterView *)filterView filterViewType:(JGJFirstFilterViewType)filterViewType memberModel:(JGJSynBillingModel *)memberModel proModel:(JGJRecordWorkPointFilterModel *)proModel;

@end

@interface JGJFirstFilterView : JGJBaseMenuView

@property (nonatomic, weak) id <JGJFirstFilterViewDelegate> delegate;

//当前选中的人员
@property (strong, nonatomic) JGJSynBillingModel *selMemberModel;

//当前选中的项目
@property (strong, nonatomic) JGJRecordWorkPointFilterModel *selProModel;

@property (copy, nonatomic) JGJFirstFilterViewBlock filterViewBlock;

@property (nonatomic, strong, readonly) JGJMemberImpressTagView *tagView;

@property (nonatomic, strong, readonly) JGJMemberImpressTagView *remarkTagView;

//类型标签
@property (nonatomic, strong) NSArray *tags;

//备注标签
@property (nonatomic, strong) NSArray *remarktags;

//有无代理人标签
@property (nonatomic, strong) NSArray *agentags;

//选中类型标签
@property (nonatomic, strong) NSArray *selTags;

//选中备注标签
@property (nonatomic, strong) NSArray *selRemarktags;

//选中有无代理人标签
@property (nonatomic, strong) NSArray *selAgentags;

//传入之前筛选的模型
@property (nonatomic, strong) NSMutableArray *desInfos;

//默认选中参数
@property (nonatomic, strong) JGJRecordWorkStaListModel *staModel;

//代理人标签
@property (nonatomic, strong, readonly) JGJMemberImpressTagView *agencyTagView;

//代班模型
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proModel;

//确定筛选
- (void)confirmFilter;

//多个标签横向显示
- (NSString *)selTagModels:(NSArray *)tagModels;

@end
