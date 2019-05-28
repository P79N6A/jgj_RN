//
//  JGJTeamMemberCollectionViewCell.h
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJTeamMemberCollectionViewCell;
@protocol JGJTeamMemberCollectionViewCellDelegate <NSObject>
@optional
//添加多个成员
- (void)handleJGJTeamMemberCollectionViewCellAddTeamMember:(JGJSynBillingModel *)teamMemberModel;
//移除多个成员
- (void)handleJGJTeamMemberCollectionViewCellRemoveTeamMember:(NSArray *)teamMemberModels;
//项目组使用
- (void)handleJGJTeamMemberCollectionViewCellRemoveMember:(JGJTeamMemberCommonModel *)commonModel;
- (void)handleJGJTeamMemberCollectionViewCellAddMember:(JGJTeamMemberCommonModel *)commonModel;
//移除单个成员
- (void)handleJGJRemoveIndividualTeamModel:(JGJSynBillingModel *)teamMemberModel;
//点击不是我们平台用户弹框处理
- (void)handleJGJUnRegisterTeamModel:(JGJTeamMemberCommonModel *)teamMemberModel;
@end

@interface JGJTeamMemberCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JGJSynBillingModel *teamMemberModel;
@property (nonatomic, assign) MemberFlagType memberFlagType;
@property (nonatomic, weak) id <JGJTeamMemberCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;//设置头部标题，是否显示删除按钮

//查看圈成员改变颜色
@property (nonatomic, copy) NSString *searchValue;

@property (weak, nonatomic) IBOutlet UIButton *headButton; //有头像显示头像，无头像显示最后一个名

@property (weak, nonatomic) IBOutlet UIButton *delMemberModelButton;
@end
