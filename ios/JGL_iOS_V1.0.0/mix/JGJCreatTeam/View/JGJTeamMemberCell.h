//
//  JGJTeamMemberCell.h
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MemberRowNum (TYIS_IPHONE_5_OR_LESS ? 4 : 5)

#define ItemWidth 70

#define ItemHeight (ItemWidth + 20)

#define LinePadding  (TYIS_IPHONE_5_OR_LESS ? 5 : (TYIS_IPHONE_6 ? 10 : 18))

#define HeaderHegiht 40
#define LineMargin 10  //行间距
#define ItemSpacing (TYIS_IPHONE_5_OR_LESS ? 6 : 16)

#define CheckPlanHeaderHegiht 20 //检查计划使用

@class JGJTeamMemberCell;
@protocol JGJTeamMemberCellDelegate <NSObject>
@optional
//添加成员
- (void)handleJGJTeamMemberCellAddTeamMember:(JGJTeamMemberCell *)teamMemberCell;
//移除多个成员
- (void)handleJGJTeamMemberCellRemoveTeamMember:(NSMutableArray *)teamMemberModels;

//项目组使用和上面的区别是包含类型之前没考虑 到这个问题
- (void)handleJGJTeamMemberCellAddMember:(JGJTeamMemberCommonModel *)commonModel;
- (void)handleJGJTeamMemberCellRemoveMember:(JGJTeamMemberCommonModel *)commonModel;
//移除单个成员
- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel;
//点击不是我们平台用户弹框处理
- (void)handleJGJTeamMemberCellUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel;

//升级按钮按下
- (void)handleUpgradeActionWithCell:(JGJTeamMemberCell *)teamMemberCell;
@end
@interface JGJTeamMemberCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSMutableArray *teamMemberModels;
@property (nonatomic, assign) MemberFlagType memberFlagType;
@property (nonatomic, weak) id <JGJTeamMemberCellDelegate> delegate;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;//设置头部标题，是否显示删除按钮
//2.3.0添加顶部升级人数使用
@property (nonatomic, strong) JGJTeamInfoModel *teamInfo;

//隐藏头部
@property (nonatomic, assign) BOOL isCheckPlanHeader;

//计算高度
+ (CGFloat)calculateCollectiveViewHeight:(NSArray *)dataSource headerHeight:(CGFloat)headerHeight;

//删除或者添加按钮添加
+ (NSMutableArray *)accordTypeGetMangerModels:(MemberFlagType)flagType;
@end
