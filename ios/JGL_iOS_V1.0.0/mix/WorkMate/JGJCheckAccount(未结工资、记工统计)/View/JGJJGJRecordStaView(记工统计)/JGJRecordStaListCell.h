//
//  JGJRecordStaListCell.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

//尾部最小距离，金额到尾部

#define MaxTrail 20

@interface JGJRecordStaListCell : UITableViewCell

@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

//是否显示工否则显示小时
@property (nonatomic, assign) BOOL isShowWork;

//显示类型
@property (nonatomic, assign) NSInteger showType;

//是否显示姓名统计详情页
@property (nonatomic ,assign) BOOL isHiddenName;

//尾部的最大距离
@property (nonatomic, assign) CGFloat maxTrail;

//根据类型显示名字或者日期
@property (nonatomic, copy) NSString *des;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@property (nonatomic, assign) BOOL isScreenShowLine;

//搜索的记工类型。如果只搜索1个和多个的样式不一样
@property (nonatomic, copy) NSString *accounts_type;

#pragma mark - 比较宽度，显示的时候最大宽度为准
+ (CGFloat)maxWidthWithStaList:(NSArray *)staList;

+ (CGFloat)cellHeight;

@end
