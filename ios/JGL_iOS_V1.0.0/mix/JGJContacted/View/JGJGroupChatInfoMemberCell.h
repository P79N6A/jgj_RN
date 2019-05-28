//
//  JGJGroupChatInfoMemberCell.h
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

#define MemberRowNum (TYIS_IPHONE_5_OR_LESS ? 4 : 5)

#define ItemWidth 70

#define ItemHeight (ItemWidth + 8)

#define LinePadding  (TYIS_IPHONE_5_OR_LESS ? 5 : (TYIS_IPHONE_6 ? 10 : 18))

#define LineMargin 10  //行间距

#define ItemSpacing (TYIS_IPHONE_5_OR_LESS ? 6 : 16)
@class JGJGroupChatInfoMemberCell;
@protocol JGJGroupChatInfoMemberCellDelegate <NSObject>
@optional
//项目组使用
- (void)handleJGJGroupChatInfoMemberCell:(JGJGroupChatInfoMemberCell *)cell commonModel:(JGJTeamMemberCommonModel *)commonModel memberModel:(JGJSynBillingModel *)memberModel;
@end
@interface JGJGroupChatInfoMemberCell : UITableViewCell
@property (nonatomic, weak) id <JGJGroupChatInfoMemberCellDelegate> delegate;
@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;//设置头部标题，是否显示删除按钮
@property (nonatomic, strong) NSMutableArray *memberModels;
@property (nonatomic, assign) MemberFlagType memberFlagType;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
