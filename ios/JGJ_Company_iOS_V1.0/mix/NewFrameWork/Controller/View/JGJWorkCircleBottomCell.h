//
//  JGJWorkCircleBottomCell.h
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWorkCircleHeaderView.h"

#import "JGJWorkCircleProTypeTableViewCell.h"

#define JGJHomeProOffsetHeight 20 //偏移底部的高度

#define JGJHomeProHeaderHeight 130

#define JGJHomeProHeight JGJHomeProOffsetHeight + SelItemHeight * (ProListDescs.count / 4 + 1) + JGJHomeProHeaderHeight //有项目高度


@class JGJWorkCircleBottomCell;
typedef enum : NSUInteger {
    ProGroupCellStickButtonType //置顶按钮
} ProGroupCellButtonType;
@class JGJWorkCircleBottomCell;
@protocol JGJWorkCircleBottomCellDelegate <NSObject>

@optional
- (void)handleJGJJGJWorkCircleBottomCellDidSelected:(JGJMyWorkCircleProListModel *)worlCircleModel;
- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedWorlCircleModel:(JGJMyWorkCircleProListModel *)worlCircleModel;

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell didSelectedListType:(JGJWorkCircleMiddleInfoModel *)proTypeModel;

- (void)handleJGJWorkCircleBottomCell:(JGJWorkCircleBottomCell *)cell infoModel:(JGJWorkCircleMiddleInfoModel *)infoModel;

- (void)handleButtonPressedWithButtonType:(ProTypeHeaderButtonType)buttonType;

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

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewH;

@end
