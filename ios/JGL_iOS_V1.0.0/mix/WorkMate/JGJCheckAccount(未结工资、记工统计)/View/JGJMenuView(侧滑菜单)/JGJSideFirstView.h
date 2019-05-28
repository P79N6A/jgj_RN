//
//  JGJSideFirstView.h
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJFilterSideView.h"

#import "JGJCusNavBar.h"

#import "JGJComTitleDesCell.h"

#import "JGJMemberImpressTagView.h"

typedef void(^JGJSideFirstViewBlock)(NSArray *infos, JGJMemberImpressTagView *tagView);

@interface JGJSideFirstView : UIView

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) NSMutableArray *containViews;

@property (nonatomic, strong) JGJFilterSideView *sideView;

@property (nonatomic, strong, readonly) JGJCusNavBar *cusNavBar;

//传入之前筛选的模型
@property (nonatomic, strong, readonly) NSMutableArray *desInfos;

//初始化数据
@property (nonatomic, strong) NSMutableArray *oriDesInfos;

@property (nonatomic, copy) JGJSideFirstViewBlock filterBlock;

//设置数据
- (void)setDecCellWithIndexPath:(NSIndexPath *)indexpath desInfoModel:(JGJComTitleDesInfoModel *)desInfoModel;

@end
