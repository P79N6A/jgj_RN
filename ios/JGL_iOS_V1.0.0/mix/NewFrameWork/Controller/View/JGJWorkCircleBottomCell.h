//
//  JGJWorkCircleBottomCell.h
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWorkCircleHeaderView.h"

#import "YZGWorkDayModel.h"

#import "JGJWorkCircleTodayAccountCell.h"

#import "JGJWorkCircleProTypeTableViewCell.h"

#import "JGJHomeAccountNoteCell.h"

#import "JGJCheckAccountModulesCell.h"

#define WorkCircleFirstCellHeight 143.0

#define JGJHomeProOffsetHeight 20 //偏移底部的高度

#define JGJHomeProHeaderHeight 130

#define JGJHomeProHeight JGJHomeProOffsetHeight + SelItemHeight * (ProListDescs.count / 4 + 1) + JGJHomeProHeaderHeight + WorkCircleFirstCellHeight //有项目高度

#define JGJHomeGroupHeight JGJHomeProOffsetHeight + SelItemHeight * (GroupListDescs.count / 4 + 1) + JGJHomeProHeaderHeight + WorkCircleFirstCellHeight //有项目高度

#define JGJHomeAgencyGroupHeight JGJHomeProOffsetHeight + SelItemHeight * (AgencyGroupListDescs.count / 4 + 1) + JGJHomeProHeaderHeight + WorkCircleFirstCellHeight //代理班组长项目高度

#define JGJHomeCreaterSetGroupHeight JGJHomeProOffsetHeight + SelItemHeight * (AgencyGroupListDescs.count / 4) + JGJHomeProHeaderHeight + WorkCircleFirstCellHeight //创建者设置代理班组长项目高度

#define JGJHomeUnProHeight 100  //没有项目高度

@class JGJWorkCircleBottomCell;
typedef enum : NSUInteger {
    ProGroupCellStickButtonType //置顶按钮
} ProGroupCellButtonType;
@protocol JGJWorkCircleBottomCellDelegate <NSObject>

@optional

- (void)handleJGJJGJWorkCircleBottomCellDidSelected:(JGJMyWorkCircleProListModel *)worlCircleModel;

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedWorlCircleModel:(JGJMyWorkCircleProListModel *)worlCircleModel;

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedListType:(JGJWorkCircleMiddleInfoModel *)proTypeModel;

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell infoModel:(JGJWorkCircleMiddleInfoModel *)infoModel;

////记账按钮
//- (void)handleJGJWorkCircleTodayAccountCellButtonPressed:(TodayAccountCellButtonType)buttonType;

//切换项目按钮按下
- (void)handleButtonPressedWithButtonType:(ProTypeHeaderButtonType)buttonType;

//记账和笔记本切换
- (void)handleHomeAccountNoteCell:(JGJWorkCircleBottomCell *)cell buttonType:(JGJHomeAccountNoteCellButtonType)buttonType;

- (void)bottomCellWithModulesView:(JGJCheckAccountModulesView *)modulesView buttontype:(JGJCheckAccountModulesButtontype)buttonType;

//数据加载状态

- (void)loadStatus:(NSInteger)status;

@end
typedef void(^WorkCircleHeaderFooterViewBlock)(WorkCircleHeaderFooterViewButtonType);
@interface JGJWorkCircleBottomCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UITableView *workCircleTableView;
@property (nonatomic, copy) WorkCircleHeaderFooterViewBlock workCircleHeaderFooterViewBlock;
@property (nonatomic, strong) JGJActiveGroupModel *activeGroupModel;//未关闭班组模型
@property (nonatomic, weak) id <JGJWorkCircleBottomCellDelegate> delegate;
@property (strong, nonatomic) JGJMyWorkCircleProListModel *defaultProListModel; //设置默认数据
@property (assign, nonatomic) ProGroupCellButtonType buttonType;

@property (strong, nonatomic) JGJMyWorkCircleProListModel *proListModel;//当前选中的项目

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (strong, nonatomic) JGJHomeWorkRecordTotalModel *recordTotalModel;

//没有班组项目高度
+(CGFloat)defaultCellHeight;

@end
