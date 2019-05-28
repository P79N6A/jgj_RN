//
//  JGJMemberImpressTagView.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberMangerModel.h"

#import "JGJCusButton.h"

#import "JGJMemberMangerModel.h"

//最大标签数
#define MaxTagCount 5

@class JGJMemberImpressTagView;

@protocol JGJMemberImpressTagViewDelegate <NSObject>

- (void)tagView:(JGJMemberImpressTagView *)tagView sender:(JGJCusButton *)sender;

@end

@interface JGJMemberImpressTagView : UIView

-(JGJMemberImpressTagView *)tagViewWithTags:(NSArray *)tags tagViewType:(JGJMemberImpressTagViewType)tagViewType;

/** 标签类型 */
@property (nonatomic, assign) JGJMemberImpressTagViewType tagViewType;

/** 标签模型 */
@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, weak) id <JGJMemberImpressTagViewDelegate> delegate;

/** 添加单个标签 */
@property (nonatomic, strong) JGJMemberImpressTagViewModel *tagModel;

/** 选中的标签个数 */
@property (nonatomic, strong) NSMutableArray *selTagModels;

/** 获取最后一个按钮的位置 */
@property (nonatomic, strong, readonly) JGJCusButton *lastButton;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, strong) UIColor *selTextColor;

@property (nonatomic, strong) UIColor *selBackColor;

@property (nonatomic, strong) UIColor *layerColor;

@property (nonatomic, strong) UIColor *selLayerColor;

//复位标签状态

- (void)resetTagView;
@end
